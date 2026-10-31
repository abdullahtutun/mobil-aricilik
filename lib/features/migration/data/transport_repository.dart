import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/migration/data/migration_repository.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';

/// Taşımalar; durum kaydı, son yazan kazanır. Taşınan kovanları [items].
/// Kovanlar yüklemede araca okutulur, indirmede yeniden okutulur; indirme
/// bitince indirilen kovanların arılığı, konum geçmişi ve göç durağı aynı
/// transaction'da güncellenir. Hepsi yerel DB'de; yol boyunca ağ gerekmez.
class TransportRepository extends BaseRepository<$TransportsTable, Transport> {
  new(super.db, {super.clock});

  @override
  $TransportsTable get table => db.transports;

  @override
  Insertable<Transport> toInsertable(Transport record) => record.toInsertable();

  /// Taşınan kovanlar; aynı veritabanı ve saat.
  late final items = TransportItemRepository(db, clock: clock);

  late final _hives = HiveRepository(db, clock: clock);

  late final _stops = MigrationStopRepository(db, clock: clock);

  /// Göç durağına giden en son taşıma; yoksa null.
  Stream<Transport?> watchLatestForStop(String migrationStopId) =>
      (selectWhere((t) => t.migrationStopId.equals(migrationStopId))
            ..orderBy([
              (t) => OrderingTerm.desc(t.createdAt),
              (t) => OrderingTerm.desc(t.id),
            ])
            ..limit(1))
          .watchSingleOrNull();

  /// Yeni taşıma; yükleme adımında başlar. Araç yoksa, adı boş ya da çok
  /// uzunsa, aynı ad iki kez verildiyse ya da kaynak ve hedef aynıysa
  /// [ArgumentError] atar ve bir şey yazmaz.
  Future<Transport> start({
    required String orgId,
    required String sourceApiaryId,
    required String destinationApiaryId,
    required List<String> vehicles,
    String? migrationStopId,
  }) {
    if (sourceApiaryId == destinationApiaryId) {
      throw ArgumentError.value(destinationApiaryId, 'destinationApiaryId');
    }
    final names = [for (final vehicle in vehicles) _checkedVehicle(vehicle)];
    if (names.isEmpty || names.toSet().length != names.length) {
      throw ArgumentError.value(vehicles, 'vehicles');
    }
    final at = now();
    return insertRecord(
      Transport(
        id: generateId(),
        orgId: orgId,
        migrationStopId: migrationStopId,
        sourceApiaryId: sourceApiaryId,
        destinationApiaryId: destinationApiaryId,
        vehicles: names,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  /// Taşımaya araç ekler. Ad boşsa, çok uzunsa ya da taşımada varsa
  /// [ArgumentError]; taşıma yoksa [StateError].
  Future<Transport> addVehicle(String transportId, String name) =>
      db.transaction(() async {
        final transport = await requireById(transportId);
        final vehicle = _checkedVehicle(name);
        if (transport.vehicles.contains(vehicle)) {
          throw ArgumentError.value(name, 'name');
        }
        return await updateRecord(
          transport.copyWith(vehicles: [...transport.vehicles, vehicle]),
        );
      });

  /// Kovanı [vehicle] aracına yükler. Kovan bu taşımada varsa bir şey
  /// yazmaz. Taşıma yükleme adımında değilse, araç taşımada yoksa ya da
  /// kovan yoksa [StateError].
  Future<LoadResult> load(
    String transportId, {
    required String hiveId,
    required String vehicle,
  }) => db.transaction(() async {
    final transport = await _requireStatus(
      transportId,
      TransportStatus.loading,
    );
    if (!transport.vehicles.contains(vehicle)) {
      throw StateError('Araç taşımada yok: $vehicle');
    }
    final hive =
        await _hives.findById(hiveId) ??
        (throw StateError('hives/$hiveId yok ya da silinmiş'));
    if (await items.findByHive(transportId, hiveId) != null) {
      return LoadResult.alreadyLoaded;
    }
    final at = now();
    await items.add(
      TransportItem(
        id: generateId(),
        orgId: transport.orgId,
        transportId: transportId,
        hiveId: hiveId,
        vehicle: vehicle,
        loadedAt: at,
        createdAt: at,
        updatedAt: at,
      ),
    );
    return hive.apiaryId == transport.sourceApiaryId
        ? LoadResult.loaded
        : LoadResult.loadedFromOtherApiary;
  });

  /// Yüklemeyi bitirir; taşıma indirme adımına geçer. Taşıma yükleme
  /// adımında değilse [StateError].
  Future<Transport> startUnloading(String transportId) =>
      db.transaction(() async {
        final transport = await _requireStatus(
          transportId,
          TransportStatus.loading,
        );
        return await updateRecord(
          transport.copyWith(status: TransportStatus.unloading),
        );
      });

  /// Hedefte okutulan kovanı indirir. Yüklenmemiş ya da zaten indirilmiş
  /// kovanda bir şey yazmaz. Taşıma indirme adımında değilse [StateError].
  Future<UnloadResult> unload(String transportId, {required String hiveId}) =>
      db.transaction(() async {
        await _requireStatus(transportId, TransportStatus.unloading);
        final item = await items.findByHive(transportId, hiveId);
        if (item == null) return UnloadResult.notLoaded;
        if (item.unloadedAt != null) return UnloadResult.alreadyUnloaded;
        await items.update(item.copyWith(unloadedAt: now()));
        return UnloadResult.unloaded;
      });

  /// İndirmeyi bitirir: indirilen her kovan hedef arılığa taşınır ve konum
  /// geçmişine indirildiği anla yazılır; taşıma biter. İndirilmeyen kovanlar
  /// yerinde kalır. Taşımanın göç durağı "şu an" olur (plandaki önceki
  /// "şu an" durak geçmiş) ve kovan sayısı indirilen kovan sayısı olur.
  /// Hepsi tek transaction'da. Taşınan kovan sayısını döner. Taşıma indirme
  /// adımında değilse [StateError].
  Future<int> complete(String transportId) => db.transaction(() async {
    final transport = await _requireStatus(
      transportId,
      TransportStatus.unloading,
    );
    var moved = 0;
    var unloaded = 0;
    for (final item in await items.findByTransport(transportId)) {
      final unloadedAt = item.unloadedAt;
      if (unloadedAt == null) continue;
      unloaded++;
      // Kovan bu arada silindiyse taşınacak bir şey yok.
      if (await _hives.findById(item.hiveId) == null) continue;
      final move = await _hives.move(
        item.hiveId,
        apiaryId: transport.destinationApiaryId,
        movedAt: unloadedAt,
      );
      if (move != null) moved++;
    }
    // Durak bu arada silindiyse güncellenecek bir şey yok.
    if (transport.migrationStopId case final stopId?) {
      if (await _stops.findById(stopId) case final stop?) {
        await _stops.update(stop, (
          position: stop.position,
          name: stop.name,
          place: stop.place,
          plannedStartOn: stop.plannedStartOn,
          plannedEndOn: stop.plannedEndOn,
          apiaryId: stop.apiaryId,
          hiveCount: unloaded,
          status: MigrationStopStatus.current,
        ));
      }
    }
    await updateRecord(
      transport.copyWith(status: TransportStatus.completed, completedAt: now()),
    );
    return moved;
  });

  Future<Transport> _requireStatus(
    String transportId,
    TransportStatus status,
  ) async {
    final transport = await requireById(transportId);
    if (transport.status != status) {
      throw StateError('Taşıma ${status.value} adımında değil');
    }
    return transport;
  }

  /// Sunucunun kısıtı: ad dolu ve [maxVehicleNameLength]'i geçmez.
  static String _checkedVehicle(String name) {
    final trimmed = name.trim();
    if (trimmed.isEmpty || trimmed.length > maxVehicleNameLength) {
      throw ArgumentError.value(name, 'name');
    }
    return trimmed;
  }
}

/// Taşımadaki kovanlar; durum kaydı, son yazan kazanır. Bir kovanın bir
/// taşımada tek satırı olur ([TransportRepository.load] denetler).
class TransportItemRepository
    extends BaseRepository<$TransportItemsTable, TransportItem> {
  new(super.db, {super.clock});

  @override
  $TransportItemsTable get table => db.transportItems;

  @override
  Insertable<TransportItem> toInsertable(TransportItem record) =>
      record.toInsertable();

  /// Taşımanın kovanları, yüklenme sırasıyla.
  Stream<List<TransportItem>> watchByTransport(String transportId) =>
      watchWhere(
        (t) => t.transportId.equals(transportId),
        orderBy: [
          (t) => OrderingTerm.asc(t.loadedAt),
          (t) => OrderingTerm.asc(t.id),
        ],
      );

  /// Taşımanın silinmemiş kovanları.
  Future<List<TransportItem>> findByTransport(String transportId) =>
      selectWhere((t) => t.transportId.equals(transportId)).get();

  /// Kovanın taşımadaki satırı; yoksa null. Başka telefonla aynı kovan iki
  /// kez yüklendiyse ilk yükleneni.
  Future<TransportItem?> findByHive(String transportId, String hiveId) {
    final query =
        selectWhere(
            (t) => t.transportId.equals(transportId) & t.hiveId.equals(hiveId),
          )
          ..orderBy([(t) => OrderingTerm.asc(t.loadedAt)])
          ..limit(1);
    return query.getSingleOrNull();
  }

  Future<TransportItem> add(TransportItem item) => insertRecord(item);

  Future<TransportItem> update(TransportItem item) => updateRecord(item);
}

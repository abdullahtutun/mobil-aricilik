import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';

/// Bir taşıma: kovanın yeni hâli, geldiği arılık ve yazılan geçmiş kaydı.
/// Geri almak için [HiveRepository.undoMove]'a verilir.
typedef HiveMove = ({Hive hive, String fromApiaryId, HiveLocationEntry entry});

/// Kovanlar; durum kaydı, son yazan kazanır. Oluşturma ve taşıma arılık
/// geçmişini ([HiveLocationRepository]) aynı transaction'da yazar.
class HiveRepository extends BaseRepository<$HivesTable, Hive> {
  new(super.db, {super.clock});

  late final _locations = HiveLocationRepository(db, clock: clock);

  @override
  $HivesTable get table => db.hives;

  @override
  Insertable<Hive> toInsertable(Hive record) => record.toInsertable();

  /// İşletmenin kovanları, numaraya göre (metin sırası).
  Stream<List<Hive>> watchAll(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.number)],
  );

  /// Arılıktaki kovanlar, numaraya göre (metin sırası).
  Stream<List<Hive>> watchByApiary(String apiaryId) => watchWhere(
    (t) => t.apiaryId.equals(apiaryId),
    orderBy: [(t) => OrderingTerm.asc(t.number)],
  );

  /// Kovanı oluşturur ve [apiaryId] arılığına geldiğini geçmişe yazar;
  /// ikisi tek transaction'da.
  Future<Hive> create({
    required String orgId,
    required String number,
    required HiveType type,
    required String apiaryId,
    HiveStatus status = HiveStatus.active,
    String? tagCode,
    String? queenId,
    int boxCount = 1,
    int? frameCount,
    HiveSource? source,
    String? marking,
  }) => db.transaction(() async {
    final at = now();
    final hive = await insertRecord(
      Hive(
        id: generateId(),
        orgId: orgId,
        number: number,
        type: type,
        apiaryId: apiaryId,
        status: status,
        tagCode: tagCode,
        queenId: queenId,
        boxCount: boxCount,
        frameCount: frameCount,
        source: source,
        marking: marking,
        createdAt: at,
        updatedAt: at,
      ),
    );
    await _locations.add(
      orgId: orgId,
      hiveId: hive.id,
      apiaryId: apiaryId,
      movedAt: at,
    );
    return hive;
  });

  /// [numbers] sırasıyla aynı tip ve kaynakta aktif kovanlar; hepsi ya da
  /// hiçbiri yazılır.
  Future<List<Hive>> createMany({
    required String orgId,
    required String apiaryId,
    required List<String> numbers,
    required HiveType type,
    HiveSource? source,
  }) => db.transaction(
    () async => [
      for (final number in numbers)
        await create(
          orgId: orgId,
          number: number,
          type: type,
          apiaryId: apiaryId,
          source: source,
        ),
    ],
  );

  /// Kovanın alanlarını yazar.
  Future<Hive> update(Hive hive) => updateRecord(hive);

  /// Durumu kovanın en son hâlinin üzerine yazar. Kovan yoksa ya da
  /// silinmişse [StateError].
  Future<Hive> setStatus(String hiveId, HiveStatus status) =>
      db.transaction(() async {
        final hive = await _requireLive(hiveId);
        return await updateRecord(hive.copyWith(status: status));
      });

  /// Kovanı [apiaryId] arılığına taşır ve geçmişe yazar; tek transaction.
  /// Kovan zaten oradaysa bir şey yazmaz, null döner. Kovan yoksa ya da
  /// silinmişse [StateError].
  Future<HiveMove?> move(String hiveId, {required String apiaryId}) =>
      db.transaction(() async {
        final hive = await _requireLive(hiveId);
        if (hive.apiaryId == apiaryId) return null;
        final moved = await updateRecord(hive.copyWith(apiaryId: apiaryId));
        final entry = await _locations.add(
          orgId: hive.orgId,
          hiveId: hiveId,
          apiaryId: apiaryId,
          movedAt: moved.updatedAt,
        );
        return (hive: moved, fromApiaryId: hive.apiaryId, entry: entry);
      });

  /// Taşımayı geri alır: kovan geldiği arılığa döner, taşımanın geçmiş
  /// kaydı yumuşak silinir; tek transaction. Kovan bu arada başka yere
  /// taşındıysa ya da silindiyse bir şey yazmaz ve false döner.
  Future<bool> undoMove(HiveMove move) => db.transaction(() async {
    final hive = await findById(move.hive.id);
    if (hive == null || hive.apiaryId != move.hive.apiaryId) return false;
    await updateRecord(hive.copyWith(apiaryId: move.fromApiaryId));
    await _locations.delete(move.entry.id);
    return true;
  });

  Future<Hive> _requireLive(String hiveId) async =>
      await findById(hiveId) ??
      (throw StateError('hives/$hiveId yok ya da silinmiş'));
}

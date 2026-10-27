import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';

/// Göç planları; durum kaydı, son yazan kazanır. Durakları [stops].
class MigrationRepository extends BaseRepository<$MigrationsTable, Migration> {
  new(super.db, {super.clock});

  @override
  $MigrationsTable get table => db.migrations;

  @override
  Insertable<Migration> toInsertable(Migration record) => record.toInsertable();

  /// Planların durakları; aynı veritabanı ve saat.
  late final stops = MigrationStopRepository(db, clock: clock);

  /// İşletmenin planları, yeni yıl önce; aynı yılda ada göre.
  Stream<List<Migration>> watchByOrg(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [
      (t) => OrderingTerm.desc(t.year),
      (t) => OrderingTerm.asc(t.name),
      (t) => OrderingTerm.asc(t.id),
    ],
  );

  /// Yeni plan. Ad boşsa, çok uzunsa ya da yıl aralık dışındaysa
  /// [ArgumentError] atar ve bir şey yazmaz.
  Future<Migration> create({
    required String orgId,
    required int year,
    required String name,
  }) async {
    final at = now();
    return await insertRecord(
      _checked(
        Migration(
          id: generateId(),
          orgId: orgId,
          year: year,
          name: name.trim(),
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
  }

  /// Planın yılını ve adını yazar (son yazan kazanır).
  Future<Migration> update(Migration migration) =>
      updateRecord(_checked(migration.copyWith(name: migration.name.trim())));

  /// Planı ve duraklarını tek transaction'da yumuşak siler.
  Future<void> remove(String id) => db.transaction(() async {
    for (final stop in await stops.findByMigration(id)) {
      await stops.delete(stop.id);
    }
    await delete(id);
  });

  /// [apiaryIds] arılıklarındaki silinmemiş hasatlar, hasada alınan
  /// (silinmemiş) kovan sayısıyla; durakların geçmiş yıl verimi. Hasat ya
  /// da hasat kovanı değişince yeniden yayar.
  Stream<List<ApiaryHarvestEntry>> watchApiaryHarvests(Set<String> apiaryIds) {
    if (apiaryIds.isEmpty) return Stream.value(const []);
    final harvests = db.harvests;
    final hives = db.harvestHives;
    final hiveCount = hives.id.count();
    final query =
        db.select(harvests).join([
            innerJoin(
              hives,
              hives.harvestId.equalsExp(harvests.id) & hives.deletedAt.isNull(),
              useColumns: false,
            ),
          ])
          ..addColumns([hiveCount])
          ..where(
            harvests.deletedAt.isNull() & harvests.apiaryId.isIn(apiaryIds),
          )
          ..groupBy([harvests.id]);
    ApiaryHarvestEntry entry(TypedResult row) {
      final harvest = row.readTable(harvests);
      return (
        apiaryId: harvest.apiaryId,
        harvestedAt: harvest.harvestedAt,
        netKg: harvest.netKg,
        hiveCount: row.read(hiveCount) ?? 0,
      );
    }

    return query.watch().map((rows) => rows.map(entry).toList());
  }

  /// Sunucunun kısıtları: ad dolu ve [maxMigrationNameLength]'i geçmez,
  /// yıl [minMigrationYear]–[maxMigrationYear].
  static Migration _checked(Migration migration) {
    final name = migration.name;
    if (name.isEmpty || name.length > maxMigrationNameLength) {
      throw ArgumentError.value(name, 'name');
    }
    if (migration.year < minMigrationYear ||
        migration.year > maxMigrationYear) {
      throw ArgumentError.value(migration.year, 'year');
    }
    return migration;
  }
}

/// Göç planının durakları; durum kaydı, son yazan kazanır. Planda en çok
/// bir durak "şu an": bir durak şu an yapılınca öncekinin durumu aynı
/// transaction'da geçmiş olur.
class MigrationStopRepository
    extends BaseRepository<$MigrationStopsTable, MigrationStop> {
  new(super.db, {super.clock});

  @override
  $MigrationStopsTable get table => db.migrationStops;

  @override
  Insertable<MigrationStop> toInsertable(MigrationStop record) =>
      record.toInsertable();

  /// Planın durakları rota sırasıyla ([sortStops]).
  Stream<List<MigrationStop>> watchByMigration(String migrationId) =>
      watchWhere((t) => t.migrationId.equals(migrationId)).map(sortStops);

  /// Planın silinmemiş durakları.
  Future<List<MigrationStop>> findByMigration(String migrationId) =>
      selectWhere((t) => t.migrationId.equals(migrationId)).get();

  /// Plana yeni durağın sırası: en büyük sıradan bir sonraki, boş planda 1.
  Future<int> nextPosition(String migrationId) async {
    final max = table.position.max();
    final query = db.selectOnly(table)
      ..addColumns([max])
      ..where(table.migrationId.equals(migrationId) & table.deletedAt.isNull());
    final current = (await query.getSingle()).read(max) ?? 0;
    return current >= maxStopPosition ? maxStopPosition : current + 1;
  }

  /// [migrationId] planına durak ekler. Değerler sunucunun kısıtlarına
  /// uymazsa [ArgumentError] atar ve bir şey yazmaz.
  Future<MigrationStop> create({
    required String orgId,
    required String migrationId,
    required MigrationStopPlan plan,
  }) => db.transaction(() async {
    final at = now();
    final stop = _checked(
      MigrationStop(
        id: generateId(),
        orgId: orgId,
        migrationId: migrationId,
        position: plan.position,
        name: plan.name,
        place: plan.place,
        plannedStartOn: plan.plannedStartOn,
        plannedEndOn: plan.plannedEndOn,
        apiaryId: plan.apiaryId,
        hiveCount: plan.hiveCount,
        status: plan.status,
        createdAt: at,
        updatedAt: at,
      ),
    );
    await _demoteOtherCurrent(stop);
    return await insertRecord(stop);
  });

  /// Durağın alanlarını [plan]'dan yazar (son yazan kazanır). Durak yoksa
  /// ya da silinmişse [StateError]; değerler geçersizse [ArgumentError].
  Future<MigrationStop> update(MigrationStop stop, MigrationStopPlan plan) =>
      db.transaction(() async {
        final updated = _checked(
          stop.copyWith(
            position: plan.position,
            name: plan.name,
            place: plan.place,
            plannedStartOn: plan.plannedStartOn,
            plannedEndOn: plan.plannedEndOn,
            apiaryId: plan.apiaryId,
            hiveCount: plan.hiveCount,
            status: plan.status,
          ),
        );
        await _demoteOtherCurrent(updated);
        return await updateRecord(updated);
      });

  /// [stop] şu an ise plandaki diğer "şu an" durak geçmiş olur.
  Future<void> _demoteOtherCurrent(MigrationStop stop) async {
    if (stop.status != MigrationStopStatus.current) return;
    final others = await selectWhere(
      (t) =>
          t.migrationId.equals(stop.migrationId) &
          t.status.equalsValue(MigrationStopStatus.current) &
          t.id.equals(stop.id).not(),
    ).get();
    for (final other in others) {
      await updateRecord(other.copyWith(status: MigrationStopStatus.past));
    }
  }

  /// Sunucunun kısıtları; metinler kırpılır, boş yer null olur, günler
  /// saatsiz.
  static MigrationStop _checked(MigrationStop stop) {
    final name = stop.name.trim();
    final place = stop.place?.trim();
    final start = dateOnly(stop.plannedStartOn);
    final end = dateOnly(stop.plannedEndOn);
    if (name.isEmpty || name.length > maxMigrationNameLength) {
      throw ArgumentError.value(stop.name, 'name');
    }
    if (place != null && place.length > maxStopPlaceLength) {
      throw ArgumentError.value(stop.place, 'place');
    }
    if (stop.position < 1 || stop.position > maxStopPosition) {
      throw ArgumentError.value(stop.position, 'position');
    }
    if (stop.hiveCount case final count?
        when count < 0 || count > maxStopHiveCount) {
      throw ArgumentError.value(count, 'hiveCount');
    }
    if (end.isBefore(start)) {
      throw ArgumentError.value(stop.plannedEndOn, 'plannedEndOn');
    }
    return stop.copyWith(
      name: name,
      place: place == null || place.isEmpty ? null : place,
      plannedStartOn: start,
      plannedEndOn: end,
    );
  }
}

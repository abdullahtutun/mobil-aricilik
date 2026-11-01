import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/harvest/data/harvest_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';

/// Lottaki hasat ve arılığının adı (arılık silinmişse null).
typedef LotHarvestRow = ({Harvest harvest, String? apiaryName});

/// Lota bağlanan son ilaçlama, kovanın numarası ve ürünün adı.
typedef LotTreatmentRow = ({
  LotTreatment link,
  String? hiveNumber,
  String productName,
});

/// Hasat zaten bir lotta; bir şey yazılmadı.
class HarvestAlreadyInLotException implements Exception {
  const new(this.harvestId);

  final String harvestId;

  @override
  String toString() => 'HarvestAlreadyInLotException($harvestId)';
}

/// Lotlar; durum kaydı, son yazan kazanır. Kilogram ve stok saklanmaz:
/// okurken bağlı hasatlardan ve satışlardan hesaplanır ([LotSummary]).
///
/// Hasat lota eklenirken ([attachHarvest]) hasada alınan kovanların hasat
/// gününe kadarki son ilaçlamaları `lot_treatments`'a kopyalanır; hepsi tek
/// transaction'da. Bekleme süresi ihlali olan kopya lotu kırmızı uyarılı
/// yapar.
class LotRepository extends BaseRepository<$LotsTable, Lot> {
  new(super.db, {super.clock});

  @override
  $LotsTable get table => db.lots;

  @override
  Insertable<Lot> toInsertable(Lot record) => record.toInsertable();

  late final harvests = LotHarvestRepository(db, clock: clock);
  late final treatments = LotTreatmentRepository(db, clock: clock);
  late final labResults = LabResultRepository(db, clock: clock);
  late final sales = LotSaleRepository(db, clock: clock);
  late final _harvestHives = HarvestHiveRepository(db, clock: clock);
  late final _hiveTreatments = TreatmentRepository(db, clock: clock);

  /// İşletmenin lotları ve hesaplanan değerleri, yeni önce
  /// ([compareLots]); lot, hasat, satış, analiz ya da ilaçlama bağı
  /// değişince yeniden yayar.
  Stream<List<LotSummary>> watchSummaries(String orgId) =>
      _watchSummaries('l.org_id = ?', orgId);

  /// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.
  Stream<LotSummary?> watchSummary(String id) =>
      _watchSummaries('l.id = ?', id).map((rows) => rows.singleOrNull);

  Stream<List<LotSummary>> _watchSummaries(String filter, String value) {
    final sql =
        'select l.*, '
        '(select coalesce(sum(h.net_kg), 0) from lot_harvests lh '
        'join harvests h on h.id = lh.harvest_id and h.deleted_at is null '
        'where lh.lot_id = l.id and lh.deleted_at is null) as lot_kg, '
        '(select coalesce(sum(s.kg), 0) from lot_sales s '
        'where s.lot_id = l.id and s.deleted_at is null) as sold_kg, '
        '(select count(distinct hh.hive_id) from lot_harvests lh '
        'join harvests h on h.id = lh.harvest_id and h.deleted_at is null '
        'join harvest_hives hh on hh.harvest_id = lh.harvest_id '
        'and hh.deleted_at is null '
        'where lh.lot_id = l.id and lh.deleted_at is null) as hive_count, '
        'exists (select 1 from lab_results r '
        'where r.lot_id = l.id and r.deleted_at is null) as analyzed, '
        'exists (select 1 from lot_treatments t '
        'where t.lot_id = l.id and t.deleted_at is null '
        'and t.withdrawal_violation) as violation '
        'from lots l where l.deleted_at is null and $filter';
    return db
        .customSelect(
          sql,
          variables: [Variable.withString(value)],
          readsFrom: {
            db.lots,
            db.lotHarvests,
            db.harvests,
            db.harvestHives,
            db.lotSales,
            db.labResults,
            db.lotTreatments,
          },
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              (
                lot: db.lots.map(row.data),
                kg: _round(row.read<double>('lot_kg')),
                soldKg: _round(row.read<double>('sold_kg')),
                hiveCount: row.read<int>('hive_count'),
                analyzed: row.read<bool>('analyzed'),
                violation: row.read<bool>('violation'),
              ),
          ]..sort((a, b) => compareLots(a.lot, b.lot)),
        );
  }

  /// İşletmenin açık lotları, yeni önce; hasat eklenebilecek olanlar.
  Stream<List<Lot>> watchOpen(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId) & t.status.equalsValue(LotStatus.open),
    orderBy: [
      (t) => OrderingTerm.desc(t.year),
      (t) => OrderingTerm.desc(t.seq),
    ],
  );

  /// Hasadın lotu; lotta değilse null.
  Future<Lot?> findByHarvest(String harvestId) async {
    final link = await harvests.findByHarvest(harvestId);
    return link == null ? null : await findById(link.lotId);
  }

  /// [harvest] için yeni lot açar ve hasadı ona ekler; numara hasadın
  /// yılında sıradaki ([nextLotSeq]), bal türü hasadınki. Hepsi tek
  /// transaction'da. Yöre ya da nem geçersizse [ArgumentError], hasat zaten
  /// bir lottaysa [HarvestAlreadyInLotException] atar ve bir şey yazmaz.
  Future<Lot> createWithHarvest(
    Harvest harvest, {
    String? origin,
    double? moisture,
  }) => db.transaction(() async {
    final year = harvest.harvestedAt.toLocal().year;
    final seqs =
        await (db.selectOnly(table)
              ..addColumns([table.seq])
              ..where(
                table.orgId.equals(harvest.orgId) &
                    table.year.equals(year) &
                    table.deletedAt.isNull(),
              ))
            .map((row) => row.read(table.seq)!)
            .get();
    final at = now();
    final lot = await insertRecord(
      checkLot(
        Lot(
          id: generateId(),
          orgId: harvest.orgId,
          year: year,
          seq: nextLotSeq(seqs),
          honeyKind: harvest.honeyKind,
          origin: origin,
          moisture: moisture,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
    await attachHarvest(lot, harvest);
    return lot;
  });

  /// [harvest]'ı [lot]'a ekler ve hasada alınan kovanların son
  /// ilaçlamalarını ([lotTreatmentLinks]) lota bağlar; tek transaction'da.
  /// Lot kapalıysa [StateError], hasat zaten bir lottaysa
  /// [HarvestAlreadyInLotException] atar ve bir şey yazmaz.
  Future<LotHarvest> attachHarvest(Lot lot, Harvest harvest) =>
      db.transaction(() async {
        final current = await requireById(lot.id);
        if (current.status != LotStatus.open) {
          throw StateError('lots/${lot.id} kapalı');
        }
        if (await harvests.findByHarvest(harvest.id) != null) {
          throw HarvestAlreadyInLotException(harvest.id);
        }
        final link = await harvests.add(lot, harvest);
        final hiveIds = [
          for (final hive in await _harvestHives.findByHarvest(harvest.id))
            hive.hiveId,
        ];
        final links = lotTreatmentLinks(
          harvestedAt: harvest.harvestedAt,
          hiveIds: hiveIds,
          treatments: await _hiveTreatments.findByHives(hiveIds),
        );
        for (final treatment in links) {
          await treatments.add(lot, harvest, treatment);
        }
        return link;
      });

  /// Hasadı lotundan çıkarır: lot hasadı ve hasadın ilaçlama kopyaları
  /// silinir (hasadın Geri al'ı). Çağıranın transaction'ında çalışır.
  Future<void> detachHarvest(String harvestId) => db.transaction(() async {
    if (await harvests.findByHarvest(harvestId) case final link?) {
      await harvests.delete(link.id);
    }
    for (final treatment in await treatments.findByHarvest(harvestId)) {
      await treatments.delete(treatment.id);
    }
  });

  /// Lotun yöre, nem ve durumunu yazar (son yazan kazanır). Lot yoksa ya da
  /// silinmişse [StateError], alanlar geçersizse [ArgumentError] atar.
  Future<Lot> update(Lot lot) => updateRecord(checkLot(lot));

  /// Lotun yayımını ve sayfada görünen alanlarını yazar; verilmeyen alan
  /// değişmez. Lot DB'den yeniden okunur, eski bir kopya diğer alanları
  /// geri yazmasın. Lot yoksa ya da silinmişse [StateError] atar.
  Future<Lot> setPublication(
    String id, {
    bool? published,
    bool? publicProducer,
    bool? publicOrigin,
    bool? publicLab,
    bool? publicReport,
  }) => db.transaction(() async {
    final lot = await requireById(id);
    return await updateRecord(
      lot.copyWith(
        published: published ?? lot.published,
        publicProducer: publicProducer ?? lot.publicProducer,
        publicOrigin: publicOrigin ?? lot.publicOrigin,
        publicLab: publicLab ?? lot.publicLab,
        publicReport: publicReport ?? lot.publicReport,
      ),
    );
  });

  /// Lotu ve bağlı kayıtlarını (hasat bağları, ilaçlama kopyaları,
  /// analizler, satışlar) tek transaction'da siler. Hasatların kendisi
  /// kalır.
  Future<void> remove(String id) => db.transaction(() async {
    for (final link in await harvests.findByLot(id)) {
      await harvests.delete(link.id);
    }
    for (final treatment in await treatments.findByLot(id)) {
      await treatments.delete(treatment.id);
    }
    for (final result in await labResults.findByLot(id)) {
      await labResults.delete(result.id);
    }
    for (final sale in await sales.findByLot(id)) {
      await sales.delete(sale.id);
    }
    await delete(id);
  });

  /// Lotun hasatları, yeni önce, arılık adıyla.
  Stream<List<LotHarvestRow>> watchHarvests(String lotId) {
    final links = db.lotHarvests;
    final harvests = db.harvests;
    final apiaries = db.apiaries;
    final query =
        db.select(harvests).join([
            innerJoin(
              links,
              links.harvestId.equalsExp(harvests.id) & links.deletedAt.isNull(),
              useColumns: false,
            ),
            leftOuterJoin(
              apiaries,
              apiaries.id.equalsExp(harvests.apiaryId) &
                  apiaries.deletedAt.isNull(),
            ),
          ])
          ..where(links.lotId.equals(lotId) & harvests.deletedAt.isNull())
          ..orderBy([
            OrderingTerm.desc(harvests.harvestedAt),
            OrderingTerm.desc(harvests.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            harvest: row.readTable(harvests),
            apiaryName: row.readTableOrNull(apiaries)?.name,
          ),
      ],
    );
  }

  /// Lota bağlı son ilaçlamalar: ihlaller önce, sonra yeni uygulama önce;
  /// kovan numarası ve ürün adıyla.
  Stream<List<LotTreatmentRow>> watchTreatments(String lotId) {
    final links = db.lotTreatments;
    final hives = db.hives;
    final treatments = db.treatments;
    final query =
        db.select(links).join([
            leftOuterJoin(hives, hives.id.equalsExp(links.hiveId)),
            innerJoin(treatments, treatments.id.equalsExp(links.treatmentId)),
          ])
          ..where(links.lotId.equals(lotId) & links.deletedAt.isNull())
          ..orderBy([
            OrderingTerm.desc(links.withdrawalViolation),
            OrderingTerm.desc(links.treatedAt),
            OrderingTerm.asc(links.id),
          ]);
    return query.watch().map(
      (rows) => [
        for (final row in rows)
          (
            link: row.readTable(links),
            hiveNumber: row.readTableOrNull(hives)?.number,
            productName: row.readTable(treatments).productName,
          ),
      ],
    );
  }
}

/// Lota eklenen hasatlar; olay kaydı. Yalnız [LotRepository] yazar.
class LotHarvestRepository
    extends BaseRepository<$LotHarvestsTable, LotHarvest> {
  new(super.db, {super.clock});

  @override
  $LotHarvestsTable get table => db.lotHarvests;

  @override
  Insertable<LotHarvest> toInsertable(LotHarvest record) =>
      record.toInsertable();

  Future<LotHarvest?> findByHarvest(String harvestId) => (selectWhere(
    (t) => t.harvestId.equals(harvestId),
  )..limit(1)).getSingleOrNull();

  Future<List<LotHarvest>> findByLot(String lotId) =>
      selectWhere((t) => t.lotId.equals(lotId)).get();

  Future<LotHarvest> add(Lot lot, Harvest harvest) {
    final at = now();
    return insertRecord(
      LotHarvest(
        id: generateId(),
        orgId: lot.orgId,
        lotId: lot.id,
        harvestId: harvest.id,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

/// Lota bağlanan son ilaçlama kopyaları; olay kaydı. Yalnız
/// [LotRepository] yazar.
class LotTreatmentRepository
    extends BaseRepository<$LotTreatmentsTable, LotTreatment> {
  new(super.db, {super.clock});

  @override
  $LotTreatmentsTable get table => db.lotTreatments;

  @override
  Insertable<LotTreatment> toInsertable(LotTreatment record) =>
      record.toInsertable();

  Future<List<LotTreatment>> findByLot(String lotId) =>
      selectWhere((t) => t.lotId.equals(lotId)).get();

  Future<List<LotTreatment>> findByHarvest(String harvestId) =>
      selectWhere((t) => t.harvestId.equals(harvestId)).get();

  Future<LotTreatment> add(Lot lot, Harvest harvest, LotTreatmentLink link) {
    final at = now();
    return insertRecord(
      LotTreatment(
        id: generateId(),
        orgId: lot.orgId,
        lotId: lot.id,
        harvestId: harvest.id,
        hiveId: link.hiveId,
        treatmentId: link.treatment.id,
        treatedAt: link.treatment.startedAt.toUtc(),
        withdrawalEndsOn: link.withdrawalEndsOn,
        withdrawalViolation: link.violation,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

/// Analizin yazılacak değerleri; en az biri dolu.
typedef LabResultValues = ({
  DateTime testedOn,
  double? hmf,
  double? diastase,
  double? proline,
  double? moisture,
  ResidueResult? residue,
  String? documentId,
});

/// Lotların analizleri; olay kaydı: yalnız eklenir, yanlış kayıt silinir.
class LabResultRepository extends BaseRepository<$LabResultsTable, LabResult> {
  new(super.db, {super.clock});

  @override
  $LabResultsTable get table => db.labResults;

  @override
  Insertable<LabResult> toInsertable(LabResult record) => record.toInsertable();

  /// Lotun analizleri, yeni önce.
  Stream<List<LabResult>> watchByLot(String lotId) => watchWhere(
    (t) => t.lotId.equals(lotId),
    orderBy: [
      (t) => OrderingTerm.desc(t.testedOn),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  Future<List<LabResult>> findByLot(String lotId) =>
      selectWhere((t) => t.lotId.equals(lotId)).get();

  /// [lot]'a analiz yazar. Hiç sonuç yoksa ya da değer sınır dışındaysa
  /// ([isValidLabResult]) [ArgumentError] atar ve bir şey yazmaz.
  Future<LabResult> add(Lot lot, LabResultValues values) {
    if (!isValidLabResult(values)) throw ArgumentError.value(values, 'values');
    final at = now();
    return insertRecord(
      LabResult(
        id: generateId(),
        orgId: lot.orgId,
        lotId: lot.id,
        testedOn: dateOnly(values.testedOn),
        hmf: values.hmf,
        diastase: values.diastase,
        proline: values.proline,
        moisture: values.moisture,
        residue: values.residue,
        documentId: values.documentId,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

/// Lot satışları; olay kaydı: yalnız eklenir, yanlış kayıt silinir (Geri al
/// da silmedir).
class LotSaleRepository extends BaseRepository<$LotSalesTable, LotSale> {
  new(super.db, {super.clock});

  @override
  $LotSalesTable get table => db.lotSales;

  @override
  Insertable<LotSale> toInsertable(LotSale record) => record.toInsertable();

  /// Lotun satışları, yeni önce.
  Stream<List<LotSale>> watchByLot(String lotId) => watchWhere(
    (t) => t.lotId.equals(lotId),
    orderBy: [
      (t) => OrderingTerm.desc(t.soldOn),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  Future<List<LotSale>> findByLot(String lotId) =>
      selectWhere((t) => t.lotId.equals(lotId)).get();

  /// [lot]'tan [kg] satış düşer. [kg] pozitif değilse ya da sınırı aşıyorsa
  /// [ArgumentError] atar.
  Future<LotSale> add(Lot lot, double kg, {required DateTime soldOn}) {
    if (!(kg > 0 && kg <= maxLotSaleKg)) throw ArgumentError.value(kg, 'kg');
    final at = now();
    return insertRecord(
      LotSale(
        id: generateId(),
        orgId: lot.orgId,
        lotId: lot.id,
        soldOn: dateOnly(soldOn),
        kg: _round(kg),
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

/// Lotu yazılacak hâline getirir: yörenin baştaki ve sondaki boşlukları
/// atılır, boş yöre null olur. Yöre uzunsa ya da nem aralık dışındaysa
/// [ArgumentError] atar.
Lot checkLot(Lot lot) {
  final origin = lot.origin?.trim();
  if (origin != null && origin.length > maxLotOriginLength) {
    throw ArgumentError.value(lot.origin, 'origin');
  }
  final moisture = lot.moisture;
  if (moisture != null &&
      !(moisture >= minLotMoisture && moisture <= maxLotMoisture)) {
    throw ArgumentError.value(moisture, 'moisture');
  }
  return lot.copyWith(origin: origin == null || origin.isEmpty ? null : origin);
}

/// Analizde en az bir sonuç var ve değerler sunucunun sınırları içinde.
bool isValidLabResult(LabResultValues values) {
  bool within(double? value, double min, double max) =>
      value == null || (value >= min && value <= max);
  return (values.hmf != null ||
          values.diastase != null ||
          values.proline != null ||
          values.moisture != null ||
          values.residue != null) &&
      within(values.hmf, 0, maxLabHmf) &&
      within(values.diastase, 0, maxLabDiastase) &&
      within(values.proline, 0, maxLabProline) &&
      within(values.moisture, minLotMoisture, maxLotMoisture);
}

double _round(double value) => (value * 1000).roundToDouble() / 1000;

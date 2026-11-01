import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing_rules.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

/// Ana yetiştirme serileri; durum kaydı, son yazan kazanır. Seri takvim
/// görevleriyle ([TaskRepository.addQueenRearingSteps]) aynı
/// transaction'da yazılır. Çiftleşme kutuları [nucs].
class QueenRearingRepository
    extends BaseRepository<$QueenRearingBatchesTable, QueenRearingBatch> {
  new(super.db, {super.clock});

  late final _tasks = TaskRepository(db, clock: clock);

  /// Çiftleşme kutuları; aynı veritabanı ve saat.
  late final nucs = MatingNucRepository(db, clock: clock);

  @override
  $QueenRearingBatchesTable get table => db.queenRearingBatches;

  @override
  Insertable<QueenRearingBatch> toInsertable(QueenRearingBatch record) =>
      record.toInsertable();

  /// İşletmenin serileri, son aktarılan önce; aynı günde büyük numara önce.
  Stream<List<QueenRearingBatch>> watchByOrg(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [
      (t) => OrderingTerm.desc(t.graftedOn),
      (t) => OrderingTerm.desc(t.number),
      (t) => OrderingTerm.asc(t.id),
    ],
  );

  /// Yeni seri ve takvim görevleri tek transaction'da. Numara işletmedeki
  /// en büyük numaranın bir fazlası ([nextRearingBatchNumber]); görevler
  /// [assignedTo]'ya atanır. Sayılar aralık dışındaysa [ArgumentError]
  /// atar ve bir şey yazmaz.
  Future<QueenRearingBatch> create({
    required String orgId,
    required DateTime graftedOn,
    required int graftedCount,
    String? motherQueenId,
    int? acceptedCount,
    String? assignedTo,
  }) => db.transaction(() async {
    // Silinmiş serilerin numarası da sayılır; numara yeniden verilmez.
    final numbers =
        await (db.selectOnly(table)
              ..addColumns([table.number])
              ..where(table.orgId.equals(orgId)))
            .get();
    final at = now();
    final batch = await insertRecord(
      _checked(
        QueenRearingBatch(
          id: generateId(),
          orgId: orgId,
          number: nextRearingBatchNumber(
            numbers.map((row) => row.read(table.number) ?? 0),
          ),
          graftedOn: dateOnly(graftedOn),
          graftedCount: graftedCount,
          motherQueenId: motherQueenId,
          acceptedCount: acceptedCount,
          createdAt: at,
          updatedAt: at,
        ),
      ),
    );
    await _tasks.addQueenRearingSteps(
      orgId: orgId,
      batchId: batch.id,
      graftedOn: batch.graftedOn,
      assignedTo: assignedTo,
    );
    return batch;
  });

  /// Serinin alanlarını yazar (son yazan kazanır). Aktarma günü değiştiyse
  /// görevlerin günü aynı transaction'da yeni takvime çekilir. Seri yoksa
  /// [StateError]; sayılar geçersizse [ArgumentError].
  Future<QueenRearingBatch> update(QueenRearingBatch batch) =>
      db.transaction(() async {
        final previous = await requireById(batch.id);
        final updated = await updateRecord(
          _checked(batch.copyWith(graftedOn: dateOnly(batch.graftedOn))),
        );
        if (!previous.graftedOn.isAtSameMomentAs(updated.graftedOn)) {
          await _tasks.rescheduleQueenRearing(updated.id, updated.graftedOn);
        }
        return updated;
      });

  /// Seriyi ve takvim görevlerini tek transaction'da siler. Kutular ve
  /// kovana verilmiş analar kalır.
  Future<void> remove(String id) => db.transaction(() async {
    await _tasks.deleteBySource(TaskSource.queenRearing, id);
    await delete(id);
  });

  /// Sunucunun kısıtları: numara 1–[maxRearingBatchNumber], aktarılan
  /// 1–[maxGraftedCount], kabul 0 ile aktarılan arasında.
  static QueenRearingBatch _checked(QueenRearingBatch batch) {
    if (batch.number < 1 || batch.number > maxRearingBatchNumber) {
      throw ArgumentError.value(batch.number, 'number');
    }
    if (batch.graftedCount < 1 || batch.graftedCount > maxGraftedCount) {
      throw ArgumentError.value(batch.graftedCount, 'graftedCount');
    }
    if (batch.acceptedCount case final accepted?
        when accepted < 0 || accepted > batch.graftedCount) {
      throw ArgumentError.value(accepted, 'acceptedCount');
    }
    return batch;
  }
}

/// Kutudan kovana verilen ana: kutunun yeni hâli ve ananın verilişi.
/// Geri almak için [MatingNucRepository.undoGiveQueen]'e verilir.
typedef NucQueenGiven = ({MatingNuc nuc, QueenGiven given});

/// Çiftleşme kutuları; durum kaydı, son yazan kazanır.
class MatingNucRepository extends BaseRepository<$MatingNucsTable, MatingNuc> {
  new(super.db, {super.clock});

  late final _queens = QueenRepository(db, clock: clock);

  @override
  $MatingNucsTable get table => db.matingNucs;

  @override
  Insertable<MatingNuc> toInsertable(MatingNuc record) => record.toInsertable();

  /// Serinin kutuları (boşaltılmışlar dahil). Sıra ekranda numaraya göre
  /// verilir.
  Stream<List<MatingNuc>> watchByBatch(String batchId) =>
      watchWhere((t) => t.rearingBatchId.equals(batchId));

  /// Arılığın kutuları.
  Stream<List<MatingNuc>> watchByApiary(String apiaryId) =>
      watchWhere((t) => t.apiaryId.equals(apiaryId));

  /// [count] memeyi [apiaryId] arılığındaki kutulara dağıtır
  /// ([distributeCells]): boş kutular yeniden kullanılır, kalanlar için
  /// yeni kutu açılır; hepsinin içi meme olur ve seriye bağlanır. Hepsi tek
  /// transaction'da. [count] 1'den küçükse [ArgumentError].
  Future<List<MatingNuc>> distribute({
    required QueenRearingBatch batch,
    required String apiaryId,
    required int count,
  }) {
    if (count < 1 || count > maxGraftedCount) {
      throw ArgumentError.value(count, 'count');
    }
    return db.transaction(() async {
      final plan = distributeCells(
        await selectWhere((t) => t.apiaryId.equals(apiaryId)).get(),
        count,
      );
      final at = now();
      return [
        for (final nuc in plan.reused)
          await updateRecord(
            nuc.copyWith(
              status: MatingNucStatus.cell,
              rearingBatchId: batch.id,
              queenId: null,
            ),
          ),
        for (final number in plan.newNumbers)
          await insertRecord(
            MatingNuc(
              id: generateId(),
              orgId: batch.orgId,
              number: number,
              apiaryId: apiaryId,
              status: MatingNucStatus.cell,
              rearingBatchId: batch.id,
              createdAt: at,
              updatedAt: at,
            ),
          ),
      ];
    });
  }

  /// Kutunun içini yazar. "Kovana verildi" yalnız [giveQueen] ile
  /// yazılır; [ArgumentError] atar. Seriye bağlı olmayan kutu yalnız boş
  /// olabilir.
  Future<MatingNuc> setStatus(MatingNuc nuc, MatingNucStatus status) {
    if (status == MatingNucStatus.given ||
        (status != MatingNucStatus.empty && nuc.rearingBatchId == null)) {
      throw ArgumentError.value(status, 'status');
    }
    return updateRecord(nuc.copyWith(status: status, queenId: null));
  }

  /// Kutudaki yumurtlayan anayı [hiveId] kovanına verir: yeni ana kaydı
  /// (kendi üretimi, çiftleşmiş, aktarma yılı ve yılın rengi, anne ana
  /// serinin anne anası) kovana yazılır ve kutu "kovana verildi" olur.
  /// Hepsi tek transaction'da. Kutu yumurtlamıyorsa ya da kutu veya kovan
  /// yoksa [StateError] atar ve bir şey yazmaz.
  Future<NucQueenGiven> giveQueen(String nucId, String hiveId) =>
      db.transaction(() async {
        final nuc = await requireById(nucId);
        if (!canGiveQueen(nuc)) {
          throw StateError('mating_nucs/$nucId yumurtlamıyor');
        }
        final batchId = nuc.rearingBatchId;
        // Seri silinmiş olsa da anne ana ve yıl ondan gelir.
        final batch = batchId == null
            ? null
            : await (db.select(
                db.queenRearingBatches,
              )..where((t) => t.id.equals(batchId))).getSingleOrNull();
        final year = (batch?.graftedOn ?? clock()).year;
        final given = await _queens.giveToHive(
          hiveId,
          year: year,
          markColor: markColorForYear(year),
          source: QueenSource.ownRearing,
          matingStatus: QueenMatingStatus.mated,
          motherQueenId: batch?.motherQueenId,
        );
        final updated = await updateRecord(
          nuc.copyWith(status: MatingNucStatus.given, queenId: given.queen.id),
        );
        return (nuc: updated, given: given);
      });

  /// Kutudan vermeyi geri alır: kovan eski anasına döner, yeni ana silinir
  /// ([QueenRepository.undoGive]) ve kutu yeniden "yumurtluyor" olur; tek
  /// transaction. Kovanın anası bu arada değiştiyse bir şey yazmaz ve
  /// false döner.
  Future<bool> undoGiveQueen(NucQueenGiven given) => db.transaction(() async {
    if (!await _queens.undoGive(given.given)) return false;
    final nuc = await findById(given.nuc.id);
    if (nuc != null && nuc.queenId == given.given.queen.id) {
      await updateRecord(
        nuc.copyWith(status: MatingNucStatus.laying, queenId: null),
      );
    }
    return true;
  });
}

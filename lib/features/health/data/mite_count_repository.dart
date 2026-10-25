import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';

/// Varroa ölçümleri; olay kaydı: yalnız eklenir, güncelleme yok, yanlış
/// kayıt silinir (Geri al da silmedir).
class MiteCountRepository extends BaseRepository<$MiteCountsTable, MiteCount> {
  new(super.db, {super.clock});

  @override
  $MiteCountsTable get table => db.miteCounts;

  @override
  Insertable<MiteCount> toInsertable(MiteCount record) => record.toInsertable();

  /// Kovanın ölçümleri, en yeni önce. Aynı anda yapılanlardan kimliği
  /// (UUIDv7) büyük olan önce.
  Stream<List<MiteCount>> watchByHive(String hiveId) => watchWhere(
    (t) => t.hiveId.equals(hiveId),
    orderBy: [
      (t) => OrderingTerm.desc(t.countedAt),
      (t) => OrderingTerm.desc(t.id),
    ],
  );

  /// [apiaryId] arılığında yapılan ölçümler, eskisi önce. Kovan sonra
  /// taşınsa da ölçüm yapıldığı arılıkta kalır.
  Stream<List<MiteCount>> watchByApiary(String apiaryId) => watchWhere(
    (t) => t.apiaryId.equals(apiaryId),
    orderBy: [
      (t) => OrderingTerm.asc(t.countedAt),
      (t) => OrderingTerm.asc(t.id),
    ],
  );

  /// Kovanın şimdi [apiaryId] arılığında yapılan ölçümünü yazar. Örnekli
  /// yöntemde [sampleBees], alt tablada [days] verilir; öbürü yok sayılır.
  /// Gereken alan yoksa ya da sıfırsa [ArgumentError] atar ve bir şey
  /// yazmaz (sunucu da reddederdi).
  Future<MiteCount> add({
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required MiteCountMethod method,
    required int mites,
    int? sampleBees,
    int? days,
  }) {
    if (mites < 0) throw ArgumentError.value(mites, 'mites');
    final sample = method.usesSample ? sampleBees : null;
    final boardDays = method.usesSample ? null : days;
    if (method.usesSample && (sample == null || sample <= 0)) {
      throw ArgumentError.value(sampleBees, 'sampleBees');
    }
    if (!method.usesSample && (boardDays == null || boardDays <= 0)) {
      throw ArgumentError.value(days, 'days');
    }
    final at = now();
    return insertRecord(
      MiteCount(
        id: generateId(),
        orgId: orgId,
        hiveId: hiveId,
        apiaryId: apiaryId,
        countedAt: at,
        method: method,
        mites: mites,
        sampleBees: sample,
        days: boardDays,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }
}

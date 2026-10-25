import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';

/// Beslemeler; olay kaydı: yalnız eklenir, güncelleme yok, yanlış kayıt
/// silinir (Geri al da silmedir). Bir kayıtta yazılan beslemeler ortak
/// `feeding_group_id` taşır; toplu besleme hepsini ya da hiçbirini yazar.
class FeedingRepository extends BaseRepository<$FeedingsTable, Feeding> {
  new(super.db, {super.clock});

  late final _inspections = InspectionRepository(db, clock: clock);

  @override
  $FeedingsTable get table => db.feedings;

  @override
  Insertable<Feeding> toInsertable(Feeding record) => record.toInsertable();

  /// [plan]'ı [hive]'a, kovanın şimdiki arılığında yazar. Bal katı uyarısı
  /// ekranın; tek kovanda kayıt yine yazılır.
  Future<Feeding> addToHive(Hive hive, FeedingPlan plan) async =>
      (await _addAll([hive], plan)).single;

  /// [plan]'ı [apiaryId] arılığındaki aktif kovanlara tek transaction'da
  /// yazar ve kovan numarası sırasıyla döner. Şurupta bal katı olan kovanlar
  /// atlanır ([feedingTargets]); bal katı aynı transaction'da muayenelerden
  /// okunur. Beslenecek kovan yoksa bir şey yazmaz, boş döner.
  Future<List<Feeding>> addToApiary(String apiaryId, FeedingPlan plan) =>
      db.transaction(() async {
        final hives =
            await (db.select(db.hives)
                  ..where(
                    (t) =>
                        t.apiaryId.equals(apiaryId) &
                        t.deletedAt.isNull() &
                        t.status.equalsValue(HiveStatus.active),
                  )
                  ..orderBy([(t) => OrderingTerm.asc(t.number)]))
                .get();
        final supers = honeySuperHiveIds(
          await _inspections.findSuperChangesByApiary(apiaryId),
        );
        return await _addAll(
          feedingTargets(hives, supers, plan.kind).fed,
          plan,
        );
      });

  /// Geri al: [feedings]'i tek transaction'da siler.
  Future<void> deleteAll(Iterable<Feeding> feedings) =>
      db.transaction(() async {
        for (final feeding in feedings) {
          await delete(feeding.id);
        }
      });

  /// Miktar sunucunun kısıtına uymazsa [ArgumentError] atar ve bir şey
  /// yazmaz.
  Future<List<Feeding>> _addAll(List<Hive> hives, FeedingPlan plan) {
    if (!(plan.amount > 0 && plan.amount <= maxStoredFeedingAmount)) {
      throw ArgumentError.value(plan.amount, 'amount');
    }
    final groupId = generateId();
    return db.transaction(() async {
      final at = now();
      return [
        for (final hive in hives)
          await insertRecord(
            Feeding(
              id: generateId(),
              orgId: hive.orgId,
              hiveId: hive.id,
              apiaryId: hive.apiaryId,
              feedingGroupId: groupId,
              fedAt: plan.fedAt.toUtc(),
              kind: plan.kind,
              amount: plan.amount,
              createdAt: at,
              updatedAt: at,
            ),
          ),
      ];
    });
  }
}

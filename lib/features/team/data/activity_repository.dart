import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/team/domain/activity_rules.dart';

/// Ekibin son işlemleri; yalnız okunur, yeni tablo yok. Muayene, ilaç,
/// besleme, hasat, varroa ölçümü ve elle açılan görev kayıtlarının
/// `created_by` + `created_at` alanlarından yerel DB'de üretilir.
/// `created_by`'ı sunucu doldurur; senkrona ulaşmamış kayıt akışta yok.
class ActivityRepository {
  new(this.db);

  final AppDatabase db;

  /// Okunan kayıt sayısı; gruplamadan önceki üst sınır.
  static const recordLimit = 100;

  /// İşletmenin en yeni kayıtları, yeniden eskiye. Kayıtlardan biri ya da
  /// arılık adı değişince yeniden yayar.
  Stream<List<ActivityRecord>> watchRecent(String orgId) {
    String part(ActivityKind kind, String table, [String extra = '']) =>
        "select '${kind.name}' as kind, created_by, created_at, apiary_id "
        'from $table '
        'where org_id = ?1 and deleted_at is null and created_by is not null'
        '$extra';
    final sql =
        'select u.kind, u.created_by, u.created_at, u.apiary_id, '
        '(select name from apiaries a where a.id = u.apiary_id) as apiary_name '
        'from ('
        '${part(ActivityKind.inspection, 'inspections')} union all '
        '${part(ActivityKind.treatment, 'treatments')} union all '
        '${part(ActivityKind.feeding, 'feedings')} union all '
        '${part(ActivityKind.harvest, 'harvests')} union all '
        '${part(ActivityKind.miteCount, 'mite_counts')} union all '
        "${part(ActivityKind.task, 'tasks', " and source = 'manual'")}"
        ') u order by u.created_at desc limit $recordLimit';
    return db
        .customSelect(
          sql,
          variables: [Variable.withString(orgId)],
          readsFrom: {
            db.inspections,
            db.treatments,
            db.feedings,
            db.harvests,
            db.miteCounts,
            db.tasks,
            db.apiaries,
          },
        )
        .watch()
        .map(
          (rows) => [
            for (final row in rows)
              (
                kind: ActivityKind.values.byName(row.read<String>('kind')),
                userId: row.read<String>('created_by'),
                at: row.readWithType(DriftSqlType.dateTime, 'created_at'),
                apiaryId: row.readNullable<String>('apiary_id'),
                apiaryName: row.readNullable<String>('apiary_name'),
              ),
          ],
        );
  }
}

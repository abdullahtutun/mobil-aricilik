import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';

/// Muayeneden sonra seçilen "X gün sonra hatırlat". Görev modülü gelene
/// kadar yalnız değer saklanır ve yalnız bu telefonda durur; görevler
/// gelince göreve çevrilecek.
class InspectionReminderRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  /// Yazma zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  /// Muayenenin hatırlatması; yoksa null.
  Future<InspectionReminder?> findByInspection(String inspectionId) =>
      (db.select(
        db.inspectionReminders,
      )..where((t) => t.inspectionId.equals(inspectionId))).getSingleOrNull();

  /// [inspection]'dan [days] gün sonra hatırlatır; muayenenin önceki
  /// seçiminin yerini alır.
  Future<InspectionReminder> set(Inspection inspection, int days) => db
      .into(db.inspectionReminders)
      .insertReturning(
        InspectionRemindersCompanion.insert(
          inspectionId: inspection.id,
          orgId: inspection.orgId,
          hiveId: inspection.hiveId,
          days: days,
          remindAt: reminderAt(inspection.inspectedAt, days),
          createdAt: clock().toUtc(),
        ),
        mode: InsertMode.insertOrReplace,
      );

  /// Muayenenin hatırlatmasını kaldırır; yoksa bir şey yapmaz.
  Future<void> clear(String inspectionId) => (db.delete(
    db.inspectionReminders,
  )..where((t) => t.inspectionId.equals(inspectionId))).go();
}

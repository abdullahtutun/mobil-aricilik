import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'inspection_providers.g.dart';

@Riverpod(keepAlive: true)
InspectionRepository inspectionRepository(Ref ref) =>
    InspectionRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
InspectionDraftRepository inspectionDraftRepository(Ref ref) =>
    InspectionDraftRepository(ref.watch(appDatabaseProvider));

/// Kaydedilen muayene ve kaydedilirkenki form; Geri al formu taslak olarak
/// geri yazar.
typedef SavedInspection = ({Inspection inspection, InspectionDraft draft});

/// Kaydettikten sonraki eylemler: geri alma ve "tekrar bak" görevi.
/// Bildirim, muayene sayfası kapandıktan sonra da çalışsın diye sürekli
/// yaşar. Her şey yerel DB'ye yazılır.
@Riverpod(keepAlive: true)
class InspectionActions extends _$InspectionActions {
  @override
  void build() {}

  Future<void> undo(SavedInspection saved) => ref
      .read(inspectionRepositoryProvider)
      .undoAdd(saved.inspection, saved.draft);

  /// [days] gün sonra "tekrar bak" görevi açar ya da görevin gününü
  /// değiştirir; null görevi siler. Görev muayeneyi yapana atanır ve
  /// bildirim izni yoksa sorulur.
  Future<void> remind(Inspection inspection, int? days) async {
    final tasks = ref.read(taskRepositoryProvider);
    if (days == null) {
      await tasks.deleteBySource(TaskSource.inspection, inspection.id);
      return;
    }
    await tasks.remindAfterInspection(
      inspection,
      days,
      assignedTo: ref.read(currentUserIdProvider),
    );
    await ref.read(reminderAccessProvider.notifier).requestNotifications();
  }
}

import 'package:clock/clock.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_form_controller.freezed.dart';
part 'task_form_controller.g.dart';

@freezed
abstract class TaskFormState with _$TaskFormState {
  const factory({
    /// Son tarih, yerel saat.
    required DateTime dueAt,
    @Default('') String title,
    String? apiaryId,
    String? hiveId,
    String? assignedTo,
    @Default(false) bool completed,

    /// Düzenlenen görevin kaynağı; otomatik görevde başlık, arılık ve kovan
    /// kaynaktan gelir, değişmez.
    @Default(TaskSource.manual) TaskSource source,
    @Default(false) bool saving,
  }) = _TaskFormState;

  factory fromTask(Task task) => TaskFormState(
    dueAt: task.dueAt.toLocal(),
    title: task.title ?? '',
    apiaryId: task.apiaryId,
    hiveId: task.hiveId,
    assignedTo: task.assignedTo,
    completed: task.completedAt != null,
    source: task.source,
  );
}

extension TaskFormProgress on TaskFormState {
  bool get isManual => source == TaskSource.manual;

  bool get canSave => (!isManual || title.trim().isNotEmpty) && !saving;
}

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır.
@riverpod
class TaskFormController extends _$TaskFormController {
  @override
  Future<TaskFormState?> build(String? taskId) async {
    if (taskId == null) {
      return TaskFormState(
        dueAt: defaultTaskDueAt(clock.now()),
        // Yeni görev önce kendime; hatırlatma ekibin her telefonunda
        // çalmasın.
        assignedTo: ref.read(currentUserIdProvider),
      );
    }
    final task = await ref.read(taskRepositoryProvider).findById(taskId);
    return task == null ? null : TaskFormState.fromTask(task);
  }

  void setTitle(String title) => _update((form) => form.copyWith(title: title));

  /// Günü değiştirir, saati korur.
  void setDueDay(DateTime day) => _update(
    (form) => form.copyWith(
      dueAt: DateTime(
        day.year,
        day.month,
        day.day,
        form.dueAt.hour,
        form.dueAt.minute,
      ),
    ),
  );

  /// Saati değiştirir, günü korur.
  void setDueTime({required int hour, required int minute}) => _update(
    (form) => form.copyWith(
      dueAt: DateTime(
        form.dueAt.year,
        form.dueAt.month,
        form.dueAt.day,
        hour,
        minute,
      ),
    ),
  );

  /// Arılığı seçer; kovan başka arılıktaysa bırakılır.
  void setApiary(String? apiaryId) => _update(
    (form) => form.copyWith(
      apiaryId: apiaryId,
      hiveId: apiaryId == form.apiaryId ? form.hiveId : null,
    ),
  );

  void setHive(String? hiveId) =>
      _update((form) => form.copyWith(hiveId: hiveId));

  void setAssignee(String? userId) =>
      _update((form) => form.copyWith(assignedTo: userId));

  void setCompleted({required bool completed}) =>
      _update((form) => form.copyWith(completed: completed));

  /// Görevi yazar ve döner; kaydedilemiyorsa ya da düzenlenen görev bu
  /// arada silindiyse null.
  Future<Task?> save() async {
    final form = state.value;
    final orgId = ref.read(currentOrgIdProvider);
    if (form == null || !form.canSave || orgId == null) return null;
    _update((form) => form.copyWith(saving: true));

    final repository = ref.read(taskRepositoryProvider);
    final id = taskId;
    // Yazma hata atsa da Kaydet yeniden açılsın.
    try {
      if (id == null) {
        return await repository.create(
          orgId: orgId,
          title: form.title,
          dueAt: form.dueAt,
          apiaryId: form.apiaryId,
          hiveId: form.hiveId,
          assignedTo: form.assignedTo,
        );
      }
      // Formda olmayan alanlar (ör. kaynak) en son hâlinden alınır.
      final latest = await repository.findById(id);
      if (latest == null) {
        if (ref.mounted) state = const AsyncData(null);
        return null;
      }
      return await repository.update(
        latest.copyWith(
          title: form.isManual ? form.title : latest.title,
          dueAt: form.dueAt,
          apiaryId: form.isManual ? form.apiaryId : latest.apiaryId,
          hiveId: form.isManual ? form.hiveId : latest.hiveId,
          assignedTo: form.assignedTo,
          completedAt: form.completed
              ? latest.completedAt ?? clock.now().toUtc()
              : null,
        ),
      );
    } finally {
      if (ref.mounted) _update((form) => form.copyWith(saving: false));
    }
  }

  void _update(TaskFormState Function(TaskFormState form) change) {
    if (state.value case final form?) state = AsyncData(change(form));
  }
}

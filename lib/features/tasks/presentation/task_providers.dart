import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_providers.g.dart';

@Riverpod(keepAlive: true)
TaskRepository taskRepository(Ref ref) =>
    TaskRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin açık görevleri, son tarih sırasıyla; işletme
/// yoksa boş.
@riverpod
Stream<List<TaskView>> openTasks(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(taskRepositoryProvider).watchOpen(orgId);
}

/// Oturumdaki işletmenin açık planlı ilaçlama görevleri ve uygulanacak
/// kovan sayısı; işletme yoksa boş.
@riverpod
Stream<List<({Task task, int hives})>> openPlannedTreatments(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(taskRepositoryProvider).watchOpenPlannedTreatments(orgId);
}

/// Görev; yoksa ya da silinmişse null.
@riverpod
Stream<Task?> task(Ref ref, String id) =>
    ref.watch(taskRepositoryProvider).watchById(id);

/// Listedeki eylemler. Bildirimin Geri al'ı ekran değişse de çalışsın diye
/// sürekli yaşar.
@Riverpod(keepAlive: true)
class TaskActions extends _$TaskActions {
  @override
  void build() {}

  /// Görevi tamamlar ve tamamlanmış hâlini döner.
  Future<Task> complete(Task task) =>
      ref.read(taskRepositoryProvider).setCompleted(task, completed: true);

  /// Geri al: görev yeniden açılır.
  Future<void> reopen(Task task) async {
    final latest = await ref.read(taskRepositoryProvider).findById(task.id);
    if (latest == null) return;
    await ref
        .read(taskRepositoryProvider)
        .setCompleted(latest, completed: false);
  }

  Future<void> delete(String id) => ref.read(taskRepositoryProvider).delete(id);
}

/// Oturumdaki kullanıcının kimliği; görev atamada "Ben".
@riverpod
String? currentUserId(Ref ref) =>
    ref.watch(currentUserProvider.select((user) => user?.id));

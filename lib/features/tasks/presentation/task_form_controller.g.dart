// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır.

@ProviderFor(TaskFormController)
final taskFormControllerProvider = TaskFormControllerFamily._();

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır.
final class TaskFormControllerProvider
    extends $AsyncNotifierProvider<TaskFormController, TaskFormState?> {
  /// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye yazılır.
  TaskFormControllerProvider._({
    required TaskFormControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'taskFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskFormControllerHash();

  @override
  String toString() {
    return r'taskFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TaskFormController create() => TaskFormController();

  @override
  bool operator ==(Object other) {
    return other is TaskFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskFormControllerHash() =>
    r'8df1ffb91ff4c7bd32c3d51aefea25f213d7aea1';

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır.

final class TaskFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TaskFormController,
          AsyncValue<TaskFormState?>,
          TaskFormState?,
          FutureOr<TaskFormState?>,
          String?
        > {
  TaskFormControllerFamily._()
    : super(
        retry: null,
        name: r'taskFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye yazılır.

  TaskFormControllerProvider call(String? taskId) =>
      TaskFormControllerProvider._(argument: taskId, from: this);

  @override
  String toString() => r'taskFormControllerProvider';
}

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır.

abstract class _$TaskFormController extends $AsyncNotifier<TaskFormState?> {
  late final _$args = ref.$arg as String?;
  String? get taskId => _$args;

  FutureOr<TaskFormState?> build(String? taskId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<TaskFormState?>, TaskFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<TaskFormState?>, TaskFormState?>,
              AsyncValue<TaskFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

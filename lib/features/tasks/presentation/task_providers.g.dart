// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(taskRepository)
final taskRepositoryProvider = TaskRepositoryProvider._();

final class TaskRepositoryProvider
    extends $FunctionalProvider<TaskRepository, TaskRepository, TaskRepository>
    with $Provider<TaskRepository> {
  TaskRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRepositoryHash();

  @$internal
  @override
  $ProviderElement<TaskRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TaskRepository create(Ref ref) {
    return taskRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TaskRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TaskRepository>(value),
    );
  }
}

String _$taskRepositoryHash() => r'6d33b061fdc59c9d541e9f0649801dbc2dc27424';

/// Oturumdaki işletmenin açık görevleri, son tarih sırasıyla; işletme
/// yoksa boş.

@ProviderFor(openTasks)
final openTasksProvider = OpenTasksProvider._();

/// Oturumdaki işletmenin açık görevleri, son tarih sırasıyla; işletme
/// yoksa boş.

final class OpenTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TaskView>>,
          List<TaskView>,
          Stream<List<TaskView>>
        >
    with $FutureModifier<List<TaskView>>, $StreamProvider<List<TaskView>> {
  /// Oturumdaki işletmenin açık görevleri, son tarih sırasıyla; işletme
  /// yoksa boş.
  OpenTasksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openTasksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openTasksHash();

  @$internal
  @override
  $StreamProviderElement<List<TaskView>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TaskView>> create(Ref ref) {
    return openTasks(ref);
  }
}

String _$openTasksHash() => r'f1fa8d2f05699b46148d24de8f5df4543a488bb2';

/// Görev; yoksa ya da silinmişse null.

@ProviderFor(task)
final taskProvider = TaskFamily._();

/// Görev; yoksa ya da silinmişse null.

final class TaskProvider
    extends $FunctionalProvider<AsyncValue<Task?>, Task?, Stream<Task?>>
    with $FutureModifier<Task?>, $StreamProvider<Task?> {
  /// Görev; yoksa ya da silinmişse null.
  TaskProvider._({
    required TaskFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'taskProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$taskHash();

  @override
  String toString() {
    return r'taskProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Task?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Task?> create(Ref ref) {
    final argument = this.argument as String;
    return task(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TaskProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$taskHash() => r'd69b8aebf0a50cc7662e2afe5ee2cdd93de57a7a';

/// Görev; yoksa ya da silinmişse null.

final class TaskFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Task?>, String> {
  TaskFamily._()
    : super(
        retry: null,
        name: r'taskProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Görev; yoksa ya da silinmişse null.

  TaskProvider call(String id) => TaskProvider._(argument: id, from: this);

  @override
  String toString() => r'taskProvider';
}

/// Listedeki eylemler. Bildirimin Geri al'ı ekran değişse de çalışsın diye
/// sürekli yaşar.

@ProviderFor(TaskActions)
final taskActionsProvider = TaskActionsProvider._();

/// Listedeki eylemler. Bildirimin Geri al'ı ekran değişse de çalışsın diye
/// sürekli yaşar.
final class TaskActionsProvider extends $NotifierProvider<TaskActions, void> {
  /// Listedeki eylemler. Bildirimin Geri al'ı ekran değişse de çalışsın diye
  /// sürekli yaşar.
  TaskActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskActionsHash();

  @$internal
  @override
  TaskActions create() => TaskActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$taskActionsHash() => r'7aeae84a0123dc0964e917de930833689f2aa3d8';

/// Listedeki eylemler. Bildirimin Geri al'ı ekran değişse de çalışsın diye
/// sürekli yaşar.

abstract class _$TaskActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Oturumdaki kullanıcının kimliği; görev atamada "Ben".

@ProviderFor(currentUserId)
final currentUserIdProvider = CurrentUserIdProvider._();

/// Oturumdaki kullanıcının kimliği; görev atamada "Ben".

final class CurrentUserIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Oturumdaki kullanıcının kimliği; görev atamada "Ben".
  CurrentUserIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserIdProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentUserId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentUserIdHash() => r'3553137ae8e885e53f4f191cc6056ea7907bbc75';

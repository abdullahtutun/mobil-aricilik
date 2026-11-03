// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır. Yeni görev önerilen günle ([dueDay]),
/// arılıkla ve başlıkla açılabilir (ör. hava ekranındaki "Planla");
/// kullanıcı kaydedene kadar görev yazılmaz.

@ProviderFor(TaskFormController)
final taskFormControllerProvider = TaskFormControllerFamily._();

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır. Yeni görev önerilen günle ([dueDay]),
/// arılıkla ve başlıkla açılabilir (ör. hava ekranındaki "Planla");
/// kullanıcı kaydedene kadar görev yazılmaz.
final class TaskFormControllerProvider
    extends $AsyncNotifierProvider<TaskFormController, TaskFormState?> {
  /// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
  /// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
  /// Her şey yerel DB'ye yazılır. Yeni görev önerilen günle ([dueDay]),
  /// arılıkla ve başlıkla açılabilir (ör. hava ekranındaki "Planla");
  /// kullanıcı kaydedene kadar görev yazılmaz.
  TaskFormControllerProvider._({
    required TaskFormControllerFamily super.from,
    required (String?, {DateTime? dueDay, String? apiaryId, String? title})
    super.argument,
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
        '$argument';
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
    r'd5bd39656840c1c0a2ad1656598d4bf280ee7eba';

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır. Yeni görev önerilen günle ([dueDay]),
/// arılıkla ve başlıkla açılabilir (ör. hava ekranındaki "Planla");
/// kullanıcı kaydedene kadar görev yazılmaz.

final class TaskFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          TaskFormController,
          AsyncValue<TaskFormState?>,
          TaskFormState?,
          FutureOr<TaskFormState?>,
          (String?, {DateTime? dueDay, String? apiaryId, String? title})
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
  /// Her şey yerel DB'ye yazılır. Yeni görev önerilen günle ([dueDay]),
  /// arılıkla ve başlıkla açılabilir (ör. hava ekranındaki "Planla");
  /// kullanıcı kaydedene kadar görev yazılmaz.

  TaskFormControllerProvider call(
    String? taskId, {
    DateTime? dueDay,
    String? apiaryId,
    String? title,
  }) => TaskFormControllerProvider._(
    argument: (taskId, dueDay: dueDay, apiaryId: apiaryId, title: title),
    from: this,
  );

  @override
  String toString() => r'taskFormControllerProvider';
}

/// Görev ekleme ([taskId] null) ve düzenleme formu. Ekran açık kaldığı
/// sürece yaşar. Düzenlenecek görev yoksa ya da silinmişse durum null.
/// Her şey yerel DB'ye yazılır. Yeni görev önerilen günle ([dueDay]),
/// arılıkla ve başlıkla açılabilir (ör. hava ekranındaki "Planla");
/// kullanıcı kaydedene kadar görev yazılmaz.

abstract class _$TaskFormController extends $AsyncNotifier<TaskFormState?> {
  late final _$args =
      ref.$arg
          as (String?, {DateTime? dueDay, String? apiaryId, String? title});
  String? get taskId => _$args.$1;
  DateTime? get dueDay => _$args.dueDay;
  String? get apiaryId => _$args.apiaryId;
  String? get title => _$args.title;

  FutureOr<TaskFormState?> build(
    String? taskId, {
    DateTime? dueDay,
    String? apiaryId,
    String? title,
  });
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
    return element.handleCreate(
      ref,
      () => build(
        _$args.$1,
        dueDay: _$args.dueDay,
        apiaryId: _$args.apiaryId,
        title: _$args.title,
      ),
    );
  }
}

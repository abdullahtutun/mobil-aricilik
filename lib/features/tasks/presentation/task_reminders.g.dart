// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_reminders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Bildirim ve tam zamanlı alarm izinleri. İzin değişince (ör. sistem
/// ayarından dönünce) kurulu hatırlatmalar yeni duruma göre yeniden kurulur.

@ProviderFor(ReminderAccess)
final reminderAccessProvider = ReminderAccessProvider._();

/// Bildirim ve tam zamanlı alarm izinleri. İzin değişince (ör. sistem
/// ayarından dönünce) kurulu hatırlatmalar yeni duruma göre yeniden kurulur.
final class ReminderAccessProvider
    extends $AsyncNotifierProvider<ReminderAccess, ReminderAccessState> {
  /// Bildirim ve tam zamanlı alarm izinleri. İzin değişince (ör. sistem
  /// ayarından dönünce) kurulu hatırlatmalar yeni duruma göre yeniden kurulur.
  ReminderAccessProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reminderAccessProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reminderAccessHash();

  @$internal
  @override
  ReminderAccess create() => ReminderAccess();
}

String _$reminderAccessHash() => r'53c8ab5e8cfdd015fb3db96e7c500a1b2a4e4b9d';

/// Bildirim ve tam zamanlı alarm izinleri. İzin değişince (ör. sistem
/// ayarından dönünce) kurulu hatırlatmalar yeni duruma göre yeniden kurulur.

abstract class _$ReminderAccess extends $AsyncNotifier<ReminderAccessState> {
  FutureOr<ReminderAccessState> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<ReminderAccessState>, ReminderAccessState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ReminderAccessState>, ReminderAccessState>,
              AsyncValue<ReminderAccessState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Görev hatırlatmalarını yerel DB'den eşitler: bu telefonun kullanıcısına
/// atanmış ya da atanmamış açık görevlerin ([reminderPlan]) bildirimleri
/// kurulur, diğerleri kaldırılır. Senkronla gelen, tamamlanan, silinen ya
/// da günü değişen görev de kendiliğinden yansır; internet gerekmez.
/// Uygulama öne gelince izinler ve bildirimler yenilenir. Oturum ya da
/// işletme yoksa bütün bildirimler kalkar. `bootstrap` uygulama boyunca
/// dinler.

@ProviderFor(TaskReminders)
final taskRemindersProvider = TaskRemindersProvider._();

/// Görev hatırlatmalarını yerel DB'den eşitler: bu telefonun kullanıcısına
/// atanmış ya da atanmamış açık görevlerin ([reminderPlan]) bildirimleri
/// kurulur, diğerleri kaldırılır. Senkronla gelen, tamamlanan, silinen ya
/// da günü değişen görev de kendiliğinden yansır; internet gerekmez.
/// Uygulama öne gelince izinler ve bildirimler yenilenir. Oturum ya da
/// işletme yoksa bütün bildirimler kalkar. `bootstrap` uygulama boyunca
/// dinler.
final class TaskRemindersProvider
    extends $NotifierProvider<TaskReminders, void> {
  /// Görev hatırlatmalarını yerel DB'den eşitler: bu telefonun kullanıcısına
  /// atanmış ya da atanmamış açık görevlerin ([reminderPlan]) bildirimleri
  /// kurulur, diğerleri kaldırılır. Senkronla gelen, tamamlanan, silinen ya
  /// da günü değişen görev de kendiliğinden yansır; internet gerekmez.
  /// Uygulama öne gelince izinler ve bildirimler yenilenir. Oturum ya da
  /// işletme yoksa bütün bildirimler kalkar. `bootstrap` uygulama boyunca
  /// dinler.
  TaskRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'taskRemindersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$taskRemindersHash();

  @$internal
  @override
  TaskReminders create() => TaskReminders();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$taskRemindersHash() => r'fe22c1a9f28e24f163f6f05dc8257bf6b400aa70';

/// Görev hatırlatmalarını yerel DB'den eşitler: bu telefonun kullanıcısına
/// atanmış ya da atanmamış açık görevlerin ([reminderPlan]) bildirimleri
/// kurulur, diğerleri kaldırılır. Senkronla gelen, tamamlanan, silinen ya
/// da günü değişen görev de kendiliğinden yansır; internet gerekmez.
/// Uygulama öne gelince izinler ve bildirimler yenilenir. Oturum ya da
/// işletme yoksa bütün bildirimler kalkar. `bootstrap` uygulama boyunca
/// dinler.

abstract class _$TaskReminders extends $Notifier<void> {
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

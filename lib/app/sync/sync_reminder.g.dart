// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_reminder.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Gönderilemeyen kayıt hatırlatması: bekleyen en eski kayıttan
/// [syncOverdueAfter] sonra (gece düşerse 09:00'da) bu telefonda tek bir
/// bildirim kurulur ([syncReminderAt]). Kayıtlar gönderilince ya da
/// bekleyen kalmayınca bildirim kalkar; an geçtiyse kurulmaz, uyarı
/// Bugün'de görünür. İnternet gerekmez. Oturum ya da işletme yoksa bildirim
/// kalkar. `bootstrap` uygulama boyunca dinler.

@ProviderFor(SyncReminder)
final syncReminderProvider = SyncReminderProvider._();

/// Gönderilemeyen kayıt hatırlatması: bekleyen en eski kayıttan
/// [syncOverdueAfter] sonra (gece düşerse 09:00'da) bu telefonda tek bir
/// bildirim kurulur ([syncReminderAt]). Kayıtlar gönderilince ya da
/// bekleyen kalmayınca bildirim kalkar; an geçtiyse kurulmaz, uyarı
/// Bugün'de görünür. İnternet gerekmez. Oturum ya da işletme yoksa bildirim
/// kalkar. `bootstrap` uygulama boyunca dinler.
final class SyncReminderProvider extends $NotifierProvider<SyncReminder, void> {
  /// Gönderilemeyen kayıt hatırlatması: bekleyen en eski kayıttan
  /// [syncOverdueAfter] sonra (gece düşerse 09:00'da) bu telefonda tek bir
  /// bildirim kurulur ([syncReminderAt]). Kayıtlar gönderilince ya da
  /// bekleyen kalmayınca bildirim kalkar; an geçtiyse kurulmaz, uyarı
  /// Bugün'de görünür. İnternet gerekmez. Oturum ya da işletme yoksa bildirim
  /// kalkar. `bootstrap` uygulama boyunca dinler.
  SyncReminderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncReminderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncReminderHash();

  @$internal
  @override
  SyncReminder create() => SyncReminder();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncReminderHash() => r'd89a3f7fb2f7a5315a7b61c52f5b78825a41184c';

/// Gönderilemeyen kayıt hatırlatması: bekleyen en eski kayıttan
/// [syncOverdueAfter] sonra (gece düşerse 09:00'da) bu telefonda tek bir
/// bildirim kurulur ([syncReminderAt]). Kayıtlar gönderilince ya da
/// bekleyen kalmayınca bildirim kalkar; an geçtiyse kurulmaz, uyarı
/// Bugün'de görünür. İnternet gerekmez. Oturum ya da işletme yoksa bildirim
/// kalkar. `bootstrap` uygulama boyunca dinler.

abstract class _$SyncReminder extends $Notifier<void> {
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

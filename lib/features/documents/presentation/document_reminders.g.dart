// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_reminders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Belge süre dolumu hatırlatmalarını yerel DB'den eşitler: geçerlilik
/// tarihi olan her belgeye son günden 30, 7 ve 1 gün önce saat 09:00'da
/// bildirim ([documentReminderPlan]). Senkronla gelen, düzenlenen ya da
/// silinen belge de kendiliğinden yansır; internet gerekmez. Bildirim
/// izinleri değişince yeniden kurulur. Oturum ya da işletme yoksa belge
/// bildirimleri kalkar. `bootstrap` uygulama boyunca dinler.

@ProviderFor(DocumentReminders)
final documentRemindersProvider = DocumentRemindersProvider._();

/// Belge süre dolumu hatırlatmalarını yerel DB'den eşitler: geçerlilik
/// tarihi olan her belgeye son günden 30, 7 ve 1 gün önce saat 09:00'da
/// bildirim ([documentReminderPlan]). Senkronla gelen, düzenlenen ya da
/// silinen belge de kendiliğinden yansır; internet gerekmez. Bildirim
/// izinleri değişince yeniden kurulur. Oturum ya da işletme yoksa belge
/// bildirimleri kalkar. `bootstrap` uygulama boyunca dinler.
final class DocumentRemindersProvider
    extends $NotifierProvider<DocumentReminders, void> {
  /// Belge süre dolumu hatırlatmalarını yerel DB'den eşitler: geçerlilik
  /// tarihi olan her belgeye son günden 30, 7 ve 1 gün önce saat 09:00'da
  /// bildirim ([documentReminderPlan]). Senkronla gelen, düzenlenen ya da
  /// silinen belge de kendiliğinden yansır; internet gerekmez. Bildirim
  /// izinleri değişince yeniden kurulur. Oturum ya da işletme yoksa belge
  /// bildirimleri kalkar. `bootstrap` uygulama boyunca dinler.
  DocumentRemindersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentRemindersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentRemindersHash();

  @$internal
  @override
  DocumentReminders create() => DocumentReminders();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$documentRemindersHash() => r'1f9c1b7c6d0ae507671eefb2b6ae3f16c6c8d9f5';

/// Belge süre dolumu hatırlatmalarını yerel DB'den eşitler: geçerlilik
/// tarihi olan her belgeye son günden 30, 7 ve 1 gün önce saat 09:00'da
/// bildirim ([documentReminderPlan]). Senkronla gelen, düzenlenen ya da
/// silinen belge de kendiliğinden yansır; internet gerekmez. Bildirim
/// izinleri değişince yeniden kurulur. Oturum ya da işletme yoksa belge
/// bildirimleri kalkar. `bootstrap` uygulama boyunca dinler.

abstract class _$DocumentReminders extends $Notifier<void> {
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

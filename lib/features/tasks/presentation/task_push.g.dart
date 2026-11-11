// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_push.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(deviceTokenService)
final deviceTokenServiceProvider = DeviceTokenServiceProvider._();

/// Testler sahtesiyle override eder.

final class DeviceTokenServiceProvider
    extends
        $FunctionalProvider<
          DeviceTokenService,
          DeviceTokenService,
          DeviceTokenService
        >
    with $Provider<DeviceTokenService> {
  /// Testler sahtesiyle override eder.
  DeviceTokenServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceTokenServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceTokenServiceHash();

  @$internal
  @override
  $ProviderElement<DeviceTokenService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DeviceTokenService create(Ref ref) {
    return deviceTokenService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceTokenService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceTokenService>(value),
    );
  }
}

String _$deviceTokenServiceHash() =>
    r'77a730cc3738385bbd6ab2946f4693427f32bfc5';

/// Bu telefonun push token'ını sunucuya kaydeder: görev atanınca bildirim
/// buraya gelir. Oturum açıkken ve "Görev bildirimleri" açıkken çalışır;
/// bildirim izni telefonda bir kez sorulur. Token yenilenince yeniden
/// kaydedilir; arayüz dili değişince de (bildirim bu telefonun dilinde
/// gider). Çevrimdışı ya da başarısız kayıt sessizce geçilir, sonraki
/// açılışta yeniden denenir. `bootstrap` uygulama boyunca dinler.

@ProviderFor(PushRegistration)
final pushRegistrationProvider = PushRegistrationProvider._();

/// Bu telefonun push token'ını sunucuya kaydeder: görev atanınca bildirim
/// buraya gelir. Oturum açıkken ve "Görev bildirimleri" açıkken çalışır;
/// bildirim izni telefonda bir kez sorulur. Token yenilenince yeniden
/// kaydedilir; arayüz dili değişince de (bildirim bu telefonun dilinde
/// gider). Çevrimdışı ya da başarısız kayıt sessizce geçilir, sonraki
/// açılışta yeniden denenir. `bootstrap` uygulama boyunca dinler.
final class PushRegistrationProvider
    extends $NotifierProvider<PushRegistration, void> {
  /// Bu telefonun push token'ını sunucuya kaydeder: görev atanınca bildirim
  /// buraya gelir. Oturum açıkken ve "Görev bildirimleri" açıkken çalışır;
  /// bildirim izni telefonda bir kez sorulur. Token yenilenince yeniden
  /// kaydedilir; arayüz dili değişince de (bildirim bu telefonun dilinde
  /// gider). Çevrimdışı ya da başarısız kayıt sessizce geçilir, sonraki
  /// açılışta yeniden denenir. `bootstrap` uygulama boyunca dinler.
  PushRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushRegistrationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushRegistrationHash();

  @$internal
  @override
  PushRegistration create() => PushRegistration();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushRegistrationHash() => r'066eefb8c12f79a9faec2510797a7a5db6802e96';

/// Bu telefonun push token'ını sunucuya kaydeder: görev atanınca bildirim
/// buraya gelir. Oturum açıkken ve "Görev bildirimleri" açıkken çalışır;
/// bildirim izni telefonda bir kez sorulur. Token yenilenince yeniden
/// kaydedilir; arayüz dili değişince de (bildirim bu telefonun dilinde
/// gider). Çevrimdışı ya da başarısız kayıt sessizce geçilir, sonraki
/// açılışta yeniden denenir. `bootstrap` uygulama boyunca dinler.

abstract class _$PushRegistration extends $Notifier<void> {
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

/// Bildirime dokununca görevi açar: uygulama kapalıyken ya da arka
/// plandayken. `bootstrap` uygulama boyunca dinler.

@ProviderFor(pushTaskLinks)
final pushTaskLinksProvider = PushTaskLinksProvider._();

/// Bildirime dokununca görevi açar: uygulama kapalıyken ya da arka
/// plandayken. `bootstrap` uygulama boyunca dinler.

final class PushTaskLinksProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Bildirime dokununca görevi açar: uygulama kapalıyken ya da arka
  /// plandayken. `bootstrap` uygulama boyunca dinler.
  PushTaskLinksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushTaskLinksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushTaskLinksHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return pushTaskLinks(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$pushTaskLinksHash() => r'f4807f73bf9a9388d2948a3b64ad0718a1b9fa2e';

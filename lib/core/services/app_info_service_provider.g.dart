// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sabit bilgi veren sahteyle override eder.

@ProviderFor(appInfoService)
final appInfoServiceProvider = AppInfoServiceProvider._();

/// Testler sabit bilgi veren sahteyle override eder.

final class AppInfoServiceProvider
    extends $FunctionalProvider<AppInfoService, AppInfoService, AppInfoService>
    with $Provider<AppInfoService> {
  /// Testler sabit bilgi veren sahteyle override eder.
  AppInfoServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appInfoServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appInfoServiceHash();

  @$internal
  @override
  $ProviderElement<AppInfoService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AppInfoService create(Ref ref) {
    return appInfoService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppInfoService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppInfoService>(value),
    );
  }
}

String _$appInfoServiceHash() => r'5c089ffb347bc95887ba6d337350070f17dcf7b5';

/// Ayarların altında gösterilen sürüm (`1.0.0+1`).

@ProviderFor(appVersion)
final appVersionProvider = AppVersionProvider._();

/// Ayarların altında gösterilen sürüm (`1.0.0+1`).

final class AppVersionProvider
    extends $FunctionalProvider<AsyncValue<String>, String, FutureOr<String>>
    with $FutureModifier<String>, $FutureProvider<String> {
  /// Ayarların altında gösterilen sürüm (`1.0.0+1`).
  AppVersionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appVersionProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appVersionHash();

  @$internal
  @override
  $FutureProviderElement<String> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String> create(Ref ref) {
    return appVersion(ref);
  }
}

String _$appVersionHash() => r'84316fdce65a5c068519e408dd05574aa4b42357';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'basemap_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler ağsız altlıkla override eder.

@ProviderFor(basemapService)
final basemapServiceProvider = BasemapServiceProvider._();

/// Testler ağsız altlıkla override eder.

final class BasemapServiceProvider
    extends $FunctionalProvider<BasemapService, BasemapService, BasemapService>
    with $Provider<BasemapService> {
  /// Testler ağsız altlıkla override eder.
  BasemapServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'basemapServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basemapServiceHash();

  @$internal
  @override
  $ProviderElement<BasemapService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BasemapService create(Ref ref) {
    return basemapService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BasemapService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BasemapService>(value),
    );
  }
}

String _$basemapServiceHash() => r'5b3f254ca0e26883dc22927ff89d0f358baaed02';

/// Altlık uygulama açık kaldıkça bir kez okunur. Hata kendiliğinden yeniden
/// denenmez; ekran "Yeniden dene" ile ya da haritaya yeniden geçince
/// yeniler.

@ProviderFor(basemap)
final basemapProvider = BasemapProvider._();

/// Altlık uygulama açık kaldıkça bir kez okunur. Hata kendiliğinden yeniden
/// denenmez; ekran "Yeniden dene" ile ya da haritaya yeniden geçince
/// yeniler.

final class BasemapProvider
    extends $FunctionalProvider<AsyncValue<Basemap>, Basemap, FutureOr<Basemap>>
    with $FutureModifier<Basemap>, $FutureProvider<Basemap> {
  /// Altlık uygulama açık kaldıkça bir kez okunur. Hata kendiliğinden yeniden
  /// denenmez; ekran "Yeniden dene" ile ya da haritaya yeniden geçince
  /// yeniler.
  BasemapProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'basemapProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$basemapHash();

  @$internal
  @override
  $FutureProviderElement<Basemap> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Basemap> create(Ref ref) {
    return basemap(ref);
  }
}

String _$basemapHash() => r'c198a765e7599657b9bc501e779cef2f9fbff1a8';

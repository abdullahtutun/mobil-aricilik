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

/// İndirilmiş arılık çevrelerinden altlık; testler override eder.

@ProviderFor(offlineBasemapService)
final offlineBasemapServiceProvider = OfflineBasemapServiceProvider._();

/// İndirilmiş arılık çevrelerinden altlık; testler override eder.

final class OfflineBasemapServiceProvider
    extends
        $FunctionalProvider<
          OfflineBasemapService,
          OfflineBasemapService,
          OfflineBasemapService
        >
    with $Provider<OfflineBasemapService> {
  /// İndirilmiş arılık çevrelerinden altlık; testler override eder.
  OfflineBasemapServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'offlineBasemapServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$offlineBasemapServiceHash();

  @$internal
  @override
  $ProviderElement<OfflineBasemapService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OfflineBasemapService create(Ref ref) {
    return offlineBasemapService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OfflineBasemapService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OfflineBasemapService>(value),
    );
  }
}

String _$offlineBasemapServiceHash() =>
    r'7e2e074111f1db503240c62e336cf0e7df5d7647';

/// Altlık uygulama açık kaldıkça bir kez okunur. Ağdan okunamazsa
/// indirilmiş arılık çevrelerinden açılır; o da yoksa [BasemapUnavailable].
/// Hata kendiliğinden yeniden denenmez; ekran "Yeniden dene" ile ya da
/// haritaya yeniden geçince yeniler. Alan inince ya da silinince
/// internetsiz altlık yeniden okunur.

@ProviderFor(basemap)
final basemapProvider = BasemapProvider._();

/// Altlık uygulama açık kaldıkça bir kez okunur. Ağdan okunamazsa
/// indirilmiş arılık çevrelerinden açılır; o da yoksa [BasemapUnavailable].
/// Hata kendiliğinden yeniden denenmez; ekran "Yeniden dene" ile ya da
/// haritaya yeniden geçince yeniler. Alan inince ya da silinince
/// internetsiz altlık yeniden okunur.

final class BasemapProvider
    extends $FunctionalProvider<AsyncValue<Basemap>, Basemap, FutureOr<Basemap>>
    with $FutureModifier<Basemap>, $FutureProvider<Basemap> {
  /// Altlık uygulama açık kaldıkça bir kez okunur. Ağdan okunamazsa
  /// indirilmiş arılık çevrelerinden açılır; o da yoksa [BasemapUnavailable].
  /// Hata kendiliğinden yeniden denenmez; ekran "Yeniden dene" ile ya da
  /// haritaya yeniden geçince yeniler. Alan inince ya da silinince
  /// internetsiz altlık yeniden okunur.
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

String _$basemapHash() => r'a36e2e32907ca93214ee59e531dfedbf48de7f89';

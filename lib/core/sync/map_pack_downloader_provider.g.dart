// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_pack_downloader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek harita paketi indiricisi; testler sahte HTTP ile
/// override eder.

@ProviderFor(mapPackDownloader)
final mapPackDownloaderProvider = MapPackDownloaderProvider._();

/// Uygulamadaki tek harita paketi indiricisi; testler sahte HTTP ile
/// override eder.

final class MapPackDownloaderProvider
    extends
        $FunctionalProvider<
          MapPackDownloader,
          MapPackDownloader,
          MapPackDownloader
        >
    with $Provider<MapPackDownloader> {
  /// Uygulamadaki tek harita paketi indiricisi; testler sahte HTTP ile
  /// override eder.
  MapPackDownloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapPackDownloaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPackDownloaderHash();

  @$internal
  @override
  $ProviderElement<MapPackDownloader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MapPackDownloader create(Ref ref) {
    return mapPackDownloader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapPackDownloader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapPackDownloader>(value),
    );
  }
}

String _$mapPackDownloaderHash() => r'5d33ee5ca3198798bbd11233308b4c34361898c7';

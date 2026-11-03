// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_area_downloader_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek harita alanı indiricisi; testler sahte HTTP ile
/// override eder.

@ProviderFor(mapAreaDownloader)
final mapAreaDownloaderProvider = MapAreaDownloaderProvider._();

/// Uygulamadaki tek harita alanı indiricisi; testler sahte HTTP ile
/// override eder.

final class MapAreaDownloaderProvider
    extends
        $FunctionalProvider<
          MapAreaDownloader,
          MapAreaDownloader,
          MapAreaDownloader
        >
    with $Provider<MapAreaDownloader> {
  /// Uygulamadaki tek harita alanı indiricisi; testler sahte HTTP ile
  /// override eder.
  MapAreaDownloaderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapAreaDownloaderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapAreaDownloaderHash();

  @$internal
  @override
  $ProviderElement<MapAreaDownloader> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MapAreaDownloader create(Ref ref) {
    return mapAreaDownloader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapAreaDownloader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapAreaDownloader>(value),
    );
  }
}

String _$mapAreaDownloaderHash() => r'019af378e6c4c0bc87e54bea31887fb4c959fe75';

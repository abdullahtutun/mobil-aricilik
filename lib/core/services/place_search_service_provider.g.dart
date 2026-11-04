// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'place_search_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Haritada yer araması; testler ağsız sahteyle override eder.

@ProviderFor(placeSearchService)
final placeSearchServiceProvider = PlaceSearchServiceProvider._();

/// Haritada yer araması; testler ağsız sahteyle override eder.

final class PlaceSearchServiceProvider
    extends
        $FunctionalProvider<
          PlaceSearchService,
          PlaceSearchService,
          PlaceSearchService
        >
    with $Provider<PlaceSearchService> {
  /// Haritada yer araması; testler ağsız sahteyle override eder.
  PlaceSearchServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'placeSearchServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$placeSearchServiceHash();

  @$internal
  @override
  $ProviderElement<PlaceSearchService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlaceSearchService create(Ref ref) {
    return placeSearchService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlaceSearchService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlaceSearchService>(value),
    );
  }
}

String _$placeSearchServiceHash() =>
    r'b669d9785924148b2c4609750bbb07f2693926a6';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'directions_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler cihazsız sahteyle override eder.

@ProviderFor(directionsService)
final directionsServiceProvider = DirectionsServiceProvider._();

/// Testler cihazsız sahteyle override eder.

final class DirectionsServiceProvider
    extends
        $FunctionalProvider<
          DirectionsService,
          DirectionsService,
          DirectionsService
        >
    with $Provider<DirectionsService> {
  /// Testler cihazsız sahteyle override eder.
  DirectionsServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'directionsServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$directionsServiceHash();

  @$internal
  @override
  $ProviderElement<DirectionsService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DirectionsService create(Ref ref) {
    return directionsService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DirectionsService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DirectionsService>(value),
    );
  }
}

String _$directionsServiceHash() => r'ee5a542ef04d2d09a004878d2c80d2fde6e7f599';

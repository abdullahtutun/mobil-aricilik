// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'flavor.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
/// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.

@ProviderFor(flavor)
final flavorProvider = FlavorProvider._();

/// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
/// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.

final class FlavorProvider extends $FunctionalProvider<Flavor, Flavor, Flavor>
    with $Provider<Flavor> {
  /// Çalışan flavor. `bootstrap` gerçek değerle override eder; override
  /// edilmezse (ör. testlerde) geliştirici araçları kapalı kalsın diye prod.
  FlavorProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'flavorProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$flavorHash();

  @$internal
  @override
  $ProviderElement<Flavor> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Flavor create(Ref ref) {
    return flavor(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Flavor value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Flavor>(value),
    );
  }
}

String _$flavorHash() => r'c3c6739adc0e2d6b51d2f700da1c7219e281b92f';

/// PocketBase sunucusunun adresi ([resolvePocketbaseUrl]).

@ProviderFor(pocketbaseUrl)
final pocketbaseUrlProvider = PocketbaseUrlProvider._();

/// PocketBase sunucusunun adresi ([resolvePocketbaseUrl]).

final class PocketbaseUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// PocketBase sunucusunun adresi ([resolvePocketbaseUrl]).
  PocketbaseUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pocketbaseUrlProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pocketbaseUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return pocketbaseUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$pocketbaseUrlHash() => r'e058e39884d91e5884a2614cd141f748b196dd88';

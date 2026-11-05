// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ekranların dinlediği işletme türü yapılandırması. Tür yerel işletme
/// satırından gelir (profilde değişince hemen uygulanır); satır henüz
/// inmemişse cihazdaki işletme kopyasından, o da yoksa gezginci (hiçbir
/// şey gizlenmez).

@ProviderFor(businessConfig)
final businessConfigProvider = BusinessConfigProvider._();

/// Ekranların dinlediği işletme türü yapılandırması. Tür yerel işletme
/// satırından gelir (profilde değişince hemen uygulanır); satır henüz
/// inmemişse cihazdaki işletme kopyasından, o da yoksa gezginci (hiçbir
/// şey gizlenmez).

final class BusinessConfigProvider
    extends $FunctionalProvider<BusinessConfig, BusinessConfig, BusinessConfig>
    with $Provider<BusinessConfig> {
  /// Ekranların dinlediği işletme türü yapılandırması. Tür yerel işletme
  /// satırından gelir (profilde değişince hemen uygulanır); satır henüz
  /// inmemişse cihazdaki işletme kopyasından, o da yoksa gezginci (hiçbir
  /// şey gizlenmez).
  BusinessConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'businessConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$businessConfigHash();

  @$internal
  @override
  $ProviderElement<BusinessConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BusinessConfig create(Ref ref) {
    return businessConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BusinessConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BusinessConfig>(value),
    );
  }
}

String _$businessConfigHash() => r'cc311fd3c3ee958b3228a892c9f8a819457bd2fb';

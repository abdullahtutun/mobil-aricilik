// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kullanım olaylarını yazan tek giriş; ekranlar ve controller'lar olayı
/// buradan kaydeder.

@ProviderFor(analyticsRepository)
final analyticsRepositoryProvider = AnalyticsRepositoryProvider._();

/// Kullanım olaylarını yazan tek giriş; ekranlar ve controller'lar olayı
/// buradan kaydeder.

final class AnalyticsRepositoryProvider
    extends
        $FunctionalProvider<
          AnalyticsRepository,
          AnalyticsRepository,
          AnalyticsRepository
        >
    with $Provider<AnalyticsRepository> {
  /// Kullanım olaylarını yazan tek giriş; ekranlar ve controller'lar olayı
  /// buradan kaydeder.
  AnalyticsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsRepositoryHash();

  @$internal
  @override
  $ProviderElement<AnalyticsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AnalyticsRepository create(Ref ref) {
    return analyticsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AnalyticsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AnalyticsRepository>(value),
    );
  }
}

String _$analyticsRepositoryHash() =>
    r'56ce627038a70d81fde83fd7f21b562e35d8fedd';

/// "Kullanım verisi paylaş" (bu telefonun ayarı).

@ProviderFor(analyticsEnabled)
final analyticsEnabledProvider = AnalyticsEnabledProvider._();

/// "Kullanım verisi paylaş" (bu telefonun ayarı).

final class AnalyticsEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// "Kullanım verisi paylaş" (bu telefonun ayarı).
  AnalyticsEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analyticsEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analyticsEnabledHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return analyticsEnabled(ref);
  }
}

String _$analyticsEnabledHash() => r'd3d509cbcce795204222311199e953cb668c54a4';

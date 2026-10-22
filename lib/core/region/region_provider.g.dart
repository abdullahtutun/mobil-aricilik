// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Enlem seçimi. Şimdilik bellekte; ileride arılığın konumundan gelecek.
/// Ekranlar bunu değil [regionConfigProvider]'ı dinler.

@ProviderFor(RegionSelection)
final regionSelectionProvider = RegionSelectionProvider._();

/// Enlem seçimi. Şimdilik bellekte; ileride arılığın konumundan gelecek.
/// Ekranlar bunu değil [regionConfigProvider]'ı dinler.
final class RegionSelectionProvider
    extends $NotifierProvider<RegionSelection, RegionSettings> {
  /// Enlem seçimi. Şimdilik bellekte; ileride arılığın konumundan gelecek.
  /// Ekranlar bunu değil [regionConfigProvider]'ı dinler.
  RegionSelectionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regionSelectionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regionSelectionHash();

  @$internal
  @override
  RegionSelection create() => RegionSelection();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegionSettings value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegionSettings>(value),
    );
  }
}

String _$regionSelectionHash() => r'ea79e7fba1d9a72b3c6f79349ca72943210b6095';

/// Enlem seçimi. Şimdilik bellekte; ileride arılığın konumundan gelecek.
/// Ekranlar bunu değil [regionConfigProvider]'ı dinler.

abstract class _$RegionSelection extends $Notifier<RegionSettings> {
  RegionSettings build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<RegionSettings, RegionSettings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<RegionSettings, RegionSettings>,
              RegionSettings,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Ekranların dinlediği bölge yapılandırması. Ülke işletmeden gelir; işletme
/// yokken [defaultCountryCode] kullanılır. Türkiye'ye özel modüller
/// [RegionConfig.features] ile açılıp kapanır.

@ProviderFor(regionConfig)
final regionConfigProvider = RegionConfigProvider._();

/// Ekranların dinlediği bölge yapılandırması. Ülke işletmeden gelir; işletme
/// yokken [defaultCountryCode] kullanılır. Türkiye'ye özel modüller
/// [RegionConfig.features] ile açılıp kapanır.

final class RegionConfigProvider
    extends $FunctionalProvider<RegionConfig, RegionConfig, RegionConfig>
    with $Provider<RegionConfig> {
  /// Ekranların dinlediği bölge yapılandırması. Ülke işletmeden gelir; işletme
  /// yokken [defaultCountryCode] kullanılır. Türkiye'ye özel modüller
  /// [RegionConfig.features] ile açılıp kapanır.
  RegionConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'regionConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$regionConfigHash();

  @$internal
  @override
  $ProviderElement<RegionConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RegionConfig create(Ref ref) {
    return regionConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RegionConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RegionConfig>(value),
    );
  }
}

String _$regionConfigHash() => r'c3593eecbde51ba85084b1f7fd46d9e047221b73';

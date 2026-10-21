// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'region_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ülke ve enlem seçimi. Şimdilik bellekte; kalıcı kayıt ve seçici arayüz
/// ayarlar adımında gelecek. Ekranlar bunu değil [regionConfigProvider]'ı
/// dinler.

@ProviderFor(RegionSelection)
final regionSelectionProvider = RegionSelectionProvider._();

/// Ülke ve enlem seçimi. Şimdilik bellekte; kalıcı kayıt ve seçici arayüz
/// ayarlar adımında gelecek. Ekranlar bunu değil [regionConfigProvider]'ı
/// dinler.
final class RegionSelectionProvider
    extends $NotifierProvider<RegionSelection, RegionSettings> {
  /// Ülke ve enlem seçimi. Şimdilik bellekte; kalıcı kayıt ve seçici arayüz
  /// ayarlar adımında gelecek. Ekranlar bunu değil [regionConfigProvider]'ı
  /// dinler.
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

String _$regionSelectionHash() => r'ea7ec2bf8102e50c4e550fadac9c768b5f8e5cf4';

/// Ülke ve enlem seçimi. Şimdilik bellekte; kalıcı kayıt ve seçici arayüz
/// ayarlar adımında gelecek. Ekranlar bunu değil [regionConfigProvider]'ı
/// dinler.

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

/// Ekranların dinlediği bölge yapılandırması. Türkiye'ye özel modüller
/// [RegionConfig.features] ile açılıp kapanır.

@ProviderFor(regionConfig)
final regionConfigProvider = RegionConfigProvider._();

/// Ekranların dinlediği bölge yapılandırması. Türkiye'ye özel modüller
/// [RegionConfig.features] ile açılıp kapanır.

final class RegionConfigProvider
    extends $FunctionalProvider<RegionConfig, RegionConfig, RegionConfig>
    with $Provider<RegionConfig> {
  /// Ekranların dinlediği bölge yapılandırması. Türkiye'ye özel modüller
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

String _$regionConfigHash() => r'3cc2543ed64e29d00b948336236703e3c04d208e';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(localSettingsRepository)
final localSettingsRepositoryProvider = LocalSettingsRepositoryProvider._();

final class LocalSettingsRepositoryProvider
    extends
        $FunctionalProvider<
          LocalSettingsRepository,
          LocalSettingsRepository,
          LocalSettingsRepository
        >
    with $Provider<LocalSettingsRepository> {
  LocalSettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localSettingsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localSettingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<LocalSettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  LocalSettingsRepository create(Ref ref) {
    return localSettingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalSettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalSettingsRepository>(value),
    );
  }
}

String _$localSettingsRepositoryHash() =>
    r'afefbf7d190fd255cdfc4089e89f7ee22718d548';

/// "Fotoğrafları sadece Wi‑Fi'da yükle".

@ProviderFor(mediaWifiOnly)
final mediaWifiOnlyProvider = MediaWifiOnlyProvider._();

/// "Fotoğrafları sadece Wi‑Fi'da yükle".

final class MediaWifiOnlyProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// "Fotoğrafları sadece Wi‑Fi'da yükle".
  MediaWifiOnlyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaWifiOnlyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaWifiOnlyHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return mediaWifiOnly(ref);
  }
}

String _$mediaWifiOnlyHash() => r'857837556216810395de7759865cba36de9cac47';

/// Varroa uyarı eşikleri (bu telefonun ayarı).

@ProviderFor(varroaThresholds)
final varroaThresholdsProvider = VarroaThresholdsProvider._();

/// Varroa uyarı eşikleri (bu telefonun ayarı).

final class VarroaThresholdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<VarroaThresholds>,
          VarroaThresholds,
          Stream<VarroaThresholds>
        >
    with $FutureModifier<VarroaThresholds>, $StreamProvider<VarroaThresholds> {
  /// Varroa uyarı eşikleri (bu telefonun ayarı).
  VarroaThresholdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'varroaThresholdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$varroaThresholdsHash();

  @$internal
  @override
  $StreamProviderElement<VarroaThresholds> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VarroaThresholds> create(Ref ref) {
    return varroaThresholds(ref);
  }
}

String _$varroaThresholdsHash() => r'f86a5bfc69ac8abdfde3f08a3395811284beecb8';

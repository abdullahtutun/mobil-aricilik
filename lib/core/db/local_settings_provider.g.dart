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

/// "Sadece Wi‑Fi'da indir" (offline harita paketleri).

@ProviderFor(mapWifiOnly)
final mapWifiOnlyProvider = MapWifiOnlyProvider._();

/// "Sadece Wi‑Fi'da indir" (offline harita paketleri).

final class MapWifiOnlyProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// "Sadece Wi‑Fi'da indir" (offline harita paketleri).
  MapWifiOnlyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapWifiOnlyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapWifiOnlyHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return mapWifiOnly(ref);
  }
}

String _$mapWifiOnlyHash() => r'e7bf1746da0fccde3d4e1db18a3c861b692e53e8';

/// "Görev bildirimleri" (push).

@ProviderFor(pushEnabled)
final pushEnabledProvider = PushEnabledProvider._();

/// "Görev bildirimleri" (push).

final class PushEnabledProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// "Görev bildirimleri" (push).
  PushEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pushEnabledProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pushEnabledHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return pushEnabled(ref);
  }
}

String _$pushEnabledHash() => r'5ea7eb73961aef5e633524ce9399f7811da56c63';

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

/// Kovan açma eşikleri (bu telefonun ayarı).

@ProviderFor(hiveOpeningThresholds)
final hiveOpeningThresholdsProvider = HiveOpeningThresholdsProvider._();

/// Kovan açma eşikleri (bu telefonun ayarı).

final class HiveOpeningThresholdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<HiveOpeningThresholds>,
          HiveOpeningThresholds,
          Stream<HiveOpeningThresholds>
        >
    with
        $FutureModifier<HiveOpeningThresholds>,
        $StreamProvider<HiveOpeningThresholds> {
  /// Kovan açma eşikleri (bu telefonun ayarı).
  HiveOpeningThresholdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveOpeningThresholdsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveOpeningThresholdsHash();

  @$internal
  @override
  $StreamProviderElement<HiveOpeningThresholds> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<HiveOpeningThresholds> create(Ref ref) {
    return hiveOpeningThresholds(ref);
  }
}

String _$hiveOpeningThresholdsHash() =>
    r'bd22058cb234d162adc68533be166965dae161fe';

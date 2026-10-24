// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_services_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler geçici klasörle override eder.

@ProviderFor(mediaFileStore)
final mediaFileStoreProvider = MediaFileStoreProvider._();

/// Testler geçici klasörle override eder.

final class MediaFileStoreProvider
    extends $FunctionalProvider<MediaFileStore, MediaFileStore, MediaFileStore>
    with $Provider<MediaFileStore> {
  /// Testler geçici klasörle override eder.
  MediaFileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaFileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaFileStoreHash();

  @$internal
  @override
  $ProviderElement<MediaFileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaFileStore create(Ref ref) {
    return mediaFileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaFileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaFileStore>(value),
    );
  }
}

String _$mediaFileStoreHash() => r'abfaa79ce6c6c0b410a9ad7c3b8839afceabe11a';

/// Testler sahte kamerayla override eder.

@ProviderFor(cameraService)
final cameraServiceProvider = CameraServiceProvider._();

/// Testler sahte kamerayla override eder.

final class CameraServiceProvider
    extends $FunctionalProvider<CameraService, CameraService, CameraService>
    with $Provider<CameraService> {
  /// Testler sahte kamerayla override eder.
  CameraServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cameraServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cameraServiceHash();

  @$internal
  @override
  $ProviderElement<CameraService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CameraService create(Ref ref) {
    return cameraService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CameraService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CameraService>(value),
    );
  }
}

String _$cameraServiceHash() => r'a5289f386e0c962d91436f1ffac25b2c81ee3e69';

/// Testler sahte kayıtçıyla override eder.

@ProviderFor(voiceRecorder)
final voiceRecorderProvider = VoiceRecorderProvider._();

/// Testler sahte kayıtçıyla override eder.

final class VoiceRecorderProvider
    extends $FunctionalProvider<VoiceRecorder, VoiceRecorder, VoiceRecorder>
    with $Provider<VoiceRecorder> {
  /// Testler sahte kayıtçıyla override eder.
  VoiceRecorderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voiceRecorderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voiceRecorderHash();

  @$internal
  @override
  $ProviderElement<VoiceRecorder> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VoiceRecorder create(Ref ref) {
    return voiceRecorder(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoiceRecorder value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoiceRecorder>(value),
    );
  }
}

String _$voiceRecorderHash() => r'd075146ecf4930eabcf7338388e7f3103470a573';

/// Testler sahte çalarla override eder.

@ProviderFor(voicePlayer)
final voicePlayerProvider = VoicePlayerProvider._();

/// Testler sahte çalarla override eder.

final class VoicePlayerProvider
    extends $FunctionalProvider<VoicePlayer, VoicePlayer, VoicePlayer>
    with $Provider<VoicePlayer> {
  /// Testler sahte çalarla override eder.
  VoicePlayerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'voicePlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$voicePlayerHash();

  @$internal
  @override
  $ProviderElement<VoicePlayer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  VoicePlayer create(Ref ref) {
    return voicePlayer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(VoicePlayer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<VoicePlayer>(value),
    );
  }
}

String _$voicePlayerHash() => r'6cd06b5f23a291427b3b1b03c5a335627171fa8a';

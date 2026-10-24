// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek medya yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

@ProviderFor(mediaSyncService)
final mediaSyncServiceProvider = MediaSyncServiceProvider._();

/// Uygulamadaki tek medya yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

final class MediaSyncServiceProvider
    extends
        $FunctionalProvider<
          MediaSyncService,
          MediaSyncService,
          MediaSyncService
        >
    with $Provider<MediaSyncService> {
  /// Uygulamadaki tek medya yükleyicisi; kilit bu örneğe bağlı olduğu için
  /// canlı tutulur.
  MediaSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaSyncServiceHash();

  @$internal
  @override
  $ProviderElement<MediaSyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaSyncService create(Ref ref) {
    return mediaSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaSyncService>(value),
    );
  }
}

String _$mediaSyncServiceHash() => r'9ff6b119921e7e78771ab4950446324c1377e7c1';

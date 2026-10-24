// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_upload_scheduler.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler planları kaydeden sahteyle override eder.

@ProviderFor(mediaUploadScheduler)
final mediaUploadSchedulerProvider = MediaUploadSchedulerProvider._();

/// Testler planları kaydeden sahteyle override eder.

final class MediaUploadSchedulerProvider
    extends
        $FunctionalProvider<
          MediaUploadScheduler,
          MediaUploadScheduler,
          MediaUploadScheduler
        >
    with $Provider<MediaUploadScheduler> {
  /// Testler planları kaydeden sahteyle override eder.
  MediaUploadSchedulerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaUploadSchedulerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaUploadSchedulerHash();

  @$internal
  @override
  $ProviderElement<MediaUploadScheduler> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MediaUploadScheduler create(Ref ref) {
    return mediaUploadScheduler(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaUploadScheduler value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaUploadScheduler>(value),
    );
  }
}

String _$mediaUploadSchedulerHash() =>
    r'98ba7f221bcf36ac4dc139bf1e030d10fb25ea5b';

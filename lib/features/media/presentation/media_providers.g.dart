// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mediaRepository)
final mediaRepositoryProvider = MediaRepositoryProvider._();

final class MediaRepositoryProvider
    extends
        $FunctionalProvider<MediaRepository, MediaRepository, MediaRepository>
    with $Provider<MediaRepository> {
  MediaRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaRepositoryHash();

  @$internal
  @override
  $ProviderElement<MediaRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaRepository create(Ref ref) {
    return mediaRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaRepository>(value),
    );
  }
}

String _$mediaRepositoryHash() => r'fa39f1dd573052190483a0a4a69a71b0f01ff253';

/// Kovanın foto ve sesli notları, çekilme sırasıyla.

@ProviderFor(hiveMedia)
final hiveMediaProvider = HiveMediaFamily._();

/// Kovanın foto ve sesli notları, çekilme sırasıyla.

final class HiveMediaProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MediaItem>>,
          List<MediaItem>,
          Stream<List<MediaItem>>
        >
    with $FutureModifier<List<MediaItem>>, $StreamProvider<List<MediaItem>> {
  /// Kovanın foto ve sesli notları, çekilme sırasıyla.
  HiveMediaProvider._({
    required HiveMediaFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveMediaProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveMediaHash();

  @override
  String toString() {
    return r'hiveMediaProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MediaItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MediaItem>> create(Ref ref) {
    final argument = this.argument as String;
    return hiveMedia(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveMediaProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveMediaHash() => r'e8b4cb9d0f742b09c1fdede2f18f694abd0bf3ce';

/// Kovanın foto ve sesli notları, çekilme sırasıyla.

final class HiveMediaFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MediaItem>>, String> {
  HiveMediaFamily._()
    : super(
        retry: null,
        name: r'hiveMediaProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın foto ve sesli notları, çekilme sırasıyla.

  HiveMediaProvider call(String hiveId) =>
      HiveMediaProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveMediaProvider';
}

/// Yüklenmeyi bekleyen dosya sayısı (Ayarlar).

@ProviderFor(pendingMediaUploads)
final pendingMediaUploadsProvider = PendingMediaUploadsProvider._();

/// Yüklenmeyi bekleyen dosya sayısı (Ayarlar).

final class PendingMediaUploadsProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Yüklenmeyi bekleyen dosya sayısı (Ayarlar).
  PendingMediaUploadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingMediaUploadsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingMediaUploadsHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return pendingMediaUploads(ref);
  }
}

String _$pendingMediaUploadsHash() =>
    r'57c262e8e188f6a2d782e32960c5eec67c9edf41';

/// Medya kaydı; yoksa ya da silindiyse null.

@ProviderFor(mediaItem)
final mediaItemProvider = MediaItemFamily._();

/// Medya kaydı; yoksa ya da silindiyse null.

final class MediaItemProvider
    extends
        $FunctionalProvider<
          AsyncValue<MediaItem?>,
          MediaItem?,
          Stream<MediaItem?>
        >
    with $FutureModifier<MediaItem?>, $StreamProvider<MediaItem?> {
  /// Medya kaydı; yoksa ya da silindiyse null.
  MediaItemProvider._({
    required MediaItemFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'mediaItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mediaItemHash();

  @override
  String toString() {
    return r'mediaItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<MediaItem?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<MediaItem?> create(Ref ref) {
    final argument = this.argument as String;
    return mediaItem(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MediaItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mediaItemHash() => r'88ea59189fcb1c890a040ee289d6c50590f8a746';

/// Medya kaydı; yoksa ya da silindiyse null.

final class MediaItemFamily extends $Family
    with $FunctionalFamilyOverride<Stream<MediaItem?>, String> {
  MediaItemFamily._()
    : super(
        retry: null,
        name: r'mediaItemProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Medya kaydı; yoksa ya da silindiyse null.

  MediaItemProvider call(String mediaId) =>
      MediaItemProvider._(argument: mediaId, from: this);

  @override
  String toString() => r'mediaItemProvider';
}

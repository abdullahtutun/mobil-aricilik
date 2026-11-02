// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'knowledge_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// İndirilen paketin klasörü; testler geçici klasörle override eder.

@ProviderFor(knowledgeFileStore)
final knowledgeFileStoreProvider = KnowledgeFileStoreProvider._();

/// İndirilen paketin klasörü; testler geçici klasörle override eder.

final class KnowledgeFileStoreProvider
    extends $FunctionalProvider<MediaFileStore, MediaFileStore, MediaFileStore>
    with $Provider<MediaFileStore> {
  /// İndirilen paketin klasörü; testler geçici klasörle override eder.
  KnowledgeFileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeFileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeFileStoreHash();

  @$internal
  @override
  $ProviderElement<MediaFileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaFileStore create(Ref ref) {
    return knowledgeFileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaFileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaFileStore>(value),
    );
  }
}

String _$knowledgeFileStoreHash() =>
    r'71d6e43f96377e186a3ec169c085710b8cfd3bd8';

@ProviderFor(knowledgeRepository)
final knowledgeRepositoryProvider = KnowledgeRepositoryProvider._();

final class KnowledgeRepositoryProvider
    extends
        $FunctionalProvider<
          KnowledgeRepository,
          KnowledgeRepository,
          KnowledgeRepository
        >
    with $Provider<KnowledgeRepository> {
  KnowledgeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeRepositoryHash();

  @$internal
  @override
  $ProviderElement<KnowledgeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  KnowledgeRepository create(Ref ref) {
    return knowledgeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(KnowledgeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<KnowledgeRepository>(value),
    );
  }
}

String _$knowledgeRepositoryHash() =>
    r'3f35013e25c24e3b38b2a89c14f61721c6f76364';

/// Okunan içerik sürümü; yeni paket inince yeniden okunur.

@ProviderFor(knowledgeLibrary)
final knowledgeLibraryProvider = KnowledgeLibraryProvider._();

/// Okunan içerik sürümü; yeni paket inince yeniden okunur.

final class KnowledgeLibraryProvider
    extends
        $FunctionalProvider<
          AsyncValue<KnowledgeLibrary>,
          KnowledgeLibrary,
          FutureOr<KnowledgeLibrary>
        >
    with $FutureModifier<KnowledgeLibrary>, $FutureProvider<KnowledgeLibrary> {
  /// Okunan içerik sürümü; yeni paket inince yeniden okunur.
  KnowledgeLibraryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeLibraryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeLibraryHash();

  @$internal
  @override
  $FutureProviderElement<KnowledgeLibrary> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<KnowledgeLibrary> create(Ref ref) {
    return knowledgeLibrary(ref);
  }
}

String _$knowledgeLibraryHash() => r'd54a2266f8ac2b103dec4177c52dde117ee53773';

/// [language]'deki ve bölgede görünen makaleler, başlık sırasıyla.

@ProviderFor(knowledgeArticles)
final knowledgeArticlesProvider = KnowledgeArticlesFamily._();

/// [language]'deki ve bölgede görünen makaleler, başlık sırasıyla.

final class KnowledgeArticlesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<KnowledgeArticle>>,
          List<KnowledgeArticle>,
          FutureOr<List<KnowledgeArticle>>
        >
    with
        $FutureModifier<List<KnowledgeArticle>>,
        $FutureProvider<List<KnowledgeArticle>> {
  /// [language]'deki ve bölgede görünen makaleler, başlık sırasıyla.
  KnowledgeArticlesProvider._({
    required KnowledgeArticlesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'knowledgeArticlesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$knowledgeArticlesHash();

  @override
  String toString() {
    return r'knowledgeArticlesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<KnowledgeArticle>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<KnowledgeArticle>> create(Ref ref) {
    final argument = this.argument as String;
    return knowledgeArticles(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is KnowledgeArticlesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$knowledgeArticlesHash() => r'71ba2781f4f31836f23f44a3335947379108fb48';

/// [language]'deki ve bölgede görünen makaleler, başlık sırasıyla.

final class KnowledgeArticlesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<KnowledgeArticle>>, String> {
  KnowledgeArticlesFamily._()
    : super(
        retry: null,
        name: r'knowledgeArticlesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [language]'deki ve bölgede görünen makaleler, başlık sırasıyla.

  KnowledgeArticlesProvider call(String language) =>
      KnowledgeArticlesProvider._(argument: language, from: this);

  @override
  String toString() => r'knowledgeArticlesProvider';
}

/// İçerik güncellemesi: Storage'da yeni paket varsa indirir ve içeriği
/// yeniden okutur; açık ekranlar kendiliğinden yenilenir.

@ProviderFor(KnowledgeUpdates)
final knowledgeUpdatesProvider = KnowledgeUpdatesProvider._();

/// İçerik güncellemesi: Storage'da yeni paket varsa indirir ve içeriği
/// yeniden okutur; açık ekranlar kendiliğinden yenilenir.
final class KnowledgeUpdatesProvider
    extends $NotifierProvider<KnowledgeUpdates, void> {
  /// İçerik güncellemesi: Storage'da yeni paket varsa indirir ve içeriği
  /// yeniden okutur; açık ekranlar kendiliğinden yenilenir.
  KnowledgeUpdatesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'knowledgeUpdatesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$knowledgeUpdatesHash();

  @$internal
  @override
  KnowledgeUpdates create() => KnowledgeUpdates();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$knowledgeUpdatesHash() => r'6d557392114069cf2d7cc578723d72a521ad483d';

/// İçerik güncellemesi: Storage'da yeni paket varsa indirir ve içeriği
/// yeniden okutur; açık ekranlar kendiliğinden yenilenir.

abstract class _$KnowledgeUpdates extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

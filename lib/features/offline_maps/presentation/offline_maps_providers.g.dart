// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_maps_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Paketlerin klasörü; testler geçici klasörle override eder.

@ProviderFor(mapPackStore)
final mapPackStoreProvider = MapPackStoreProvider._();

/// Paketlerin klasörü; testler geçici klasörle override eder.

final class MapPackStoreProvider
    extends $FunctionalProvider<MapPackStore, MapPackStore, MapPackStore>
    with $Provider<MapPackStore> {
  /// Paketlerin klasörü; testler geçici klasörle override eder.
  MapPackStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapPackStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPackStoreHash();

  @$internal
  @override
  $ProviderElement<MapPackStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapPackStore create(Ref ref) {
    return mapPackStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapPackStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapPackStore>(value),
    );
  }
}

String _$mapPackStoreHash() => r'08b3b890d37a7b115eb2ab0825b07c9c1489c0b5';

/// Storage'daki katalog (ağ). Hata kendiliğinden yeniden denenmez; ekran
/// "Yeniden dene" ile yeniler.

@ProviderFor(mapPackCatalog)
final mapPackCatalogProvider = MapPackCatalogProvider._();

/// Storage'daki katalog (ağ). Hata kendiliğinden yeniden denenmez; ekran
/// "Yeniden dene" ile yeniler.

final class MapPackCatalogProvider
    extends
        $FunctionalProvider<
          AsyncValue<MapPackCatalog>,
          MapPackCatalog,
          FutureOr<MapPackCatalog>
        >
    with $FutureModifier<MapPackCatalog>, $FutureProvider<MapPackCatalog> {
  /// Storage'daki katalog (ağ). Hata kendiliğinden yeniden denenmez; ekran
  /// "Yeniden dene" ile yeniler.
  MapPackCatalogProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'mapPackCatalogProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPackCatalogHash();

  @$internal
  @override
  $FutureProviderElement<MapPackCatalog> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<MapPackCatalog> create(Ref ref) {
    return mapPackCatalog(ref);
  }
}

String _$mapPackCatalogHash() => r'a707626f9efcfca2b1f706d65f54fdd51c4d6db4';

/// Bu telefona indirilmiş paketler, indirme sırasıyla.

@ProviderFor(InstalledMapPacks)
final installedMapPacksProvider = InstalledMapPacksProvider._();

/// Bu telefona indirilmiş paketler, indirme sırasıyla.
final class InstalledMapPacksProvider
    extends $AsyncNotifierProvider<InstalledMapPacks, List<InstalledMapPack>> {
  /// Bu telefona indirilmiş paketler, indirme sırasıyla.
  InstalledMapPacksProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedMapPacksProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedMapPacksHash();

  @$internal
  @override
  InstalledMapPacks create() => InstalledMapPacks();
}

String _$installedMapPacksHash() => r'fab0885abc7dfb2d5b5de005554b64a4b2a22b4e';

/// Bu telefona indirilmiş paketler, indirme sırasıyla.

abstract class _$InstalledMapPacks
    extends $AsyncNotifier<List<InstalledMapPack>> {
  FutureOr<List<InstalledMapPack>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<InstalledMapPack>>, List<InstalledMapPack>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<InstalledMapPack>>,
                List<InstalledMapPack>
              >,
              AsyncValue<List<InstalledMapPack>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Oturumdaki işletmenin geçmişte kalmamış göç durakları; işletme yoksa
/// boş.

@ProviderFor(upcomingMigrationStops)
final upcomingMigrationStopsProvider = UpcomingMigrationStopsProvider._();

/// Oturumdaki işletmenin geçmişte kalmamış göç durakları; işletme yoksa
/// boş.

final class UpcomingMigrationStopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MigrationStop>>,
          List<MigrationStop>,
          Stream<List<MigrationStop>>
        >
    with
        $FutureModifier<List<MigrationStop>>,
        $StreamProvider<List<MigrationStop>> {
  /// Oturumdaki işletmenin geçmişte kalmamış göç durakları; işletme yoksa
  /// boş.
  UpcomingMigrationStopsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upcomingMigrationStopsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upcomingMigrationStopsHash();

  @$internal
  @override
  $StreamProviderElement<List<MigrationStop>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MigrationStop>> create(Ref ref) {
    return upcomingMigrationStops(ref);
  }
}

String _$upcomingMigrationStopsHash() =>
    r'ac9af9a0bb6702ff5f1ce50e918487fb2efebb49';

/// Arılıkların ve göç duraklarının içinde kaldığı, indirilmemiş paketler
/// ([suggestMapPacks]).

@ProviderFor(mapPackSuggestions)
final mapPackSuggestionsProvider = MapPackSuggestionsProvider._();

/// Arılıkların ve göç duraklarının içinde kaldığı, indirilmemiş paketler
/// ([suggestMapPacks]).

final class MapPackSuggestionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MapPackSuggestion>>,
          List<MapPackSuggestion>,
          FutureOr<List<MapPackSuggestion>>
        >
    with
        $FutureModifier<List<MapPackSuggestion>>,
        $FutureProvider<List<MapPackSuggestion>> {
  /// Arılıkların ve göç duraklarının içinde kaldığı, indirilmemiş paketler
  /// ([suggestMapPacks]).
  MapPackSuggestionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapPackSuggestionsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPackSuggestionsHash();

  @$internal
  @override
  $FutureProviderElement<List<MapPackSuggestion>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MapPackSuggestion>> create(Ref ref) {
    return mapPackSuggestions(ref);
  }
}

String _$mapPackSuggestionsHash() =>
    r'b6cd6fe6f445986918be83df48b08a45f43a1389';

/// Süren indirmeler: paket kimliğinden o ana kadar inen bayta. Uygulama
/// açık kaldıkça sürer; ekrandan çıkınca durmaz.

@ProviderFor(MapPackDownloads)
final mapPackDownloadsProvider = MapPackDownloadsProvider._();

/// Süren indirmeler: paket kimliğinden o ana kadar inen bayta. Uygulama
/// açık kaldıkça sürer; ekrandan çıkınca durmaz.
final class MapPackDownloadsProvider
    extends $NotifierProvider<MapPackDownloads, Map<String, int>> {
  /// Süren indirmeler: paket kimliğinden o ana kadar inen bayta. Uygulama
  /// açık kaldıkça sürer; ekrandan çıkınca durmaz.
  MapPackDownloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapPackDownloadsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapPackDownloadsHash();

  @$internal
  @override
  MapPackDownloads create() => MapPackDownloads();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, int> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, int>>(value),
    );
  }
}

String _$mapPackDownloadsHash() => r'057907f4a37b750891ed8ce8e78636914c5d853b';

/// Süren indirmeler: paket kimliğinden o ana kadar inen bayta. Uygulama
/// açık kaldıkça sürer; ekrandan çıkınca durmaz.

abstract class _$MapPackDownloads extends $Notifier<Map<String, int>> {
  Map<String, int> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Map<String, int>, Map<String, int>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, int>, Map<String, int>>,
              Map<String, int>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

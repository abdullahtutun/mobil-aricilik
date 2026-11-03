// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offline_maps_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Alanların klasörü; testler geçici klasörle override eder.

@ProviderFor(mapAreaStore)
final mapAreaStoreProvider = MapAreaStoreProvider._();

/// Alanların klasörü; testler geçici klasörle override eder.

final class MapAreaStoreProvider
    extends $FunctionalProvider<MapAreaStore, MapAreaStore, MapAreaStore>
    with $Provider<MapAreaStore> {
  /// Alanların klasörü; testler geçici klasörle override eder.
  MapAreaStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapAreaStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapAreaStoreHash();

  @$internal
  @override
  $ProviderElement<MapAreaStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MapAreaStore create(Ref ref) {
    return mapAreaStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MapAreaStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MapAreaStore>(value),
    );
  }
}

String _$mapAreaStoreHash() => r'87fdf6f08112a836759a837c5e3b3d6dc3d53ac6';

/// Bu telefona indirilmiş arılık çevreleri, indirme sırasıyla.

@ProviderFor(InstalledMapAreas)
final installedMapAreasProvider = InstalledMapAreasProvider._();

/// Bu telefona indirilmiş arılık çevreleri, indirme sırasıyla.
final class InstalledMapAreasProvider
    extends $AsyncNotifierProvider<InstalledMapAreas, List<InstalledMapArea>> {
  /// Bu telefona indirilmiş arılık çevreleri, indirme sırasıyla.
  InstalledMapAreasProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'installedMapAreasProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$installedMapAreasHash();

  @$internal
  @override
  InstalledMapAreas create() => InstalledMapAreas();
}

String _$installedMapAreasHash() => r'31a07285bdf3175bf6716146625fe78b4225d69f';

/// Bu telefona indirilmiş arılık çevreleri, indirme sırasıyla.

abstract class _$InstalledMapAreas
    extends $AsyncNotifier<List<InstalledMapArea>> {
  FutureOr<List<InstalledMapArea>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<List<InstalledMapArea>>, List<InstalledMapArea>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<InstalledMapArea>>,
                List<InstalledMapArea>
              >,
              AsyncValue<List<InstalledMapArea>>,
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

/// İndirilmeye aday konumlu arılıklar ([mapAreaCandidates]); arılığa bağlı
/// göç durakları adlarıyla.

@ProviderFor(mapAreaCandidateList)
final mapAreaCandidateListProvider = MapAreaCandidateListProvider._();

/// İndirilmeye aday konumlu arılıklar ([mapAreaCandidates]); arılığa bağlı
/// göç durakları adlarıyla.

final class MapAreaCandidateListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MapAreaCandidate>>,
          List<MapAreaCandidate>,
          FutureOr<List<MapAreaCandidate>>
        >
    with
        $FutureModifier<List<MapAreaCandidate>>,
        $FutureProvider<List<MapAreaCandidate>> {
  /// İndirilmeye aday konumlu arılıklar ([mapAreaCandidates]); arılığa bağlı
  /// göç durakları adlarıyla.
  MapAreaCandidateListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapAreaCandidateListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapAreaCandidateListHash();

  @$internal
  @override
  $FutureProviderElement<List<MapAreaCandidate>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MapAreaCandidate>> create(Ref ref) {
    return mapAreaCandidateList(ref);
  }
}

String _$mapAreaCandidateListHash() =>
    r'75baa99070933175c2f35b25564f95e334c90a53';

/// Süren indirmeler, alan kimliğine göre. Uygulama açık kaldıkça sürer;
/// ekrandan çıkınca durmaz.

@ProviderFor(MapAreaDownloads)
final mapAreaDownloadsProvider = MapAreaDownloadsProvider._();

/// Süren indirmeler, alan kimliğine göre. Uygulama açık kaldıkça sürer;
/// ekrandan çıkınca durmaz.
final class MapAreaDownloadsProvider
    extends $NotifierProvider<MapAreaDownloads, Map<String, MapAreaProgress>> {
  /// Süren indirmeler, alan kimliğine göre. Uygulama açık kaldıkça sürer;
  /// ekrandan çıkınca durmaz.
  MapAreaDownloadsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mapAreaDownloadsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mapAreaDownloadsHash();

  @$internal
  @override
  MapAreaDownloads create() => MapAreaDownloads();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, MapAreaProgress> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, MapAreaProgress>>(value),
    );
  }
}

String _$mapAreaDownloadsHash() => r'3c7f97c0b0bf90098345deebdd2f4b501226e775';

/// Süren indirmeler, alan kimliğine göre. Uygulama açık kaldıkça sürer;
/// ekrandan çıkınca durmaz.

abstract class _$MapAreaDownloads
    extends $Notifier<Map<String, MapAreaProgress>> {
  Map<String, MapAreaProgress> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<Map<String, MapAreaProgress>, Map<String, MapAreaProgress>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                Map<String, MapAreaProgress>,
                Map<String, MapAreaProgress>
              >,
              Map<String, MapAreaProgress>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

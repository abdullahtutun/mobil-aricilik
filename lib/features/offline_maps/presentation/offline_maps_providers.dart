import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/map_pack_downloader.dart';
import 'package:mobil_arici/core/sync/map_pack_downloader_provider.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/offline_maps/data/map_pack_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline_maps_providers.g.dart';

/// Paketlerin klasörü; testler geçici klasörle override eder.
@Riverpod(keepAlive: true)
MapPackStore mapPackStore(Ref ref) => MapPackStore.app();

/// Storage'daki katalog (ağ). Hata kendiliğinden yeniden denenmez; ekran
/// "Yeniden dene" ile yeniler.
@Riverpod(retry: _noRetry)
Future<MapPackCatalog> mapPackCatalog(Ref ref) =>
    ref.watch(mapPackDownloaderProvider).catalog();

Duration? _noRetry(int retryCount, Object error) => null;

/// Bu telefona indirilmiş paketler, indirme sırasıyla.
@Riverpod(keepAlive: true)
class InstalledMapPacks extends _$InstalledMapPacks {
  @override
  Future<List<InstalledMapPack>> build() =>
      ref.watch(mapPackStoreProvider).installed();

  /// Paketi siler.
  Future<void> remove(String id) async {
    await ref.read(mapPackStoreProvider).remove(id);
    changed();
  }

  /// Liste yeniden okunur; internetsiz açılmış (ya da açılamamış) harita
  /// yeni paketlerle yeniden kurulur.
  void changed() {
    ref.invalidateSelf();
    if (!ref.exists(basemapProvider)) return;
    final basemap = ref.read(basemapProvider);
    if (basemap.hasError || (basemap.value?.offline ?? false)) {
      ref.invalidate(basemapProvider);
    }
  }
}

/// Oturumdaki işletmenin geçmişte kalmamış göç durakları; işletme yoksa
/// boş.
@riverpod
Stream<List<MigrationStop>> upcomingMigrationStops(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(migrationRepositoryProvider).stops.watchUpcomingByOrg(orgId);
}

/// Arılıkların ve göç duraklarının içinde kaldığı, indirilmemiş paketler
/// ([suggestMapPacks]). Katalogun hatasını taşır; o da kendiliğinden
/// yeniden denenmez.
@Riverpod(retry: _noRetry)
Future<List<MapPackSuggestion>> mapPackSuggestions(Ref ref) async {
  final catalog = await ref.watch(mapPackCatalogProvider.future);
  final installed = await ref.watch(installedMapPacksProvider.future);
  final summaries = await ref.watch(apiaryListProvider.future);
  final stops = await ref.watch(upcomingMigrationStopsProvider.future);
  final apiaryById = {
    for (final summary in summaries) summary.apiary.id: summary.apiary,
  };
  return suggestMapPacks(
    packs: catalog.packs,
    installedIds: {for (final row in installed) row.pack.id},
    apiaries: [
      for (final summary in summaries)
        if (summary.apiary case Apiary(:final latitude?, :final longitude?))
          (latitude: latitude, longitude: longitude),
    ],
    stops: [
      for (final stop in stops)
        (
          name: stop.name,
          place: stop.place,
          latitude: apiaryById[stop.apiaryId]?.latitude,
          longitude: apiaryById[stop.apiaryId]?.longitude,
        ),
    ],
  );
}

/// İndirmeyi başlatmanın sonucu.
enum MapPackDownloadOutcome {
  done,
  cancelled,

  /// "Sadece Wi‑Fi'da indir" açık ve telefon Wi‑Fi'da değil; başlamadı.
  needsWifi,
  failed,
}

/// Süren indirmeler: paket kimliğinden o ana kadar inen bayta. Uygulama
/// açık kaldıkça sürer; ekrandan çıkınca durmaz.
@Riverpod(keepAlive: true)
class MapPackDownloads extends _$MapPackDownloads {
  final _tokens = <String, MapPackCancelToken>{};

  /// İlerleme bu kadar bayt değişmeden yayılmaz; her parçada ekran
  /// yeniden çizilmesin.
  static const int progressStep = 256 * 1024;

  @override
  Map<String, int> build() => const {};

  /// [pack]'i indirir: önce stil, sonra paket; boyut ve SHA-256
  /// doğrulanınca kurulur. Aynı paket zaten iniyorsa bir şey yapmaz.
  Future<MapPackDownloadOutcome> start(
    MapPack pack,
    MapPackCatalog catalog,
  ) async {
    if (_tokens.containsKey(pack.id)) return MapPackDownloadOutcome.cancelled;
    final token = _tokens[pack.id] = MapPackCancelToken();
    final store = ref.read(mapPackStoreProvider);
    try {
      if (await ref.read(localSettingsRepositoryProvider).mapWifiOnly() &&
          !await ref.read(connectivityServiceProvider).isUnmetered()) {
        return MapPackDownloadOutcome.needsWifi;
      }
      _progress(pack.id, 0);
      final downloader = ref.read(mapPackDownloaderProvider);
      final style = await downloader.fetchStyle();
      final partial = await store.partialFile(pack.id);
      var shown = 0;
      try {
        await downloader.download(
          pack,
          partial,
          cancel: token,
          onProgress: (received) {
            if (received - shown < progressStep) return;
            shown = received;
            _progress(pack.id, received);
          },
        );
        await store.saveStyle(style);
        await store.install(
          InstalledMapPack(
            pack: pack,
            version: catalog.version,
            generatedAt: catalog.generatedAt,
            downloadedAt: clock.now(),
          ),
          partial,
        );
      } finally {
        if (partial.existsSync()) partial.deleteSync();
      }
      if (ref.mounted) ref.read(installedMapPacksProvider.notifier).changed();
      return MapPackDownloadOutcome.done;
    } on MapPackDownloadCancelled {
      return MapPackDownloadOutcome.cancelled;
    } on MapPackDownloadFailed {
      return MapPackDownloadOutcome.failed;
    } finally {
      _tokens.remove(pack.id);
      if (ref.mounted) state = {...state}..remove(pack.id);
    }
  }

  /// Süren indirmeyi durdurur; yarım dosya silinir.
  void cancel(String id) => _tokens[id]?.cancel();

  void _progress(String id, int received) {
    if (ref.mounted) state = {...state, id: received};
  }
}

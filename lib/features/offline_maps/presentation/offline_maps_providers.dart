import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/business/business_provider.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service_provider.dart';
import 'package:mobil_arici/core/sync/map_area_downloader.dart';
import 'package:mobil_arici/core/sync/map_area_downloader_provider.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/offline_maps/data/map_area_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'offline_maps_providers.g.dart';

/// Alanların klasörü; testler geçici klasörle override eder.
@Riverpod(keepAlive: true)
MapAreaStore mapAreaStore(Ref ref) => MapAreaStore.app();

/// Bu telefona indirilmiş arılık çevreleri, indirme sırasıyla.
@Riverpod(keepAlive: true)
class InstalledMapAreas extends _$InstalledMapAreas {
  @override
  Future<List<InstalledMapArea>> build() =>
      ref.watch(mapAreaStoreProvider).installed();

  /// Alanı siler.
  Future<void> remove(String id) async {
    await ref.read(mapAreaStoreProvider).remove(id);
    changed();
  }

  /// Liste yeniden okunur; internetsiz açılmış (ya da açılamamış) harita
  /// yeni alanlarla yeniden kurulur.
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
  // Sabit işletmede göç durakları gösterilmez (kayıtlar silinmez).
  final migratory = ref.watch(
    businessConfigProvider.select((config) => config.features.migratory),
  );
  if (orgId == null || !migratory) return Stream.value(const []);
  return ref.watch(migrationRepositoryProvider).stops.watchUpcomingByOrg(orgId);
}

/// İndirilmeye aday konumlu arılıklar ([mapAreaCandidates]); arılığa bağlı
/// göç durakları adlarıyla.
@riverpod
Future<List<MapAreaCandidate>> mapAreaCandidateList(Ref ref) async {
  final summaries = await ref.watch(apiaryListProvider.future);
  final installed = await ref.watch(installedMapAreasProvider.future);
  final stops = await ref.watch(upcomingMigrationStopsProvider.future);
  final stopNames = <String, List<String>>{};
  for (final stop in stops) {
    if (stop.apiaryId case final apiaryId?) {
      (stopNames[apiaryId] ??= []).add(stop.name);
    }
  }
  return mapAreaCandidates(
    apiaries: [
      for (final summary in summaries)
        if (summary.apiary case Apiary(
          :final id,
          :final name,
          :final latitude?,
          :final longitude?,
        ))
          MapArea(id: id, name: name, latitude: latitude, longitude: longitude),
    ],
    installed: installed,
    stopNamesByApiary: stopNames,
  );
}

/// İndirmeyi başlatmanın sonucu.
enum MapAreaDownloadOutcome {
  done,
  cancelled,

  /// "Sadece Wi‑Fi'da indir" açık ve telefon Wi‑Fi'da değil; başlamadı.
  needsWifi,
  failed,
}

/// Süren bir indirme: biten ve toplam karo, inen bayt.
typedef MapAreaProgress = ({MapArea area, int done, int total, int bytes});

/// Süren indirmeler, alan kimliğine göre. Uygulama açık kaldıkça sürer;
/// ekrandan çıkınca durmaz.
@Riverpod(keepAlive: true)
class MapAreaDownloads extends _$MapAreaDownloads {
  final _tokens = <String, MapAreaCancelToken>{};

  @override
  Map<String, MapAreaProgress> build() => const {};

  /// [area]'nın karolarını indirir; bitince kurulur (aynı alan varsa
  /// yerine). Aynı alan zaten iniyorsa bir şey yapmaz.
  Future<MapAreaDownloadOutcome> start(MapArea area) async {
    if (_tokens.containsKey(area.id)) return MapAreaDownloadOutcome.cancelled;
    final token = _tokens[area.id] = MapAreaCancelToken();
    final store = ref.read(mapAreaStoreProvider);
    final tiles = mapAreaTiles(area);
    try {
      if (await ref.read(localSettingsRepositoryProvider).mapWifiOnly() &&
          !await ref.read(connectivityServiceProvider).isUnmetered()) {
        return MapAreaDownloadOutcome.needsWifi;
      }
      _progress((area: area, done: 0, total: tiles.length, bytes: 0));
      final downloader = ref.read(mapAreaDownloaderProvider);
      final style = await downloader.fetchStyle();
      final partial = await store.partialFile(area.id);
      try {
        await downloader.download(
          tiles,
          partial,
          cancel: token,
          onProgress: (done, bytes) => _progress((
            area: area,
            done: done,
            total: tiles.length,
            bytes: bytes,
          )),
        );
        await store.saveStyle(style);
        await store.install(
          InstalledMapArea(
            area: area,
            tileCount: tiles.length,
            bytes: partial.lengthSync(),
            downloadedAt: clock.now(),
          ),
          partial,
        );
      } finally {
        if (partial.existsSync()) partial.deleteSync();
      }
      if (ref.mounted) ref.read(installedMapAreasProvider.notifier).changed();
      return MapAreaDownloadOutcome.done;
    } on MapAreaDownloadCancelled {
      return MapAreaDownloadOutcome.cancelled;
    } on MapAreaDownloadFailed {
      return MapAreaDownloadOutcome.failed;
    } finally {
      _tokens.remove(area.id);
      if (ref.mounted) state = {...state}..remove(area.id);
    }
  }

  /// Süren indirmeyi durdurur; yarım dosya silinir.
  void cancel(String id) => _tokens[id]?.cancel();

  void _progress(MapAreaProgress progress) {
    if (ref.mounted) state = {...state, progress.area.id: progress};
  }
}

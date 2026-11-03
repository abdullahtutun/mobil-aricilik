import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/services/offline_basemap.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basemap_service_provider.g.dart';

/// Testler ağsız altlıkla override eder.
@Riverpod(keepAlive: true)
BasemapService basemapService(Ref ref) => const OpenFreeMapService();

/// İndirilmiş arılık çevrelerinden altlık; testler override eder.
@Riverpod(keepAlive: true)
OfflineBasemapService offlineBasemapService(Ref ref) =>
    MbtilesBasemapService(ref.watch(mapAreaStoreProvider));

/// Altlık uygulama açık kaldıkça bir kez okunur. Ağdan okunamazsa
/// indirilmiş arılık çevrelerinden açılır; o da yoksa [BasemapUnavailable].
/// Hata kendiliğinden yeniden denenmez; ekran "Yeniden dene" ile ya da
/// haritaya yeniden geçince yeniler. Alan inince ya da silinince
/// internetsiz altlık yeniden okunur.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<Basemap> basemap(Ref ref) async {
  final online = ref.watch(basemapServiceProvider);
  final offline = ref.watch(offlineBasemapServiceProvider);
  try {
    return await online.load();
  } on BasemapUnavailable {
    final basemap = await offline.load();
    if (basemap == null) rethrow;
    ref.onDispose(basemap.dispose);
    return basemap;
  }
}

Duration? _noRetry(int retryCount, Object error) => null;

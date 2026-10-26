import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basemap_service_provider.g.dart';

/// Testler ağsız altlıkla override eder.
@Riverpod(keepAlive: true)
BasemapService basemapService(Ref ref) => const OpenFreeMapService();

/// Altlık uygulama açık kaldıkça bir kez okunur. Hata kendiliğinden yeniden
/// denenmez; ekran "Yeniden dene" ile ya da haritaya yeniden geçince
/// yeniler.
@Riverpod(keepAlive: true, retry: _noRetry)
Future<Basemap> basemap(Ref ref) => ref.watch(basemapServiceProvider).load();

Duration? _noRetry(int retryCount, Object error) => null;

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/services/offline_basemap.dart';
import 'package:mobil_arici/core/sync/map_area_downloader.dart';
import 'package:mobil_arici/core/sync/map_area_downloader_provider.dart';
import 'package:mobil_arici/features/offline_maps/data/map_area_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';

/// Cihazsız offline haritalar: alanlar geçici klasörde, TileJSON, stil ve
/// karolar sahte HTTP'den. Her karo [tileBytes] bayt. İnternetsiz altlık
/// gerçek MBTiles okumaz; klasörde alan ve stil varsa boş bir karo katmanı
/// verir.
class FakeOfflineMaps {
  new() : directory = Directory.systemTemp.createTempSync('fake_maps') {
    addTearDown(() => directory.deleteSync(recursive: true));
  }

  final Directory directory;
  late final store = MapAreaStore(Future.value(directory));

  static const String tileTemplate =
      'https://tiles.test/planet/20261101/{z}/{x}/{y}.pbf';

  /// Karo yanıtının kodu; 200 değilse indirme başarısız olur.
  int tileStatus = HttpStatus.ok;
  int tileBytes = 10 * 1024;

  /// Verilirse [holdAfter] karodan sonraki karo istekleri bu tamamlanana
  /// kadar bekler (ilerleme ve iptal testleri).
  Completer<void>? hold;
  int holdAfter = 20;

  /// İstenen adresler, sırayla.
  final requested = <String>[];

  /// Gönderilen User-Agent'lar.
  final userAgents = <String?>{};

  int _tileRequests = 0;

  /// Bu telefona indirilmiş gibi bir arılık çevresi ve stil koyar.
  Future<void> install(MapArea area, {int bytes = 3 * 1024 * 1024}) async {
    final partial = (await store.partialFile(area.id))
      ..writeAsBytesSync([1, 2, 3]);
    await store.saveStyle((style: '{}', spriteIndex: null, spriteAtlas: null));
    await store.install(
      InstalledMapArea(
        area: area,
        tileCount: 120,
        bytes: bytes,
        downloadedAt: DateTime.utc(2026, 11, 2),
      ),
      partial,
    );
  }

  late final client = MockClient((request) async {
    final url = request.url.toString();
    requested.add(url);
    userAgents.add(request.headers['User-Agent']);
    if (url == MapAreaDownloader.tileJsonUri) {
      return http.Response(
        jsonEncode({
          'tiles': [tileTemplate],
        }),
        200,
      );
    }
    if (url == OpenFreeMapService.styleUri) {
      return http.Response(
        jsonEncode({
          'version': 8,
          'sources': {
            'openmaptiles': {'type': 'vector', 'url': 'https://x/planet'},
          },
          'layers': <Object>[],
        }),
        200,
      );
    }
    if (url.startsWith('https://tiles.test/planet/')) {
      _tileRequests++;
      final hold = this.hold;
      if (hold != null && _tileRequests > holdAfter) await hold.future;
      return http.Response.bytes(
        tileStatus == HttpStatus.ok ? Uint8List(tileBytes) : const [],
        tileStatus,
      );
    }
    return http.Response('', 404);
  });

  List<Override> get overrides => [
    mapAreaStoreProvider.overrideWithValue(store),
    mapAreaDownloaderProvider.overrideWithValue(MapAreaDownloader(client)),
    offlineBasemapServiceProvider.overrideWithValue(
      _FakeOfflineBasemaps(store),
    ),
  ];
}

class _FakeOfflineBasemaps implements OfflineBasemapService {
  const new(this._store);

  final MapAreaStore _store;

  @override
  Future<Basemap?> load() async {
    if ((await _store.installed()).isEmpty) return null;
    if (await _store.readStyle() == null) return null;
    return const _BlankOfflineBasemap();
  }
}

class _BlankOfflineBasemap implements Basemap {
  const new();

  @override
  Widget tileLayer() => const SizedBox.expand(key: Key('offline-basemap'));

  @override
  bool get offline => true;

  @override
  void dispose() {}
}

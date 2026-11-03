import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/services/basemap_service_provider.dart';
import 'package:mobil_arici/core/services/offline_basemap.dart';
import 'package:mobil_arici/core/sync/map_pack_downloader.dart';
import 'package:mobil_arici/core/sync/map_pack_downloader_provider.dart';
import 'package:mobil_arici/features/offline_maps/data/map_pack_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/presentation/offline_maps_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Cihazsız offline haritalar: paketler geçici klasörde, katalog [files]
/// haritasında (boşsa 404), paketler ve stil sahte HTTP'den ([served]).
/// İnternetsiz altlık gerçek MBTiles okumaz; bu klasörde paket ve stil
/// varsa boş bir karo katmanı verir.
class FakeOfflineMaps {
  new() : directory = Directory.systemTemp.createTempSync('fake_maps') {
    addTearDown(() => directory.deleteSync(recursive: true));
  }

  final Directory directory;
  late final store = MapPackStore(Future.value(directory));

  /// Storage'daki dosyalar (katalog), yola göre.
  final files = <String, Uint8List>{};

  /// HTTP'den sunulan dosyalar (paketler, stil), adrese göre.
  final served = <String, Uint8List>{};

  /// Verilirse paket indirmeleri bu tamamlanana kadar ilk parçadan sonra
  /// bekler (ilerleme ve iptal testleri).
  Completer<void>? hold;

  /// Verilirse Storage okuması (katalog) bu tamamlanana kadar bekler.
  Completer<void>? catalogHold;

  /// İstenen adresler, sırayla.
  final requested = <String>[];

  static const String styleUrl = OpenFreeMapService.styleUri;

  /// Katalogu ve paketleri yayımlar; her paket [bytesById] baytlarıyla.
  /// Stil de sunulur.
  void publish(
    List<({String id, Map<String, String> name, List<double> bbox})> packs, {
    Map<String, Uint8List> bytesById = const {},
    String version = '20261029',
    String generatedAt = '2026-09-15T00:00:00Z',
  }) {
    served[styleUrl] = utf8.encode(
      jsonEncode({
        'version': 8,
        'sources': {
          'openmaptiles': {'type': 'vector', 'url': 'https://x/planet'},
        },
        'layers': <Object>[],
      }),
    );
    final rows = <Object>[];
    for (final pack in packs) {
      final bytes = bytesById[pack.id] ?? Uint8List(2 * 1024 * 1024);
      final url = 'https://storage.test/map-packs/$version/${pack.id}.mbtiles';
      served[url] = bytes;
      rows.add({
        'id': pack.id,
        'name': pack.name,
        'bbox': pack.bbox,
        'minzoom': 6,
        'maxzoom': 14,
        'path': '$version/${pack.id}.mbtiles',
        'url': url,
        'bytes': bytes.length,
        'tiles': 1,
        'sha256': sha256.convert(bytes).toString(),
      });
    }
    files[MapPackDownloader.catalogPath] = utf8.encode(
      jsonEncode({
        'format': 1,
        'version': version,
        'generated_at': generatedAt,
        'packs': rows,
      }),
    );
  }

  /// Bu telefona indirilmiş gibi bir paket ve stil koyar.
  Future<void> install(
    String id, {
    Map<String, String> name = const {'tr': 'Muğla', 'en': 'Mugla'},
    MapBounds bounds = const MapBounds(
      west: 27.2,
      south: 36.3,
      east: 29.6,
      north: 37.6,
    ),
    int bytes = 84 * 1024 * 1024,
  }) async {
    final partial = (await store.partialFile(id))
      ..writeAsBytesSync([1, 2, 3]);
    await store.saveStyle((style: '{}', spriteIndex: null, spriteAtlas: null));
    await store.install(
      InstalledMapPack(
        pack: MapPack(
          id: id,
          names: name,
          bounds: bounds,
          minZoom: 6,
          maxZoom: 14,
          url: 'https://storage.test/map-packs/20261029/$id.mbtiles',
          bytes: bytes,
          sha256: '00',
        ),
        version: '20261029',
        generatedAt: DateTime.utc(2026, 9, 15),
        downloadedAt: DateTime.utc(2026, 10, 2),
      ),
      partial,
    );
  }

  Future<Uint8List> download(String path) async {
    await catalogHold?.future;
    final bytes = files[path];
    if (bytes == null) {
      throw const StorageException('Object not found', statusCode: '404');
    }
    return bytes;
  }

  late final client = MockClient.streaming((request, _) async {
    final url = request.url.toString();
    requested.add(url);
    final bytes = served[url];
    if (bytes == null) {
      return http.StreamedResponse(const Stream<List<int>>.empty(), 404);
    }
    final hold = this.hold;
    if (hold == null || !url.endsWith('.mbtiles')) {
      return http.StreamedResponse(Stream.value(bytes), 200);
    }
    final half = bytes.length ~/ 2;
    Stream<List<int>> body() async* {
      yield bytes.sublist(0, half);
      await hold.future;
      yield bytes.sublist(half);
    }

    return http.StreamedResponse(body(), 200, contentLength: bytes.length);
  });

  List<Override> get overrides => [
    mapPackStoreProvider.overrideWithValue(store),
    mapPackDownloaderProvider.overrideWithValue(
      MapPackDownloader(download, client),
    ),
    offlineBasemapServiceProvider.overrideWithValue(
      _FakeOfflineBasemaps(store),
    ),
  ];
}

class _FakeOfflineBasemaps implements OfflineBasemapService {
  const new(this._store);

  final MapPackStore _store;

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

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/services/offline_basemap.dart';
import 'package:mobil_arici/features/offline_maps/data/map_pack_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

MapPack _pack(String id, MapBounds bounds, {int minZoom = 6}) => MapPack(
  id: id,
  names: {'tr': id},
  bounds: bounds,
  minZoom: minZoom,
  maxZoom: 14,
  url: 'https://x/$id.mbtiles',
  bytes: 1,
  sha256: 'ab',
);

const _mugla = MapBounds(west: 27.2, south: 36.3, east: 29.6, north: 37.6);
const _izmir = MapBounds(west: 26.2, south: 37.8, east: 28.5, north: 39.4);

/// Muğla'daki z10 karosu (XYZ) ve MBTiles'taki (TMS) satırı.
const _z = 10;
const _x = 592;
const _y = 401;
const int _tmsY = (1 << _z) - 1 - _y;

/// OpenFreeMap stilinin özü: vektör katmanlar, Natural Earth raster
/// katmanı ve tile JSON adresli kaynak.
final String _style = jsonEncode({
  'version': 8,
  'sources': {
    'ne2_shaded': {
      'type': 'raster',
      'tiles': ['https://x/{z}/{x}/{y}.png'],
    },
    'openmaptiles': {'type': 'vector', 'url': 'https://x/planet'},
  },
  'sprite': 'https://x/sprites/ofm',
  'layers': [
    {
      'id': 'background',
      'type': 'background',
      'paint': {'background-color': '#f8f4f0'},
    },
    {'id': 'ne2', 'type': 'raster', 'source': 'ne2_shaded'},
    {
      'id': 'water',
      'type': 'fill',
      'source': 'openmaptiles',
      'source-layer': 'water',
      'paint': {'fill-color': '#9ec8e8'},
    },
  ],
});

void main() {
  late Directory directory;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('offline_basemap');
  });

  tearDown(() => directory.deleteSync(recursive: true));

  /// [tiles] (z, x, TMS y → bayt) ile bir MBTiles dosyası.
  String mbtiles(String id, Map<(int, int, int), List<int>> tiles) {
    final path = '${directory.path}/$id.mbtiles';
    final db = sqlite3.open(path)
      ..execute(
        'CREATE TABLE tiles (zoom_level INTEGER, tile_column INTEGER, '
        'tile_row INTEGER, tile_data BLOB)',
      );
    for (final MapEntry(key: (z, x, y), :value) in tiles.entries) {
      db.execute('INSERT INTO tiles VALUES (?, ?, ?, ?)', [
        z,
        x,
        y,
        Uint8List.fromList(value),
      ]);
    }
    db.close();
    return path;
  }

  group('MbtilesTileProvider', () {
    test('karo TMS satırından okunur, gzip açılır', () async {
      final provider = MbtilesTileProvider.open([
        (
          pack: _pack('tr-48', _mugla),
          path: mbtiles('tr-48', {
            (_z, _x, _tmsY): gzip.encode([1, 2, 3]),
            (_z, _x + 1, _tmsY): [4, 5],
          }),
        ),
      ]);
      addTearDown(provider.dispose);

      expect(await provider.provide(TileIdentity(_z, _x, _y)), [1, 2, 3]);
      expect(await provider.provide(TileIdentity(_z, _x + 1, _y)), [4, 5]);
      expect(provider.minimumZoom, 6);
      expect(provider.maximumZoom, 14);
    });

    test('pakette olmayan karo 404; kutu dışındaki paket sorulmaz', () async {
      final provider = MbtilesTileProvider.open([
        // İzmir paketinde Muğla karosu var gibi; kutu dışı olduğu için
        // okunmaz.
        (
          pack: _pack('tr-35', _izmir),
          path: mbtiles('tr-35', {
            (_z, _x, _tmsY): [9],
          }),
        ),
        (
          pack: _pack('tr-48', _mugla, minZoom: 11),
          path: mbtiles('tr-48', {
            (_z, _x, _tmsY): [7],
          }),
        ),
      ]);
      addTearDown(provider.dispose);

      await expectLater(
        provider.provide(TileIdentity(_z, _x, _y)),
        throwsA(
          isA<ProviderException>().having((e) => e.statusCode, 'kod', 404),
        ),
      );
      expect(provider.minimumZoom, 6);
    });
  });

  group('MbtilesBasemapService', () {
    late MapPackStore store;

    setUp(() => store = MapPackStore(Future.value(directory)));

    Future<void> install() async {
      final partial = File(mbtiles('indirilen', {}));
      await store.install(
        InstalledMapPack(
          pack: _pack('tr-48', _mugla),
          version: '1',
          generatedAt: DateTime.utc(2026, 9),
          downloadedAt: DateTime.utc(2026, 10),
        ),
        partial,
      );
    }

    test('paket ya da stil yoksa null', () async {
      expect(await MbtilesBasemapService(store).load(), isNull);
      await install();
      expect(await MbtilesBasemapService(store).load(), isNull);
    });

    test('paket ve stille internetsiz altlık; raster katman atılır', () async {
      await install();
      await store.saveStyle((
        style: _style,
        spriteIndex: jsonEncode({
          'icon': {'x': 0, 'y': 0, 'width': 1, 'height': 1, 'pixelRatio': 1},
        }),
        spriteAtlas: Uint8List(1),
      ));

      final basemap = await MbtilesBasemapService(store).load();
      expect(basemap, isA<OfflineBasemap>());
      expect(basemap!.offline, isTrue);
      final layer = basemap.tileLayer() as VectorTileLayer;
      expect(
        [for (final layer in layer.theme.layers) layer.id],
        ['background', 'water'],
      );
      expect(layer.sprites, isNotNull);
      expect(
        layer.tileProviders.get(OfflineBasemap.vectorSource),
        isA<MbtilesTileProvider>(),
      );
      basemap.dispose();
    });

    test('okunamayan stil BasemapUnavailable', () async {
      await install();
      await store.saveStyle((
        style: '[]',
        spriteIndex: null,
        spriteAtlas: null,
      ));
      await expectLater(
        MbtilesBasemapService(store).load(),
        throwsA(isA<BasemapUnavailable>()),
      );
    });
  });
}

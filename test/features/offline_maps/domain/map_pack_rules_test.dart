import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack_rules.dart';

Map<String, Object?> _packJson(
  String id, {
  Object name = 'Muğla',
  List<num> bbox = const [27.2, 36.3, 29.6, 37.6],
}) => {
  'id': id,
  'name': name,
  'bbox': bbox,
  'minzoom': 6,
  'maxzoom': 14,
  'path': '20261029/$id.mbtiles',
  'url': 'https://x/$id.mbtiles',
  'bytes': 1000,
  'tiles': 3,
  'sha256': 'ABCDEF',
};

MapPack _pack(String id, Map<String, String> names, List<double> bbox) =>
    MapPack(
      id: id,
      names: names,
      bounds: MapBounds(
        west: bbox[0],
        south: bbox[1],
        east: bbox[2],
        north: bbox[3],
      ),
      minZoom: 6,
      maxZoom: 14,
      url: 'https://x/$id.mbtiles',
      bytes: 1000,
      sha256: 'ab',
    );

final MapPack _mugla = _pack(
  'tr-48',
  {'tr': 'Muğla', 'en': 'Mugla'},
  [27.2, 36.3, 29.6, 37.6],
);
final MapPack _mersin = _pack(
  'tr-33',
  {'tr': 'Mersin'},
  [32.5, 36.0, 35.2, 37.5],
);
final MapPack _izmir = _pack(
  'tr-35',
  {'tr': 'İzmir', 'en': 'Izmir'},
  [26.2, 37.8, 28.5, 39.4],
);

MapStopPlace _stop(
  String name, {
  String? place,
  double? latitude,
  double? longitude,
}) => (name: name, place: place, latitude: latitude, longitude: longitude);

void main() {
  group('parseMapPackCatalog', () {
    test('katalogu okur; okunamayan paketi atlar', () {
      final catalog = parseMapPackCatalog({
        'format': 1,
        'version': '20261029',
        'generated_at': '2026-09-15T20:00:00+00:00',
        'packs': [
          _packJson('tr-48', name: {'tr': 'Muğla', 'en': 'Mugla', 'x': 3}),
          _packJson('tr-35', name: 'İzmir'),
          // Boş kutu, eksik alan, ad yok.
          _packJson('bad-1', bbox: [28, 37, 27, 38]),
          {'id': 'bad-2'},
          _packJson('bad-3', name: <String, Object?>{}),
        ],
      });

      expect(catalog.version, '20261029');
      expect(catalog.generatedAt, DateTime.utc(2026, 9, 15, 20));
      expect([for (final pack in catalog.packs) pack.id], ['tr-48', 'tr-35']);
      final mugla = catalog.packs.first;
      expect(mugla.names, {'tr': 'Muğla', 'en': 'Mugla'});
      expect(
        mugla.bounds,
        const MapBounds(west: 27.2, south: 36.3, east: 29.6, north: 37.6),
      );
      expect(mugla.sha256, 'abcdef');
      expect(mugla.bytes, 1000);
      expect(mapPackName(catalog.packs.last, 'tr'), 'İzmir');
    });

    test('başka biçim ya da geçersiz katalog hata atar', () {
      expect(
        () => parseMapPackCatalog({
          'format': 2,
          'version': '1',
          'generated_at': '2026-09-15T00:00:00Z',
          'packs': <Object>[],
        }),
        throwsFormatException,
      );
      expect(() => parseMapPackCatalog([]), throwsFormatException);
    });
  });

  test('indirilmiş paket listesi yazılıp geri okunur', () {
    final installed = InstalledMapPack(
      pack: _mugla,
      version: '20261029',
      generatedAt: DateTime.utc(2026, 9, 15),
      downloadedAt: DateTime.utc(2026, 10, 2, 8),
    );
    final rows = parseInstalledMapPacks([
      installedMapPackToJson(installed),
      {'id': 'eksik'},
    ]);
    expect(rows, [installed]);
    expect(parseInstalledMapPacks({'x': 1}), isEmpty);
  });

  test('ad dilde yoksa İngilizcesi, o da yoksa ilki', () {
    expect(mapPackName(_mugla, 'tr'), 'Muğla');
    expect(mapPackName(_mugla, 'de'), 'Mugla');
    expect(mapPackName(_mersin, 'en'), 'Mersin');
  });

  group('karo', () {
    test('XYZ karosunun kutusu ve TMS satırı', () {
      final world = tileBounds(0, 0, 0);
      expect(world.west, -180);
      expect(world.east, 180);
      expect(world.north, closeTo(85.0511, 1e-4));
      expect(world.south, closeTo(-85.0511, 1e-4));

      // z1'de sol üst karo kuzey-batı çeyrek.
      final northWest = tileBounds(1, 0, 0);
      expect(northWest.east, 0);
      expect(northWest.south, closeTo(0, 1e-9));

      expect(tmsRow(0, 0), 0);
      expect(tmsRow(3, 0), 7);
      expect(tmsRow(14, 6000), (1 << 14) - 1 - 6000);
    });

    test('kutu kesişmesi ve içerme', () {
      // Muğla'daki z10 karosu (28.4, 37.1 civarı).
      final tile = tileBounds(10, 592, 401);
      expect(boundsIntersect(_mugla.bounds, tile), isTrue);
      expect(boundsIntersect(_mersin.bounds, tile), isFalse);
      expect(boundsContain(_mugla.bounds, 37.1, 28.4), isTrue);
      expect(boundsContain(_mugla.bounds, 36.3, 27.2), isTrue);
      expect(boundsContain(_mugla.bounds, 38, 28.4), isFalse);
    });
  });

  group('suggestMapPacks', () {
    test('arılığın ya da durağın içinde kaldığı paketler, indirilmişler '
        'hariç; çok arılıklı önce', () {
      final suggestions = suggestMapPacks(
        packs: [_mugla, _mersin, _izmir],
        installedIds: {},
        apiaries: [
          (latitude: 37.1, longitude: 28.4),
          (latitude: 38.5, longitude: 27.1),
          (latitude: 38.6, longitude: 27.2),
        ],
        stops: [
          _stop('Narenciye', place: 'Erdemli, MERSİN'),
          _stop('Çam', latitude: 37, longitude: 28),
          _stop('Kestane', place: 'Zonguldak'),
          _stop('Boş'),
        ],
      );

      expect(
        [
          for (final s in suggestions)
            (s.pack.id, s.apiaryCount, s.stopNames.join(', ')),
        ],
        [('tr-35', 2, ''), ('tr-48', 1, 'Çam'), ('tr-33', 0, 'Narenciye')],
      );

      expect(
        suggestMapPacks(
          packs: [_mugla, _mersin, _izmir],
          installedIds: {'tr-35', 'tr-48'},
          apiaries: [(latitude: 38.5, longitude: 27.1)],
          stops: [_stop('Narenciye', place: 'Mersin')],
        ).map((s) => s.pack.id),
        ['tr-33'],
      );
    });

    test('yer metni Türkçe küçük harfle ve her dildeki adla eşleşir', () {
      List<String> match(String place) => [
        for (final s in suggestMapPacks(
          packs: [_mugla, _izmir],
          installedIds: {},
          apiaries: const [],
          stops: [_stop('Kışlak', place: place)],
        ))
          s.pack.id,
      ];

      expect(match('Köyceğiz, MUĞLA'), ['tr-48']);
      expect(match('Mugla'), ['tr-48']);
      expect(match('İZMİR'), ['tr-35']);
      expect(match('Ödemiş'), isEmpty);
      // Durağın konumu varsa yer metnine bakılmaz.
      expect(
        suggestMapPacks(
          packs: [_mugla],
          installedIds: {},
          apiaries: const [],
          stops: [_stop('Çam', place: 'Muğla', latitude: 40, longitude: 30)],
        ),
        isEmpty,
      );
    });
  });
}

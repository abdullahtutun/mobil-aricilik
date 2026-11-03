import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';

const _yayla = MapArea(
  id: 'a-1',
  name: 'Yayla',
  latitude: 37.1,
  longitude: 28.4,
);
const _kislak = MapArea(
  id: 'a-2',
  name: 'Kışlak',
  latitude: 41,
  longitude: 37.6,
);

InstalledMapArea _installed(MapArea area) => InstalledMapArea(
  area: area,
  tileCount: 120,
  bytes: 3 * 1024 * 1024,
  downloadedAt: DateTime.utc(2026, 11, 3, 8),
);

void main() {
  group('mapAreaTiles', () {
    test(
      'genel görünüm 6–10, ayrıntı 11–14; OpenFreeMap sınırının altında',
      () {
        for (final area in [
          _yayla,
          _kislak,
          const MapArea(id: 'k', name: 'Kuzey', latitude: 64, longitude: 25),
        ]) {
          final tiles = mapAreaTiles(area);
          final zooms = {for (final tile in tiles) tile.z};
          expect(zooms, {6, 7, 8, 9, 10, 11, 12, 13, 14});
          expect(tiles.toSet().length, tiles.length, reason: 'tekrar yok');
          expect(tiles.length, lessThan(mapAreaMaxTiles));
          expect(estimateTileBytes(tiles), lessThan(mapAreaMaxBytes));
        }
        // Muğla'da arılık başına ~130 karo, birkaç MB.
        final tiles = mapAreaTiles(_yayla);
        expect(tiles.length, inInclusiveRange(80, 200));
        expect(
          estimateTileBytes(tiles),
          inInclusiveRange(2 * 1024 * 1024, 10 * 1024 * 1024),
        );
      },
    );

    test('ayrıntılı karolar arılığın 6 km çevresini kaplar', () {
      final z14 = [
        for (final tile in mapAreaTiles(_yayla))
          if (tile.z == 14) tileBounds(tile.z, tile.x, tile.y),
      ];
      final want = boundsAround(_yayla.latitude, _yayla.longitude, 6);
      double min(Iterable<double> v) => v.reduce((a, b) => a < b ? a : b);
      double max(Iterable<double> v) => v.reduce((a, b) => a > b ? a : b);
      expect(min(z14.map((b) => b.west)), lessThanOrEqualTo(want.west));
      expect(max(z14.map((b) => b.east)), greaterThanOrEqualTo(want.east));
      expect(min(z14.map((b) => b.south)), lessThanOrEqualTo(want.south));
      expect(max(z14.map((b) => b.north)), greaterThanOrEqualTo(want.north));
      // Arılığın kendi karosu içinde.
      expect(
        mapAreaTiles(_yayla),
        contains(tileAt(_yayla.latitude, _yayla.longitude, 14)),
      );
    });
  });

  test('karo, kutu ve TMS', () {
    expect(tileAt(0, 0, 1), (z: 1, x: 1, y: 1));
    expect(tileAt(85, -180, 2), (z: 2, x: 0, y: 0));
    final world = tileBounds(0, 0, 0);
    expect(world.west, -180);
    expect(world.north, closeTo(85.0511, 1e-4));
    expect(tmsRow(3, 0), 7);
    final tile = tileAt(37.1, 28.4, 10);
    final bounds = tileBounds(tile.z, tile.x, tile.y);
    expect(bounds.west, lessThanOrEqualTo(28.4));
    expect(bounds.east, greaterThan(28.4));
    expect(bounds.south, lessThanOrEqualTo(37.1));
    expect(bounds.north, greaterThan(37.1));
    expect(boundsIntersect(bounds, boundsAround(37.1, 28.4, 1)), isTrue);
    expect(boundsIntersect(bounds, boundsAround(41, 37.6, 1)), isFalse);
    expect(distanceKm(37.1, 28.4, 37.1, 28.4), 0);
    expect(distanceKm(37, 28, 38, 28), closeTo(111.2, 0.5));
  });

  group('mapAreaCandidates', () {
    test('indirilmemiş ve taşınmış arılıklar, verilen sırayla; durak adı', () {
      final moved = _kislak.copyWith(latitude: 41.05);
      final barely = _yayla.copyWith(latitude: 37.105);
      final candidates = mapAreaCandidates(
        apiaries: [
          barely,
          moved,
          const MapArea(id: 'a-3', name: 'Çam', latitude: 37, longitude: 28),
        ],
        installed: [_installed(_yayla), _installed(_kislak)],
        stopNamesByApiary: {
          'a-3': ['Narenciye', 'Çam balı'],
        },
      );

      expect(
        [
          for (final c in candidates)
            (c.area.id, c.moved, c.stopNames.join(', ')),
        ],
        [('a-2', true, ''), ('a-3', false, 'Narenciye, Çam balı')],
      );
      expect(candidates.first.area.latitude, 41.05);
    });

    test('hepsi indirilmişse boş', () {
      expect(
        mapAreaCandidates(apiaries: [_yayla], installed: [_installed(_yayla)]),
        isEmpty,
      );
    });
  });

  test('indirilmiş alan listesi yazılıp geri okunur', () {
    final row = _installed(_yayla);
    expect(
      parseInstalledMapAreas([
        installedMapAreaToJson(row),
        {'id': 'eksik'},
      ]),
      [row],
    );
    expect(parseInstalledMapAreas({'x': 1}), isEmpty);
  });
}

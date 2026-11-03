import 'dart:math' as math;

import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';

/// Ayrıntılı çevre: arılar çoğunlukla 3 km içinde, en çok 5–6 km'ye kadar
/// uçar. 6 km uçuş alanını, çevredeki kaynakları (çam, narenciye), en yakın
/// köyü ve arılığa giden orman yolunu kapsar.
const mapAreaDetailRadiusKm = 6.0;
const ({int min, int max}) mapAreaDetailZooms = (min: 11, max: 14);

/// Genel görünüm: ilçe, ana yollar ve yön bulmak için.
const mapAreaOverviewRadiusKm = 40.0;
const ({int min, int max}) mapAreaOverviewZooms = (min: 6, max: 10);

/// OpenFreeMap'in herkese açık sunucusundan uygulama içi indirme sınırı
/// (openfreemap.org: indirme başına en çok 3000 karo ya da 50 MB, en çok 4
/// paralel istek, uygulamayı tanıtan User-Agent).
const mapAreaMaxTiles = 3000;
const int mapAreaMaxBytes = 50 * 1024 * 1024;
const mapAreaMaxParallel = 4;

/// Arılık taşınmış sayılır: indirilen alanın merkezinden bu kadar uzakta.
const mapAreaMovedKm = 1.0;

const _kmPerDegree = 111.32;

/// Noktanın çevresinde [radiusKm] yarıçaplı (yaklaşık) kutu.
MapBounds boundsAround(double latitude, double longitude, double radiusKm) {
  final dLat = radiusKm / _kmPerDegree;
  final dLon = radiusKm / (_kmPerDegree * math.cos(latitude * math.pi / 180));
  return MapBounds(
    west: longitude - dLon,
    south: latitude - dLat,
    east: longitude + dLon,
    north: latitude + dLat,
  );
}

/// Noktanın [z] zoom'undaki XYZ karosu.
TileId tileAt(double latitude, double longitude, int z) {
  final n = 1 << z;
  final lat = latitude.clamp(-85.0511, 85.0511) * math.pi / 180;
  final x = ((longitude + 180) / 360 * n).floor();
  final y =
      ((1 - math.log(math.tan(lat) + 1 / math.cos(lat)) / math.pi) / 2 * n)
          .floor();
  return (z: z, x: x.clamp(0, n - 1), y: y.clamp(0, n - 1));
}

/// Kutuya değen [z] zoom'undaki karolar.
List<TileId> tilesInBounds(MapBounds bounds, int z) {
  final northWest = tileAt(bounds.north, bounds.west, z);
  final southEast = tileAt(bounds.south, bounds.east, z);
  return [
    for (var x = northWest.x; x <= southEast.x; x++)
      for (var y = northWest.y; y <= southEast.y; y++) (z: z, x: x, y: y),
  ];
}

/// Alanın indirilecek karoları: genel görünüm ve ayrıntılı çevre.
List<TileId> mapAreaTiles(MapArea area) => [
  for (var z = mapAreaOverviewZooms.min; z <= mapAreaOverviewZooms.max; z++)
    ...tilesInBounds(mapAreaOverviewBounds(area), z),
  for (var z = mapAreaDetailZooms.min; z <= mapAreaDetailZooms.max; z++)
    ...tilesInBounds(
      boundsAround(area.latitude, area.longitude, mapAreaDetailRadiusKm),
      z,
    ),
];

/// Alanın en dış kutusu (genel görünüm).
MapBounds mapAreaOverviewBounds(MapArea area) =>
    boundsAround(area.latitude, area.longitude, mapAreaOverviewRadiusKm);

/// Zoom'a göre ortalama karo boyutu (OpenFreeMap, kırsal ve kasaba
/// karışık, 2026-11 ölçümü).
const Map<int, int> _averageTileBytes = {
  6: 120 * 1024,
  7: 120 * 1024,
  8: 115 * 1024,
  9: 90 * 1024,
  10: 55 * 1024,
  11: 35 * 1024,
  12: 20 * 1024,
  13: 12 * 1024,
  14: 8 * 1024,
};

/// İndirmeden önce gösterilen tahmini boyut.
int estimateTileBytes(List<TileId> tiles) =>
    tiles.fold(0, (sum, tile) => sum + (_averageTileBytes[tile.z] ?? 0));

/// XYZ karosunun kapladığı kutu.
MapBounds tileBounds(int z, int x, int y) {
  final n = 1 << z;
  double latitude(int row) =>
      math.atan(_sinh(math.pi * (1 - 2 * row / n))) * 180 / math.pi;
  return MapBounds(
    west: x / n * 360 - 180,
    east: (x + 1) / n * 360 - 180,
    north: latitude(y),
    south: latitude(y + 1),
  );
}

double _sinh(double value) => (math.exp(value) - math.exp(-value)) / 2;

/// MBTiles satırları TMS düzeninde: y ekseni güneyden kuzeye.
int tmsRow(int z, int y) => (1 << z) - 1 - y;

/// İki kutu kesişiyor mu (kenarda değmek sayılmaz).
bool boundsIntersect(MapBounds a, MapBounds b) =>
    a.west < b.east &&
    b.west < a.east &&
    a.south < b.north &&
    b.south < a.north;

/// İki nokta arasındaki büyük daire uzaklığı, km.
double distanceKm(
  double latitude1,
  double longitude1,
  double latitude2,
  double longitude2,
) {
  double radians(double degrees) => degrees * math.pi / 180;
  final dLat = radians(latitude2 - latitude1);
  final dLon = radians(longitude2 - longitude1);
  final a =
      math.pow(math.sin(dLat / 2), 2) +
      math.cos(radians(latitude1)) *
          math.cos(radians(latitude2)) *
          math.pow(math.sin(dLon / 2), 2);
  return 6371 * 2 * math.asin(math.sqrt(a));
}

/// İndirilmeye aday arılıklar, verilen sırayla: indirilmemiş olanlar ve
/// indirildikten sonra [mapAreaMovedKm]'den fazla taşınmış olanlar.
/// [stopNamesByApiary] arılığa bağlı geçmişte kalmamış göç durakları.
List<MapAreaCandidate> mapAreaCandidates({
  required List<MapArea> apiaries,
  required List<InstalledMapArea> installed,
  Map<String, List<String>> stopNamesByApiary = const {},
}) {
  final installedById = {for (final row in installed) row.area.id: row.area};
  return [
    for (final apiary in apiaries)
      if (installedById[apiary.id] case final downloaded
          when downloaded == null ||
              distanceKm(
                    downloaded.latitude,
                    downloaded.longitude,
                    apiary.latitude,
                    apiary.longitude,
                  ) >
                  mapAreaMovedKm)
        MapAreaCandidate(
          area: apiary,
          stopNames: stopNamesByApiary[apiary.id] ?? const [],
          moved: downloaded != null,
        ),
  ];
}

/// Bu telefondaki alan listesinin (`installed.json`) bir satırı.
Map<String, Object?> installedMapAreaToJson(InstalledMapArea installed) => {
  'id': installed.area.id,
  'name': installed.area.name,
  'latitude': installed.area.latitude,
  'longitude': installed.area.longitude,
  'tile_count': installed.tileCount,
  'bytes': installed.bytes,
  'downloaded_at': installed.downloadedAt.toIso8601String(),
};

/// [installedMapAreaToJson]'ın tersi; okunamayan satır atlanır.
List<InstalledMapArea> parseInstalledMapAreas(Object? json) => [
  if (json is List<Object?>)
    for (final row in json)
      if (row case {
        'id': final String id,
        'name': final String name,
        'latitude': final num latitude,
        'longitude': final num longitude,
        'tile_count': final int tileCount,
        'bytes': final int bytes,
        'downloaded_at': final String downloadedAt,
      })
        InstalledMapArea(
          area: MapArea(
            id: id,
            name: name,
            latitude: latitude.toDouble(),
            longitude: longitude.toDouble(),
          ),
          tileCount: tileCount,
          bytes: bytes,
          downloadedAt: DateTime.parse(downloadedAt),
        ),
];

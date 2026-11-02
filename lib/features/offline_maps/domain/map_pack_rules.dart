import 'dart:math' as math;

import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';

/// Uygulamanın okuyabildiği katalog biçimi (`catalog.json` → `format`).
const mapPackCatalogFormat = 1;

/// Storage'daki `catalog.json`. Okunamayan paket atlanır; katalogun kendisi
/// geçersizse ya da biçimi [mapPackCatalogFormat] değilse [FormatException]
/// atar.
MapPackCatalog parseMapPackCatalog(Object? json) {
  if (json case {
    'format': final int format,
    'version': final String version,
    'generated_at': final String generatedAt,
    'packs': final List<Object?> packs,
  }) {
    if (format != mapPackCatalogFormat) {
      throw FormatException('Desteklenmeyen biçim', format);
    }
    return MapPackCatalog(
      version: version,
      generatedAt: DateTime.parse(generatedAt),
      packs: [for (final pack in packs) ?_parsePack(pack)],
    );
  }
  throw const FormatException('Geçersiz katalog');
}

MapPack? _parsePack(Object? json) {
  if (json case {
    'id': final String id,
    'name': final Object name,
    'bbox': [final num west, final num south, final num east, final num north],
    'minzoom': final int minZoom,
    'maxzoom': final int maxZoom,
    'url': final String url,
    'bytes': final int bytes,
    'sha256': final String sha256,
  }) {
    final names = switch (name) {
      final String single => {'': single},
      final Map<String, Object?> byLanguage => {
        for (final MapEntry(:key, :value) in byLanguage.entries)
          if (value is String) key: value,
      },
      _ => const <String, String>{},
    };
    if (names.isEmpty || west >= east || south >= north) return null;
    return MapPack(
      id: id,
      names: names,
      bounds: MapBounds(
        west: west.toDouble(),
        south: south.toDouble(),
        east: east.toDouble(),
        north: north.toDouble(),
      ),
      minZoom: minZoom,
      maxZoom: maxZoom,
      url: url,
      bytes: bytes,
      sha256: sha256.toLowerCase(),
    );
  }
  return null;
}

/// Bu telefondaki paket listesinin (`installed.json`) bir satırı.
Map<String, Object?> installedMapPackToJson(InstalledMapPack installed) {
  final pack = installed.pack;
  return {
    'id': pack.id,
    'name': pack.names,
    'bbox': [
      pack.bounds.west,
      pack.bounds.south,
      pack.bounds.east,
      pack.bounds.north,
    ],
    'minzoom': pack.minZoom,
    'maxzoom': pack.maxZoom,
    'url': pack.url,
    'bytes': pack.bytes,
    'sha256': pack.sha256,
    'version': installed.version,
    'generated_at': installed.generatedAt.toIso8601String(),
    'downloaded_at': installed.downloadedAt.toIso8601String(),
  };
}

/// [installedMapPackToJson]'ın tersi; okunamayan satır atlanır.
List<InstalledMapPack> parseInstalledMapPacks(Object? json) => [
  if (json is List<Object?>)
    for (final row in json)
      if (row case {
        'version': final String version,
        'generated_at': final String generatedAt,
        'downloaded_at': final String downloadedAt,
      })
        if (_parsePack(row) case final pack?)
          InstalledMapPack(
            pack: pack,
            version: version,
            generatedAt: DateTime.parse(generatedAt),
            downloadedAt: DateTime.parse(downloadedAt),
          ),
];

/// Paketin [languageCode]'daki adı; yoksa İngilizcesi, o da yoksa ilki.
String mapPackName(MapPack pack, String languageCode) =>
    pack.names[languageCode] ?? pack.names['en'] ?? pack.names.values.first;

/// Nokta kutunun içinde mi (kenar dahil).
bool boundsContain(MapBounds bounds, double latitude, double longitude) =>
    latitude >= bounds.south &&
    latitude <= bounds.north &&
    longitude >= bounds.west &&
    longitude <= bounds.east;

/// İki kutu kesişiyor mu (kenarda değmek sayılmaz).
bool boundsIntersect(MapBounds a, MapBounds b) =>
    a.west < b.east &&
    b.west < a.east &&
    a.south < b.north &&
    b.south < a.north;

/// XYZ karosunun ([z]/[x]/[y], Web Mercator) kapladığı kutu.
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

/// Paketin içindeki konumlu arılık sayısı.
int apiaryCountInPack(
  MapPack pack,
  Iterable<({double latitude, double longitude})> apiaries,
) => apiaries
    .where(
      (point) => boundsContain(pack.bounds, point.latitude, point.longitude),
    )
    .length;

/// Arılıkların ya da göç duraklarının içinde kaldığı, henüz indirilmemiş
/// paketler; önce arılığı çok olan, sonra durağı olan, eşitse katalog
/// sırası. Durak konumu bağlı arılıktan gelir; konumu yoksa "yer" metninde
/// paketin adlarından biri geçiyorsa (Türkçe küçük harfle) o pakette
/// sayılır.
List<MapPackSuggestion> suggestMapPacks({
  required List<MapPack> packs,
  required Set<String> installedIds,
  required List<({double latitude, double longitude})> apiaries,
  required List<MapStopPlace> stops,
}) {
  final suggestions = <MapPackSuggestion>[];
  for (final pack in packs) {
    if (installedIds.contains(pack.id)) continue;
    final apiaryCount = apiaryCountInPack(pack, apiaries);
    final stopNames = [
      for (final stop in stops)
        if (_stopInPack(pack, stop)) stop.name,
    ];
    if (apiaryCount == 0 && stopNames.isEmpty) continue;
    suggestions.add(
      MapPackSuggestion(
        pack: pack,
        apiaryCount: apiaryCount,
        stopNames: stopNames,
      ),
    );
  }
  final order = {for (final (i, pack) in packs.indexed) pack.id: i};
  return suggestions..sort((a, b) {
    final byApiaries = b.apiaryCount.compareTo(a.apiaryCount);
    if (byApiaries != 0) return byApiaries;
    final byStops = b.stopNames.length.compareTo(a.stopNames.length);
    if (byStops != 0) return byStops;
    return order[a.pack.id]!.compareTo(order[b.pack.id]!);
  });
}

bool _stopInPack(MapPack pack, MapStopPlace stop) {
  if ((stop.latitude, stop.longitude) case (
    final latitude?,
    final longitude?,
  )) {
    return boundsContain(pack.bounds, latitude, longitude);
  }
  final place = stop.place;
  if (place == null || place.trim().isEmpty) return false;
  final text = _turkishLower(place);
  return pack.names.values.any(
    (name) => name.trim().isNotEmpty && text.contains(_turkishLower(name)),
  );
}

String _turkishLower(String value) =>
    value.replaceAll('İ', 'i').replaceAll('I', 'ı').toLowerCase();

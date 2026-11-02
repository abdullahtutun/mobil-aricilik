import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/widgets.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/features/offline_maps/data/map_pack_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack_rules.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';
import 'package:vector_tile_renderer/vector_tile_renderer.dart'
    show SpriteIndexReader, ThemeReader;

/// İndirilmiş paketlerden altlık. İnternet yokken haritanın açılması için;
/// ekranlar buna provider üzerinden ulaşır.
abstract interface class OfflineBasemapService {
  /// İndirilmiş paket ve kaydedilmiş stil varsa altlık, yoksa null.
  Future<Basemap?> load();
}

/// Paketler ve stil [MapPackStore]'da.
class MbtilesBasemapService implements OfflineBasemapService {
  const new(this._store);

  final MapPackStore _store;

  @override
  Future<Basemap?> load() async {
    final List<InstalledMapPack> installed;
    final OfflineStyleFiles? style;
    try {
      installed = await _store.installed();
      style = await _store.readStyle();
    } on Exception {
      // Klasör okunamadı; paket yok sayılır.
      return null;
    }
    if (installed.isEmpty || style == null) return null;
    final sources = [
      for (final row in installed)
        (pack: row.pack, path: (await _store.packFile(row.pack.id)).path),
    ];
    return OfflineBasemap.open(style, sources);
  }
}

/// MBTiles paketlerinden çizilen altlık. Stil OpenFreeMap'inki; vektör
/// kaynağı (`openmaptiles`) paketlerden okunur, başka kaynaklı katmanlar
/// (Natural Earth gölgelendirmesi) atılır. Paket dışında kalan yer boş.
class OfflineBasemap implements Basemap {
  new _(this._style, this._provider);

  /// Stil okunamazsa [BasemapUnavailable] atar.
  factory open(
    OfflineStyleFiles files,
    List<({MapPack pack, String path})> sources,
  ) {
    final MbtilesTileProvider provider;
    final Style style;
    try {
      final json = jsonDecode(files.style) as Map<String, dynamic>;
      provider = MbtilesTileProvider.open(sources);
      style = Style(
        theme: ThemeReader().read(_vectorOnly(json)),
        providers: TileProviders({vectorSource: provider}),
        sprites: switch (files) {
          (spriteIndex: final index?, spriteAtlas: final atlas?, style: _) =>
            SpriteStyle(
              atlasProvider: () async => atlas,
              index: SpriteIndexReader().read(
                jsonDecode(index) as Map<String, dynamic>,
              ),
            ),
          _ => null,
        },
      );
    } on Object catch (error) {
      throw BasemapUnavailable(error);
    }
    return OfflineBasemap._(style, provider);
  }

  /// OpenMapTiles şemasındaki vektör kaynağın stildeki adı.
  static const vectorSource = 'openmaptiles';

  final Style _style;
  final MbtilesTileProvider _provider;

  @override
  Widget tileLayer() => VectorTileLayer(
    theme: _style.theme,
    sprites: _style.sprites,
    tileProviders: _style.providers,
  );

  @override
  bool get offline => true;

  @override
  void dispose() => _provider.dispose();

  /// Yalnız [vectorSource]'u ve onu kullanan katmanları bırakır.
  static Map<String, dynamic> _vectorOnly(Map<String, dynamic> style) => {
    ...style,
    'sources': {
      vectorSource: {'type': 'vector'},
    },
    'layers': [
      for (final layer in style['layers'] as List<dynamic>)
        if (layer case {'source': final String source}
            when source != vectorSource)
          ...const <dynamic>[]
        else
          layer,
    ],
  };
}

/// Karoları MBTiles dosyalarından okur. Karo birden çok paketteyse ilk
/// açılanınki kullanılır; hiçbirinde yoksa 404 (boş karo). Gzip'li PBF
/// açılır.
class MbtilesTileProvider extends VectorTileProvider {
  new _(this._packs);

  /// Dosyaları salt okunur açar.
  factory open(List<({MapPack pack, String path})> sources) =>
      MbtilesTileProvider._([
        for (final source in sources)
          (
            pack: source.pack,
            db: sqlite3.open(source.path, mode: OpenMode.readOnly),
          ),
      ]);

  final List<({MapPack pack, Database db})> _packs;

  @override
  int get maximumZoom =>
      _packs.fold(0, (max, p) => p.pack.maxZoom > max ? p.pack.maxZoom : max);

  @override
  int get minimumZoom => _packs.fold(
    maximumZoom,
    (min, p) => p.pack.minZoom < min ? p.pack.minZoom : min,
  );

  @override
  TileOffset get tileOffset => TileOffset.DEFAULT;

  @override
  Future<Uint8List> provide(TileIdentity tile) async {
    final bounds = tileBounds(tile.z, tile.x, tile.y);
    for (final (:pack, :db) in _packs) {
      if (tile.z < pack.minZoom || tile.z > pack.maxZoom) continue;
      if (!boundsIntersect(pack.bounds, bounds)) continue;
      final rows = db.select(
        'SELECT tile_data FROM tiles '
        'WHERE zoom_level = ? AND tile_column = ? AND tile_row = ?',
        [tile.z, tile.x, tmsRow(tile.z, tile.y)],
      );
      if (rows.isEmpty) continue;
      final data = rows.first['tile_data'] as Uint8List;
      return _isGzip(data) ? Uint8List.fromList(gzip.decode(data)) : data;
    }
    throw ProviderException(
      message: 'tile not in offline packs',
      retryable: Retryable.none,
      statusCode: 404,
    );
  }

  static bool _isGzip(Uint8List data) =>
      data.length > 2 && data[0] == 0x1f && data[1] == 0x8b;

  void dispose() {
    for (final (pack: _, :db) in _packs) {
      db.close();
    }
  }
}

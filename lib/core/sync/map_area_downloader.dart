import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/features/offline_maps/data/map_area_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';
import 'package:sqlite3/sqlite3.dart';

/// İndirme kullanıcı tarafından iptal edildi.
class MapAreaDownloadCancelled implements Exception {
  const new();
}

/// İndirme bitmedi: ağ, sunucu, zaman aşımı ya da alan OpenFreeMap'in
/// indirme sınırını aşıyor.
class MapAreaDownloadFailed implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'MapAreaDownloadFailed($cause)';
}

/// Süren indirmeyi durdurur.
class MapAreaCancelToken {
  final _cancelled = Completer<void>();

  bool get isCancelled => _cancelled.isCompleted;

  Future<void> get whenCancelled => _cancelled.future;

  void cancel() {
    if (!_cancelled.isCompleted) _cancelled.complete();
  }
}

/// Arılık çevresinin karolarını telefon doğrudan OpenFreeMap'ten indirir ve
/// bir MBTiles dosyasına yazar; sunucumuz araya girmez. OpenFreeMap'in
/// uygulama içi indirme koşullarına uyar: indirme başına en çok
/// [mapAreaMaxTiles] karo ve [mapAreaMaxBytes], en çok
/// [mapAreaMaxParallel] paralel istek ve uygulamayı tanıtan [userAgent].
/// Haritanın internetsiz çizilmesi için stili de indirir. Uygulamada tek
/// örnek `mapAreaDownloaderProvider`'dan gelir.
class MapAreaDownloader {
  new(this._client, {this.userAgent = defaultUserAgent});

  final http.Client _client;
  final String userAgent;

  static const defaultUserAgent = 'MobilArici-offline-maps/1.0';

  /// OpenMapTiles kaynağının TileJSON'u; karo adresi sürümlü, buradan okunur.
  static const tileJsonUri = 'https://tiles.openfreemap.org/planet';

  /// Tek isteğin süre sınırı.
  static const requestTimeout = Duration(seconds: 30);

  /// Geçici hatada bir karo en çok bu kadar denenir.
  static const tileAttempts = 3;

  /// [tiles]'ı [target]'a MBTiles olarak yazar; her karodan sonra
  /// [onProgress] biten karo sayısı ve inen baytla çağrılır. Sunucuda
  /// olmayan karo (204, 404) atlanır. [cancel] ile durdurulursa
  /// [MapAreaDownloadCancelled], başka her hatada [MapAreaDownloadFailed]
  /// atar. Yarım dosyayı silmek çağıranın işi.
  Future<void> download(
    List<TileId> tiles,
    File target, {
    required MapAreaCancelToken cancel,
    required void Function(int done, int bytes) onProgress,
  }) async {
    if (cancel.isCancelled) throw const MapAreaDownloadCancelled();
    if (tiles.length > mapAreaMaxTiles) {
      throw MapAreaDownloadFailed('${tiles.length} karo, sınır aşıldı');
    }
    if (target.existsSync()) target.deleteSync();
    final template = await _tileTemplate(cancel);
    final db = sqlite3.open(target.path)
      ..execute('CREATE TABLE metadata (name TEXT, value TEXT)')
      ..execute(
        'CREATE TABLE tiles (zoom_level INTEGER, tile_column INTEGER, '
        'tile_row INTEGER, tile_data BLOB)',
      )
      ..execute(
        'CREATE UNIQUE INDEX tile_index ON tiles '
        '(zoom_level, tile_column, tile_row)',
      );
    final insert = db.prepare(
      'INSERT OR REPLACE INTO tiles VALUES (?, ?, ?, ?)',
    );
    final queue = [...tiles];
    var done = 0;
    var bytes = 0;
    Object? error;

    Future<void> worker() async {
      while (queue.isNotEmpty && error == null) {
        final tile = queue.removeLast();
        try {
          final data = await _tile(template, tile, cancel);
          if (error != null) return;
          if (data != null) {
            insert.execute([tile.z, tile.x, tmsRow(tile.z, tile.y), data]);
            bytes += data.length;
          }
          done++;
          if (bytes > mapAreaMaxBytes) {
            throw const MapAreaDownloadFailed('50 MB sınırı aşıldı');
          }
          onProgress(done, bytes);
        } on Object catch (e) {
          error ??= e;
        }
      }
    }

    try {
      await Future.wait([
        for (var i = 0; i < mapAreaMaxParallel; i++) worker(),
      ]);
      db.execute('INSERT INTO metadata VALUES (?, ?), (?, ?)', [
        'format',
        'pbf',
        'attribution',
        '© OpenFreeMap © OpenMapTiles © OpenStreetMap contributors',
      ]);
    } finally {
      insert.close();
      db.close();
    }
    switch (error) {
      case null:
        return;
      case final MapAreaDownloadCancelled cancelled:
        throw cancelled;
      case final MapAreaDownloadFailed failed:
        throw failed;
      case final Object other:
        throw MapAreaDownloadFailed(other);
    }
  }

  /// Karonun baytları; sunucuda yoksa null. Ağ hatasında [tileAttempts]
  /// kez dener.
  Future<Uint8List?> _tile(
    String template,
    TileId tile,
    MapAreaCancelToken cancel,
  ) async {
    final url = template
        .replaceAll('{z}', '${tile.z}')
        .replaceAll('{x}', '${tile.x}')
        .replaceAll('{y}', '${tile.y}');
    for (var attempt = 1; ; attempt++) {
      try {
        final response = await _get(url, cancel);
        return switch (response.statusCode) {
          HttpStatus.ok => response.bodyBytes,
          HttpStatus.noContent || HttpStatus.notFound => null,
          final code => throw MapAreaDownloadFailed('HTTP $code: $url'),
        };
      } on MapAreaDownloadCancelled {
        rethrow;
      } on Object {
        if (attempt >= tileAttempts) rethrow;
      }
    }
  }

  Future<String> _tileTemplate(MapAreaCancelToken cancel) async {
    try {
      final response = await _get(tileJsonUri, cancel);
      if (response.statusCode != HttpStatus.ok) {
        throw MapAreaDownloadFailed('HTTP ${response.statusCode}');
      }
      return switch (jsonDecode(utf8.decode(response.bodyBytes))) {
        {'tiles': [final String template, ...]} => template,
        _ => throw const MapAreaDownloadFailed('Geçersiz TileJSON'),
      };
    } on MapAreaDownloadCancelled {
      rethrow;
    } on MapAreaDownloadFailed {
      rethrow;
    } on Object catch (error) {
      throw MapAreaDownloadFailed(error);
    }
  }

  /// OpenFreeMap stili ve ikon atlası (önce 2x, olmazsa 1x; ikisi de
  /// yoksa atlassız). Stil okunamazsa [MapAreaDownloadFailed] atar.
  Future<OfflineStyleFiles> fetchStyle() async {
    final cancel = MapAreaCancelToken();
    try {
      final style = utf8.decode(
        await _bytes(OpenFreeMapService.styleUri, cancel),
      );
      final sprite = switch (jsonDecode(style)) {
        {'sprite': final String sprite} when sprite.isNotEmpty => sprite,
        _ => null,
      };
      if (sprite != null) {
        for (final suffix in const ['@2x', '']) {
          try {
            final index = utf8.decode(
              await _bytes('$sprite$suffix.json', cancel),
            );
            final atlas = await _bytes('$sprite$suffix.png', cancel);
            return (style: style, spriteIndex: index, spriteAtlas: atlas);
          } on Object {
            continue;
          }
        }
      }
      return (style: style, spriteIndex: null, spriteAtlas: null);
    } on Object catch (error) {
      throw MapAreaDownloadFailed(error);
    }
  }

  Future<Uint8List> _bytes(String url, MapAreaCancelToken cancel) async {
    final response = await _get(url, cancel);
    if (response.statusCode != HttpStatus.ok) {
      throw MapAreaDownloadFailed('HTTP ${response.statusCode}: $url');
    }
    return response.bodyBytes;
  }

  /// İptal edilince yanıtı beklemeden [MapAreaDownloadCancelled] atar.
  Future<http.Response> _get(String url, MapAreaCancelToken cancel) {
    if (cancel.isCancelled) throw const MapAreaDownloadCancelled();
    return Future.any([
      _client
          .get(Uri.parse(url), headers: {'User-Agent': userAgent})
          .timeout(requestTimeout),
      cancel.whenCancelled.then<http.Response>(
        (_) => throw const MapAreaDownloadCancelled(),
      ),
    ]);
  }
}

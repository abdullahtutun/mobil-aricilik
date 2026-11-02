import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/features/offline_maps/data/map_pack_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack_rules.dart';

/// Storage'dan bir dosyanın baytlarını indirir (`map-packs` bucket'ında
/// yol).
typedef MapCatalogDownload = Future<Uint8List> Function(String path);

/// İndirme kullanıcı tarafından iptal edildi.
class MapPackDownloadCancelled implements Exception {
  const new();
}

/// İndirme bitmedi: ağ, sunucu, zaman aşımı ya da dosya katalogla
/// uyuşmuyor (boyut, SHA-256).
class MapPackDownloadFailed implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'MapPackDownloadFailed($cause)';
}

/// Süren indirmeyi durdurur.
class MapPackCancelToken {
  final _cancelled = Completer<void>();

  bool get isCancelled => _cancelled.isCompleted;

  Future<void> get whenCancelled => _cancelled.future;

  void cancel() {
    if (!_cancelled.isCompleted) _cancelled.complete();
  }
}

/// Offline harita paketlerinin ağ tarafı: katalog (`map-packs` bucket'ı),
/// paketin akışlı indirilmesi (ilerleme, iptal, SHA-256 doğrulaması) ve
/// haritanın internetsiz çizilmesi için OpenFreeMap stili. Uygulamada tek
/// örnek `mapPackDownloaderProvider`'dan gelir.
class MapPackDownloader {
  new(this._catalogDownload, this._client);

  final MapCatalogDownload _catalogDownload;
  final http.Client _client;

  static const bucket = 'map-packs';
  static const catalogPath = 'catalog.json';

  /// Katalog, stil ve yanıtın başlaması için süre sınırı.
  static const requestTimeout = Duration(seconds: 30);

  /// Bu kadar süre hiç bayt gelmezse indirme kopmuş sayılır.
  static const idleTimeout = Duration(seconds: 60);

  /// Storage'daki katalog. Ağ hatası ya da geçersiz katalogda hata atar.
  Future<MapPackCatalog> catalog() async => parseMapPackCatalog(
    jsonDecode(
      utf8.decode(await _catalogDownload(catalogPath).timeout(requestTimeout)),
    ),
  );

  /// [pack]'i [target]'a yazar; her parçada [onProgress] o ana kadar gelen
  /// baytla çağrılır. Bitince boyut ve SHA-256 katalogla karşılaştırılır.
  /// [cancel] ile durdurulursa [MapPackDownloadCancelled], başka her
  /// hatada [MapPackDownloadFailed] atar. Yarım dosyayı silmek çağıranın
  /// işi.
  Future<void> download(
    MapPack pack,
    File target, {
    required MapPackCancelToken cancel,
    required void Function(int received) onProgress,
  }) async {
    if (cancel.isCancelled) throw const MapPackDownloadCancelled();
    try {
      final response = await _client
          .send(http.Request('GET', Uri.parse(pack.url)))
          .timeout(requestTimeout);
      if (response.statusCode != HttpStatus.ok) {
        throw MapPackDownloadFailed('HTTP ${response.statusCode}');
      }
      // Parçalar küçük (onlarca KB); eşzamanlı yazma ekranı bekletmez.
      final output = target.openSync(mode: FileMode.write);
      final digest = _DigestSink();
      final hash = sha256.startChunkedConversion(digest);
      final done = Completer<void>();
      var received = 0;
      final subscription = response.stream
          .timeout(idleTimeout)
          .listen(
            (chunk) {
              output.writeFromSync(chunk);
              hash.add(chunk);
              received += chunk.length;
              onProgress(received);
            },
            onError: (Object error) {
              if (!done.isCompleted) done.completeError(error);
            },
            onDone: () {
              if (!done.isCompleted) done.complete();
            },
            cancelOnError: true,
          );
      unawaited(
        cancel.whenCancelled.then((_) async {
          if (done.isCompleted) return;
          done.completeError(const MapPackDownloadCancelled());
          await subscription.cancel();
        }),
      );
      try {
        await done.future;
      } finally {
        output.closeSync();
      }
      hash.close();
      if (received != pack.bytes) {
        throw MapPackDownloadFailed('${pack.bytes} yerine $received bayt');
      }
      if (digest.value.toString() != pack.sha256) {
        throw const MapPackDownloadFailed('SHA-256 uyuşmuyor');
      }
    } on MapPackDownloadCancelled {
      rethrow;
    } on MapPackDownloadFailed {
      rethrow;
    } on Object catch (error) {
      throw MapPackDownloadFailed(error);
    }
  }

  /// OpenFreeMap stili ve ikon atlası (önce 2x, olmazsa 1x; ikisi de
  /// yoksa atlassız). Stil okunamazsa [MapPackDownloadFailed] atar.
  Future<OfflineStyleFiles> fetchStyle() async {
    try {
      final style = utf8.decode(await _get(OpenFreeMapService.styleUri));
      final sprite = switch (jsonDecode(style)) {
        {'sprite': final String sprite} when sprite.isNotEmpty => sprite,
        _ => null,
      };
      if (sprite != null) {
        for (final suffix in const ['@2x', '']) {
          try {
            final index = utf8.decode(await _get('$sprite$suffix.json'));
            final atlas = await _get('$sprite$suffix.png');
            return (style: style, spriteIndex: index, spriteAtlas: atlas);
          } on Object {
            continue;
          }
        }
      }
      return (style: style, spriteIndex: null, spriteAtlas: null);
    } on Object catch (error) {
      throw MapPackDownloadFailed(error);
    }
  }

  Future<Uint8List> _get(String url) async {
    final response = await _client.get(Uri.parse(url)).timeout(requestTimeout);
    if (response.statusCode != HttpStatus.ok) {
      throw MapPackDownloadFailed('HTTP ${response.statusCode}: $url');
    }
    return response.bodyBytes;
  }
}

class _DigestSink implements Sink<Digest> {
  late Digest value;

  @override
  void add(Digest data) => value = data;

  @override
  void close() {}
}

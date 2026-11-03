import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/sync/map_area_downloader.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';
import 'package:sqlite3/sqlite3.dart';

const _template = 'https://tiles.test/v1/{z}/{x}/{y}.pbf';

final List<TileId> _tiles = [
  for (var x = 0; x < 3; x++)
    for (var y = 0; y < 3; y++) (z: 14, x: 9000 + x, y: 6000 + y),
];

void main() {
  late Directory directory;
  late File target;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('map_area_downloader');
    target = File('${directory.path}/a-1.mbtiles.part');
  });

  tearDown(() => directory.deleteSync(recursive: true));

  /// TileJSON'u ve karoları sunar; [tile] karo yanıtını verir.
  MapAreaDownloader downloader(
    Future<http.Response> Function(Uri url) tile, {
    void Function(http.Request request)? onRequest,
  }) => MapAreaDownloader(
    MockClient((request) async {
      onRequest?.call(request);
      if (request.url.toString() == MapAreaDownloader.tileJsonUri) {
        return http.Response(
          jsonEncode({
            'tiles': [_template],
          }),
          200,
        );
      }
      return await tile(request.url);
    }),
  );

  http.Response ok(Uri url) => http.Response.bytes(utf8.encode(url.path), 200);

  test("karolar MBTiles'a TMS satırıyla yazılır; ilerleme bildirilir; "
      'User-Agent gönderilir', () async {
    final agents = <String?>{};
    final progress = <int>[];
    var bytes = 0;
    await downloader(
      (url) async => url.path.endsWith('/9001/6001.pbf')
          ? http.Response('', 204)
          : ok(url),
      onRequest: (request) => agents.add(request.headers['User-Agent']),
    ).download(
      _tiles,
      target,
      cancel: MapAreaCancelToken(),
      onProgress: (done, received) {
        progress.add(done);
        bytes = received;
      },
    );

    expect(agents, {MapAreaDownloader.defaultUserAgent});
    expect(progress.length, _tiles.length);
    expect(progress.last, _tiles.length);
    final db = sqlite3.open(target.path, mode: OpenMode.readOnly);
    addTearDown(db.close);
    final rows = db.select(
      'SELECT tile_data FROM tiles '
      'WHERE zoom_level = 14 AND tile_column = 9000 AND tile_row = ?',
      [tmsRow(14, 6002)],
    );
    expect(
      utf8.decode(rows.single['tile_data'] as Uint8List),
      '/v1/14/9000/6002.pbf',
    );
    // Boş karo (204) yazılmaz.
    expect(
      db.select('SELECT COUNT(*) AS n FROM tiles').single['n'],
      _tiles.length - 1,
    );
    expect(bytes, greaterThan(0));
  });

  test('geçici hata yeniden denenir; sürerse başarısız', () async {
    var failures = 2;
    await downloader((url) async {
      if (url.path.endsWith('/9000/6000.pbf') && failures-- > 0) {
        throw const SocketException('koptu');
      }
      return ok(url);
    }).download(
      _tiles,
      target,
      cancel: MapAreaCancelToken(),
      onProgress: (_, _) {},
    );

    await expectLater(
      downloader((url) async => http.Response('', 500)).download(
        _tiles,
        target,
        cancel: MapAreaCancelToken(),
        onProgress: (_, _) {},
      ),
      throwsA(isA<MapAreaDownloadFailed>()),
    );
  });

  test('sınırı aşan alan istenmez', () async {
    var requests = 0;
    await expectLater(
      downloader((url) async {
        requests++;
        return ok(url);
      }).download(
        [for (var x = 0; x <= mapAreaMaxTiles; x++) (z: 14, x: x, y: 0)],
        target,
        cancel: MapAreaCancelToken(),
        onProgress: (_, _) {},
      ),
      throwsA(isA<MapAreaDownloadFailed>()),
    );
    expect(requests, 0);
  });

  test('en çok 4 istek aynı anda; iptal bekleyen istekleri durdurur', () async {
    final gate = Completer<void>();
    var active = 0;
    var peak = 0;
    final cancel = MapAreaCancelToken();
    final download = downloader((url) async {
      active++;
      peak = active > peak ? active : peak;
      await gate.future;
      active--;
      return ok(url);
    }).download(_tiles, target, cancel: cancel, onProgress: (_, _) {});

    await pumpEventQueue();
    expect(peak, mapAreaMaxParallel);
    cancel.cancel();
    await expectLater(download, throwsA(isA<MapAreaDownloadCancelled>()));
    gate.complete();
  });

  test('stil ve atlas: 2x yoksa 1x; atlas hiç yoksa atlassız', () async {
    const sprite = 'https://tiles.test/sprites/ofm';
    final served = <String, String>{
      OpenFreeMapService.styleUri: jsonEncode({'sprite': sprite}),
      '$sprite.json': '{"a": {}}',
      '$sprite.png': 'png',
    };
    final client = MapAreaDownloader(
      MockClient((request) async {
        final body = served[request.url.toString()];
        return body == null ? http.Response('', 404) : http.Response(body, 200);
      }),
    );

    final style = await client.fetchStyle();
    expect(style.style, contains(sprite));
    expect(style.spriteIndex, '{"a": {}}');
    expect(style.spriteAtlas, utf8.encode('png'));

    served
      ..remove('$sprite.json')
      ..remove('$sprite.png');
    final bare = await client.fetchStyle();
    expect(bare.spriteIndex, isNull);

    served.remove(OpenFreeMapService.styleUri);
    await expectLater(
      client.fetchStyle(),
      throwsA(isA<MapAreaDownloadFailed>()),
    );
  });
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';
import 'package:mobil_arici/core/sync/map_pack_downloader.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';

MapPack _pack(Uint8List bytes, {String? sha}) => MapPack(
  id: 'tr-48',
  names: const {'tr': 'Muğla'},
  bounds: const MapBounds(west: 27, south: 36, east: 29, north: 37),
  minZoom: 6,
  maxZoom: 14,
  url: 'https://storage.test/tr-48.mbtiles',
  bytes: bytes.length,
  sha256: sha ?? sha256.convert(bytes).toString(),
);

void main() {
  late Directory directory;
  late File target;
  final bytes = Uint8List.fromList(List.generate(5000, (i) => i % 251));

  setUp(() {
    directory = Directory.systemTemp.createTempSync('map_pack_downloader');
    target = File('${directory.path}/tr-48.mbtiles.part');
  });

  tearDown(() => directory.deleteSync(recursive: true));

  MapPackDownloader downloader(
    MockClientStreamHandler handler, {
    Map<String, Uint8List> storage = const {},
  }) => MapPackDownloader((path) async {
    final file = storage[path];
    if (file == null) throw Exception('404');
    return file;
  }, MockClient.streaming(handler));

  Future<http.StreamedResponse> chunks(
    http.BaseRequest request,
    Object? _,
  ) async => http.StreamedResponse(
    Stream.fromIterable([bytes.sublist(0, 2000), bytes.sublist(2000)]),
    200,
  );

  test("katalog Storage'dan okunur", () async {
    final catalog = await downloader(
      chunks,
      storage: {
        MapPackDownloader.catalogPath: utf8.encode(
          jsonEncode({
            'format': 1,
            'version': '20261029',
            'generated_at': '2026-09-15T00:00:00Z',
            'packs': <Object>[],
          }),
        ),
      },
    ).catalog();
    expect(catalog.version, '20261029');
  });

  test(
    'paket parça parça yazılır, ilerleme bildirilir, özet doğrulanır',
    () async {
      final progress = <int>[];
      await downloader(chunks).download(
        _pack(bytes),
        target,
        cancel: MapPackCancelToken(),
        onProgress: progress.add,
      );
      expect(progress, [2000, 5000]);
      expect(target.readAsBytesSync(), bytes);
    },
  );

  test('özet ya da boyut uyuşmazsa ya da HTTP hatasında başarısız', () async {
    await expectLater(
      downloader(chunks).download(
        _pack(bytes, sha: 'ab'),
        target,
        cancel: MapPackCancelToken(),
        onProgress: (_) {},
      ),
      throwsA(isA<MapPackDownloadFailed>()),
    );
    await expectLater(
      downloader(chunks).download(
        _pack(Uint8List(10)),
        target,
        cancel: MapPackCancelToken(),
        onProgress: (_) {},
      ),
      throwsA(isA<MapPackDownloadFailed>()),
    );
    await expectLater(
      downloader(
        (request, _) async =>
            http.StreamedResponse(const Stream<List<int>>.empty(), 404),
      ).download(
        _pack(bytes),
        target,
        cancel: MapPackCancelToken(),
        onProgress: (_) {},
      ),
      throwsA(isA<MapPackDownloadFailed>()),
    );
  });

  test('iptal edilince yarıda durur', () async {
    final hold = Completer<void>();
    final cancel = MapPackCancelToken();
    Stream<List<int>> body() async* {
      yield bytes.sublist(0, 2000);
      await hold.future;
      yield bytes.sublist(2000);
    }

    final download =
        downloader((request, _) async => http.StreamedResponse(body(), 200))
            .download(
              _pack(bytes),
              target,
              cancel: cancel,
              onProgress: (received) {
                if (received == 2000) cancel.cancel();
              },
            );
    await expectLater(download, throwsA(isA<MapPackDownloadCancelled>()));
    hold.complete();

    // Baştan iptal edilmiş jeton hiç istemez.
    var requests = 0;
    await expectLater(
      downloader((request, _) async {
        requests++;
        return http.StreamedResponse(const Stream<List<int>>.empty(), 200);
      }).download(_pack(bytes), target, cancel: cancel, onProgress: (_) {}),
      throwsA(isA<MapPackDownloadCancelled>()),
    );
    expect(requests, 0);
  });

  test('stil ve atlas: 2x yoksa 1x; atlas hiç yoksa atlassız', () async {
    const sprite = 'https://tiles.test/sprites/ofm';
    final served = <String, String>{
      OpenFreeMapService.styleUri: jsonEncode({'sprite': sprite}),
      '$sprite.json': '{"a": {}}',
      '$sprite.png': 'png',
    };
    Future<http.StreamedResponse> serve(http.BaseRequest request, _) async {
      final body = served[request.url.toString()];
      return body == null
          ? http.StreamedResponse(const Stream<List<int>>.empty(), 404)
          : http.StreamedResponse(Stream.value(utf8.encode(body)), 200);
    }

    final style = await downloader(serve).fetchStyle();
    expect(style.style, contains(sprite));
    expect(style.spriteIndex, '{"a": {}}');
    expect(style.spriteAtlas, utf8.encode('png'));

    served
      ..remove('$sprite.json')
      ..remove('$sprite.png');
    final bare = await downloader(serve).fetchStyle();
    expect(bare.spriteIndex, isNull);
    expect(bare.spriteAtlas, isNull);

    served.remove(OpenFreeMapService.styleUri);
    await expectLater(
      downloader(serve).fetchStyle(),
      throwsA(isA<MapPackDownloadFailed>()),
    );
  });
}

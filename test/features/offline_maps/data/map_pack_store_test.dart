import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/offline_maps/data/map_pack_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';

InstalledMapPack _installed(String id) => InstalledMapPack(
  pack: MapPack(
    id: id,
    names: {'tr': id},
    bounds: const MapBounds(west: 27, south: 36, east: 29, north: 37),
    minZoom: 6,
    maxZoom: 14,
    url: 'https://x/$id.mbtiles',
    bytes: 3,
    sha256: 'ab',
  ),
  version: '20261029',
  generatedAt: DateTime.utc(2026, 9, 15),
  downloadedAt: DateTime.utc(2026, 10, 2),
);

void main() {
  late Directory directory;
  late MapPackStore store;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('map_pack_store');
    store = MapPackStore(Future.value(directory));
  });

  tearDown(() => directory.deleteSync(recursive: true));

  Future<void> install(String id) async {
    final partial = (await store.partialFile(id))..writeAsBytesSync([1, 2, 3]);
    await store.install(_installed(id), partial);
  }

  test(
    'kurulan paket listede ve dosyası yerinde; aynı kimlik yerine',
    () async {
      expect(await store.installed(), isEmpty);

      await install('tr-48');
      await install('tr-35');
      await install('tr-48');

      expect(
        [for (final row in await store.installed()) row.pack.id],
        ['tr-35', 'tr-48'],
      );
      expect((await store.packFile('tr-48')).readAsBytesSync(), [1, 2, 3]);
      expect((await store.partialFile('tr-48')).existsSync(), isFalse);
    },
  );

  test('dosyası silinmiş satır listelenmez', () async {
    await install('tr-48');
    (await store.packFile('tr-48')).deleteSync();
    expect(await store.installed(), isEmpty);
  });

  test('silme paketi kaldırır; son paketle stil de gider', () async {
    await install('tr-48');
    await install('tr-35');
    await store.saveStyle((
      style: '{"version": 8}',
      spriteIndex: '{}',
      spriteAtlas: Uint8List.fromList([9]),
    ));

    await store.remove('tr-48');
    expect([for (final row in await store.installed()) row.pack.id], ['tr-35']);
    expect((await store.packFile('tr-48')).existsSync(), isFalse);
    expect((await store.readStyle())?.spriteAtlas, [9]);

    await store.remove('tr-35');
    expect(await store.installed(), isEmpty);
    expect(await store.readStyle(), isNull);
  });

  test('atlassız stil eski atlası siler', () async {
    await store.saveStyle((
      style: 'a',
      spriteIndex: '{}',
      spriteAtlas: Uint8List.fromList([9]),
    ));
    await store.saveStyle((style: 'b', spriteIndex: null, spriteAtlas: null));
    final style = await store.readStyle();
    expect(style?.style, 'b');
    expect(style?.spriteIndex, isNull);
    expect(style?.spriteAtlas, isNull);
  });
}

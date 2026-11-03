import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/offline_maps/data/map_area_store.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';

InstalledMapArea _installed(String id) => InstalledMapArea(
  area: MapArea(id: id, name: id, latitude: 37.1, longitude: 28.4),
  tileCount: 120,
  bytes: 3,
  downloadedAt: DateTime.utc(2026, 11, 2),
);

void main() {
  late Directory directory;
  late MapAreaStore store;

  setUp(() {
    directory = Directory.systemTemp.createTempSync('map_area_store');
    store = MapAreaStore(Future.value(directory));
  });

  tearDown(() => directory.deleteSync(recursive: true));

  Future<void> install(String id) async {
    final partial = (await store.partialFile(id))..writeAsBytesSync([1, 2, 3]);
    await store.install(_installed(id), partial);
  }

  test('kurulan alan listede ve dosyası yerinde; aynı kimlik yerine', () async {
    expect(await store.installed(), isEmpty);

    await install('a-1');
    await install('a-2');
    await install('a-1');

    expect(
      [for (final row in await store.installed()) row.area.id],
      ['a-2', 'a-1'],
    );
    expect((await store.areaFile('a-1')).readAsBytesSync(), [1, 2, 3]);
    expect((await store.partialFile('a-1')).existsSync(), isFalse);
  });

  test('dosyası silinmiş satır listelenmez', () async {
    await install('a-1');
    (await store.areaFile('a-1')).deleteSync();
    expect(await store.installed(), isEmpty);
  });

  test('silme alanı kaldırır; son alanla stil de gider', () async {
    await install('a-1');
    await install('a-2');
    await store.saveStyle((
      style: '{"version": 8}',
      spriteIndex: '{}',
      spriteAtlas: Uint8List.fromList([9]),
    ));

    await store.remove('a-1');
    expect([for (final row in await store.installed()) row.area.id], ['a-2']);
    expect((await store.areaFile('a-1')).existsSync(), isFalse);
    expect((await store.readStyle())?.spriteAtlas, [9]);

    await store.remove('a-2');
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

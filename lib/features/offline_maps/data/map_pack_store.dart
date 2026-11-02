import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mobil_arici/features/offline_maps/domain/map_pack.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_pack_rules.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Haritanın internetsiz açılması için kaydedilen stil: OpenFreeMap stil
/// JSON'u ve varsa ikon atlası (sprite JSON + PNG).
typedef OfflineStyleFiles = ({
  String style,
  String? spriteIndex,
  Uint8List? spriteAtlas,
});

/// Bu telefona indirilen harita paketleri (uygulama destek klasöründe
/// `maps/`): her paket `<id>.mbtiles`, liste `installed.json`, stil
/// `style.json` (+ `sprite.json`, `sprite.png`). Senkronlanmaz; paketler
/// yalnız bu telefonun.
class MapPackStore {
  new(this._root);

  factory app() => MapPackStore(
    getApplicationSupportDirectory().then(
      (support) => Directory(p.join(support.path, 'maps')),
    ),
  );

  static const indexFile = 'installed.json';
  static const styleFile = 'style.json';
  static const spriteIndexFile = 'sprite.json';
  static const spriteAtlasFile = 'sprite.png';

  final Future<Directory> _root;
  Future<Directory>? _created;

  Future<Directory> get _directory =>
      _created ??= _root.then((root) => root..createSync(recursive: true));

  Future<File> _file(String name) async =>
      File(p.join((await _directory).path, name));

  /// İndirilmiş paketler, indirme sırasıyla. Dosyası olmayan satır atlanır.
  Future<List<InstalledMapPack>> installed() async {
    final index = await _file(indexFile);
    if (!index.existsSync()) return const [];
    try {
      final rows = parseInstalledMapPacks(jsonDecode(index.readAsStringSync()));
      return [
        for (final row in rows)
          if ((await packFile(row.pack.id)).existsSync()) row,
      ];
    } on FormatException {
      return const [];
    }
  }

  /// Paketin MBTiles dosyası; henüz olmayabilir.
  Future<File> packFile(String id) => _file('$id.mbtiles');

  /// İndirmenin yazıldığı geçici dosya; bitmeden paket gibi görünmez.
  Future<File> partialFile(String id) => _file('$id.mbtiles.part');

  /// [partial]'ı paketin dosyası yapar ve listeye yazar (aynı kimlik varsa
  /// yerine).
  Future<void> install(InstalledMapPack installed, File partial) async {
    partial.renameSync((await packFile(installed.pack.id)).path);
    final rows = [
      for (final row in await this.installed())
        if (row.pack.id != installed.pack.id) row,
      installed,
    ];
    await _writeIndex(rows);
  }

  /// Paketi ve listedeki satırını siler. Son paket gidince stil de silinir.
  Future<void> remove(String id) async {
    final rows = [
      for (final row in await installed())
        if (row.pack.id != id) row,
    ];
    await _writeIndex(rows);
    for (final file in [await packFile(id), await partialFile(id)]) {
      if (file.existsSync()) file.deleteSync();
    }
    if (rows.isEmpty) {
      for (final name in [styleFile, spriteIndexFile, spriteAtlasFile]) {
        final file = await _file(name);
        if (file.existsSync()) file.deleteSync();
      }
    }
  }

  Future<void> _writeIndex(List<InstalledMapPack> rows) async {
    final index = await _file(indexFile);
    File('${index.path}.part')
      ..writeAsStringSync(
        jsonEncode([for (final row in rows) installedMapPackToJson(row)]),
        flush: true,
      )
      ..renameSync(index.path);
  }

  /// Stili kaydeder; atlas yoksa eskisi silinir.
  Future<void> saveStyle(OfflineStyleFiles files) async {
    (await _file(styleFile)).writeAsStringSync(files.style, flush: true);
    final spriteIndex = await _file(spriteIndexFile);
    final spriteAtlas = await _file(spriteAtlasFile);
    if (files case (
      spriteIndex: final index?,
      spriteAtlas: final atlas?,
      style: _,
    )) {
      spriteIndex.writeAsStringSync(index, flush: true);
      spriteAtlas.writeAsBytesSync(atlas, flush: true);
    } else {
      for (final file in [spriteIndex, spriteAtlas]) {
        if (file.existsSync()) file.deleteSync();
      }
    }
  }

  /// Kaydedilen stil; yoksa null.
  Future<OfflineStyleFiles?> readStyle() async {
    final style = await _file(styleFile);
    if (!style.existsSync()) return null;
    final spriteIndex = await _file(spriteIndexFile);
    final spriteAtlas = await _file(spriteAtlasFile);
    final hasSprites = spriteIndex.existsSync() && spriteAtlas.existsSync();
    return (
      style: style.readAsStringSync(),
      spriteIndex: hasSprites ? spriteIndex.readAsStringSync() : null,
      spriteAtlas: hasSprites ? spriteAtlas.readAsBytesSync() : null,
    );
  }
}

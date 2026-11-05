import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:mobil_arici/features/offline_maps/domain/map_area.dart';
import 'package:mobil_arici/features/offline_maps/domain/map_area_rules.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Haritanın internetsiz açılması için kaydedilen stil: OpenFreeMap stil
/// JSON'u ve varsa ikon atlası (sprite JSON + PNG).
typedef OfflineStyleFiles = ({
  String style,
  String? spriteIndex,
  Uint8List? spriteAtlas,
});

/// Bu telefona indirilen arılık çevreleri (uygulama destek klasöründe
/// `maps/`): her alan `<id>.mbtiles`, liste `installed.json`, stil
/// `style.json` (+ `sprite.json`, `sprite.png`). Senkronlanmaz; alanlar
/// yalnız bu telefonun.
class MapAreaStore {
  new(this._root);

  factory app() => MapAreaStore(
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

  /// İndirilmiş alanlar, indirme sırasıyla. Dosyası olmayan satır atlanır.
  Future<List<InstalledMapArea>> installed() async {
    final index = await _file(indexFile);
    if (!index.existsSync()) return const [];
    try {
      final rows = parseInstalledMapAreas(jsonDecode(index.readAsStringSync()));
      return [
        for (final row in rows)
          if ((await areaFile(row.area.id)).existsSync()) row,
      ];
    } on FormatException {
      return const [];
    }
  }

  /// Alanın MBTiles dosyası; henüz olmayabilir.
  /// İndirilmiş her alanı, listeyi ve stili siler (hesap silindikten sonra
  /// cihaz temizliği); eşzamanlı.
  Future<void> clear() async {
    final directory = await _root;
    if (!directory.existsSync()) return;
    for (final entity in directory.listSync()) {
      entity.deleteSync(recursive: true);
    }
  }

  Future<File> areaFile(String id) => _file('$id.mbtiles');

  /// İndirmenin yazıldığı geçici dosya; bitmeden alan gibi görünmez.
  Future<File> partialFile(String id) => _file('$id.mbtiles.part');

  /// [partial]'ı alanın dosyası yapar ve listeye yazar (aynı kimlik varsa
  /// yerine).
  Future<void> install(InstalledMapArea installed, File partial) async {
    partial.renameSync((await areaFile(installed.area.id)).path);
    final rows = [
      for (final row in await this.installed())
        if (row.area.id != installed.area.id) row,
      installed,
    ];
    await _writeIndex(rows);
  }

  /// Alanı ve listedeki satırını siler. Son alan gidince stil de silinir.
  Future<void> remove(String id) async {
    final rows = [
      for (final row in await installed())
        if (row.area.id != id) row,
    ];
    await _writeIndex(rows);
    for (final file in [await areaFile(id), await partialFile(id)]) {
      if (file.existsSync()) file.deleteSync();
    }
    if (rows.isEmpty) {
      for (final name in [styleFile, spriteIndexFile, spriteAtlasFile]) {
        final file = await _file(name);
        if (file.existsSync()) file.deleteSync();
      }
    }
  }

  Future<void> _writeIndex(List<InstalledMapArea> rows) async {
    final index = await _file(indexFile);
    File('${index.path}.part')
      ..writeAsStringSync(
        jsonEncode([for (final row in rows) installedMapAreaToJson(row)]),
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

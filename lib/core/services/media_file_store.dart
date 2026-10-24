import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Foto ve sesli notların bu telefondaki klasörü (uygulama destek
/// klasöründe `media/`). Kayıtlarda yalnız dosya adı tutulur; iOS'ta
/// uygulama klasörünün tam yolu güncellemeyle değişebilir.
class MediaFileStore {
  new(this._root);

  /// Uygulamanın kendi klasörü.
  factory app() => MediaFileStore(
    getApplicationSupportDirectory().then(
      (support) => Directory(p.join(support.path, 'media')),
    ),
  );

  final Future<Directory> _root;
  Future<Directory>? _created;

  Future<Directory> get _directory =>
      _created ??= _root.then((root) => root..createSync(recursive: true));

  /// [fileName]'in tam yolu; dosya henüz olmayabilir.
  Future<String> pathOf(String fileName) async =>
      p.join((await _directory).path, fileName);

  /// [fileName] bu telefonda varsa dosyası, yoksa null.
  Future<File?> find(String fileName) async {
    final file = File(await pathOf(fileName));
    return file.existsSync() ? file : null;
  }

  /// [bytes]'ı [fileName] olarak yazar (ör. indirilen dosya). Önce geçici
  /// adla yazılıp taşınır; yarım kalan yazma dosya gibi görünmez.
  Future<File> write(String fileName, List<int> bytes) async {
    final path = await pathOf(fileName);
    final partial = await File('$path.part').writeAsBytes(bytes, flush: true);
    return await partial.rename(path);
  }

  /// Dosyayı siler; yoksa bir şey yapmaz. Küçük tek dosya; eşzamanlı.
  Future<void> delete(String fileName) async {
    final file = File(await pathOf(fileName));
    if (file.existsSync()) file.deleteSync();
  }
}

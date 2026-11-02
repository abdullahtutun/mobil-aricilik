import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_article.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';

/// Bilgi bankası içeriği; internet istemez. Uygulamayla gelen Markdown
/// dosyaları (`assets/knowledge/<dil>/*.md`, sürümü `manifest.json`'da) ya
/// da Storage'dan indirilip bu telefona kaydedilen paket: hangisinin sürümü
/// büyükse o okunur. Paketi `KnowledgeUpdateService` indirir.
class KnowledgeRepository {
  new(this.bundle, this.store);

  static const assetRoot = 'assets/knowledge/';
  static const manifestAsset = '${assetRoot}manifest.json';

  /// İndirilen paketin bu telefondaki adı.
  static const packageFile = 'package.json';

  final AssetBundle bundle;
  final MediaFileStore store;

  /// Okunacak içerik: indirilen paket daha yeniyse o, değilse uygulamayla
  /// gelen.
  Future<KnowledgeLibrary> load() async {
    final bundled = await loadBundled();
    final downloaded = await loadDownloaded();
    return downloaded != null && downloaded.version > bundled.version
        ? downloaded
        : bundled;
  }

  /// Uygulamayla gelen içerik.
  Future<KnowledgeLibrary> loadBundled() async {
    final manifest = jsonDecode(await bundle.loadString(manifestAsset));
    final paths = (await AssetManifest.loadFromAssetBundle(bundle))
        .listAssets()
        .where((path) => path.startsWith(assetRoot) && path.endsWith('.md'));
    return parseKnowledgePackage({
      if (manifest is Map<String, Object?>) ...manifest,
      'files': {
        for (final path in paths)
          path.substring(assetRoot.length): await bundle.loadString(path),
      },
    });
  }

  /// İndirilen paket; yoksa ya da okunamıyorsa null.
  Future<KnowledgeLibrary?> loadDownloaded() async {
    final file = await store.find(packageFile);
    if (file == null) return null;
    try {
      return parseKnowledgePackage(jsonDecode(file.readAsStringSync()));
    } on FormatException {
      return null;
    }
  }

  /// Doğrulanmış paketi kaydeder; bir sonraki [load] onu okur.
  Future<void> saveDownloaded(List<int> bytes) =>
      store.write(packageFile, bytes);
}

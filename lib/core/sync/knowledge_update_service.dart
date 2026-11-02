import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:mobil_arici/features/knowledge/data/knowledge_repository.dart';
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';

/// Storage'dan bir dosyanın baytlarını indirir (`knowledge` bucket'ında
/// yol).
typedef KnowledgeDownload = Future<Uint8List> Function(String path);

/// Bilgi bankasını uygulama güncellemesi olmadan günceller: Storage'daki
/// `manifest.json`'a bakar, sürüm bu telefondakinden büyükse paketi indirir,
/// SHA-256 ve sürümünü doğrular ve kaydeder. Herhangi bir hatada eldeki
/// içerik kalır; bir sonraki denemede yeniden bakılır.
///
/// Aynı anda tek kontrol çalışır. Uygulamada tek örnek
/// `knowledgeUpdateServiceProvider`'dan gelir.
class KnowledgeUpdateService {
  new(this._download, this._repository, {this.clock = DateTime.now});

  final KnowledgeDownload _download;
  final KnowledgeRepository _repository;

  /// Son kontrolün zamanı; testler sabit saat verir.
  final DateTime Function() clock;

  static const bucket = 'knowledge';
  static const manifestPath = 'manifest.json';

  /// Zorlanmayan kontroller arasındaki en kısa süre; her senkron turunda
  /// manifest indirilmesin.
  static const checkInterval = Duration(hours: 1);

  /// Tek isteğin süre sınırı.
  static const requestTimeout = Duration(seconds: 60);

  Future<bool>? _running;
  DateTime? _lastCheck;

  /// Yeni paket kaydedildiyse true. [force] false ise son kontrolden
  /// [checkInterval] geçmeden bakmaz.
  Future<bool> update({bool force = false}) {
    final last = _lastCheck;
    if (_running == null &&
        !force &&
        last != null &&
        clock().difference(last) < checkInterval) {
      return Future.value(false);
    }
    return _running ??= _update().whenComplete(() => _running = null);
  }

  Future<bool> _update() async {
    _lastCheck = clock();
    try {
      final manifest = parseKnowledgeManifest(
        jsonDecode(
          utf8.decode(await _download(manifestPath).timeout(requestTimeout)),
        ),
      );
      if (manifest.format != knowledgeFormat) return false;
      final current = await _repository.load();
      if (manifest.version <= current.version) return false;
      final bytes = await _download(manifest.path).timeout(requestTimeout);
      verifyKnowledgePackage(bytes, manifest);
      await _repository.saveDownloaded(bytes);
      return true;
    } on Exception {
      // Ağ, Storage (bucket boş, yetki), zaman aşımı ya da bozuk paket.
      return false;
    }
  }
}

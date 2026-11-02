import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/knowledge_update_service.dart';
import 'package:mobil_arici/core/sync/knowledge_update_service_provider.dart';
import 'package:mobil_arici/features/knowledge/data/knowledge_repository.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_providers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Cihazsız bilgi bankası: indirilen paket geçici klasörde, Storage
/// [files] haritası (boşsa her indirme 404). Asset'ler her testte yeni bir
/// bundle'dan okunur: `rootBundle`'ın önbelleğindeki Future önceki testin
/// sahte zamanına bağlı kalır ve bir daha tamamlanmaz.
class FakeKnowledge {
  new() : directory = Directory.systemTemp.createTempSync('fake_knowledge') {
    addTearDown(() => directory.deleteSync(recursive: true));
  }

  final Directory directory;
  late final store = MediaFileStore(Future.value(directory));

  /// Storage'daki dosyalar, yola göre.
  final files = <String, Uint8List>{};

  /// İstenen yollar, sırayla.
  final requested = <String>[];

  Future<Uint8List> download(String path) async {
    requested.add(path);
    final bytes = files[path];
    if (bytes == null) {
      throw const StorageException('Object not found', statusCode: '404');
    }
    return bytes;
  }

  /// Storage'a [version] sürümlü paketi ve onu gösteren manifesti koyar.
  /// Paketin baytlarını döner.
  Uint8List publish(int version, Map<String, String> markdown) {
    final path = 'knowledge-v$version.json';
    final bytes = utf8.encode(
      jsonEncode({'format': 1, 'version': version, 'files': markdown}),
    );
    files[path] = bytes;
    files[KnowledgeUpdateService.manifestPath] = utf8.encode(
      jsonEncode({
        'format': 1,
        'version': version,
        'path': path,
        'sha256': sha256.convert(bytes).toString(),
      }),
    );
    return bytes;
  }

  List<Override> get overrides => [
    knowledgeFileStoreProvider.overrideWithValue(store),
    knowledgeRepositoryProvider.overrideWithValue(
      KnowledgeRepository(PlatformAssetBundle(), store),
    ),
    knowledgeUpdateServiceProvider.overrideWith(
      (ref) => KnowledgeUpdateService(
        download,
        ref.watch(knowledgeRepositoryProvider),
      ),
    ),
  ];
}

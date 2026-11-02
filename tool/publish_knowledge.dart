// Bilgi bankası içeriğini uygulama güncellemesi olmadan yayımlar.
//
//   SUPABASE_URL=https://jcddnelaboueazhordfz.supabase.co \
//   SUPABASE_SERVICE_ROLE_KEY=... \
//   dart run tool/publish_knowledge.dart --version 2
//
// `assets/knowledge/<dil>/*.md` dosyalarını (ya da `--dir` ile verilen
// klasörü) okur; her makaleyi uygulamanın ayrıştırıcısıyla denetler, biri
// bile okunamazsa durur. Paketi `knowledge-v<N>.json` olarak yükler, sonra
// `manifest.json`'u ona çevirir (manifest hiçbir zaman olmayan bir paketi
// göstermez). `--dry-run` yalnız denetler ve özeti yazar.
//
// Sürüm, uygulamayla gelen `assets/knowledge/manifest.json` sürümünden ve
// daha önce yayımlanandan büyük olmalı; telefonlar yalnız daha büyük sürümü
// indirir. Aynı içerik bir sonraki uygulama sürümüyle gelecekse
// `assets/knowledge/manifest.json`'daki sürüm de bu sayıya çekilir.
//
// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  String? option(String name) {
    final index = args.indexOf('--$name');
    return index >= 0 && index + 1 < args.length ? args[index + 1] : null;
  }

  final version = int.tryParse(option('version') ?? '');
  final directory = Directory(option('dir') ?? 'assets/knowledge');
  final dryRun = args.contains('--dry-run');
  if (version == null || version < 1) {
    _fail(
      'Kullanım: dart run tool/publish_knowledge.dart --version <N> '
      '[--dir assets/knowledge] [--dry-run]',
    );
  }

  final bundled = jsonDecode(
    File(p.join(directory.path, 'manifest.json')).readAsStringSync(),
  ) as Map<String, Object?>;
  if (version <= (bundled['version'] as int? ?? 0)) {
    _fail(
      'Sürüm uygulamayla gelen sürümden (${bundled['version']}) '
      'büyük olmalı.',
    );
  }

  final files = <String, String>{};
  for (final entity in directory.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.md')) continue;
    final path = p.posix.joinAll(
      p.split(p.relative(entity.path, from: directory.path)),
    );
    final language = p.posix.split(path).first;
    final source = entity.readAsStringSync();
    try {
      parseKnowledgeArticle(source, language: language);
    } on FormatException catch (error) {
      _fail('$path okunamadı: ${error.message} (${error.source})');
    }
    files[path] = source;
  }
  if (files.isEmpty) _fail('${directory.path} içinde Markdown yok.');

  final bytes = utf8.encode(
    jsonEncode({'format': knowledgeFormat, 'version': version, 'files': files}),
  );
  final packagePath = 'knowledge-v$version.json';
  final manifest = utf8.encode(
    jsonEncode({
      'format': knowledgeFormat,
      'version': version,
      'path': packagePath,
      'sha256': sha256.convert(bytes).toString(),
    }),
  );
  // Uygulamanın doğrulamasıyla aynı denetim.
  final library = verifyKnowledgePackage(
    bytes,
    parseKnowledgeManifest(jsonDecode(utf8.decode(manifest))),
  );
  print(
    '${library.articles.length} makale, sürüm $version, '
    '${(bytes.length / 1024).toStringAsFixed(1)} KB',
  );
  if (dryRun) return;

  final url = Platform.environment['SUPABASE_URL'];
  final key = Platform.environment['SUPABASE_SERVICE_ROLE_KEY'];
  if (url == null || key == null) {
    _fail('SUPABASE_URL ve SUPABASE_SERVICE_ROLE_KEY gerekli.');
  }

  Future<void> upload(
    String path,
    List<int> body, {
    required bool upsert,
  }) async {
    final response = await http.post(
      Uri.parse('$url/storage/v1/object/knowledge/$path'),
      headers: {
        'Authorization': 'Bearer $key',
        'apikey': key,
        'Content-Type': 'application/json',
        // Manifest kısa önbellekte kalsın; paket sürümlü, değişmez.
        'Cache-Control': upsert ? 'max-age=60' : 'max-age=31536000',
        'x-upsert': '$upsert',
      },
      body: body,
    );
    if (response.statusCode >= 300) {
      _fail('$path yüklenemedi: ${response.statusCode} ${response.body}');
    }
    print('$path yüklendi');
  }

  await upload(packagePath, bytes, upsert: false);
  await upload('manifest.json', manifest, upsert: true);
}

Never _fail(String message) {
  stderr.writeln(message);
  exit(1);
}

// Bilgi bankası içeriğini uygulama güncellemesi olmadan yayımlar.
//
//   SUPABASE_URL=https://jcddnelaboueazhordfz.supabase.co \
//   SUPABASE_SERVICE_ROLE_KEY=... \
//   dart run tool/publish_knowledge.dart --version 2
//
//   PB_URL=https://... PB_SUPERUSER_EMAIL=... PB_SUPERUSER_PASSWORD=... \
//   dart run tool/publish_knowledge.dart --backend pocketbase --version 2
//
// `assets/knowledge/<dil>/*.md` dosyalarını (ya da `--dir` ile verilen
// klasörü) okur; her makaleyi uygulamanın ayrıştırıcısıyla denetler, biri
// bile okunamazsa durur. Paketi `knowledge-v<N>.json` olarak yükler, sonra
// `manifest.json`'u ona çevirir (manifest hiçbir zaman olmayan bir paketi
// göstermez). `--dry-run` yalnız denetler ve özeti yazar.
//
// `--backend`: `supabase` (varsayılan, P11.1'e kadar) `knowledge` bucket'ına,
// `pocketbase` `knowledge_packs` koleksiyonuna süper kullanıcı olarak yazar;
// aynı adlı kayıt varsa yalnız dosyası değişir. Gizli değerler yalnız
// ortamdan okunur ve hiçbir çıktıya yazılmaz.
//
// Sürüm, uygulamayla gelen `assets/knowledge/manifest.json` sürümünden ve
// daha önce yayımlanandan büyük olmalı; telefonlar yalnız daha büyük sürümü
// indirir. Aynı içerik bir sonraki uygulama sürümüyle gelecekse
// `assets/knowledge/manifest.json`'daki sürüm de bu sayıya çekilir.

import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/features/knowledge/domain/knowledge_rules.dart';
import 'package:path/path.dart' as p;

Future<void> main(List<String> args) async {
  final client = http.Client();
  try {
    await publishKnowledge(
      args,
      environment: Platform.environment,
      client: client,
      log: print,
    );
  } on PublishKnowledgeException catch (error) {
    stderr.writeln(error.message);
    exitCode = 1;
  } finally {
    client.close();
  }
}

/// Aracı durduran hata; `main` iletisini yazar ve 1 ile çıkar.
class PublishKnowledgeException implements Exception {
  const new(this.message);

  final String message;

  @override
  String toString() => message;
}

/// PocketBase'teki koleksiyon (server/migrations/1794300014_knowledge_packs).
const knowledgePacksCollection = 'knowledge_packs';

/// Aracın tamamı; testler sahte [client] ve [environment] verir.
Future<void> publishKnowledge(
  List<String> args, {
  required Map<String, String> environment,
  required http.Client client,
  required void Function(String) log,
}) async {
  String? option(String name) {
    final index = args.indexOf('--$name');
    return index >= 0 && index + 1 < args.length ? args[index + 1] : null;
  }

  final version = int.tryParse(option('version') ?? '');
  final directory = Directory(option('dir') ?? 'assets/knowledge');
  final dryRun = args.contains('--dry-run');
  final backend = option('backend') ?? 'supabase';
  if (version == null ||
      version < 1 ||
      !const {'supabase', 'pocketbase'}.contains(backend)) {
    _fail(
      'Kullanım: dart run tool/publish_knowledge.dart --version <N> '
      '[--backend supabase|pocketbase] [--dir assets/knowledge] [--dry-run]',
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
  log(
    '${library.articles.length} makale, sürüm $version, '
    '${(bytes.length / 1024).toStringAsFixed(1)} KB',
  );
  if (dryRun) return;

  final upload = switch (backend) {
    'pocketbase' => await _pocketBaseUploader(environment, client),
    _ => _supabaseUploader(environment, client),
  };
  for (final (name, body, mutable) in [
    (packagePath, bytes, false),
    ('manifest.json', manifest, true),
  ]) {
    await upload(name, body, mutable: mutable);
    log('$name yüklendi');
  }
}

typedef _Uploader = Future<void> Function(
  String name,
  List<int> body, {
  required bool mutable,
});

_Uploader _supabaseUploader(Map<String, String> env, http.Client client) {
  final url = env['SUPABASE_URL'];
  final key = env['SUPABASE_SERVICE_ROLE_KEY'];
  if (url == null || key == null) {
    _fail('SUPABASE_URL ve SUPABASE_SERVICE_ROLE_KEY gerekli.');
  }
  Future<void> upload(
    String name,
    List<int> body, {
    required bool mutable,
  }) async {
    final response = await client.post(
      Uri.parse('$url/storage/v1/object/knowledge/$name'),
      headers: {
        'Authorization': 'Bearer $key',
        'apikey': key,
        'Content-Type': 'application/json',
        // Manifest kısa önbellekte kalsın; paket sürümlü, değişmez.
        'Cache-Control': mutable ? 'max-age=60' : 'max-age=31536000',
        'x-upsert': '$mutable',
      },
      body: body,
    );
    _check(response, '$name yüklenemedi');
  }

  return upload;
}

/// Süper kullanıcı olarak girer; her ad için kayıt varsa dosyasını
/// değiştirir (PATCH), yoksa oluşturur (POST).
Future<_Uploader> _pocketBaseUploader(
  Map<String, String> env,
  http.Client client,
) async {
  final rawUrl = env['PB_URL'];
  final email = env['PB_SUPERUSER_EMAIL'];
  final password = env['PB_SUPERUSER_PASSWORD'];
  if (rawUrl == null || email == null || password == null) {
    _fail('PB_URL, PB_SUPERUSER_EMAIL ve PB_SUPERUSER_PASSWORD gerekli.');
  }
  final base = rawUrl.endsWith('/')
      ? rawUrl.substring(0, rawUrl.length - 1)
      : rawUrl;
  final auth = await client.post(
    Uri.parse('$base/api/collections/_superusers/auth-with-password'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'identity': email, 'password': password}),
  );
  // PocketBase'in hata gövdesi kimlik bilgisini geri yazmaz.
  _check(auth, 'Süper kullanıcı girişi başarısız');
  final token = (jsonDecode(auth.body) as Map<String, Object?>)['token'];
  if (token is! String) _fail('Süper kullanıcı girişi token döndürmedi.');
  final records = '$base/api/collections/$knowledgePacksCollection/records';
  final headers = {'Authorization': token};

  Future<void> upload(
    String name,
    List<int> body, {
    required bool mutable,
  }) async {
    final found = await client.get(
      Uri.parse(records).replace(
        queryParameters: {
          'filter': "(name='$name')",
          'perPage': '1',
          'fields': 'id',
          'skipTotal': '1',
        },
      ),
      headers: headers,
    );
    _check(found, '$name aranamadı');
    final items =
        (jsonDecode(found.body) as Map<String, Object?>)['items']!
            as List<Object?>;
    final id = items.isEmpty
        ? null
        : (items.first! as Map<String, Object?>)['id']! as String;

    final request =
        http.MultipartRequest(
            id == null ? 'POST' : 'PATCH',
            Uri.parse(id == null ? records : '$records/$id'),
          )
          ..headers.addAll(headers)
          ..files.add(
            http.MultipartFile.fromBytes('file', body, filename: name),
          );
    if (id == null) request.fields['name'] = name;
    final response = await http.Response.fromStream(await client.send(request));
    _check(response, '$name yüklenemedi');
  }

  return upload;
}

void _check(http.Response response, String message) {
  if (response.statusCode >= 300) {
    _fail('$message: ${response.statusCode} ${response.body}');
  }
}

Never _fail(String message) => throw PublishKnowledgeException(message);

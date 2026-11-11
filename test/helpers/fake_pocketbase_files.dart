import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';

/// Sahte sunucunun adresi.
const fakePocketBaseUrl = 'http://pocketbase.test';

/// [expiresAt]'e kadar geçerli, imzasız bir JWT; `AuthStore.isValid` yalnız
/// `exp`'e bakar.
String fakePocketBaseJwt(DateTime expiresAt, {String id = 'token'}) {
  String part(Object value) =>
      base64Url.encode(utf8.encode(jsonEncode(value))).replaceAll('=', '');
  return [
    part({'alg': 'HS256', 'typ': 'JWT'}),
    part({'id': id, 'exp': expiresAt.millisecondsSinceEpoch ~/ 1000}),
    'sig',
  ].join('.');
}

http.Response fakePocketBaseJson(Object? body, [int status = 200]) =>
    http.Response(
      jsonEncode(body),
      status,
      headers: {'content-type': 'application/json; charset=utf-8'},
    );

/// PocketBase'in kayıt hatası gövdesi; [data] alan hataları
/// (`{'file': 'validation_file_size_limit'}`).
http.Response fakePocketBaseError(
  int status, {
  Map<String, String> data = const {},
  String message = 'Failed to create record.',
}) => fakePocketBaseJson({
  'data': {
    for (final MapEntry(:key, :value) in data.entries)
      key: {'code': value, 'message': '$value mesajı'},
  },
  'message': message,
  'status': status,
}, status);

/// Aynı id ile ikinci yüklemenin yanıtı (P6.1, `files_test.go`
/// `alreadyUploaded`).
http.Response fakePocketBaseAlreadyUploaded() =>
    fakePocketBaseError(400, data: {'id': 'validation_pk_invalid'});

/// Sunucuya ulaşan bir yükleme.
typedef FakeUpload = ({
  String collection,
  Map<String, dynamic> body,
  String fileName,
  Uint8List bytes,
  String? authorization,
});

/// Dosya koleksiyonlarının sahte sunucusu (`server/internal/files`):
/// multipart create, `filter=path = "…"` (bilgi bankasında `name`) ile
/// liste, `POST /api/files/token` ve `/api/files/<koleksiyon>/<id>/<ad>`.
/// Korumalı dosya geçerli dosya token'ı olmadan 404 (P6.1); bilgi bankası
/// korumasız. Aynı id ikinci kez yüklenince [fakePocketBaseAlreadyUploaded].
///
/// [handler] null değilse önce o çağrılır; yanıt dönerse sahte sunucu
/// atlanır (hata ve ağ kesintisi için).
class FakePocketBaseFiles {
  /// Koleksiyon → id → kayıt.
  final records = <String, Map<String, Map<String, Object?>>>{};

  /// Kayıt id'si → dosyanın baytları.
  final contents = <String, Uint8List>{};

  final requests = <http.Request>[];
  final uploads = <FakeUpload>[];

  /// Sunucunun verdiği dosya token'ları; sonuncusu geçerli.
  final fileTokens = <String>[];

  FutureOr<http.Response?> Function(http.Request request)? handler;

  /// [collection]'a doğrudan bir kayıt ve dosyası koyar (başka cihazın
  /// yüklediği); [field] bilgi bankasında `name`.
  void put(
    String collection,
    String path,
    List<int> bytes, {
    String field = 'path',
  }) {
    final name = path.split('/').last;
    final id = field == 'path' ? name.split('.').first : 'pack-$name';
    records.putIfAbsent(collection, () => {})[id] = {
      'id': id,
      'collectionId': 'c_$collection',
      'collectionName': collection,
      field: path,
      'file': '${name.replaceAll('.', '_')}_abc123.${name.split('.').last}',
    };
    contents[id] = Uint8List.fromList(bytes);
  }

  /// Sunucuya ulaşan dosya indirmeleri (`/api/files/…`, token hariç).
  List<http.Request> get fileGets => [
    for (final r in requests)
      if (r.method == 'GET' && r.url.path.startsWith('/api/files/')) r,
  ];

  /// Bu sahte sunucuya bağlı istemci; oturum [token] (varsayılan bir saat
  /// geçerli).
  PocketBase client({String? token}) {
    final pb = PocketBase(
      fakePocketBaseUrl,
      httpClientFactory: () => MockClient(_handle),
    );
    pb.authStore.save(
      token ?? fakePocketBaseJwt(DateTime.now().add(const Duration(hours: 1))),
      null,
    );
    return pb;
  }

  Future<http.Response> _handle(http.Request request) async {
    requests.add(request);
    if (await handler?.call(request) case final response?) return response;
    final segments = request.url.pathSegments;
    if (request.method == 'POST' && request.url.path == '/api/files/token') {
      final token = 'file-token-${fileTokens.length + 1}';
      fileTokens.add(token);
      return fakePocketBaseJson({'token': token});
    }
    if (segments case ['api', 'collections', final collection, 'records']) {
      return request.method == 'POST'
          ? _create(collection, request)
          : _list(collection, request);
    }
    if (segments case ['api', 'files', final collection, final id, _]) {
      final record = records[collection.substring(2)]?[id];
      final protected = collection != 'c_knowledge_packs';
      final token = request.url.queryParameters['token'];
      if (record == null ||
          (protected && (fileTokens.isEmpty || token != fileTokens.last))) {
        return http.Response('{"message":"not found"}', 404);
      }
      return http.Response.bytes(contents[id]!, 200);
    }
    return http.Response('{}', 404);
  }

  http.Response _create(String collection, http.Request request) {
    final parts = _multipart(request);
    final body = jsonDecode(
      utf8.decode(parts['@jsonPayload']!.bytes),
    ) as Map<String, dynamic>;
    final file = parts['file']!;
    uploads.add((
      collection: collection,
      body: body,
      fileName: file.fileName!,
      bytes: file.bytes,
      authorization: request.headers['Authorization'],
    ));
    final id = body['id'] as String;
    final existing = records.putIfAbsent(collection, () => {});
    if (existing.containsKey(id)) return fakePocketBaseAlreadyUploaded();
    put(collection, body['path'] as String, file.bytes);
    return fakePocketBaseJson(existing[id]);
  }

  http.Response _list(String collection, http.Request request) {
    final filter = request.url.queryParameters['filter'] ?? '';
    final match = RegExp(r'^(path|name) = "(.*)"$').firstMatch(filter);
    final items = [
      if (match != null)
        for (final record
            in records[collection]?.values ?? const <Map<String, Object?>>[])
          if (record[match[1]!] == match[2]) record,
    ];
    return fakePocketBaseJson({
      'page': 1,
      'perPage': 1,
      'totalItems': -1,
      'totalPages': -1,
      'items': items.take(1).toList(),
    });
  }

  /// Multipart gövdenin parçaları, ada göre.
  static Map<String, ({String? fileName, Uint8List bytes})> _multipart(
    http.Request request,
  ) {
    final boundary = RegExp('boundary=(.+)')
        .firstMatch(request.headers['content-type']!)![1]!;
    final body = latin1.decode(request.bodyBytes);
    final out = <String, ({String? fileName, Uint8List bytes})>{};
    for (final part in body.split('--$boundary')) {
      final split = part.indexOf('\r\n\r\n');
      if (split < 0) continue;
      final headers = part.substring(0, split);
      final name = RegExp('name="([^"]*)"').firstMatch(headers)?[1];
      if (name == null) continue;
      var content = part.substring(split + 4);
      if (content.endsWith('\r\n')) {
        content = content.substring(0, content.length - 2);
      }
      out[name] = (
        fileName: RegExp('filename="([^"]*)"').firstMatch(headers)?[1],
        bytes: Uint8List.fromList(latin1.encode(content)),
      );
    }
    return out;
  }
}

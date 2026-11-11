import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/sync/file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../helpers/fake_pocketbase_files.dart';

const _org = '0190a0b0-0000-7000-8000-000000000001';
const _hive = '0190a0b0-0000-7000-8000-000000000002';
const _media = '0190a0b0-0000-7000-8000-000000000003';
const _path = '$_org/$_hive/$_media.jpg';

Matcher _fails(FileStoreFailure failure, [Object? message]) => throwsA(
  isA<FileStoreException>()
      .having((e) => e.failure, 'failure', failure)
      .having((e) => e.message, 'message', message ?? anything),
);

void main() {
  late FakePocketBaseFiles server;
  late PocketBase client;
  late DateTime now;
  late PocketBaseFileStore store;

  setUp(() {
    server = FakePocketBaseFiles();
    client = server.client();
    now = DateTime.utc(2026, 11, 11, 9);
    store = PocketBaseFileStore(client, clock: () => now);
  });

  Future<FileUploadResult> upload([
    String bucket = 'media',
    String path = _path,
  ]) => store.upload(
    bucket,
    path,
    Uint8List.fromList(utf8.encode('bytes')),
    contentType: 'image/jpeg',
  );

  group('yükleme', () {
    test('kaydı yolun son UUID’si, ilk klasörü ve yolun kendisiyle, '
        'dosyayı multipart olarak oturumla yazar', () async {
      expect(await upload(), FileUploadResult.uploaded);

      final request = server.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/collections/media_files/records');
      final sent = server.uploads.single;
      expect(sent.body, {'id': _media, 'org_id': _org, 'path': _path});
      expect(sent.fileName, '$_media.jpg');
      expect(utf8.decode(sent.bytes), 'bytes');
      expect(sent.authorization, client.authStore.token);
    });

    test('bucket’lar dosya koleksiyonlarına gider (K-13)', () async {
      const paths = {
        'media': ('media_files', '$_org/$_hive/$_media.m4a'),
        'documents': ('document_files', '$_org/$_hive/$_media.pdf'),
        'receipts': ('receipt_files', '$_org/$_hive/$_media.jpg'),
        'feedback': ('feedback_files', '$_org/$_media.jpg'),
        'org-logos': ('org_logo_files', '$_org/$_media.jpg'),
      };
      for (final MapEntry(key: bucket, value: (collection, path))
          in paths.entries) {
        await upload(bucket, path);
        expect(server.uploads.last.collection, collection, reason: bucket);
        expect(server.uploads.last.body['id'], _media, reason: bucket);
      }
    });

    test('aynı id ile ikinci yükleme (400 validation_pk_invalid) zaten '
        'yüklendi sayılır', () async {
      expect(await upload(), FileUploadResult.uploaded);
      expect(await upload(), FileUploadResult.alreadyExists);
      expect(server.uploads, hasLength(2));
    });

    test('boyut, tür, yol, kural reddi ve yetki kalıcı', () async {
      final cases = {
        'size': fakePocketBaseError(
          400,
          data: {'file': 'validation_file_size_limit'},
        ),
        'mime': fakePocketBaseError(
          400,
          data: {'file': 'validation_invalid_mime_type'},
        ),
        'path': fakePocketBaseError(
          400,
          data: {'path': 'validation_path_invalid'},
        ),
        'org': fakePocketBaseError(
          400,
          data: {'org_id': 'validation_path_org_mismatch'},
        ),
        'rule': fakePocketBaseError(400),
        'body': http.Response('request entity too large', 413),
        'forbidden': fakePocketBaseError(403, message: 'Forbidden.'),
        'missing': fakePocketBaseError(404, message: 'Missing collection.'),
      };
      for (final MapEntry(key: name, value: response) in cases.entries) {
        server.handler = (_) => response;
        await expectLater(
          upload(),
          _fails(
            FileStoreFailure.permanent,
            startsWith('${response.statusCode}'),
          ),
          reason: name,
        );
      }
      server.handler = (_) => fakePocketBaseError(
        400,
        data: {'file': 'validation_file_size_limit'},
      );
      await expectLater(
        upload(),
        _fails(
          FileStoreFailure.permanent,
          contains('file=validation_file_size_limit'),
        ),
      );
    });

    test('ağ hatası, oturum, istek sınırı ve sunucu hataları geçici', () async {
      for (final status in [401, 408, 429, 500, 502, 503, 504]) {
        server.handler = (_) => fakePocketBaseError(status, message: 'hata');
        await expectLater(
          upload(),
          _fails(FileStoreFailure.transient, startsWith('$status')),
          reason: '$status',
        );
      }
      server.handler = (_) => throw const SocketException('ağ yok');
      await expectLater(upload(), _fails(FileStoreFailure.transient));
      server.handler = (_) => throw http.ClientException('bağlantı koptu');
      await expectLater(upload(), _fails(FileStoreFailure.transient));
    });

    test('süresi dolmuş ya da olmayan oturumda istek atılmaz, geçici; '
        'yenilenince gider', () async {
      client.authStore.save(
        fakePocketBaseJwt(DateTime.now().subtract(const Duration(minutes: 1))),
        null,
      );
      await expectLater(upload(), _fails(FileStoreFailure.transient));
      client.authStore.clear();
      await expectLater(upload(), _fails(FileStoreFailure.transient));
      expect(server.requests, isEmpty);

      client.authStore.save(
        fakePocketBaseJwt(DateTime.now().add(const Duration(hours: 1))),
        null,
      );
      expect(await upload(), FileUploadResult.uploaded);
    });

    test('bilinmeyen bucket kalıcı', () async {
      await expectLater(
        upload('public-lots', '$_org/$_media.pdf'),
        _fails(FileStoreFailure.permanent),
      );
      expect(server.requests, isEmpty);
    });
  });

  group('indirme', () {
    setUp(() => server.put('media_files', _path, [1, 2, 3]));

    test('kaydı parametreli path filtresiyle bulur, dosya token’ı alır ve '
        'dosyayı token’la indirir', () async {
      expect(await store.download('media', _path), [1, 2, 3]);

      final [list, token, file] = server.requests;
      expect(list.url.path, '/api/collections/media_files/records');
      expect(list.url.queryParameters['filter'], 'path = "$_path"');
      expect(list.url.queryParameters['perPage'], '1');
      expect(list.headers['Authorization'], client.authStore.token);
      expect(token.method, 'POST');
      expect(token.url.path, '/api/files/token');
      expect(file.url.path, startsWith('/api/files/c_media_files/$_media/'));
      expect(file.url.queryParameters['token'], 'file-token-1');
      expect(file.url.queryParameters.containsKey('thumb'), isFalse);
    });

    test('yoldaki tırnak filtreyi bozmaz', () async {
      await expectLater(
        store.download('media', 'a" || path != "'),
        _fails(FileStoreFailure.notFound),
      );
      expect(
        server.requests.single.url.queryParameters['filter'],
        r'path = "a\" || path != \""',
      );
    });

    test('dosya token’ı bir dakika yeniden kullanılır; oturum değişince ya '
        'da süre dolunca yenisi alınır', () async {
      await store.download('media', _path);
      now = now.add(const Duration(seconds: 59));
      await store.download('media', _path);
      expect(server.fileTokens, ['file-token-1']);

      now = now.add(const Duration(seconds: 1));
      await store.download('media', _path);
      expect(server.fileTokens, hasLength(2));

      client.authStore.save(
        fakePocketBaseJwt(
          DateTime.now().add(const Duration(hours: 1)),
          id: 'other',
        ),
        null,
      );
      await store.download('media', _path);
      expect(server.fileTokens, hasLength(3));
      expect(server.fileGets.map((r) => r.url.queryParameters['token']), [
        'file-token-1',
        'file-token-1',
        'file-token-2',
        'file-token-3',
      ]);
    });

    test(
      'önbellekteki token geçersizse yenisiyle bir kez daha denenir',
      () async {
        await store.download('media', _path);
        server.fileTokens.add('rotated');

        expect(await store.download('media', _path), [1, 2, 3]);
        expect(server.fileGets.map((r) => r.url.queryParameters['token']), [
          'file-token-1',
          'file-token-1',
          'file-token-3',
        ]);
      },
    );

    test('kaydı olmayan ya da okunamayan dosya 404: token istenmez', () async {
      await expectLater(
        store.download('media', '$_org/$_hive/other.jpg'),
        _fails(FileStoreFailure.notFound, startsWith('404')),
      );
      expect(server.requests, hasLength(1));
    });

    test('taze token’la gelen 404 notFound; yeniden denenmez', () async {
      server.handler = (request) => request.url.path.startsWith('/api/files/c')
          ? http.Response('{}', 404)
          : null;

      await expectLater(
        store.download('media', _path),
        _fails(FileStoreFailure.notFound, startsWith('404')),
      );
      expect(server.fileGets, hasLength(1));
    });

    test('ağ hatası ve sunucu hatası geçici, yetki kalıcı', () async {
      server.handler = (_) => throw const SocketException('ağ yok');
      await expectLater(
        store.download('media', _path),
        _fails(FileStoreFailure.transient),
      );

      server.handler = (request) => request.url.path.startsWith('/api/files/c')
          ? throw const SocketException('ağ yok')
          : null;
      await expectLater(
        store.download('media', _path),
        _fails(FileStoreFailure.transient),
      );

      server.handler = (request) => request.url.path == '/api/files/token'
          ? fakePocketBaseError(503, message: 'hata')
          : null;
      await expectLater(
        PocketBaseFileStore(client).download('media', _path),
        _fails(FileStoreFailure.transient),
      );

      server.handler = (_) => fakePocketBaseError(403, message: 'Forbidden.');
      await expectLater(
        PocketBaseFileStore(client).download('media', _path),
        _fails(FileStoreFailure.permanent, startsWith('403')),
      );
    });

    test('süresi dolmuş oturumda istek atılmaz, geçici', () async {
      client.authStore.clear();
      await expectLater(
        store.download('media', _path),
        _fails(FileStoreFailure.transient),
      );
      expect(server.requests, isEmpty);
    });
  });

  group('bilgi bankası', () {
    test('knowledge_packs’ten ada göre, dosya token’ı olmadan iner', () async {
      server.put(
        'knowledge_packs',
        'manifest.json',
        utf8.encode('{"version":2}'),
        field: 'name',
      );

      expect(
        utf8.decode(await store.download('knowledge', 'manifest.json')),
        '{"version":2}',
      );
      final [list, file] = server.requests;
      expect(list.url.path, '/api/collections/knowledge_packs/records');
      expect(list.url.queryParameters['filter'], 'name = "manifest.json"');
      expect(file.url.queryParameters.containsKey('token'), isFalse);
      expect(server.fileTokens, isEmpty);
    });

    test('paket yoksa notFound', () async {
      await expectLater(
        store.download('knowledge', 'knowledge-v9.json'),
        _fails(FileStoreFailure.notFound),
      );
    });
  });
}

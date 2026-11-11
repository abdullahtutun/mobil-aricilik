import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/document_sync_service.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/features/documents/data/document_repository.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/fake_pocketbase_files.dart';
import '../../helpers/test_database.dart';

const _url = 'http://supabase.test';
const _objectPath = '/storage/v1/object/documents/';

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

http.Response _storageError(int status, String error) => http.Response(
  jsonEncode({'statusCode': '$status', 'error': error, 'message': error}),
  status == 409 ? 400 : status,
  headers: {'content-type': 'application/json'},
);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late Directory directory;
  late MediaFileStore files;
  late DocumentRepository documents;
  late DocumentSyncService service;
  late List<http.Request> requests;
  late _Handler handler;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('document_sync_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    documents = DocumentRepository(db, clock: clock.call);
    requests = [];
    handler = (_) => http.Response(jsonEncode({'Key': 'ok'}), 200);
    final client = SupabaseClient(
      _url,
      'anon-key',
      accessToken: () async => 'user-token',
      httpClient: MockClient((request) async {
        requests.add(request);
        return await handler(request);
      }),
    );
    addTearDown(client.dispose);
    service = DocumentSyncService(
      db,
      SupabaseFileStore(client),
      files,
      clock: clock.call,
    );
  });

  /// Dosyası belge klasöründe olan bir belge yazar.
  Future<VaultDocument> add(
    String fileId, {
    DocumentFileKind kind = DocumentFileKind.pdf,
    bool withFile = true,
  }) async {
    final file = (fileId: fileId, kind: kind, byteSize: 10);
    if (withFile) {
      await files.write(file.fileName, utf8.encode('bytes:$fileId'));
    }
    clock.advance(const Duration(seconds: 1));
    return await documents.create(
      orgId: 'org-1',
      type: DocumentType.healthReport,
      name: 'Sağlık raporu',
      file: file,
    );
  }

  Future<DocumentUpload> uploadOf(String storagePath) => (db.select(
    db.documentUploads,
  )..where((t) => t.storagePath.equals(storagePath))).getSingle();

  List<String> uploadedPaths() => [
    for (final request in requests)
      if (request.method == 'POST')
        request.url.path.substring(_objectPath.length),
  ];

  group('yükleme', () {
    test(
      'bekleyenleri sırayla doğru yola, türüyle ve oturumla yükler',
      () async {
        final pdf = await add('f1');
        final photo = await add('f2', kind: DocumentFileKind.photo);

        final result = await service.uploadPending();

        expect(result.done, 2);
        expect(result.retryLater, isFalse);
        expect(uploadedPaths(), [pdf.storagePath, photo.storagePath]);
        expect(requests[0].headers['Authorization'], 'Bearer user-token');
        expect(utf8.decode(requests[0].bodyBytes), contains('bytes:f1'));
        expect(
          utf8.decode(requests[0].bodyBytes),
          contains('content-type: application/pdf'),
        );
        expect(
          utf8.decode(requests[1].bodyBytes),
          contains('content-type: image/jpeg'),
        );
        expect(
          (await uploadOf(pdf.storagePath)).uploadStatus,
          MediaUploadStatus.uploaded,
        );
        expect(await documents.pendingUploadCount(), 0);

        // Yüklenen yeniden gönderilmez.
        await service.uploadPending();
        expect(requests, hasLength(2));
      },
    );

    test('Storage’da zaten olan dosya (409) yüklendi sayılır', () async {
      final document = await add('f1');
      handler = (_) => _storageError(409, 'Duplicate');

      await service.uploadPending();

      expect(
        (await uploadOf(document.storagePath)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('geçici hatada ertelenir ve tur durur; zamanı gelince yeniden '
        'denenir', () async {
      final first = await add('f1');
      await add('f2');
      handler = (_) => _storageError(503, 'Unavailable');

      final result = await service.uploadPending();

      expect(result.retryLater, isTrue);
      expect(requests, hasLength(1));
      final postponed = await uploadOf(first.storagePath);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
      expect(
        postponed.nextAttemptAt,
        clock.current.add(const Duration(seconds: 30)),
      );

      handler = (_) => http.Response(jsonEncode({'Key': 'ok'}), 200);
      requests.clear();
      clock.advance(const Duration(seconds: 30));
      await service.uploadPending();
      expect(uploadedPaths(), hasLength(2));
    });

    test('yetki hatası ve kayıp dosya kalıcı; kuyruk durmaz', () async {
      final forbidden = await add('f1');
      final missing = await add('f2', withFile: false);
      final fine = await add('f3');
      handler = (request) => request.url.path.endsWith(forbidden.storagePath)
          ? _storageError(403, 'Unauthorized')
          : http.Response(jsonEncode({'Key': 'ok'}), 200);

      final result = await service.uploadPending();

      expect(result.failed, 2);
      expect(result.done, 1);
      expect(
        (await uploadOf(forbidden.storagePath)).lastError,
        startsWith('403'),
      );
      expect(
        (await uploadOf(missing.storagePath)).lastError,
        startsWith('missing_file'),
      );
      expect(
        (await uploadOf(fine.storagePath)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('silinen belgenin dosyası yüklenmez', () async {
      final document = await add('f1');
      await documents.remove(document.id);

      await service.uploadPending();

      expect(requests, isEmpty);
    });
  });

  group('indirme', () {
    Future<void> pulled(String id, String fileId) => db
        .into(db.documents)
        .insert(
          VaultDocument(
            id: id,
            orgId: 'org-1',
            type: DocumentType.landPermit,
            name: 'Arazi izni',
            fileKind: DocumentFileKind.photo,
            storagePath: 'org-1/$id/$fileId.jpg',
            byteSize: 5,
            createdAt: clock.current,
            updatedAt: clock.current,
          ).toInsertable(),
        );

    test('dosyası bu telefonda olmayan belgeleri yolun son parçası adıyla '
        'indirir; olanı yeniden istemez', () async {
      await add('local');
      await pulled('remote-1', 'r1');
      handler = (_) => http.Response.bytes([1, 2, 3, 4, 5], 200);

      final result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect(requests.single.method, 'GET');
      expect(requests.single.url.path, '${_objectPath}org-1/remote-1/r1.jpg');
      expect((await files.find('r1.jpg'))!.readAsBytesSync(), [1, 2, 3, 4, 5]);

      requests.clear();
      await service.downloadMissing('org-1');
      expect(requests, isEmpty);
    });

    test('henüz yüklenmemiş dosya atlanır, sıradaki indirilir', () async {
      await pulled('remote-1', 'r1');
      await pulled('remote-2', 'r2');
      handler = (request) => request.url.path.endsWith('r1.jpg')
          ? http.Response('{"error":"not_found"}', 400)
          : http.Response.bytes([7], 200);

      final result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect(result.failed, 1);
      expect(await files.find('r1.jpg'), isNull);
      expect(await files.find('r2.jpg'), isNotNull);
      expect(documentFileName('org-1/remote-2/r2.jpg'), 'r2.jpg');
    });

    test('ağ yoksa tur durur', () async {
      await pulled('remote-1', 'r1');
      await pulled('remote-2', 'r2');
      handler = (_) => throw const SocketException('ağ yok');

      final result = await service.downloadMissing('org-1');

      expect(result.retryLater, isTrue);
      expect(requests, hasLength(1));
    });

    test('başka işletmenin ve silinmiş belgenin dosyası istenmez', () async {
      await pulled('remote-1', 'r1');
      await db
          .update(db.documents)
          .write(DocumentsCompanion(deletedAt: Value(clock.current)));

      await service.downloadMissing('org-1');
      await service.downloadMissing('org-2');

      expect(requests, isEmpty);
    });
  });

  group('PocketBase', () {
    late FakePocketBaseFiles server;

    setUp(() {
      server = FakePocketBaseFiles();
      service = DocumentSyncService(
        db,
        PocketBaseFileStore(server.client()),
        files,
        clock: clock.call,
      );
    });

    Future<void> pulledPb(String id, String fileId) => db
        .into(db.documents)
        .insert(
          VaultDocument(
            id: id,
            orgId: 'org-1',
            type: DocumentType.landPermit,
            name: 'Arazi izni',
            fileKind: DocumentFileKind.photo,
            storagePath: 'org-1/$id/$fileId.jpg',
            byteSize: 5,
            createdAt: clock.current,
            updatedAt: clock.current,
          ).toInsertable(),
        );

    test('ilk yükleme document_files’a gider; sunucuda zaten olan (ikinci '
        'yükleme) yüklendi sayılır', () async {
      final first = await add('f1');
      final second = await add('f2');
      server.put('document_files', second.storagePath, [9]);

      final result = await service.uploadPending();

      expect(result.done, 2);
      expect(server.uploads.map((u) => u.body), [
        {'id': 'f1', 'org_id': 'org-1', 'path': first.storagePath},
        {'id': 'f2', 'org_id': 'org-1', 'path': second.storagePath},
      ]);
      expect(server.uploads.first.collection, 'document_files');
      expect(utf8.decode(server.uploads.first.bytes), 'bytes:f1');
      expect(
        (await uploadOf(second.storagePath)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('boyut sınırı (400 ve 413) kalıcı; kuyruk durmaz', () async {
      final big = await add('big');
      final huge = await add('huge');
      final fine = await add('fine');
      server.handler = (request) {
        final body = latin1.decode(request.bodyBytes);
        if (body.contains('bytes:big')) {
          return fakePocketBaseError(
            400,
            data: {'file': 'validation_file_size_limit'},
          );
        }
        if (body.contains('bytes:huge')) {
          return http.Response('too large', 413);
        }
        return null;
      };

      final result = await service.uploadPending();

      expect(result.done, 1);
      expect(result.failed, 2);
      expect(
        (await uploadOf(big.storagePath)).lastError,
        contains('validation_file_size_limit'),
      );
      expect((await uploadOf(huge.storagePath)).lastError, startsWith('413'));
      expect(
        (await uploadOf(fine.storagePath)).uploadStatus,
        MediaUploadStatus.uploaded,
      );
    });

    test('ağ hatası geçici: ertelenir, tur durur', () async {
      final first = await add('f1');
      await add('f2');
      server.handler = (_) => throw const SocketException('ağ yok');

      final result = await service.uploadPending();

      expect(result.retryLater, isTrue);
      expect(server.requests, hasLength(1));
      final postponed = await uploadOf(first.storagePath);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
    });

    test('indirme dosya token’ıyla; yüklenmemiş dosya (404) atlanır', () async {
      await pulledPb('remote-1', 'r1');
      await pulledPb('remote-2', 'r2');
      server.put('document_files', 'org-1/remote-2/r2.jpg', [1, 2, 3]);

      final result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect(result.failed, 1);
      expect(await files.find('r1.jpg'), isNull);
      expect((await files.find('r2.jpg'))!.readAsBytesSync(), [1, 2, 3]);
      expect(server.fileGets.single.url.queryParameters['token'], isNotEmpty);
    });
  });
}

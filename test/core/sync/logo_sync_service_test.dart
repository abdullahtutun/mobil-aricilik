import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/logo_sync_service.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';

import '../../helpers/fake_pocketbase_files.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late MediaFileStore files;
  late FakePocketBaseFiles server;
  late LogoSyncService service;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    final directory = Directory.systemTemp.createTempSync('logo_sync_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    server = FakePocketBaseFiles();
    service = LogoSyncService(
      db,
      PocketBaseFileStore(server.client()),
      files,
      clock: clock.call,
    );
  });

  /// Kuyruğa dosyası telefonda olan bir logo yazar.
  Future<String> queue(String orgId, String id) async {
    final path = '$orgId/$id.jpg';
    await files.write('$id.jpg', utf8.encode('bytes:$id'));
    clock.advance(const Duration(seconds: 1));
    await db
        .into(db.logoUploads)
        .insert(
          LogoUploadsCompanion.insert(
            storagePath: path,
            orgId: orgId,
            uploadStatus: MediaUploadStatus.pending,
            createdAt: clock.current,
          ),
        );
    return path;
  }

  Future<LogoUpload> uploadOf(String path) => (db.select(
    db.logoUploads,
  )..where((t) => t.storagePath.equals(path))).getSingle();

  group('PocketBase', () {
    test('ilk yükleme org_logo_files’a gider; sunucuda zaten olan (ikinci '
        'yükleme) yüklendi sayılır', () async {
      final first = await queue('org-1', 'l1');
      final second = await queue('org-2', 'l2');
      server.put('org_logo_files', second, [9]);

      final result = await service.uploadPending();

      expect(result.done, 2);
      expect(server.uploads.map((u) => u.collection).toSet(), {
        'org_logo_files',
      });
      expect(server.uploads.map((u) => u.body), [
        {'id': 'l1', 'org_id': 'org-1', 'path': first},
        {'id': 'l2', 'org_id': 'org-2', 'path': second},
      ]);
      expect(utf8.decode(server.uploads.first.bytes), 'bytes:l1');
      expect((await uploadOf(second)).uploadStatus, MediaUploadStatus.uploaded);
    });

    test('boyut sınırı (400 ve 413) ve yetki (worker) kalıcı', () async {
      final big = await queue('org-1', 'big');
      final huge = await queue('org-2', 'huge');
      final forbidden = await queue('org-3', 'worker');
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
        // Kural reddi: data boş 400.
        return fakePocketBaseError(400);
      };

      final result = await service.uploadPending();

      expect(result.failed, 3);
      for (final path in [big, huge, forbidden]) {
        expect((await uploadOf(path)).uploadStatus, MediaUploadStatus.failed);
      }
      expect((await uploadOf(huge)).lastError, startsWith('413'));
      expect((await uploadOf(forbidden)).lastError, startsWith('400'));
    });

    test('ağ hatası geçici: ertelenir', () async {
      final path = await queue('org-1', 'l1');
      server.handler = (_) => throw const SocketException('ağ yok');

      final result = await service.uploadPending();

      expect(result.retryLater, isTrue);
      expect((await uploadOf(path)).uploadStatus, MediaUploadStatus.pending);
      expect((await uploadOf(path)).attempts, 1);
    });

    test('başka telefonda seçilen logo dosya token’ıyla iner; yüklenmemişse '
        '(404) atlanır', () async {
      await db
          .into(db.organizations)
          .insert(
            OrganizationsCompanion.insert(
              id: 'org-1',
              name: 'Arılık',
              countryCode: 'TR',
              currency: 'TRY',
              logoPath: const Value('org-1/remote.jpg'),
              createdAt: clock.current,
              updatedAt: clock.current,
            ),
          );

      var result = await service.downloadMissing('org-1');
      expect(result.failed, 1);
      expect(await files.find('remote.jpg'), isNull);

      server.put('org_logo_files', 'org-1/remote.jpg', [1, 2, 3]);
      result = await service.downloadMissing('org-1');

      expect(result.done, 1);
      expect((await files.find('remote.jpg'))!.readAsBytesSync(), [1, 2, 3]);
      expect(server.fileGets.single.url.queryParameters['token'], isNotEmpty);
    });
  });
}

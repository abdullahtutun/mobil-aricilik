import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';

import '../../helpers/fake_connectivity_service.dart';
import '../../helpers/fake_pocketbase_files.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late TestClock clock;
  late Directory directory;
  late MediaFileStore files;
  late FakeConnectivityService network;
  late MediaRepository media;
  late MediaSyncService service;
  late FakePocketBaseFiles server;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('media_sync_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    network = FakeConnectivityService();
    media = MediaRepository(db, clock: clock.call);
    server = FakePocketBaseFiles();
    service = MediaSyncService(
      db,
      PocketBaseFileStore(server.client()),
      files,
      network,
      clock: clock.call,
    );
  });

  /// Dosyası medya klasöründe olan bir çekim yazar.
  Future<MediaItem> capture(
    String fileName, {
    MediaKind kind = MediaKind.photo,
    bool withFile = true,
  }) async {
    if (withFile) await files.write(fileName, utf8.encode('bytes:$fileName'));
    clock.advance(const Duration(seconds: 1));
    return await media.add(
      orgId: 'org-1',
      hiveId: 'hive-1',
      capture: MediaCapture(
        fileName: fileName,
        kind: kind,
        capturedAt: clock.current,
        byteSize: 10,
      ),
    );
  }

  Future<MediaUpload> uploadOf(MediaItem item) => (db.select(
    db.mediaUploads,
  )..where((t) => t.mediaId.equals(item.id))).getSingle();

  List<String> uploadedPaths() => [
    for (final upload in server.uploads) upload.body['path'] as String,
  ];

  group('yükleme', () {
    test(
      'bekleyenleri sırayla doğru yola, adıyla ve oturumla yükler',
      () async {
        final photo = await capture('p.jpg');
        final voice = await capture('v.m4a', kind: MediaKind.audio);

        final result = await service.uploadPending();

        expect(result.outcome, MediaUploadOutcome.done);
        expect(result.uploaded, 2);
        expect(uploadedPaths(), [photo.storagePath, voice.storagePath]);
        expect(server.uploads.first.authorization, isNotEmpty);
        expect(utf8.decode(server.uploads.first.bytes), 'bytes:p.jpg');
        // Dosyanın adı yolun son parçası (kimlik + uzantı).
        expect(server.uploads.map((upload) => upload.fileName), [
          photo.storagePath.split('/').last,
          voice.storagePath.split('/').last,
        ]);
        expect(
          (await uploadOf(photo)).uploadStatus,
          MediaUploadStatus.uploaded,
        );
        expect(await media.watchPendingUploadCount().first, 0);

        // Yüklenen yeniden gönderilmez.
        await service.uploadPending();
        expect(server.requests, hasLength(2));
      },
    );

    test('sunucuda zaten olan dosya yüklendi sayılır', () async {
      final photo = await capture('p.jpg');
      server.handler = (_) => fakePocketBaseAlreadyUploaded();

      await service.uploadPending();

      expect((await uploadOf(photo)).uploadStatus, MediaUploadStatus.uploaded);
    });

    test('geçici hatada dosya ertelenir ve tur durur; zamanı gelince yeniden '
        'denenir', () async {
      final first = await capture('1.jpg');
      await capture('2.jpg');
      server.handler = (_) => fakePocketBaseError(503, message: 'Unavailable');

      final result = await service.uploadPending();

      expect(result.outcome, MediaUploadOutcome.retryLater);
      expect(server.requests, hasLength(1));
      final postponed = await uploadOf(first);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
      expect(
        postponed.nextAttemptAt,
        clock.current.add(const Duration(seconds: 30)),
      );

      // Ertelenen beklenirken sıradaki denenir.
      server.handler = null;
      server.uploads.clear();
      await service.uploadPending();
      expect(uploadedPaths(), hasLength(1));
      expect(uploadedPaths().single, isNot(first.storagePath));

      clock.advance(const Duration(seconds: 30));
      await service.uploadPending();
      expect(uploadedPaths().last, first.storagePath);
      expect((await uploadOf(first)).uploadStatus, MediaUploadStatus.uploaded);
    });

    test('bağlantı hatası geçici sayılır', () async {
      final photo = await capture('p.jpg');
      server.handler = (_) => throw const SocketException('ağ yok');

      expect(
        (await service.uploadPending()).outcome,
        MediaUploadOutcome.retryLater,
      );
      expect((await uploadOf(photo)).attempts, 1);
    });

    test('yetki hatası ve kayıp dosya kalıcı; kuyruk durmaz', () async {
      final forbidden = await capture('1.jpg');
      final missing = await capture('2.jpg', withFile: false);
      final fine = await capture('3.jpg');
      server.handler = (request) =>
          latin1.decode(request.bodyBytes).contains('bytes:1.jpg')
          ? fakePocketBaseError(403, message: 'Unauthorized')
          : null;

      final result = await service.uploadPending();

      expect(result.outcome, MediaUploadOutcome.done);
      expect(result.failed, 2);
      expect(result.uploaded, 1);
      expect(
        (await uploadOf(forbidden)).uploadStatus,
        MediaUploadStatus.failed,
      );
      expect((await uploadOf(forbidden)).lastError, startsWith('403'));
      expect((await uploadOf(missing)).uploadStatus, MediaUploadStatus.failed);
      expect((await uploadOf(missing)).lastError, startsWith('missing_file'));
      expect((await uploadOf(fine)).uploadStatus, MediaUploadStatus.uploaded);
      // Kalıcı hata bekleyen sayılmaz.
      expect(await media.watchPendingUploadCount().first, 0);
    });

    test('sadece Wi‑Fi açıkken mobil veride hiçbir şey göndermez', () async {
      await capture('p.jpg');
      await LocalSettingsRepository(db).setMediaWifiOnly(enabled: true);
      network.unmetered = false;

      expect(
        (await service.uploadPending()).outcome,
        MediaUploadOutcome.waitingForWifi,
      );
      expect(server.requests, isEmpty);

      network.connectUnmetered();
      expect((await service.uploadPending()).uploaded, 1);
    });

    test('silinen medyanın dosyası yüklenmez', () async {
      final photo = await capture('p.jpg');
      // Silme kuyruğu da temizler; satır elle geri konup denenir.
      await db
          .into(db.mediaUploads)
          .insert(
            MediaUploadsCompanion.insert(
              mediaId: 'deleted',
              orgId: 'org-1',
              fileName: 'p.jpg',
              uploadStatus: MediaUploadStatus.pending,
              createdAt: clock.current,
            ),
          );
      await media.remove(photo.id);

      await service.uploadPending();
      expect(server.requests, isEmpty);
    });

    test('tur sürerken gelen çağrı aynı turu bekler', () async {
      await capture('p.jpg');
      final gate = Completer<void>();
      server.handler = (_) async {
        await gate.future;
        return null;
      };

      final first = service.uploadPending();
      final second = service.uploadPending();
      gate.complete();

      expect(await second, same(await first));
      expect(server.requests, hasLength(1));
    });
  });

  group('indirme', () {
    MediaItem remote() => MediaItem(
      id: 'remote-1',
      orgId: 'org-1',
      hiveId: 'hive-1',
      kind: MediaKind.photo,
      storagePath: 'org-1/hive-1/remote-1.jpg',
      capturedAt: clock.current,
      byteSize: 5,
      createdAt: clock.current,
      updatedAt: clock.current,
    );

    test('dosyayı kimliğinin adıyla medya klasörüne yazar', () async {
      server.put('media_files', 'org-1/hive-1/remote-1.jpg', [1, 2, 3, 4, 5]);

      final file = await service.download(remote());

      expect(server.fileGets.single.url.path, startsWith('/api/files/'));
      expect(file.readAsBytesSync(), [1, 2, 3, 4, 5]);
      expect((await files.find('remote-1.jpg'))!.path, file.path);
    });

    test('henüz yüklenmemiş, ağ yok ve yetki yok ayrı nedenler', () async {
      Future<MediaDownloadFailure?> failure() async {
        try {
          await service.download(remote());
          return null;
        } on MediaDownloadException catch (error) {
          return error.failure;
        }
      }

      expect(await failure(), MediaDownloadFailure.notUploaded);
      server.handler = (_) => throw const SocketException('ağ yok');
      expect(await failure(), MediaDownloadFailure.offline);
      server.handler = (_) => fakePocketBaseError(403, message: 'Forbidden');
      expect(await failure(), MediaDownloadFailure.failed);
      expect(await files.find('remote-1.jpg'), isNull);
    });
  });

  group('PocketBase', () {
    test('ilk yükleme media_files’a gider; sunucuda zaten olan (ikinci '
        'yükleme) yüklendi sayılır', () async {
      final photo = await capture('p.jpg');
      final voice = await capture('v.m4a', kind: MediaKind.audio);
      // Önceki denemenin yanıtı yolda kalmış: kayıt sunucuda.
      server.put('media_files', voice.storagePath, [9]);

      final result = await service.uploadPending();

      expect(result.outcome, MediaUploadOutcome.done);
      expect(result.uploaded, 2);
      expect(server.uploads.map((u) => (u.collection, u.body['path'])), [
        ('media_files', photo.storagePath),
        ('media_files', voice.storagePath),
      ]);
      expect(server.uploads.first.body, {
        'id': photo.id,
        'org_id': 'org-1',
        'path': photo.storagePath,
      });
      expect(utf8.decode(server.uploads.first.bytes), 'bytes:p.jpg');
      expect((await uploadOf(voice)).uploadStatus, MediaUploadStatus.uploaded);
      expect(await media.watchPendingUploadCount().first, 0);
    });

    test('boyut sınırı (400 ve 413) kalıcı; kuyruk durmaz', () async {
      final big = await capture('big.jpg');
      final huge = await capture('huge.jpg');
      final fine = await capture('fine.jpg');
      server.handler = (request) {
        final body = latin1.decode(request.bodyBytes);
        if (body.contains('bytes:big.jpg')) {
          return fakePocketBaseError(
            400,
            data: {'file': 'validation_file_size_limit'},
          );
        }
        if (body.contains('bytes:huge.jpg')) {
          return http.Response('too large', 413);
        }
        return null;
      };

      final result = await service.uploadPending();

      expect(result.uploaded, 1);
      expect((await uploadOf(big)).uploadStatus, MediaUploadStatus.failed);
      expect(
        (await uploadOf(big)).lastError,
        contains('validation_file_size_limit'),
      );
      expect((await uploadOf(huge)).uploadStatus, MediaUploadStatus.failed);
      expect((await uploadOf(huge)).lastError, startsWith('413'));
      expect((await uploadOf(fine)).uploadStatus, MediaUploadStatus.uploaded);
    });

    test('ağ hatası geçici: ertelenir, tur durur', () async {
      final photo = await capture('p.jpg');
      await capture('q.jpg');
      server.handler = (_) => throw const SocketException('ağ yok');

      final result = await service.uploadPending();

      expect(result.outcome, MediaUploadOutcome.retryLater);
      expect(server.requests, hasLength(1));
      final postponed = await uploadOf(photo);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
    });

    test(
      'indirme dosya token’ıyla; yüklenmemiş dosya 404 → notUploaded',
      () async {
        final remote = MediaItem(
          id: 'remote-1',
          orgId: 'org-1',
          hiveId: 'hive-1',
          kind: MediaKind.photo,
          storagePath: 'org-1/hive-1/remote-1.jpg',
          capturedAt: clock.current,
          byteSize: 5,
          createdAt: clock.current,
          updatedAt: clock.current,
        );
        await expectLater(
          service.download(remote),
          throwsA(
            isA<MediaDownloadException>().having(
              (e) => e.failure,
              'failure',
              MediaDownloadFailure.notUploaded,
            ),
          ),
        );

        server.put('media_files', remote.storagePath, [1, 2, 3]);
        final file = await service.download(remote);

        expect(file.readAsBytesSync(), [1, 2, 3]);
        expect(server.fileGets.single.url.queryParameters['token'], isNotEmpty);
      },
    );
  });
}

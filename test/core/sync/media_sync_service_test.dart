import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/supabase_file_store.dart';
import 'package:mobil_arici/features/media/data/media_repository.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/fake_connectivity_service.dart';
import '../../helpers/fake_pocketbase_files.dart';
import '../../helpers/test_database.dart';

const _url = 'http://supabase.test';
const _objectPath = '/storage/v1/object/media/';

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
  late FakeConnectivityService network;
  late MediaRepository media;
  late MediaSyncService service;
  late List<http.Request> requests;
  late _Handler handler;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('media_sync_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    network = FakeConnectivityService();
    media = MediaRepository(db, clock: clock.call);
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
    service = MediaSyncService(
      db,
      SupabaseFileStore(client),
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
    for (final request in requests)
      if (request.method == 'POST')
        request.url.path.substring(_objectPath.length),
  ];

  group('yükleme', () {
    test(
      'bekleyenleri sırayla doğru yola, türüyle ve oturumla yükler',
      () async {
        final photo = await capture('p.jpg');
        final voice = await capture('v.m4a', kind: MediaKind.audio);

        final result = await service.uploadPending();

        expect(result.outcome, MediaUploadOutcome.done);
        expect(result.uploaded, 2);
        expect(uploadedPaths(), [photo.storagePath, voice.storagePath]);
        expect(requests[0].headers['Authorization'], 'Bearer user-token');
        // Dosya multipart gövdede, bucket'ın kabul ettiği türle.
        expect(utf8.decode(requests[0].bodyBytes), contains('bytes:p.jpg'));
        expect(
          utf8.decode(requests[0].bodyBytes),
          contains('content-type: image/jpeg'),
        );
        expect(
          utf8.decode(requests[1].bodyBytes),
          contains('content-type: audio/mp4'),
        );
        expect(
          (await uploadOf(photo)).uploadStatus,
          MediaUploadStatus.uploaded,
        );
        expect(await media.watchPendingUploadCount().first, 0);

        // Yüklenen yeniden gönderilmez.
        await service.uploadPending();
        expect(requests, hasLength(2));
      },
    );

    test('Storage’da zaten olan dosya (409) yüklendi sayılır', () async {
      final photo = await capture('p.jpg');
      handler = (_) => _storageError(409, 'Duplicate');

      await service.uploadPending();

      expect((await uploadOf(photo)).uploadStatus, MediaUploadStatus.uploaded);
    });

    test('geçici hatada dosya ertelenir ve tur durur; zamanı gelince yeniden '
        'denenir', () async {
      final first = await capture('1.jpg');
      await capture('2.jpg');
      handler = (_) => _storageError(503, 'Unavailable');

      final result = await service.uploadPending();

      expect(result.outcome, MediaUploadOutcome.retryLater);
      expect(requests, hasLength(1));
      final postponed = await uploadOf(first);
      expect(postponed.uploadStatus, MediaUploadStatus.pending);
      expect(postponed.attempts, 1);
      expect(
        postponed.nextAttemptAt,
        clock.current.add(const Duration(seconds: 30)),
      );

      // Ertelenen beklenirken sıradaki denenir.
      handler = (_) => http.Response(jsonEncode({'Key': 'ok'}), 200);
      requests.clear();
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
      handler = (_) => throw const SocketException('ağ yok');

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
      handler = (request) => request.url.path.endsWith(forbidden.storagePath)
          ? _storageError(403, 'Unauthorized')
          : http.Response(jsonEncode({'Key': 'ok'}), 200);

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
      expect(requests, isEmpty);

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
      expect(requests, isEmpty);
    });

    test('tur sürerken gelen çağrı aynı turu bekler', () async {
      await capture('p.jpg');
      final gate = Completer<void>();
      handler = (_) async {
        await gate.future;
        return http.Response(jsonEncode({'Key': 'ok'}), 200);
      };

      final first = service.uploadPending();
      final second = service.uploadPending();
      gate.complete();

      expect(await second, same(await first));
      expect(requests, hasLength(1));
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
      handler = (_) => http.Response.bytes([1, 2, 3, 4, 5], 200);

      final file = await service.download(remote());

      expect(requests.single.method, 'GET');
      expect(
        requests.single.url.path,
        '${_objectPath}org-1/hive-1/remote-1.jpg',
      );
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

      handler = (_) => http.Response('{"error":"not_found"}', 400);
      expect(await failure(), MediaDownloadFailure.notUploaded);
      handler = (_) => throw const SocketException('ağ yok');
      expect(await failure(), MediaDownloadFailure.offline);
      handler = (_) => http.Response('forbidden', 403);
      expect(await failure(), MediaDownloadFailure.failed);
      expect(await files.find('remote-1.jpg'), isNull);
    });
  });

  group('PocketBase', () {
    late FakePocketBaseFiles server;

    setUp(() {
      server = FakePocketBaseFiles();
      service = MediaSyncService(
        db,
        PocketBaseFileStore(server.client()),
        files,
        network,
        clock: clock.call,
      );
    });

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

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_service.dart';
import 'package:mobil_arici/features/feedback/data/feedback_repository.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/fake_app_info_service.dart';
import '../../helpers/test_database.dart';

const _url = 'http://supabase.test';
const _storagePath = '/storage/v1/object/feedback/';

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

http.Response _postgrestError(int status, String code) => http.Response(
  jsonEncode({'code': code, 'message': code, 'details': null, 'hint': null}),
  status,
  headers: {'content-type': 'application/json'},
);

http.Response _storageError(int status, String error) => http.Response(
  jsonEncode({'statusCode': '$status', 'error': error, 'message': error}),
  status == 409 ? 400 : status,
  headers: {'content-type': 'application/json'},
);

/// Storage yüklemesi yolu, PostgREST eklemesi boş gövde döner.
http.Response _ok(http.Request request) =>
    request.url.path.startsWith(_storagePath)
    ? http.Response(jsonEncode({'Key': request.url.path}), 200)
    : http.Response('', 201);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late Directory directory;
  late MediaFileStore files;
  late FeedbackRepository feedback;
  late AnalyticsRepository analytics;
  late TelemetryUploadService service;
  late List<http.Request> requests;
  late _Handler handler;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('telemetry_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    feedback = FeedbackRepository(db, clock: clock.call);
    analytics = AnalyticsRepository(db, clock: clock.call);
    requests = [];
    handler = _ok;
    final client = SupabaseClient(
      _url,
      'anon-key',
      accessToken: () async => 'user-token',
      httpClient: MockClient((request) async {
        requests.add(request);
        final response = await handler(request);
        // postgrest yanıtın isteğine bakar.
        return http.Response.bytes(
          response.bodyBytes,
          response.statusCode,
          headers: response.headers,
          request: request,
        );
      }),
    );
    addTearDown(client.dispose);
    service = TelemetryUploadService(
      db,
      client,
      files,
      FakeAppInfoService(),
      clock: clock.call,
    );
  });

  Future<String> queueFeedback({String? screenshot}) async {
    if (screenshot != null) await files.write(screenshot, [1, 2, 3]);
    return await feedback.queue(
      orgId: 'org-1',
      kind: FeedbackKind.bug,
      message: 'Liste açılmıyor',
      screenshotFileName: screenshot,
      deviceInfo: {'app_version': '1.0.0+1'},
    );
  }

  Iterable<http.Request> restCalls(String table) =>
      requests.where((r) => r.url.path == '/rest/v1/$table');

  group('görüş', () {
    test(
      'önce ekran görüntüsü, sonra satır gider; kuyruk ve dosya silinir',
      () async {
        final id = await queueFeedback(screenshot: 'feedback-a.jpg');

        final result = await service.uploadPending();

        expect(result.complete, isTrue);
        expect(result.feedbackSent, 1);
        expect(requests.map((r) => r.url.path), [
          '${_storagePath}org-1/$id.jpg',
          '/rest/v1/feedback',
        ]);
        expect(jsonDecode(requests.last.body), {
          'id': id,
          'org_id': 'org-1',
          'kind': 'bug',
          'message': 'Liste açılmıyor',
          'screenshot_path': 'org-1/$id.jpg',
          'device_info': {'app_version': '1.0.0+1'},
          'created_at': clock.current.toIso8601String(),
        });
        expect(await feedback.nextDue(), isNull);
        expect(await files.find('feedback-a.jpg'), isNull);
      },
    );

    test("ekran görüntüsüz görüşte Storage'a gidilmez", () async {
      await queueFeedback();

      await service.uploadPending();

      expect(requests.map((r) => r.url.path), ['/rest/v1/feedback']);
      expect(
        (jsonDecode(requests.single.body) as Map)['screenshot_path'],
        isNull,
      );
    });

    test('ikinci gönderim (409 ve 23505) gönderildi sayılır', () async {
      await queueFeedback(screenshot: 'feedback-a.jpg');
      handler = (request) => request.url.path.startsWith(_storagePath)
          ? _storageError(409, 'Duplicate')
          : _postgrestError(409, '23505');

      final result = await service.uploadPending();

      expect(result.feedbackSent, 1);
      expect(await feedback.nextDue(), isNull);
    });

    test(
      'geçici hatada ertelenir ve tur durur; zamanı gelince gider',
      () async {
        await queueFeedback();
        handler = (_) => throw const SocketException('offline');

        final result = await service.uploadPending();

        expect(result.complete, isFalse);
        expect(await feedback.nextDue(), isNull);
        final [row] = await db.select(db.feedbackQueue).get();
        expect(row.attempts, 1);
        expect(row.failed, isFalse);

        clock.advance(const Duration(minutes: 1));
        handler = (_) => http.Response('', 201);
        expect((await service.uploadPending()).feedbackSent, 1);
      },
    );

    test('sunucu hatası (503) geçici sayılır', () async {
      await queueFeedback();
      handler = (_) => _postgrestError(503, 'PGRST000');

      expect((await service.uploadPending()).complete, isFalse);
      final [row] = await db.select(db.feedbackQueue).get();
      expect(row.failed, isFalse);
    });

    test('yetki hatası kalıcı: görüş failed olur, sıradaki gider', () async {
      await queueFeedback();
      clock.advance(const Duration(seconds: 1));
      final second = await queueFeedback();
      var calls = 0;
      handler = (_) =>
          calls++ == 0 ? _postgrestError(403, '42501') : http.Response('', 201);

      final result = await service.uploadPending();

      expect(result.complete, isTrue);
      expect(result.feedbackSent, 1);
      final rows = await db.select(db.feedbackQueue).get();
      expect(rows.single.failed, isTrue);
      expect(rows.single.lastError, startsWith('42501'));
      expect(rows.single.id, isNot(second));
    });
  });

  group('kullanım olayları', () {
    test('kurulum kimliği, sürüm ve platformla paket olarak gider', () async {
      await analytics.record(AnalyticsEvent.scanFinished, {'result': 'found'});
      clock.advance(const Duration(seconds: 1));
      await analytics.record(AnalyticsEvent.inspectionSaved, {'duration_s': 9});
      final installId = await analytics.installId();

      final result = await service.uploadPending();

      expect(result.eventsSent, 2);
      final rows =
          jsonDecode(restCalls('analytics_events').single.body) as List;
      expect(rows, [
        for (final (name, props) in [
          ('scan_finished', {'result': 'found'}),
          ('inspection_saved', {'duration_s': 9}),
        ])
          allOf(
            containsPair('install_id', installId),
            containsPair('name', name),
            containsPair('props', props),
            containsPair('app_version', '1.0.0+1'),
            containsPair('platform', 'android'),
          ),
      ]);
      expect(await analytics.pending(), isEmpty);
    });

    test('kapalıyken gönderilmez', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      await db
          .into(db.localSettings)
          .insertOnConflictUpdate(
            LocalSettingsCompanion.insert(
              key: 'analytics_enabled',
              value: 'false',
            ),
          );

      await service.uploadPending();

      expect(requests, isEmpty);
    });

    test('paketin bir kısmı gitmişse olaylar tek tek gönderilir', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      clock.advance(const Duration(seconds: 1));
      await analytics.record(AnalyticsEvent.syncPushed);
      handler = (request) => (jsonDecode(request.body) is List)
          ? _postgrestError(409, '23505')
          : (jsonDecode(request.body) as Map)['name'] == 'scan_finished'
          ? _postgrestError(409, '23505')
          : http.Response('', 201);

      final result = await service.uploadPending();

      expect(result.eventsSent, 2);
      expect(restCalls('analytics_events'), hasLength(3));
      expect(await analytics.pending(), isEmpty);
    });

    test('geçici hatada olaylar kuyrukta kalır', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      handler = (_) => throw const SocketException('offline');

      expect((await service.uploadPending()).complete, isFalse);
      expect(await analytics.pending(), hasLength(1));
    });

    test('kalıcı hatada paket silinir, kuyruk tıkanmaz', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      handler = (_) => _postgrestError(400, '23514');

      final result = await service.uploadPending();

      expect(result.complete, isTrue);
      expect(result.eventsSent, 0);
      expect(await analytics.pending(), isEmpty);
    });
  });

  test('görüş geçici hata alınca olaylar da beklemede kalır', () async {
    await queueFeedback();
    await analytics.record(AnalyticsEvent.scanFinished);
    handler = (_) => throw const SocketException('offline');

    await service.uploadPending();

    expect(restCalls('analytics_events'), isEmpty);
    expect(await analytics.pending(), hasLength(1));
  });
}

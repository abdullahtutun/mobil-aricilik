import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/analytics/analytics_repository.dart';
import 'package:mobil_arici/core/analytics/analytics_rules.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_file_store.dart';
import 'package:mobil_arici/core/sync/pocketbase_telemetry_api.dart';
import 'package:mobil_arici/core/sync/telemetry_api.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_service.dart';
import 'package:mobil_arici/features/feedback/data/feedback_repository.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:pocketbase/pocketbase.dart' show RecordModel;

import '../../helpers/fake_app_info_service.dart';
import '../../helpers/fake_pocketbase_files.dart';
import '../../helpers/test_database.dart';

typedef _Failure = FutureOr<http.Response?> Function(http.Request request);

void main() {
  late AppDatabase db;
  late TestClock clock;
  late Directory directory;
  late MediaFileStore files;
  late FeedbackRepository feedback;
  late AnalyticsRepository analytics;
  late TelemetryUploadService service;
  late FakePocketBaseFiles server;
  late _PocketBaseRows rows;

  /// Doluysa her istek önce buna gider; yanıt dönerse sahte sunucu atlanır.
  _Failure? failure;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock();
    directory = Directory.systemTemp.createTempSync('telemetry_test');
    addTearDown(() => directory.deleteSync(recursive: true));
    files = MediaFileStore(Future.value(directory));
    feedback = FeedbackRepository(db, clock: clock.call);
    analytics = AnalyticsRepository(db, clock: clock.call);
    server = FakePocketBaseFiles();
    rows = _PocketBaseRows();
    failure = null;
    server.handler = (request) async =>
        await failure?.call(request) ?? rows.handle(request);
    final client = server.client(
      record: RecordModel({'id': 'user-1', 'collectionName': 'users'}),
    );
    service = TelemetryUploadService(
      db,
      PocketBaseTelemetryApi(client),
      PocketBaseFileStore(client),
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

  /// Sunucuya giden kayıt eklemeleri, koleksiyon adıyla.
  List<String> createdCollections() => [
    for (final request in server.requests)
      if (request.method == 'POST')
        if (request.url.pathSegments case ['api', 'collections', final c, _]) c,
  ];

  Iterable<Map<String, Object?>> created(String collection) => [
    for (final (c, body) in rows.creates)
      if (c == collection) body,
  ];

  group('görüş', () {
    test(
      'önce ekran görüntüsü, sonra satır gider; kuyruk ve dosya silinir',
      () async {
        final id = await queueFeedback(screenshot: 'feedback-a.jpg');

        final result = await service.uploadPending();

        expect(result.complete, isTrue);
        expect(result.feedbackSent, 1);
        expect(createdCollections(), ['feedback_files', 'feedback']);
        expect(server.uploads.single.body['path'], 'org-1/$id.jpg');
        expect(created('feedback').single, {
          'id': id,
          'org_id': 'org-1',
          'kind': 'bug',
          'message': 'Liste açılmıyor',
          'screenshot_path': 'org-1/$id.jpg',
          'device_info': {'app_version': '1.0.0+1'},
          'created_at': isA<String>(),
          'created_by': 'user-1',
        });
        expect(await feedback.nextDue(), isNull);
        expect(await files.find('feedback-a.jpg'), isNull);
      },
    );

    test('ekran görüntüsüz görüşte dosya yüklenmez', () async {
      await queueFeedback();

      await service.uploadPending();

      expect(createdCollections(), ['feedback']);
      expect(created('feedback').single['screenshot_path'], isNull);
    });

    test(
      'ikinci gönderim (dosya ve satır sunucuda) gönderildi sayılır',
      () async {
        final id = await queueFeedback(screenshot: 'feedback-a.jpg');
        server.put('feedback_files', 'org-1/$id.jpg', [9]);
        rows.rows['feedback'] = {
          id: {'id': id},
        };

        final result = await service.uploadPending();

        expect(result.feedbackSent, 1);
        expect(await feedback.nextDue(), isNull);
      },
    );

    test(
      'geçici hatada ertelenir ve tur durur; zamanı gelince gider',
      () async {
        await queueFeedback();
        failure = (_) => throw const SocketException('offline');

        final result = await service.uploadPending();

        expect(result.complete, isFalse);
        expect(await feedback.nextDue(), isNull);
        final [row] = await db.select(db.feedbackQueue).get();
        expect(row.attempts, 1);
        expect(row.failed, isFalse);

        clock.advance(const Duration(minutes: 1));
        failure = null;
        expect((await service.uploadPending()).feedbackSent, 1);
      },
    );

    test('sunucu hatası (503) geçici sayılır', () async {
      await queueFeedback();
      failure = (_) => fakePocketBaseError(503, message: 'Unavailable');

      expect((await service.uploadPending()).complete, isFalse);
      final [row] = await db.select(db.feedbackQueue).get();
      expect(row.failed, isFalse);
    });

    test('yetki hatası kalıcı: görüş failed olur, sıradaki gider', () async {
      await queueFeedback();
      clock.advance(const Duration(seconds: 1));
      final second = await queueFeedback();
      var calls = 0;
      failure = (_) =>
          calls++ == 0 ? fakePocketBaseError(403, message: 'Forbidden') : null;

      final result = await service.uploadPending();

      expect(result.complete, isTrue);
      expect(result.feedbackSent, 1);
      final rows = await db.select(db.feedbackQueue).get();
      expect(rows.single.failed, isTrue);
      expect(rows.single.lastError, startsWith('403'));
      expect(rows.single.id, isNot(second));
    });
  });

  group('kullanım olayları', () {
    test('kurulum kimliği, sürüm ve platformla, sırayla gider', () async {
      await analytics.record(AnalyticsEvent.scanFinished, {'result': 'found'});
      clock.advance(const Duration(seconds: 1));
      await analytics.record(AnalyticsEvent.inspectionSaved, {'duration_s': 9});
      final installId = await analytics.installId();

      final result = await service.uploadPending();

      expect(result.eventsSent, 2);
      expect(created('analytics_events'), [
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

      expect(server.requests, isEmpty);
    });

    test('geçici hatada olaylar kuyrukta kalır', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      failure = (_) => throw const SocketException('offline');

      expect((await service.uploadPending()).complete, isFalse);
      expect(await analytics.pending(), hasLength(1));
    });

    test('kalıcı hatada paket silinir, kuyruk tıkanmaz', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      failure = (_) => fakePocketBaseError(400);

      final result = await service.uploadPending();

      expect(result.complete, isTrue);
      expect(result.eventsSent, 0);
      expect(await analytics.pending(), isEmpty);
    });
  });

  test('görüş geçici hata alınca olaylar da beklemede kalır', () async {
    await queueFeedback();
    await analytics.record(AnalyticsEvent.scanFinished);
    failure = (_) => throw const SocketException('offline');

    await service.uploadPending();

    expect(created('analytics_events'), isEmpty);
    expect(await analytics.pending(), hasLength(1));
  });

  group('PocketBase ekran görüntüsü', () {
    late FakePocketBaseFiles server;
    late _RecordingTelemetryApi api;

    setUp(() {
      server = FakePocketBaseFiles();
      // Görüş satırının PocketBase yolu P7.5'te; burada yalnız dosya.
      api = _RecordingTelemetryApi();
      service = TelemetryUploadService(
        db,
        api,
        PocketBaseFileStore(server.client()),
        files,
        FakeAppInfoService(),
        clock: clock.call,
      );
    });

    test('ilk yükleme feedback_files’a, sonra satır gider; sunucuda zaten '
        'olan (ikinci yükleme) gönderildi sayılır', () async {
      final first = await queueFeedback(screenshot: 'feedback-a.jpg');
      clock.advance(const Duration(seconds: 1));
      final second = await queueFeedback(screenshot: 'feedback-b.jpg');
      server.put('feedback_files', 'org-1/$second.jpg', [9]);

      final result = await service.uploadPending();

      expect(result.feedbackSent, 2);
      expect(server.uploads.map((u) => u.collection).toSet(), {
        'feedback_files',
      });
      expect(server.uploads.map((u) => u.body), [
        {'id': first, 'org_id': 'org-1', 'path': 'org-1/$first.jpg'},
        {'id': second, 'org_id': 'org-1', 'path': 'org-1/$second.jpg'},
      ]);
      expect(server.uploads.first.bytes, [1, 2, 3]);
      expect(api.feedback.map((row) => row['screenshot_path']), [
        'org-1/$first.jpg',
        'org-1/$second.jpg',
      ]);
      expect(await feedback.nextDue(), isNull);
    });

    test(
      'boyut sınırı (400 ve 413) kalıcı: görüş failed, satır gitmez',
      () async {
        await queueFeedback(screenshot: 'feedback-a.jpg');
        server.handler = (_) => fakePocketBaseError(
          400,
          data: {'file': 'validation_file_size_limit'},
        );

        await service.uploadPending();

        var [row] = await db.select(db.feedbackQueue).get();
        expect(row.failed, isTrue);
        expect(row.lastError, contains('validation_file_size_limit'));

        await db.delete(db.feedbackQueue).go();
        await queueFeedback(screenshot: 'feedback-b.jpg');
        server.handler = (_) => http.Response('too large', 413);

        await service.uploadPending();

        [row] = await db.select(db.feedbackQueue).get();
        expect(row.failed, isTrue);
        expect(row.lastError, startsWith('413'));
        expect(api.feedback, isEmpty);
      },
    );

    test('ağ hatası geçici: ertelenir, satır gitmez', () async {
      await queueFeedback(screenshot: 'feedback-a.jpg');
      server.handler = (_) => throw const SocketException('ağ yok');

      final result = await service.uploadPending();

      expect(result.complete, isFalse);
      final [row] = await db.select(db.feedbackQueue).get();
      expect(row.failed, isFalse);
      expect(row.attempts, 1);
      expect(api.feedback, isEmpty);
    });
  });

  group('PocketBase görüş ve olay satırları', () {
    test('ekran görüntüsü, sonra feedback kaydı (created_by, K-5 zamanı); '
        'sunucuda zaten olan görüş gönderildi sayılır', () async {
      final id = await queueFeedback(screenshot: 'feedback-a.jpg');

      final result = await service.uploadPending();

      expect(result.feedbackSent, 1);
      expect(server.uploads.single.collection, 'feedback_files');
      final (collection, body) = rows.creates.single;
      expect(collection, 'feedback');
      expect(body, {
        'id': id,
        'org_id': 'org-1',
        'kind': 'bug',
        'message': 'Liste açılmıyor',
        'screenshot_path': 'org-1/$id.jpg',
        'device_info': {'app_version': '1.0.0+1'},
        'created_at': matches(
          RegExp(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d\.\d{6}Z$'),
        ),
        'created_by': 'user-1',
      });
      expect(
        DateTime.parse(body['created_at']! as String),
        clock.current.toUtc(),
      );

      // Önceki denemenin yanıtı yolda kalmış: kayıt sunucuda var.
      final again = await queueFeedback();
      rows.rows['feedback']![again] = {'id': again};

      expect((await service.uploadPending()).feedbackSent, 1);
      expect(await feedback.nextDue(), isNull);
    });

    test('kural reddi kalıcı: görüş failed', () async {
      await queueFeedback();
      rows.reply = (_) => fakePocketBaseError(400);

      await service.uploadPending();

      final [row] = await db.select(db.feedbackQueue).get();
      expect(row.failed, isTrue);
      expect(row.lastError, startsWith('400'));
    });

    test('olaylar tek tek gider; sunucuda olan atlanır, hepsi '
        'kuyruktan düşer', () async {
      await analytics.record(AnalyticsEvent.scanFinished);
      clock.advance(const Duration(seconds: 1));
      await analytics.record(AnalyticsEvent.syncPushed);
      final [first, _] = await analytics.pending();
      rows.rows['analytics_events'] = {
        first.id: {'id': first.id},
      };

      final result = await service.uploadPending();

      expect(result.eventsSent, 2);
      expect(await analytics.pending(), isEmpty);
      expect(rows.rows['analytics_events']!.keys, hasLength(2));
      final created = rows.creates.last.$2;
      expect(created['name'], 'sync_pushed');
      expect(created.containsKey('created_by'), isFalse);
      expect(
        created['occurred_at'],
        matches(RegExp(r'^\d{4}-\d\d-\d\dT\d\d:\d\d:\d\d\.\d{6}Z$')),
      );
    });
  });
}

/// `feedback` ve `analytics_events` kayıtlarını (JSON create) tutan sahte
/// PocketBase; aynı id ikinci kez gelirse "zaten var" (400
/// `validation_pk_invalid`). Dosya yüklemeleri [FakePocketBaseFiles]'a
/// kalır.
class _PocketBaseRows {
  final rows = <String, Map<String, Map<String, Object?>>>{};
  final creates = <(String, Map<String, Object?>)>[];

  /// Doluysa bu koleksiyonun eklemesi bu yanıtı alır.
  http.Response Function(Map<String, Object?> body)? reply;

  http.Response? handle(http.Request request) {
    final collection = switch (request.url.pathSegments) {
      ['api', 'collections', final c, 'records']
          when c == 'feedback' || c == 'analytics_events' =>
        c,
      _ => null,
    };
    if (request.method != 'POST' || collection == null) return null;
    final body = jsonDecode(request.body) as Map<String, Object?>;
    creates.add((collection, body));
    if (reply?.call(body) case final response?) return response;
    final table = rows.putIfAbsent(collection, () => {});
    if (table.containsKey(body['id'])) return fakePocketBaseAlreadyUploaded();
    table[body['id']! as String] = body;
    return fakePocketBaseJson(body);
  }
}

/// Satırları kaydeden [TelemetryApi]; hepsini kabul eder.
class _RecordingTelemetryApi implements TelemetryApi {
  final feedback = <Map<String, Object?>>[];

  @override
  Future<void> insertFeedback(Map<String, Object?> row) async =>
      feedback.add(row);

  @override
  Future<void> insertAnalytics(List<Map<String, Object?>> rows) async {}

  @override
  Future<void> insertAnalyticsEvent(Map<String, Object?> row) async {}
}

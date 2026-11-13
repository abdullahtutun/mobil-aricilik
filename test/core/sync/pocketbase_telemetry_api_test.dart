import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/sync/pocketbase_telemetry_api.dart';
import 'package:mobil_arici/core/sync/telemetry_api.dart';

import '../../helpers/fake_pocketbase_api.dart';
import '../../helpers/fake_pocketbase_files.dart';

const _orgId = '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a';
const _feedbackId = '0199a3b2-7c1e-7d40-8a5b-0000000000f1';

Map<String, Object?> _feedbackRow({
  String createdAt = '2026-11-12T08:15:30.123Z',
}) => {
  'id': _feedbackId,
  'org_id': _orgId,
  'kind': 'bug',
  'message': 'Liste açılmıyor',
  'screenshot_path': null,
  'device_info': {'app_version': '1.0.0+1'},
  'created_at': createdAt,
};

Map<String, Object?> _event(String id) => {
  'id': id,
  'install_id': '0199a3b2-7c1e-7d40-8a5b-0000000000c1',
  'name': 'screen_view',
  'props': {'screen': 'today'},
  'occurred_at': '2026-11-12T08:15:30.123456Z',
  'app_version': '1.0.0+1',
  'platform': 'android',
};

void main() {
  late FakePocketBaseApi server;

  setUp(() {
    server = FakePocketBaseApi()
      ..handler = (request) =>
          fakePocketBaseJson(FakePocketBaseApi.body(request));
  });

  PocketBaseTelemetryApi api({String? token, bool signedIn = true}) =>
      PocketBaseTelemetryApi(
        server.client(token: token, signedIn: signedIn),
        timeout: const Duration(milliseconds: 200),
      );

  group('insertFeedback', () {
    test('feedback kaydı: created_by oturumdaki kullanıcı, created_at K-5 '
        'biçiminde', () async {
      await api().insertFeedback(_feedbackRow());

      final request = server.requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/api/collections/feedback/records');
      expect(request.headers['Authorization'], isNotEmpty);
      expect(FakePocketBaseApi.body(request), {
        ..._feedbackRow(),
        'created_at': '2026-11-12T08:15:30.123000Z',
        'created_by': fakePocketBaseUserId,
      });
    });

    test('zaman her zaman 6 haneli kesir ve UTC', () async {
      final times = {
        '2026-11-12T08:15:30Z': '2026-11-12T08:15:30.000000Z',
        '2026-11-12T08:15:30.000001Z': '2026-11-12T08:15:30.000001Z',
        '2026-11-12T11:15:30.5+03:00': '2026-11-12T08:15:30.500000Z',
      };
      for (final MapEntry(key: sent, value: stored) in times.entries) {
        server.requests.clear();
        await api().insertFeedback(_feedbackRow(createdAt: sent));
        expect(
          FakePocketBaseApi.body(server.requests.single)['created_at'],
          stored,
        );
      }
    });

    test('aynı id ikinci kez: TelemetryDuplicateException', () async {
      server.handler = (_) => fakePocketBaseAlreadyUploaded();

      await expectLater(
        api().insertFeedback(_feedbackRow()),
        throwsA(isA<TelemetryDuplicateException>()),
      );
    });

    test('kural reddi ve alan hatası kalıcı, nedeni iletide', () async {
      server.handler = (_) => fakePocketBaseError(400);
      await expectLater(
        api().insertFeedback(_feedbackRow()),
        throwsA(isA<TelemetryRejectedException>()),
      );

      server.handler = (_) =>
          fakePocketBaseError(400, data: {'message': 'validation_max_text'});
      await expectLater(
        api().insertFeedback(_feedbackRow()),
        throwsA(
          isA<TelemetryRejectedException>().having(
            (e) => e.message,
            'message',
            contains('message=validation_max_text'),
          ),
        ),
      );

      server.handler = (_) => fakePocketBaseError(403);
      await expectLater(
        api().insertFeedback(_feedbackRow()),
        throwsA(isA<TelemetryRejectedException>()),
      );
    });

    test('bağlantı hatası, zaman aşımı, 401, 429 ve 5xx geçici', () async {
      final responses = <FutureOr<http.Response> Function()>[
        () => throw const SocketException('çevrimdışı'),
        () => Completer<http.Response>().future,
        () => fakePocketBaseError(401),
        () => fakePocketBaseError(429),
        () => fakePocketBaseError(500),
        () => fakePocketBaseError(503),
      ];
      for (final response in responses) {
        server.handler = (_) => response();
        await expectLater(
          api().insertFeedback(_feedbackRow()),
          throwsA(
            allOf(
              isA<Exception>(),
              isNot(isA<TelemetryRejectedException>()),
              isNot(isA<TelemetryDuplicateException>()),
            ),
          ),
        );
      }
    });

    test(
      'oturum yoksa ya da süresi dolmuşsa istek atılmaz, hata geçici',
      () async {
        for (final client in [
          api(signedIn: false),
          api(
            token: fakePocketBaseJwt(
              DateTime.now().subtract(const Duration(minutes: 1)),
            ),
          ),
        ]) {
          await expectLater(
            client.insertFeedback(_feedbackRow()),
            throwsA(isA<TelemetrySessionUnavailableException>()),
          );
          await expectLater(
            client.insertAnalyticsEvent(_event('e1')),
            throwsA(isA<TelemetrySessionUnavailableException>()),
          );
        }
        expect(server.requests, isEmpty);
      },
    );
  });

  group('analytics_events', () {
    test('tek olay: created_by yok, occurred_at K-5', () async {
      await api().insertAnalyticsEvent({
        ..._event('e1'),
        'occurred_at': '2026-11-12T08:15:30.123Z',
      });

      final request = server.requests.single;
      expect(request.url.path, '/api/collections/analytics_events/records');
      expect(FakePocketBaseApi.body(request), {
        ..._event('e1'),
        'occurred_at': '2026-11-12T08:15:30.123000Z',
      });
    });

    test('paket olaylar tek tek, sırayla gider', () async {
      await api().insertAnalytics([_event('e1'), _event('e2'), _event('e3')]);

      expect(server.requests.map((r) => FakePocketBaseApi.body(r)['id']), [
        'e1',
        'e2',
        'e3',
      ]);
    });

    test('paketin ortasında "zaten var": kalan gönderilmez, duplicate '
        'atılır (servis olayları tek tek yeniden dener)', () async {
      server.handler = (request) =>
          FakePocketBaseApi.body(request)['id'] == 'e2'
          ? fakePocketBaseAlreadyUploaded()
          : fakePocketBaseJson(FakePocketBaseApi.body(request));

      await expectLater(
        api().insertAnalytics([_event('e1'), _event('e2'), _event('e3')]),
        throwsA(isA<TelemetryDuplicateException>()),
      );
      expect(server.requests, hasLength(2));
    });
  });
}

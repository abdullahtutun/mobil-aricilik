import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/push_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../helpers/test_database.dart';

const _url = 'http://supabase.test';

typedef _Handler = FutureOr<http.Response> Function(http.Request request);

http.Response _json(Object? body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// PostgREST'in hata gövdesi; [code] SQLSTATE ya da `PGRST...`.
http.Response _postgrestError(String code, int status) => _json({
  'code': code,
  'message': '$code hatası',
  'details': null,
  'hint': null,
}, status);

/// İstekteki outbox kimlikleri, gönderim sırasıyla.
List<int> _ids(http.Request request) => [
  for (final change
      in (jsonDecode(request.body) as Map<String, dynamic>)['changes']
          as List<dynamic>)
    (change as Map<String, dynamic>)['id'] as int,
];

http.Response _results(List<Map<String, Object?>> results) => _json({
  'results': results,
  'server_time': '2026-10-23T09:00:01Z',
  'warning': null,
});

/// Sahte sync_push: [rejected]'daki kimlikleri o nedenle reddeder, gerisini
/// kabul eder.
http.Response _accept(
  http.Request request, {
  Map<int, String> rejected = const {},
}) => _results([
  for (final id in _ids(request))
    if (rejected[id] case final reason?)
      {
        'id': id,
        'status': 'rejected',
        'reason': reason,
        'message': '$reason mesajı',
      }
    else
      {'id': id, 'status': 'ok', 'applied': true},
]);

List<Duration> _seconds(List<int> values) => [
  for (final value in values) Duration(seconds: value),
];

List<int> _range(int first, int last) => [
  for (var id = first; id <= last; id++) id,
];

void main() {
  late AppDatabase db;
  late TestClock clock;
  late List<http.Request> requests;
  late _Handler handler;
  late List<Duration> delays;
  late SupabaseClient client;
  late SyncService service;

  /// Bir sonraki token isteğinde bir kez atılır.
  Exception? nextTokenError;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 10, 23, 9));
    requests = [];
    handler = _accept;
    delays = [];
    nextTokenError = null;
    client = SupabaseClient(
      _url,
      'anon-key',
      accessToken: () async {
        if (nextTokenError case final error?) {
          nextTokenError = null;
          throw error;
        }
        return 'user-token';
      },
      httpClient: MockClient((request) async {
        requests.add(request);
        final response = await handler(request);
        // postgrest yanıtı isteğiyle birlikte okur.
        return http.Response.bytes(
          response.bodyBytes,
          response.statusCode,
          headers: response.headers,
          request: request,
        );
      }),
    );
    addTearDown(client.dispose);
    service = SyncService(
      db,
      client,
      clock: clock.call,
      delay: (duration) async => delays.add(duration),
    );
  });

  /// Outbox'a [count] kovan kaydı ekler; kimlikler sırayla artar.
  Future<void> enqueue(int count) => db.batch(
    (batch) => batch.insertAll(db.outbox, [
      for (var i = 0; i < count; i++)
        OutboxCompanion.insert(
          recordTable: 'hives',
          recordId: 'hive-$i',
          operation: OutboxOperation.upsert,
          payload: {'id': 'hive-$i', 'updated_at': '2026-10-23T09:00:00Z'},
          createdAt: clock.current,
        ),
    ]),
  );

  group('gönderme', () {
    test('outbox boşsa istek atmaz', () async {
      expect(await service.push(), const PushResult(status: PushStatus.done));
      expect(requests, isEmpty);
    });

    test('kayıtları sync_push sözleşmesiyle gönderir', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final apiary = await repository.create(orgId: 'org-1', name: 'Yayla');
      await repository.delete(apiary.id);
      final entries = await readOutbox(db);

      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 2),
      );

      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url.path, '/rest/v1/rpc/sync_push');
      expect(request.headers['Authorization'], 'Bearer user-token');
      expect(jsonDecode(request.body), {
        'changes': [
          {
            'id': entries[0].id,
            'table': 'apiaries',
            'operation': 'upsert',
            'payload': entries[0].payload,
          },
          {
            'id': entries[1].id,
            'table': 'apiaries',
            'operation': 'delete',
            'payload': entries[1].payload,
          },
        ],
        'client_time': '2026-10-23T09:00:00.000Z',
        'schema_version': db.schemaVersion,
      });
      expect(await readOutbox(db), isEmpty);
    });

    test('sırayla 100’lük paketler gönderir, kabul edilenleri siler', () async {
      await enqueue(250);

      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 250),
      );
      expect(requests.map(_ids), [
        _range(1, 100),
        _range(101, 200),
        _range(201, 250),
      ]);
      expect(await readOutbox(db), isEmpty);
      expect(delays, isEmpty);
    });

    test('sunucuda aynı ya da daha yeni hâli olan kayıt da silinir', () async {
      await enqueue(2);
      handler = (request) => _results([
        for (final id in _ids(request))
          {'id': id, 'status': 'ok', 'applied': false},
      ]);

      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 2),
      );
      expect(await readOutbox(db), isEmpty);
    });

    test('tur sürerken eklenen kayıt aynı turda, sırasıyla gider', () async {
      await enqueue(1);
      handler = (request) async {
        if (requests.length == 1) await enqueue(1);
        return _accept(request);
      };

      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 2),
      );
      expect(requests.map(_ids), [
        [1],
        [2],
      ]);
    });
  });

  group('kalıcı ret', () {
    test(
      'reddedilen kaydı işaretler, kuyruğun geri kalanını gönderir',
      () async {
        await enqueue(150);
        handler = (request) =>
            _accept(request, rejected: {2: 'forbidden', 120: 'conflict'});

        expect(
          await service.push(),
          const PushResult(status: PushStatus.done, pushed: 148, rejected: 2),
        );
        expect(requests.map(_ids), [_range(1, 100), _range(101, 150)]);

        final left = await readOutbox(db);
        expect(left.map((entry) => entry.id), [2, 120]);
        expect(left.map((entry) => entry.lastError), [
          'forbidden: forbidden mesajı',
          'conflict: conflict mesajı',
        ]);
        expect(left.map((entry) => entry.attempts), [1, 1]);
        expect(delays, isEmpty);
      },
    );

    test('işaretli kayıt sonraki turlarda gönderilmez', () async {
      await enqueue(2);
      handler = (request) => _accept(request, rejected: {1: 'invalid'});
      await service.push();
      requests.clear();

      expect(await service.push(), const PushResult(status: PushStatus.done));
      expect(requests, isEmpty);

      await enqueue(1);
      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 1),
      );
      expect(requests.map(_ids), [
        [3],
      ]);
      expect((await readOutbox(db)).map((entry) => entry.id), [1]);
    });
  });

  group('geçici hata', () {
    test('aynı paketi üstel bekleyerek yeniden gönderir', () async {
      await enqueue(3);
      handler = (request) {
        if (requests.length <= 3) throw const SocketException('çevrimdışı');
        return _accept(request);
      };

      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 3),
      );
      expect(delays, _seconds([1, 2, 4]));
      expect(requests.map(_ids), List.filled(4, [1, 2, 3]));
      expect(await readOutbox(db), isEmpty);
    });

    test('denemeler tükenince durur; kayıtlar yerinde, deneme sayısı '
        'artar', () async {
      await enqueue(150);
      handler = (_) => throw const SocketException('çevrimdışı');

      expect(
        await service.push(),
        const PushResult(status: PushStatus.retryLater),
      );
      expect(delays, _seconds([1, 2, 4, 8, 16]));
      expect(requests.map(_ids), List.filled(6, _range(1, 100)));

      final left = await readOutbox(db);
      expect(left, hasLength(150));
      expect(left.take(100).map((entry) => entry.attempts), everyElement(6));
      expect(left.skip(100).map((entry) => entry.attempts), everyElement(0));
      expect(left.map((entry) => entry.lastError), everyElement(isNull));
    });

    test('bekleme her başarılı paketten sonra baştan başlar', () async {
      await enqueue(150);
      final failedOnce = <int>{};
      handler = (request) {
        if (failedOnce.add(_ids(request).first)) {
          throw http.ClientException('bağlantı koptu');
        }
        return _accept(request);
      };

      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 150),
      );
      expect(delays, _seconds([1, 1]));
    });

    final transientFailures = <String, _Handler>{
      'bağlantı hatası': (_) => throw http.ClientException('bağlantı koptu'),
      'istek zaman aşımı': (_) => throw TimeoutException('yanıt yok'),
      'kilitlenme (40P01)': (_) => _postgrestError('40P01', 500),
      'serileştirme hatası (40001)': (_) => _postgrestError('40001', 500),
      'sorgu zaman aşımı (57014)': (_) => _postgrestError('57014', 500),
      'kilit beklenemedi (55P03)': (_) => _postgrestError('55P03', 500),
      'veritabanına ulaşılamıyor (PGRST001)': (_) =>
          _postgrestError('PGRST001', 503),
      'JSON dönmeyen ağ geçidi (502)': (_) =>
          http.Response('<html>Bad Gateway</html>', 502),
      'çok sık istek (429)': (_) => _json({'message': 'Too many'}, 429),
    };
    for (final MapEntry(key: name, value: failure)
        in transientFailures.entries) {
      test('geçici sayılır: $name', () async {
        await enqueue(1);
        handler = (request) =>
            requests.length == 1 ? failure(request) : _accept(request);

        expect(
          await service.push(),
          const PushResult(status: PushStatus.done, pushed: 1),
        );
        expect(delays, _seconds([1]));
      });
    }

    test(
      'geçici sayılır: süresi dolmuş token çevrimdışı yenilenemedi',
      () async {
        await enqueue(1);
        nextTokenError = AuthRetryableFetchException(message: 'çevrimdışı');

        expect(
          await service.push(),
          const PushResult(status: PushStatus.done, pushed: 1),
        );
        expect(delays, _seconds([1]));
        expect(requests, hasLength(1));
      },
    );
  });

  group('yeniden denenmeyen hata', () {
    final fatalFailures = <String, _Handler>{
      'oturum yok (42501)': (_) => _postgrestError('42501', 401),
      'süresi dolmuş JWT (PGRST303)': (_) => _postgrestError('PGRST303', 401),
      'bozuk istek (22023)': (_) => _postgrestError('22023', 400),
      'fonksiyon yok (PGRST202)': (_) => _postgrestError('PGRST202', 404),
      'iç hata (XX000)': (_) => _postgrestError('XX000', 500),
    };
    for (final MapEntry(key: name, value: failure) in fatalFailures.entries) {
      test('turu bitirir: $name', () async {
        await enqueue(2);
        handler = failure;

        expect(
          await service.push(),
          const PushResult(status: PushStatus.failed),
        );
        expect(requests, hasLength(1));
        expect(delays, isEmpty);
        final left = await readOutbox(db);
        expect(left.map((entry) => entry.attempts), [1, 1]);
        expect(left.map((entry) => entry.lastError), everyElement(isNull));
      });
    }

    test('turu bitirir: refresh token reddedildi', () async {
      await enqueue(1);
      nextTokenError = const AuthException('Invalid Refresh Token');

      expect(await service.push(), const PushResult(status: PushStatus.failed));
      expect(requests, isEmpty);
      expect(delays, isEmpty);
    });

    test('desteklenmeyen şema sürümünde güncelleme ister', () async {
      await enqueue(1);
      handler = (_) => _postgrestError('PT426', 426);

      expect(
        await service.push(),
        const PushResult(status: PushStatus.upgradeRequired),
      );
      expect(requests, hasLength(1));
      expect(delays, isEmpty);
      expect((await readOutbox(db)).single.lastError, isNull);
    });

    test('yanıtta sonucu olmayan kayıt yerinde kalır ve tur durur', () async {
      await enqueue(150);
      handler = (request) => _results([
        for (final id in _ids(request).take(50))
          {'id': id, 'status': 'ok', 'applied': true},
        {'id': 51, 'status': 'beklenmeyen'},
      ]);

      expect(
        await service.push(),
        const PushResult(status: PushStatus.failed, pushed: 50),
      );
      expect(requests, hasLength(1));
      final left = await readOutbox(db);
      expect(left.map((entry) => entry.id), _range(51, 150));
      expect(left.map((entry) => entry.attempts), everyElement(0));
      expect(left.map((entry) => entry.lastError), everyElement(isNull));
    });
  });

  group('kilit', () {
    test(
      'tur sürerken gelen çağrı yeni tur başlatmaz, sonucunu bekler',
      () async {
        await enqueue(1);
        final entered = Completer<void>();
        final release = Completer<void>();
        handler = (request) async {
          entered.complete();
          await release.future;
          return _accept(request);
        };

        final first = service.push();
        await entered.future;
        final second = service.push();
        expect(second, same(first));

        release.complete();
        const result = PushResult(status: PushStatus.done, pushed: 1);
        expect(await first, result);
        expect(await second, result);
        expect(requests, hasLength(1));
      },
    );

    test(
      'yeniden deneme beklenirken gelen çağrı da aynı turu bekler',
      () async {
        await enqueue(1);
        final waiting = Completer<void>();
        final resume = Completer<void>();
        service = SyncService(
          db,
          client,
          clock: clock.call,
          delay: (_) {
            waiting.complete();
            return resume.future;
          },
        );
        handler = (request) {
          if (requests.length == 1) throw const SocketException('çevrimdışı');
          return _accept(request);
        };

        final first = service.push();
        await waiting.future;
        expect(service.push(), same(first));

        resume.complete();
        expect(
          await first,
          const PushResult(status: PushStatus.done, pushed: 1),
        );
        expect(requests, hasLength(2));
      },
    );

    test('biten tur kilidi bırakır, hatayla bitse de', () async {
      await enqueue(1);
      handler = (_) => _postgrestError('42501', 401);
      expect((await service.push()).status, PushStatus.failed);

      handler = _accept;
      expect(
        await service.push(),
        const PushResult(status: PushStatus.done, pushed: 1),
      );
      expect(requests, hasLength(2));
    });
  });
}

import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../helpers/test_database.dart';

const _url = 'http://pocketbase.test';
const _token = 'user-token';

typedef _Handler = FutureOr<http.Response> Function(http.Request request);
typedef _Rows = List<Map<String, Object?>>;

http.Response _json(Object? body, [int status = 200]) => http.Response(
  jsonEncode(body),
  status,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

/// Sunucunun hata gövdesi (`server/internal/sync`, `apiError`).
http.Response _error(int status, String code) => _json({
  'status': status,
  'message': '$code hatası',
  'data': {'code': code},
}, status);

bool _isPull(http.Request request) =>
    request.url.path == PocketBaseSyncTransport.pullPath;

/// İstekteki outbox kimlikleri, gönderim sırasıyla.
List<int> _ids(http.Request request) => [
  for (final change
      in (jsonDecode(request.body) as Map<String, dynamic>)['changes']
          as List<dynamic>)
    (change as Map<String, dynamic>)['id'] as int,
];

/// Sahte push: [rejected]'daki kimlikleri o nedenle reddeder, gerisini
/// kabul eder.
http.Response _accept(
  http.Request request, {
  Map<int, String> rejected = const {},
}) => _json({
  'results': [
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
  ],
  'server_time': '2026-11-11T09:00:01.000000Z',
  'warning': null,
});

/// Sahte sunucu: push'a her şeyi kabul eder; pull'a [tables]'daki
/// satırlardan imleçten büyük olanları server_seq sırasıyla, en çok
/// [maxPage] satır döner (geriye bakma payı yok, K-7).
_Handler _server(Map<String, _Rows> tables, {int maxPage = 1000}) => (request) {
  if (!_isPull(request)) return _accept(request);
  final query = request.url.queryParameters;
  final since = int.parse(query['since_seq']!);
  final rows = [
    for (final row in tables[query['table']] ?? const <Map<String, Object?>>[])
      if ((row['server_seq']! as int) > since) row,
  ];
  final size = math.min(int.parse(query['page_size']!), maxPage);
  final page = rows.take(size).toList();
  return _json({
    'rows': page,
    'next_seq': page.isEmpty ? since : page.last['server_seq'],
    'has_more': rows.length > page.length,
  });
};

/// Sunucunun pull'da döndüğü arılık satırı: K-5 metin zamanları, boş
/// alanlar null (`RowJSON`).
Map<String, Object?> _apiaryRow(String id, int seq) => {
  'id': id,
  'org_id': 'org-1',
  'created_at': '2026-11-11T07:00:00.000000Z',
  'updated_at': '2026-11-11T08:00:00.123456Z',
  'created_by': 'user-1',
  'deleted_at': null,
  'server_seq': seq,
  'name': 'Yayla $seq',
  'latitude': 38.41,
  'longitude': 27.14,
  'altitude_m': 1200,
  'land_tenure': 'rented',
  'water_source': null,
  'vehicle_distance_m': null,
  'road_notes': null,
  'notes': null,
};

List<Duration> _seconds(List<int> values) => [
  for (final value in values) Duration(seconds: value),
];

List<int> _range(int first, int last) => [
  for (var id = first; id <= last; id++) id,
];

Future<Map<String, int>> _cursors(AppDatabase db) async => {
  for (final cursor in await db.select(db.syncState).get())
    cursor.recordTable: cursor.lastPulledSeq,
};

void main() {
  late AppDatabase db;
  late TestClock clock;
  late List<http.Request> requests;
  late _Handler handler;
  late List<Duration> delays;
  late PocketBase client;
  late SyncService service;

  setUp(() {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 11, 11, 9));
    requests = [];
    handler = _accept;
    delays = [];
    client = PocketBase(
      _url,
      authStore: AuthStore()
        ..save(_token, RecordModel({'id': 'user-1', 'email': 'a@b.co'})),
      httpClientFactory: () => MockClient((request) async {
        requests.add(request);
        return await handler(request);
      }),
    );
    service = SyncService(
      db,
      PocketBaseSyncTransport(
        client,
        timeout: const Duration(milliseconds: 50),
      ),
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
          payload: {'id': 'hive-$i', 'updated_at': '2026-11-11T09:00:00Z'},
          createdAt: clock.current,
        ),
    ]),
  );

  group('gönderme', () {
    test('kayıtları /api/sync/push sözleşmesiyle, oturumun token’ıyla '
        'gönderir', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final apiary = await repository.create(orgId: 'org-1', name: 'Yayla');
      await repository.delete(apiary.id);
      final entries = await readOutbox(db);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 2),
      );

      final request = requests.single;
      expect(request.method, 'POST');
      expect(request.url.toString(), '$_url/api/sync/push');
      expect(request.headers['Authorization'], _token);
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
        'client_time': '2026-11-11T09:00:00.000Z',
        'schema_version': db.schemaVersion,
      });
      expect(await readOutbox(db), isEmpty);
    });

    test('süresi dolmuş token da gönderilir; kararı sunucu verir', () async {
      // SDK `isValid` olmayan token'ı kendiliğinden eklemez.
      client.authStore.save('expired.jwt.token', null);
      await enqueue(1);

      await service.push();

      expect(requests.single.headers['Authorization'], 'expired.jwt.token');
    });

    test('sırayla 100’lük paketler gönderir, kabul edilenleri siler', () async {
      await enqueue(250);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 250),
      );
      expect(requests.map(_ids), [
        _range(1, 100),
        _range(101, 200),
        _range(201, 250),
      ]);
      expect(await readOutbox(db), isEmpty);
    });

    test('applied false da kabul sayılır', () async {
      await enqueue(2);
      handler = (request) => _json({
        'results': [
          for (final id in _ids(request))
            {'id': id, 'status': 'ok', 'applied': false},
        ],
        'server_time': '2026-11-11T09:00:01.000000Z',
        'warning': {'code': 'clock_skew', 'skew_seconds': 400},
      });

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 2),
      );
      expect(await readOutbox(db), isEmpty);
    });

    test('reddedilen kaydı işaretler, kuyruğun geri kalanını gönderir; '
        'işaretli kayıt bir daha gitmez', () async {
      await enqueue(150);
      handler = (request) => _accept(
        request,
        rejected: {2: 'forbidden', 120: 'missing_reference'},
      );

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 148, rejected: 2),
      );
      final left = await readOutbox(db);
      expect(left.map((entry) => entry.id), [2, 120]);
      expect(left.map((entry) => entry.lastError), [
        'forbidden: forbidden mesajı',
        'missing_reference: missing_reference mesajı',
      ]);
      expect(delays, isEmpty);

      requests.clear();
      expect(await service.push(), const SyncResult(status: SyncStatus.done));
      expect(requests, isEmpty);
    });

    test('yanıtta sonucu olmayan kayıt yerinde kalır ve tur durur', () async {
      await enqueue(3);
      handler = (request) => _json({
        'results': [
          {'id': 1, 'status': 'ok', 'applied': true},
          {'id': 2, 'status': 'beklenmeyen'},
        ],
        'server_time': '2026-11-11T09:00:01.000000Z',
        'warning': null,
      });

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.failed, pushed: 1),
      );
      expect((await readOutbox(db)).map((entry) => entry.id), [2, 3]);
    });
  });

  group('desteklenmeyen şema sürümü', () {
    test('426 güncelleme ister; kayıtlar işaretlenmez', () async {
      await enqueue(1);
      handler = (_) => _error(426, 'upgrade_required');

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.upgradeRequired),
      );
      expect(requests, hasLength(1));
      expect(delays, isEmpty);
      expect((await readOutbox(db)).single.lastError, isNull);
    });
  });

  group('geçici hata', () {
    final transientFailures = <String, _Handler>{
      'bağlantı hatası': (_) => throw http.ClientException('bağlantı koptu'),
      'istek zaman aşımı': (_) => Completer<http.Response>().future,
      '408': (_) => _json({'message': 'Request Timeout'}, 408),
      '429 (hız sınırı)': (_) => _error(429, 'too_many_requests'),
      '500': (_) => _json({
        'status': 500,
        'message': 'x',
        'data': <String, Object?>{},
      }, 500),
      'JSON dönmeyen ağ geçidi (502)': (_) =>
          http.Response('<html>Bad Gateway</html>', 502),
      '503 (sunucu paketi geri aldı)': (_) => _error(503, 'unavailable'),
      '504': (_) => http.Response('', 504),
    };
    for (final MapEntry(key: name, value: failure)
        in transientFailures.entries) {
      test('geçici sayılır: $name', () async {
        await enqueue(1);
        handler = (request) =>
            requests.length == 1 ? failure(request) : _accept(request);

        expect(
          await service.push(),
          const SyncResult(status: SyncStatus.done, pushed: 1),
        );
        expect(delays, _seconds([1]));
        expect(requests.map(_ids), [
          [1],
          [1],
        ]);
        expect(client.authStore.token, _token);
      });
    }

    test('aynı paketi üstel bekleyerek yeniden gönderir; denemeler '
        'tükenince durur, kayıtlar yerinde', () async {
      await enqueue(150);
      handler = (_) => _error(503, 'unavailable');

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(delays, _seconds([1, 2, 4, 8, 16]));
      expect(requests.map(_ids), List.filled(6, _range(1, 100)));
      final left = await readOutbox(db);
      expect(left, hasLength(150));
      expect(left.take(100).map((entry) => entry.attempts), everyElement(6));
      expect(left.map((entry) => entry.lastError), everyElement(isNull));
    });
  });

  group('yeniden denenmeyen hata', () {
    final fatalFailures = <String, _Handler>{
      '400 (bozuk istek)': (_) => _error(400, 'invalid'),
      '403': (_) => _json({
        'status': 403,
        'message': 'x',
        'data': <String, Object?>{},
      }, 403),
      '404 (route yok)': (_) => _json({'status': 404, 'message': 'x'}, 404),
      '413': (_) => http.Response('', 413),
      'JSON olmayan 200': (_) => http.Response('<html>proxy</html>', 200),
      'biçimi bozuk 200': (_) => _json({'results': 'yok'}),
    };
    for (final MapEntry(key: name, value: failure) in fatalFailures.entries) {
      test('turu bitirir: $name', () async {
        await enqueue(2);
        handler = failure;

        expect(
          await service.push(),
          const SyncResult(status: SyncStatus.failed),
        );
        expect(requests, hasLength(1));
        expect(delays, isEmpty);
        final left = await readOutbox(db);
        expect(left.map((entry) => entry.attempts), [1, 1]);
        expect(left.map((entry) => entry.lastError), everyElement(isNull));
        expect(client.authStore.token, _token);
      });
    }

    test('401 oturumu kapatır ve turu bitirir', () async {
      await enqueue(1);
      handler = (_) => _json({
        'status': 401,
        'message': 'The request requires valid record authorization token.',
        'data': <String, Object?>{},
      }, 401);

      expect(await service.push(), const SyncResult(status: SyncStatus.failed));
      expect(requests, hasLength(1));
      expect(delays, isEmpty);
      expect(client.authStore.token, isEmpty);
      expect(client.authStore.record, isNull);
      expect((await readOutbox(db)).single.lastError, isNull);
    });

    test('401 sürerken yeni giriş yapıldıysa yeni oturum kapanmaz', () async {
      await enqueue(1);
      handler = (_) {
        client.authStore.save('new-token', RecordModel({'id': 'user-2'}));
        return _json({
          'status': 401,
          'message': 'x',
          'data': <String, Object?>{},
        }, 401);
      };

      expect(await service.push(), const SyncResult(status: SyncStatus.failed));
      expect(client.authStore.token, 'new-token');
    });

    test('oturum yoksa istek atmadan biter', () async {
      await enqueue(1);
      client.authStore.clear();

      expect(await service.push(), const SyncResult(status: SyncStatus.failed));
      expect(requests, isEmpty);
    });
  });

  group('çekme', () {
    test('tabloyu GET /api/sync/pull ile sayfa sayfa çeker; imleç her '
        'sayfada ilerler', () async {
      handler = _server({
        'apiaries': [
          for (var seq = 1; seq <= 5; seq++) _apiaryRow('a-$seq', seq),
        ],
      }, maxPage: 2);

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 5),
      );

      final first = requests.first;
      expect(first.method, 'GET');
      expect(first.headers['Authorization'], _token);
      expect(first.url.path, '/api/sync/pull');
      expect(first.url.queryParameters, {
        'table': 'organizations',
        'since_seq': '0',
        'page_size': '${SyncService.pullPageSize}',
      });
      expect(
        requests
            .where((r) => r.url.queryParameters['table'] == 'apiaries')
            .map((r) => r.url.queryParameters['since_seq']),
        ['0', '2', '4'],
      );
      expect(
        requests.map((r) => r.url.queryParameters['table']).toSet(),
        service.pullTables.map((t) => t.actualTableName).toSet(),
      );

      final apiaries = await db.select(db.apiaries).get();
      expect(
        apiaries.map((a) => a.id),
        unorderedEquals(_range(1, 5).map((s) => 'a-$s')),
      );
      final yayla = apiaries.firstWhere((a) => a.id == 'a-1');
      expect(yayla.name, 'Yayla 1');
      expect(yayla.deletedAt, isNull);
      expect(yayla.updatedAt, DateTime.utc(2026, 11, 11, 8, 0, 0, 123, 456));
      expect(await _cursors(db), containsPair('apiaries', 5));
      expect(await _cursors(db), containsPair(fullPullMarker, 0));
    });

    test('sonraki tur imleçten devam eder', () async {
      final rows = [_apiaryRow('a-1', 1)];
      handler = _server({'apiaries': rows});
      await service.pull();
      rows.add(_apiaryRow('a-2', 7));
      requests.clear();

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 1),
      );
      expect(
        requests
            .firstWhere((r) => r.url.queryParameters['table'] == 'apiaries')
            .url
            .queryParameters['since_seq'],
        '1',
      );
      expect(await _cursors(db), containsPair('apiaries', 7));
    });

    test('geçici hatada aynı sayfayı üstel bekleyerek yeniden ister; '
        'tükenince imleçler yerinde, tam çekme işaretlenmez', () async {
      final server = _server({
        'apiaries': [_apiaryRow('a-1', 1), _apiaryRow('a-2', 2)],
      }, maxPage: 1);
      var failures = 0;
      handler = (request) {
        final query = request.url.queryParameters;
        if (query['table'] == 'apiaries' &&
            query['since_seq'] == '1' &&
            failures++ < 2) {
          return _error(503, 'unavailable');
        }
        return server(request);
      };

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 2),
      );
      expect(delays, _seconds([1, 2]));

      await db.delete(db.syncState).go();
      delays.clear();
      handler = (request) => request.url.queryParameters['table'] == 'apiaries'
          ? throw http.ClientException('çevrimdışı')
          : server(request);

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(delays, _seconds([1, 2, 4, 8, 16]));
      expect(await _cursors(db), isNot(contains('apiaries')));
      expect(await _cursors(db), isNot(contains(fullPullMarker)));
    });

    test('bilinmeyen tablo (400 unsupported) turu bitirir', () async {
      handler = (_) => _error(400, 'unsupported');

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(requests, hasLength(1));
    });

    test('biçimi bozuk sayfa turu bitirir', () async {
      handler = (_) =>
          _json({'rows': <Object?>[], 'next_seq': '3', 'has_more': false});

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(delays, isEmpty);
    });
  });

  group('tam tur', () {
    test('turun başında oturumu yeniler, 401 alan turda oturum kapanır ve '
        'çekme yapılmaz', () async {
      final calls = <String>[];
      service = SyncService(
        db,
        PocketBaseSyncTransport(client),
        clock: clock.call,
        delay: (duration) async => delays.add(duration),
        refreshSession: () async => calls.add('refresh:${requests.length}'),
      );
      await enqueue(1);
      handler = (_) => _json({
        'status': 401,
        'message': 'x',
        'data': <String, Object?>{},
      }, 401);

      expect(await service.sync(), const SyncResult(status: SyncStatus.failed));
      expect(calls, ['refresh:0']);
      expect(requests.map((r) => r.url.path), ['/api/sync/push']);
      expect(client.authStore.token, isEmpty);
    });
  });
}

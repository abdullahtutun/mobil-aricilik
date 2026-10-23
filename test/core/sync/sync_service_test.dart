import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/tokens/app_colors.dart'
    show QueenMarkColor;
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_location_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
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

typedef _Rows = List<Map<String, Object?>>;

const _org = 'org-1';

/// Sunucu satırlarının ortak alanları, sync_pull'un döndüğü biçimde.
Map<String, Object?> _standard(
  String id,
  int seq, {
  String? deletedAt,
  String updatedAt = '2026-10-23T08:00:00.123456+00:00',
}) => {
  'id': id,
  'created_at': '2026-10-23T07:00:00+00:00',
  'updated_at': updatedAt,
  'created_by': 'user-1',
  'deleted_at': deletedAt,
  'server_seq': seq,
};

Map<String, Object?> _organizationRow(int seq) => {
  ..._standard(_org, seq),
  'name': 'Petek Arıcılık',
  'country_code': 'TR',
  'currency': 'TRY',
  'tr_registration_no': null,
  'tr_aks_no': null,
  'hive_count_range': 'up_to_50',
};

Map<String, Object?> _membershipRow(int seq) => {
  ..._standard('membership-1', seq),
  'org_id': _org,
  'user_id': 'user-1',
  'role': 'owner',
};

/// Konum sync_pull'daki gibi latitude + longitude.
Map<String, Object?> _apiaryRow(
  String id,
  int seq, {
  String? name = 'Yayla',
  String? deletedAt,
}) => {
  ..._standard(id, seq, deletedAt: deletedAt),
  'org_id': _org,
  'name': name,
  'latitude': 38.41,
  'longitude': 27.14,
  'altitude_m': 1200,
  'landowner_name': null,
  'landowner_phone': null,
  'land_tenure': 'rented',
  'water_source': null,
  'vehicle_distance_m': null,
  'road_notes': null,
  'notes': null,
};

Map<String, Object?> _queenRow(int seq) => {
  ..._standard('queen-1', seq),
  'org_id': _org,
  'year': 2026,
  'mark_color': 'yellow',
  'breed': 'Kafkas',
  'breed_line': null,
  'source': 'own_rearing',
  'mating_status': 'mated',
  'wing_clipped': true,
  'mother_queen_id': null,
};

Map<String, Object?> _hiveRow(
  String id,
  int seq, {
  String type = 'langstroth',
}) => {
  ..._standard(id, seq),
  'org_id': _org,
  'number': '101',
  'tag_code': null,
  'type': type,
  'status': 'active',
  'apiary_id': 'apiary-1',
  'queen_id': 'queen-1',
  'box_count': 2,
  'frame_count': 10,
  'source': 'swarm',
  'marking': null,
};

Map<String, Object?> _moveRow(int seq) => {
  ..._standard('move-1', seq),
  'org_id': _org,
  'hive_id': 'hive-1',
  'apiary_id': 'apiary-1',
  'moved_at': '2026-10-23T06:30:00+00:00',
};

bool _isPull(http.Request request) =>
    request.url.path == '/rest/v1/rpc/sync_pull';

/// Çekme isteğinin tablosu ve imleci.
({String table, int since}) _pullOf(http.Request request) {
  final body = jsonDecode(request.body) as Map<String, dynamic>;
  return (table: body['table_name'] as String, since: body['since_seq'] as int);
}

/// Sahte sunucu: sync_push'a her şeyi kabul eder; sync_pull'a [tables]'daki
/// satırlardan imleçten büyük olanları server_seq sırasıyla döner. Sayfa en
/// çok [maxPage] satır (sunucu istenenden az dönebilir); geriye bakma payı
/// yok.
_Handler _server(Map<String, _Rows> tables, {int maxPage = 1000}) => (request) {
  if (!_isPull(request)) return _accept(request);
  final body = jsonDecode(request.body) as Map<String, dynamic>;
  final (:table, :since) = _pullOf(request);
  final rows = [
    for (final row in tables[table] ?? const <Map<String, Object?>>[])
      if ((row['server_seq']! as int) > since) row,
  ];
  final page = rows.take(math.min(body['page_size'] as int, maxPage)).toList();
  return _json({
    'rows': page,
    'next_seq': page.isEmpty ? since : page.last['server_seq'],
    'has_more': rows.length > page.length,
  });
};

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
      expect(await service.push(), const SyncResult(status: SyncStatus.done));
      expect(requests, isEmpty);
    });

    test('kayıtları sync_push sözleşmesiyle gönderir', () async {
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
        const SyncResult(status: SyncStatus.done, pushed: 250),
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
        const SyncResult(status: SyncStatus.done, pushed: 2),
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
        const SyncResult(status: SyncStatus.done, pushed: 2),
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
          const SyncResult(status: SyncStatus.done, pushed: 148, rejected: 2),
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

      expect(await service.push(), const SyncResult(status: SyncStatus.done));
      expect(requests, isEmpty);

      await enqueue(1);
      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 1),
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
        const SyncResult(status: SyncStatus.done, pushed: 3),
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
        const SyncResult(status: SyncStatus.retryLater),
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
        const SyncResult(status: SyncStatus.done, pushed: 150),
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
          const SyncResult(status: SyncStatus.done, pushed: 1),
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
          const SyncResult(status: SyncStatus.done, pushed: 1),
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
          const SyncResult(status: SyncStatus.failed),
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

      expect(await service.push(), const SyncResult(status: SyncStatus.failed));
      expect(requests, isEmpty);
      expect(delays, isEmpty);
    });

    test('desteklenmeyen şema sürümünde güncelleme ister', () async {
      await enqueue(1);
      handler = (_) => _postgrestError('PT426', 426);

      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.upgradeRequired),
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
        const SyncResult(status: SyncStatus.failed, pushed: 50),
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
        const result = SyncResult(status: SyncStatus.done, pushed: 1);
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
          const SyncResult(status: SyncStatus.done, pushed: 1),
        );
        expect(requests, hasLength(2));
      },
    );

    test('biten tur kilidi bırakır, hatayla bitse de', () async {
      await enqueue(1);
      handler = (_) => _postgrestError('42501', 401);
      expect((await service.push()).status, SyncStatus.failed);

      handler = _accept;
      expect(
        await service.push(),
        const SyncResult(status: SyncStatus.done, pushed: 1),
      );
      expect(requests, hasLength(2));
    });
  });

  group('çekme', () {
    test('her yerel senkron tablosunu çeker', () {
      expect(service.pullTables.map((table) => table.actualTableName).toSet(), {
        for (final table in db.allTables)
          if (table.$columns.any((column) => column.name == 'server_seq'))
            table.actualTableName,
      });
    });

    test('tabloları sırayla imleçten çeker, satırları yerel DB’ye '
        'sunucudaki değerleriyle yazar', () async {
      handler = _server({
        'organizations': [_organizationRow(1)],
        'memberships': [_membershipRow(2)],
        'apiaries': [_apiaryRow('apiary-1', 3)],
        'queens': [_queenRow(4)],
        'hives': [_hiveRow('hive-1', 5)],
        'hive_location_history': [_moveRow(6)],
      });

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 6),
      );

      expect(requests.map(_pullOf), [
        (table: 'organizations', since: 0),
        (table: 'memberships', since: 0),
        (table: 'apiaries', since: 0),
        (table: 'queens', since: 0),
        (table: 'hives', since: 0),
        (table: 'hive_location_history', since: 0),
      ]);
      final body = jsonDecode(requests.first.body) as Map<String, dynamic>;
      expect(body['page_size'], SyncService.pullPageSize);
      expect(requests.first.headers['Authorization'], 'Bearer user-token');

      final organization = await db.select(db.organizations).getSingle();
      expect(organization.name, 'Petek Arıcılık');
      expect(organization.hiveCountRange, HiveCountRange.upTo50);
      expect(
        (await db.select(db.memberships).getSingle()).role,
        MembershipRole.owner,
      );

      final apiary = (await ApiaryRepository(db).findById('apiary-1'))!;
      expect(apiary.latitude, 38.41);
      expect(apiary.landTenure, LandTenure.rented);
      expect(apiary.createdBy, 'user-1');
      expect(apiary.serverSeq, 3);
      // Mikrosaniye ve UTC korunur; son yazan kazanır kararı buna dayanır.
      expect(apiary.updatedAt, DateTime.utc(2026, 10, 23, 8, 0, 0, 123, 456));
      expect(apiary.createdAt, DateTime.utc(2026, 10, 23, 7));

      final queen = (await QueenRepository(db).findById('queen-1'))!;
      expect(queen.markColor, QueenMarkColor.yellow);
      expect(queen.source, QueenSource.ownRearing);
      expect(queen.matingStatus, QueenMatingStatus.mated);
      expect(queen.wingClipped, isTrue);

      final hive = (await HiveRepository(db).findById('hive-1'))!;
      expect(hive.type, HiveType.langstroth);
      expect(hive.source, HiveSource.swarm);
      expect(hive.boxCount, 2);

      final move = (await HiveLocationRepository(db).findById('move-1'))!;
      expect(move.movedAt, DateTime.utc(2026, 10, 23, 6, 30));

      expect(await _cursors(db), {
        'organizations': 1,
        'memberships': 2,
        'apiaries': 3,
        'queens': 4,
        'hives': 5,
        'hive_location_history': 6,
        fullPullMarker: 0,
      });
      // Çekme outbox'a yazmaz; inen satırlar geri gönderilmez.
      expect(await readOutbox(db), isEmpty);
    });

    test('mevcut satırı sunucudaki hâliyle günceller', () async {
      handler = _server({
        'apiaries': [_apiaryRow('apiary-1', 3)],
      });
      await service.pull();

      handler = _server({
        'apiaries': [_apiaryRow('apiary-1', 9, name: 'Ova')],
      });
      expect((await service.pull()).pulled, 1);

      expect((await ApiaryRepository(db).findById('apiary-1'))!.name, 'Ova');
      expect(await db.select(db.apiaries).get(), hasLength(1));
      expect((await _cursors(db))['apiaries'], 9);
    });

    test(
      'sayfa sayfa çeker; yarıda kesilirse kaldığı sayfadan sürer',
      () async {
        final hives = [
          for (var seq = 1; seq <= 5; seq++) _hiveRow('h$seq', seq),
        ];
        final serve = _server({'hives': hives}, maxPage: 2);
        handler = (request) {
          final hiveRequests = requests.where(
            (request) => _pullOf(request).table == 'hives',
          );
          // Üçüncü sayfa reddedilir (ör. oturum düştü).
          if (_pullOf(request).table == 'hives' && hiveRequests.length == 3) {
            return _postgrestError('42501', 401);
          }
          return serve(request);
        };

        expect(
          await service.pull(),
          const SyncResult(status: SyncStatus.failed, pulled: 4),
        );
        expect(requests.map(_pullOf).where((pull) => pull.table == 'hives'), [
          (table: 'hives', since: 0),
          (table: 'hives', since: 2),
          (table: 'hives', since: 4),
        ]);
        expect((await _cursors(db))['hives'], 4);
        expect(await db.select(db.hives).get(), hasLength(4));
        expect((await _cursors(db)).containsKey(fullPullMarker), isFalse);

        requests.clear();
        handler = serve;
        expect(
          await service.pull(),
          const SyncResult(status: SyncStatus.done, pulled: 1),
        );
        expect(
          requests.map(_pullOf).firstWhere((pull) => pull.table == 'hives'),
          (table: 'hives', since: 4),
        );
        expect(await db.select(db.hives).get(), hasLength(5));
        expect((await _cursors(db))['hives'], 5);
      },
    );

    test('outbox’ta bekleyen değişikliği olan satırı ezmez; imleç onu '
        'geçmez, gönderilince sunucudaki hâli iner', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final local = await repository.create(orgId: _org, name: 'Yerel ad');
      final server = _server({
        'apiaries': [
          _apiaryRow(local.id, 7, name: 'Sunucudaki ad'),
          _apiaryRow('apiary-2', 8),
        ],
      });
      handler = server;

      expect((await service.pull()).pulled, 1);
      expect((await repository.findById(local.id))!.name, 'Yerel ad');
      expect(await repository.findById('apiary-2'), isNotNull);
      expect((await _cursors(db))['apiaries'], 6);

      await service.push();
      requests.clear();
      expect((await service.pull()).pulled, 2);
      expect(
        requests.where(_isPull).map(_pullOf),
        contains((table: 'apiaries', since: 6)),
      );
      expect((await repository.findById(local.id))!.name, 'Sunucudaki ad');
      expect((await _cursors(db))['apiaries'], 8);
    });

    test('sunucunun reddettiği kayıt bekleyen sayılmaz; satır sunucudaki '
        'hâliyle güncellenir', () async {
      final repository = ApiaryRepository(db, clock: clock.call);
      final local = await repository.create(orgId: _org, name: 'Yerel ad');
      await db
          .update(db.outbox)
          .write(const OutboxCompanion(lastError: Value('forbidden: RLS')));
      handler = _server({
        'apiaries': [_apiaryRow(local.id, 7, name: 'Sunucudaki ad')],
      });

      expect((await service.pull()).pulled, 1);
      expect((await repository.findById(local.id))!.name, 'Sunucudaki ad');
      expect((await _cursors(db))['apiaries'], 7);
    });

    test('silinen satır deleted_at ile yazılır, listelerden düşer', () async {
      handler = _server({
        'apiaries': [
          _apiaryRow('apiary-1', 3, deletedAt: '2026-10-23T09:00:00+00:00'),
        ],
      });

      await service.pull();

      expect(await ApiaryRepository(db).findById('apiary-1'), isNull);
      final row = await db.select(db.apiaries).getSingle();
      expect(row.deletedAt, DateTime.utc(2026, 10, 23, 9));
    });

    test('geriye bakma payında yeniden gelen satırlar zararsız', () async {
      // Taze bölgede sunucu satırları döner ama imleci ilerletmez.
      handler = (request) => _isPull(request)
          ? _json({
              'rows': _pullOf(request).table == 'apiaries'
                  ? [_apiaryRow('apiary-1', 3), _apiaryRow('apiary-2', 4)]
                  : const <Object>[],
              'next_seq': 0,
              'has_more': false,
            })
          : _accept(request);

      await service.pull();
      await service.pull();

      expect(await db.select(db.apiaries).get(), hasLength(2));
      expect((await _cursors(db))['apiaries'], 0);
    });

    test('sunucuda olup yerelde olmayan kolon atlanır', () async {
      handler = _server({
        'apiaries': [
          {..._apiaryRow('apiary-1', 3), 'gelecek_kolon': 'değer'},
        ],
      });

      expect((await service.pull()).status, SyncStatus.done);
      expect(await ApiaryRepository(db).findById('apiary-1'), isNotNull);
    });

    final invalidRows = <String, Map<String, Object?>>{
      'tanınmayan enum değeri (daha yeni şema)': _hiveRow(
        'hive-2',
        2,
        type: 'top_bar',
      ),
      'zorunlu alan boş': {..._hiveRow('hive-2', 2), 'number': null},
      'yanlış tür': {..._hiveRow('hive-2', 2), 'box_count': 'iki'},
      'bozuk tarih': {..._hiveRow('hive-2', 2), 'updated_at': 'dün'},
    };
    for (final MapEntry(key: name, value: row) in invalidRows.entries) {
      test('okunamayan satır sayfayı reddeder: $name', () async {
        handler = _server({
          'hives': [_hiveRow('hive-1', 1), row],
        });

        expect(
          await service.pull(),
          const SyncResult(status: SyncStatus.failed),
        );
        expect(await db.select(db.hives).get(), isEmpty);
        expect((await _cursors(db)).containsKey('hives'), isFalse);
      });
    }

    test('ilerlemeden “devamı var” diyen yanıtta durur', () async {
      handler = (request) => _isPull(request)
          ? _json({'rows': const <Object>[], 'next_seq': 0, 'has_more': true})
          : _accept(request);

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(requests, hasLength(1));
    });

    test('geçici hatada aynı sayfayı üstel bekleyerek yeniden ister', () async {
      final serve = _server({
        'apiaries': [_apiaryRow('apiary-1', 3)],
      });
      handler = (request) {
        if (requests.length <= 2) throw const SocketException('çevrimdışı');
        return serve(request);
      };

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.done, pulled: 1),
      );
      expect(delays, _seconds([1, 2]));
      expect(requests.take(3).map(_pullOf), [
        for (var i = 0; i < 3; i++) (table: 'organizations', since: 0),
      ]);
    });

    test('denemeler tükenince durur; imleçler yerinde, tam çekme '
        'işaretlenmez', () async {
      handler = (_) => throw const SocketException('çevrimdışı');

      expect(
        await service.pull(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(delays, _seconds([1, 2, 4, 8, 16]));
      expect(await _cursors(db), isEmpty);
    });

    test('yeniden denenmeyen hatada hemen durur', () async {
      handler = (_) => _postgrestError('42501', 401);

      expect(await service.pull(), const SyncResult(status: SyncStatus.failed));
      expect(requests, hasLength(1));
      expect(delays, isEmpty);
    });

    test('ilerlemeyi tablo tablo bildirir', () async {
      handler = _server({
        'organizations': [_organizationRow(1)],
        'apiaries': [_apiaryRow('apiary-1', 3), _apiaryRow('apiary-2', 4)],
      });
      final progress = <SyncProgress>[];

      await service.pull(onProgress: progress.add);

      SyncProgress at(int tablesDone, int rows) =>
          SyncProgress(tablesDone: tablesDone, tableCount: 6, rowsPulled: rows);
      expect(progress.first, at(0, 0));
      expect(progress.last, at(6, 3));
      expect(progress, contains(at(2, 3)));
      expect(
        progress.map((event) => event.tablesDone),
        orderedEquals([...progress.map((event) => event.tablesDone)]..sort()),
      );
    });

    test('tur sürerken gelen çağrı aynı turu bekler', () async {
      final entered = Completer<void>();
      final release = Completer<void>();
      final serve = _server({});
      handler = (request) async {
        if (!entered.isCompleted) entered.complete();
        await release.future;
        return await serve(request);
      };

      final first = service.pull();
      await entered.future;
      expect(service.pull(), same(first));
      release.complete();
      expect((await first).status, SyncStatus.done);
      expect(requests, hasLength(6));
    });
  });

  group('tam tur', () {
    test('önce gönderir, sonra çeker; sonuçlar birleşir', () async {
      await enqueue(2);
      handler = _server({
        'hives': [_hiveRow('hive-1', 5)],
      });

      expect(
        await service.sync(),
        const SyncResult(status: SyncStatus.done, pushed: 2, pulled: 1),
      );
      expect(requests.first.url.path, '/rest/v1/rpc/sync_push');
      expect(requests.skip(1).every(_isPull), isTrue);
      expect(requests.skip(1), hasLength(6));
    });

    test('gönderme bitmezse çekmez', () async {
      await enqueue(1);
      handler = (_) => throw const SocketException('çevrimdışı');

      expect(
        await service.sync(),
        const SyncResult(status: SyncStatus.retryLater),
      );
      expect(requests.where(_isPull), isEmpty);
    });

    test('reddedilen kayıt turu durdurmaz', () async {
      await enqueue(2);
      final serve = _server({});
      handler = (request) => _isPull(request)
          ? serve(request)
          : _accept(request, rejected: {1: 'invalid'});

      expect(
        await service.sync(),
        const SyncResult(status: SyncStatus.done, pushed: 1, rejected: 1),
      );
      expect(requests.where(_isPull), hasLength(6));
    });

    test('tur sürerken gelen çağrı aynı turu bekler', () async {
      await enqueue(1);
      final entered = Completer<void>();
      final release = Completer<void>();
      final serve = _server({});
      handler = (request) async {
        if (!entered.isCompleted) entered.complete();
        await release.future;
        return await serve(request);
      };

      final first = service.sync();
      await entered.future;
      expect(service.sync(), same(first));
      release.complete();
      expect(await first, const SyncResult(status: SyncStatus.done, pushed: 1));
      expect(requests, hasLength(7));
    });
  });
}

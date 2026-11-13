import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/sync_backend.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:pocketbase/pocketbase.dart';

import '../../helpers/test_database.dart';

const _dev = 'pocketbase|https://arici-api-dev.tutunsoft.com';
const _local = 'pocketbase|http://127.0.0.1:8090';

http.Response _json(Object? body) => http.Response(
  jsonEncode(body),
  200,
  headers: {'content-type': 'application/json; charset=utf-8'},
);

void main() {
  late AppDatabase db;
  late LocalSettingsRepository settings;

  setUp(() {
    db = openTestDatabase();
    settings = LocalSettingsRepository(db);
  });

  /// Dev sunucusuyla senkronlanmış telefon: imleçler ve ilk tam çekme
  /// işareti.
  Future<void> syncedWithDev() async {
    await settings.writeValue(syncBackendKey, _dev);
    await db.batch(
      (batch) => batch.insertAll(db.syncState, [
        SyncStateCompanion.insert(
          recordTable: 'apiaries',
          lastPulledSeq: const Value(4210),
        ),
        SyncStateCompanion.insert(
          recordTable: 'hives',
          lastPulledSeq: const Value(5120),
        ),
        SyncStateCompanion.insert(recordTable: fullPullMarker),
      ]),
    );
  }

  Future<List<SyncCursor>> cursors() => db.select(db.syncState).get();

  test('aynı sunucuda bir şeye dokunmaz', () async {
    await syncedWithDev();

    expect(await resetCursorsIfBackendChanged(db, _dev), isFalse);
    expect(await cursors(), hasLength(3));
  });

  test('değer hiç yoksa (önceki sürüm) imleçler sıfırlanır ve değer '
      'yazılır', () async {
    await syncedWithDev();
    await settings.removeValue(syncBackendKey);

    expect(await resetCursorsIfBackendChanged(db, _dev), isTrue);
    expect(await cursors(), isEmpty);
    expect(await settings.readValue(syncBackendKey), _dev);
    expect(await resetCursorsIfBackendChanged(db, _dev), isFalse);
  });

  test('başka adres (ör. dev ↔ prod) değişim sayılır', () async {
    await settings.writeValue(syncBackendKey, _local);

    expect(
      await resetCursorsIfBackendChanged(
        db,
        'pocketbase|https://arici-api.tutunsoft.com',
      ),
      isTrue,
    );
  });

  test('eski sunucuda yazılmış, outbox’ta bekleyen kayıt adres değişince '
      'yeni sunucuya gönderilir; ilk tam çekme baştan yapılır', () async {
    await syncedWithDev();
    // Eski sunucuya gönderilmeden kalan yazma ve önceki sunucudan yerel bir
    // satır (sunucu numarası eski sunucunun).
    final apiaries = ApiaryRepository(db);
    final pending = await apiaries.create(orgId: 'org-1', name: 'Yayla');
    final outbox = await readOutbox(db);
    final fullPull = SyncRepository(db).watchFullPullDone();
    expect(await fullPull.first, isTrue);

    expect(await resetCursorsIfBackendChanged(db, _local), isTrue);

    // İmleçler ve işaret silindi: ilk çekme ekranı açılır. Outbox ve yerel
    // kayıt yerinde.
    expect(await cursors(), isEmpty);
    expect(await fullPull.first, isFalse);
    expect(await settings.readValue(syncBackendKey), _local);
    expect(
      (await readOutbox(db)).map((entry) => entry.toJson()),
      outbox.map((entry) => entry.toJson()),
    );
    expect((await apiaries.findById(pending.id))?.name, 'Yayla');

    final requests = <http.Request>[];
    final client = PocketBase(
      'http://127.0.0.1:8090',
      authStore: AuthStore()..save('pb-token', RecordModel({'id': 'user-1'})),
      httpClientFactory: () => MockClient((request) async {
        requests.add(request);
        if (request.url.path == PocketBaseSyncTransport.pushPath) {
          final body = jsonDecode(request.body) as Map<String, dynamic>;
          return _json({
            'results': [
              for (final change in body['changes'] as List<dynamic>)
                {
                  'id': (change as Map<String, dynamic>)['id'],
                  'status': 'ok',
                  'applied': true,
                },
            ],
            'server_time': '2026-11-11T09:00:01.000000Z',
            'warning': null,
          });
        }
        return _json({
          'rows': <Object?>[],
          'next_seq': int.parse(request.url.queryParameters['since_seq']!),
          'has_more': false,
        });
      }),
    );

    expect(
      await SyncService(db, PocketBaseSyncTransport(client)).sync(),
      const SyncResult(status: SyncStatus.done, pushed: 1),
    );

    final push = requests.first;
    expect(push.url.path, '/api/sync/push');
    expect(push.headers['Authorization'], 'pb-token');
    expect((jsonDecode(push.body) as Map<String, dynamic>)['changes'], [
      {
        'id': outbox.single.id,
        'table': 'apiaries',
        'operation': 'upsert',
        'payload': outbox.single.payload,
      },
    ]);
    expect(await readOutbox(db), isEmpty);

    // Her tablo yeni sunucunun numaralarıyla sıfırdan çekildi.
    final pulls = requests.skip(1).toList();
    expect(
      pulls,
      hasLength(
        SyncService(db, PocketBaseSyncTransport(client)).pullTables.length,
      ),
    );
    expect(
      pulls.map((r) => r.url.queryParameters['since_seq']),
      everyElement('0'),
    );
    expect(await fullPull.first, isTrue);
  });
}

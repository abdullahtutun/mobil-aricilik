import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/organization/data/organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test/helpers/test_database.dart';

export '../../test/helpers/test_database.dart' show TestClock;

/// Yerel Supabase (`supabase start`). iOS simülatöründe 127.0.0.1 Mac'in
/// kendisidir; başka cihazda adres `--dart-define=SUPABASE_URL=...` ile
/// verilir.
const supabaseUrl = String.fromEnvironment(
  'SUPABASE_URL',
  defaultValue: 'http://127.0.0.1:54321',
);

/// Supabase CLI'ın her kurulumda aynı olan yerel publishable key'i
/// (`supabase status`).
const supabaseKey = String.fromEnvironment(
  'SUPABASE_KEY',
  defaultValue: 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
);

/// İsteği RPC adıyla (ve çekmede tablosuyla) seçer.
typedef RequestMatcher = bool Function(http.BaseRequest request);

/// [name] RPC'sine giden istek; [table] verilirse yalnız o tablonun
/// `sync_pull` çağrısı.
RequestMatcher rpc(String name, {String? table}) => (request) {
  if (request.url.path != '/rest/v1/rpc/$name') return false;
  if (table == null) return true;
  final params = jsonDecode((request as http.Request).body) as Map;
  return params['table_name'] == table;
};

/// Cihazın ağ bağlantısı. Testler bağlantıyı keser ya da bir isteğin
/// ortasında koparır.
class TestNetwork extends http.BaseClient {
  final _inner = http.Client();

  /// false iken istekler sunucuya hiç ulaşmaz.
  bool online = true;

  /// Eşleşen istek sunucuya ulaşmadan bağlantı kopar.
  RequestMatcher? cutBefore;

  /// Eşleşen istek sunucuda işlenir, yanıt yolda kaybolur ve bağlantı
  /// kopar.
  RequestMatcher? cutAfter;

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    if (online && (cutBefore?.call(request) ?? false)) online = false;
    if (!online) throw http.ClientException('Ağ yok', request.url);
    final response = await _inner.send(request);
    if (cutAfter?.call(request) ?? false) {
      await response.stream.drain<void>();
      online = false;
      throw http.ClientException('Bağlantı koptu', request.url);
    }
    return response;
  }

  /// Bağlantıyı geri getirir ve kesme kurallarını kaldırır.
  void reconnect() {
    online = true;
    cutBefore = null;
    cutAfter = null;
  }

  @override
  void close() => _inner.close();
}

/// Testteki bir telefon: kendi yerel DB'si, kendi oturumu ve kesilebilen
/// ağı. Saat cihazlar arasında ortaktır; testler yazmalar arasında ilerletir.
class TestDevice {
  factory _open(String name, TestClock clock) {
    final network = TestNetwork();
    final client = SupabaseClient(
      supabaseUrl,
      supabaseKey,
      httpClient: network,
      // PKCE kod deposu ister; parola girişi için gerekmez.
      authOptions: const AuthClientOptions(
        autoRefreshToken: false,
        authFlowType: AuthFlowType.implicit,
      ),
    );
    addTearDown(() async {
      await client.dispose();
      network.close();
    });
    return TestDevice._(name, client, network, clock);
  }

  new _(this.name, this.client, this.network, this.clock)
    : db = openTestDatabase();

  /// [account] ile giriş yapmış yeni bir telefon; yerel DB'si boş.
  static Future<TestDevice> signIn(
    String name,
    TestAccount account,
    TestClock clock,
  ) async {
    final device = TestDevice._open(name, clock);
    await device.client.auth.signInWithPassword(
      email: account.email,
      password: account.password,
    );
    return device;
  }

  final String name;
  final AppDatabase db;
  final SupabaseClient client;
  final TestNetwork network;
  final TestClock clock;

  late final sync = SyncService(
    db,
    client,
    clock: clock.call,
    // Yeniden denemeler beklemeden yapılır.
    delay: (_) async {},
  );
  late final apiaries = ApiaryRepository(db, clock: clock.call);
  late final hives = HiveRepository(db, clock: clock.call);

  /// Tam tur; sonucu döner.
  Future<SyncResult> syncNow() => sync.sync();

  /// Kovanlar, silinenler dahil, kimlik sırasıyla.
  Future<List<Hive>> allHives() =>
      (db.select(db.hives)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

  /// Silinmemiş kovanların numaraları.
  Future<Set<String>> liveHiveNumbers() async => {
    for (final hive in await allHives())
      if (hive.deletedAt == null) hive.number,
  };

  /// Arılık geçmişi, silinenler dahil, kimlik sırasıyla.
  Future<List<HiveLocationEntry>> allLocationEntries() => (db.select(
    db.hiveLocationHistory,
  )..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

  Future<List<OutboxEntry>> outbox() => readOutbox(db);

  /// [table]'ın kaydedilmiş çekme imleci; hiç çekilmediyse 0.
  Future<int> cursor(String table) async {
    final query = db.select(db.syncState)
      ..where((t) => t.recordTable.equals(table));
    return (await query.getSingleOrNull())?.lastPulledSeq ?? 0;
  }

  Future<bool> fullPullDone() => SyncRepository(db).watchFullPullDone().first;

  @override
  String toString() => name;
}

/// Testin hesabı; her cihaz bununla giriş yapar.
typedef TestAccount = ({String email, String password});

/// Aynı hesapla giriş yapmış iki telefon ve ortak işletmeleri. İkisi de
/// işletmeyi ve ortak bir arılığı çekmiştir.
typedef TwoDevices = ({
  TestDevice a,
  TestDevice b,
  TestAccount account,
  String orgId,
  String apiaryId,
  TestClock clock,
});

/// Yeni bir hesap açar; A cihazı hesabı açıp işletmeyi kurar, B aynı
/// hesapla giriş yapar. A bir arılık ekler ve iki cihaz eşitlenir.
Future<TwoDevices> openTwoDevices() async {
  final clock = TestClock(DateTime.now().toUtc());
  final account = (
    email: 'two-devices-${generateId()}@example.com',
    password: 'two-devices-password',
  );
  final a = TestDevice._open('A', clock);
  await a.client.auth.signUp(email: account.email, password: account.password);
  final b = await TestDevice.signIn('B', account, clock);

  final org = await SupabaseOrganizationService(a.client).create(
    Organization(
      id: generateId(),
      name: 'İki Cihaz Arıcılık',
      countryCode: 'TR',
      currency: 'TRY',
    ),
  );
  final apiary = await a.apiaries.create(orgId: org.id, name: 'Yayla');
  await settle([a, b]);
  return (
    a: a,
    b: b,
    account: account,
    orgId: org.id,
    apiaryId: apiary.id,
    clock: clock,
  );
}

/// Cihazları sırayla iki kez eşitler; ikinci geçişte her cihaz diğerlerinin
/// yazmalarını almıştır. Her tur `done` bitmeli.
Future<void> settle(List<TestDevice> devices) async {
  for (var pass = 0; pass < 2; pass++) {
    for (final device in devices) {
      final result = await device.syncNow();
      expect(result.status, SyncStatus.done, reason: '$device: $result');
    }
  }
}

/// İki cihazın senkronlanan satırları birebir aynı mı ve outbox'lar boş mu.
Future<void> expectConverged(TestDevice a, TestDevice b) async {
  expect(await a.outbox(), isEmpty, reason: 'A outbox');
  expect(await b.outbox(), isEmpty, reason: 'B outbox');
  expect(await b.allHives(), await a.allHives());
  expect(await b.allLocationEntries(), await a.allLocationEntries());
}

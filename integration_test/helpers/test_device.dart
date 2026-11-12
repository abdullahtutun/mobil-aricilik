import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/pocketbase_sync_transport.dart';
import 'package:mobil_arici/core/sync/supabase_sync_transport.dart';
import 'package:mobil_arici/core/sync/sync_repository.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/sync/sync_transport.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_auth_service.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/organization/data/organization_service.dart';
import 'package:mobil_arici/features/organization/data/pocketbase_organization_service.dart';
import 'package:mobil_arici/features/organization/data/supabase_organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/team/data/pocketbase_team_service.dart';
import 'package:mobil_arici/features/team/data/supabase_team_service.dart';
import 'package:mobil_arici/features/team/data/team_service.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../test/helpers/test_database.dart';

export '../../test/helpers/test_database.dart' show TestClock;

/// Testlerin konuştuğu sunucu: `--dart-define=BACKEND=supabase|pocketbase`;
/// verilmezse dev flavor'ın varsayılanı (PocketBase).
final Backend testBackend = resolveBackend(Flavor.dev);

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

/// Yerel PocketBase'in adresi (`--dart-define=PB_URL=...`).
final String pocketbaseUrl = resolvePocketbaseUrl(Flavor.dev);

/// `server/ops/test_users.sh`'in açtığı hesaplar (JSON listesi:
/// `{email, id, token, expired_token}`); betiğin çıktısı
/// `--dart-define-from-file` ile verilir.
const _pocketbaseAccountsDefine = String.fromEnvironment('PB_TEST_ACCOUNTS');

/// İsteği seçer; testler eşleşen istekte bağlantıyı keser.
typedef RequestMatcher = bool Function(http.BaseRequest request);

/// Gönderim isteği (Supabase `sync_push` RPC'si, PocketBase
/// `POST /api/sync/push`).
RequestMatcher pushRequest() => switch (testBackend) {
  Backend.supabase => (request) => request.url.path == '/rest/v1/rpc/sync_push',
  Backend.pocketbase => (
    request,
  ) => request.url.path == PocketBaseSyncTransport.pushPath,
};

/// Çekme isteği; [table] verilirse yalnız o tablonunki.
RequestMatcher pullRequest({String? table}) => switch (testBackend) {
  Backend.supabase => (request) {
    if (request.url.path != '/rest/v1/rpc/sync_pull') return false;
    if (table == null) return true;
    final params = jsonDecode((request as http.Request).body) as Map;
    return params['table_name'] == table;
  },
  Backend.pocketbase =>
    (request) =>
        request.url.path == PocketBaseSyncTransport.pullPath &&
        (table == null || request.url.queryParameters['table'] == table),
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

/// Testin hesabı; her cihaz bununla giriş yapar. Supabase'de e-posta +
/// parola; PocketBase'de `test_users.sh`'in verdiği kimlik ve token'lar
/// (superuser'ın impersonate token'ı; parola girişi yalnız demo hesaba
/// açık kalır).
class TestAccount {
  const new _({
    required this.email,
    this.password,
    this.userId,
    this.token,
    this.expiredToken,
  });

  final String email;
  final String? password;
  final String? userId;
  final String? token;

  /// Süresi dolmuş token (PocketBase).
  final String? expiredToken;

  @override
  String toString() => email;
}

List<Map<String, Object?>>? _pocketbaseAccounts;
var _nextPocketbaseAccount = 0;

/// Daha önce hiçbir testin kullanmadığı bir hesap. Supabase'de yeni hesap
/// açılır; PocketBase'de betiğin hazırladığı havuzdan sıradaki alınır.
Future<TestAccount> newAccount() async {
  switch (testBackend) {
    case Backend.supabase:
      final email = 'two-devices-${generateId()}@example.com';
      const password = 'two-devices-password';
      final client = SupabaseClient(
        supabaseUrl,
        supabaseKey,
        authOptions: const AuthClientOptions(
          autoRefreshToken: false,
          authFlowType: AuthFlowType.implicit,
        ),
      );
      try {
        await client.auth.signUp(email: email, password: password);
      } finally {
        await client.dispose();
      }
      return TestAccount._(email: email, password: password);
    case Backend.pocketbase:
      final pool = _pocketbaseAccounts ??= _readPocketbaseAccounts();
      if (_nextPocketbaseAccount >= pool.length) {
        fail(
          'PB_TEST_ACCOUNTS havuzu bitti (${pool.length} hesap); '
          'server/ops/test_users.sh daha büyük bir sayıyla çalıştırılmalı.',
        );
      }
      final entry = pool[_nextPocketbaseAccount++];
      return TestAccount._(
        email: entry['email']! as String,
        userId: entry['id']! as String,
        token: entry['token']! as String,
        expiredToken: entry['expired_token']! as String,
      );
  }
}

List<Map<String, Object?>> _readPocketbaseAccounts() {
  final host = Uri.parse(pocketbaseUrl).host;
  // Test hesapları yalnız yerel sunucuda açılır; PB_URL verilmezse dev
  // sunucusuna gidilmesin.
  if (!const {'127.0.0.1', 'localhost', '10.0.2.2'}.contains(host)) {
    fail(
      'PocketBase testleri yalnız yerel sunucuya karşı çalışır; '
      '--dart-define=PB_URL=http://127.0.0.1:8090 verilmeli '
      '(şu an $pocketbaseUrl).',
    );
  }
  if (_pocketbaseAccountsDefine.isEmpty) {
    fail(
      'PB_TEST_ACCOUNTS yok: önce server/ops/test_users.sh çalıştırılır, '
      'çıktısı --dart-define-from-file=build/p91_accounts.json ile verilir.',
    );
  }
  return (jsonDecode(_pocketbaseAccountsDefine) as List<Object?>)
      .cast<Map<String, Object?>>();
}

/// Testteki bir telefon: kendi yerel DB'si, kendi oturumu ve kesilebilen
/// ağı. Saat cihazlar arasında ortaktır; testler yazmalar arasında ilerletir.
class TestDevice {
  new _(this.name, this.account, this.clock) : db = openTestDatabase() {
    switch (testBackend) {
      case Backend.supabase:
        supabase = SupabaseClient(
          supabaseUrl,
          supabaseKey,
          httpClient: network,
          // PKCE kod deposu ister; parola girişi için gerekmez.
          authOptions: const AuthClientOptions(
            autoRefreshToken: false,
            authFlowType: AuthFlowType.implicit,
          ),
        );
      case Backend.pocketbase:
        // Tek istemci: SDK her istekten sonra kapatmasın, kesme kuralları
        // aynı nesnede kalsın.
        pocketbase = PocketBase(
          pocketbaseUrl,
          reuseHTTPClient: true,
          httpClientFactory: () => network,
        );
    }
    addTearDown(() async {
      await supabase?.dispose();
      pocketbase?.close();
      network.close();
    });
  }

  /// [account] ile giriş yapmış yeni bir telefon; yerel DB'si boş.
  /// [expiredSession] ise PocketBase oturumu süresi dolmuş token'la kurulur
  /// (uzun süre çevrimdışı kalmış telefon).
  static Future<TestDevice> signIn(
    String name,
    TestAccount account,
    TestClock clock, {
    bool expiredSession = false,
  }) async {
    final device = TestDevice._(name, account, clock);
    switch (testBackend) {
      case Backend.supabase:
        await device.supabase!.auth.signInWithPassword(
          email: account.email,
          password: account.password!,
        );
      case Backend.pocketbase:
        device.restoreSession(
          token: expiredSession ? account.expiredToken : account.token,
        );
    }
    return device;
  }

  final String name;
  final TestAccount account;
  final AppDatabase db;
  final TestClock clock;
  final network = TestNetwork();

  /// Hangisi kullanılıyorsa onun istemcisi; diğeri null.
  SupabaseClient? supabase;
  PocketBase? pocketbase;

  /// PocketBase'de giriş: kayıtlı oturum telefona yazılır (ağa gitmez).
  /// [token] verilmezse hesabın geçerli token'ı.
  void restoreSession({String? token}) {
    pocketbase!.authStore.save(
      token ?? account.token!,
      RecordModel.fromJson({
        'id': account.userId,
        'email': account.email,
        'collectionId': '_pb_users_auth_',
        'collectionName': PocketBaseAuthService.usersCollection,
      }),
    );
  }

  /// Uygulamanın PocketBase oturum servisi (yenileme, K-6).
  late final auth = PocketBaseAuthService(
    pocketbase!,
    PocketBaseSessionStorage(pocketbaseUrl),
  );

  /// Telefonda oturum var mı.
  bool get signedIn => switch (testBackend) {
    Backend.supabase => supabase!.auth.currentSession != null,
    Backend.pocketbase => auth.currentUser != null,
  };

  late final SyncTransport transport = switch (testBackend) {
    Backend.supabase => SupabaseSyncTransport(supabase!),
    Backend.pocketbase => PocketBaseSyncTransport(pocketbase!),
  };

  late final OrganizationService organizations = switch (testBackend) {
    Backend.supabase => SupabaseOrganizationService(supabase!),
    Backend.pocketbase => PocketBaseOrganizationService(pocketbase!),
  };

  late final TeamService team = switch (testBackend) {
    Backend.supabase => SupabaseTeamService(supabase!),
    Backend.pocketbase => PocketBaseTeamService(pocketbase!),
  };

  /// Uygulamadaki gibi kurulmuş senkron: PocketBase'de her tur token'ı
  /// yeniler.
  late final SyncService sync = syncWith(transport);

  /// [transport] ile konuşan, bu telefonun DB'sini kullanan senkron.
  SyncService syncWith(SyncTransport transport) => SyncService(
    db,
    transport,
    clock: clock.call,
    // Yeniden denemeler beklemeden yapılır.
    delay: (_) async {},
    refreshSession: switch (testBackend) {
      Backend.supabase => null,
      Backend.pocketbase => auth.refreshSession,
    },
  );

  late final apiaries = ApiaryRepository(db, clock: clock.call);
  late final hives = HiveRepository(db, clock: clock.call);
  late final inspections = InspectionRepository(db, clock: clock.call);

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

  /// Muayeneler, silinenler dahil, kimlik sırasıyla.
  Future<List<Inspection>> allInspections() => (db.select(
    db.inspections,
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

/// Yeni bir hesap alır; A ve B aynı hesapla giriş yapar, A işletmeyi
/// kurar. A bir arılık ekler ve iki cihaz eşitlenir.
Future<TwoDevices> openTwoDevices() async {
  final clock = TestClock(DateTime.now().toUtc());
  final account = await newAccount();
  final a = await TestDevice.signIn('A', account, clock);
  final b = await TestDevice.signIn('B', account, clock);

  final org = await a.organizations.create(
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
  expect(await a.outbox(), isEmpty, reason: '$a outbox');
  expect(await b.outbox(), isEmpty, reason: '$b outbox');
  expect(await b.allHives(), await a.allHives());
  expect(await b.allLocationEntries(), await a.allLocationEntries());
  expect(await b.allInspections(), await a.allInspections());
}

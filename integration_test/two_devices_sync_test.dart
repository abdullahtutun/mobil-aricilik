// İki telefon, tek hesap ve tek işletme: yerel sunucuya karşı senkron.
// Aynı senaryolar iki backend'de de koşar; yalnız PocketBase'e özgü olanlar
// (Supabase'den geçiş, token yenileme) Supabase'de atlanır.
//
// PocketBase (README "İki cihaz testleri"):
//   cd server && go run . serve --http 127.0.0.1:8090 --dir <boş klasör>
//   server/ops/test_users.sh http://127.0.0.1:8090
//   flutter test integration_test/two_devices_sync_test.dart --flavor dev \
//     -d <iOS simülatörü> --dart-define=BACKEND=pocketbase \
//     --dart-define=PB_URL=http://127.0.0.1:8090 \
//     --dart-define-from-file=build/p91_accounts.json
//
// Supabase (`supabase start` açıkken): aynı komut, yalnız
// `--dart-define=BACKEND=supabase`.
//
// Her test yeni bir hesap ve işletme açar; testler birbirini etkilemez.

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/sync/sync_screen.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/supabase_sync_transport.dart';
import 'package:mobil_arici/core/sync/sync_backend.dart';
import 'package:mobil_arici/core/sync/sync_indicator.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:supabase_flutter/supabase_flutter.dart'
    show AuthClientOptions, SupabaseClient;

import '../test/helpers/fake_auth_service.dart';
import '../test/helpers/fake_sync_service.dart';
import 'helpers/test_device.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  // Her cihazın kendi bellek içi DB'si var; drift aynı sınıfın ikinci
  // örneğini paylaşılan bağlantı sanıp uyarıyor.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;

  late TestDevice a;
  late TestDevice b;
  late TestAccount account;
  late String orgId;
  late String apiaryId;
  late TestClock clock;

  setUp(() async {
    final devices = await openTwoDevices();
    (:a, :b, :account, :orgId, :apiaryId, :clock) = devices;
  });

  void goOffline() {
    a.network.online = false;
    b.network.online = false;
  }

  void reconnect() {
    a.network.reconnect();
    b.network.reconnect();
  }

  /// İki cihazın da çektiği ortak bir kovan.
  Future<Hive> sharedHive() async {
    final hive = await a.hives.create(
      orgId: orgId,
      number: '101',
      type: HiveType.langstroth,
      apiaryId: apiaryId,
    );
    await settle([a, b]);
    return hive;
  }

  test(
    'çevrimdışı eklenen farklı kovanlar eşitlenince iki cihazda da var',
    () async {
      goOffline();
      await a.hives.createMany(
        orgId: orgId,
        apiaryId: apiaryId,
        numbers: ['A1', 'A2', 'A3'],
        type: HiveType.langstroth,
      );
      clock.advance(const Duration(minutes: 1));
      await b.hives.createMany(
        orgId: orgId,
        apiaryId: apiaryId,
        numbers: ['B1', 'B2'],
        type: HiveType.dadant,
      );
      expect((await a.syncNow()).status, SyncStatus.retryLater);
      expect((await b.syncNow()).status, SyncStatus.retryLater);
      expect(await a.liveHiveNumbers(), {'A1', 'A2', 'A3'});
      expect(await b.liveHiveNumbers(), {'B1', 'B2'});

      reconnect();
      await settle([a, b]);

      const all = {'A1', 'A2', 'A3', 'B1', 'B2'};
      expect(await a.liveHiveNumbers(), all);
      expect(await b.liveHiveNumbers(), all);
      expect(await a.allLocationEntries(), hasLength(5));
      await expectConverged(a, b);
    },
  );

  /// A ve B'nin eşitlenme sıraları; son yazan kazanır kuralında sonuç
  /// sıraya bağlı değildir. [aRole] ve [bRole] test adında geçer.
  Map<String, Future<void> Function()> syncOrders(String aRole, String bRole) =>
      {
        'önce $aRole eşitlenir': () => settle([a, b]),
        'önce $bRole eşitlenir': () => settle([b, a]),
        'ikisi aynı anda eşitlenir': () async {
          final results = await Future.wait([a.syncNow(), b.syncNow()]);
          for (final result in results) {
            expect(result.status, SyncStatus.done);
          }
          await settle([a, b]);
        },
      };

  group('aynı kovanın durumunu ikisi de değiştirir: son yazan kazanır', () {
    // A önce (eski), B sonra (yeni) yazar. "Son" yazma zamanıdır
    // (updated_at), gönderim sırası değil.
    final orders = syncOrders('eski yazan', 'yeni yazan');
    for (final MapEntry(key: order, value: syncDevices) in orders.entries) {
      test(order, () async {
        final hive = await sharedHive();
        goOffline();
        clock.advance(const Duration(minutes: 1));
        await a.hives.setStatus(hive.id, HiveStatus.dead);
        clock.advance(const Duration(minutes: 1));
        await b.hives.setStatus(hive.id, HiveStatus.sold);

        reconnect();
        await syncDevices();

        for (final device in [a, b]) {
          final synced = await device.hives.findById(hive.id);
          expect(synced?.status, HiveStatus.sold, reason: '$device');
        }
        // Sunucudaki hâl: hiç yazmamış yeni bir telefonun çektiği.
        final fresh = await TestDevice.signIn('C', account, clock);
        expect((await fresh.syncNow()).status, SyncStatus.done);
        expect((await fresh.hives.findById(hive.id))?.status, HiveStatus.sold);
        await expectConverged(a, b);
      });
    }

    test(
      'farklı alanlar değişse de satırın tamamı son yazandan gelir',
      () async {
        final hive = await sharedHive();
        goOffline();
        clock.advance(const Duration(minutes: 1));
        await a.hives.setStatus(hive.id, HiveStatus.dead);
        clock.advance(const Duration(minutes: 1));
        final current = (await b.hives.findById(hive.id))!;
        await b.hives.update(current.copyWith(frameCount: 10));

        reconnect();
        await settle([a, b]);

        final synced = await a.hives.findById(hive.id);
        expect(synced?.frameCount, 10);
        // A'nın durum değişikliği B'nin satırıyla ezildi.
        expect(synced?.status, HiveStatus.active);
        await expectConverged(a, b);
      },
    );
  });

  group('biri siler, diğeri düzenler: son yazan kazanır', () {
    // Silme de bir yazmadır (deleted_at + updated_at) ve satırın tamamını
    // taşır. Silmeden sonraki düzenleme kovanı geri getirir; silmeden
    // önceki düzenleme silmeyle birlikte kaybolur. A siler, B düzenler.
    final orders = syncOrders('silen', 'düzenleyen');
    for (final MapEntry(key: order, value: syncDevices) in orders.entries) {
      test('silmeden sonraki düzenleme kovanı geri getirir ($order)', () async {
        final hive = await sharedHive();
        goOffline();
        clock.advance(const Duration(minutes: 1));
        await a.hives.delete(hive.id);
        clock.advance(const Duration(minutes: 1));
        final edited = await b.hives.setStatus(hive.id, HiveStatus.dead);

        reconnect();
        await syncDevices();

        for (final device in [a, b]) {
          final synced = await device.hives.findById(hive.id);
          expect(synced, isNotNull, reason: '$device');
          expect(synced!.status, HiveStatus.dead, reason: '$device');
          expect(synced.updatedAt, edited.updatedAt, reason: '$device');
        }
        await expectConverged(a, b);
      });

      test('düzenlemeden sonraki silme kalır ($order)', () async {
        final hive = await sharedHive();
        goOffline();
        clock.advance(const Duration(minutes: 1));
        await b.hives.setStatus(hive.id, HiveStatus.dead);
        clock.advance(const Duration(minutes: 1));
        await a.hives.delete(hive.id);

        reconnect();
        await syncDevices();

        for (final device in [a, b]) {
          expect(await device.hives.findById(hive.id), isNull);
          final row = (await device.allHives()).singleWhere(
            (h) => h.id == hive.id,
          );
          expect(row.deletedAt, isNotNull, reason: '$device');
          // Silme A'nın satırını taşır; B'nin düzenlemesi kaybolur.
          expect(row.status, HiveStatus.active, reason: '$device');
        }
        await expectConverged(a, b);
      });
    }
  });

  group('senkron ortasında bağlantı kesilir: veri kaybı yok', () {
    test('ikinci paketin yanıtı yolda kaybolursa yeniden gönderim çift kayıt '
        'yazmaz', () async {
      // 75 kovan + 75 geçmiş kaydı = 150 outbox kaydı: 100 + 50'lik iki paket.
      goOffline();
      final numbers = [for (var i = 1; i <= 75; i++) '$i'];
      await a.hives.createMany(
        orgId: orgId,
        apiaryId: apiaryId,
        numbers: numbers,
        type: HiveType.langstroth,
      );
      expect(await a.outbox(), hasLength(150));

      reconnect();
      var pushes = 0;
      a.network.cutAfter = (request) => pushRequest()(request) && ++pushes == 2;
      final cut = await a.syncNow();
      expect(cut.status, SyncStatus.retryLater);
      expect(cut.pushed, 100);
      // İkinci paket sunucuya yazıldı ama A bunu bilmiyor; kayıtlar
      // outbox'ta kalır.
      final pending = await a.outbox();
      expect(pending, hasLength(50));
      expect(pending.every((entry) => entry.attempts > 0), isTrue);
      expect(pending.every((entry) => entry.lastError == null), isTrue);

      // B sunucudaki hâli görür: 75 kovanın hepsi orada.
      expect((await b.syncNow()).status, SyncStatus.done);
      expect(await b.liveHiveNumbers(), hasLength(75));

      reconnect();
      final resent = await a.syncNow();
      expect(resent.status, SyncStatus.done);
      expect(resent.pushed, 50);
      expect(resent.rejected, 0);

      await settle([a, b]);
      expect(await a.liveHiveNumbers(), numbers.toSet());
      expect(await b.allHives(), hasLength(75));
      expect(await b.allLocationEntries(), hasLength(75));
      await expectConverged(a, b);
    });

    test('çekme yarıda kesilirse inen tablolar korunur, sonraki tur kalanı '
        'indirir', () async {
      final yeni = await a.apiaries.create(orgId: orgId, name: 'Ova');
      await a.hives.createMany(
        orgId: orgId,
        apiaryId: yeni.id,
        numbers: ['1', '2', '3'],
        type: HiveType.local,
      );
      expect((await a.syncNow()).status, SyncStatus.done);

      b.network.cutBefore = pullRequest(table: 'hives');
      expect((await b.syncNow()).status, SyncStatus.retryLater);
      expect(await b.apiaries.findById(yeni.id), isNotNull);
      expect(await b.liveHiveNumbers(), isEmpty);

      // Bağlantı yokken yazılan kayıt da kaybolmaz.
      final offline = await b.hives.create(
        orgId: orgId,
        number: '4',
        type: HiveType.local,
        apiaryId: yeni.id,
      );

      b.network.reconnect();
      await settle([b, a]);
      expect(await b.liveHiveNumbers(), {'1', '2', '3', '4'});
      expect(await a.hives.findById(offline.id), isNotNull);
      await expectConverged(a, b);
    });

    test('yeni telefonun ilk çekmesi sayfalar arasında kesilirse kaldığı '
        'sayfadan sürer', () async {
      // 600 kovan + 600 geçmiş kaydı 1200 sunucu numarası alır; kovanlar
      // iki sayfada iner (sayfa 500). Supabase'de ilk kovanlar geriye bakma
      // payının (1000 numara) gerisinde kalır; PocketBase'de pay yok (K-7).
      final numbers = [for (var i = 1; i <= 600; i++) '$i'];
      await a.hives.createMany(
        orgId: orgId,
        apiaryId: apiaryId,
        numbers: numbers,
        type: HiveType.langstroth,
      );
      expect((await a.syncNow()).status, SyncStatus.done);

      final c = await TestDevice.signIn('C', account, clock);
      var hivePages = 0;
      c.network.cutBefore = (request) =>
          pullRequest(table: 'hives')(request) && ++hivePages == 2;
      expect((await c.syncNow()).status, SyncStatus.retryLater);
      expect(await c.allHives(), hasLength(SyncService.pullPageSize));
      expect(await c.cursor('hives'), greaterThan(0));
      expect(await c.fullPullDone(), isFalse);

      c.network.reconnect();
      expect((await c.syncNow()).status, SyncStatus.done);
      expect(await c.liveHiveNumbers(), numbers.toSet());
      expect(await c.fullPullDone(), isTrue);
      await settle([a, c]);
      await expectConverged(a, c);
    });

    test(
      "gönderim sunucuya ulaşmadan kesilirse kayıtlar outbox'ta kalır",
      () async {
        final hive = await a.hives.create(
          orgId: orgId,
          number: '7',
          type: HiveType.langstroth,
          apiaryId: apiaryId,
        );
        a.network.cutBefore = pushRequest();
        expect((await a.syncNow()).status, SyncStatus.retryLater);
        expect(await a.outbox(), hasLength(2));

        expect((await b.syncNow()).status, SyncStatus.done);
        expect(await b.hives.findById(hive.id), isNull);

        a.network.reconnect();
        await settle([a, b]);
        expect(await b.hives.findById(hive.id), isNotNull);
        await expectConverged(a, b);
      },
    );
  });

  test('aynı kovana iki cihazdan çevrimdışı muayene iki ayrı kayıt olur '
      '(olay kaydı, son yazan kazanır değil)', () async {
    final hive = await sharedHive();
    goOffline();
    final fromA = await a.inspections.add(
      orgId: orgId,
      hiveId: hive.id,
      apiaryId: apiaryId,
      values: const InspectionValues(beeFrames: 8),
    );
    clock.advance(const Duration(minutes: 1));
    final fromB = await b.inspections.add(
      orgId: orgId,
      hiveId: hive.id,
      apiaryId: apiaryId,
      values: const InspectionValues(beeFrames: 6),
    );

    reconnect();
    await settle([a, b]);

    for (final device in [a, b]) {
      final inspections = await device.allInspections();
      expect(
        {for (final i in inspections) i.id: i.beeFrames},
        {fromA.id: 8, fromB.id: 6},
        reason: '$device',
      );
    }
    await expectConverged(a, b);
  });

  test('imleç yalnız yeni satırlarla ilerler; boş tur imleci '
      'oynatmaz', () async {
    final before = await b.cursor('hives');
    await a.hives.createMany(
      orgId: orgId,
      apiaryId: apiaryId,
      numbers: ['1', '2'],
      type: HiveType.langstroth,
    );
    expect((await a.syncNow()).status, SyncStatus.done);

    final pulled = await b.syncNow();
    expect(pulled.status, SyncStatus.done);
    expect(await b.liveHiveNumbers(), {'1', '2'});
    final after = await b.cursor('hives');
    expect(after, greaterThan(before));

    final idle = await b.syncNow();
    expect(idle.status, SyncStatus.done);
    expect(await b.cursor('hives'), after);
    // Supabase'de geriye bakma payı aynı satırları yeniden indirir.
    if (testBackend == Backend.pocketbase) expect(idle.pulled, 0);
  });

  test("Supabase'de yazılıp outbox'ta kalan kayıt backend değişince "
      "PocketBase'e gider (P7.3)", () async {
    // Uygulama Supabase'e bağlıyken çevrimdışı yazılmış kayıt.
    final c = await TestDevice.signIn('C', account, clock);
    await resetCursorsIfBackendChanged(
      c.db,
      syncBackendIdentity(Flavor.dev, Backend.supabase),
    );
    final offline = TestNetwork()..online = false;
    final oldClient = SupabaseClient(
      supabaseUrl,
      supabaseKey,
      httpClient: offline,
      authOptions: const AuthClientOptions(autoRefreshToken: false),
    );
    addTearDown(() async {
      await oldClient.dispose();
      offline.close();
    });
    final hive = await c.hives.create(
      orgId: orgId,
      number: 'S1',
      type: HiveType.langstroth,
      apiaryId: apiaryId,
    );
    final viaSupabase = await c
        .syncWith(SupabaseSyncTransport(oldClient))
        .sync();
    expect(viaSupabase.status, isNot(SyncStatus.done));
    expect(await c.outbox(), hasLength(2));

    // Yeni sürüm PocketBase'e bağlanır: imleçler sıfırlanır, outbox kalır.
    expect(
      await resetCursorsIfBackendChanged(
        c.db,
        syncBackendIdentity(Flavor.dev, Backend.pocketbase),
      ),
      isTrue,
    );
    final viaPocketBase = await c.syncNow();
    expect(viaPocketBase.status, SyncStatus.done);
    expect(viaPocketBase.pushed, 2);
    expect(await c.fullPullDone(), isTrue);

    await settle([a, c]);
    expect(await a.hives.findById(hive.id), isNotNull);
    await expectConverged(a, c);
  }, skip: testBackend == Backend.pocketbase ? false : 'yalnız PocketBase');

  test(
    'süresi dolmuş oturumla çevrimdışı açılış: arayüz kilitlenmez, ağ '
    'gelince sunucu reddeder, kayıtlar yeniden girişte gider (K-6)',
    () async {
      // Uzun süre çevrimdışı kalmış telefon: token'ın süresi dolmuş.
      final e = await TestDevice.signIn(
        'E',
        account,
        clock,
        expiredSession: true,
      );
      e.network.online = false;
      expect(e.signedIn, isTrue);
      final hive = await e.hives.create(
        orgId: orgId,
        number: 'E1',
        type: HiveType.langstroth,
        apiaryId: apiaryId,
      );
      // Yenileme ağ hatası alır; ağ hatası oturumu kapatmaz.
      expect((await e.syncNow()).status, SyncStatus.retryLater);
      expect(e.signedIn, isTrue);
      expect(await e.outbox(), hasLength(2));

      // Ağ gelir: yenileme 401 alır ve oturum kapanır; kayıtlar kalır.
      e.network.reconnect();
      expect((await e.syncNow()).status, SyncStatus.failed);
      expect(e.signedIn, isFalse);
      expect(await e.outbox(), hasLength(2));

      // Yeniden giriş: bekleyen kayıtlar gider.
      e.restoreSession();
      final resent = await e.syncNow();
      expect(resent.status, SyncStatus.done);
      expect(resent.pushed, 2);

      // Geçerli oturumun yenilemesi oturumu açık tutar. (Test token'ı
      // superuser'ın impersonate token'ı; sunucu onu yenilemeden aynen
      // döner, yeni token üretimi auth_service testlerinde.)
      await a.auth.refreshSession();
      expect(a.signedIn, isTrue);

      await settle([a, e]);
      expect(await a.hives.findById(hive.id), isNotNull);
      await expectConverged(a, e);
    },
    skip: testBackend == Backend.pocketbase ? false : 'yalnız PocketBase',
  );

  testWidgets('aynı etiket iki kovana verilirse ikincisi conflict ile '
      'reddedilir ve senkron ekranında görünür', (tester) async {
    goOffline();
    final tagged = await a.hives.create(
      orgId: orgId,
      number: '201',
      type: HiveType.langstroth,
      apiaryId: apiaryId,
      tagCode: 'QR-201',
    );
    clock.advance(const Duration(minutes: 1));
    final clash = await b.hives.create(
      orgId: orgId,
      number: '202',
      type: HiveType.langstroth,
      apiaryId: apiaryId,
      tagCode: 'QR-201',
    );
    reconnect();
    expect((await a.syncNow()).status, SyncStatus.done);
    final refused = await b.syncNow();
    expect(refused.status, SyncStatus.done);
    // Kovan çakışmayla reddedilir; sunucuda olmayan kovana bağlı ilk konum
    // kaydı da bağ bulamaz.
    expect(refused.rejected, 2);
    final pending = await b.outbox();
    expect(
      {
        for (final entry in pending)
          entry.recordTable: syncRejectionOf(entry.lastError!),
      },
      {
        'hives': SyncRejection.conflict,
        'hive_location_history': SyncRejection.missingReference,
      },
    );
    expect(
      pending.singleWhere((entry) => entry.recordTable == 'hives').recordId,
      clash.id,
    );
    expect((await b.hives.findById(tagged.id))?.tagCode, 'QR-201');
    expect(await a.hives.findById(clash.id), isNull);

    final container = ProviderContainer.test(
      overrides: signedIn(db: b.db, sync: FakeSyncService()),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    container.read(routerProvider).go(AppRoutes.sync);
    await tester.pumpAndSettle();

    final l10n = AppLocalizations.of(tester.element(find.byType(SyncScreen)));
    expect(find.text(l10n.syncRejectedMessage), findsOneWidget);
    for (final text in [
      l10n.syncRejectionConflict,
      l10n.syncRejectionMissingReference,
    ]) {
      final reason = find.textContaining(text);
      await tester.scrollUntilVisible(reason, 200);
      expect(reason, findsOneWidget, reason: text);
    }
  });

  test('viewer yazması forbidden ile reddedilir, sahibe ulaşmaz', () async {
    final invite = await a.team.createInvite(
      orgId: orgId,
      role: MembershipRole.viewer,
    );
    final viewer = await TestDevice.signIn('V', await newAccount(), clock);
    expect(await viewer.team.redeem(invite.code), orgId);
    expect((await viewer.syncNow()).status, SyncStatus.done);
    expect(await viewer.apiaries.findById(apiaryId), isNotNull);

    final written = await viewer.hives.create(
      orgId: orgId,
      number: 'V1',
      type: HiveType.langstroth,
      apiaryId: apiaryId,
    );
    final result = await viewer.syncNow();
    expect(result.status, SyncStatus.done);
    expect(result.rejected, 2);
    for (final entry in await viewer.outbox()) {
      expect(
        syncRejectionOf(entry.lastError!),
        SyncRejection.forbidden,
        reason: '${entry.recordTable}: ${entry.lastError}',
      );
    }

    await settle([a]);
    expect(await a.hives.findById(written.id), isNull);
  });
}

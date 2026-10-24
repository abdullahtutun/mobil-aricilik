// İki telefon, tek hesap ve tek işletme: yerel Supabase'e karşı senkron.
//
// Çalıştırma (yerel Supabase açıkken, `supabase start`):
//   flutter test integration_test --flavor dev -d <iOS simülatörü>
//
// Her test yeni bir hesap ve işletme açar; testler birbirini etkilemez.

import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

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
        final server = await a.client
            .from('hives')
            .select('status')
            .eq('id', hive.id)
            .single();
        expect(server['status'], 'sold');
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
      a.network.cutAfter = (request) =>
          rpc('sync_push')(request) && ++pushes == 2;
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

      b.network.cutBefore = rpc('sync_pull', table: 'hives');
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
      // 600 kovan + 600 geçmiş kaydı 1200 sunucu numarası alır. İlk kovanlar
      // geriye bakma payının (1000 numara) gerisinde kalır ve kovanlar iki
      // sayfada iner.
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
          rpc('sync_pull', table: 'hives')(request) && ++hivePages == 2;
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
        a.network.cutBefore = rpc('sync_push');
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
}

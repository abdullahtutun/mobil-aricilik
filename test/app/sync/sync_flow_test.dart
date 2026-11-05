import 'dart:async';

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/app_navigation_bar.dart';
import 'package:mobil_arici/app/sync/initial_sync_screen.dart';
import 'package:mobil_arici/app/sync/sync_overdue_card.dart';
import 'package:mobil_arici/app/sync/sync_screen.dart';
import 'package:mobil_arici/app/sync/sync_status_button.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_email_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';

import '../../helpers/fake_auth_service.dart';
import '../../helpers/fake_sync_service.dart';
import '../../helpers/test_database.dart';

void main() {
  late AppDatabase db;
  late FakeSyncService sync;

  setUp(() {
    db = openTestDatabase();
    sync = FakeSyncService();
  });

  Future<ProviderContainer> open(
    WidgetTester tester, {
    bool fullPullDone = true,
  }) async {
    final container = ProviderContainer.test(
      overrides: signedIn(db: db, sync: sync, fullPullDone: fullPullDone),
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(container: container, child: const App()),
    );
    await tester.pumpAndSettle();
    return container;
  }

  /// Bugün'ün başlığındaki senkron hapında [text].
  Finder inAppBar(String text) => find.descendant(
    of: find.byType(SyncStatusButton),
    matching: find.text(text),
  );

  Future<void> tap(WidgetTester tester, Finder finder) async {
    await tester.ensureVisible(finder);
    await tester.pumpAndSettle();
    await tester.tap(finder);
    await tester.pumpAndSettle();
  }

  /// Outbox'a bir arılık kaydı yazar; [rejectedAs] verilirse sunucu onu o
  /// nedenle reddetmiş sayılır. [at] verilirse kayıt o anda yazılmış olur.
  Future<void> writeApiary({String? rejectedAs, DateTime? at}) async {
    await ApiaryRepository(
      db,
      clock: () => at ?? DateTime.now(),
    ).create(orgId: 'org-1', name: 'Yayla');
    if (rejectedAs != null) {
      await db
          .update(db.outbox)
          .write(OutboxCompanion(lastError: Value(rejectedAs)));
    }
  }

  BigButton syncNowButton(WidgetTester tester) =>
      tester.widget<BigButton>(find.byType(BigButton));

  group("Bugün'deki senkron hapı", () {
    testWidgets("yalnız Bugün'de görünür (docs/design); dokununca ayrıntı "
        'açılır, geri tuşu sekmeye döner', (tester) async {
      await open(tester);

      for (final tab in ['Apiaries', 'Tasks', 'More', 'Today']) {
        await tap(
          tester,
          find.descendant(
            of: find.byType(AppNavigationBar),
            matching: find.text(tab),
          ),
        );
        expect(
          inAppBar('Synced'),
          tab == 'Today' ? findsOneWidget : findsNothing,
          reason: tab,
        );
      }
      expect(find.bySemanticsLabel('Sync: Synced'), findsOneWidget);

      await tap(tester, inAppBar('Synced'));
      expect(find.byType(SyncScreen), findsOneWidget);
      expect(
        find.text('Every record on this phone has reached the server.'),
        findsOneWidget,
      );
      expect(find.byType(AppNavigationBar), findsNothing);

      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('gönderilmeyi bekleyen kayıtlar sayılır', (tester) async {
      await writeApiary();
      await writeApiary();
      await open(tester);

      expect(inAppBar('2 pending'), findsOneWidget);
      await tap(tester, inAppBar('2 pending'));
      expect(find.text('2 records are waiting to be sent.'), findsOneWidget);
    });

    testWidgets('sunucunun reddettiği kayıt hata olarak görünür; ayrıntıda '
        'türü ve nedeniyle listelenir', (tester) async {
      await writeApiary(rejectedAs: 'conflict: duplicate key');
      await open(tester);

      expect(inAppBar('Error'), findsOneWidget);
      expect(find.bySemanticsLabel('Sync: Error'), findsOneWidget);
      await tap(tester, inAppBar('Error'));

      expect(find.text("COULDN'T BE SENT (1)"), findsOneWidget);
      expect(find.text('Apiary'), findsOneWidget);
      expect(
        find.textContaining(
          'Conflicts with another record (e.g. the same label) · ',
        ),
        findsOneWidget,
      );
      // Bekleyen kayıt yok ama hepsi eşitlendi de denmez.
      expect(
        find.text('Every record on this phone has reached the server.'),
        findsNothing,
      );
    });
  });

  group('Senkron ekranı', () {
    testWidgets('Şimdi eşitle turu başlatır; sürerken buton pasif, bitince '
        'son eşitleme yazar', (tester) async {
      final container = await open(tester);
      container.read(routerProvider).go(AppRoutes.sync);
      await tester.pumpAndSettle();
      expect(find.textContaining('Last synced'), findsNothing);

      sync.gate = Completer<void>();
      await tester.tap(find.widgetWithText(BigButton, 'Sync now'));
      await tester.pump();
      expect(find.text('Syncing…'), findsOneWidget);
      expect(syncNowButton(tester).onPressed, isNull);

      sync.gate!.complete();
      await tester.pumpAndSettle();
      expect(find.text('Sync now'), findsOneWidget);
      expect(syncNowButton(tester).onPressed, isNotNull);
      expect(find.textContaining('Last synced '), findsOneWidget);
      expect(sync.syncCount, 1);
    });

    final problems = <SyncStatus, String>{
      SyncStatus.retryLater:
          "Couldn't reach the server. Sync will try again when you're back "
          'online.',
      SyncStatus.failed: "Sync couldn't finish. Try again a little later.",
      SyncStatus.upgradeRequired:
          'This version can no longer sync. Update the app.',
    };
    for (final MapEntry(key: status, value: message) in problems.entries) {
      testWidgets('tur bitemezse nedenini yazar: ${status.name}', (
        tester,
      ) async {
        final container = await open(tester);
        container.read(routerProvider).go(AppRoutes.sync);
        await tester.pumpAndSettle();

        sync.result = SyncResult(status: status);
        await tap(tester, find.widgetWithText(BigButton, 'Sync now'));

        expect(find.text(message), findsOneWidget);
        expect(find.textContaining('Last synced'), findsNothing);
        // Ağ olmaması hata değil; diğerleri kullanıcıya hata olarak görünür.
        final indicator = status == SyncStatus.retryLater ? 'Synced' : 'Error';
        expect(
          find.descendant(
            of: find.byType(SyncScreen),
            matching: find.text(indicator),
          ),
          findsOneWidget,
        );
      });
    }

    testWidgets('Türkçe metinler', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await writeApiary(rejectedAs: 'forbidden: RLS');
      await writeApiary();
      await open(tester);

      expect(inAppBar('Hata'), findsOneWidget);
      await tap(tester, inAppBar('Hata'));

      expect(find.text('Eşitleme'), findsOneWidget);
      expect(find.text('1 kayıt gönderilmeyi bekliyor.'), findsOneWidget);
      expect(find.text('GÖNDERİLMEYİ BEKLEYEN · 1'), findsOneWidget);
      expect(find.text('GÖNDERİLEMEYEN KAYITLAR (1)'), findsOneWidget);
      // Bekleyenlerde ve reddedilenlerde birer kez.
      expect(find.text('Arılık'), findsNWidgets(2));
      expect(
        find.textContaining('Bu kaydı değiştirme yetkin yok · '),
        findsOneWidget,
      );
      expect(find.text('Şimdi eşitle'), findsOneWidget);
    });
  });

  group('Yedek güvencesi', () {
    testWidgets('bekleyen kayıtlar türe göre, çoktan aza sayılır', (
      tester,
    ) async {
      await writeApiary();
      await writeApiary();
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              recordTable: 'tasks',
              recordId: 'task-1',
              operation: OutboxOperation.upsert,
              payload: const {'id': 'task-1'},
              createdAt: DateTime.now(),
            ),
          );
      final container = await open(tester);
      container.read(routerProvider).go(AppRoutes.sync);
      await tester.pumpAndSettle();

      expect(find.text('WAITING TO BE SENT · 3'), findsOneWidget);
      final apiaryRow = find.widgetWithText(ListRow, 'Apiary');
      final taskRow = find.widgetWithText(ListRow, 'Task');
      expect(
        find.descendant(of: apiaryRow, matching: find.text('2')),
        findsOneWidget,
      );
      expect(
        find.descendant(of: taskRow, matching: find.text('1')),
        findsOneWidget,
      );
      expect(
        tester.getTopLeft(apiaryRow).dy,
        lessThan(tester.getTopLeft(taskRow).dy),
      );
    });

    testWidgets('son eşitleme kalıcı kayıttan: kaç gün önce ve ne zaman; '
        'arka plan turu da yazar', (tester) async {
      await LocalSettingsRepository(db)
          .setLastSyncedAt(DateTime.now().subtract(const Duration(days: 3)));
      final container = await open(tester);
      container.read(routerProvider).go(AppRoutes.sync);
      await tester.pumpAndSettle();

      expect(find.textContaining('Last synced 3 days ago · '), findsOneWidget);
    });

    testWidgets('kayıt 3 günden uzun süredir gönderilemediyse Bugün uyarır; '
        'dokununca senkron ekranı açılır, orada da uyarı var', (tester) async {
      await writeApiary(at: DateTime.now().subtract(const Duration(days: 4)));
      await writeApiary();
      await open(tester);

      expect(find.text('Not backed up for 3+ days'), findsOneWidget);
      expect(
        find.text(
          "2 records are only on this phone. If the phone is lost, they're "
          'lost too. Connect to the internet and sync.',
        ),
        findsOneWidget,
      );
      await tap(tester, find.byType(SyncOverdueCard));

      expect(find.byType(SyncScreen), findsOneWidget);
      expect(find.byType(SyncOverdueCard), findsOneWidget);
    });

    testWidgets('3 günden yeni bekleyen kayıt uyarı göstermez', (tester) async {
      await writeApiary(
        at: DateTime.now().subtract(const Duration(days: 2, hours: 23)),
      );
      final container = await open(tester);
      expect(find.byType(SyncOverdueCard), findsNothing);

      container.read(routerProvider).go(AppRoutes.sync);
      await tester.pumpAndSettle();
      expect(find.byType(SyncOverdueCard), findsNothing);
    });

    testWidgets('Türkçe uyarı ve son eşitleme', (tester) async {
      tester.platformDispatcher.localesTestValue = const [Locale('tr')];
      addTearDown(tester.platformDispatcher.clearLocalesTestValue);
      await LocalSettingsRepository(db)
          .setLastSyncedAt(DateTime.now().subtract(const Duration(days: 1)));
      await writeApiary(at: DateTime.now().subtract(const Duration(days: 5)));
      await open(tester);

      expect(find.text('3 günden uzun süredir yedeklenmedi'), findsOneWidget);
      expect(
        find.text(
          '1 kayıt yalnız bu telefonda. Telefon kaybolursa bunlar da '
          'kaybolur. İnternete bağlanıp eşitle.',
        ),
        findsOneWidget,
      );
      await tap(tester, find.byType(SyncOverdueCard));
      expect(find.textContaining('Son eşitleme dün · '), findsOneWidget);
    });
  });

  group('İlk tam çekme', () {
    /// Çekme bitince işareti yazar; router Bugün'e geçer.
    void markFullPullOnDone() => sync.onDone = () => db
        .into(db.syncState)
        .insert(SyncStateCompanion.insert(recordTable: fullPullMarker));

    testWidgets('kayıtlar inene kadar sekmeler açılmaz, ilerleme görünür; '
        'bitince Bugün açılır', (tester) async {
      markFullPullOnDone();
      sync
        ..gate = Completer<void>()
        ..progress = const [
          SyncProgress(tablesDone: 3, tableCount: 6, rowsPulled: 1234),
        ];
      await open(tester, fullPullDone: false);

      expect(find.byType(InitialSyncScreen), findsOneWidget);
      expect(find.byType(AppNavigationBar), findsNothing);
      expect(find.text('Downloading your records'), findsOneWidget);
      expect(find.text('1,234 records downloaded'), findsOneWidget);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .value,
        0.5,
      );
      expect(sync.syncCount, 1);

      sync.gate!.complete();
      await tester.pumpAndSettle();
      expect(find.byType(TodayScreen), findsOneWidget);
      expect(find.byType(InitialSyncScreen), findsNothing);
    });

    testWidgets('tamamlanamazsa nedenini yazar; yeniden dene turu '
        'tekrarlar', (tester) async {
      sync.result = const SyncResult(status: SyncStatus.retryLater);
      await open(tester, fullPullDone: false);

      expect(find.text("Download couldn't finish"), findsOneWidget);
      expect(
        find.text(
          "Couldn't reach the server. Sync will try again when you're back "
          'online.',
        ),
        findsOneWidget,
      );

      markFullPullOnDone();
      sync.result = const SyncResult(status: SyncStatus.done);
      await tap(tester, find.widgetWithText(BigButton, 'Try again'));

      expect(find.byType(TodayScreen), findsOneWidget);
      expect(sync.syncCount, 2);
    });

    testWidgets('ilk çekme ekranından çıkış yapılabilir', (tester) async {
      sync.result = const SyncResult(status: SyncStatus.failed);
      await open(tester, fullPullDone: false);

      await tap(tester, find.byTooltip('Sign out'));

      expect(find.byType(SignInEmailScreen), findsOneWidget);
    });

    testWidgets('bu cihazda tam çekme bittiyse ekran açılmaz', (tester) async {
      await db
          .into(db.syncState)
          .insert(SyncStateCompanion.insert(recordTable: fullPullMarker));

      await open(tester, fullPullDone: false);

      expect(find.byType(TodayScreen), findsOneWidget);
    });
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    // Önce reddedilen: işaretleme o anki bütün outbox'a uygulanır.
    await writeApiary(rejectedAs: 'missing_reference: apiary');
    final old = DateTime.now().subtract(const Duration(days: 4));
    for (var i = 0; i < 12; i++) {
      await writeApiary(at: old);
    }
    sync
      ..gate = Completer<void>()
      ..progress = const [
        SyncProgress(tablesDone: 1, tableCount: 6, rowsPulled: 123456),
      ];
    final container = await open(tester, fullPullDone: false);

    for (final glove in [false, true]) {
      container.read(appearanceProvider.notifier).setGloveMode(enabled: glove);
      await tester.pump();
      expect(find.byType(InitialSyncScreen), findsOneWidget);
      expect(tester.takeException(), isNull);
    }

    sync.result = const SyncResult(status: SyncStatus.failed);
    sync.gate!.complete();
    await tester.pumpAndSettle();
    expect(find.text("Download couldn't finish"), findsOneWidget);
    expect(tester.takeException(), isNull);

    await db
        .into(db.syncState)
        .insert(SyncStateCompanion.insert(recordTable: fullPullMarker));
    await tester.pumpAndSettle();
    for (final glove in [false, true]) {
      container.read(appearanceProvider.notifier).setGloveMode(enabled: glove);
      container.read(routerProvider).go(AppRoutes.today);
      await tester.pumpAndSettle();
      expect(inAppBar('Error'), findsOneWidget);
      expect(find.byType(SyncOverdueCard), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tap(tester, inAppBar('Error'));
      expect(find.byType(SyncOverdueCard), findsOneWidget);
      await tester.scrollUntilVisible(
        find.textContaining('A record it belongs to is missing on the server'),
        100,
      );
      expect(tester.takeException(), isNull);
      await tester.pageBack();
      await tester.pumpAndSettle();
    }
  });
}

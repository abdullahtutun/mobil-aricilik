import 'package:drift/drift.dart' show Variable;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

/// Uygulamayı Türkçe açar ve Ekip ekranına gider. Kullanıcı ([testUser])
/// [role] rolünde; ekipte bir işçi ile bir danışman daha var.
Future<({ProviderContainer container, FakeTeamService team, AppDatabase db})>
_openTeam(
  WidgetTester tester, {
  MembershipRole? role = MembershipRole.owner,
  bool withOthers = true,
  Future<void> Function(AppDatabase db)? seed,
}) async {
  final db = openTestDatabase();
  if (role != null) {
    await addMember(db, userId: testUser.id, role: role);
  }
  if (withOthers) {
    await addMember(db, userId: 'worker-1', role: MembershipRole.worker);
    await addMember(db, userId: 'viewer-1', role: MembershipRole.viewer);
  }
  if (seed != null) await seed(db);
  final team = FakeTeamService(
    db: db,
    emails: {'worker-1': 'mustafa@example.com', 'viewer-1': 'can@example.com'},
  );
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db),
      teamServiceProvider.overrideWithValue(team),
    ],
  );
  container.read(languageProvider.notifier).language = AppLanguage.turkish;
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(AppRoutes.team);
  await tester.pumpAndSettle();
  return (container: container, team: team, db: db);
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Üye listesindeki metin; davet kartındaki aynı yazıdan ayırır.
Finder _inList(String text) =>
    find.descendant(of: find.byType(ListGroup), matching: find.text(text));

Future<List<MembershipRow>> _rows(AppDatabase db) =>
    db.select(db.memberships).get();

void main() {
  group('üye listesi', () {
    testWidgets('üyeleri e-posta ve rolle gösterir, kendin en üstte', (
      tester,
    ) async {
      await _openTeam(tester);

      expect(find.text('Ekip'), findsWidgets);
      expect(find.text('ari@example.com (sen)'), findsOneWidget);
      expect(find.text('mustafa@example.com'), findsOneWidget);
      expect(find.text('can@example.com'), findsOneWidget);
      expect(_inList('Sahip'), findsOneWidget);
      expect(_inList('İşçi'), findsOneWidget);
      // Danışman rolü satırda da "Sadece okuma" diye yazar.
      expect(_inList('Danışman'), findsOneWidget);
      expect(find.text('Sadece okuma'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('ari@example.com (sen)')).dy,
        lessThan(tester.getTopLeft(find.text('mustafa@example.com')).dy),
      );
    });

    testWidgets('e-postalar alınamazsa (çevrimdışı) liste yine çizilir', (
      tester,
    ) async {
      final db = openTestDatabase();
      await addMember(db, userId: testUser.id, role: MembershipRole.owner);
      await addMember(db, userId: 'worker-1', role: MembershipRole.worker);
      final team = FakeTeamService(db: db)..failure = TeamFailure.network;
      final container = ProviderContainer.test(
        overrides: [
          ...signedIn(db: db),
          teamServiceProvider.overrideWithValue(team),
        ],
      );
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go(AppRoutes.team);
      await tester.pumpAndSettle();

      expect(find.text('ari@example.com (sen)'), findsOneWidget);
      expect(find.text('Ekip üyesi'), findsOneWidget);
      expect(_inList('İşçi'), findsOneWidget);
    });

    testWidgets('Daha fazla ekranından açılır', (tester) async {
      final db = openTestDatabase();
      final container = ProviderContainer.test(
        overrides: [
          ...signedIn(db: db),
          teamServiceProvider.overrideWithValue(FakeTeamService(db: db)),
        ],
      );
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go(AppRoutes.more);
      await tester.pumpAndSettle();

      await _tap(tester, find.text('Ekip'));

      expect(find.text('Koda sahibim'), findsOneWidget);
    });
  });

  group('rol değiştirme ve çıkarma', () {
    testWidgets('owner üyenin rolünü değiştirir', (tester) async {
      final (:team, :db, container: _) = await _openTeam(tester);

      await _tap(tester, find.text('mustafa@example.com'));
      // Sayfada üç rol ve çıkarma seçeneği.
      expect(find.text('Ekipten çıkar'), findsOneWidget);
      await _tap(tester, find.text('Ortak').last);

      expect(team.roleChanges, [
        (userId: 'worker-1', role: MembershipRole.partner),
      ]);
      expect(
        (await _rows(db)).singleWhere((r) => r.userId == 'worker-1').role,
        MembershipRole.partner,
      );
      expect(find.text('mustafa@example.com artık Ortak.'), findsOneWidget);
    });

    testWidgets('seçili rola yeniden dokunmak bir şey yazmaz', (tester) async {
      final (:team, container: _, db: _) = await _openTeam(tester);

      await _tap(tester, find.text('mustafa@example.com'));
      await _tap(tester, find.text('İşçi').last);

      expect(team.roleChanges, isEmpty);
    });

    testWidgets('owner üyeyi onayla çıkarır; vazgeçerse çıkarmaz', (
      tester,
    ) async {
      final (:team, :db, container: _) = await _openTeam(tester);

      await _tap(tester, find.text('mustafa@example.com'));
      await _tap(tester, find.text('Ekipten çıkar'));
      expect(find.text('Ekipten çıkarılsın mı?'), findsOneWidget);
      await _tap(tester, find.text('Vazgeç'));
      expect(team.removed, isEmpty);

      await _tap(tester, find.text('mustafa@example.com'));
      await _tap(tester, find.text('Ekipten çıkar'));
      await _tap(tester, find.text('Çıkar'));

      expect(team.removed, ['worker-1']);
      expect(
        (await _rows(db)).singleWhere((r) => r.userId == 'worker-1').deletedAt,
        isNotNull,
      );
      // Liste kendiliğinden güncellenir.
      expect(find.text('mustafa@example.com'), findsNothing);
      expect(
        find.text('mustafa@example.com ekipten çıkarıldı.'),
        findsOneWidget,
      );
    });

    testWidgets('çevrimdışıyken anlaşılır mesaj gösterir', (tester) async {
      final (:team, container: _, db: _) = await _openTeam(tester);
      team.failure = TeamFailure.network;

      await _tap(tester, find.text('mustafa@example.com'));
      await _tap(tester, find.text('Ortak').last);

      expect(
        find.text('Bu işlem için internet gerekir. Bağlanınca yeniden dene.'),
        findsOneWidget,
      );
      // Rol değişmedi: üye satırında hâlâ işçi.
      expect(_inList('İşçi'), findsOneWidget);
      expect(_inList('Ortak'), findsNothing);
    });

    testWidgets('owner satırı ve kendi satırı dokunulmaz', (tester) async {
      await _openTeam(tester);

      await _tap(tester, find.text('ari@example.com (sen)'));

      expect(find.text('Ekipten çıkar'), findsNothing);
    });

    for (final role in [
      MembershipRole.partner,
      MembershipRole.worker,
      MembershipRole.viewer,
    ]) {
      testWidgets('${role.name} üyeleri yönetemez', (tester) async {
        await _openTeam(tester, role: role);

        await _tap(tester, find.text('mustafa@example.com'));

        expect(find.text('Ekipten çıkar'), findsNothing);
      });
    }
  });

  group('davet kodu', () {
    testWidgets('owner rol seçip kod üretir ve kopyalar', (tester) async {
      final (:team, container: _, db: _) = await _openTeam(tester);
      String? clipboard;
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (call) async {
          if (call.method == 'Clipboard.setData') {
            clipboard = (call.arguments as Map)['text'] as String?;
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      expect(find.text('Ekibe davet et'), findsOneWidget);
      // Varsayılan rol işçi.
      expect(find.text('İşçi kayıt girer, finansı göremez.'), findsOneWidget);
      expect(find.text('AR7K2Q'), findsNothing);

      await _tap(tester, find.text('Kod üret'));

      expect(team.created, [
        (orgId: testOrganization.id, role: MembershipRole.worker),
      ]);
      expect(find.text('AR7K2Q'), findsOneWidget);
      expect(find.textContaining('48 saat geçerli'), findsOneWidget);

      await _tap(tester, find.text('Kopyala'));
      expect(clipboard, 'AR7K2Q');
      expect(find.text('Kod kopyalandı.'), findsOneWidget);
    });

    testWidgets('rol değişince eski kod silinir, yenisi o rolle üretilir', (
      tester,
    ) async {
      final (:team, container: _, db: _) = await _openTeam(tester);

      await _tap(tester, find.text('Kod üret'));
      expect(find.text('AR7K2Q'), findsOneWidget);

      // Kartta üç rol düğmesi; "Danışman" üye satırında da var.
      await _tap(
        tester,
        find
            .descendant(
              of: find.byType(Material),
              matching: find.widgetWithText(InkWell, 'Danışman'),
            )
            .last,
      );
      expect(find.text('AR7K2Q'), findsNothing);
      expect(find.text('Danışman yalnız okur, kayıt giremez.'), findsOneWidget);

      await _tap(tester, find.text('Kod üret'));
      expect(team.created.last.role, MembershipRole.viewer);
      expect(find.text('BCDEFG'), findsOneWidget);
    });

    testWidgets('çevrimdışıyken kod üretilmez, mesaj çıkar', (tester) async {
      final (:team, container: _, db: _) = await _openTeam(tester);
      team.failure = TeamFailure.network;

      await _tap(tester, find.text('Kod üret'));

      expect(
        find.text('Bu işlem için internet gerekir. Bağlanınca yeniden dene.'),
        findsOneWidget,
      );
      expect(find.text('Kod üret'), findsOneWidget);
    });

    testWidgets('partner davet eder, worker ve viewer davet kartını görmez', (
      tester,
    ) async {
      await _openTeam(tester, role: MembershipRole.partner);
      expect(find.text('Ekibe davet et'), findsOneWidget);
    });

    for (final role in [MembershipRole.worker, MembershipRole.viewer]) {
      testWidgets('${role.name} davet kartını görmez', (tester) async {
        await _openTeam(tester, role: role);

        expect(find.text('Ekibe davet et'), findsNothing);
        expect(find.text('Koda sahibim'), findsOneWidget);
      });
    }
  });

  group('Koda sahibim', () {
    Future<void> openSheet(WidgetTester tester) async {
      await _tap(tester, find.text('Koda sahibim'));
      expect(find.text('Koda katıl'), findsOneWidget);
    }

    Finder codeField() => find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(TextField),
    );

    testWidgets('kod yazılana kadar Katıl pasif; yazınca katılır', (
      tester,
    ) async {
      final (:team, container: _, db: _) = await _openTeam(tester);
      await openSheet(tester);

      bool enabled() =>
          tester
              .widget<BigButton>(find.widgetWithText(BigButton, 'Katıl'))
              .onPressed !=
          null;
      expect(enabled(), isFalse);
      await tester.enterText(codeField(), 'ar7');
      await tester.pump();
      expect(enabled(), isFalse);
      // Boşluk, tire ve küçük harf kabul edilir.
      await tester.enterText(codeField(), 'ar7-k2q');
      await tester.pump();
      expect(enabled(), isTrue);

      await _tap(tester, find.widgetWithText(BigButton, 'Katıl'));

      expect(team.redeemed, ['AR7K2Q']);
      expect(find.text('Koda katıl'), findsNothing);
      expect(find.text('Ekibe katıldın.'), findsOneWidget);
    });

    testWidgets('karışan karakterli kod (0, O, 1, I) geçerli sayılmaz', (
      tester,
    ) async {
      await _openTeam(tester);
      await openSheet(tester);

      await tester.enterText(codeField(), 'AR0K2Q');
      await tester.pump();

      expect(
        tester
            .widget<BigButton>(find.widgetWithText(BigButton, 'Katıl'))
            .onPressed,
        isNull,
      );
    });

    final failures = {
      TeamFailure.invalidCode: 'Kod geçersiz, süresi dolmuş ya da kullanılmış.',
      TeamFailure.alreadyMember: 'Zaten bu ekibin üyesisin.',
      TeamFailure.network:
          'Bu işlem için internet gerekir. Bağlanınca yeniden dene.',
    };
    for (final MapEntry(key: failure, value: message) in failures.entries) {
      testWidgets('${failure.name}: hata sayfada yazılır, sayfa açık kalır', (
        tester,
      ) async {
        final (:team, container: _, db: _) = await _openTeam(tester);
        team.failure = failure;
        await openSheet(tester);

        await tester.enterText(codeField(), 'AR7K2Q');
        await tester.pump();
        await _tap(tester, find.widgetWithText(BigButton, 'Katıl'));

        expect(find.text(message), findsOneWidget);
        expect(find.text('Koda katıl'), findsOneWidget);
        expect(find.text('Ekibe katıldın.'), findsNothing);

        // Kodu düzeltmeye başlayınca hata kalkar.
        await tester.enterText(codeField(), 'AR7K2R');
        await tester.pump();
        expect(find.text(message), findsNothing);
      });
    }
  });

  group('rol kısıtları arayüzde', () {
    Future<ProviderContainer> openApp(
      WidgetTester tester, {
      MembershipRole? role,
      String route = AppRoutes.apiaries,
    }) async {
      final db = openTestDatabase();
      if (role != null) {
        await addMember(db, userId: testUser.id, role: role);
      }
      await ApiaryRepository(db)
          .create(orgId: testOrganization.id, name: 'Kızılçam');
      final container = ProviderContainer.test(
        overrides: [
          ...signedIn(db: db),
          teamServiceProvider.overrideWithValue(FakeTeamService(db: db)),
        ],
      );
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go(route);
      await tester.pumpAndSettle();
      return container;
    }

    // Rol henüz bilinmiyorsa (null) hiçbir şey gizlenmez.
    for (final (role, visible) in [
      (MembershipRole.viewer, false),
      (MembershipRole.worker, true),
      (MembershipRole.partner, true),
      (MembershipRole.owner, true),
      (null, true),
    ]) {
      testWidgets('${role?.name ?? 'rol bilinmiyor'}: arılık ekleme butonu '
          '${visible ? 'görünür' : 'gizli'}', (tester) async {
        await openApp(tester, role: role);

        expect(
          find.byTooltip('Arılık ekle'),
          visible ? findsOneWidget : findsNothing,
        );
      });
    }

    testWidgets('viewer arılık detayında kayıt eylemlerini görmez', (
      tester,
    ) async {
      final db = openTestDatabase();
      await addMember(db, userId: testUser.id, role: MembershipRole.viewer);
      final apiary = await ApiaryRepository(db)
          .create(orgId: testOrganization.id, name: 'Kızılçam');
      final container = ProviderContainer.test(
        overrides: [...signedIn(db: db)],
      );
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();
      container.read(routerProvider).go(AppRoutes.apiary(apiary.id));
      await tester.pumpAndSettle();

      expect(find.text('Kızılçam'), findsWidgets);
      // Kovan yok; boş durum buton önermez.
      expect(find.text('Kovan ekle'), findsNothing);
      expect(find.byIcon(Icons.more_vert_rounded), findsOneWidget);
      await _tap(tester, find.byIcon(Icons.more_vert_rounded));
      expect(find.text('Arılığı düzenle'), findsNothing);
    });

    for (final (role, visible) in [
      (MembershipRole.viewer, false),
      (MembershipRole.worker, true),
    ]) {
      testWidgets('${role.name}: görev ekleme butonu '
          '${visible ? 'görünür' : 'gizli'}', (tester) async {
        await openApp(tester, role: role, route: AppRoutes.tasks);

        expect(
          find.byTooltip('Görev ekle'),
          visible ? findsOneWidget : findsNothing,
        );
      });
    }

    testWidgets('viewer okut düğmesini basılı tutunca hızlı kayıt açılmaz', (
      tester,
    ) async {
      await openApp(tester, role: MembershipRole.viewer);

      await tester.longPress(find.byIcon(Icons.crop_free_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Hızlı kayıt'), findsNothing);
    });

    testWidgets('worker basılı tutunca hızlı kayıt açılır', (tester) async {
      await openApp(tester, role: MembershipRole.worker);

      await tester.longPress(find.byIcon(Icons.crop_free_rounded));
      await tester.pumpAndSettle();
      expect(find.text('Hızlı kayıt'), findsOneWidget);
    });

    // Finans ekranı henüz yok; menü karosu bu provider'a bakacak.
    for (final (role, visible) in [
      (MembershipRole.owner, true),
      (MembershipRole.partner, true),
      (MembershipRole.worker, false),
      (MembershipRole.viewer, false),
      (null, true),
    ]) {
      test('${role?.name ?? 'rol bilinmiyor'}: finans menüsü '
          '${visible ? 'görünür' : 'gizli'}', () async {
        final db = openTestDatabase();
        if (role != null) {
          await addMember(db, userId: testUser.id, role: role);
        }
        final container = ProviderContainer.test(
          overrides: [...signedIn(db: db)],
        );
        await container.read(currentOrganizationProvider.future);
        container.listen(canSeeFinanceProvider, (_, _) {});
        await container.read(organizationMembersProvider.future);

        expect(container.read(canSeeFinanceProvider), visible);
      });
    }
  });

  group('son işlemler', () {
    /// Sunucunun senkronla indirdiği gibi, `createdBy` dolu bir görev.
    Future<void> addTask(
      AppDatabase db, {
      required String createdBy,
      required String title,
    }) async {
      final task = await TaskRepository(db).create(
        orgId: testOrganization.id,
        title: title,
        dueAt: DateTime.utc(2026, 11),
      );
      await db.customUpdate(
        'update tasks set created_by = ? where id = ?',
        variables: [Variable<String>(createdBy), Variable<String>(task.id)],
        updates: {db.tasks},
      );
    }

    testWidgets('kayıt yokken boş metin yazar', (tester) async {
      await _openTeam(tester);
      await tester.scrollUntilVisible(find.text('SON İŞLEMLER'), 200);

      expect(find.text('SON İŞLEMLER'), findsOneWidget);
      expect(find.text('Henüz işlem yok.'), findsOneWidget);
    });

    testWidgets('kişi adı, işlem ve zaman yazılır; kendin "Sen"', (
      tester,
    ) async {
      await _openTeam(
        tester,
        seed: (db) async {
          await addTask(db, createdBy: 'worker-1', title: 'Şurup');
          await addTask(db, createdBy: testUser.id, title: 'Ana arı');
        },
      );
      await tester.scrollUntilVisible(find.text('SON İŞLEMLER'), 200);

      expect(find.text('Henüz işlem yok.'), findsNothing);
      expect(
        find.textContaining('mustafa 1 görev ekledi', findRichText: true),
        findsOneWidget,
      );
      expect(
        find.textContaining('Sen 1 görev ekledi', findRichText: true),
        findsOneWidget,
      );
    });
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    final (:container, team: _, db: _) = await _openTeam(tester);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    await tester.scrollUntilVisible(find.text('Kod üret'), 200);
    await _tap(tester, find.text('Kod üret'));
    expect(tester.takeException(), isNull);
    expect(find.text('AR7K2Q'), findsOneWidget);

    await tester.scrollUntilVisible(find.text('Koda sahibim'), 200);
    await _tap(tester, find.text('Koda sahibim'));
    expect(tester.takeException(), isNull);
    await tester.enterText(
      find.descendant(
        of: find.byType(BottomSheet),
        matching: find.byType(TextField),
      ),
      'AR7K2Q',
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });
}

import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_edit_screen.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_screen.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

import '../../../helpers/business_seed.dart';
import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

typedef _App = ({ProviderContainer container, AppDatabase db});

/// Uygulamayı Türkçe açar; kullanıcı ([testUser]) [role] rolünde, adı
/// "Ahmet Yılmaz". Ekipte bir işçi ve bir danışman daha var. İşletme
/// satırı yerel DB'de ([insertOrganizationRow]).
Future<_App> _open(
  WidgetTester tester, {
  MembershipRole role = MembershipRole.owner,
  OperationType operationType = OperationType.migratory,
  Future<void> Function(AppDatabase db)? seed,
  String location = AppRoutes.business,
}) async {
  final db = openTestDatabase();
  await insertOrganizationRow(db, operationType: operationType);
  await addMember(db, userId: testUser.id, role: role);
  await (db.update(db.memberships)..where((t) => t.userId.equals(testUser.id)))
      .write(const MembershipsCompanion(fullName: Value('Ahmet Yılmaz')));
  await addMember(db, userId: 'worker-1', role: MembershipRole.worker);
  await addMember(db, userId: 'viewer-1', role: MembershipRole.viewer);
  if (seed != null) await seed(db);
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db),
      teamServiceProvider.overrideWithValue(
        FakeTeamService(
          db: db,
          emails: {
            'worker-1': 'mustafa@example.com',
            'viewer-1': 'can@example.com',
          },
        ),
      ),
    ],
  );
  container.read(languageProvider.notifier).language = AppLanguage.turkish;
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await _settle(tester);
  container.read(routerProvider).go(location);
  await _settle(tester);
  return (container: container, db: db);
}

/// Sonsuz animasyon testi 10 dakika asmasın diye süre sınırlı.
Future<void> _settle(WidgetTester tester) => tester.pumpAndSettle(
  const Duration(milliseconds: 100),
  EnginePhase.sendSemanticsUpdate,
  const Duration(seconds: 10),
);

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // Kaydırılan listede henüz kurulmamış olabilir.
  if (finder.evaluate().isEmpty) {
    await tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find.byType(Scrollable).first,
    );
  }
  await tester.ensureVisible(finder);
  await _settle(tester);
  await tester.tap(finder);
  await _settle(tester);
}

Future<void> _go(WidgetTester tester, ProviderContainer c, String to) async {
  c.read(routerProvider).go(to);
  await _settle(tester);
}

/// Formdaki "Kaydet" (üst çubukta).
Finder get _save => find.widgetWithText(TextButton, 'Kaydet');

Finder get _cancel => find.widgetWithText(TextButton, 'İptal');

Finder _field(String label) => find.descendant(
  of: find.widgetWithText(LabeledField, label),
  matching: find.byType(TextField),
);

/// Alanı (gerekirse kaydırıp) bulur ve yazar.
Future<void> _enter(WidgetTester tester, String label, String text) async {
  await _reveal(tester, _field(label));
  await tester.enterText(_field(label), text);
  await _settle(tester);
}

/// Tembel listede henüz kurulmamış öğeyi görünene kadar kaydırır.
Future<void> _reveal(WidgetTester tester, Finder finder) => tester
    .scrollUntilVisible(finder, 200, scrollable: find.byType(Scrollable).first);

Future<OrganizationRow> _org(AppDatabase db) =>
    db.select(db.organizations).getSingle();

void main() {
  group('profil', () {
    testWidgets('Daha fazla kartından açılır; bilgiler yerel kayıtlardan', (
      tester,
    ) async {
      final (container: _, :db) = await _open(
        tester,
        location: AppRoutes.more,
        seed: seedCountedRecords,
      );

      expect(find.text('Ahmet Yılmaz · Sahip · Türkiye'), findsOneWidget);
      await _tap(tester, find.text('Yılmaz Arıcılık'));

      expect(find.byType(BusinessProfileScreen), findsOneWidget);
      expect(find.text('YA'), findsOneWidget);
      expect(find.text('Ahmet Yılmaz · Sahip'), findsOneWidget);
      expect(find.text('Türkiye · TR profili'), findsOneWidget);
      // 3 aktif kovan, 2 arılık, 4 muayene (silinmiş/sönmüş sayılmaz).
      expect(find.widgetWithText(CountTile, 'kovan'), findsOneWidget);
      expect(
        tester.widget<CountTile>(find.widgetWithText(CountTile, 'kovan')).count,
        3,
      );
      expect(
        tester
            .widget<CountTile>(find.widgetWithText(CountTile, 'arılık'))
            .count,
        2,
      );
      expect(
        tester
            .widget<CountTile>(find.widgetWithText(CountTile, 'muayene'))
            .count,
        4,
      );
      expect(find.text('Gezginci'), findsOneWidget);
      expect(find.text('TRY'), findsOneWidget);
      expect(find.text('Ekip · 3 kişi'), findsOneWidget);
      expect(find.text('1 işçi, 1 danışman'), findsOneWidget);
      expect(find.text(testUser.email!), findsOneWidget);
      expect(find.text('Mart 2024 · 3. sezon'), findsOneWidget);
      // Elle girilen sayı ya da tescil alanı yok.
      expect(find.byType(TextField), findsNothing);

      // Yeni kovan sayacı kendiliğinden günceller.
      final apiary = (await db.select(db.apiaries).get()).first;
      await HiveRepository(db).create(
        orgId: testOrganization.id,
        number: '9',
        type: HiveType.langstroth,
        apiaryId: apiary.id,
      );
      await _settle(tester);
      expect(
        tester.widget<CountTile>(find.widgetWithText(CountTile, 'kovan')).count,
        4,
      );
    });

    testWidgets('e-posta satırı "yakında"; ayarlar ve ekip kısayolu', (
      tester,
    ) async {
      final (:container, db: _) = await _open(tester);

      await _tap(tester, find.text(testUser.email!));
      expect(
        find.text('E-postayı değiştirme yakında gelecek.'),
        findsOneWidget,
      );

      await _tap(tester, find.text('Ekip · 3 kişi'));
      expect(container.read(routerProvider).state.uri.path, AppRoutes.team);

      await _go(tester, container, AppRoutes.business);
      await _tap(tester, find.text('Dil, birim, tema ve veri ayarları'));
      expect(container.read(routerProvider).state.uri.path, AppRoutes.settings);
    });
  });

  group('rol bazlı düzenleme', () {
    for (final (role, canEdit) in [
      (MembershipRole.owner, true),
      (MembershipRole.partner, true),
      (MembershipRole.worker, false),
      (MembershipRole.viewer, false),
    ]) {
      testWidgets('${role.name}: Düzenle ${canEdit ? 'görünür' : 'görünmez'}, '
          'düzenleme rotası ${canEdit ? 'form' : 'salt okunur'}', (
        tester,
      ) async {
        final (:container, :db) = await _open(tester, role: role);

        expect(
          find.widgetWithText(TextButton, 'Düzenle'),
          canEdit ? findsOneWidget : findsNothing,
        );

        await _go(tester, container, AppRoutes.businessEdit);
        expect(find.byType(BusinessProfileEditScreen), findsOneWidget);
        expect(_save, canEdit ? findsOneWidget : findsNothing);
        expect(
          find.text(
            'İşletme bilgilerini yalnız sahip ve ortak değiştirebilir.',
          ),
          canEdit ? findsNothing : findsOneWidget,
        );
        // Kendi rolü formda yok.
        expect(find.text('Rol'), findsNothing);
        expect(find.byType(TextField), canEdit ? findsWidgets : findsNothing);
        expect(await readOutbox(db), isEmpty);
      });
    }
  });

  group('işletme türü', () {
    testWidgets('gezginci → sabit gizler, sabit → gezginci kayıtları geri '
        'getirir; onay doğru sayıları gösterir', (tester) async {
      final (:container, :db) = await _open(tester, seed: seedMigrations);

      // Başta gezginci: menüde ve rotada görünür.
      await _go(tester, container, AppRoutes.more);
      expect(find.text('Gezginci'), findsOneWidget);
      await _go(tester, container, AppRoutes.migrations);
      expect(find.textContaining('Yayla 1'), findsOneWidget);

      // Sabite geçiş: onay 2 plan ve 4 durak sayar (silinmişler hariç).
      await _go(tester, container, AppRoutes.businessEdit);
      await _tap(tester, find.text('Sabit'));
      await _tap(tester, _save);
      expect(find.text('Sabit işletmeye geçilsin mi?'), findsOneWidget);
      expect(
        find.text(
          '2 göç planı ve 4 durak kaydı gizlenecek. Kayıtlar silinmez, geri '
          'alabilirsin.',
        ),
        findsOneWidget,
      );
      await _tap(tester, find.text('Sabite geç'));
      expect((await _org(db)).operationType, OperationType.stationary);
      expect(find.byType(BusinessProfileScreen), findsOneWidget);
      expect(find.text('Sabit'), findsOneWidget);

      // Menüden kalkar; rotaya elle gidilince çökmez, boş durum çıkar.
      await _go(tester, container, AppRoutes.more);
      expect(find.text('Gezginci'), findsNothing);
      await _go(tester, container, AppRoutes.migrations);
      expect(find.text('Gezginci modülü kapalı'), findsOneWidget);
      expect(find.textContaining('Yayla 1'), findsNothing);
      // Kayıtlar silinmedi.
      expect(
        (await db.select(db.migrations).get()).where(
          (m) => m.deletedAt == null,
        ),
        hasLength(2),
      );

      // Geri gezginci: onay sorulmaz, kayıtlar geri gelir.
      await _go(tester, container, AppRoutes.businessEdit);
      await _tap(tester, find.text('Gezginci'));
      await _tap(tester, _save);
      expect(find.text('Sabit işletmeye geçilsin mi?'), findsNothing);
      expect((await _org(db)).operationType, OperationType.migratory);
      await _go(tester, container, AppRoutes.more);
      expect(find.text('Gezginci'), findsOneWidget);
      await _go(tester, container, AppRoutes.migrations);
      expect(find.textContaining('Yayla 1'), findsOneWidget);
      expect(find.textContaining('Yayla 2'), findsOneWidget);
    });

    testWidgets('onaydan vazgeçilirse bir şey yazılmaz', (tester) async {
      final (:container, :db) = await _open(
        tester,
        seed: seedMigrations,
        location: AppRoutes.businessEdit,
      );

      await _tap(tester, find.text('Sabit'));
      await _tap(tester, _save);
      await _tap(tester, find.text('Vazgeç'));

      expect(find.byType(BusinessProfileEditScreen), findsOneWidget);
      expect((await _org(db)).operationType, OperationType.migratory);
      expect(
        (await readOutbox(db)).where((e) => e.recordTable == 'organizations'),
        isEmpty,
      );
    });

    testWidgets('sabit işletmede finans formunda taşıma alanı yok', (
      tester,
    ) async {
      await _open(
        tester,
        operationType: OperationType.stationary,
        location: AppRoutes.financeNew(TransactionKind.expense),
      );
      expect(find.text('Taşıma'), findsNothing);
    });
  });

  group('form', () {
    testWidgets('kaydet: işletme ve ad yerelde yazılır, outbox kaydı açılır, '
        '"eşitlenecek" rozeti görünür', (tester) async {
      final (:container, :db) = await _open(
        tester,
        location: AppRoutes.businessEdit,
      );

      await _enter(tester, 'İşletme adı', 'Petek Ltd.');
      await _enter(tester, 'Ad soyad', 'Ahmet Can Yılmaz');
      await _tap(tester, find.text('Bal'));
      await _tap(tester, _save);

      expect(find.byType(BusinessProfileScreen), findsOneWidget);
      final org = await _org(db);
      expect(org.name, 'Petek Ltd.');
      expect(org.avatarColor, OrgAvatarColor.honey);
      final member = await (db.select(
        db.memberships,
      )..where((t) => t.userId.equals(testUser.id))).getSingle();
      expect(member.fullName, 'Ahmet Can Yılmaz');
      expect(member.role, MembershipRole.owner);
      expect([
        for (final e in await readOutbox(db)) e.recordTable,
      ], unorderedEquals(['organizations', 'memberships']));
      expect(find.text('Petek Ltd.'), findsOneWidget);
      expect(find.text('Ahmet Can Yılmaz · Sahip'), findsOneWidget);
      expect(find.text('Eşitlenecek'), findsOneWidget);

      // Gönderilince rozet kalkar.
      await db.delete(db.outbox).go();
      await _settle(tester);
      expect(find.text('Eşitlenecek'), findsNothing);
    });

    testWidgets('değişiklik yoksa İptal hemen çıkar', (tester) async {
      final (:container, :db) = await _open(tester);
      await _tap(tester, find.widgetWithText(TextButton, 'Düzenle'));

      await _tap(tester, _cancel);

      expect(find.byType(BusinessProfileScreen), findsOneWidget);
      expect(find.text('Değişiklikler atılsın mı?'), findsNothing);
      expect(await readOutbox(db), isEmpty);
    });

    testWidgets('kaydetmeden çıkış sorulur; vazgeçince formda kalır, atınca '
        'bir şey yazılmaz', (tester) async {
      final (:container, :db) = await _open(tester);
      await _tap(tester, find.widgetWithText(TextButton, 'Düzenle'));
      await _enter(tester, 'İşletme adı', 'Başka ad');

      await _tap(tester, _cancel);
      expect(find.text('Değişiklikler atılsın mı?'), findsOneWidget);
      await _tap(tester, find.text('Vazgeç'));
      expect(find.byType(BusinessProfileEditScreen), findsOneWidget);

      // Sistem geri tuşu da sorar.
      await tester.binding.handlePopRoute();
      await _settle(tester);
      expect(find.text('Değişiklikler atılsın mı?'), findsOneWidget);
      await _tap(tester, find.text('At'));

      expect(find.byType(BusinessProfileScreen), findsOneWidget);
      expect((await _org(db)).name, 'Yılmaz Arıcılık');
      expect(await readOutbox(db), isEmpty);
    });

    testWidgets('para birimi değişince not çıkar; eski hareket eski para '
        'biriminde kalır, finans ayrı gösterir', (tester) async {
      final (:container, :db) = await _open(
        tester,
        location: AppRoutes.businessEdit,
        seed: (db) => TransactionRepository(db).create(
          orgId: testOrganization.id,
          kind: TransactionKind.income,
          category: TransactionCategory.other,
          amount: 1200,
          currency: 'TRY',
          occurredOn: DateTime.now(),
        ),
      );

      const note =
          'Geçmiş kayıtlar dönüştürülmez; yeni para birimi yalnız bundan '
          'sonraki kayıtlara uygulanır.';
      expect(find.text(note), findsNothing);
      await _tap(tester, find.text('TRY'));
      final sheet = find.byType(BottomSheet);
      // Simge yok, yalnız kod; seçili birim en üstte.
      expect(
        find.descendant(of: sheet, matching: find.text('₺ TRY')),
        findsNothing,
      );
      final search = find.descendant(
        of: sheet,
        matching: find.byType(TextField),
      );
      // Ülke adıyla arama: "almanya" → EUR.
      await tester.enterText(search, 'almanya');
      await tester.pump();
      expect(
        find.descendant(of: sheet, matching: find.text('TRY')),
        findsNothing,
      );
      await tester.enterText(search, 'xx-yok');
      await tester.pump();
      expect(find.text('Aramana uyan para birimi yok.'), findsOneWidget);
      await tester.enterText(search, 'eu');
      await tester.pump();
      await _tap(
        tester,
        find.descendant(of: sheet, matching: find.text('EUR')),
      );
      expect(find.text(note), findsOneWidget);
      await _tap(tester, _save);

      expect((await _org(db)).currency, 'EUR');
      final transaction = await db.select(db.transactions).getSingle();
      expect(transaction.currency, 'TRY');
      expect(transaction.amount, 1200);

      await _go(tester, container, AppRoutes.finance);
      expect(find.text('Diğer para birimleri'), findsOneWidget);
      expect(find.textContaining('TRY · net +'), findsOneWidget);
    });
  });

  group('görünüm', () {
    for (final mode in [
      AppColorMode.light,
      AppColorMode.dark,
      AppColorMode.sun,
    ]) {
      for (final glove in [false, true]) {
        testWidgets(
          '${mode.name}${glove ? ' + eldiven' : ''}: 360dp 1.5x yazıda profil '
          've form taşmaz, düğmeler en az 56dp',
          (tester) async {
            tester.view
              ..physicalSize = const Size(360, 640)
              ..devicePixelRatio = 1;
            tester.platformDispatcher.textScaleFactorTestValue = 1.5;
            addTearDown(tester.view.reset);
            addTearDown(
              tester.platformDispatcher.clearTextScaleFactorTestValue,
            );

            final (:container, db: _) = await _open(
              tester,
              seed: seedCountedRecords,
            );
            container.read(appearanceProvider.notifier)
              ..setColorMode(mode)
              ..setGloveMode(enabled: glove);
            await _settle(tester);
            expect(tester.takeException(), isNull);
            await _reveal(
              tester,
              find.text('Dil, birim, tema ve veri ayarları'),
            );
            expect(tester.takeException(), isNull);

            await _go(tester, container, AppRoutes.businessEdit);
            expect(tester.takeException(), isNull);
            expect(tester.getSize(_save).height, greaterThanOrEqualTo(56));
            expect(tester.getSize(_cancel).height, greaterThanOrEqualTo(56));
            await _reveal(tester, _field('Ad soyad'));
            expect(tester.takeException(), isNull);
          },
        );
      }
    }
  });
}

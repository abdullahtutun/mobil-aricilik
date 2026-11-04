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
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiaries_screen.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
}) async {
  final container = ProviderContainer.test(overrides: signedIn(db: db));
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

Future<void> _openMenu(WidgetTester tester) =>
    _tap(tester, find.byIcon(Icons.more_vert_rounded));

void main() {
  late AppDatabase db;
  late ApiaryRepository apiaries;
  late HiveRepository hives;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    apiaries = ApiaryRepository(db);
    hives = HiveRepository(db);
    yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> hive(String number) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.local,
    apiaryId: yayla.id,
  );

  group('Arılık silme', () {
    testWidgets('kovan sayısı hatırlatılır; onaylanınca kovanlarıyla silinir', (
      tester,
    ) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.owner);
      final h1 = await hive('1');
      final h2 = await hive('2');
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      await _openMenu(tester);
      await _tap(tester, find.text('Delete apiary'));
      expect(find.text('Delete this apiary?'), findsOneWidget);
      expect(
        find.text(
          'This apiary has 2 hives. The apiary and its hives will be '
          'removed from every phone.',
        ),
        findsOneWidget,
      );

      // Vazgeçince hiçbir şey silinmez.
      await _tap(tester, find.text('Cancel'));
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(await apiaries.findById(yayla.id), isNotNull);

      await _openMenu(tester);
      await _tap(tester, find.text('Delete apiary'));
      await _tap(tester, find.widgetWithText(TextButton, 'Delete'));

      expect(find.byType(ApiariesScreen), findsOneWidget);
      expect(find.text('Apiary deleted'), findsOneWidget);
      expect(find.text('Yayla'), findsNothing);
      expect(await apiaries.findById(yayla.id), isNull);
      expect(await hives.findById(h1.id), isNull);
      expect(await hives.findById(h2.id), isNull);
    });

    testWidgets('kovansız arılıkta kovan anılmaz', (tester) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.partner);
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      await _openMenu(tester);
      await _tap(tester, find.text('Delete apiary'));
      expect(
        find.text('The apiary will be removed from every phone.'),
        findsOneWidget,
      );
      await _tap(tester, find.widgetWithText(TextButton, 'Delete'));
      expect(await apiaries.findById(yayla.id), isNull);
    });

    testWidgets('worker ve rolü bilinmeyen kullanıcı silemez', (tester) async {
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));
      await _openMenu(tester);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete apiary'), findsNothing);
    });

    testWidgets('worker menüde Sil görmez', (tester) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.worker);
      await hive('1');
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));
      await _openMenu(tester);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete apiary'), findsNothing);
    });
  });

  group('Kovan silme', () {
    testWidgets('onaylanınca kovan silinir, arılığa dönülür', (tester) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.owner);
      final h1 = await hive('7');
      final h2 = await hive('8');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, h1.id));

      await _openMenu(tester);
      await _tap(tester, find.text('Delete hive'));
      expect(find.text('Delete hive 7?'), findsOneWidget);
      expect(
        find.text('The hive and its records will be removed from every phone.'),
        findsOneWidget,
      );
      await _tap(tester, find.text('Cancel'));
      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(await hives.findById(h1.id), isNotNull);

      await _openMenu(tester);
      await _tap(tester, find.text('Delete hive'));
      await _tap(tester, find.widgetWithText(TextButton, 'Delete'));

      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
      expect(find.text('Hive 7 deleted'), findsOneWidget);
      expect(await hives.findById(h1.id), isNull);
      expect(await hives.findById(h2.id), isNotNull);
      expect(await apiaries.findById(yayla.id), isNotNull);
    });

    testWidgets('worker menüde Sil görmez', (tester) async {
      await addMember(db, userId: testUser.id, role: MembershipRole.worker);
      final h1 = await hive('7');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, h1.id));
      await _openMenu(tester);
      expect(find.text('Edit'), findsOneWidget);
      expect(find.text('Delete hive'), findsNothing);
    });
  });

  testWidgets('Türkçe metinler', (tester) async {
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    final h1 = await hive('7');
    await hive('8');
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, h1.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _openMenu(tester);
    await _tap(tester, find.text('Kovanı sil'));
    expect(find.text('7 numaralı kovan silinsin mi?'), findsOneWidget);
    expect(
      find.text('Kovan ve kayıtları bütün telefonlardan kalkar.'),
      findsOneWidget,
    );
    await _tap(tester, find.widgetWithText(TextButton, 'Sil'));
    expect(find.text('7 numaralı kovan silindi'), findsOneWidget);

    await _openMenu(tester);
    await _tap(tester, find.text('Arılığı sil'));
    expect(find.text('Arılık silinsin mi?'), findsOneWidget);
    expect(
      find.text(
        'Bu arılıkta 1 kovan var. Arılık, kovanlarıyla birlikte bütün '
        'telefonlardan kalkar.',
      ),
      findsOneWidget,
    );
    await _tap(tester, find.widgetWithText(TextButton, 'Sil'));
    expect(find.text('Arılık silindi'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    await hive('1');

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiary(yayla.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    await _openMenu(tester);
    await _tap(tester, find.text('Delete apiary'));
    expect(tester.takeException(), isNull);
    expect(find.text('Delete this apiary?'), findsOneWidget);
  });
}

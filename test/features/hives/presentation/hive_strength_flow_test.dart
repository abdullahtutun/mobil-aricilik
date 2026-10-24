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
import 'package:mobil_arici/features/apiaries/presentation/apiary_detail_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// İşletmesi olan kullanıcıyla uygulamayı açar ve [location]'a gider.
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
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Izgaradaki karolar ekrandaki sırasıyla: numara ve güç puanı.
List<(String, int?)> _tiles(WidgetTester tester) => [
  for (final tile in tester.widgetList<HiveTile>(find.byType(HiveTile)))
    (tile.number, tile.strength),
];

HiveSort _sort(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(ApiaryDetailScreen)))
        .read(hiveSortPreferenceProvider);

/// Listedeki aktif kovanların güç puanları, ekrandaki sırasıyla.
List<int?> _listStrengths(WidgetTester tester) => [
  for (final dots in tester.widgetList<StrengthDots>(find.byType(StrengthDots)))
    dots.strength,
];

void main() {
  late AppDatabase db;
  late TestClock clock;
  late HiveRepository hives;
  late InspectionRepository inspections;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock();
    hives = HiveRepository(db, clock: clock.call);
    inspections = InspectionRepository(db, clock: clock.call);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> createHive(
    String number, {
    HiveStatus status = HiveStatus.active,
  }) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: yayla.id,
    status: status,
  );

  Future<Inspection> inspect(Hive hive, InspectionValues values) {
    clock.advance(const Duration(minutes: 1));
    return inspections.add(
      orgId: _orgId,
      hiveId: hive.id,
      apiaryId: hive.apiaryId,
      values: values,
    );
  }

  /// Puanları 1, 3, 3, 5 olan dört aktif kovan, puansız bir aktif kovan ve
  /// muayenesi olan sönmüş bir kovan.
  Future<void> seedScoredApiary() async {
    final strong = await createHive('1');
    final weak = await createHive('2');
    await createHive('3');
    final ten = await createHive('10');
    final nine = await createHive('9');
    final dead = await createHive('5', status: HiveStatus.dead);
    await inspect(strong, const InspectionValues(beeFrames: 9));
    await inspect(
      weak,
      const InspectionValues(beeFrames: 3, queenState: QueenState.none),
    );
    await inspect(ten, const InspectionValues(beeFrames: 6));
    await inspect(nine, const InspectionValues(beeFrames: 5));
    await inspect(dead, const InspectionValues(beeFrames: 8));
  }

  testWidgets('karoda son muayenenin puanı; muayenesiz, arılı çerçevesi '
      'girilmemiş ve aktif olmayan kovan puansız', (tester) async {
    final updated = await createHive('1');
    final framesUnknown = await createHive('2');
    await createHive('3');
    final dead = await createHive('4', status: HiveStatus.dead);
    // Eski muayene güçlü, son muayene zayıf: son muayene sayılır.
    await inspect(updated, const InspectionValues(beeFrames: 10));
    clock.advance(const Duration(days: 7));
    await inspect(
      updated,
      const InspectionValues(beeFrames: 4, diseaseSuspected: true),
    );
    await inspect(
      framesUnknown,
      const InspectionValues(queenState: QueenState.seen),
    );
    await inspect(dead, const InspectionValues(beeFrames: 9));

    await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

    expect(_tiles(tester), [('1', 1), ('2', null), ('3', null), ('4', null)]);
    expect(find.bySemanticsLabel('Hive 1, Strength 1 of 5'), findsOneWidget);
    expect(find.bySemanticsLabel('Hive 3'), findsOneWidget);
  });

  testWidgets('muayene kaydedilince karo kendiliğinden puan alır', (
    tester,
  ) async {
    final hive = await createHive('101');
    await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));
    expect(_tiles(tester), [('101', null)]);

    await tester.runAsync(
      () => inspect(hive, const InspectionValues(beeFrames: 7)),
    );
    await tester.pumpAndSettle();
    expect(_tiles(tester), [('101', 4)]);

    await tester.runAsync(
      () => inspect(
        hive,
        const InspectionValues(beeFrames: 7, queenState: QueenState.none),
      ),
    );
    await tester.pumpAndSettle();
    expect(_tiles(tester), [('101', 3)]);
  });

  testWidgets("zayıflar önce: 1'den 5'e, eşitte numara sırası, puansızlar "
      'sonda; seçim ızgarada ve listede geçerli', (tester) async {
    await seedScoredApiary();
    await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

    // Varsayılan numara sırası; aktif olmayan kovan ayrı bölümde, puansız.
    expect(_tiles(tester), [
      ('1', 5),
      ('2', 1),
      ('3', null),
      ('9', 3),
      ('10', 3),
      ('5', null),
    ]);
    final weakestFirst = find.text('Weakest first');
    expect(_sort(tester), HiveSort.number);
    expect(
      tester.getSemantics(weakestFirst),
      isSemantics(hasToggledState: true, isToggled: false, isButton: true),
    );

    await _tap(tester, weakestFirst);

    expect(_tiles(tester), [
      ('2', 1),
      ('9', 3),
      ('10', 3),
      ('1', 5),
      ('3', null),
      ('5', null),
    ]);
    expect(_sort(tester), HiveSort.weakestFirst);
    expect(
      tester.getSemantics(weakestFirst),
      isSemantics(hasToggledState: true, isToggled: true, isButton: true),
    );
    // Ekranda da öyle: geniş ekranda aktifler tek satırda, en zayıf solda.
    final x = [
      for (final n in ['2', '9', '10', '1', '3'])
        tester.getTopLeft(find.text(n)).dx,
    ];
    expect(x, [...x]..sort());

    // Yeniden dokunmak numara sırasına döndürür.
    await _tap(tester, weakestFirst);
    expect(_sort(tester), HiveSort.number);
    expect(_tiles(tester).first, ('1', 5));
    await _tap(tester, weakestFirst);

    await _tap(tester, find.text('List'));

    expect(find.byType(HiveTile), findsNothing);
    // Aktif olmayan kovanın satırında nokta değil durum rozeti var.
    expect(_listStrengths(tester), [1, 3, 3, 5, null]);
    expect(find.widgetWithText(StatusBadge, 'Dead'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Strength 1 of 5')), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Strength 3 of 5')), findsNWidgets(2));

    await _tap(tester, weakestFirst);
    expect(_listStrengths(tester), [5, 1, null, 3, 3]);
  });

  group('Kovan kartı', () {
    /// Kartın başlığındaki güç noktaları.
    Finder cardDots() => find.descendant(
      of: find.byType(HiveCardScreen),
      matching: find.byType(StrengthDots),
    );

    testWidgets('son muayenenin puanı noktalar ve kelimesiyle; yeni '
        'muayenede kendiliğinden güncellenir', (tester) async {
      final hive = await createHive('101');
      await inspect(hive, const InspectionValues(beeFrames: 9));
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      expect(find.text('Strength 5 of 5'), findsOneWidget);
      expect(tester.widget<StrengthDots>(cardDots()).strength, 5);
      expect(find.text('No strength score yet'), findsNothing);

      await tester.runAsync(
        () => inspect(
          hive,
          const InspectionValues(beeFrames: 4, queenState: QueenState.none),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Strength 1 of 5'), findsOneWidget);
      expect(tester.widget<StrengthDots>(cardDots()).strength, 1);
    });

    testWidgets('muayene ya da arılı çerçeve yoksa "puan yok" yazar', (
      tester,
    ) async {
      final hive = await createHive('101');
      final container = await _open(
        tester,
        db: db,
        location: AppRoutes.hive(yayla.id, hive.id),
      );

      expect(find.text('No strength score yet'), findsOneWidget);
      expect(tester.widget<StrengthDots>(cardDots()).strength, isNull);

      await tester.runAsync(
        () => inspect(
          hive,
          const InspectionValues(queenState: QueenState.seen, broodFrames: 5),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text('No strength score yet'), findsOneWidget);

      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();
      expect(find.text('Henüz güç puanı yok'), findsOneWidget);
    });

    testWidgets('aktif olmayan kovanın kartında puan yok', (tester) async {
      final hive = await createHive('101', status: HiveStatus.dead);
      await inspect(hive, const InspectionValues(beeFrames: 9));
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      expect(find.widgetWithText(StatusBadge, 'Dead'), findsOneWidget);
      expect(cardDots(), findsNothing);
      expect(find.text('Strength 5 of 5'), findsNothing);
      expect(find.text('No strength score yet'), findsNothing);
    });
  });

  testWidgets('tek aktif kovanda sıra seçimi yok', (tester) async {
    await createHive('1');
    await createHive('2', status: HiveStatus.sold);
    await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

    expect(find.text('Weakest first'), findsNothing);
    expect(find.text('By number'), findsNothing);
  });

  testWidgets('Türkçe metinler', (tester) async {
    await seedScoredApiary();
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiary(yayla.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, find.text('Zayıflar önce'));
    expect(find.bySemanticsLabel('Kovan 2, Güç 1/5'), findsOneWidget);
    await _tap(tester, find.text('Liste'));
    expect(find.bySemanticsLabel(RegExp('Güç 5/5')), findsOneWidget);

    await _tap(tester, find.text('2'));
    expect(find.text('Güç 1/5'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await seedScoredApiary();

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.apiary(yayla.id),
    );
    expect(tester.takeException(), isNull);
    await _tap(tester, find.text('Weakest first'));
    expect(tester.takeException(), isNull);

    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    final toggle = tester.getSize(
      find.ancestor(
        of: find.text('Weakest first'),
        matching: find.byType(InkWell),
      ),
    );
    expect(toggle.height, greaterThanOrEqualTo(AppTouchTargets.glove.minimum));

    await _tap(tester, find.text('List'));
    expect(tester.takeException(), isNull);
  });
}

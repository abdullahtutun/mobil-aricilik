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
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Her alanı dolu muayene.
const _full = InspectionValues(
  queenState: QueenState.seen,
  beeFrames: 7,
  broodFrames: 4,
  honeyFrames: 2,
  temperament: Temperament.calm,
  swarmSigns: false,
  queenCells: QueenCells.none,
  diseaseSuspected: true,
  actions: {InspectionAction.fed, InspectionAction.superAdded},
);

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

/// Kartı tünelin son olayına kadar kaydırır; liste tembel, alttaki olaylar
/// görünmeden kurulmaz.
Future<void> _scrollToEnd(WidgetTester tester) async {
  await tester.scrollUntilVisible(
    find.byWidgetPredicate((w) => w is TimelineTile && w.isLast),
    200,
    scrollable: find
        .descendant(
          of: find.byType(HiveCardScreen),
          matching: find.byType(Scrollable),
        )
        .first,
  );
  await tester.pumpAndSettle();
}

/// Tünel ekrandaki sırasıyla: her olayın başlığı ve ayrıntıları.
List<List<String>> _timeline(WidgetTester tester) => [
  for (final tile in tester.widgetList<TimelineTile>(find.byType(TimelineTile)))
    [tile.title, ...tile.details],
];

void main() {
  late AppDatabase db;
  late TestClock clock;
  late HiveRepository hives;
  late InspectionRepository inspections;
  late Apiary yayla;
  late Apiary ova;

  setUp(() async {
    db = openTestDatabase();
    clock = TestClock(DateTime.utc(2026, 10, 1, 9));
    hives = HiveRepository(db, clock: clock.call);
    inspections = InspectionRepository(db, clock: clock.call);
    final apiaries = ApiaryRepository(db, clock: clock.call);
    yayla = await apiaries.create(orgId: _orgId, name: 'Yayla');
    ova = await apiaries.create(orgId: _orgId, name: 'Ova');
  });

  Future<Hive> createHive() => hives.create(
    orgId: _orgId,
    number: '101',
    type: HiveType.langstroth,
    apiaryId: yayla.id,
  );

  Future<Inspection> inspect(Hive hive, InspectionValues values) async =>
      await inspections.add(
        orgId: _orgId,
        hiveId: hive.id,
        apiaryId: (await hives.findById(hive.id))!.apiaryId,
        values: values,
      );

  testWidgets('olaylar en yeni önce ve ikonlu: muayene, taşıma, muayene, '
      'eklendi; girilen alanlar yazılır, bakılmayanlar yazılmaz', (
    tester,
  ) async {
    final hive = await createHive();
    final added = clock.current;
    clock.advance(const Duration(days: 2));
    await inspect(hive, _full);
    clock.advance(const Duration(days: 3));
    await hives.move(hive.id, apiaryId: ova.id);
    clock.advance(const Duration(days: 1, hours: 5));
    final last = clock.current;
    await inspect(hive, const InspectionValues(beeFrames: 5));

    await _open(tester, db: db, location: AppRoutes.hive(ova.id, hive.id));
    expect(find.text('History'), findsNothing);
    await _scrollToEnd(tester);

    expect(find.text('History'), findsOneWidget);
    expect(_timeline(tester), [
      ['Inspection', 'Frames: 5 with bees'],
      ['Moved', 'Yayla → Ova'],
      [
        'Inspection',
        'Queen: Seen',
        'Frames: 7 with bees, 4 with brood, 2 with honey',
        'Temperament: Calm',
        'Swarm signs: No',
        'Queen cells: None',
        'Disease suspected: Yes',
        'Done: Super added, Fed',
      ],
      ['Added to apiary', 'Yayla'],
    ]);
    final tiles = tester
        .widgetList<TimelineTile>(find.byType(TimelineTile))
        .toList();
    expect(
      [for (final t in tiles) t.icon],
      [
        Icons.fact_check_rounded,
        Icons.local_shipping_rounded,
        Icons.fact_check_rounded,
        Icons.add_location_alt_rounded,
      ],
    );
    expect([for (final t in tiles) t.isLast], [false, false, false, true]);
    const format = AppFormat('en');
    expect(tiles.first.time, format.dateTime(last.toLocal()));
    expect(tiles.last.time, format.dateTime(added.toLocal()));
    // Ekran okuyucu her olayı tek parça okur.
    expect(
      tester.getSemantics(find.text('Yayla → Ova')),
      isSemantics(label: 'Moved\n${tiles[1].time}\nYayla → Ova'),
    );
  });

  testWidgets('karttan taşıma tünele düşer, Geri al kaldırır; yeni muayene '
      'en üste gelir', (tester) async {
    final hive = await createHive();
    await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));
    await _scrollToEnd(tester);
    expect(_timeline(tester), [
      ['Added to apiary', 'Yayla'],
    ]);

    await _tap(tester, find.text('Move to another apiary'));
    await _tap(tester, find.widgetWithText(OptionTile, 'Ova'));
    await _scrollToEnd(tester);
    expect(_timeline(tester), [
      ['Moved', 'Yayla → Ova'],
      ['Added to apiary', 'Yayla'],
    ]);

    await _tap(tester, find.text('Undo'));
    expect(_timeline(tester), [
      ['Added to apiary', 'Yayla'],
    ]);

    await tester.runAsync(() async {
      clock.advance(const Duration(days: 1));
      await inspect(hive, const InspectionValues(queenState: QueenState.eggs));
    });
    await tester.pumpAndSettle();
    expect(_timeline(tester), [
      ['Inspection', 'Queen: Eggs seen'],
      ['Added to apiary', 'Yayla'],
    ]);
  });

  testWidgets('silinen arılığın adı "Unknown apiary"', (tester) async {
    final hive = await createHive();
    clock.advance(const Duration(days: 1));
    await hives.move(hive.id, apiaryId: ova.id);
    await ApiaryRepository(db).delete(yayla.id);

    await _open(tester, db: db, location: AppRoutes.hive(ova.id, hive.id));
    await _scrollToEnd(tester);

    expect(_timeline(tester), [
      ['Moved', 'Unknown apiary → Ova'],
      ['Added to apiary', 'Unknown apiary'],
    ]);
  });

  testWidgets('Türkçe metinler', (tester) async {
    final hive = await createHive();
    clock.advance(const Duration(days: 1));
    await hives.move(hive.id, apiaryId: ova.id);
    clock.advance(const Duration(days: 1));
    await inspect(hive, _full);
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(ova.id, hive.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    await _scrollToEnd(tester);

    expect(find.text('Geçmiş'), findsOneWidget);
    expect(_timeline(tester), [
      [
        'Muayene',
        'Ana arı: Görüldü',
        'Çerçeveler: 7 arılı, 4 yavrulu, 2 ballı',
        'Mizaç: Sakin',
        'Oğul belirtisi: Yok',
        'Ana arı memesi: Yok',
        'Hastalık şüphesi: Var',
        'Yapılanlar: Kat verildi, Besleme yapıldı',
      ],
      ['Taşındı', 'Yayla → Ova'],
      ['Arılığa eklendi', 'Yayla'],
    ]);
    expect(
      tester.widget<TimelineTile>(find.byType(TimelineTile).first).time,
      const AppFormat('tr').dateTime(clock.current.toLocal()),
    );
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final hive = await createHive();
    for (var i = 0; i < 4; i++) {
      clock.advance(const Duration(days: 1));
      await hives.move(hive.id, apiaryId: i.isEven ? ova.id : yayla.id);
      clock.advance(const Duration(days: 1));
      await inspect(hive, _full);
    }

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    await _scrollToEnd(tester);
    expect(tester.takeException(), isNull);
    expect(find.byType(TimelineTile), findsWidgets);

    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    await _scrollToEnd(tester);
    expect(tester.takeException(), isNull);
  });
}

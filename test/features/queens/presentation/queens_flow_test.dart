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
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/queens/data/queen_repository.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';
import 'package:mobil_arici/features/queens/presentation/old_queens_screen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_card_screen.dart';
import 'package:mobil_arici/features/queens/presentation/queen_form_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Ekranlar yaşı ve renk önerisini `clock.now()`'dan alır; testler aynı
/// yıla göre yazılır.
final int _year = DateTime.now().year;

const Map<QueenMarkColor, String> _colorNames = {
  QueenMarkColor.white: 'White',
  QueenMarkColor.yellow: 'Yellow',
  QueenMarkColor.red: 'Red',
  QueenMarkColor.green: 'Green',
  QueenMarkColor.blue: 'Blue',
};

/// "2025 · Blue": yılın önerilen rengiyle ananın başlığı.
String _title(int year) => '$year · ${_colorNames[markColorForYear(year)]}';

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

/// Adı [label] olan alanın seçim grubu.
ChoiceChipGroup<T> _choices<T>(WidgetTester tester, String label) =>
    tester.widget<ChoiceChipGroup<T>>(
      find.descendant(
        of: find.byWidgetPredicate(
          (w) => w is LabeledField && w.label == label,
        ),
        matching: find.byType(ChoiceChipGroup<T>),
      ),
    );

/// Açık seçim sayfasındaki [text]; sayfa generic, `byType` tam tipi arar.
Finder _inSheet(String text) => find.descendant(
  of: find.byWidgetPredicate((widget) => widget is OptionSheet),
  matching: find.text(text),
);

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late QueenRepository queens;
  late Apiary yayla;

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    queens = QueenRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
  });

  Future<Hive> createHive(
    String number, {
    String? queenId,
    HiveStatus status = HiveStatus.active,
  }) => hives.create(
    orgId: _orgId,
    number: number,
    type: HiveType.langstroth,
    apiaryId: yayla.id,
    queenId: queenId,
    status: status,
  );

  /// [year] yılının önerilen rengiyle işaretli ana.
  Future<Queen> createQueen(
    int year, {
    String? breed,
    String? breedLine,
    QueenSource? source,
    bool wingClipped = false,
    String? motherQueenId,
  }) => queens.create(
    orgId: _orgId,
    year: year,
    markColor: markColorForYear(year),
    breed: breed,
    breedLine: breedLine,
    source: source,
    wingClipped: wingClipped,
    motherQueenId: motherQueenId,
  );

  group('Kovan kartındaki ana arı şeridi', () {
    testWidgets('anasız kovanda kayıt yok; dokununca yeni ana verilir, şerit '
        'gerçek veriyle dolar; Geri al kovanı anasız bırakır', (tester) async {
      final hive = await createHive('101');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      expect(find.text('Queen · Not recorded'), findsOneWidget);
      await _tap(tester, find.text('Queen · Not recorded'));

      expect(find.byType(QueenFormScreen), findsOneWidget);
      expect(find.text('New queen · Hive 101'), findsOneWidget);
      // Yeni ana bu yılın; renk yılın uluslararası rengi.
      expect(_choices<int>(tester, 'Year').selected, {_year});
      expect(_choices<QueenMarkColor?>(tester, 'Mark color').selected, {
        markColorForYear(_year),
      });
      expect(
        find.text('$_year color: ${_colorNames[markColorForYear(_year)]}'),
        findsOneWidget,
      );

      await tester.enterText(
        find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is LabeledField && w.label == 'Breed',
          ),
          matching: find.byType(TextField),
        ),
        'Kafkas',
      );
      await _tap(tester, find.text('Purchased'));
      await _tap(tester, find.text('Save'));

      // Form ana arı kartının üstünde açılmıştı; kaydedince yeni ananın
      // kartı kalır.
      expect(find.byType(QueenCardScreen), findsOneWidget);
      expect(find.text('Hive 101 has a new queen'), findsOneWidget);
      expect(find.text(_title(_year)), findsOneWidget);
      expect(find.text('Under a year old · Kafkas'), findsOneWidget);
      final saved = (await hives.findById(hive.id))!;
      final queen = (await queens.findById(saved.queenId!))!;
      expect(queen.year, _year);
      expect(queen.markColor, markColorForYear(_year));
      expect(queen.source, QueenSource.purchased);
      expect(queen.breed, 'Kafkas');

      await _tap(tester, find.text('Undo'));
      expect(find.text('No queen recorded'), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(HiveCardScreen), findsOneWidget);
      expect(find.text('Queen · Not recorded'), findsOneWidget);
      expect((await hives.findById(hive.id))!.queenId, isNull);
      expect(await queens.findById(queen.id), isNull);
    });

    testWidgets('anası olan kovanda dokununca ana arı kartı açılır', (
      tester,
    ) async {
      final queen = await createQueen(_year - 1, breed: 'Kafkas');
      final hive = await createHive('104', queenId: queen.id);
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      expect(find.text('Queen · ${_title(_year - 1)}'), findsOneWidget);
      expect(find.text('1 year old · Kafkas'), findsOneWidget);
      await _tap(tester, find.text('Queen · ${_title(_year - 1)}'));

      expect(find.byType(QueenCardScreen), findsOneWidget);
      expect(find.text('Hive 104'), findsOneWidget);
    });

    testWidgets('ızgara karosundaki nokta ananın işaret rengi', (tester) async {
      final queen = await createQueen(2025);
      await createHive('1', queenId: queen.id);
      final unmarked = await queens.create(orgId: _orgId, year: 2024);
      await createHive('2', queenId: unmarked.id);
      await createHive('3');
      await _open(tester, db: db, location: AppRoutes.apiary(yayla.id));

      final tiles = {
        for (final tile in tester.widgetList<HiveTile>(find.byType(HiveTile)))
          tile.number: tile.queenColor,
      };
      expect(tiles, {'1': QueenMarkColor.blue, '2': null, '3': null});
    });
  });

  group('Ana arı kartı', () {
    testWidgets('yıl ve renk, yaş ve ırk; kaynak, hat, kanat ve anne ana', (
      tester,
    ) async {
      final mother = await createQueen(_year - 3);
      await createHive('88', queenId: mother.id);
      final queen = await createQueen(
        _year - 1,
        breed: 'Kafkas',
        breedLine: 'Artvin',
        source: QueenSource.ownRearing,
        wingClipped: true,
        motherQueenId: mother.id,
      );
      final hive = await createHive('104', queenId: queen.id);
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveQueen(yayla.id, hive.id),
      );

      expect(find.text('Hive 104'), findsOneWidget);
      expect(find.text(_title(_year - 1)), findsOneWidget);
      expect(find.text('1 year old · Kafkas'), findsOneWidget);
      expect(find.text('Own rearing'), findsOneWidget);
      expect(find.text('Artvin'), findsOneWidget);
      expect(find.text('Clipped'), findsOneWidget);
      expect(find.text('Hive 88 · ${_title(_year - 3)}'), findsOneWidget);
      expect(find.widgetWithText(BigButton, 'Replace queen'), findsOneWidget);
    });

    testWidgets('girilmeyen alanlar "Not entered", anne ana bilinmiyor', (
      tester,
    ) async {
      final queen = await queens.create(orgId: _orgId);
      final hive = await createHive('104', queenId: queen.id);
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveQueen(yayla.id, hive.id),
      );

      expect(find.text('Year unknown · Unmarked'), findsOneWidget);
      expect(find.text('Not entered'), findsNWidgets(2));
      expect(find.text('Not clipped'), findsOneWidget);
      expect(find.text('Unknown'), findsOneWidget);
    });

    testWidgets('kovanda ana yoksa "Ana ver" sunulur', (tester) async {
      final hive = await createHive('104');
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveQueen(yayla.id, hive.id),
      );

      expect(find.text('No queen recorded'), findsOneWidget);
      expect(find.byTooltip('Edit queen'), findsNothing);
      await _tap(tester, find.text('Add queen'));
      expect(find.byType(QueenFormScreen), findsOneWidget);
    });

    testWidgets('düzenleme: yıl değişince öneriyi izleyen renk de değişir; '
        'ayrıca seçilen renk kalır', (tester) async {
      final queen = await createQueen(_year - 1);
      final hive = await createHive('104', queenId: queen.id);
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveQueen(yayla.id, hive.id),
      );

      await _tap(tester, find.text('Edit queen'));
      expect(find.text('Edit queen'), findsOneWidget);
      expect(_choices<int>(tester, 'Year').selected, {_year - 1});

      await _tap(tester, find.text('${_year - 2}'));
      expect(_choices<QueenMarkColor?>(tester, 'Mark color').selected, {
        markColorForYear(_year - 2),
      });

      await _tap(tester, find.text('Unmarked'));
      await _tap(tester, find.text('${_year - 3}'));
      expect(_choices<QueenMarkColor?>(tester, 'Mark color').selected, {null});

      await _tap(tester, find.text('Clipped'));
      await _tap(tester, find.text('Save'));

      expect(find.byType(QueenCardScreen), findsOneWidget);
      expect(find.text('${_year - 3} · Unmarked'), findsOneWidget);
      final saved = (await queens.findById(queen.id))!;
      expect(saved.year, _year - 3);
      expect(saved.markColor, isNull);
      expect(saved.wingClipped, isTrue);
      // Düzenleme kovandaki anayı değiştirmez.
      expect((await hives.findById(hive.id))!.queenId, queen.id);
    });

    testWidgets('Ana değiştir: yeni ana eskisinin yerine geçer; eski ana '
        'anne ana seçilebilir', (tester) async {
      final old = await createQueen(_year - 2);
      final hive = await createHive('104', queenId: old.id);
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveQueen(yayla.id, hive.id),
      );

      await _tap(tester, find.text('Replace queen'));
      expect(find.text('New queen · Hive 104'), findsOneWidget);

      await _tap(tester, find.text('Mother queen'));
      expect(_inSheet('Unknown'), findsOneWidget);
      await _tap(tester, _inSheet('Hive 104 · ${_title(_year - 2)}'));
      expect(find.text('Hive 104 · ${_title(_year - 2)}'), findsOneWidget);
      await _tap(tester, find.text('Save'));

      expect(find.byType(QueenCardScreen), findsOneWidget);
      expect(find.text(_title(_year)), findsOneWidget);
      final saved = (await hives.findById(hive.id))!;
      expect(saved.queenId, isNot(old.id));
      final queen = (await queens.findById(saved.queenId!))!;
      expect(queen.motherQueenId, old.id);
      // Eski ananın kaydı kalır; artık kovanda değil.
      expect(await queens.findById(old.id), isNotNull);
      expect(find.text('MOTHER QUEEN'), findsOneWidget);
      expect(find.text(_title(_year - 2)), findsOneWidget);
    });
  });

  group('Yaşlı analar', () {
    testWidgets(
      'Daha fazla sekmesinden açılır; aktif kovanlarda 2 yaşına girenler, '
      'en yaşlı önce; dokununca ana arı kartı',
      (tester) async {
        final two = await createQueen(_year - 2);
        await createHive('5', queenId: two.id);
        final three = await createQueen(_year - 3);
        await createHive('7', queenId: three.id);
        final one = await createQueen(_year - 1);
        await createHive('9', queenId: one.id);
        final dead = await createQueen(_year - 4);
        await createHive('11', queenId: dead.id, status: HiveStatus.dead);
        await _open(tester, db: db, location: AppRoutes.more);

        await _tap(tester, find.text('Old queens'));
        expect(find.byType(OldQueensScreen), findsOneWidget);

        // En yaşlı önce.
        expect(
          tester.getTopLeft(find.text('Hive 7 · Yayla')).dy,
          lessThan(tester.getTopLeft(find.text('Hive 5 · Yayla')).dy),
        );
        expect(find.text(_title(_year - 3)), findsOneWidget);
        expect(find.text(_title(_year - 2)), findsOneWidget);
        expect(find.textContaining('Hive 9'), findsNothing);
        expect(find.textContaining('Hive 11'), findsNothing);
        expect(find.widgetWithText(StatusBadge, '3 years old'), findsOneWidget);
        expect(find.widgetWithText(StatusBadge, '2 years old'), findsOneWidget);

        await _tap(tester, find.text('Hive 7 · Yayla'));
        expect(find.byType(QueenCardScreen), findsOneWidget);
        expect(find.text('Hive 7'), findsOneWidget);
      },
    );

    testWidgets('yaşlı ana yoksa söylenir', (tester) async {
      final young = await createQueen(_year - 1);
      await createHive('5', queenId: young.id);
      await _open(tester, db: db, location: AppRoutes.oldQueens);

      expect(find.text('No old queens'), findsOneWidget);
      expect(find.textContaining('Hive 5'), findsNothing);
    });
  });

  testWidgets('Türkçe metinler', (tester) async {
    final old = await createQueen(_year - 2, breed: 'Kafkas');
    final hive = await createHive('104', queenId: old.id);
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();
    final router = container.read(routerProvider);

    final color = {
      QueenMarkColor.white: 'Beyaz',
      QueenMarkColor.yellow: 'Sarı',
      QueenMarkColor.red: 'Kırmızı',
      QueenMarkColor.green: 'Yeşil',
      QueenMarkColor.blue: 'Mavi',
    }[markColorForYear(_year - 2)]!;
    expect(find.text('Ana arı · ${_year - 2} · $color'), findsOneWidget);
    expect(find.text('2 yaşında · Kafkas'), findsOneWidget);

    router.go(AppRoutes.hiveQueen(yayla.id, hive.id));
    await tester.pumpAndSettle();
    expect(find.text('Kovan 104'), findsOneWidget);
    expect(find.text('KANAT'), findsOneWidget);
    expect(find.text('Kesik değil'), findsOneWidget);
    expect(find.text('ANNE ANA'), findsOneWidget);
    expect(find.text('Ana değiştir'), findsOneWidget);

    await _tap(tester, find.text('Ana değiştir'));
    expect(find.text('Yeni ana · Kovan 104'), findsOneWidget);
    expect(find.text('Doğum ya da alım yılı'), findsOneWidget);
    expect(find.text('İşaretsiz'), findsOneWidget);
    expect(find.text('Kendi üretimi'), findsOneWidget);

    router.go(AppRoutes.oldQueens);
    await tester.pumpAndSettle();
    expect(find.text('Yaşlı analar'), findsOneWidget);
    expect(find.text('Kovan 104 · Yayla'), findsOneWidget);
    expect(find.text('2 yaşında'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final mother = await createQueen(_year - 4);
    await createHive('A-123456', queenId: mother.id);
    final queen = await createQueen(
      _year - 3,
      breed: 'Kafkas',
      breedLine: 'Artvin',
      source: QueenSource.certifiedBreeder,
      motherQueenId: mother.id,
    );
    final hive = await createHive('104', queenId: queen.id);

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final router = container.read(routerProvider)
      ..go(AppRoutes.hiveQueen(yayla.id, hive.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.hiveQueenEdit(yayla.id, hive.id));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await _tap(tester, find.text('Mother queen'));
    expect(tester.takeException(), isNull);
    await tester.tapAt(const Offset(180, 20));
    await tester.pumpAndSettle();

    router.go(AppRoutes.oldQueens);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(StatusBadge), findsNWidgets(2));
  });
}

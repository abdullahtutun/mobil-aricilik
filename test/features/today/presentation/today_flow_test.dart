import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
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
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_screen.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/tasks/data/task_repository.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';
import 'package:mobil_arici/features/today/presentation/attention_screen.dart';
import 'package:mobil_arici/features/today/presentation/today_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

const _drug = DrugChoice(
  refDrugId: 'ref-drug-1',
  name: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  doseUnit: DrugDoseUnit.strip,
);

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  AppLanguage language = AppLanguage.turkish,
  String? location,
}) async {
  final container = ProviderContainer.test(overrides: signedIn(db: db));
  container.read(languageProvider.notifier).language = language;
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  if (location != null) {
    container.read(routerProvider).go(location);
    await tester.pumpAndSettle();
  }
  return container;
}

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
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// [label]'lı dikkat karosu (en yakın kart).
Finder _tile(String label) =>
    find.ancestor(of: find.text(label), matching: find.byType(AppCard)).first;

/// Karodaki sayı.
String _tileCount(WidgetTester tester, String label) => tester
    .widgetList<Text>(
      find.descendant(of: _tile(label), matching: find.byType(Text)),
    )
    .first
    .data!;

void main() {
  late AppDatabase db;

  setUpAll(initializeDateFormatting);
  setUp(() => db = openTestDatabase());

  testWidgets('arılık yokken boş durum ve kurulum adımları; buton arılık '
      'formunu açar', (tester) async {
    await _open(tester, db: db);

    expect(find.text('Arılığını ekleyerek başla'), findsOneWidget);
    expect(find.text('KURULUM 0/3'), findsOneWidget);
    for (final step in [
      'Arılığını ekle',
      'Kovanlarını oluştur',
      'İlk muayeneyi yap',
    ]) {
      expect(find.text(step), findsOneWidget);
    }
    // Arılık yokken dikkat ve görev bölümleri yok.
    expect(find.text('Dikkat isteyenler'), findsNothing);
    expect(find.text('Bugünün görevleri'), findsNothing);

    await _tap(tester, find.widgetWithText(BigButton, 'İlk arılığını ekle'));
    expect(find.byType(ApiaryFormScreen), findsOneWidget);
  });

  group('arılık varken', () {
    late Apiary kizilcam;
    late HiveRepository hives;
    late Hive hive101;
    late Hive hive102;
    late Hive hive103;
    late Hive hive104;

    setUp(() async {
      kizilcam = await ApiaryRepository(db)
          .create(orgId: _orgId, name: 'Kızılçam');
      hives = HiveRepository(db);
      Future<Hive> create(String number) => hives.create(
        orgId: _orgId,
        number: number,
        type: HiveType.langstroth,
        apiaryId: kizilcam.id,
      );
      hive101 = await create('101');
      hive102 = await create('102');
      hive103 = await create('103');
      hive104 = await create('104');
    });

    Future<void> inspect(Hive hive, InspectionValues values) =>
        InspectionRepository(db).add(
          orgId: _orgId,
          hiveId: hive.id,
          apiaryId: hive.apiaryId,
          values: values,
        );

    /// Kovanlar dört gruba düşer; 104'ün şerit çıkarma günü dün.
    Future<void> seedAttention() async {
      // Anasız ve zayıf (güç 1).
      await inspect(
        hive101,
        const InspectionValues(queenState: QueenState.none, beeFrames: 4),
      );
      // Zayıf (güç 1).
      await inspect(hive102, const InspectionValues(beeFrames: 2));
      // Oğul eğilimli.
      await inspect(
        hive103,
        const InspectionValues(beeFrames: 9, queenCells: QueenCells.swarm),
      );
      await inspect(hive104, const InspectionValues(beeFrames: 9));
      final now = DateTime.now();
      final treatment = await TreatmentRepository(db).addToHive(
        hive104,
        TreatmentPlan(
          drug: _drug,
          dose: 2,
          startedAt: now.subtract(const Duration(days: 40)),
          plannedRemovalAt: now.add(const Duration(days: 2)),
          withdrawalDays: 0,
        ),
      );
      final tasks = TaskRepository(db);
      final task = (await tasks.findBySource(
        TaskSource.treatment,
        treatment.groupId,
      )).single;
      await tasks.update(
        task.copyWith(dueAt: now.subtract(const Duration(days: 1))),
      );
      // Sönmüş kovan anasız olsa da sayılmaz.
      final dead = await hives.create(
        orgId: _orgId,
        number: '105',
        type: HiveType.langstroth,
        apiaryId: kizilcam.id,
        status: HiveStatus.dead,
      );
      await inspect(
        dead,
        const InspectionValues(queenState: QueenState.none, beeFrames: 1),
      );
    }

    testWidgets('dikkat isteyenler: sayılar, ayrı kovan sayısı; karo '
        'filtreli listeyi, satır kovan kartını açar', (tester) async {
      await seedAttention();
      await _open(tester, db: db);

      expect(find.text('Dikkat isteyenler'), findsOneWidget);
      expect(find.text('4 kovan'), findsOneWidget);
      expect(_tileCount(tester, 'Anasız'), '1');
      expect(_tileCount(tester, 'Zayıf'), '2');
      expect(_tileCount(tester, 'Oğul eğilimli'), '1');
      expect(_tileCount(tester, 'İlacı çıkarılacak'), '1');
      // Kurulum bitti; adımlar görünmez.
      expect(find.textContaining('KURULUM'), findsNothing);

      await _tap(tester, find.text('Zayıf'));
      expect(find.byType(AttentionScreen), findsOneWidget);
      expect(find.text('Zayıf kovanlar'), findsOneWidget);
      expect(find.text('Kovan 101 · Kızılçam'), findsOneWidget);
      expect(find.text('Kovan 102 · Kızılçam'), findsOneWidget);
      expect(find.text('Kovan 103 · Kızılçam'), findsNothing);
      expect(find.textContaining('Güç 1/5 · Son muayene:'), findsNWidgets(2));

      await _tap(tester, find.text('Kovan 102 · Kızılçam'));
      expect(find.byType(HiveCardScreen), findsOneWidget);
    });

    testWidgets('şerit çıkarma görevi Bugün’de tamamlanınca karo düşer; '
        'yeni muayene grubu değiştirir', (tester) async {
      await seedAttention();
      await _open(tester, db: db);

      // Başlık "Bugün"; biri de sekme adı.
      expect(find.text('Bugün'), findsNWidgets(2));
      expect(find.text('Kovan 104 · şerit çıkar'), findsOneWidget);

      // Bugün'deki tek görevin kutusu.
      await _tap(tester, find.byType(Checkbox));
      expect(_tileCount(tester, 'İlacı çıkarılacak'), '0');
      expect(find.text('Kovan 104 · şerit çıkar'), findsNothing);

      // 101'e ana verildi: artık anasız değil.
      await inspect(
        hive101,
        const InspectionValues(queenState: QueenState.seen, beeFrames: 9),
      );
      await tester.pumpAndSettle();
      expect(_tileCount(tester, 'Anasız'), '0');
      expect(_tileCount(tester, 'Zayıf'), '1');
      expect(find.text('2 kovan'), findsOneWidget);
    });

    testWidgets('bugünün görevleri: gecikmiş ve bugünkü görevler arılığa '
        'göre; yarınki yok', (tester) async {
      await inspect(hive101, const InspectionValues(beeFrames: 9));
      final tasks = TaskRepository(db);
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day, 23, 59);
      await tasks.create(
        orgId: _orgId,
        title: 'Zayıflara 1:1 şurup',
        dueAt: today,
        apiaryId: kizilcam.id,
      );
      await tasks.create(
        orgId: _orgId,
        title: 'Kovan 103’e ana ver',
        dueAt: today.subtract(const Duration(days: 3)),
        apiaryId: kizilcam.id,
      );
      await tasks.create(orgId: _orgId, title: 'Malzeme al', dueAt: today);
      await tasks.create(
        orgId: _orgId,
        title: 'Yarınki iş',
        dueAt: today.add(const Duration(days: 1)),
      );
      await _open(tester, db: db);

      expect(find.text('3 görev'), findsOneWidget);
      expect(find.text('KIZILÇAM · 2'), findsOneWidget);
      expect(find.text('ARILIKSIZ · 1'), findsOneWidget);
      expect(find.text('Zayıflara 1:1 şurup'), findsOneWidget);
      expect(find.text('Kovan 103’e ana ver'), findsOneWidget);
      expect(find.textContaining('3 gün gecikti'), findsOneWidget);
      expect(find.text('Malzeme al'), findsOneWidget);
      expect(find.text('Yarınki iş'), findsNothing);
      // Dikkat isteyen yok.
      expect(find.text('Dikkat isteyen kovan yok'), findsOneWidget);
    });

    testWidgets('muayene yokken kurulum 2/3; sıradaki adım arılığı açar', (
      tester,
    ) async {
      await _open(tester, db: db);

      expect(find.text('KURULUM 2/3'), findsOneWidget);
      final semantics = tester.ensureSemantics();
      expect(
        find.bySemanticsLabel('Arılığını ekle: tamamlandı'),
        findsOneWidget,
      );
      semantics.dispose();
      await _tap(tester, find.text('İlk muayeneyi yap'));
      expect(find.byType(ApiaryDetailScreen), findsOneWidget);
    });

    testWidgets('İngilizce metinler', (tester) async {
      await seedAttention();
      await _open(tester, db: db, language: AppLanguage.english);

      expect(find.text('Needs attention'), findsOneWidget);
      expect(find.text('4 hives'), findsOneWidget);
      for (final label in [
        'Queenless',
        'Weak',
        'Swarm signs',
        'Treatment to remove',
      ]) {
        expect(find.text(label), findsOneWidget);
      }
      expect(find.text('Today'), findsNWidgets(2));

      await _tap(tester, find.text('Treatment to remove'));
      expect(find.text('Treatments to remove'), findsOneWidget);
      expect(find.textContaining('Removal due:'), findsOneWidget);
    });

    testWidgets('bilinmeyen dikkat grubu Bugün’e düşer', (tester) async {
      await _open(tester, db: db, location: '/attention/unknown');

      expect(find.byType(AttentionScreen), findsNothing);
      expect(find.byType(TodayScreen), findsOneWidget);
    });

    testWidgets('360dp ekranda senkron hapı tek satır: "Eşitlendi" alt '
        'satıra kaymaz ve kesilmez', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      // Bekleyen kayıt yok: hap "Eşitlendi" der.
      await db.delete(db.outbox).go();

      final container = await _open(tester, db: db);
      final label = tester.renderObject<RenderParagraph>(
        find.descendant(
          of: find.text('Eşitlendi'),
          matching: find.byType(RichText),
        ),
      );
      expect(label.didExceedMaxLines, isFalse);
      expect(label.size.height, lessThan(label.text.style!.fontSize! * 1.5));

      // Eldivende de taşmaz (test yazı tipi Inter'den geniş; sığmazsa sonu
      // kesilir, alt satıra kaymaz).
      container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
      expect(
        tester
            .renderObject<RenderParagraph>(
              find.descendant(
                of: find.text('Eşitlendi'),
                matching: find.byType(RichText),
              ),
            )
            .size
            .height,
        lessThan(label.text.style!.fontSize! * 2),
      );
    });

    testWidgets('360dp ekranda 1.5x yazı ve eldivenle panel ve liste '
        'taşmaz', (tester) async {
      tester.view
        ..physicalSize = const Size(360, 640)
        ..devicePixelRatio = 1;
      tester.platformDispatcher.textScaleFactorTestValue = 1.5;
      addTearDown(tester.view.reset);
      addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
      await seedAttention();

      final container = await _open(tester, db: db);
      container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      await tester.scrollUntilVisible(
        find.text('Kovan 104 · şerit çıkar'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      expect(tester.takeException(), isNull);

      container
          .read(routerProvider)
          .go(AppRoutes.attention(AttentionKind.treatmentRemoval));
      await tester.pumpAndSettle();
      expect(find.text('İlacı çıkarılacak kovanlar'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });
  });
}

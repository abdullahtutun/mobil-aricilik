import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/drug_info.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';
import 'package:mobil_arici/features/health/presentation/drug_form_screen.dart';
import 'package:mobil_arici/features/health/presentation/treatment_form_screen.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/health/presentation/widgets/drug_info_sheet.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/data/inspection_draft_repository.dart';
import 'package:mobil_arici/features/inspections/data/inspection_repository.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_strip.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_media.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_reminder_notifications.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// TR şeridinin ürün bilgisi; GLOBAL ilacın bilgisi yok.
const _stripInfo = DrugInfo(
  refDrugId: 'tr-strip',
  name: 'Amitraz şerit',
  activeIngredient: '500 mg Amitraz',
  indications: 'Varroa mücadelesi',
  usage: {'uygulama_suresi': '4–6 hafta', 'uygulama_sekli': 'Asılır'},
  periods: DrugInfoPeriods(
    suitable: ['Geç sonbahar'],
    avoid: ['Bal akımı süresince'],
  ),
  residue: DrugInfoResidue(
    withdrawal: '0 gün',
    warnings: 'Ballara temas ettirilmemeli',
  ),
);

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  RegionConfig? region,
  FakeMedia? media,
  FakeReminderNotifications? reminders,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db, media: media, reminders: reminders),
      drugInfosProvider.overrideWith((ref) async => {'tr-strip': _stripInfo}),
      if (region != null) regionConfigProvider.overrideWithValue(region),
    ],
  );
  await tester.pumpWidget(
    UncontrolledProviderScope(container: container, child: const App()),
  );
  await tester.pumpAndSettle();
  container.read(routerProvider).go(location);
  await tester.pumpAndSettle();
  return container;
}

Future<void> _tap(WidgetTester tester, Finder finder) async {
  // Kaydırılan listede henüz kurulmamış olabilir.
  if (finder.evaluate().isEmpty) await tester.scrollUntilVisible(finder, 200);
  await tester.ensureVisible(finder);
  await tester.pumpAndSettle();
  await tester.tap(finder);
  await tester.pumpAndSettle();
}

/// Adı [label] olan sayacın [tooltip] butonuna [times] kez dokunur.
Future<void> _step(
  WidgetTester tester,
  String label,
  String tooltip, {
  int times = 1,
}) async {
  final button = find.descendant(
    of: find.widgetWithText(BigStepper, label),
    matching: find.byTooltip(tooltip),
  );
  await tester.ensureVisible(button);
  await tester.pumpAndSettle();
  for (var i = 0; i < times; i++) {
    await tester.tap(button);
    await tester.pump();
  }
  await tester.pumpAndSettle();
}

/// [screen] ekranının listesini [finder] görünene kadar kaydırır; metin
/// alanlarının kendi kaydırıcısı karışmasın.
Future<void> _scrollTo(WidgetTester tester, Finder finder, Type screen) =>
    tester.scrollUntilVisible(
      finder,
      200,
      scrollable: find
          .descendant(
            of: find.byType(screen),
            matching: find.byType(Scrollable),
          )
          .first,
    );

BigStepper _stepper(WidgetTester tester, String label) =>
    tester.widget<BigStepper>(find.widgetWithText(BigStepper, label));

/// Açık seçim sayfasındaki [text]; sayfa generic, `byType` tam tipi arar.
Finder _inSheet(String text) => find.descendant(
  of: find.byWidgetPredicate((widget) => widget is OptionSheet),
  matching: find.text(text),
);

Finder _button(String label) => find.widgetWithText(BigButton, label);

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<BigButton>(_button(label)).onPressed != null;

/// Bugünden [days] gün sonrası, gün başı.
DateTime _today([int days = 0]) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day + days);
}

Future<void> _addRefDrug(
  AppDatabase db,
  String id, {
  required String countryCode,
  required String nameTr,
  required String nameEn,
  required DrugActiveIngredient ingredient,
  required DrugDoseUnit unit,
  int? withdrawalDays,
}) => db
    .into(db.refDrugs)
    .insert(
      RefDrugsCompanion.insert(
        id: id,
        countryCode: countryCode,
        nameTr: nameTr,
        nameEn: nameEn,
        activeIngredient: ingredient,
        doseUnit: unit,
        withdrawalDays: Value(withdrawalDays),
        createdAt: DateTime.utc(2026),
        updatedAt: DateTime.utc(2026),
      ),
    );

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late Apiary yayla;
  late Hive hive;
  late Hive second;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    yayla = await ApiaryRepository(db).create(orgId: _orgId, name: 'Yayla');
    Future<Hive> create(String number, {HiveStatus? status}) => hives.create(
      orgId: _orgId,
      number: number,
      type: HiveType.langstroth,
      apiaryId: yayla.id,
      status: status ?? HiveStatus.active,
    );
    hive = await create('101');
    second = await create('102');
    await create('103', status: HiveStatus.dead);
    await _addRefDrug(
      db,
      'tr-strip',
      countryCode: 'TR',
      nameTr: 'Amitraz şerit',
      nameEn: 'Amitraz strip',
      ingredient: DrugActiveIngredient.amitraz,
      unit: DrugDoseUnit.strip,
    );
    await _addRefDrug(
      db,
      'g-oxalic',
      countryCode: 'GLOBAL',
      nameTr: 'Oksalik asit',
      nameEn: 'Oxalic acid',
      ingredient: DrugActiveIngredient.oxalicAcid,
      unit: DrugDoseUnit.ml,
      withdrawalDays: 0,
    );
  });

  Future<List<Treatment>> liveTreatments() async => [
    for (final row in await db.select(db.treatments).get())
      if (row.deletedAt == null) row,
  ];

  /// [hive]'a bugün başlayan, [removalDays] gün sonra çıkarılacak şerit.
  Future<Treatment> treatHive({int removalDays = 42}) =>
      TreatmentRepository(db).addToHive(
        hive,
        TreatmentPlan(
          drug: const DrugChoice(
            refDrugId: 'tr-strip',
            name: 'Amitraz şerit',
            activeIngredient: DrugActiveIngredient.amitraz,
            doseUnit: DrugDoseUnit.strip,
          ),
          dose: 2,
          startedAt: DateTime.now(),
          plannedRemovalAt: _today(removalDays).add(const Duration(hours: 12)),
          withdrawalDays: 0,
          batchNo: '24-118',
        ),
      );

  group('İlaç uygulaması', () {
    testWidgets('karttan açılır; ilaç seçilene kadar Kaydet kapalı; TR '
        'profilinde TR listesi ve GLOBAL liste; şeritte çıkarma 42 gün sonra '
        'önerilir; kayıt yazılır, Geri al siler', (tester) async {
      final format = DateFormat.yMMMd('en');
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      await _tap(tester, find.byIcon(Icons.more_vert_rounded));
      await _tap(tester, find.text('Apply treatment'));
      expect(find.byType(TreatmentFormScreen), findsOneWidget);
      expect(find.text('Hive 101'), findsOneWidget);
      expect(find.text('Whole apiary · 2'), findsOneWidget);
      expect(_enabled(tester, 'Save'), isFalse);

      await _tap(tester, _button('Choose drug'));
      expect(_inSheet('Amitraz strip'), findsOneWidget);
      expect(_inSheet('Oxalic acid'), findsOneWidget);
      expect(_inSheet('Add a new drug'), findsOneWidget);
      await _tap(tester, _inSheet('Amitraz strip'));

      expect(find.text('Active ingredient: Amitraz'), findsOneWidget);
      expect(find.text('Change'), findsOneWidget);
      expect(_stepper(tester, 'Dose per hive (strip)').value, 1);
      expect(_stepper(tester, 'Withdrawal period (days)').value, 0);
      expect(find.text(format.format(_today(42))), findsOneWidget);
      expect(find.text('Until ${format.format(_today(42))}'), findsOneWidget);
      expect(find.text('no withdrawal after removal'), findsOneWidget);

      await tester.enterText(
        find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is LabeledField && w.label == 'Batch no',
          ),
          matching: find.byType(TextField),
        ),
        '24-118',
      );
      await _step(tester, 'Dose per hive (strip)', 'Increase');
      await _step(tester, 'Withdrawal period (days)', 'Increase', times: 3);
      expect(find.text('Until ${format.format(_today(45))}'), findsOneWidget);
      expect(find.text('removal + 3 days withdrawal'), findsOneWidget);
      // Tek kovanda toplam yazılmaz.
      expect(find.textContaining('Total'), findsNothing);

      await _tap(tester, _button('Save'));
      expect(find.text('Treatment saved for hive 101'), findsOneWidget);
      expect(find.byType(TreatmentFormScreen), findsNothing);

      final treatment = (await liveTreatments()).single;
      expect(treatment.hiveId, hive.id);
      expect(treatment.refDrugId, 'tr-strip');
      expect(treatment.productName, 'Amitraz strip');
      expect(treatment.batchNo, '24-118');
      expect(treatment.dose, 2);
      expect(treatment.withdrawalDays, 3);
      expect(
        treatment.plannedRemovalAt!.toLocal(),
        _today(42).add(const Duration(hours: 12)),
      );

      await _tap(tester, find.text('Undo'));
      expect(await liveTreatments(), isEmpty);
    });

    testWidgets('listede bilgisi olan ilacın satırında bilgi butonu; '
        'Bakanlık kaynağı ve bölümler; kapatınca listeye dönülür', (
      tester,
    ) async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
      );
      await _tap(tester, _button('Choose drug'));
      // Yalnız TR şeridinin bilgisi var.
      expect(find.byTooltip('Drug information'), findsOneWidget);

      await _tap(tester, find.byTooltip('Drug information'));
      expect(find.byType(DrugInfoSheet), findsOneWidget);
      Finder inInfo(String text) => find.descendant(
        of: find.byType(DrugInfoSheet),
        matching: find.text(text),
      );
      expect(inInfo('Amitraz şerit'), findsOneWidget);
      expect(
        inInfo('Source: Ministry of Agriculture and Forestry of Türkiye'),
        findsOneWidget,
      );
      expect(inInfo('500 mg Amitraz'), findsOneWidget);
      expect(inInfo('Varroa mücadelesi'), findsOneWidget);
      expect(inInfo('How to apply'), findsOneWidget);
      expect(inInfo('Asılır'), findsOneWidget);
      expect(inInfo('Duration'), findsOneWidget);
      expect(inInfo('SUITABLE PERIODS'), findsOneWidget);
      expect(inInfo('Geç sonbahar'), findsOneWidget);
      expect(inInfo('DO NOT USE'), findsOneWidget);
      expect(inInfo('Bal akımı süresince'), findsOneWidget);
      expect(inInfo('0 gün'), findsOneWidget);
      expect(inInfo('Ballara temas ettirilmemeli'), findsOneWidget);
      // Uygulama şekli süreden önce yazılır.
      expect(
        tester.getTopLeft(inInfo('How to apply')).dy,
        lessThan(tester.getTopLeft(inInfo('Duration')).dy),
      );

      await _tap(tester, _button('Close'));
      expect(find.byType(DrugInfoSheet), findsNothing);
      expect(_inSheet('Amitraz strip'), findsOneWidget);
      // Bilgi butonu ilacı seçmez.
      expect(find.text('Change'), findsNothing);
      await _tap(tester, _inSheet('Amitraz strip'));
      expect(find.byType(DrugInfoSheet), findsNothing);
      expect(find.text('Change'), findsOneWidget);
    });

    testWidgets('arılığın tümü: aktif kovan sayısı, toplam doz ve "N kovana '
        'kaydet"; her aktif kovana yazılır, Geri al hepsini siler', (
      tester,
    ) async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
      );
      await _tap(tester, find.text('Whole apiary · 2'));
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Amitraz strip'));
      await _step(tester, 'Dose per hive (strip)', 'Increase');

      expect(find.text('Total 4 strip'), findsOneWidget);
      expect(_button('Save to 2 hives'), findsOneWidget);

      await _tap(tester, _button('Save to 2 hives'));
      expect(find.text('Treatment saved for 2 hives'), findsOneWidget);
      final saved = await liveTreatments();
      expect({for (final t in saved) t.hiveId}, {hive.id, second.id});
      expect({for (final t in saved) t.dose}, {2});

      await _tap(tester, find.text('Undo'));
      expect(await liveTreatments(), isEmpty);
    });

    testWidgets('tek seferlik ilaçta çıkarma yok; tarih seçilip yeniden '
        'kaldırılabilir', (tester) async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
      );
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Oxalic acid'));

      expect(find.text('None'), findsOneWidget);
      expect(find.text('Single application; tap to set'), findsOneWidget);
      expect(find.text('no withdrawal'), findsOneWidget);
      expect(find.text('No removal (single application)'), findsNothing);

      await _tap(tester, find.text('None'));
      await _tap(tester, find.text('OK'));
      expect(find.text('No removal (single application)'), findsOneWidget);
      expect(
        find.text(DateFormat.yMMMd('en').format(_today(1))),
        findsOneWidget,
      );

      await _tap(tester, find.text('No removal (single application)'));
      expect(find.text('None'), findsOneWidget);

      await _tap(tester, _button('Save'));
      expect((await liveTreatments()).single.plannedRemovalAt, isNull);
    });

    testWidgets('diğer bölgede TR listesi görünmez; yeni ilaç eklenir, '
        'seçilir ve uygulamaya bağlanır', (tester) async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
        region: resolveRegionConfig('DE'),
      );
      await _tap(tester, _button('Choose drug'));
      expect(_inSheet('Amitraz strip'), findsNothing);
      expect(_inSheet('Oxalic acid'), findsOneWidget);

      await _tap(tester, _inSheet('Add a new drug'));
      expect(find.byType(DrugFormScreen), findsOneWidget);
      expect(_enabled(tester, 'Add drug'), isFalse);
      await tester.enterText(
        find.descendant(
          of: find.byWidgetPredicate(
            (w) => w is LabeledField && w.label == 'Name',
          ),
          matching: find.byType(TextField),
        ),
        'Thymovar',
      );
      await _tap(tester, find.text('Thymol'));
      expect(_enabled(tester, 'Add drug'), isFalse);
      await _tap(tester, find.text('strip'));
      await _step(
        tester,
        'Withdrawal period on the label (days)',
        'Increase',
        times: 2,
      );
      await _tap(tester, _button('Add drug'));

      expect(find.byType(DrugFormScreen), findsNothing);
      expect(find.text('Thymovar'), findsOneWidget);
      expect(
        find.text('Active ingredient: Thymol · your drug'),
        findsOneWidget,
      );
      expect(_stepper(tester, 'Withdrawal period (days)').value, 2);

      await _tap(tester, _button('Save'));
      final drug = await db.select(db.drugs).getSingle();
      expect(drug.name, 'Thymovar');
      expect(drug.orgId, _orgId);
      expect(drug.doseUnit, DrugDoseUnit.strip);
      final treatment = (await liveTreatments()).single;
      expect(treatment.drugId, drug.id);
      expect(treatment.refDrugId, isNull);
      expect(treatment.activeIngredient, DrugActiveIngredient.thymol);

      // Eklenen ilaç listede en üstte.
      _container(tester)
          .read(routerProvider)
          .go(AppRoutes.hiveTreat(yayla.id, hive.id));
      await tester.pumpAndSettle();
      await _tap(tester, _button('Choose drug'));
      expect(
        tester.getTopLeft(_inSheet('Thymovar')).dy,
        lessThan(tester.getTopLeft(_inSheet('Oxalic acid')).dy),
      );
    });

    testWidgets('aktif olmayan kovanda İlaç uygula yok', (tester) async {
      await hives.setStatus(hive.id, HiveStatus.dead);
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));

      expect(_button('Apply treatment'), findsNothing);
    });
  });

  group('Bekleme süresi kilidi (muayene)', () {
    Finder superChip() => find.text('Super added');

    Future<Set<InspectionAction>> draftActions() async =>
        (await InspectionDraftRepository(db).find(hive.id))?.values.actions ??
        const {};

    testWidgets('ilacı olmayan kovanda bal katı doğrudan seçilir', (
      tester,
    ) async {
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveInspect(yayla.id, hive.id),
      );

      await _tap(tester, superChip());

      expect(find.byType(CriticalLockCard), findsNothing);
      expect(await draftActions(), {InspectionAction.superAdded});
    });

    testWidgets('bekleme süresinde: tam genişlikte kırmızı kilit; Vazgeç '
        'kat vermez; gerekçe seçilmeden geçilemez; gerekçeyle muayeneye '
        'yazılır', (tester) async {
      final treatment = await treatHive();
      final format = DateFormat.yMMMd('en');
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveInspect(yayla.id, hive.id),
      );

      await _tap(tester, superChip());
      expect(find.byType(CriticalLockCard), findsOneWidget);
      // Kilit kartında başlık ve açıklama tek cümle gibi akar.
      expect(
        find.textContaining(
          'In withdrawal period. Hive 101 is being treated with Amitraz '
          'şerit. No honey super should be added before '
          '${format.format(_today(42))}',
          findRichText: true,
        ),
        findsOneWidget,
      );
      expect(find.text('42 days'), findsOneWidget);
      expect(
        find.text('${DateFormat.MMMd('en').format(_today())} · 24-118'),
        findsOneWidget,
      );
      // Kart diyaloğun neredeyse tam genişliğinde.
      final width = tester.getSize(find.byType(CriticalLockCard)).width;
      final screen = tester.view.physicalSize / tester.view.devicePixelRatio;
      expect(width, greaterThan(screen.width * 0.8));
      expect(_enabled(tester, 'Save anyway'), isFalse);

      await _tap(tester, _button("Cancel, don't add super"));
      expect(find.byType(CriticalLockCard), findsNothing);
      expect(await draftActions(), isEmpty);

      await _tap(tester, superChip());
      await _tap(tester, find.text('Drug removed early'));
      expect(_enabled(tester, 'Save anyway'), isTrue);
      await _tap(tester, _button('Save anyway'));
      expect(await draftActions(), {InspectionAction.superAdded});
      expect(
        find.text(
          'Honey super added during the withdrawal period: Drug removed early',
        ),
        findsOneWidget,
      );

      await _tap(tester, _button('Save'));
      final inspection = (await InspectionRepository(db)
          .latestByHive(hive.id))!;
      expect(inspection.actions, {InspectionAction.superAdded});
      expect(
        inspection.withdrawalOverride,
        WithdrawalOverride(
          treatmentId: treatment.id,
          reason: WithdrawalOverrideReason.removedEarly,
        ),
      );
    });

    testWidgets('bal katı kaldırılınca gerekçe de kalkar', (tester) async {
      await treatHive();
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveInspect(yayla.id, hive.id),
      );
      await _tap(tester, superChip());
      await _tap(tester, find.text('Drug removed early'));
      await _tap(tester, _button('Save anyway'));

      await _tap(tester, superChip());

      expect(await draftActions(), isEmpty);
      expect(
        (await InspectionDraftRepository(db).find(hive.id))?.withdrawalOverride,
        isNull,
      );
      expect(find.textContaining('withdrawal period:'), findsNothing);
    });

    testWidgets('bekleme süresi bitmiş ilaç kilitlemez', (tester) async {
      await TreatmentRepository(db).addToHive(
        hive,
        TreatmentPlan(
          drug: const DrugChoice(
            refDrugId: 'g-oxalic',
            name: 'Oxalic acid',
            activeIngredient: DrugActiveIngredient.oxalicAcid,
            doseUnit: DrugDoseUnit.ml,
          ),
          dose: 5,
          startedAt: _today(-10),
          withdrawalDays: 7,
        ),
      );
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveInspect(yayla.id, hive.id),
      );

      await _tap(tester, superChip());

      expect(find.byType(CriticalLockCard), findsNothing);
      expect(await draftActions(), {InspectionAction.superAdded});
    });
  });

  group('Rotasyon, reçete, hatırlatıcı, kart ve geçmiş', () {
    /// Arılıkta [daysAgo] gün önce başlamış, kendi grubunda bir uygulama.
    Future<void> pastTreatment(
      DrugActiveIngredient ingredient, {
      required int daysAgo,
    }) => TreatmentRepository(db).addToHive(
      second,
      TreatmentPlan(
        drug: DrugChoice(
          refDrugId: 'g-oxalic',
          name: 'Eski',
          activeIngredient: ingredient,
          doseUnit: DrugDoseUnit.ml,
        ),
        dose: 5,
        startedAt: _today(-daysAgo),
        withdrawalDays: 0,
      ),
    );

    Finder rotationWarning() =>
        find.textContaining('Same active ingredient.', findRichText: true);

    testWidgets('arılıkta son 2 uygulama aynı etken maddeyse uyarır; farklı '
        'etken maddede ve tek tekrarda uyarmaz', (tester) async {
      await pastTreatment(DrugActiveIngredient.oxalicAcid, daysAgo: 90);
      await pastTreatment(DrugActiveIngredient.amitraz, daysAgo: 60);
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
      );
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Amitraz strip'));
      expect(rotationWarning(), findsNothing);

      await pastTreatment(DrugActiveIngredient.amitraz, daysAgo: 30);
      await tester.pumpAndSettle();
      await _scrollTo(tester, rotationWarning(), TreatmentFormScreen);
      expect(
        find.textContaining(
          'Same active ingredient. The last 2 treatments in this apiary were '
          'also Amitraz.',
          findRichText: true,
        ),
        findsOneWidget,
      );

      await _tap(tester, find.text('Change'));
      await _tap(tester, _inSheet('Oxalic acid'));
      expect(rotationWarning(), findsNothing);
    });

    testWidgets('reçete fotoğrafı arılığın tümünde açılan kovanın '
        'uygulamasına bağlanır, gruptaki diğer kovanın geçmişinde de '
        'görünür; Geri al kaydı ve dosyayı siler', (tester) async {
      final media = FakeMedia();
      final container = await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
        media: media,
      );
      await _tap(tester, find.text('Whole apiary · 2'));
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Amitraz strip'));
      await _tap(tester, _button('Add prescription / invoice photo'));
      expect(media.camera.photoCount, 1);
      expect(find.text('Prescription photo added'), findsOneWidget);
      expect(media.fileNames, hasLength(1));

      await _tap(tester, _button('Save to 2 hives'));
      final treatments = await liveTreatments();
      final photo = await db.select(db.media).getSingle();
      expect(
        photo.treatmentId,
        treatments.firstWhere((t) => t.hiveId == hive.id).id,
      );
      expect(photo.hiveId, hive.id);

      container.read(routerProvider).go(AppRoutes.hive(yayla.id, second.id));
      await tester.pumpAndSettle();
      final row = find.text('Treatment · Amitraz strip');
      await tester.scrollUntilVisible(row, 200);
      expect(
        find.descendant(
          of: find.ancestor(of: row, matching: find.byType(TimelineTile)),
          matching: find.byType(MediaStrip),
        ),
        findsOneWidget,
      );

      container.read(routerProvider).go(AppRoutes.hive(yayla.id, hive.id));
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Undo'));
      expect(await liveTreatments(), isEmpty);
      expect((await db.select(db.media).getSingle()).deletedAt, isNotNull);
      expect(media.fileNames, isEmpty);
    });

    testWidgets('kaydetmeden çıkılırsa ya da Kaldır’a basılırsa fotoğraf '
        'dosyası silinir', (tester) async {
      final media = FakeMedia();
      final container = await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
        media: media,
      );
      await _tap(tester, _button('Add prescription / invoice photo'));
      expect(media.fileNames, hasLength(1));
      await _tap(tester, find.text('Remove'));
      expect(media.fileNames, isEmpty);
      expect(_button('Add prescription / invoice photo'), findsOneWidget);

      await _tap(tester, _button('Add prescription / invoice photo'));
      expect(media.fileNames, hasLength(1));
      container.read(routerProvider).go(AppRoutes.hive(yayla.id, hive.id));
      await tester.pumpAndSettle();
      expect(media.fileNames, isEmpty);
      expect(await db.select(db.media).get(), isEmpty);
    });

    testWidgets('çıkarma günü sabahına görev açılır ve bildirimi kurulur; '
        'Geri al ikisini de kaldırır; tek seferlikte açılmaz', (tester) async {
      final reminders = FakeReminderNotifications();
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
        reminders: reminders,
      );
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Amitraz strip'));
      await _tap(tester, _button('Save'));

      final task = (await db.select(db.tasks).get()).single;
      final treatment = (await liveTreatments()).single;
      expect(task.source, TaskSource.treatment);
      expect(task.sourceId, treatment.groupId);
      expect(task.hiveId, hive.id);
      expect(task.apiaryId, yayla.id);
      expect(task.assignedTo, testUser.id);
      final reminder = reminders.scheduled.values.single;
      expect(reminder.id, reminderNotificationId(task.id));
      expect(reminder.at, _today(42).add(const Duration(hours: 9)));
      expect(reminder.title, 'Hive 101 · remove strips');
      expect(reminder.body, 'Yayla · treatment');
      expect(reminders.channelName, 'Reminders');

      await _tap(tester, find.text('Undo'));
      expect(reminders.scheduled, isEmpty);
      expect((await db.select(db.tasks).getSingle()).deletedAt, isNotNull);

      _container(tester)
          .read(routerProvider)
          .go(AppRoutes.hiveTreat(yayla.id, hive.id));
      await tester.pumpAndSettle();
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Oxalic acid'));
      await _tap(tester, _button('Save'));
      expect(reminders.scheduled, isEmpty);
      expect(await db.select(db.tasks).get(), hasLength(1));
    });

    testWidgets('bildirim izni yoksa kayıt yine yazılır ve nedeni söylenir', (
      tester,
    ) async {
      final reminders = FakeReminderNotifications()
        ..permitted = false
        ..grantOnRequest = false;
      await _open(
        tester,
        db: db,
        location: AppRoutes.hiveTreat(yayla.id, hive.id),
        reminders: reminders,
      );
      await _tap(tester, _button('Choose drug'));
      await _tap(tester, _inSheet('Amitraz strip'));
      await _tap(tester, _button('Save'));

      expect(await liveTreatments(), hasLength(1));
      expect(
        find.text('Notifications are off; no removal reminder was set.'),
        findsOneWidget,
      );
    });

    testWidgets('kovan kartında aktif ilaç karosu ve geçmişte ilaç satırı', (
      tester,
    ) async {
      await _open(tester, db: db, location: AppRoutes.hive(yayla.id, hive.id));
      Finder tile() => find.ancestor(
        of: find.text('ACTIVE TREATMENT'),
        matching: find.byType(SummaryTile),
      );
      expect(
        find.descendant(of: tile(), matching: find.text('None')),
        findsOneWidget,
      );

      await treatHive();
      await tester.pumpAndSettle();

      expect(
        find.descendant(of: tile(), matching: find.text('42 days left')),
        findsOneWidget,
      );
      expect(
        find.descendant(
          of: tile(),
          matching: find.text('Amitraz · no honey super'),
        ),
        findsOneWidget,
      );
      expect(tester.widget<SummaryTile>(tile()).status, AppStatus.critical);

      final row = find.text('Treatment · Amitraz şerit');
      await tester.scrollUntilVisible(row, 200);
      expect(
        find.text(
          'Batch 24-118 · 2 strip · removal '
          '${DateFormat.MMMd('en').format(_today(42))}',
        ),
        findsOneWidget,
      );
    });
  });

  testWidgets('Türkçe metinler', (tester) async {
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _tap(tester, find.byIcon(Icons.more_vert_rounded));
    await _tap(tester, find.text('İlaç uygula'));
    expect(find.text('İlaç uygulaması'), findsOneWidget);
    expect(find.text('Kovan 101'), findsOneWidget);
    expect(find.text('Arılığın tümü · 2'), findsOneWidget);
    await _tap(tester, _button('İlaç seç'));
    expect(_inSheet('Oksalik asit'), findsOneWidget);
    expect(_inSheet('Yeni ilaç ekle'), findsOneWidget);
    await _tap(tester, find.byTooltip('İlaç bilgisi'));
    expect(find.text('Kaynak: T.C. Tarım ve Orman Bakanlığı'), findsOneWidget);
    expect(find.text('ETKEN MADDE'), findsOneWidget);
    expect(find.text('NE İÇİN KULLANILIR'), findsOneWidget);
    expect(find.text('KULLANIM VE SIKLIK'), findsOneWidget);
    expect(find.text('Uygulama şekli'), findsOneWidget);
    expect(find.text('Uygulama süresi'), findsOneWidget);
    expect(find.text('UYGUN DÖNEMLER'), findsOneWidget);
    expect(find.text('KULLANILMAMASI GEREKEN DÖNEMLER'), findsOneWidget);
    expect(find.text('ARINMA SÜRESİ'), findsOneWidget);
    expect(find.text('UYARILAR'), findsOneWidget);
    await _tap(tester, _button('Kapat'));
    await _tap(tester, _inSheet('Amitraz şerit'));
    expect(find.text('Etken madde: Amitraz'), findsOneWidget);
    expect(find.text('Değiştir'), findsOneWidget);
    expect(find.text('Parti no'), findsOneWidget);
    expect(find.text('Başlangıç'), findsOneWidget);
    expect(
      find.widgetWithText(BigStepper, 'Doz / kovan (şerit)'),
      findsOneWidget,
    );
    expect(
      find.widgetWithText(BigStepper, 'Bekleme süresi (gün)'),
      findsOneWidget,
    );
    expect(find.text('ÇIKARMA'), findsOneWidget);
    expect(find.text('BAL KATI YOK'), findsOneWidget);
    expect(find.text('çıkarmadan sonra bekleme yok'), findsOneWidget);
    expect(find.text('Çıkarma yok (tek seferlik)'), findsOneWidget);
    await _tap(tester, find.text('Arılığın tümü · 2'));
    expect(find.text('Toplam 2 şerit'), findsOneWidget);
    await _tap(tester, _button('2 kovana kaydet'));
    expect(find.text('2 kovana ilaç kaydedildi'), findsOneWidget);
    // Bildirim kapanır.
    await tester.pump(const Duration(seconds: 7));
    await tester.pumpAndSettle();

    container.read(routerProvider).go(AppRoutes.hiveInspect(yayla.id, hive.id));
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Kat verildi'));
    expect(
      find.textContaining(
        'Bekleme süresinde. Kovan 101: Amitraz şerit uygulanıyor.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(find.text('KALAN'), findsOneWidget);
    expect(find.text('42 gün'), findsOneWidget);
    expect(find.text('UYGULAMA'), findsOneWidget);
    expect(find.text('YİNE DE KAYDETMEK İÇİN NEDEN SEÇ'), findsOneWidget);
    expect(find.text('İlaç erken çıkarıldı'), findsOneWidget);
    expect(find.text('Kat satılmayacak (kendi kullanım/yem)'), findsOneWidget);
    expect(_button('Vazgeç, kat verme'), findsOneWidget);
    await _tap(tester, find.text('Kat satılmayacak (kendi kullanım/yem)'));
    await _tap(tester, _button('Yine de kaydet'));
    expect(
      find.text(
        'Bekleme süresinde bal katı verildi: Kat satılmayacak (kendi '
        'kullanım/yem)',
      ),
      findsOneWidget,
    );
  });

  testWidgets('Türkçe metinler: aktif ilaç, geçmiş, rotasyon ve reçete', (
    tester,
  ) async {
    final reminders = FakeReminderNotifications();
    await treatHive();
    await TreatmentRepository(db).addToHive(
      second,
      TreatmentPlan(
        drug: const DrugChoice(
          refDrugId: 'tr-strip',
          name: 'Amitraz şerit',
          activeIngredient: DrugActiveIngredient.amitraz,
          doseUnit: DrugDoseUnit.strip,
        ),
        dose: 2,
        startedAt: _today(-60),
        withdrawalDays: 0,
      ),
    );
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
      reminders: reminders,
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('AKTİF İLAÇ'), findsOneWidget);
    expect(find.text('42 gün kaldı'), findsOneWidget);
    expect(find.text('Amitraz · bal katı yok'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('İlaç · Amitraz şerit'), 200);
    expect(
      find.textContaining('Parti 24-118 · 2 şerit · çıkarma'),
      findsOneWidget,
    );

    container.read(routerProvider).go(AppRoutes.hiveTreat(yayla.id, hive.id));
    await tester.pumpAndSettle();
    await _tap(tester, _button('İlaç seç'));
    await _tap(tester, _inSheet('Amitraz şerit'));
    await _scrollTo(
      tester,
      find.textContaining('Aynı etken madde.', findRichText: true),
      TreatmentFormScreen,
    );
    expect(
      find.textContaining(
        'Aynı etken madde. Bu arılıkta son 2 uygulama da Amitraz. Direnç '
        'riskine karşı farklı etken madde düşün.',
        findRichText: true,
      ),
      findsOneWidget,
    );
    expect(
      find.text('O sabah hatırlatılır; değiştirmek için dokun'),
      findsOneWidget,
    );
    await _tap(tester, _button('Reçete / fatura fotoğrafı ekle'));
    expect(find.text('Reçete fotoğrafı eklendi'), findsOneWidget);
    expect(find.text('Kaldır'), findsOneWidget);

    await _tap(tester, _button('Kaydet'));
    // Önceki uygulamanın çıkarma görevinin hatırlatması da kurulu.
    expect(reminders.scheduled, hasLength(2));
    expect(
      {for (final r in reminders.scheduled.values) (r.title, r.body)},
      {('Kovan 101 · şerit çıkar', 'Yayla · ilaç')},
    );
    expect(reminders.channelName, 'Hatırlatmalar');
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle kart, uyarı ve reçete '
      'taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await treatHive();
    await TreatmentRepository(db).addToHive(
      second,
      TreatmentPlan(
        drug: const DrugChoice(
          refDrugId: 'tr-strip',
          name: 'Amitraz şerit',
          activeIngredient: DrugActiveIngredient.amitraz,
          doseUnit: DrugDoseUnit.strip,
        ),
        dose: 2,
        startedAt: _today(-60),
        withdrawalDays: 0,
      ),
    );

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('ACTIVE TREATMENT'), 200);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Treatment · Amitraz şerit'),
      200,
    );
    expect(tester.takeException(), isNull);

    container.read(routerProvider).go(AppRoutes.hiveTreat(yayla.id, hive.id));
    await tester.pumpAndSettle();
    await _tap(tester, _button('Choose drug'));
    await _tap(tester, _inSheet('Amitraz strip'));
    await _scrollTo(
      tester,
      find.textContaining('Same active ingredient.', findRichText: true),
      TreatmentFormScreen,
    );
    expect(tester.takeException(), isNull);
    await _tap(tester, _button('Add prescription / invoice photo'));
    expect(find.text('Prescription photo added'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await treatHive();

    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.hive(yayla.id, hive.id),
    );
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    final router = container.read(routerProvider)
      ..go(AppRoutes.hiveTreat(yayla.id, hive.id));
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Whole apiary · 2'));
    await _tap(tester, _button('Choose drug'));
    expect(tester.takeException(), isNull);
    await _tap(tester, find.byTooltip('Drug information'));
    expect(tester.takeException(), isNull);
    await _tap(tester, _button('Close'));
    expect(tester.takeException(), isNull);
    await _tap(tester, _inSheet('Amitraz strip'));
    await _scrollTo(tester, find.text('NO HONEY SUPER'), TreatmentFormScreen);
    expect(tester.takeException(), isNull);

    await _tap(tester, find.text('Change'));
    await _tap(tester, _inSheet('Add a new drug'));
    expect(tester.takeException(), isNull);
    await _scrollTo(
      tester,
      find.text('Withdrawal period on the label (days)'),
      DrugFormScreen,
    );
    expect(tester.takeException(), isNull);

    router.go(AppRoutes.hiveInspect(yayla.id, hive.id));
    await tester.pumpAndSettle();
    await _tap(tester, find.text('Super added'));
    expect(find.byType(CriticalLockCard), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      _button('Save anyway'),
      200,
      scrollable: find.descendant(
        of: find.byType(Dialog),
        matching: find.byType(Scrollable),
      ),
    );
    expect(tester.takeException(), isNull);
  });
}

ProviderContainer _container(WidgetTester tester) =>
    ProviderScope.containerOf(tester.element(find.byType(App)));

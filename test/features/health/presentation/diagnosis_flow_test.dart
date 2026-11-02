import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:flutter/material.dart';
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
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/health/data/diagnosis_repository.dart';
import 'package:mobil_arici/features/health/domain/diagnosis.dart';
import 'package:mobil_arici/features/health/domain/diagnosis_rules.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_providers.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_result_screen.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_screen.dart';
import 'package:mobil_arici/features/health/presentation/quarantine_hive_screen.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_card_screen.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_organization_service.dart';
import '../../../helpers/fake_team_service.dart';
import '../../../helpers/fake_url_launcher.dart';
import '../../../helpers/test_database.dart';

final String _orgId = testOrganization.id;

/// Uygulamayla gelen kural tablosu, diskten.
final DiagnosisTable _table = parseDiagnosisTable(
  jsonDecode(File(DiagnosisRepository.assetPath).readAsStringSync()),
);

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required AppDatabase db,
  required String location,
  FakeUrlLauncher? urlLauncher,
  RegionConfig? region,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(db: db, urlLauncher: urlLauncher),
      // Asset okuması gerçek G/Ç; sahte zamanda bitmez.
      diagnosisTableProvider.overrideWith((ref) async => _table),
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

Future<void> _go(ProviderContainer container, WidgetTester tester, String to) {
  container.read(routerProvider).go(to);
  return tester.pumpAndSettle();
}

Finder _button(String label) => find.widgetWithText(BigButton, label);

void _tall(WidgetTester tester) {
  tester.view
    ..physicalSize = const Size(800, 2400)
    ..devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  late AppDatabase db;
  late HiveRepository hives;
  late String apiaryId;
  late Hive hive101;
  late Hive hive102;

  setUpAll(initializeDateFormatting);

  setUp(() async {
    db = openTestDatabase();
    hives = HiveRepository(db);
    await addMember(db, userId: testUser.id, role: MembershipRole.owner);
    apiaryId = (await ApiaryRepository(
      db,
    ).create(orgId: _orgId, name: 'Kızılçam')).id;
    [hive101, hive102] = await hives.createMany(
      orgId: _orgId,
      apiaryId: apiaryId,
      numbers: ['101', '102'],
      type: HiveType.langstroth,
    );
  });

  Future<void> setRole(MembershipRole role) =>
      (db.update(db.memberships)..where((t) => t.userId.equals(testUser.id)))
          .write(MembershipsCompanion(role: Value(role)));

  testWidgets('bilgi bankasından açılır; seçilen belirtilere göre olası '
      'hastalıklar, çok eşleşen önce; seçim kaldırılınca boşalır', (
    tester,
  ) async {
    _tall(tester);
    await _open(tester, db: db, location: AppRoutes.knowledge);

    await _tap(tester, find.text('Diagnosis helper'));
    expect(find.byType(DiagnosisScreen), findsOneWidget);
    expect(find.text('Pick a sign to see possible diseases here.'), findsOne);
    expect(
      find.text(
        'This is a first assessment; a vet or laboratory gives the final '
        'diagnosis.',
      ),
      findsOneWidget,
    );

    await _tap(tester, find.text('Spotty, patchy brood'));
    expect(find.text('American foulbrood'), findsOneWidget);
    expect(find.text('Chalkbrood'), findsOneWidget);
    expect(find.text('Nosema'), findsNothing);
    expect(find.text('Matching signs: 1/4'), findsOneWidget);
    expect(find.text('Matching signs: 1/3'), findsOneWidget);
    expect(find.text('Notifiable'), findsOneWidget);
    // Eşit sayıda eşleşmede payı büyük olan (1/3) önce.
    expect(
      tester.getTopLeft(find.text('Chalkbrood')).dy,
      lessThan(tester.getTopLeft(find.text('American foulbrood')).dy),
    );

    await _tap(tester, find.text('Sunken, perforated brood cappings'));
    expect(find.text('Matching signs: 2/4'), findsOneWidget);
    expect(
      tester.getTopLeft(find.text('American foulbrood')).dy,
      lessThan(tester.getTopLeft(find.text('Chalkbrood')).dy),
    );

    await _tap(tester, find.text('Spotty, patchy brood'));
    await _tap(tester, find.text('Sunken, perforated brood cappings'));
    await _tap(tester, find.text('Bees crawling, unable to fly'));
    expect(find.text('Nosema'), findsOneWidget);
    expect(find.text('American foulbrood'), findsNothing);
    expect(find.text('Notifiable'), findsNothing);
  });

  testWidgets('ihbarı mecburi: TR kurumu ve Ara; kovanı karantinaya alır, '
      'kovan kartı açılır; Geri al kaldırır', (tester) async {
    _tall(tester);
    final urlLauncher = FakeUrlLauncher();
    await _open(
      tester,
      db: db,
      location: AppRoutes.diagnosisResult('american_foulbrood'),
      urlLauncher: urlLauncher,
    );

    expect(find.byType(DiagnosisResultScreen), findsOneWidget);
    expect(find.text('American foulbrood'), findsOneWidget);
    expect(
      find.textContaining('Notifiable disease.', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.text('Provincial/district directorate of agriculture and forestry'),
      findsOneWidget,
    );

    await _tap(tester, _button('Call 174'));
    expect(urlLauncher.opened, [Uri.parse('tel:174')]);

    await _tap(tester, _button('Quarantine a hive'));
    expect(find.byType(QuarantineHiveScreen), findsOneWidget);
    expect(find.text('Hive 101'), findsOneWidget);
    expect(find.text('Hive 102'), findsOneWidget);
    expect(find.text('Kızılçam'), findsNWidgets(2));

    await tester.enterText(find.byType(TextField), '102');
    await tester.pumpAndSettle();
    expect(find.text('Hive 101'), findsNothing);

    await _tap(tester, find.text('Hive 102'));
    expect(find.byType(HiveCardScreen), findsOneWidget);
    expect(find.text('Quarantined'), findsOneWidget);
    expect(find.text('Suspected: American foulbrood'), findsOneWidget);
    expect(
      find.text("Don't share its equipment, frames or honey with other hives."),
      findsOneWidget,
    );
    expect(find.text('Hive 102 quarantined'), findsOneWidget);
    final quarantined = (await hives.findById(hive102.id))!;
    expect(quarantined.quarantined, isTrue);
    expect(quarantined.quarantineDisease, 'american_foulbrood');
    expect(quarantined.status, HiveStatus.active);
    expect((await hives.findById(hive101.id))!.quarantined, isFalse);

    await _tap(tester, find.text('Undo'));
    expect((await hives.findById(hive102.id))!.quarantined, isFalse);
    expect(find.text('Quarantined'), findsNothing);
  });

  testWidgets('kovan kartında karantinadan çıkarılır, Geri al geri koyar; '
      'seçim listesinde karantinadaki kovan yazılı', (tester) async {
    _tall(tester);
    await hives.quarantine(hive101.id, disease: 'american_foulbrood');
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.diagnosisQuarantine('american_foulbrood'),
    );
    expect(find.text('Quarantined'), findsOneWidget);

    await _go(container, tester, AppRoutes.hive(apiaryId, hive101.id));
    expect(find.text('Quarantined'), findsOneWidget);
    expect(find.textContaining('Since '), findsOneWidget);

    await _tap(tester, _button('End quarantine'));
    expect(find.text('Hive 101 is out of quarantine'), findsOneWidget);
    expect(find.text('Quarantined'), findsNothing);
    final ended = (await hives.findById(hive101.id))!;
    expect(ended.quarantined, isFalse);
    expect(ended.quarantinedAt, isNull);

    await _tap(tester, find.text('Undo'));
    final restored = (await hives.findById(hive101.id))!;
    expect(restored.quarantined, isTrue);
    expect(restored.quarantineDisease, 'american_foulbrood');
  });

  testWidgets('tabloda olmayan hastalıkla karantinada kovanın kartında '
      'yalnız "Karantinada" yazar', (tester) async {
    _tall(tester);
    await hives.quarantine(hive101.id, disease: 'removed_disease');
    await _open(tester, db: db, location: AppRoutes.hive(apiaryId, hive101.id));

    expect(find.text('Quarantined'), findsOneWidget);
    expect(find.textContaining('Suspected:'), findsNothing);
  });

  testWidgets('diğer bölgede yerel otorite, Ara yok; ihbarı mecburi olmayan '
      'hastalıkta kurum ve karantina yok', (tester) async {
    _tall(tester);
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.diagnosisResult('american_foulbrood'),
      region: resolveRegionConfig('DE'),
    );

    expect(find.text('Local veterinary authority'), findsOneWidget);
    expect(find.textContaining('Call '), findsNothing);
    expect(_button('Quarantine a hive'), findsOneWidget);

    await _go(container, tester, AppRoutes.diagnosisResult('chalkbrood'));
    expect(find.text('Chalkbrood'), findsOneWidget);
    expect(find.text('WHAT TO DO'), findsOneWidget);
    expect(find.text('AUTHORITY'), findsNothing);
    expect(_button('Quarantine a hive'), findsNothing);

    await _go(container, tester, AppRoutes.diagnosisResult('yok'));
    expect(find.text('Disease not found'), findsOneWidget);
  });

  testWidgets('viewer karantinaya alamaz ve çıkaramaz', (tester) async {
    _tall(tester);
    await setRole(MembershipRole.viewer);
    await hives.quarantine(hive101.id, disease: 'american_foulbrood');
    final urlLauncher = FakeUrlLauncher();
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.diagnosisResult('american_foulbrood'),
      urlLauncher: urlLauncher,
    );
    expect(_button('Quarantine a hive'), findsNothing);
    // Aramak kayıt değil; viewer da arar.
    urlLauncher.available = false;
    await _tap(tester, _button('Call 174'));
    expect(find.text("Couldn't start the call"), findsOneWidget);

    await _go(container, tester, AppRoutes.hive(apiaryId, hive101.id));
    expect(find.text('Quarantined'), findsOneWidget);
    expect(_button('End quarantine'), findsNothing);
  });

  testWidgets('Türkçe metinler', (tester) async {
    _tall(tester);
    await hives.quarantine(hive101.id, disease: 'american_foulbrood');
    final container = await _open(
      tester,
      db: db,
      location: AppRoutes.diagnosis,
    );
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    expect(find.text('Teşhis yardımcısı'), findsOneWidget);
    expect(find.text('GÖRDÜĞÜN BELİRTİLER'), findsOneWidget);
    await _tap(tester, find.text('Kibrit testinde larva uzayıp sünüyor'));
    expect(find.text('Amerikan yavru çürüklüğü'), findsOneWidget);
    expect(find.text('İhbarı mecburi'), findsOneWidget);
    expect(find.text('Eşleşen belirti: 1/4'), findsOneWidget);

    await _tap(tester, find.text('Amerikan yavru çürüklüğü'));
    expect(find.text('İl/ilçe tarım ve orman müdürlüğü'), findsOneWidget);
    expect(_button('Ara: 174'), findsOneWidget);
    expect(_button('Kovanı karantinaya al'), findsOneWidget);

    await _go(container, tester, AppRoutes.hive(apiaryId, hive101.id));
    expect(find.text('Karantinada'), findsOneWidget);
    expect(find.text('Şüphe: Amerikan yavru çürüklüğü'), findsOneWidget);
    expect(_button('Karantinadan çıkar'), findsOneWidget);
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    await hives.quarantine(hive101.id, disease: 'american_foulbrood');

    final container = await _open(tester, db: db, location: AppRoutes.more);
    container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await _go(container, tester, AppRoutes.diagnosis);
    await _tap(tester, find.text('Düzensiz, alacalı yavru'));
    expect(tester.takeException(), isNull);
    for (final location in [
      AppRoutes.diagnosisResult('american_foulbrood'),
      AppRoutes.diagnosisQuarantine('american_foulbrood'),
      AppRoutes.hive(apiaryId, hive101.id),
    ]) {
      await _go(container, tester, location);
      expect(tester.takeException(), isNull, reason: location);
    }
  });
}

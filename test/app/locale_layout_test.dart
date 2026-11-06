import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

import '../helpers/business_seed.dart';
import '../helpers/fake_auth_service.dart';
import '../helpers/fake_organization_service.dart';
import '../helpers/test_database.dart';

/// Her arayüz dilinde ana ekranlar 360dp genişlikte, 1.5x yazı ve eldiven
/// modunda taşmadan açılıyor mu. Uzun dillerde (Almanca, Rusça) butonlar,
/// rozetler ve üst çubuk metinleri taşmaya en yatkın yerlerdir. İngilizce
/// her ekranın kendi akış testinde zaten bu koşulda denenir.
void main() {
  final languages = [
    for (final language in AppLanguage.selectable)
      if (language != AppLanguage.english) language,
  ];

  for (final language in languages) {
    testWidgets(
      '${language.nativeName}: 360dp, 1.5x yazı ve eldivenle taşmaz',
      (tester) async {
        tester.view
          ..physicalSize = const Size(360, 640)
          ..devicePixelRatio = 1;
        tester.platformDispatcher.textScaleFactorTestValue = 1.5;
        addTearDown(tester.view.reset);
        addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

        final db = openTestDatabase();
        final orgId = testOrganization.id;
        await insertOrganizationRow(db);
        final apiary = await ApiaryRepository(db)
            .create(orgId: orgId, name: 'Yayla arılığı');
        final hiveRepository = HiveRepository(db);
        final hive = await hiveRepository.createMany(
          orgId: orgId,
          apiaryId: apiary.id,
          numbers: [for (var n = 101; n <= 112; n++) '$n'],
          type: HiveType.langstroth,
          source: HiveSource.package,
        );
        final first = hive.first;

        final container = ProviderContainer.test(overrides: signedIn(db: db));
        addTearDown(container.dispose);
        container.read(languageProvider.notifier).language = language;
        container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
        await tester.pumpWidget(
          UncontrolledProviderScope(container: container, child: const App()),
        );
        await tester.pumpAndSettle();
        expect(tester.takeException(), isNull, reason: 'açılış');
        // Farsça sağdan sola çizilir; satırlar, boşluklar ve oklar döner.
        expect(
          Directionality.of(tester.element(find.byType(Scaffold).first)),
          language == AppLanguage.persian
              ? TextDirection.rtl
              : TextDirection.ltr,
        );

        final routes = [
          AppRoutes.today,
          AppRoutes.apiaries,
          AppRoutes.apiary(apiary.id),
          AppRoutes.apiaryEdit(apiary.id),
          AppRoutes.hivesBulk(apiary.id),
          AppRoutes.hiveNew(apiary.id),
          AppRoutes.hive(apiary.id, first.id),
          AppRoutes.hiveEdit(apiary.id, first.id),
          AppRoutes.hiveInspect(apiary.id, first.id),
          AppRoutes.hiveQueen(apiary.id, first.id),
          AppRoutes.hiveQueenNew(apiary.id, first.id),
          AppRoutes.hiveVarroa(apiary.id, first.id),
          AppRoutes.hiveTreat(apiary.id, first.id, wholeApiary: true),
          AppRoutes.hiveFeed(apiary.id, first.id, wholeApiary: true),
          AppRoutes.hiveLabels(apiary.id),
          AppRoutes.apiaryHarvest(apiary.id),
          AppRoutes.apiaryWeather(apiary.id),
          AppRoutes.tasks,
          AppRoutes.taskNew,
          AppRoutes.more,
          AppRoutes.settings,
          AppRoutes.offlineMaps,
          AppRoutes.sync,
          AppRoutes.reports,
          AppRoutes.season,
          AppRoutes.oldQueens,
          AppRoutes.team,
          AppRoutes.business,
          AppRoutes.businessEdit,
          AppRoutes.feedback,
          AppRoutes.documents,
          AppRoutes.documentNew,
          AppRoutes.inventory,
          AppRoutes.inventoryNew(InventoryCategory.consumable),
          AppRoutes.inventoryShopping,
          AppRoutes.lots,
          AppRoutes.finance,
          AppRoutes.financeNew(TransactionKind.expense),
          AppRoutes.customers,
          AppRoutes.customerNew,
          AppRoutes.rearing,
          AppRoutes.rearingNew,
          AppRoutes.migrations,
          AppRoutes.migrationNew,
          AppRoutes.knowledge,
          AppRoutes.diagnosis,
          AppRoutes.calculators,
          AppRoutes.subsidies,
        ];
        final router = container.read(routerProvider);
        for (final route in routes) {
          router.go(route);
          await tester.pumpAndSettle();
          final error = tester.takeException();
          expect(error, isNull, reason: '$route: $error');
        }
      },
    );
  }
}

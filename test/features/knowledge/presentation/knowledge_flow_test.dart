import 'dart:convert';
import 'dart:io';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/health/presentation/diagnosis_screen.dart';
import 'package:mobil_arici/features/knowledge/data/knowledge_repository.dart';
import 'package:mobil_arici/features/knowledge/presentation/calculators_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_article_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_category_screen.dart';
import 'package:mobil_arici/features/knowledge/presentation/knowledge_screen.dart';

import '../../../helpers/fake_auth_service.dart';
import '../../../helpers/fake_knowledge.dart';
import '../../../helpers/fake_url_launcher.dart';

/// Örnek içerikte Kasım makalesi var; ay kartı bu güne göre.
final _november = Clock.fixed(DateTime(2026, 11, 2, 9));

Future<ProviderContainer> _open(
  WidgetTester tester, {
  required String location,
  FakeKnowledge? knowledge,
  FakeUrlLauncher? urlLauncher,
  RegionConfig? region,
}) async {
  final container = ProviderContainer.test(
    overrides: [
      ...signedIn(knowledge: knowledge, urlLauncher: urlLauncher),
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

/// İndirilmiş paket: uygulamayla gelenden yeni sürüm, telefonda kayıtlı.
void _downloaded(FakeKnowledge knowledge, Map<String, String> files) => File(
  '${knowledge.directory.path}/${KnowledgeRepository.packageFile}',
).writeAsStringSync(jsonEncode({'format': 1, 'version': 2, 'files': files}));

const _summaryEn =
    'Check winter stores, reduce entrances, final varroa treatment, '
    'unite weak colonies.';
const _summaryTr =
    'Kışlık stok kontrolü, giriş daraltma, son varroa mücadelesi, '
    'zayıfları birleştirme.';

void main() {
  setUpAll(initializeDateFormatting);

  testWidgets("TR'de Daha fazla'dan açılır: ay kartı, teşhis, kategoriler, "
      'hesaplayıcılar, TR rozetli mevzuat; güncellemeye bakılır', (
    tester,
  ) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final knowledge = FakeKnowledge();

    await withClock(_november, () async {
      await _open(tester, location: AppRoutes.more, knowledge: knowledge);
      await _tap(tester, find.text('Knowledge base'));
      expect(find.byType(KnowledgeScreen), findsOneWidget);
      expect(knowledge.requested, ['manifest.json']);

      for (final text in [
        'To do this month',
        _summaryEn,
        'Diagnosis helper',
        'Pick a sign, see possible causes',
        'Diseases and pests atlas',
        '1 topic',
        'Technical guides',
        'Calculators',
        'Regulation summaries',
        'TR',
        'My first year',
        'All content opens offline',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.textContaining('NOVEMBER · T'), findsOneWidget);

      await _tap(tester, find.text('Calculators'));
      expect(find.byType(CalculatorsScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      await _tap(tester, find.text('Diagnosis helper'));
      expect(find.byType(DiagnosisScreen), findsOneWidget);
      await tester.pageBack();
      await tester.pumpAndSettle();
      expect(find.byType(KnowledgeScreen), findsOneWidget);

      await _tap(tester, find.text('To do this month'));
      expect(find.byType(KnowledgeArticleScreen), findsOneWidget);
      expect(find.text('To do in November'), findsOneWidget);
      expect(find.text('Winter stores'), findsOneWidget);
      expect(find.text('Seasonal calendar'), findsOneWidget);
    });
  });

  testWidgets('arama: Türkçe harf farkı yok, sonuç makaleyi açar, sonuçsuzda '
      'boş durum', (tester) async {
    final container = await _open(tester, location: AppRoutes.knowledge);
    container.read(languageProvider.notifier).language = AppLanguage.turkish;
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'KIREC');
    await tester.pumpAndSettle();
    expect(find.text('Kireç hastalığı'), findsOneWidget);
    expect(find.text('Hastalık ve zararlı atlası'), findsNothing);

    await tester.enterText(find.byType(TextField), 'kafes ana');
    await tester.pumpAndSettle();
    expect(find.text('Ana verme'), findsOneWidget);
    expect(find.text('Kireç hastalığı'), findsNothing);
    await _tap(tester, find.text('Ana verme'));
    expect(find.byType(KnowledgeArticleScreen), findsOneWidget);
    expect(find.text('Kafesle verme'), findsOneWidget);

    await _go(container, tester, AppRoutes.knowledge);
    await tester.enterText(find.byType(TextField), 'zzz');
    await tester.pumpAndSettle();
    expect(find.text('Sonuç yok'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('Hastalık ve zararlı atlası'), findsOneWidget);
  });

  testWidgets('kategori makaleleri listeler; boş kategori, tanınmayan '
      'kategori ve makale boş durum gösterir', (tester) async {
    final container = await _open(tester, location: AppRoutes.knowledge);

    await _tap(tester, find.text('Diseases and pests atlas'));
    expect(find.byType(KnowledgeCategoryScreen), findsOneWidget);
    expect(find.text('Chalkbrood'), findsOneWidget);
    await _tap(tester, find.text('Chalkbrood'));
    expect(find.text('Signs'), findsOneWidget);

    await _go(container, tester, AppRoutes.knowledge);
    await _tap(tester, find.text('Regulation summaries'));
    expect(find.text('No articles yet'), findsOneWidget);

    await _go(container, tester, '/more/knowledge/category/recipes');
    expect(find.text('No articles yet'), findsOneWidget);

    await _go(container, tester, AppRoutes.knowledgeArticle('yok'));
    expect(find.text('Article not found'), findsOneWidget);
  });

  testWidgets('diğer bölgede mevzuat ve TR etiketli makale yok', (
    tester,
  ) async {
    await withClock(_november, () async {
      await _open(
        tester,
        location: AppRoutes.knowledge,
        region: resolveRegionConfig('DE'),
      );
      expect(find.text('Regulation summaries'), findsNothing);
      // Kasım makalesi TR etiketli; GLOBAL takvim makalesi yok.
      expect(find.text('To do this month'), findsNothing);
      expect(find.text('Diseases and pests atlas'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'winter');
      await tester.pumpAndSettle();
      expect(find.text('No results'), findsOneWidget);
      await tester.enterText(find.byType(TextField), 'chalk');
      await tester.pumpAndSettle();
      expect(find.text('Chalkbrood'), findsOneWidget);
    });
  });

  testWidgets('güney yarımkürede Mayıs, Kuzey Kasım takvimini gösterir', (
    tester,
  ) async {
    final knowledge = FakeKnowledge();
    _downloaded(knowledge, {
      'en/autumn.md':
          '---\nid: autumn\nregion: GLOBAL\ncategory: calendar\n'
          'months: [11]\ntitle: Late autumn\nsummary: Prepare for winter.\n'
          '---\nText.\n',
    });
    await withClock(Clock.fixed(DateTime(2027, 5, 3)), () async {
      await _open(
        tester,
        location: AppRoutes.knowledge,
        knowledge: knowledge,
        region: resolveRegionConfig('AU', latitude: -33.9),
      );
      expect(find.text('MAY · SOUTHERN HEMISPHERE'), findsOneWidget);
      expect(find.text('Prepare for winter.'), findsOneWidget);
    });
  });

  testWidgets('indirilen yeni paket uygulamayla geleni geçer; link '
      'tarayıcıda açılır', (tester) async {
    final knowledge = FakeKnowledge();
    final launcher = FakeUrlLauncher();
    _downloaded(knowledge, {
      'en/fresh.md':
          '---\nid: fresh\nregion: GLOBAL\ncategory: guides\n'
          'title: Fresh guide\nsummary: From the update.\n---\n'
          '[Source](https://example.com/source)\n',
    });
    await _open(
      tester,
      location: AppRoutes.knowledge,
      knowledge: knowledge,
      urlLauncher: launcher,
    );
    expect(find.text('0 topics'), findsOneWidget);

    await _tap(tester, find.text('Technical guides'));
    expect(find.text('Fresh guide'), findsOneWidget);
    expect(find.text('Introducing a queen'), findsNothing);

    await _tap(tester, find.text('Fresh guide'));
    await _tap(tester, find.text('Source', findRichText: true));
    expect(launcher.opened, [Uri.parse('https://example.com/source')]);

    launcher.available = false;
    await _tap(tester, find.text('Source', findRichText: true));
    expect(find.text("Couldn't open the link"), findsOneWidget);
  });

  testWidgets('Türkçe metinler', (tester) async {
    tester.view
      ..physicalSize = const Size(800, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);

    await withClock(_november, () async {
      final container = await _open(tester, location: AppRoutes.more);
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();
      expect(find.text('Bilgi bankası'), findsOneWidget);

      await _go(container, tester, AppRoutes.knowledge);
      for (final text in [
        'Bilgi bankası',
        'KASIM · TÜRKİYE',
        'Bu ay yapılacaklar',
        _summaryTr,
        'Teşhis yardımcısı',
        'Belirtiyi seç, olası nedenleri gör',
        'Hastalık ve zararlı atlası',
        '1 konu',
        'Teknik rehberler',
        'Bölme, ana verme, birleştirme, kışlatma',
        'Hesaplayıcılar',
        'Şurup, ilaç dozu, ana takvimi, verim',
        'Mevzuat özetleri',
        'Yönetmelik, gezginci, bal tebliği',
        'İlk yılım',
        'Yeni başlayanlar için adım adım',
        'Tüm içerik internetsiz açılır',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.text('Yakında'), findsNothing);
      final hint = tester.widget<TextField>(find.byType(TextField));
      expect(hint.decoration?.hintText, 'Kireç hastalığı, ana verme…');

      await _go(container, tester, '/more/knowledge/category/regulations');
      expect(find.text('Henüz makale yok'), findsOneWidget);
      expect(
        find.text('Bu bölümün içeriği güncellemeyle gelecek.'),
        findsOneWidget,
      );

      await _go(
        container,
        tester,
        AppRoutes.knowledgeArticle('kirec-hastaligi'),
      );
      expect(find.text('Kireç hastalığı'), findsOneWidget);
      expect(find.text('Belirtiler'), findsOneWidget);
    });
  });

  testWidgets('360dp ekranda 1.5x yazı ve eldivenle taşmaz', (tester) async {
    tester.view
      ..physicalSize = const Size(360, 640)
      ..devicePixelRatio = 1;
    tester.platformDispatcher.textScaleFactorTestValue = 1.5;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);

    await withClock(_november, () async {
      final container = await _open(tester, location: AppRoutes.more);
      container.read(appearanceProvider.notifier).setGloveMode(enabled: true);
      container.read(languageProvider.notifier).language = AppLanguage.turkish;
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      for (final location in [
        AppRoutes.knowledge,
        '/more/knowledge/category/atlas',
        '/more/knowledge/category/regulations',
        AppRoutes.knowledgeArticle('kasim-yapilacaklar'),
      ]) {
        await _go(container, tester, location);
        expect(tester.takeException(), isNull, reason: location);
      }

      await _go(container, tester, AppRoutes.knowledge);
      await tester.enterText(find.byType(TextField), 'ana');
      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });
}

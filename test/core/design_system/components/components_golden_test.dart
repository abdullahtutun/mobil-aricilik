import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_arici/core/design_system/gallery/component_samples.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Galerideki her bileşen bölümünü (dört tema alt alta) bir golden ile
/// karşılaştırır. Güncellemek için:
/// `flutter test --update-goldens test/core/design_system/components`
void main() {
  group('Bileşen goldenları', () {
    for (final component in GalleryComponent.values) {
      testWidgets('${component.name}: açık, koyu, güneş, eldiven', (
        tester,
      ) async {
        tester.view
          ..physicalSize = const Size(400, 4000)
          ..devicePixelRatio = 1;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(
          MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(const AppearanceSettings()),
            locale: const Locale('tr'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: SingleChildScrollView(
                child: RepaintBoundary(
                  child: GallerySection(component: component),
                ),
              ),
            ),
          ),
        );
        // Görseller (ör. AppLogo) testte kendiliğinden çözülmez; gerçek
        // zamanda önceden yüklenmezse golden boş çıkar.
        await tester.runAsync(() async {
          for (final element in find.byType(Image).evaluate()) {
            await precacheImage((element.widget as Image).image, element);
          }
        });
        await tester.pump();

        await expectLater(
          find.byType(GallerySection),
          matchesGoldenFile('goldens/${_snakeCase(component.name)}.png'),
        );
      });
    }
  });
}

String _snakeCase(String camel) =>
    camel.replaceAllMapped(RegExp('[A-Z]'), (m) => '_${m[0]!.toLowerCase()}');

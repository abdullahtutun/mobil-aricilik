import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/gallery/component_gallery_screen.dart';
import 'package:mobil_arici/features/settings/presentation/developer_menu_screen.dart';

import '../helpers/fake_auth_service.dart';

void main() {
  group('Geliştirici menüsü', () {
    testWidgets("prod'da giriş ikonu yok, /dev rotası da açılmaz", (
      tester,
    ) async {
      final container = ProviderContainer.test(
        overrides: [
          flavorProvider.overrideWithValue(Flavor.prod),
          ...signedIn(),
        ],
      );
      await tester.pumpWidget(
        UncontrolledProviderScope(container: container, child: const App()),
      );
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.developer_mode_rounded), findsNothing);

      container.read(routerProvider).go(AppRoutes.componentGallery);
      await tester.pumpAndSettle();

      expect(find.byType(ComponentGalleryScreen), findsNothing);
      expect(find.byType(DeveloperMenuScreen), findsNothing);
    });

    testWidgets("dev'de Bugün'den bileşen galerisine ulaşılır", (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            flavorProvider.overrideWithValue(Flavor.dev),
            ...signedIn(),
          ],
          child: const App(),
        ),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.developer_mode_rounded));
      await tester.pumpAndSettle();
      expect(find.byType(DeveloperMenuScreen), findsOneWidget);

      await tester.tap(find.text('Component gallery'));
      await tester.pumpAndSettle();
      expect(find.byType(ComponentGalleryScreen), findsOneWidget);
      expect(find.byType(GallerySection), findsWidgets);
    });
  });
}

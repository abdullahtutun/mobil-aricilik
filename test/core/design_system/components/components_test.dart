import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/design_system/design_system.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

Widget _app(
  Widget child, {
  AppearanceSettings settings = const AppearanceSettings(),
}) {
  return MaterialApp(
    theme: AppTheme.light(settings),
    locale: const Locale('tr'),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: Center(child: child)),
  );
}

void main() {
  group('BigButton', () {
    testWidgets('yükseklik büyük saha hedefi; eldivende yoğunluk eklenmez', (
      tester,
    ) async {
      for (final (settings, height) in [
        (const AppearanceSettings(), AppTouchTargets.standard.fieldLarge),
        (
          const AppearanceSettings(gloveMode: true),
          AppTouchTargets.glove.fieldLarge,
        ),
      ]) {
        await tester.pumpWidget(
          _app(
            BigButton(label: 'Kaydet', onPressed: () {}),
            settings: settings,
          ),
        );
        // MaterialApp tema değişimini animasyonla yapar.
        await tester.pumpAndSettle();

        expect(tester.getSize(find.byType(BigButton)).height, height);
      }
    });
  });

  group('ChoiceChipGroup', () {
    const options = [
      ChoiceChipOption(value: 'a', label: 'A'),
      ChoiceChipOption(value: 'b', label: 'B'),
    ];

    Future<Set<String>?> tapChip(
      WidgetTester tester,
      String label, {
      required Set<String> selected,
      required bool multiSelect,
    }) async {
      Set<String>? changed;
      await tester.pumpWidget(
        _app(
          ChoiceChipGroup(
            options: options,
            selected: selected,
            multiSelect: multiSelect,
            onChanged: (value) => changed = value,
          ),
        ),
      );
      await tester.tap(find.text(label));
      return changed;
    }

    testWidgets('tek seçimde yenisi eskisinin yerine geçer', (tester) async {
      final changed = await tapChip(
        tester,
        'B',
        selected: {'a'},
        multiSelect: false,
      );
      expect(changed, {'b'});
    });

    testWidgets('tek seçimde seçiliye dokunmak seçimi kaldırır', (
      tester,
    ) async {
      final changed = await tapChip(
        tester,
        'A',
        selected: {'a'},
        multiSelect: false,
      );
      expect(changed, isEmpty);
    });

    testWidgets('çok seçimde ekler ve çıkarır', (tester) async {
      expect(await tapChip(tester, 'B', selected: {'a'}, multiSelect: true), {
        'a',
        'b',
      });
      expect(
        await tapChip(tester, 'A', selected: {'a', 'b'}, multiSelect: true),
        {'b'},
      );
    });

    testWidgets('seçili chip renk dışında onay ikonuyla da ayrılır', (
      tester,
    ) async {
      await tapChip(tester, 'A', selected: {'a'}, multiSelect: false);

      expect(find.byIcon(Icons.check_rounded), findsOneWidget);
    });
  });

  group('BigStepper', () {
    Finder button(IconData icon) => find.widgetWithIcon(IconButton, icon);

    testWidgets('+ ve − adım kadar değiştirir', (tester) async {
      final values = <int>[];
      await tester.pumpWidget(
        _app(
          BigStepper(
            label: 'Arılı çerçeve',
            value: 4,
            step: 2,
            onChanged: values.add,
          ),
        ),
      );

      await tester.tap(button(Icons.add_rounded));
      await tester.tap(button(Icons.remove_rounded));

      expect(values, [6, 2]);
    });

    testWidgets('sınırda ilgili buton pasifleşir', (tester) async {
      Future<(bool, bool)> enabledAt(int value) async {
        await tester.pumpWidget(
          _app(
            BigStepper(
              label: 'Arılı çerçeve',
              value: value,
              max: 10,
              onChanged: (_) {},
            ),
          ),
        );
        bool enabled(IconData icon) =>
            tester.widget<IconButton>(button(icon)).onPressed != null;
        return (enabled(Icons.remove_rounded), enabled(Icons.add_rounded));
      }

      expect(await enabledAt(0), (false, true));
      expect(await enabledAt(5), (true, true));
      expect(await enabledAt(10), (true, false));
    });
  });

  group('HiveTile', () {
    testWidgets('ekran okuyucu numara, güç, ana rengi ve uyarıyı okur', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          HiveTile(
            number: '12',
            strength: 3,
            queenColor: QueenMarkColor.red,
            alertStatus: AppStatus.critical,
            alertLabel: 'Anasız',
            onTap: () {},
          ),
        ),
      );

      expect(
        find.bySemanticsLabel(
          'Kovan 12, Güç 3/5, Ana arı rengi kırmızı, Anasız',
        ),
        findsOneWidget,
      );
      semantics.dispose();
    });

    testWidgets('puanlanmamış ve ana rengi olmayan kovanda yalnızca numara', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(_app(const HiveTile(number: '7')));

      expect(find.bySemanticsLabel('Kovan 7'), findsOneWidget);
      semantics.dispose();
    });
  });

  group('AppStatus', () {
    test('her durumun ikonu farklı; renk tek başına kalmaz', () {
      final icons = AppStatus.values.map((s) => s.icon).toSet();
      expect(icons, hasLength(AppStatus.values.length));
    });

    test('durum rengi palet tokenından gelir', () {
      const c = AppColors.light;
      expect(AppStatus.good.colorIn(c), c.statusGood);
      expect(AppStatus.warning.colorIn(c), c.statusWarning);
      expect(AppStatus.critical.colorIn(c), c.statusCritical);
      expect(AppStatus.info.colorIn(c), c.statusInfo);
    });
  });
}

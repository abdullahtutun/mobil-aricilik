import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart'
    show QueenMarkColor;

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
    testWidgets('yükseklik buton hedefi (60); eldivende yoğunluk eklenmez', (
      tester,
    ) async {
      for (final (settings, height) in [
        (const AppearanceSettings(), AppTouchTargets.standard.button),
        (
          const AppearanceSettings(gloveMode: true),
          AppTouchTargets.glove.button,
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

    testWidgets('expanded false ise içeriği kadar geniş', (tester) async {
      await tester.pumpWidget(
        _app(BigButton(label: 'Ekle', onPressed: () {}, expanded: false)),
      );

      final size = tester.getSize(find.byType(BigButton));
      expect(size.width, lessThan(tester.view.physicalSize.width / 2));
      expect(size.height, AppTouchTargets.standard.button);
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

    testWidgets('öneri dolu değil, geçmiş ikonuyla çizilir ve ekran '
        'okuyucuya söylenir; dokunmak onu onaylar', (tester) async {
      Set<String>? changed;
      await tester.pumpWidget(
        _app(
          ChoiceChipGroup(
            options: options,
            selected: const {'a'},
            suggested: true,
            onChanged: (value) => changed = value,
          ),
        ),
      );

      expect(find.byIcon(Icons.history_rounded), findsOneWidget);
      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(
        tester.getSemantics(find.text('A')),
        matchesSemantics(
          label: 'A',
          hint: 'Önceki kayıttan',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );

      await tester.tap(find.text('A'));
      expect(changed, {'a'});

      await tester.tap(find.text('B'));
      expect(changed, {'b'});
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

    testWidgets('değer girilmemişse − en küçüğü, + bir adım fazlasını verir; '
        'ekran okuyucu "Girilmedi" der', (tester) async {
      final values = <int>[];
      await tester.pumpWidget(
        _app(
          BigStepper(
            label: 'Ballı çerçeve',
            value: null,
            max: 10,
            onChanged: values.add,
          ),
        ),
      );

      expect(find.text('–'), findsOneWidget);
      final semantics = tester.getSemantics(find.byType(BigStepper));
      expect(semantics.value, 'Girilmedi');
      expect(semantics.increasedValue, '1');
      expect(semantics.decreasedValue, '0');

      await tester.tap(button(Icons.remove_rounded));
      await tester.tap(button(Icons.add_rounded));

      expect(values, [0, 1]);
    });

    testWidgets('öneri soluk çizilir; altında ikon ve kelimeyle yazar', (
      tester,
    ) async {
      Future<Color?> numberColor({required bool suggested}) async {
        await tester.pumpWidget(
          _app(
            BigStepper(
              label: 'Arılı çerçeve',
              value: 8,
              suggested: suggested,
              onChanged: (_) {},
            ),
          ),
        );
        return tester.widget<Text>(find.text('8')).style?.color;
      }

      final normal = await numberColor(suggested: false);
      expect(find.text('Önceki kayıttan'), findsNothing);

      final suggested = await numberColor(suggested: true);
      expect(suggested, AppColors.light.textSecondary);
      expect(suggested, isNot(normal));
      expect(find.text('Önceki kayıttan'), findsOneWidget);
      expect(find.byIcon(Icons.history_rounded), findsOneWidget);
      expect(
        tester.getSemantics(find.byType(BigStepper)).hint,
        'Önceki kayıttan',
      );
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

    testWidgets('kritik uyarıda karo kritik zeminde, kelime noktaların '
        'yerinde', (tester) async {
      await tester.pumpWidget(
        _app(
          const HiveTile(
            number: '103',
            strength: 2,
            alertStatus: AppStatus.critical,
            alertLabel: 'Anasız',
          ),
        ),
      );

      expect(find.text('Anasız'), findsOneWidget);
      expect(find.byType(StrengthDots), findsNothing);
      final card = tester.widget<Material>(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(Material),
        ),
      );
      expect(card.color, AppColors.light.statusCriticalContainer);
    });

    testWidgets('uyarı kritik değilse kelime görünmez, noktalar kalır', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const HiveTile(
            number: '102',
            strength: 2,
            alertStatus: AppStatus.warning,
            alertLabel: 'Zayıf',
          ),
        ),
      );

      expect(find.text('Zayıf'), findsNothing);
      expect(find.byIcon(AppStatus.warning.icon), findsOneWidget);
      expect(find.byType(StrengthDots), findsOneWidget);
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

  group('StrengthDots', () {
    Future<List<Color?>> fills(WidgetTester tester, int? strength) async {
      await tester.pumpWidget(_app(StrengthDots(strength: strength)));
      return [
        for (final box in tester.widgetList<DecoratedBox>(
          find.descendant(
            of: find.byType(StrengthDots),
            matching: find.byType(DecoratedBox),
          ),
        ))
          (box.decoration as BoxDecoration).color,
      ];
    }

    testWidgets('dolu noktalar puana göre renklenir, kalanı soluk', (
      tester,
    ) async {
      const c = AppColors.light;
      expect(await fills(tester, 2), [
        c.statusWarning,
        c.statusWarning,
        c.surfaceContainer,
        c.surfaceContainer,
        c.surfaceContainer,
      ]);
      expect((await fills(tester, 3)).first, c.primary);
      expect(await fills(tester, 5), List.filled(5, c.statusGood));
      expect(await fills(tester, null), List.filled(5, c.surfaceContainer));
    });
  });

  group('StatusBadge', () {
    testWidgets('durumun açık zemininde, yazı ve ikon durum renginde', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(const StatusBadge(status: AppStatus.good, label: 'Güçlü')),
      );
      const c = AppColors.light;

      final box = tester.widget<DecoratedBox>(
        find.descendant(
          of: find.byType(StatusBadge),
          matching: find.byType(DecoratedBox),
        ),
      );
      expect((box.decoration as BoxDecoration).color, c.statusGoodContainer);
      expect(
        tester.widget<Text>(find.text('Güçlü')).style!.color,
        c.statusGood,
      );
      expect(
        tester.widget<Icon>(find.byIcon(AppStatus.good.icon)).color,
        c.statusGood,
      );
    });
  });

  group('CriticalLockCard', () {
    testWidgets('kilit ikonu, başlık ve açıklama tek cümle; ekran okuyucu '
        'kendiliğinden okur', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          const CriticalLockCard(
            title: 'Bekleme süresinde.',
            message: 'Kat verilmemeli.',
          ),
        ),
      );

      expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
      expect(
        find.text('Bekleme süresinde. Kat verilmemeli.', findRichText: true),
        findsOneWidget,
      );
      expect(
        tester.getSemantics(
          find
              .descendant(
                of: find.byType(CriticalLockCard),
                matching: find.byType(Semantics),
              )
              .first,
        ),
        isSemantics(isLiveRegion: true),
      );
      semantics.dispose();
    });
  });

  group('showConfirmDialog', () {
    Future<bool?> answer(WidgetTester tester, String button) async {
      bool? result;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => result = await showConfirmDialog(
                context,
                title: 'Silinsin mi?',
                message: 'Geri alınamaz.',
                confirmLabel: 'Sil',
              ),
              child: const Text('Aç'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Aç'));
      await tester.pumpAndSettle();
      expect(find.text('Silinsin mi?'), findsOneWidget);
      await tester.tap(find.text(button));
      await tester.pumpAndSettle();
      return result;
    }

    testWidgets('onaylanırsa true', (tester) async {
      expect(await answer(tester, 'Sil'), isTrue);
    });

    testWidgets('vazgeçilirse false', (tester) async {
      expect(await answer(tester, 'Vazgeç'), isFalse);
    });
  });

  group('OptionSheet', () {
    Future<void> open(
      WidgetTester tester,
      List<SheetOption<String>> options,
      ValueChanged<String?> onResult,
    ) async {
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () async => onResult(
                await showOptionSheet<String>(
                  context,
                  (context) => OptionSheet(
                    title: 'Taşı',
                    options: options,
                    emptyMessage: 'Başka arılık yok',
                  ),
                ),
              ),
              child: const Text('Aç'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Aç'));
      await tester.pumpAndSettle();
    }

    testWidgets('dokunulan seçeneğin değeriyle kapanır', (tester) async {
      String? result;
      await open(tester, const [
        SheetOption(value: 'a', icon: Icons.place_rounded, label: 'Yayla'),
        SheetOption(
          value: 'b',
          icon: Icons.place_rounded,
          label: 'Ova',
          hint: '12 kovan',
        ),
      ], (value) => result = value);

      expect(find.text('12 kovan'), findsOneWidget);
      await tester.tap(find.text('Ova'));
      await tester.pumpAndSettle();

      expect(result, 'b');
      expect(find.text('Taşı'), findsNothing);
    });

    testWidgets('seçenek yoksa boş mesajı yazar', (tester) async {
      await open(tester, const [], (_) {});

      expect(find.text('Başka arılık yok'), findsOneWidget);
    });
  });

  group('OptionTile', () {
    testWidgets('ekran okuyucu satırı tek buton olarak okur', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpWidget(
        _app(
          OptionTile(
            icon: Icons.hive_rounded,
            label: 'Kovan 12',
            hint: 'Başka etiketi var',
            badge: const StatusBadge(status: AppStatus.info, label: 'Satıldı'),
            onTap: () {},
          ),
        ),
      );

      expect(
        tester.getSemantics(find.byType(OptionTile)),
        isSemantics(
          label: 'Kovan 12\nBaşka etiketi var\nSatıldı',
          isButton: true,
        ),
      );
      semantics.dispose();
    });
  });

  group('StatusMessage', () {
    testWidgets('cümle durumun ikonu ve rengiyle gelir', (tester) async {
      await tester.pumpWidget(
        _app(
          const StatusMessage(status: AppStatus.warning, message: 'Konum yok'),
        ),
      );

      final icon = tester.widget<Icon>(find.byIcon(AppStatus.warning.icon));
      expect(icon.color, AppColors.light.statusWarning);
      expect(find.text('Konum yok'), findsOneWidget);
    });
  });

  group('NavigationCard', () {
    testWidgets('dokununca açar; sağda ok var', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(NavigationCard(onTap: () => taps++, child: const Text('Yayla'))),
      );

      await tester.tap(find.text('Yayla'));

      expect(taps, 1);
      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
    });

    testWidgets('dokunma hedefi en az saha alanı yüksekliğinde', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(NavigationCard(onTap: () {}, child: const Text('Yayla'))),
      );

      expect(
        tester.getSize(find.byType(NavigationCard)).height,
        greaterThanOrEqualTo(AppTouchTargets.standard.field),
      );
    });
  });

  group('EmptyState', () {
    testWidgets('eylem butonu içeriği kadar geniş', (tester) async {
      await tester.pumpWidget(
        _app(
          EmptyState(
            icon: Icons.add_rounded,
            title: 'Arılık yok',
            message: 'İlk arılığını ekle.',
            actionLabel: 'Ekle',
            onAction: () {},
          ),
        ),
      );

      expect(tester.widget<BigButton>(find.byType(BigButton)).expanded, false);
    });

    testWidgets('ortalanmışı sığmazsa kayar', (tester) async {
      await tester.pumpWidget(
        _app(
          const EmptyState(
            icon: Icons.hive_rounded,
            title: 'Arılık yok',
            message: 'İlk arılığını ekle.',
            centered: true,
          ),
        ),
      );

      expect(
        find.ancestor(
          of: find.text('Arılık yok'),
          matching: find.byType(SingleChildScrollView),
        ),
        findsOneWidget,
      );
    });
  });

  group('showMessageSnackBar', () {
    testWidgets('önceki bildirimin yerini alır', (tester) async {
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () {
                showMessageSnackBar(context, 'Birinci');
                showMessageSnackBar(context, 'İkinci');
              },
              child: const Text('Göster'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Göster'));
      await tester.pumpAndSettle();

      expect(find.text('Birinci'), findsNothing);
      expect(find.text('İkinci'), findsOneWidget);
    });
  });

  group('showUndoSnackBar', () {
    testWidgets('ek içerik mesajın altında; ona dokunmak bildirimi kapatmaz, '
        'Geri al kapatır', (tester) async {
      var undone = 0;
      var tapped = 0;
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showUndoSnackBar(
                context,
                message: 'Kaydedildi',
                onUndo: () => undone++,
                details: TextButton(
                  onPressed: () => tapped++,
                  child: const Text('Seçenek'),
                ),
              ),
              child: const Text('Göster'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Göster'));
      await tester.pumpAndSettle();

      expect(
        tester.getTopLeft(find.text('Seçenek')).dy,
        greaterThan(tester.getBottomLeft(find.text('Kaydedildi')).dy),
      );
      await tester.tap(find.text('Seçenek'));
      await tester.pumpAndSettle();
      expect(tapped, 1);
      expect(find.text('Kaydedildi'), findsOneWidget);

      await tester.tap(find.text('Geri al'));
      await tester.pumpAndSettle();
      expect(undone, 1);
      expect(find.text('Kaydedildi'), findsNothing);
    });

    testWidgets('ek içerikli bildirim de 6 sn sonra kapanır', (tester) async {
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showUndoSnackBar(
                context,
                message: 'Kaydedildi',
                onUndo: () {},
                details: const Text('Seçenek'),
              ),
              child: const Text('Göster'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Göster'));
      await tester.pumpAndSettle();

      await tester.pump(undoSnackBarDuration);
      await tester.pumpAndSettle();

      expect(find.text('Kaydedildi'), findsNothing);
    });
  });

  group('BottomActionLayout', () {
    testWidgets('eylem kayan içeriğin altında sabit', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(const AppearanceSettings()),
          home: Scaffold(
            body: BottomActionLayout(
              body: ListView(
                children: [for (var i = 0; i < 50; i++) Text('Satır $i')],
              ),
              action: BigButton(label: 'Kaydet', onPressed: () {}),
            ),
          ),
        ),
      );

      final screen = tester.getSize(find.byType(Scaffold));
      final button = tester.getRect(find.byType(BigButton));
      expect(button.bottom, screen.height - AppSpacing.standard.lg);
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

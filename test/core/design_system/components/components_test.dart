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

    testWidgets('seçili chip dolgulu, onay ikonu yok; ekran okuyucu seçili '
        'der', (tester) async {
      await tester.pumpWidget(
        _app(
          ChoiceChipGroup(
            options: options,
            selected: const {'a'},
            onChanged: (_) {},
          ),
        ),
      );

      expect(find.byIcon(Icons.check_rounded), findsNothing);
      expect(
        tester.getSemantics(find.text('A')),
        isSemantics(isSelected: true, isButton: true),
      );
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

  group('KeyboardDismissArea', () {
    testWidgets('alan dışına dokununca odak bırakılır, dokunuş butona da '
        'gider; kaydırma ve başka alana dokunmak odağı bırakmaz', (
      tester,
    ) async {
      var pressed = 0;
      final first = FocusNode();
      final second = FocusNode();
      addTearDown(first.dispose);
      addTearDown(second.dispose);
      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => KeyboardDismissArea(child: child!),
          home: Scaffold(
            body: ListView(
              children: [
                TextField(focusNode: first),
                TextField(focusNode: second),
                TextButton(
                  onPressed: () => pressed++,
                  child: const Text('Buton'),
                ),
                const SizedBox(height: 2000),
              ],
            ),
          ),
        ),
      );

      await tester.tap(find.byType(TextField).first);
      await tester.pump();
      expect(first.hasFocus, isTrue);

      await tester.tap(find.byType(TextField).last);
      await tester.pump();
      expect(second.hasFocus, isTrue);

      await tester.drag(find.text('Buton'), const Offset(0, -100));
      await tester.pumpAndSettle();
      expect(second.hasFocus, isTrue);

      await tester.tap(find.text('Buton'));
      await tester.pump();
      expect(second.hasFocus, isFalse);
      expect(pressed, 1);
    });
  });

  group('SnackBarDismissArea', () {
    testWidgets('bildirim dışına dokununca kapanır, dokunuş alttaki butona '
        'gider; bildirimin içine ve Geri al’a dokunmak kapatmaz', (
      tester,
    ) async {
      var other = 0;
      var undone = 0;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.light(const AppearanceSettings()),
          locale: const Locale('tr'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) => SnackBarDismissArea(child: child!),
          home: Scaffold(
            body: Builder(
              builder: (context) => Column(
                children: [
                  TextButton(
                    onPressed: () => showUndoSnackBar(
                      context,
                      message: 'Kaydedildi',
                      onUndo: () => undone++,
                      details: const Text('Seçenek'),
                    ),
                    child: const Text('Göster'),
                  ),
                  TextButton(
                    onPressed: () => other++,
                    child: const Text('Başka'),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Göster'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Seçenek'));
      await tester.pumpAndSettle();
      expect(find.text('Kaydedildi'), findsOneWidget);

      await tester.tap(find.text('Başka'));
      await tester.pumpAndSettle();
      expect(find.text('Kaydedildi'), findsNothing);
      expect(other, 1);

      await tester.tap(find.text('Göster'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Geri al'));
      await tester.pumpAndSettle();
      expect(undone, 1);

      // Bilgi bildirimi de boş alana dokununca kapanır.
      showMessageSnackBar(
        tester.element(find.text('Başka')),
        'Plan kaydedildi',
      );
      await tester.pumpAndSettle();
      await tester.tapAt(const Offset(200, 300));
      await tester.pumpAndSettle();
      expect(find.text('Plan kaydedildi'), findsNothing);
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

  group('SectionLabel', () {
    testWidgets(
      'yerelin kuralıyla büyük harf; ekran okuyucu olduğu gibi okur',
      (tester) async {
        await tester.pumpWidget(_app(const SectionLabel('Yapılan işlem')));

        expect(find.text('YAPILAN İŞLEM'), findsOneWidget);
        expect(
          tester.getSemantics(find.byType(SectionLabel)),
          isSemantics(label: 'Yapılan işlem', isHeader: true),
        );
      },
    );

    testWidgets('durum verilirse durum renginde', (tester) async {
      await tester.pumpWidget(
        _app(const SectionLabel('Sorun', status: AppStatus.critical)),
      );

      expect(
        tester.widget<Text>(find.text('SORUN')).style?.color,
        AppColors.light.statusCritical,
      );
    });
  });

  group('LabeledField', () {
    testWidgets('tek alanda ad alanla birlikte okunur', (tester) async {
      await tester.pumpWidget(
        _app(const LabeledField(label: 'Arılık adı', child: TextField())),
      );

      expect(
        tester.getSemantics(find.byType(TextField)),
        isSemantics(label: 'Arılık adı', isTextField: true),
      );
    });

    testWidgets('grupta seçenekler ayrı kalır', (tester) async {
      await tester.pumpWidget(
        _app(
          LabeledField(
            label: 'Kovan tipi',
            group: true,
            child: ChoiceChipGroup<String>(
              options: const [
                ChoiceChipOption(value: 'a', label: 'A'),
                ChoiceChipOption(value: 'b', label: 'B'),
              ],
              selected: const {'a'},
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('B')),
        isSemantics(label: 'B', isButton: true, hasSelectedState: true),
      );
    });
  });

  group('ChoiceChipGroup sütunları', () {
    testWidgets("verilirse chip'ler eşit genişlikte", (tester) async {
      await tester.pumpWidget(
        _app(
          SizedBox(
            width: 300,
            child: ChoiceChipGroup<String>(
              columns: 2,
              options: const [
                ChoiceChipOption(value: 'a', label: 'A'),
                ChoiceChipOption(value: 'b', label: 'Uzun bir seçenek'),
                ChoiceChipOption(value: 'c', label: 'C'),
              ],
              selected: const {},
              onChanged: (_) {},
            ),
          ),
        ),
      );

      double width(String label) => tester
          .getSize(
            find.ancestor(of: find.text(label), matching: find.byType(InkWell)),
          )
          .width;
      expect(width('A'), width('Uzun bir seçenek'));
      expect(width('C'), width('A'));
      expect(
        tester.getTopLeft(find.text('C')).dy,
        greaterThan(tester.getTopLeft(find.text('A')).dy),
      );
    });
  });

  group('SegmentedTabs', () {
    testWidgets('seçili segment ekran okuyucuya söylenir; dokununca değişir', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        _app(
          SegmentedTabs<String>(
            options: const [
              SegmentOption(value: 'grid', label: 'Izgara'),
              SegmentOption(value: 'list', label: 'Liste'),
            ],
            selected: 'grid',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      expect(
        tester.getSemantics(find.text('Izgara')),
        isSemantics(
          label: 'Izgara',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.text('Liste'));
      expect(changed, 'list');
      expect(
        tester
            .getSize(
              find.ancestor(
                of: find.text('Liste'),
                matching: find.byType(InkWell),
              ),
            )
            .height,
        greaterThanOrEqualTo(AppTouchTargets.standard.minimum),
      );
    });
  });

  group('RadioCardGroup', () {
    testWidgets('seçili kart dolu daireli ve seçili okunur; dokununca seçer', (
      tester,
    ) async {
      String? changed;
      await tester.pumpWidget(
        _app(
          RadioCardGroup<String>(
            options: const [
              RadioCardOption(value: 'tr', label: 'Türkçe', hint: 'Cihaz dili'),
              RadioCardOption(value: 'en', label: 'English'),
            ],
            selected: 'tr',
            onChanged: (value) => changed = value,
          ),
        ),
      );

      expect(find.text('Cihaz dili'), findsOneWidget);
      expect(
        tester.getSemantics(find.text('Türkçe')),
        isSemantics(isSelected: true, isButton: true, hasSelectedState: true),
      );
      await tester.tap(find.text('English'));
      expect(changed, 'en');
    });
  });

  group('ListRow', () {
    testWidgets('dokunulabilir satırda ok var; değeri sağda', (tester) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(
          ListGroup(
            children: [
              ListRow(title: 'Dil', value: 'Türkçe', onTap: () => taps++),
              const ListRow(title: 'Ülke', value: 'Türkiye · TR'),
            ],
          ),
        ),
      );

      expect(find.byIcon(Icons.chevron_right_rounded), findsOneWidget);
      expect(find.byType(Divider), findsOneWidget);
      await tester.tap(find.text('Dil'));
      expect(taps, 1);
      expect(
        tester.getTopLeft(find.text('Türkçe')).dx,
        greaterThan(tester.getTopLeft(find.text('Dil')).dx),
      );
    });
  });

  group('SummaryTile', () {
    testWidgets('durum verilirse durumun zemininde; tek parça okunur', (
      tester,
    ) async {
      await tester.pumpWidget(
        _app(
          const SummaryTile(
            label: 'Aktif ilaç',
            value: '12 gün kaldı',
            status: AppStatus.critical,
          ),
        ),
      );

      final card = tester.widget<Material>(
        find.descendant(
          of: find.byType(AppCard),
          matching: find.byType(Material),
        ),
      );
      expect(card.color, AppColors.light.statusCriticalContainer);
      expect(
        tester.getSemantics(find.byType(SummaryTile)),
        isSemantics(label: 'Aktif ilaç\n12 gün kaldı'),
      );
    });
  });

  group('OptionGridSheet', () {
    testWidgets(
      'karoya dokunmak sayfayı değeriyle kapatır; vurgulu karo dolu',
      (tester) async {
        String? result;
        await tester.pumpWidget(
          _app(
            Builder(
              builder: (context) => TextButton(
                onPressed: () async => result = await showOptionSheet<String>(
                  context,
                  (context) => const OptionGridSheet(
                    title: 'Hızlı kayıt',
                    highlighted: 'a',
                    options: [
                      SheetOption(
                        value: 'a',
                        icon: Icons.description_outlined,
                        label: 'Muayene',
                      ),
                      SheetOption(
                        value: 'b',
                        icon: Icons.water_drop_outlined,
                        label: 'Besleme',
                      ),
                    ],
                  ),
                ),
                child: const Text('Aç'),
              ),
            ),
          ),
        );
        await tester.tap(find.text('Aç'));
        await tester.pumpAndSettle();

        final highlighted = tester.widget<ActionTile>(
          find.ancestor(
            of: find.text('Muayene'),
            matching: find.byType(ActionTile),
          ),
        );
        expect(highlighted.highlighted, isTrue);
        await tester.tap(find.text('Besleme'));
        await tester.pumpAndSettle();

        expect(result, 'b');
        expect(find.text('Hızlı kayıt'), findsNothing);
      },
    );
  });

  group('BottomActionLayout', () {
    testWidgets('separated ise eylemin üstünde çizgi var', (tester) async {
      Future<void> pump({required bool separated}) => tester.pumpWidget(
        _app(
          BottomActionLayout(
            separated: separated,
            body: const SizedBox.shrink(),
            action: const Text('Kaydet'),
          ),
        ),
      );

      await pump(separated: false);
      expect(find.byType(Divider), findsNothing);
      await pump(separated: true);
      expect(find.byType(Divider), findsOneWidget);
    });
  });

  group('HoneycombBackdrop', () {
    testWidgets('güneş modunda çizilmez', (tester) async {
      Future<int> paints(AppearanceSettings settings) async {
        await tester.pumpWidget(
          _app(const HoneycombBackdrop(), settings: settings),
        );
        await tester.pumpAndSettle();
        return find
            .descendant(
              of: find.byType(HoneycombBackdrop),
              matching: find.byType(CustomPaint),
            )
            .evaluate()
            .length;
      }

      expect(await paints(const AppearanceSettings()), 1);
      expect(
        await paints(const AppearanceSettings(colorMode: AppColorMode.sun)),
        0,
      );
    });
  });
}

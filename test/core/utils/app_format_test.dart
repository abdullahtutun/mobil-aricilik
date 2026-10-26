import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';

void main() {
  final moment = DateTime(2026, 10, 21, 14, 5);
  const tr = AppFormat('tr');
  const en = AppFormat('en');

  // Bu grup initializeDateFormatting'den önce çalışır; uygulamada tarih
  // verisini Material yerelleştirmesinin yüklediğini de doğrular.
  group('AppFormat.of', () {
    for (final (locale, date) in [
      ('tr', '21 Eki 2026'),
      ('en', 'Oct 21, 2026'),
    ]) {
      testWidgets('uygulamanın dilinde biçimler ($locale)', (tester) async {
        late AppFormat format;
        await tester.pumpWidget(
          MaterialApp(
            locale: Locale(locale),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Builder(
              builder: (context) {
                format = AppFormat.of(context);
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        expect(format.locale, locale);
        expect(format.date(moment), date);
      });
    }
  });

  group('AppFormat', () {
    setUpAll(initializeDateFormatting);

    test('tarih ay adıyla yazılır', () {
      expect(tr.date(moment), '21 Eki 2026');
      expect(en.date(moment), 'Oct 21, 2026');
    });

    test('gün adıyla tarih gün adıyla başlar', () {
      expect(tr.weekdayDate(moment), 'Çarşamba, 21 Ekim');
      expect(en.weekdayDate(moment), 'Wednesday, October 21');
    });

    test('kısa tarih yerelin gün/ay sırasıyla yazılır', () {
      expect(tr.shortDate(moment), '21.10.2026');
      expect(en.shortDate(moment), '10/21/2026');
    });

    test('saat Türkçede 24, İngilizcede 12 saat düzeninde', () {
      expect(tr.time(moment), '14:05');
      // intl, AM/PM'den önce dar bölünmez boşluk koyar.
      expect(en.time(moment), '2:05 PM');
    });

    test('tarih ve saat birlikte', () {
      expect(tr.dateTime(moment), '21 Eki 2026 14:05');
      expect(en.dateTime(moment), 'Oct 21, 2026 2:05 PM');
    });

    test('sayıda basamak ve ondalık ayracı yerele göre', () {
      expect(tr.number(1234567), '1.234.567');
      expect(en.number(1234567), '1,234,567');
      expect(tr.number(-1234.5), '-1.234,5');
      expect(en.number(-1234.5), '-1,234.5');
    });

    test('ondalık en çok istenen hane kadar; sondaki sıfırlar yazılmaz', () {
      expect(tr.number(3.14159), '3,14');
      expect(tr.number(2.50), '2,5');
      expect(tr.number(12.46, maxFractionDigits: 1), '12,5');
      expect(tr.number(12.6, maxFractionDigits: 0), '13');
    });

    test('koordinat her dilde noktalı, beş haneli', () {
      expect(tr.coordinates(40.1234567, 29.6543), '40.12346, 29.65430');
      expect(en.coordinates(-33.86, 151.2093), '-33.86000, 151.20930');
    });

    test('yüzde işareti yerele göre başta ya da sonda', () {
      expect(tr.percent(0.75), '%75');
      expect(en.percent(0.75), '75%');
      expect(tr.percent(1), '%100');
    });

    test('para tutarı para biriminin simgesiyle', () {
      expect(tr.currency(1234.5, currencyCode: 'TRY'), '₺1.234,50');
      expect(en.currency(1234.5, currencyCode: 'TRY'), '₺1,234.50');
      expect(tr.currency(1234.5, currencyCode: 'USD'), r'$1.234,50');
      expect(tr.currency(-1234.5, currencyCode: 'EUR'), '-€1.234,50');
    });

    test('ondalık hane sayısı para biriminden gelir', () {
      expect(tr.currency(1234.5, currencyCode: 'JPY'), '¥1.235');
    });
  });

  group('upperCase ve currencySymbol', () {
    test('Türkçede i İ, ı I olur; İngilizcede Dart kuralı', () {
      expect(tr.upperCase('işletme ılık'), 'İŞLETME ILIK');
      expect(en.upperCase('queen bees'), 'QUEEN BEES');
    });

    test('para biriminin simgesi; simgesi yoksa kodu', () {
      expect(tr.currencySymbol('TRY'), '₺');
      expect(en.currencySymbol('EUR'), '€');
      expect(en.currencySymbol('CHF'), 'CHF');
    });
  });
}

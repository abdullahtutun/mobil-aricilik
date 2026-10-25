import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

/// Yerele göre tarih, saat, sayı ve para biçimleri. Ekranlar `intl`
/// biçimlerini kendisi kurmaz, bunu kullanır; biçim kararları tek yerde kalır.
///
/// Tarih biçimleri `intl`'in yerel verisine ihtiyaç duyar. Uygulamada bu
/// veriyi Material yerelleştirmesi yükler. Widget ağacı dışında (ör. arka
/// plan işi) önce `initializeDateFormatting` çağrılmalı.
class AppFormat {
  const new(this.locale);

  /// Uygulamanın o anki dilinde biçimler.
  factory of(BuildContext context) =>
      AppFormat(Localizations.localeOf(context).toString());

  /// `intl` yerel adı: `tr`, `en`.
  final String locale;

  /// Ay adıyla tarih; gün/ay sırası karışmaz. `21 Eki 2026`, `Oct 21, 2026`
  String date(DateTime value) => DateFormat.yMMMd(locale).format(value);

  /// Sayısal tarih. `21.10.2026`, `10/21/2026`
  String shortDate(DateTime value) => DateFormat.yMd(locale).format(value);

  /// Yılsız gün ve ay; grafik eksenleri için. `9 Eki`, `Oct 9`
  String dayMonth(DateTime value) => DateFormat.MMMd(locale).format(value);

  /// Yerelin saat düzeni. `14:05`, `2:05 PM`
  String time(DateTime value) => DateFormat.jm(locale).format(value);

  /// [date] ve [time] birlikte. `21 Eki 2026 14:05`
  String dateTime(DateTime value) =>
      DateFormat.yMMMd(locale).add_jm().format(value);

  /// Para biriminin simgesi; simgesi olmayan birimde kodu. `₺`, `€`, `CHF`
  String currencySymbol(String currencyCode) => NumberFormat.simpleCurrency(
    locale: locale,
    name: currencyCode,
  ).currencySymbol;

  /// Yerelin kuralıyla büyük harf: Türkçede `i` → `İ`, `ı` → `I`.
  /// Bölüm etiketi gibi büyük harfle yazılan metinler için; Dart'ın
  /// `toUpperCase`'i Türkçe `i`yi `I` yapar.
  String upperCase(String value) {
    if (!locale.startsWith('tr') && !locale.startsWith('az')) {
      return value.toUpperCase();
    }
    return value.replaceAll('i', 'İ').replaceAll('ı', 'I').toUpperCase();
  }

  /// Basamak ayraçlı sayı. En çok [maxFractionDigits] ondalık yazılır,
  /// sondaki sıfırlar atılır. `1.234,5`, `1,234.5`
  String number(num value, {int maxFractionDigits = 2}) {
    final format = NumberFormat.decimalPattern(locale)
      ..maximumFractionDigits = maxFractionDigits;
    return format.format(value);
  }

  /// Ondalık derece enlem ve boylam, beş hane (~1 m). GPS uygulamaları ve
  /// haritalar gibi her dilde nokta ile; virgül iki sayıyı ayırır.
  /// `40.12346, 29.65432`
  String coordinates(double latitude, double longitude) =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

  /// 0–1 arası oranı yüzde olarak yazar. `%76`, `76%`
  String percent(double ratio) =>
      NumberFormat.percentPattern(locale).format(ratio);

  /// Para tutarı; simge ve ondalık hane sayısı para biriminden gelir.
  /// [currencyCode] ISO 4217 kodudur (TRY, USD, EUR). `₺1.234,50`, `₺1,234.50`
  String currency(num amount, {required String currencyCode}) {
    final format = NumberFormat.simpleCurrency(
      locale: locale,
      name: currencyCode,
    );
    return format.format(amount);
  }
}

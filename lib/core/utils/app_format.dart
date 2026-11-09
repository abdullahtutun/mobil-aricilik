import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:mobil_arici/core/utils/digits.dart';

/// Yerele göre tarih, saat, sayı ve para biçimleri. Ekranlar `intl`
/// biçimlerini kendisi kurmaz, bunu kullanır; biçim kararları tek yerde kalır.
///
/// Tarih biçimleri `intl`'in yerel verisine ihtiyaç duyar. Uygulamada bu
/// veriyi Material yerelleştirmesi yükler. Widget ağacı dışında (ör. arka
/// plan işi) önce `initializeDateFormatting` çağrılmalı.
/// Arayüzü kendi rakamı yerine Latin rakamla yazılan diller. `intl`
/// Farsçada Farsça rakam (۱۲۳) basar; ARB'deki sayılar, kovan numaraları ve
/// etiketler Latin rakamla olduğundan aynı ekranda iki rakam karışırdı.
/// Girişte Farsça rakam `asciiDigits` ile Latin'e çevrilir.
const latinDigitLanguages = {'fa'};

/// Material'ın kendi tarih biçimleri (tarih seçici) de Latin rakam yazsın;
/// açılışta bir kez çağrılır.
void useLatinDigitsForDates() {
  for (final language in latinDigitLanguages) {
    DateFormat.useNativeDigitsByDefaultFor(language, false);
  }
}

class AppFormat {
  const new(this.locale);

  /// Uygulamanın o anki dilinde biçimler.
  factory of(BuildContext context) =>
      AppFormat(Localizations.localeOf(context).toString());

  /// `intl` yerel adı: `tr`, `en`.
  final String locale;

  /// Rakamları Latin kalan dil mi ([latinDigitLanguages]).
  bool get _latinDigits =>
      latinDigitLanguages.contains(locale.split(RegExp('[_-]')).first);

  /// Sayı biçiminin yereli; Latin rakamlı dilde İngilizce biçim (`1,234.5`).
  String get _numberLocale => _latinDigits ? 'en' : locale;

  /// Tarih biçimi; Latin rakamlı dilde ay ve gün adları o dilde, rakamlar
  /// Latin.
  DateFormat _dates(DateFormat format) =>
      _latinDigits ? (format..useNativeDigits = false) : format;

  /// Ay adıyla tarih; gün/ay sırası karışmaz. `21 Eki 2026`, `Oct 21, 2026`
  String date(DateTime value) => _dates(DateFormat.yMMMd(locale)).format(value);

  /// Sayısal tarih. `21.10.2026`, `10/21/2026`
  String shortDate(DateTime value) =>
      _dates(DateFormat.yMd(locale)).format(value);

  /// Yılsız gün ve ay; grafik eksenleri için. `9 Eki`, `Oct 9`
  String dayMonth(DateTime value) =>
      _dates(DateFormat.MMMd(locale)).format(value);

  /// Kısa ay adı; dönem aralıkları için. `Ağu`, `Aug`
  String shortMonth(DateTime value) =>
      _dates(DateFormat.MMM(locale)).format(value);

  /// Tek başına tam ay adı. `Kasım`, `November`
  String month(DateTime value) => _dates(DateFormat.LLLL(locale)).format(value);

  /// Günsüz ay ve yıl; uzak tarihler için. `May 2027`, `May 2027`
  String monthYear(DateTime value) =>
      _dates(DateFormat.yMMM(locale)).format(value);

  /// Ayın tam adıyla: `Mart 2026` / `March 2026`.
  String monthYearLong(DateTime value) =>
      _dates(DateFormat.yMMMM(locale)).format(value);

  /// Haftanın günü. `Pazartesi`, `Monday`
  String weekday(DateTime value) =>
      _dates(DateFormat.EEEE(locale)).format(value);

  /// Gün adıyla yılsız tarih; Bugün'ün başlığı. Gün adı başta (docs/design
  /// "Bugün"): `Pazartesi, 26 Ekim`, `Monday, October 26`
  String weekdayDate(DateTime value) => _dates(
    DateFormat.EEEE(locale)
        .addPattern(',', '')
        .addPattern(DateFormat.MMMMd(locale).pattern),
  ).format(value);

  /// Kısa gün adı; gün şeridi için. `Pzt`, `Mon`
  String weekdayShort(DateTime value) =>
      _dates(DateFormat.E(locale)).format(value);

  /// Ayın günü. `26`
  String dayOfMonth(DateTime value) =>
      _dates(DateFormat.d(locale)).format(value);

  /// Yerelin saat düzeni. `14:05`, `2:05 PM`
  String time(DateTime value) => _dates(DateFormat.jm(locale)).format(value);

  /// [date] ve [time] birlikte. `21 Eki 2026 14:05`
  String dateTime(DateTime value) =>
      _dates(DateFormat.yMMMd(locale).add_jm()).format(value);

  /// Para biriminin simgesi; simgesi olmayan birimde kodu. `₺`, `€`, `CHF`
  String currencySymbol(String currencyCode) => NumberFormat.simpleCurrency(
    locale: _numberLocale,
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
    final format = NumberFormat.decimalPattern(_numberLocale)
      ..maximumFractionDigits = maxFractionDigits;
    return format.format(value);
  }

  /// Bayt, MB (1024²) olarak ve birimsiz: 10'dan küçükse bir ondalık.
  /// `2,5`, `84`
  String megabytes(int bytes) {
    final value = bytes / (1024 * 1024);
    return number(value, maxFractionDigits: value < 10 ? 1 : 0);
  }

  /// Ondalık derece enlem ve boylam, beş hane (~1 m). GPS uygulamaları ve
  /// haritalar gibi her dilde nokta ile; virgül iki sayıyı ayırır.
  /// `40.12346, 29.65432`
  String coordinates(double latitude, double longitude) =>
      '${latitude.toStringAsFixed(5)}, ${longitude.toStringAsFixed(5)}';

  /// 0–1 arası oranı yüzde olarak yazar. `%76`, `76%`
  String percent(double ratio) =>
      NumberFormat.percentPattern(_numberLocale).format(ratio);

  /// Para tutarı; simge ve ondalık hane sayısı para biriminden gelir.
  /// [currencyCode] ISO 4217 kodudur (TRY, USD, EUR). `₺1.234,50`, `₺1,234.50`
  /// [decimalDigits] verilirse ondalık hane sayısı o olur (`₺1.235`).
  String currency(
    num amount, {
    required String currencyCode,
    int? decimalDigits,
  }) {
    final format = NumberFormat.simpleCurrency(
      locale: _numberLocale,
      name: currencyCode,
      decimalDigits: decimalDigits,
    );
    return format.format(amount);
  }

  /// Dar yerler (özet kartı, kâr satırı) için tutar: [compactFrom]'dan
  /// küçükse [currency] gibi tam, büyükse yerelin kısaltmasıyla.
  /// `₺1,22 Mr`, `1,22 Mrd. €`, `Rial 1.22 میلیارد`. Farsçada kısaltma
  /// sözcüğü Farsça, rakamlar Latin ve ondalık ayırıcı nokta kalır (sayı
  /// biçimi İngilizce olduğundan virgül binlik ayracıyla karışırdı).
  String compactCurrency(
    num amount, {
    required String currencyCode,
    int? decimalDigits,
  }) {
    if (amount.abs() < compactFrom) {
      return currency(
        amount,
        currencyCode: currencyCode,
        decimalDigits: decimalDigits,
      );
    }
    final text = NumberFormat.compactSimpleCurrency(
      locale: locale,
      name: currencyCode,
    ).format(amount);
    return _latinDigits ? asciiDigits(text.replaceAll('٫', '.')) : text;
  }

  /// Bu tutardan (10 milyon) itibaren [compactCurrency] kısaltır; lira,
  /// avro ve dolarla günlük tutarlar tam kalır.
  static const compactFrom = 10000000;
}

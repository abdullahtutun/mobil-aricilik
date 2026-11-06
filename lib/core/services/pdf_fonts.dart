import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/widgets.dart' as pw;

/// Uygulamaya gömülü Inter; PDF'in varsayılan yazı tipinde ı, ş, ğ yok.
/// Inter'de olmayan Arap yazısı (Farsça) için Vazirmatn, Devanagari için
/// Noto Sans Devanagari yedek font. Cihazda okunur, ağ gerekmez.
///
/// `pdf` paketi Devanagari harf birleşimlerini (conjunct, matra) dizemez;
/// bu yüzden Hintçe arayüzde raporlar İngilizce basılır
/// (`AppLanguage.supportsPdf`). Devanagari yedeği yalnız kullanıcının
/// yazdığı adlar (arılık, bal türü) kutucuk yerine okunabilsin diye.
Future<pw.ThemeData> interPdfTheme() async => pw.ThemeData.withFont(
  base: pw.Font.ttf(
    await rootBundle.load('assets/fonts/inter/Inter-Regular.ttf'),
  ),
  bold: pw.Font.ttf(await rootBundle.load('assets/fonts/inter/Inter-Bold.ttf')),
  fontFallback: [
    pw.Font.ttf(
      await rootBundle.load('assets/fonts/vazirmatn/Vazirmatn-Regular.ttf'),
    ),
    pw.Font.ttf(
      await rootBundle.load(
        'assets/fonts/noto_sans_devanagari/NotoSansDevanagari-Regular.ttf',
      ),
    ),
  ],
);

/// PDF'in yazı yönü: sağdan sola dillerde (Farsça) RTL. `pdf` paketi Arap
/// yazısını yalnız RTL sayfada birleştirir (harfleri bağlar).
pw.TextDirection pdfTextDirection(String locale) =>
    switch (locale.split(RegExp('[_-]')).first) {
      'fa' => pw.TextDirection.rtl,
      _ => pw.TextDirection.ltr,
    };

/// Kullanıcının yazdığı metnin yönü: ilk harfi Arap yazısındansa RTL.
/// Yerleşimi sabit kalan sayfalarda (etiketler) tek metni doğru basmak
/// için; `pdf` Arap harflerini yalnız RTL metinde birleştirir.
pw.TextDirection pdfTextDirectionOf(String text) {
  for (final rune in text.runes) {
    if (_isArabicScript(rune)) return pw.TextDirection.rtl;
    if (_isLetter(rune)) return pw.TextDirection.ltr;
  }
  return pw.TextDirection.ltr;
}

bool _isArabicScript(int rune) =>
    (rune >= 0x0600 && rune <= 0x06FF) ||
    (rune >= 0x0750 && rune <= 0x077F) ||
    (rune >= 0xFB50 && rune <= 0xFDFF) ||
    (rune >= 0xFE70 && rune <= 0xFEFF);

bool _isLetter(int rune) {
  final char = String.fromCharCode(rune);
  return char.toLowerCase() != char.toUpperCase();
}

/// PDF başlığından dosya adı: dosya adında sorun çıkaran karakterler tireye
/// döner.
String pdfFileName(String title) =>
    '${title.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-').trim()}.pdf';

import 'dart:ui' show Locale;

import 'package:mobil_arici/core/region/country_currencies.dart';
import 'package:mobil_arici/core/utils/text_fold.dart';

/// Cihazın dil listesinden ülke önerisi: sırayla ilk bilinen ülke kodu
/// (`tr_TR` → `TR`). Hiçbir dilde ülke yoksa null; kullanıcı listeden seçer.
String? suggestCountryCode(Iterable<Locale> deviceLocales) {
  for (final locale in deviceLocales) {
    final code = locale.countryCode?.toUpperCase();
    if (code != null && countryCurrencyCodes.containsKey(code)) return code;
  }
  return null;
}

/// Ülke aramasında eşleşme. Ad; büyük-küçük harf, Türkçe harfler ve aksan
/// gözetilmeden aranır ("turkiye" → Türkiye, "cote" → Côte d’Ivoire). İki
/// harfli ISO kodu da tam eşleşir. Boş arama her ülkeyle eşleşir.
bool matchesCountryQuery({
  required String code,
  required String name,
  required String query,
}) {
  final folded = foldForSearch(query.trim());
  if (folded.isEmpty) return true;
  return foldForSearch(name).contains(folded) || code.toLowerCase() == folded;
}

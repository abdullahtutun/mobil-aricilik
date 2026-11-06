// lib/core/region/country_names.dart'ı üretir: country_currencies.dart'taki
// her ülke kodunun her arayüz dilindeki adı (CLDR, macOS Foundation), o
// dilin alfabe sırasıyla.
//
//   swift tool/country_names.swift tr en de es pt ru uk fa > lib/core/region/country_names.dart
//
// Yeni dil eklenince kodu argümanlara eklenip dosya yeniden üretilir.

import Foundation

let languages = Array(CommandLine.arguments.dropFirst())
guard !languages.isEmpty else {
  FileHandle.standardError.write("Dil kodu verin: tr en de …\n".data(using: .utf8)!)
  exit(64)
}

let source = try String(
  contentsOfFile: "lib/core/region/country_currencies.dart",
  encoding: .utf8
)
let pattern = try NSRegularExpression(pattern: "^  '([A-Z]{2})': '[A-Z]{3}',", options: .anchorsMatchLines)
let codes = pattern.matches(in: source, range: NSRange(source.startIndex..., in: source)).map {
  String(source[Range($0.range(at: 1), in: source)!])
}

/// Dart tek tırnaklı dizgesi.
func dartString(_ value: String) -> String {
  "'" + value.replacingOccurrences(of: "\\", with: "\\\\")
    .replacingOccurrences(of: "'", with: "\\'")
    .replacingOccurrences(of: "$", with: "\\$") + "'"
}

func variableName(_ language: String) -> String {
  "countryNames" + language.prefix(1).uppercased() + language.dropFirst()
}

var out = """
/// Ülke adları: [countryCurrencyCodes]'taki her kod için her arayüz dilinde.
///
/// `tool/country_names.swift` ile CLDR'dan (macOS Foundation,
/// `Locale.localizedString(forRegionCode:)`) üretildi; elle düzenlenmez. Her
/// tablo kendi dilinin alfabe sırasında; listeler bu sırayla gösterilir.
library;

import 'package:mobil_arici/core/region/country_currencies.dart';


"""

for language in languages {
  let locale = Locale(identifier: language)
  let names = codes.map { code in
    (code, locale.localizedString(forRegionCode: code) ?? code)
  }.sorted {
    $0.1.compare($1.1, options: [.caseInsensitive], range: nil, locale: locale) == .orderedAscending
  }
  let endonym = locale.localizedString(forLanguageCode: language) ?? language
  out += "/// \(endonym) (`\(language)`), alfabe sırasıyla.\n"
  out += "const \(variableName(language)) = <String, String>{\n"
  for (code, name) in names {
    out += "  '\(code)': \(dartString(name)),\n"
  }
  out += "};\n\n"
}

out += """
/// [languageCode] dilindeki ülke adları, o dilin alfabe sırasıyla.
/// Tablosu olmayan dilde İngilizce adlar döner.
Map<String, String> countryNamesFor(String languageCode) =>
    switch (languageCode) {

"""
for language in languages where language != "en" {
  out += "      '\(language)' => \(variableName(language)),\n"
}
out += """
      _ => countryNamesEn,
    };

"""

print(out, terminator: "")

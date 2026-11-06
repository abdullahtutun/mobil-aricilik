import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// ARB dosyaları birbirini tutuyor mu: her dilde şablonun (EN) bütün
/// anahtarları var, fazlası yok; çeviri şablonda olmayan yer tutucu
/// kullanmıyor; çoğul biçimleri dilin istediği kategorileri içeriyor.
void main() {
  const dir = 'lib/core/l10n';
  final files = {
    for (final file in Directory(dir).listSync().whereType<File>())
      if (_arbName.firstMatch(file.uri.pathSegments.last) case final match?)
        match[1]!: jsonDecode(file.readAsStringSync()) as Map<String, Object?>,
  };
  final template = files['en']!;
  final keys = _messageKeys(template);

  test('şablon ve Türkçe var', () {
    expect(files.keys, containsAll(['en', 'tr']));
  });

  for (final MapEntry(key: locale, value: arb) in files.entries) {
    group('app_$locale.arb', () {
      test('anahtarlar şablonla aynı', () {
        final own = _messageKeys(arb);
        expect(keys.difference(own), isEmpty, reason: 'eksik anahtarlar');
        expect(own.difference(keys), isEmpty, reason: 'fazla anahtarlar');
      });

      test('metin boş değil', () {
        final empty = [
          for (final key in _messageKeys(arb))
            if ((arb[key]! as String).trim().isEmpty) key,
        ];
        expect(empty, isEmpty);
      });

      test('yalnız şablondaki yer tutucular', () {
        final unknown = <String>[];
        for (final key in keys.intersection(_messageKeys(arb))) {
          final allowed = _placeholders(template, key);
          for (final name in _usedPlaceholders(arb[key]! as String)) {
            if (!allowed.contains(name)) unknown.add('$key: {$name}');
          }
        }
        expect(unknown, isEmpty);
      });

      test('çoğullar dilin kategorilerini içeriyor', () {
        final required = _pluralCategories[locale] ?? const {'other'};
        final missing = <String>[];
        for (final key in _messageKeys(arb)) {
          for (final cases in _pluralCases(arb[key]! as String)) {
            // `=0`, `=1` gibi tam sayı durumları kategori yerine geçmez.
            final lacking = required.difference(cases);
            if (lacking.isNotEmpty) missing.add('$key: $lacking');
          }
        }
        expect(missing, isEmpty);
      });
    });
  }

  group('ARB yardımcıları', () {
    test('iç içe çoğul ve select durumlarını ayırır', () {
      expect(
        _pluralCases(
          '{count, plural, =0{yok} one{{count} {kind, select, a{A} other{B}}}'
          ' other{{count}}}',
        ),
        [
          {'=0', 'one', 'other'},
        ],
      );
      expect(_usedPlaceholders('{a} ve {b, plural, =0{Yok} other{{c} x{Y}}}'), {
        'a',
        'b',
        'c',
      });
    });
  });
}

final _arbName = RegExp(r'^app_([a-z]{2,3}(?:_[A-Za-z]+)?)\.arb$');

/// CLDR çoğul kategorileri; listede olmayan dil yalnız `other` ister.
/// Rusça ve Ukraynacada 1, 2–4 ve 5+ ayrı çekimlenir.
const _pluralCategories = {
  'ru': {'one', 'few', 'many', 'other'},
  'uk': {'one', 'few', 'many', 'other'},
};

Set<String> _messageKeys(Map<String, Object?> arb) => {
  for (final key in arb.keys)
    if (!key.startsWith('@')) key,
};

Set<String> _placeholders(Map<String, Object?> arb, String key) =>
    switch (arb['@$key']) {
      {'placeholders': final Map<String, Object?> placeholders} =>
        placeholders.keys.toSet(),
      _ => const {},
    };

/// Metinde `{ad}` ya da `{ad, plural|select, …}` olarak geçen adlar.
/// Seçicinin hemen ardındaki gövde (`beyaz{Beyaz}`, `=0{Yok}`) yer tutucu
/// değildir.
Set<String> _usedPlaceholders(String message) => {
  for (final match in RegExp(
    r'(?<![A-Za-z0-9_])\{\s*([A-Za-z_][A-Za-z0-9_]*)\s*[},]',
  ).allMatches(message))
    match[1]!,
};

/// Metindeki her `plural` bloğunun durum adları (`one`, `=0`, …).
List<Set<String>> _pluralCases(String message) {
  final result = <Set<String>>[];
  final header = RegExp(r'\{\s*[A-Za-z_][A-Za-z0-9_]*\s*,\s*plural\s*,');
  for (final match in header.allMatches(message)) {
    final cases = <String>{};
    var i = match.end;
    while (i < message.length) {
      // Boşlukları geç; blok `}` ile biter.
      while (i < message.length && message[i].trim().isEmpty) {
        i++;
      }
      if (i >= message.length || message[i] == '}') break;
      final start = i;
      while (message[i] != '{') {
        i++;
      }
      cases.add(message.substring(start, i).trim());
      // Durum gövdesi: dengeli süslü parantez.
      var depth = 0;
      do {
        if (message[i] == '{') depth++;
        if (message[i] == '}') depth--;
        i++;
      } while (depth > 0);
    }
    result.add(cases);
  }
  return result;
}

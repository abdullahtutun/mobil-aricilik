import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/health/domain/diagnosis_rules.dart';

/// Geçerli en küçük tablo; testler parçalarını bozar.
Map<String, Object?> _table() => {
  'format': 1,
  'symptoms': [
    {
      'id': 'a',
      'label': {'tr': 'A', 'en': 'A'},
    },
    {
      'id': 'b',
      'label': {'tr': 'B', 'en': 'B'},
    },
    {
      'id': 'c',
      'label': {'tr': 'C', 'en': 'C'},
    },
  ],
  'rules': [
    _rule('one', ['a', 'b', 'c']),
    _rule('two', ['a', 'b']),
    _rule('three', ['c'], notifiable: true),
    _rule('four', ['a', 'b'], notifiable: true),
  ],
  'authorities': {
    'TR': {
      'name': {'tr': 'Müdürlük', 'en': 'Directorate'},
      'phone': '174',
    },
    'GLOBAL': {
      'name': {'tr': 'Yerel otorite', 'en': 'Local authority'},
      'detail': {'tr': 'Ayrıntı', 'en': 'Detail'},
    },
  },
};

Map<String, Object?> _rule(
  String id,
  List<String> symptoms, {
  bool notifiable = false,
}) => {
  'id': id,
  'name': {'tr': 'Ad $id', 'en': 'Name $id'},
  'symptoms': symptoms,
  'notifiable': notifiable,
  'advice': {'tr': 'Öneri', 'en': 'Advice'},
};

void main() {
  test('uygulamayla gelen tablo okunur: 3 örnek kural, TR ve GLOBAL kurum', () {
    final table = parseDiagnosisTable(
      jsonDecode(File('assets/diagnosis/rules.json').readAsStringSync()),
    );

    expect(table.rules.map((rule) => rule.id), [
      'american_foulbrood',
      'chalkbrood',
      'nosema',
    ]);
    expect(diagnosisRule(table, 'american_foulbrood')!.notifiable, isTrue);
    expect(table.authorities.keys, containsAll(['TR', 'GLOBAL']));
  });

  test('geçerli tablo okunur; telefon ve açıklama isteğe bağlı', () {
    final table = parseDiagnosisTable(_table());

    expect(table.symptoms, hasLength(3));
    expect(table.rules.first.symptoms, ['a', 'b', 'c']);
    expect(table.authorities['TR']!.phone, '174');
    expect(table.authorities['TR']!.detail, isNull);
    expect(table.authorities['GLOBAL']!.phone, isNull);
  });

  group('bozuk tablo FormatException atar', () {
    final cases = <String, void Function(Map<String, Object?>)>{
      'bilinmeyen biçim': (json) => json['format'] = 2,
      'boş belirtiler': (json) => json['symptoms'] = <Object?>[],
      'tekrarlanan belirti': (json) =>
          (json['symptoms']! as List<Object?>).add({
            'id': 'a',
            'label': {'tr': 'A', 'en': 'A'},
          }),
      'tekrarlanan kural': (json) =>
          (json['rules']! as List<Object?>).add(_rule('one', ['a'])),
      'bilinmeyen belirtiye kural': (json) =>
          (json['rules']! as List<Object?>).add(_rule('five', ['x'])),
      'kuralda tekrarlanan belirti': (json) =>
          (json['rules']! as List<Object?>).add(_rule('five', ['a', 'a'])),
      'belirtisiz kural': (json) =>
          (json['rules']! as List<Object?>).add(_rule('five', [])),
      'geçersiz kimlik': (json) =>
          (json['rules']! as List<Object?>).add(_rule('Beş', ['a'])),
      'EN metni yok': (json) =>
          ((json['symptoms']! as List<Object?>).first!
              as Map<String, Object?>)['label'] = {
            'tr': 'A',
          },
      'boş TR metni': (json) =>
          ((json['symptoms']! as List<Object?>).first!
              as Map<String, Object?>)['label'] = {
            'tr': ' ',
            'en': 'A',
          },
      'GLOBAL kurum yok': (json) =>
          (json['authorities']! as Map<String, Object?>).remove('GLOBAL'),
      'bilinmeyen bölge': (json) =>
          (json['authorities']! as Map<String, Object?>)['DE'] = {
            'name': {'tr': 'X', 'en': 'X'},
          },
      'geçersiz telefon': (json) =>
          ((json['authorities']! as Map<String, Object?>)['TR']!
                  as Map<String, Object?>)['phone'] =
              'ara beni',
    };
    for (final MapEntry(key: name, value: corrupt) in cases.entries) {
      test(name, () {
        final json = _table();
        corrupt(json);
        expect(() => parseDiagnosisTable(json), throwsFormatException);
      });
    }

    test('nesne olmayan tablo', () {
      expect(() => parseDiagnosisTable([]), throwsFormatException);
    });
  });

  group('diagnose', () {
    final table = parseDiagnosisTable(_table());
    List<String> ids(Set<String> selected) => [
      for (final match in diagnose(table, selected)) match.rule.id,
    ];

    test('seçim yoksa ya da hiçbir kural eşleşmezse boş', () {
      expect(diagnose(table, {}), isEmpty);
      expect(diagnose(table, {'x'}), isEmpty);
    });

    test('çok eşleşen önce; eşitse payı büyük, sonra ihbarı mecburi, sonra '
        'tablo sırası', () {
      // one 2/3, two 2/2, four 2/2 (ihbarı mecburi).
      expect(ids({'a', 'b'}), ['four', 'two', 'one']);
      // one 1/3, three 1/1 (ihbarı mecburi).
      expect(ids({'c'}), ['three', 'one']);
      // one 3/3, sonra 2'li ve 1'li eşleşmeler.
      expect(ids({'a', 'b', 'c'}), ['one', 'four', 'two', 'three']);
    });

    test('eşleşen belirti sayısını verir', () {
      final match = diagnose(table, {
        'a',
        'c',
      }).firstWhere((match) => match.rule.id == 'one');
      expect(match.matched, 2);
    });
  });

  test('kurum bölge profiline göre: TR profilinde TR, yoksa GLOBAL', () {
    final table = parseDiagnosisTable(_table());
    expect(diagnosisAuthority(table, RegionProfile.tr).phone, '174');
    expect(
      diagnosisAuthority(table, RegionProfile.other).name['en'],
      'Local authority',
    );

    final json = _table();
    (json['authorities']! as Map<String, Object?>).remove('TR');
    expect(
      diagnosisAuthority(
        parseDiagnosisTable(json),
        RegionProfile.tr,
      ).name['en'],
      'Local authority',
    );
  });

  test('arama adresi boşlukları atar; numara yoksa null', () {
    final table = parseDiagnosisTable(_table());
    final json = _table();
    ((json['authorities']! as Map<String, Object?>)['TR']!
            as Map<String, Object?>)['phone'] =
        '+90 312 000';

    expect(authorityPhoneUri(table.authorities['TR']!), Uri.parse('tel:174'));
    expect(
      authorityPhoneUri(parseDiagnosisTable(json).authorities['TR']!),
      Uri.parse('tel:+90312000'),
    );
    expect(authorityPhoneUri(table.authorities['GLOBAL']!), isNull);
  });

  test('metin arayüz dilinde, yoksa EN', () {
    const text = {'tr': 'Kireç', 'en': 'Chalkbrood'};
    expect(localizedText(text, 'tr'), 'Kireç');
    expect(localizedText(text, 'en'), 'Chalkbrood');
    expect(localizedText(text, 'de'), 'Chalkbrood');
  });

  test('bilinmeyen ya da boş kimliğin kuralı yok', () {
    final table = parseDiagnosisTable(_table());
    expect(diagnosisRule(table, 'two')!.id, 'two');
    expect(diagnosisRule(table, 'yok'), isNull);
    expect(diagnosisRule(table, null), isNull);
  });
}

import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/features/health/domain/diagnosis.dart';

/// Kural tablosunun okunabilen biçimi.
const diagnosisFormat = 1;

/// Yetkili kurumun bölge anahtarları.
const diagnosisAuthorityTr = 'TR';
const diagnosisAuthorityGlobal = 'GLOBAL';

/// Kimlikler: küçük harf, rakam ve alt çizgi; karantina kaydına sığar.
final _id = RegExp(r'^[a-z0-9_]{1,100}$');
final _phone = RegExp(r'^\+?[0-9 ]{2,20}$');

/// `assets/diagnosis/rules.json`'u okur ve denetler (şeması
/// `rules.schema.json`): kimlikler tekil, kuralların belirtileri tabloda
/// var, metinler TR ve EN birlikte, `GLOBAL` kurum var. Uymazsa
/// [FormatException] atar.
DiagnosisTable parseDiagnosisTable(Object? json) {
  if (json is! Map<String, Object?>) {
    throw const FormatException('Tablo bir nesne olmalı');
  }
  if (json['format'] != diagnosisFormat) {
    throw FormatException('Desteklenmeyen biçim', json['format']);
  }

  final symptoms = [
    for (final item in _list(json['symptoms'], 'symptoms'))
      switch (item) {
        {'id': final Object? id, 'label': final Object? label} =>
          DiagnosisSymptom(id: _parseId(id), label: _text(label)),
        _ => throw FormatException('Geçersiz belirti', item),
      },
  ];
  final symptomIds = _unique(symptoms.map((symptom) => symptom.id));

  final rules = [
    for (final item in _list(json['rules'], 'rules'))
      switch (item) {
        {
          'id': final Object? id,
          'name': final Object? name,
          'symptoms': final Object? ruleSymptoms,
          'notifiable': final bool notifiable,
          'advice': final Object? advice,
        } =>
          DiagnosisRule(
            id: _parseId(id),
            name: _text(name),
            symptoms: _ruleSymptoms(ruleSymptoms, symptomIds),
            notifiable: notifiable,
            advice: _text(advice),
          ),
        _ => throw FormatException('Geçersiz kural', item),
      },
  ];
  _unique(rules.map((rule) => rule.id));

  final authorities = switch (json['authorities']) {
    final Map<String, Object?> map => {
      for (final MapEntry(:key, :value) in map.entries)
        if (key == diagnosisAuthorityTr || key == diagnosisAuthorityGlobal)
          key: _authority(value)
        else
          key: throw FormatException('Bilinmeyen bölge', key),
    },
    final other => throw FormatException('Geçersiz kurumlar', other),
  };
  if (!authorities.containsKey(diagnosisAuthorityGlobal)) {
    throw const FormatException('GLOBAL kurum yok');
  }

  return DiagnosisTable(
    symptoms: symptoms,
    rules: rules,
    authorities: authorities,
  );
}

List<Object?> _list(Object? value, String key) => switch (value) {
  final List<Object?> list when list.isNotEmpty => list,
  _ => throw FormatException('Boş ya da geçersiz liste', key),
};

String _parseId(Object? value) => switch (value) {
  final String id when _id.hasMatch(id) => id,
  _ => throw FormatException('Geçersiz kimlik', value),
};

Set<String> _unique(Iterable<String> ids) {
  final seen = <String>{};
  for (final id in ids) {
    if (!seen.add(id)) throw FormatException('Tekrarlanan kimlik', id);
  }
  return seen;
}

List<String> _ruleSymptoms(Object? value, Set<String> known) {
  final ids = [for (final id in _list(value, 'symptoms')) _parseId(id)];
  _unique(ids);
  for (final id in ids) {
    if (!known.contains(id)) throw FormatException('Bilinmeyen belirti', id);
  }
  return ids;
}

LocalizedText _text(Object? value) => switch (value) {
  {'tr': final String tr, 'en': final String en}
      when tr.trim().isNotEmpty && en.trim().isNotEmpty =>
    {'tr': tr, 'en': en},
  _ => throw FormatException('Metin TR ve EN birlikte olmalı', value),
};

DiagnosisAuthority _authority(Object? value) => switch (value) {
  {'name': final Object? name} && final Map<String, Object?> map =>
    DiagnosisAuthority(
      name: _text(name),
      detail: map['detail'] == null ? null : _text(map['detail']),
      phone: switch (map['phone']) {
        null => null,
        final String phone when _phone.hasMatch(phone) => phone,
        final other => throw FormatException('Geçersiz telefon', other),
      },
    ),
  _ => throw FormatException('Geçersiz kurum', value),
};

/// [text]'in [language]'deki karşılığı; yoksa EN.
String localizedText(LocalizedText text, String language) =>
    text[language] ?? text['en'] ?? text.values.first;

/// Olası hastalık: kural ve seçilen belirtilerden kaçının kuralda olduğu.
typedef DiagnosisMatch = ({DiagnosisRule rule, int matched});

/// Seçilen belirtilere göre olası hastalıklar: en az bir belirtisi seçilen
/// kurallar; çok eşleşen önce, eşitse belirtilerinin büyük payı eşleşen,
/// o da eşitse ihbarı mecburi olan, sonra tablodaki sıra.
List<DiagnosisMatch> diagnose(DiagnosisTable table, Set<String> selected) {
  final matches =
      [
        for (final (index, rule) in table.rules.indexed)
          if (rule.symptoms.where(selected.contains).length case final matched
              when matched > 0)
            (index: index, match: (rule: rule, matched: matched)),
      ]..sort((a, b) {
        final byCount = b.match.matched.compareTo(a.match.matched);
        if (byCount != 0) return byCount;
        final byShare = (b.match.matched / b.match.rule.symptoms.length)
            .compareTo(a.match.matched / a.match.rule.symptoms.length);
        if (byShare != 0) return byShare;
        if (a.match.rule.notifiable != b.match.rule.notifiable) {
          return a.match.rule.notifiable ? -1 : 1;
        }
        return a.index.compareTo(b.index);
      });
  return [for (final entry in matches) entry.match];
}

/// [id]'li kural; tabloda yoksa null.
DiagnosisRule? diagnosisRule(DiagnosisTable table, String? id) {
  for (final rule in table.rules) {
    if (rule.id == id) return rule;
  }
  return null;
}

/// Bölgenin yetkili kurumu: TR profilinde `TR`, yoksa ve diğer bölgelerde
/// `GLOBAL`.
DiagnosisAuthority diagnosisAuthority(
  DiagnosisTable table,
  RegionProfile profile,
) =>
    (profile == RegionProfile.tr
        ? table.authorities[diagnosisAuthorityTr]
        : null) ??
    table.authorities[diagnosisAuthorityGlobal]!;

/// Kurumun aranacak adresi (`tel:`); numarası yoksa null.
Uri? authorityPhoneUri(DiagnosisAuthority authority) {
  final phone = authority.phone;
  if (phone == null) return null;
  return Uri(scheme: 'tel', path: phone.replaceAll(' ', ''));
}

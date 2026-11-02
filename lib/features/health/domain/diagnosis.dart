import 'package:freezed_annotation/freezed_annotation.dart';

part 'diagnosis.freezed.dart';

/// Dile göre metin (`{"tr": …, "en": …}`); `localizedText` arayüz dilini
/// seçer.
typedef LocalizedText = Map<String, String>;

/// Teşhis yardımcısında seçilen belirti (ör. "kireçleşmiş larva").
@freezed
abstract class DiagnosisSymptom with _$DiagnosisSymptom {
  const factory({required String id, required LocalizedText label}) =
      _DiagnosisSymptom;
}

/// Kural: bir hastalık ve belirtileri. [notifiable] ihbarı mecburi
/// hastalık; sonuçta yetkili kurum ve kovanı karantinaya alma çıkar. [id]
/// kovanın karantina kaydında (`hives.quarantine_disease`) saklanır.
@freezed
abstract class DiagnosisRule with _$DiagnosisRule {
  const factory({
    required String id,
    required LocalizedText name,

    /// [DiagnosisSymptom.id] değerleri.
    required List<String> symptoms,
    required bool notifiable,

    /// Ne yapılmalı.
    required LocalizedText advice,
  }) = _DiagnosisRule;
}

/// İhbarı mecburi hastalığın bildirileceği yetkili kurum.
@freezed
abstract class DiagnosisAuthority with _$DiagnosisAuthority {
  const factory({
    required LocalizedText name,
    LocalizedText? detail,

    /// Aranacak numara (ör. "174").
    String? phone,
  }) = _DiagnosisAuthority;
}

/// Kural tablosu (`assets/diagnosis/rules.json`, şeması
/// `rules.schema.json`). Yetkili kurumlar bölge profiline göre: `TR` ve
/// `GLOBAL`.
@freezed
abstract class DiagnosisTable with _$DiagnosisTable {
  const factory({
    required List<DiagnosisSymptom> symptoms,
    required List<DiagnosisRule> rules,
    required Map<String, DiagnosisAuthority> authorities,
  }) = _DiagnosisTable;
}

import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';

/// Güç puanının aralığı.
const minStrength = 1;
const maxStrength = 5;

/// Kovanın güç puanı (1–5), son muayenesinin [values] değerlerinden.
///
/// Taban arılı çerçeve sayısından gelir: 0–2 → 1, 3–4 → 2, 5–6 → 3,
/// 7–8 → 4, 9 ve üstü → 5. Ana arının yok olması, yavrulu çerçeve
/// olmaması ve hastalık şüphesi birer puan düşürür; puan [minStrength]'in
/// altına inmez. Boş alan "bakılmadı" demektir, puan düşürmez. Taze
/// yumurta (ana görülmedi) ananın varlığı sayılır.
///
/// Arılı çerçeve girilmemişse puan yok (null). Diğer alanlar (ballı
/// çerçeve, mizaç, oğul belirtisi, meme, işlemler) puanı etkilemez.
int? strengthScore(InspectionValues values) {
  final beeFrames = values.beeFrames;
  if (beeFrames == null) return null;
  final base = switch (beeFrames) {
    <= 2 => 1,
    <= 4 => 2,
    <= 6 => 3,
    <= 8 => 4,
    _ => maxStrength,
  };
  final penalty = [
    values.queenState == QueenState.none,
    values.broodFrames == 0,
    values.diseaseSuspected ?? false,
  ].where((applies) => applies).length;
  return (base - penalty).clamp(minStrength, maxStrength);
}

/// Zayıflar önce: puanı olan kovanlar 1'den 5'e, puansızlar ([strengths]'te
/// olmayanlar) en sonda; eşit puanda numara sırası ("9" < "10"), numara da
/// aynıysa kimlik. [hives] değişmez, yeni liste döner.
List<Hive> sortWeakestFirst(Iterable<Hive> hives, Map<String, int> strengths) {
  int compare(Hive a, Hive b) {
    final byStrength = switch ((strengths[a.id], strengths[b.id])) {
      (final a?, final b?) => a.compareTo(b),
      (_?, null) => -1,
      (null, _?) => 1,
      (null, null) => 0,
    };
    if (byStrength != 0) return byStrength;
    final byNumber = compareNatural(a.number, b.number);
    return byNumber != 0 ? byNumber : a.id.compareTo(b.id);
  }

  return [...hives]..sort(compare);
}

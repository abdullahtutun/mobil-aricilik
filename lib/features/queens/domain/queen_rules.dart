import 'dart:math' as math;

import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

/// Bu yaşa giren ana değiştirilmeli; yaşlı analar listesine düşer.
const queenReplacementAge = 2;

/// Formda sunulan yıl sayısı: bu yıl ve önceki dört yıl, yani renk
/// kodunun bir turu.
const queenYearChoices = 5;

/// Uluslararası işaret rengi, yılın son hanesinden: 1/6 beyaz, 2/7 sarı,
/// 3/8 kırmızı, 4/9 yeşil, 5/0 mavi.
QueenMarkColor markColorForYear(int year) => switch (year % 5) {
  1 => QueenMarkColor.white,
  2 => QueenMarkColor.yellow,
  3 => QueenMarkColor.red,
  4 => QueenMarkColor.green,
  _ => QueenMarkColor.blue,
};

/// Yıl değişince işaret rengi. Renk eski yılın rengiyse (öneriyi
/// izliyorsa) yeni yılın rengine geçer; arıcının ayrıca seçtiği renk ya da
/// işaretsiz ana olduğu gibi kalır.
QueenMarkColor? markColorAfterYearChange({
  required int? fromYear,
  required int? toYear,
  required QueenMarkColor? markColor,
}) {
  final followsYear =
      fromYear != null && markColor == markColorForYear(fromYear);
  if (!followsYear || toYear == null) return markColor;
  return markColorForYear(toYear);
}

/// Yalnız yıl tutulduğundan yaş yıl farkıdır; gelecek yıl 0 sayılır.
int queenAge(int year, {required int currentYear}) =>
    math.max(0, currentYear - year);

/// Yılı bilinen ve [queenReplacementAge] yaşına girmiş ana.
bool isOldQueen(Queen queen, {required int currentYear}) =>
    switch (queen.year) {
      final year? =>
        queenAge(year, currentYear: currentYear) >= queenReplacementAge,
      null => false,
    };

/// Formdaki yıl seçenekleri, yeniden eskiye: bu yıl ve önceki yıllar
/// ([queenYearChoices]). Kayıtlı yıl bu aralıkta değilse o da eklenir.
List<int> queenYearOptions({required int currentYear, int? savedYear}) => {
  for (var i = 0; i < queenYearChoices; i++) currentYear - i,
  ?savedYear,
}.toList()..sort((a, b) => b.compareTo(a));

/// Kovan ve içindeki ana.
typedef HiveQueen = ({Hive hive, Queen queen});

/// Aktif kovanlardaki yaşlı analar ([isOldQueen]): en yaşlı önce, aynı
/// yılda kovan numarasıyla. Aktif olmayan kovanın anası değiştirilmez,
/// listelenmez.
List<HiveQueen> oldQueensInHives(
  List<Hive> hives,
  List<Queen> queens, {
  required int currentYear,
}) {
  final byId = {for (final queen in queens) queen.id: queen};
  return [
    for (final hive in hives)
      if (hive.status.isCounted)
        if (byId[hive.queenId] case final queen?)
          if (isOldQueen(queen, currentYear: currentYear))
            (hive: hive, queen: queen),
  ]..sort(
    (a, b) => switch (a.queen.year!.compareTo(b.queen.year!)) {
      0 => compareNatural(a.hive.number, b.hive.number),
      final order => order,
    },
  );
}

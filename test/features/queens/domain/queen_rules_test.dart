import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';

final _at = DateTime.utc(2026);

Queen _queen(String id, {int? year}) =>
    Queen(id: id, orgId: 'org-1', year: year, createdAt: _at, updatedAt: _at);

Hive _hive(
  String number, {
  String? queenId,
  HiveStatus status = HiveStatus.active,
}) => Hive(
  id: 'hive-$number',
  orgId: 'org-1',
  number: number,
  type: HiveType.langstroth,
  status: status,
  apiaryId: 'apiary-1',
  queenId: queenId,
  createdAt: _at,
  updatedAt: _at,
);

void main() {
  group('markColorForYear', () {
    test('son haneye göre: 1/6 beyaz, 2/7 sarı, 3/8 kırmızı, 4/9 yeşil, '
        '5/0 mavi', () {
      expect(
        {
          for (var year = 2021; year <= 2030; year++)
            year: markColorForYear(year),
        },
        {
          2021: QueenMarkColor.white,
          2022: QueenMarkColor.yellow,
          2023: QueenMarkColor.red,
          2024: QueenMarkColor.green,
          2025: QueenMarkColor.blue,
          2026: QueenMarkColor.white,
          2027: QueenMarkColor.yellow,
          2028: QueenMarkColor.red,
          2029: QueenMarkColor.green,
          2030: QueenMarkColor.blue,
        },
      );
    });

    test('2000 mavi; renk beş yılda bir döner', () {
      expect(markColorForYear(2000), QueenMarkColor.blue);
      for (var year = 2000; year < 2100; year++) {
        expect(markColorForYear(year + 5), markColorForYear(year));
      }
    });
  });

  group('markColorAfterYearChange', () {
    test('renk eski yılın rengiyse yeni yılın rengine geçer', () {
      expect(
        markColorAfterYearChange(
          fromYear: 2026,
          toYear: 2025,
          markColor: QueenMarkColor.white,
        ),
        QueenMarkColor.blue,
      );
    });

    test('arıcının seçtiği başka renk ve işaretsiz ana kalır', () {
      expect(
        markColorAfterYearChange(
          fromYear: 2026,
          toYear: 2025,
          markColor: QueenMarkColor.red,
        ),
        QueenMarkColor.red,
      );
      expect(
        markColorAfterYearChange(fromYear: 2026, toYear: 2025, markColor: null),
        isNull,
      );
    });

    test('yıl bilinmiyorsa ya da kaldırılırsa renk kalır', () {
      expect(
        markColorAfterYearChange(
          fromYear: null,
          toYear: 2025,
          markColor: QueenMarkColor.white,
        ),
        QueenMarkColor.white,
      );
      expect(
        markColorAfterYearChange(
          fromYear: 2026,
          toYear: null,
          markColor: QueenMarkColor.white,
        ),
        QueenMarkColor.white,
      );
    });
  });

  test('queenAge yıl farkı; gelecek yıl 0', () {
    expect(queenAge(2026, currentYear: 2026), 0);
    expect(queenAge(2024, currentYear: 2026), 2);
    expect(queenAge(2027, currentYear: 2026), 0);
  });

  test('isOldQueen: 2 yaşına giren yaşlı, yılı bilinmeyen değil', () {
    expect(isOldQueen(_queen('a', year: 2024), currentYear: 2026), isTrue);
    expect(isOldQueen(_queen('b', year: 2020), currentYear: 2026), isTrue);
    expect(isOldQueen(_queen('c', year: 2025), currentYear: 2026), isFalse);
    expect(isOldQueen(_queen('d'), currentYear: 2026), isFalse);
  });

  test('queenYearOptions: bu yıldan geriye beş yıl; dışındaki kayıtlı yıl '
      'sıraya eklenir', () {
    expect(queenYearOptions(currentYear: 2026), [2026, 2025, 2024, 2023, 2022]);
    expect(queenYearOptions(currentYear: 2026, savedYear: 2024), [
      2026,
      2025,
      2024,
      2023,
      2022,
    ]);
    expect(queenYearOptions(currentYear: 2026, savedYear: 2019), [
      2026,
      2025,
      2024,
      2023,
      2022,
      2019,
    ]);
  });

  test('oldQueensInHives: yalnız aktif kovanlardaki yaşlı analar, en yaşlı '
      'önce, aynı yılda numara sırasıyla', () {
    final queens = [
      _queen('q2024a', year: 2024),
      _queen('q2024b', year: 2024),
      _queen('q2022', year: 2022),
      _queen('q2025', year: 2025),
      _queen('qNoYear'),
      _queen('qDead', year: 2020),
    ];
    final hives = [
      _hive('10', queenId: 'q2024a'),
      _hive('9', queenId: 'q2024b'),
      _hive('3', queenId: 'q2022'),
      _hive('4', queenId: 'q2025'),
      _hive('5', queenId: 'qNoYear'),
      _hive('6', queenId: 'qDead', status: HiveStatus.dead),
      _hive('7'),
      _hive('8', queenId: 'yok'),
    ];

    final result = oldQueensInHives(hives, queens, currentYear: 2026);

    expect([for (final entry in result) entry.hive.number], ['3', '9', '10']);
    expect(
      [for (final entry in result) entry.queen.id],
      ['q2022', 'q2024b', 'q2024a'],
    );
  });
}

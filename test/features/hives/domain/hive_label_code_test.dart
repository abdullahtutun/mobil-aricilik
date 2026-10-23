import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/app/deep_link.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';

const _id = '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a';

void main() {
  group('hiveLabelCode', () {
    test('mobilarici://h/<kimlik>', () {
      expect(hiveLabelCode(_id), 'mobilarici://h/$_id');
    });

    test('derin link olarak /h/<kimlik> konumuna çevrilir', () {
      expect(deepLinkLocation(Uri.parse(hiveLabelCode(_id))), '/h/$_id');
    });
  });

  group('hiveIdFromLabelCode', () {
    test('kendi etiketimizden kimliği çıkarır', () {
      expect(hiveIdFromLabelCode('mobilarici://h/$_id'), _id);
    });

    test(
      'baştaki/sondaki boşluk ve büyük harf sorun değil; kimlik küçülür',
      () {
        expect(
          hiveIdFromLabelCode('  MOBILARICI://H/${_id.toUpperCase()}\n'),
          _id,
        );
      },
    );

    test('başka şema, host ya da biçim etiketimiz sayılmaz', () {
      for (final code in [
        'mobilaricilik://h/$_id',
        'https://h/$_id',
        'mobilarici://hives/$_id',
        'mobilarici://h/$_id/edit',
        'mobilarici://h/',
        'mobilarici://h/101',
        'mobilarici://h/$_id?x=1',
        'mobilarici://h/$_id#a',
        _id,
        '4006381333931',
        '',
      ]) {
        expect(hiveIdFromLabelCode(code), isNull, reason: code);
      }
    });
  });

  group('normalizeLabelCode', () {
    test('kendi etiketimiz standart linke döner', () {
      expect(
        normalizeLabelCode(' MOBILARICI://h/${_id.toUpperCase()} '),
        'mobilarici://h/$_id',
      );
    });

    test('başka kodun yalnız baştaki ve sondaki boşlukları atılır', () {
      expect(normalizeLabelCode('  AB-12 cd\n'), 'AB-12 cd');
      expect(normalizeLabelCode('mobilarici://h/101'), 'mobilarici://h/101');
    });
  });
}

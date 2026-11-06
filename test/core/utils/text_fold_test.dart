import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/text_fold.dart';

void main() {
  group('foldForSearch', () {
    test('küçük harfe çevirir, Türkçe harfleri ve aksanları sadeleştirir', () {
      expect(foldForSearch('İĞÜŞÖÇ ığüşöç I'), 'igusoc igusoc i');
      expect(foldForSearch('KİREÇ Hastalığı'), 'kirec hastaligi');
      expect(foldForSearch('IŞIK'), 'isik');
      expect(foldForSearch('Ağaç ÖĞÜT'), 'agac ogut');
      expect(foldForSearch('Réunion São Tomé'), 'reunion sao tome');
      expect(foldForSearch('Hâlâ îmân ûmran'), 'hala iman umran');
      expect(foldForSearch('Côte d’Ivoire'), "cote d'ivoire");
    });

    test('Almanca, İspanyolca ve Portekizce harfler', () {
      expect(foldForSearch('Bienenstöcke Größe'), 'bienenstocke grosse');
      expect(foldForSearch('Colmena ÑANDÚ'), 'colmena nandu');
      expect(foldForSearch('Própolis Ação'), 'propolis acao');
    });

    test('Kiril: küçük harf, ё → е', () {
      expect(foldForSearch('МЁД Улей'), 'мед улей');
      expect(foldForSearch('Вулик ЇЖАК'), 'вулик їжак');
    });

    test('Farsça: Arapça klavye harfleri Farsça karşılığına', () {
      expect(foldForSearch('كندو'), foldForSearch('کندو'));
      expect(foldForSearch('ملكه'), 'ملکه');
      expect(foldForSearch('عسلي'), 'عسلی');
      expect(foldForSearch('آب'), 'اب');
    });
  });
}

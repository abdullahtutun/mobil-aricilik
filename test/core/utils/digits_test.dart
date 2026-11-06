import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/digits.dart';

void main() {
  group('asciiDigits', () {
    test('Farsça ve Arapça rakamlar Latin, Arapça ondalık virgül olur', () {
      expect(asciiDigits('۱۲۳۴۵۶۷۸۹۰'), '1234567890');
      expect(asciiDigits('٠١٢٣٤٥٦٧٨٩'), '0123456789');
      expect(asciiDigits('۵۷۴٫۵'), '574,5');
    });

    test('başka karakterlere dokunmaz, uzunluk aynı kalır', () {
      expect(asciiDigits('17.5 kg, کندو'), '17.5 kg, کندو');
      const text = 'A-۱۰۱';
      expect(asciiDigits(text).length, text.length);
    });
  });

  test('biçimlendirici süzgeçten önce rakamları çevirir', () {
    TextEditingValue run(String text) {
      var value = TextEditingValue(
        text: text,
        selection: TextSelection.collapsed(offset: text.length),
      );
      for (final formatter in [
        const AsciiDigitsFormatter(),
        FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
      ]) {
        value = formatter.formatEditUpdate(TextEditingValue.empty, value);
      }
      return value;
    }

    expect(run('۱۲٫۵').text, '12,5');
    expect(run('۱۲٫۵').selection.baseOffset, 4);
  });
}

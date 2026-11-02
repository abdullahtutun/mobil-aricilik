import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/utils/csv.dart';

void main() {
  test('UTF-8 BOM ile başlar, satırlar CRLF; Türkçe harfler korunur', () {
    final bytes = encodeCsv([
      ['Kovan', 'Arılık'],
      ['101', 'Çamlık Yaylası'],
    ], separator: ';');

    expect(bytes.take(3), [0xEF, 0xBB, 0xBF]);
    expect(
      utf8.decode(bytes.skip(3).toList()),
      'Kovan;Arılık\r\n101;Çamlık Yaylası\r\n',
    );
  });

  test('ayraç, tırnak ya da satır sonu içeren hücre tırnağa alınır', () {
    final bytes = encodeCsv([
      ['Amitraz; şerit', 'Ana "Kafkas"', 'iki\nsatır', 'düz'],
    ], separator: ';');

    expect(
      utf8.decode(bytes.skip(3).toList()),
      '"Amitraz; şerit";"Ana ""Kafkas""";"iki\nsatır";düz\r\n',
    );
  });

  test('ayraç dile göre: ondalığı virgül olan dilde noktalı virgül', () {
    expect(csvSeparatorFor('tr'), ';');
    expect(csvSeparatorFor('de'), ';');
    expect(csvSeparatorFor('en'), ',');
  });

  test('dosya adında sorunlu karakterler tireye döner', () {
    expect(csvFileName('Sezon 2026/27'), 'Sezon 2026-27.csv');
  });
}

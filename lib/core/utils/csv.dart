import 'dart:convert';
import 'dart:typed_data';

import 'package:intl/intl.dart';

/// Excel'in açtığı CSV: UTF-8 (başında BOM, yoksa Excel Türkçe harfleri
/// bozar), satırlar CRLF ile. Ayraç, ayraç ya da tırnak ya da satır sonu
/// içeren hücre tırnağa alınır, içindeki tırnak ikilenir (RFC 4180).
Uint8List encodeCsv(List<List<String>> rows, {required String separator}) {
  String cell(String value) =>
      value.contains(separator) ||
          value.contains('"') ||
          value.contains('\n') ||
          value.contains('\r')
      ? '"${value.replaceAll('"', '""')}"'
      : value;
  final text = rows.map((row) => row.map(cell).join(separator)).join('\r\n');
  return Uint8List.fromList([0xEF, 0xBB, 0xBF, ...utf8.encode('$text\r\n')]);
}

/// Excel'in [locale] dilinde beklediği ayraç: ondalık ayracı virgül olan
/// dillerde (tr, de) noktalı virgül, öbürlerinde virgül.
String csvSeparatorFor(String locale) =>
    NumberFormat.decimalPattern(locale).symbols.DECIMAL_SEP == ',' ? ';' : ',';

/// Başlıktan CSV dosya adı: dosya adında sorun çıkaran karakterler tireye
/// döner.
String csvFileName(String title) =>
    '${title.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-').trim()}.csv';

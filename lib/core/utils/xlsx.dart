import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Yalnız gün taşıyan hücre (saat yok); Excel'de kısa tarih biçiminde.
final class XlsxDate {
  const new(this.value);

  final DateTime value;
}

/// Çalışma kitabının bir sayfası: ilk satır başlık (kalın, kaydırınca
/// sabit). Hücre değeri `String`, `num`, `DateTime` (tarih + saat, yerel
/// saatle), [XlsxDate] ya da boş (`null`).
final class XlsxSheet {
  const new({required this.name, required this.rows});

  final String name;
  final List<List<Object?>> rows;
}

/// Sayfaları Excel, Google E-Tablolar ve Numbers'ın açtığı bir `.xlsx`
/// dosyasına yazar (Office Open XML, en küçük parça kümesi). Metin satır
/// içinde (paylaşılan dizge tablosu yok); tarihler gün seri numarası ve
/// Excel'in yerel kısa tarih (14) ya da tarih-saat (22) biçimiyle. Sayfa
/// adları Excel'in kısıtına (31 karakter, `[]:*?/\` yok, tekil) uydurulur.
Uint8List encodeXlsx(List<XlsxSheet> sheets) {
  assert(sheets.isNotEmpty, 'en az bir sayfa gerekli');
  final names = _sheetNames([for (final sheet in sheets) sheet.name]);
  final archive = Archive();
  void add(String path, String xml) =>
      archive.add(ArchiveFile.bytes(path, utf8.encode(xml)));

  add('[Content_Types].xml', _contentTypes(sheets.length));
  add('_rels/.rels', _rootRels);
  add('xl/workbook.xml', _workbook(names));
  add('xl/_rels/workbook.xml.rels', _workbookRels(sheets.length));
  add('xl/styles.xml', _styles);
  for (final (index, sheet) in sheets.indexed) {
    add('xl/worksheets/sheet${index + 1}.xml', _worksheet(sheet.rows));
  }
  return ZipEncoder().encodeBytes(archive);
}

/// MIME türü (paylaşma sayfası için).
const xlsxMimeType =
    'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet';

/// Başlıktan `.xlsx` dosya adı: dosya adında sorun çıkaran karakterler
/// tireye döner.
String xlsxFileName(String title) =>
    '${title.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-').trim()}.xlsx';

/// Sütun harfi: 0 → A, 25 → Z, 26 → AA.
String xlsxColumn(int index) {
  var n = index + 1;
  final letters = <int>[];
  while (n > 0) {
    final rem = (n - 1) % 26;
    letters.insert(0, 0x41 + rem);
    n = (n - 1) ~/ 26;
  }
  return String.fromCharCodes(letters);
}

/// Excel'in gün seri numarası (1899-12-30 = 0); saat dilimi yok, duvar
/// saati yazılır. UTC verilirse önce yerel saate çevrilir.
double xlsxSerial(DateTime value) {
  final t = value.isUtc ? value.toLocal() : value;
  final wall = DateTime.utc(
    t.year,
    t.month,
    t.day,
    t.hour,
    t.minute,
    t.second,
    t.millisecond,
  );
  return wall.difference(DateTime.utc(1899, 12, 30)).inMilliseconds /
      Duration.millisecondsPerDay;
}

// Hücre biçimleri (styles.xml'deki cellXfs sırası).
const _styleHeader = 1;
const _styleDate = 2;
const _styleDateTime = 3;

const _main = 'http://schemas.openxmlformats.org/spreadsheetml/2006/main';
const _rel =
    'http://schemas.openxmlformats.org/officeDocument/2006/relationships';
const _packageRel =
    'http://schemas.openxmlformats.org/package/2006/relationships';
const _ooxml = 'application/vnd.openxmlformats-officedocument.spreadsheetml';
const _contentTypesNs =
    'http://schemas.openxmlformats.org/package/2006/content-types';
const _xmlHead = '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>';

// Parçalar arasındaki satır sonları XML'de anlamsız; okunur kalsın diye.
String _contentTypes(int sheetCount) => [
  _xmlHead,
  '<Types xmlns="$_contentTypesNs">',
  _tag('Default', {
    'Extension': 'rels',
    'ContentType': 'application/vnd.openxmlformats-package.relationships+xml',
  }),
  _tag('Default', {'Extension': 'xml', 'ContentType': 'application/xml'}),
  _tag('Override', {
    'PartName': '/xl/workbook.xml',
    'ContentType': '$_ooxml.sheet.main+xml',
  }),
  _tag('Override', {
    'PartName': '/xl/styles.xml',
    'ContentType': '$_ooxml.styles+xml',
  }),
  for (var i = 1; i <= sheetCount; i++)
    _tag('Override', {
      'PartName': '/xl/worksheets/sheet$i.xml',
      'ContentType': '$_ooxml.worksheet+xml',
    }),
  '</Types>',
].join('\n');

/// Boş XML öğesi: `<name a="1" b="2"/>`; değerler kaçırılır.
String _tag(String name, Map<String, String> attributes) {
  final pairs = [
    for (final MapEntry(:key, :value) in attributes.entries)
      '$key="${_escape(value)}"',
  ];
  return '<$name ${pairs.join(' ')}/>';
}

const _rootRels =
    '''
$_xmlHead
<Relationships xmlns="$_packageRel">
<Relationship Id="rId1" Type="$_rel/officeDocument" Target="xl/workbook.xml"/>
</Relationships>''';

String _workbook(List<String> names) => [
  _xmlHead,
  '<workbook xmlns="$_main" xmlns:r="$_rel"><sheets>',
  for (final (index, name) in names.indexed)
    _tag('sheet', {
      'name': name,
      'sheetId': '${index + 1}',
      'r:id': 'rId${index + 1}',
    }),
  '</sheets></workbook>',
].join('\n');

String _workbookRels(int sheetCount) => [
  _xmlHead,
  '<Relationships xmlns="$_packageRel">',
  for (var i = 1; i <= sheetCount; i++)
    _tag('Relationship', {
      'Id': 'rId$i',
      'Type': '$_rel/worksheet',
      'Target': 'worksheets/sheet$i.xml',
    }),
  _tag('Relationship', {
    'Id': 'rId${sheetCount + 1}',
    'Type': '$_rel/styles',
    'Target': 'styles.xml',
  }),
  '</Relationships>',
].join('\n');

const _styles =
    '''
$_xmlHead
<styleSheet xmlns="$_main">
<fonts count="2">
<font><sz val="11"/><name val="Calibri"/></font>
<font><b/><sz val="11"/><name val="Calibri"/></font>
</fonts>
<fills count="2">
<fill><patternFill patternType="none"/></fill>
<fill><patternFill patternType="gray125"/></fill>
</fills>
<borders count="1">
<border><left/><right/><top/><bottom/><diagonal/></border>
</borders>
<cellStyleXfs count="1">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0"/>
</cellStyleXfs>
<cellXfs count="4">
<xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/>
<xf numFmtId="0" fontId="1" fillId="0" borderId="0" xfId="0" applyFont="1"/>
<xf numFmtId="14" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>
<xf numFmtId="22" fontId="0" fillId="0" borderId="0" xfId="0" applyNumberFormat="1"/>
</cellXfs>
<cellStyles count="1">
<cellStyle name="Normal" xfId="0" builtinId="0"/>
</cellStyles>
</styleSheet>''';

String _worksheet(List<List<Object?>> rows) {
  final columnCount = rows.fold(
    0,
    (count, row) => row.length > count ? row.length : count,
  );
  final buffer = StringBuffer()
    ..writeln(_xmlHead)
    ..writeln('<worksheet xmlns="$_main">');
  if (rows.length > 1) {
    final pane = _tag('pane', {
      'ySplit': '1',
      'topLeftCell': 'A2',
      'activePane': 'bottomLeft',
      'state': 'frozen',
    });
    buffer.writeln(
      '<sheetViews><sheetView workbookViewId="0">$pane</sheetView></sheetViews>',
    );
  }
  if (columnCount > 0) {
    buffer.writeln('<cols>');
    for (var c = 0; c < columnCount; c++) {
      final width = _columnWidth(rows, c);
      buffer.writeln(
        '<col min="${c + 1}" max="${c + 1}" width="$width" customWidth="1"/>',
      );
    }
    buffer.writeln('</cols>');
  }
  buffer.writeln('<sheetData>');
  for (final (r, row) in rows.indexed) {
    buffer.write('<row r="${r + 1}">');
    for (final (c, value) in row.indexed) {
      final ref = '${xlsxColumn(c)}${r + 1}';
      final header = r == 0 ? ' s="$_styleHeader"' : '';
      switch (value) {
        case null:
          break;
        case num(isFinite: true):
          buffer.write('<c r="$ref"$header><v>$value</v></c>');
        case num():
          break;
        case XlsxDate(:final value):
          final serial = xlsxSerial(value).floor();
          buffer.write('<c r="$ref" s="$_styleDate"><v>$serial</v></c>');
        case DateTime():
          final serial = xlsxSerial(value);
          buffer.write('<c r="$ref" s="$_styleDateTime"><v>$serial</v></c>');
        default:
          final text = value.toString();
          if (text.isEmpty) break;
          final escaped = _escape(text);
          buffer
            ..write('<c r="$ref" t="inlineStr"$header>')
            ..write('<is><t xml:space="preserve">$escaped</t></is></c>');
      }
    }
    buffer.writeln('</row>');
  }
  buffer.write('</sheetData></worksheet>');
  return buffer.toString();
}

/// Sütunun en uzun değerine göre genişlik (karakter), 8 ile 50 arası.
int _columnWidth(List<List<Object?>> rows, int column) {
  var widest = 0;
  for (final row in rows) {
    if (column >= row.length) continue;
    final length = switch (row[column]) {
      null => 0,
      XlsxDate() => 10,
      DateTime() => 16,
      final value => value.toString().length,
    };
    if (length > widest) widest = length;
  }
  return (widest + 2).clamp(8, 50);
}

/// XML'de geçersiz denetim karakterleri atılır, özel karakterler kaçırılır.
String _escape(String text) => text
    .replaceAll(RegExp('[\u0000-\u0008\u000B\u000C\u000E-\u001F]'), '')
    .replaceAll('&', '&amp;')
    .replaceAll('<', '&lt;')
    .replaceAll('>', '&gt;')
    .replaceAll('"', '&quot;');

/// Excel'in sayfa adı kısıtı: en çok 31 karakter, `[]:*?/\` yok, boş değil
/// ve büyük-küçük harf gözetmeden tekil.
List<String> _sheetNames(List<String> names) {
  final used = <String>{};
  return [
    for (final (index, raw) in names.indexed)
      () {
        var base = raw.replaceAll(RegExp(r'[\[\]:*?/\\]'), '-').trim();
        if (base.isEmpty) base = 'Sheet${index + 1}';
        if (base.length > 31) base = base.substring(0, 31);
        var name = base;
        for (var n = 2; used.contains(name.toLowerCase()); n++) {
          final suffix = ' ($n)';
          name =
              '${base.substring(0, (31 - suffix.length).clamp(0, base.length))}'
              '$suffix';
        }
        used.add(name.toLowerCase());
        return name;
      }(),
  ];
}

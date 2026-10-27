import 'package:json_annotation/json_annotation.dart';

/// Saatsiz takvim günü (Postgres `date`): yerel gece yarısı olarak tutulur,
/// "2027-05-01" biçiminde yazılır. Saat dilimi değişse de gün kaymaz.
DateTime dateOnly(DateTime day) => DateTime(day.year, day.month, day.day);

/// "2027-05-01".
String formatDateOnly(DateTime day) =>
    '${day.year.toString().padLeft(4, '0')}-'
    '${day.month.toString().padLeft(2, '0')}-'
    '${day.day.toString().padLeft(2, '0')}';

/// "2027-05-01" (sunucu biçimi). Biçim tutmazsa [FormatException] atar.
DateTime parseDateOnly(String text) {
  final match = RegExp(r'^(\d{4})-(\d{2})-(\d{2})$').firstMatch(text);
  if (match == null) throw FormatException('Gün değil', text);
  return DateTime(
    int.parse(match[1]!),
    int.parse(match[2]!),
    int.parse(match[3]!),
  );
}

/// Freezed modellerde `date` kolonu; JSON'da "2027-05-01".
class DateOnlyJsonConverter implements JsonConverter<DateTime, String> {
  const new();

  @override
  DateTime fromJson(String json) => parseDateOnly(json);

  @override
  String toJson(DateTime object) => formatDateOnly(object);
}

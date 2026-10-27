import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

/// [ServerEnum]'u sunucudaki değeriyle metin kolonuna yazar. Bilinmeyen
/// değer (ör. daha yeni bir şemadan) [StateError] atar.
class ServerEnumConverter<T extends ServerEnum>
    extends TypeConverter<T, String> {
  const new(this.values);

  final List<T> values;

  @override
  T fromSql(String fromDb) => values.firstWhere((e) => e.value == fromDb);

  @override
  String toSql(T value) => value.value;
}

/// Saatsiz günü (Postgres `date`) sunucudaki gibi "2027-05-01" metni
/// olarak tutar; senkronla gelen değer de aynı biçimde.
class DateOnlyConverter extends TypeConverter<DateTime, String> {
  const new();

  @override
  DateTime fromSql(String fromDb) => parseDateOnly(fromDb);

  @override
  String toSql(DateTime value) => formatDateOnly(value);
}

/// JSON nesnesini metin kolonunda tutar.
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const new();

  @override
  Map<String, Object?> fromSql(String fromDb) =>
      jsonDecode(fromDb) as Map<String, Object?>;

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}

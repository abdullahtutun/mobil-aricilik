import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/server_enum.dart';

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

/// JSON nesnesini metin kolonunda tutar.
class JsonMapConverter extends TypeConverter<Map<String, Object?>, String> {
  const new();

  @override
  Map<String, Object?> fromSql(String fromDb) =>
      jsonDecode(fromDb) as Map<String, Object?>;

  @override
  String toSql(Map<String, Object?> value) => jsonEncode(value);
}

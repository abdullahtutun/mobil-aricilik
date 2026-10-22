import 'package:drift/drift.dart';

/// Senkronlanan her tablonun standart alanları; adlar sunucudakiyle aynı.
mixin SyncColumns on Table {
  /// İstemcide üretilen UUIDv7.
  TextColumn get id => text()();
  DateTimeColumn get createdAt => dateTime()();

  /// Son yazan kazanır; her yerel yazmada şimdiye çekilir.
  DateTimeColumn get updatedAt => dateTime()();

  /// Sunucu doldurur; yerelde oluşan kayıtta senkrona kadar boş.
  TextColumn get createdBy => text().nullable()();

  /// Yumuşak silme: dolu satır listelerde görünmez.
  DateTimeColumn get deletedAt => dateTime().nullable()();

  /// Çekme imleci; sunucuya henüz ulaşmamış kayıtta boş.
  IntColumn get serverSeq => integer().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// İşletmeye ait tablolar.
mixin OrgColumns on Table {
  TextColumn get orgId => text()();
}

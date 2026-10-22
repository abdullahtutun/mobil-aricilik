import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';

/// Outbox işlemi. Silme yumuşak olduğu için `delete` de satırın tam hâlini
/// (`deleted_at` dolu) taşır.
enum OutboxOperation { upsert, delete }

/// Sunucuya gönderilmeyi bekleyen yerel yazmalar (teknik.md §3). Her yazma
/// satırıyla aynı transaction'da buraya düşer; gönderim [id] sırasıyla.
@DataClassName('OutboxEntry')
class Outbox extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Yazılan tablonun adı (sunucudakiyle aynı).
  TextColumn get recordTable => text()();
  TextColumn get recordId => text()();
  TextColumn get operation => textEnum<OutboxOperation>()();

  /// Satırın yazma anındaki tam hâli, sunucunun kolon adlarıyla.
  TextColumn get payload => text().map(const JsonMapConverter())();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

/// Tablo başına son çekilen `server_seq`.
@DataClassName('SyncCursor')
class SyncState extends Table {
  TextColumn get recordTable => text()();
  IntColumn get lastPulledSeq => integer().withDefault(const Constant(0))();

  @override
  Set<Column<Object>> get primaryKey => {recordTable};
}

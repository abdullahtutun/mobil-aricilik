import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';

// Bu iki tablo yalnız bu telefonda: sunucuya bir kez gönderilip silinen
// kuyruklar. Sunucuda aynası yok, outbox'a yazılmaz, senkronla çekilmez.

/// Gönderilmeyi bekleyen görüşler ("Görüş bildir"). Gönderilince silinir.
@DataClassName('QueuedFeedback')
class FeedbackQueue extends Table {
  TextColumn get id => text()();
  TextColumn get orgId => text()();
  TextColumn get kind =>
      text().map(const ServerEnumConverter(FeedbackKind.values))();
  TextColumn get message => text()();

  /// Ekran görüntüsünün medya klasöründeki dosya adı.
  TextColumn get screenshotFileName => text().nullable()();

  /// Cihaz ve sürüm bilgisi (JSON); kullanıcı istemediyse boş.
  TextColumn get deviceInfo => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Boşsa hemen denenir.
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();

  /// Yeniden denemenin işe yaramayacağı hata (yetki, geçersiz mesaj);
  /// `last_error`'da nedeni.
  BoolColumn get failed => boolean().withDefault(const Constant(false))();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Gönderilmeyi bekleyen kullanım olayları. Gönderilince silinir;
/// analitik kapatılınca hepsi silinir.
@DataClassName('QueuedAnalyticsEvent')
class AnalyticsQueue extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();

  /// Olayın değerleri (JSON nesnesi).
  TextColumn get props => text()();
  DateTimeColumn get occurredAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

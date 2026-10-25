import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';

/// `public.media` aynası; olay tablosu. Dosyanın kendisi burada yok: bu
/// telefonda çekildiyse [MediaUploads]'taki yolda, başka telefonda
/// çekildiyse istenince indirilir.
@UseRowClass(MediaItem, generateInsertable: true)
@TableIndex(name: 'media_org_id_idx', columns: {#orgId})
@TableIndex(name: 'media_hive_id_idx', columns: {#hiveId})
class Media extends Table with SyncColumns, OrgColumns {
  TextColumn get hiveId => text()();
  TextColumn get inspectionId => text().nullable()();
  TextColumn get treatmentId => text().nullable()();
  TextColumn get kind =>
      text().map(const ServerEnumConverter(MediaKind.values))();
  TextColumn get storagePath => text()();
  DateTimeColumn get capturedAt => dateTime()();
  IntColumn get byteSize => integer()();
  IntColumn get durationMs => integer().nullable()();
}

// Aşağıdaki iki tablo yalnız bu telefonda: sunucuda aynası yok, outbox'a
// yazılmaz ve senkronla çekilmez.

/// Yükleme durumu (teknik.md §3 "Medya kuyruğu").
enum MediaUploadStatus {
  /// Yüklenmeyi bekliyor; geçici hatadan sonra [MediaUploads.nextAttemptAt]
  /// gelince yeniden denenir.
  pending,

  /// Storage'da; dosya bu telefonda da kalır.
  uploaded,

  /// Yeniden denemenin işe yaramayacağı hata (dosya yok, yetki yok, dosya
  /// çok büyük); `last_error`'da nedeni.
  failed,
}

/// Bu telefonda çekilen medyanın dosyası ve yükleme kuyruğu. Medya kaydıyla
/// aynı transaction'da `pending` olarak yazılır.
@DataClassName('MediaUpload')
class MediaUploads extends Table {
  TextColumn get mediaId => text()();
  TextColumn get orgId => text()();

  /// Uygulamanın medya klasöründeki dosya adı.
  TextColumn get fileName => text()();
  TextColumn get uploadStatus => textEnum<MediaUploadStatus>()();
  IntColumn get attempts => integer().withDefault(const Constant(0))();

  /// Boşsa hemen denenir.
  DateTimeColumn get nextAttemptAt => dateTime().nullable()();
  TextColumn get lastError => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column<Object>> get primaryKey => {mediaId};
}

/// Yalnız bu telefonun ayarları (ör. "sadece Wi‑Fi'da yükle"); arka plan
/// görevi de buradan okur.
@DataClassName('LocalSetting')
class LocalSettings extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column<Object>> get primaryKey => {key};
}

/// Senkronlanan bir tablonun satırı (freezed model).
///
/// Standart alanlar sunucudakiyle aynı: `id`, `created_at`, `updated_at`,
/// `created_by`, `deleted_at`, `server_seq`; işletmeye ait tablolarda
/// `org_id`. [toJson] sunucunun kolon adlarıyla (snake_case) üretir ve
/// `server_seq`'i dışarıda bırakır; outbox payload'u budur.
abstract interface class SyncedRecord {
  /// İstemcide üretilen UUIDv7.
  String get id;

  Map<String, Object?> toJson();
}

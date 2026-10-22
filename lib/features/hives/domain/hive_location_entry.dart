import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'hive_location_entry.freezed.dart';
part 'hive_location_entry.g.dart';

/// Olay (`hive_location_history`): kovan `movedAt` zamanında `apiaryId`
/// arılığına geldi. Arılıktan çıkışı, kovanın bir sonraki kaydıdır. Yalnız
/// eklenir; yanlış kayıt silinir.
@freezed
abstract class HiveLocationEntry
    with _$HiveLocationEntry
    implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required DateTime movedAt,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _HiveLocationEntry;

  factory fromJson(Map<String, Object?> json) =>
      _$HiveLocationEntryFromJson(json);
}

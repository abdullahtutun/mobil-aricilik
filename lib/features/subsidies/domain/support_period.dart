import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

part 'support_period.freezed.dart';
part 'support_period.g.dart';

/// Destek başvuru dönemi (`ref_support_periods`); salt okunur referans
/// liste, yalnız TR. İçeriği yönetici girer, senkronla iner. İki gün de
/// dahil.
@freezed
abstract class SupportPeriod with _$SupportPeriod implements SyncedRecord {
  const factory({
    required String id,
    required String name,
    @DateOnlyJsonConverter() required DateTime applicationStartsOn,
    @DateOnlyJsonConverter() required DateTime applicationEndsOn,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? description,

    /// Resmî duyurunun adresi (http/https).
    String? sourceUrl,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _SupportPeriod;

  factory fromJson(Map<String, Object?> json) => _$SupportPeriodFromJson(json);
}

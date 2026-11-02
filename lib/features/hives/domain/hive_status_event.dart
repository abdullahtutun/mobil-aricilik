import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

part 'hive_status_event.freezed.dart';
part 'hive_status_event.g.dart';

/// Kovanın kaybedilme nedeni (`public.hive_loss_reason`); yalnız söndü ya
/// da kayboldu'da.
@JsonEnum(valueField: 'value')
enum HiveLossReason implements ServerEnum {
  wintering('wintering'),
  queenless('queenless'),
  varroa('varroa'),
  disease('disease'),
  starvation('starvation'),
  robbing('robbing'),
  predator('predator'),
  poisoning('poisoning'),
  other('other');

  new(this.value);

  @override
  final String value;
}

/// Olay (`hive_status_events`): kovanın durumu `changedAt` anında
/// `fromStatus`'tan `toStatus`'a geçti; o sırada `apiaryId` arılığındaydı.
/// Yalnız eklenir; yanlış kayıt (Geri al) silinir.
@freezed
abstract class HiveStatusEvent with _$HiveStatusEvent implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,
    required String apiaryId,
    required HiveStatus fromStatus,
    required HiveStatus toStatus,
    required DateTime changedAt,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Yalnız söndü ya da kayboldu'da; boş: belirtilmemiş.
    HiveLossReason? lossReason,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _HiveStatusEvent;

  factory fromJson(Map<String, Object?> json) =>
      _$HiveStatusEventFromJson(json);
}

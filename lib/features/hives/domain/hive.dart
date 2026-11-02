import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'hive.freezed.dart';
part 'hive.g.dart';

/// `public.hive_type`.
@JsonEnum(valueField: 'value')
enum HiveType implements ServerEnum {
  langstroth('langstroth'),
  dadant('dadant'),
  local('local'),
  other('other');

  new(this.value);

  @override
  final String value;
}

/// Yaşam döngüsü (`public.hive_status`). Güç burada tutulmaz,
/// muayenelerden yerelde hesaplanır.
@JsonEnum(valueField: 'value')
enum HiveStatus implements ServerEnum {
  active('active'),
  dead('dead'),
  merged('merged'),
  sold('sold'),
  lost('lost');

  new(this.value);

  @override
  final String value;
}

/// Koloninin kaynağı: oğul, bölme, satın alma, paket arı
/// (`public.hive_source`).
@JsonEnum(valueField: 'value')
enum HiveSource implements ServerEnum {
  swarm('swarm'),
  split('split'),
  purchase('purchase'),
  package('package');

  new(this.value);

  @override
  final String value;
}

/// Kovan (`hives`). Durum kaydı: son yazan kazanır.
@freezed
abstract class Hive with _$Hive implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,

    /// Arıcının verdiği numara ("101", "A-12"); tekrar edebilir.
    required String number,
    required HiveType type,

    /// Güncel arılık; geçmişi `hive_location_history`'de.
    required String apiaryId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(HiveStatus.active) HiveStatus status,

    /// Önceden basılmış QR ya da NFC etiketin kodu.
    String? tagCode,
    String? queenId,
    @Default(1) int boxCount,
    int? frameCount,
    HiveSource? source,

    /// Kutunun rengi ya da üstündeki işaret.
    String? marking,

    /// İhbarı mecburi hastalık şüphesiyle karantinada; kovan aktif kalır.
    @Default(false) bool quarantined,

    /// Karantinanın başladığı an; yalnız [quarantined] iken dolu.
    DateTime? quarantinedAt,

    /// Şüphelenilen hastalığın teşhis kural tablosundaki kimliği.
    String? quarantineDisease,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Hive;

  factory fromJson(Map<String, Object?> json) => _$HiveFromJson(json);
}

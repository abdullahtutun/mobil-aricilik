import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'transport.freezed.dart';
part 'transport.g.dart';

/// Taşımanın adımı (`public.transport_status`).
@JsonEnum(valueField: 'value')
enum TransportStatus implements ServerEnum {
  /// Kovanlar okutularak araçlara yükleniyor.
  loading('loading'),

  /// Hedefte kovanlar yeniden okutularak indiriliyor.
  unloading('unloading'),

  /// İndirme bitti; indirilen kovanlar hedef arılıkta.
  completed('completed');

  new(this.value);

  @override
  final String value;
}

/// Aracın adı en çok bu kadar karakter (sunucudaki CHECK).
const maxVehicleNameLength = 60;

/// Bir taşıma (`transports`): kaynak ve hedef arılık, araçlar ve adım.
/// Durum kaydı: son yazan kazanır.
@freezed
abstract class Transport with _$Transport implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String sourceApiaryId,
    required String destinationApiaryId,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Araçların adları, eklenme sırasıyla ("Kamyon 1", "Kamyon 2").
    @Default(<String>[]) List<String> vehicles,
    @Default(TransportStatus.loading) TransportStatus status,

    /// Taşımanın götürdüğü göç durağı; plansız taşımada null.
    String? migrationStopId,

    /// İndirmenin bittiği an.
    DateTime? completedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Transport;

  factory fromJson(Map<String, Object?> json) => _$TransportFromJson(json);
}

/// Taşımadaki bir kovan (`transport_items`). Durum kaydı: indirilince
/// [unloadedAt] dolar.
@freezed
abstract class TransportItem with _$TransportItem implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String transportId,
    required String hiveId,

    /// Yüklendiği aracın adı.
    required String vehicle,
    required DateTime loadedAt,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Hedefte indirilirken okutulduğu an; indirilmediyse null.
    DateTime? unloadedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _TransportItem;

  factory fromJson(Map<String, Object?> json) => _$TransportItemFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'apiary.freezed.dart';
part 'apiary.g.dart';

/// Arazi: kendi arazisi, kiralık, izinli (`public.apiary_land_tenure`).
@JsonEnum(valueField: 'value')
enum LandTenure implements ServerEnum {
  owned('owned'),
  rented('rented'),
  permitted('permitted');

  new(this.value);

  @override
  final String value;
}

/// Arılık (`apiaries`). Durum kaydı: son yazan kazanır.
@freezed
abstract class Apiary with _$Apiary implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// WGS 84. Sunucuda tek bir `location` noktası; ikisi birlikte dolu ya
    /// da birlikte boş (GPS alınamadıysa).
    double? latitude,
    double? longitude,
    int? altitudeM,
    String? landownerName,
    String? landownerPhone,
    LandTenure? landTenure,
    String? waterSource,

    /// Aracın bırakıldığı yerden arılığa uzaklık.
    int? vehicleDistanceM,
    String? roadNotes,
    String? notes,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Apiary;

  factory fromJson(Map<String, Object?> json) => _$ApiaryFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

part 'migration.freezed.dart';
part 'migration.g.dart';

/// Durağın durumu (`public.migration_stop_status`).
@JsonEnum(valueField: 'value')
enum MigrationStopStatus implements ServerEnum {
  past('past'),

  /// Kovanlar şu an bu durakta; planda en çok bir durak.
  current('current'),
  planned('planned');

  new(this.value);

  @override
  final String value;
}

/// Planın adı, kaynağın adı ve yer en çok bu kadar karakter.
const maxMigrationNameLength = 120;
const maxStopPlaceLength = 120;

/// Planın yılı bu aralıkta (sunucudaki CHECK).
const minMigrationYear = 2000;
const maxMigrationYear = 2100;

/// Durağın sırası ve kovan sayısı en çok bu kadar (sunucudaki CHECK).
const maxStopPosition = 1000;
const maxStopHiveCount = 100000;

/// Bir yılın göç planı (`migrations`). Durum kaydı: son yazan kazanır.
@freezed
abstract class Migration with _$Migration implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required int year,
    required String name,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Migration;

  factory fromJson(Map<String, Object?> json) => _$MigrationFromJson(json);
}

/// Göç planının bir durağı (`migration_stops`). Durum kaydı: son yazan
/// kazanır.
@freezed
abstract class MigrationStop with _$MigrationStop implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String migrationId,

    /// Rotadaki sıra; küçük önce.
    required int position,

    /// Kaynağın adı ("Narenciye", "Çam").
    required String name,

    /// Planlanan ilk ve son konaklama günü (ikisi dahil).
    @DateOnlyJsonConverter() required DateTime plannedStartOn,
    @DateOnlyJsonConverter() required DateTime plannedEndOn,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(MigrationStopStatus.planned) MigrationStopStatus status,

    /// Yer ("Erdemli, Mersin").
    String? place,

    /// Hedef arılık; geçmiş yılların verimi onun hasatlarından.
    String? apiaryId,
    int? hiveCount,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _MigrationStop;

  factory fromJson(Map<String, Object?> json) => _$MigrationStopFromJson(json);
}

/// Yazılacak durağın değerleri.
typedef MigrationStopPlan = ({
  int position,
  String name,
  String? place,
  DateTime plannedStartOn,
  DateTime plannedEndOn,
  String? apiaryId,
  int? hiveCount,
  MigrationStopStatus status,
});

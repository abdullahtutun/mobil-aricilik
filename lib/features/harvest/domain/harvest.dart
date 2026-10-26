import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/features/health/domain/withdrawal.dart';

part 'harvest.freezed.dart';
part 'harvest.g.dart';

/// Bal türü (`public.honey_kind`).
@JsonEnum(valueField: 'value')
enum HoneyKind implements ServerEnum {
  pine('pine'),
  flower('flower'),
  chestnut('chestnut'),
  citrus('citrus'),
  other('other');

  new(this.value);

  @override
  final String value;
}

/// Hasatta alınanın birimi (`public.harvest_unit`): bal katı ya da çerçeve.
@JsonEnum(valueField: 'value')
enum HarvestUnit implements ServerEnum {
  superBox('super'),
  frame('frame');

  new(this.value);

  @override
  final String value;
}

/// Arılıkta bir hasat (`harvests`). Olay kaydı: yalnız eklenir, yanlış
/// kayıt silinir. Kat ya da çerçeve sayısı ve süzülen bal bütün hasadın
/// toplamı; kovan başına bölünmez. Hasada alınan kovanlar [HarvestHive].
@freezed
abstract class Harvest with _$Harvest implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,

    /// Hasadın yapıldığı arılık; kovanlar sonra taşınsa da değişmez.
    required String apiaryId,
    required DateTime harvestedAt,
    required HoneyKind honeyKind,
    required HarvestUnit unit,

    /// Alınan kat ya da çerçeve sayısı.
    required int unitCount,

    /// Süzülen bal, kilogram.
    required double netKg,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Harvest;

  factory fromJson(Map<String, Object?> json) => _$HarvestFromJson(json);
}

/// Hasada alınan kovan (`harvest_hives`); olay kaydı. Bekleme süresindeki
/// kovan bilerek alındıysa kilitleyen uygulama ve gerekçe birlikte dolu.
@freezed
abstract class HarvestHive with _$HarvestHive implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String harvestId,
    required String hiveId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? withdrawalTreatmentId,
    WithdrawalOverrideReason? withdrawalOverrideReason,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _HarvestHive;

  factory fromJson(Map<String, Object?> json) => _$HarvestHiveFromJson(json);
}

extension HarvestHiveFields on HarvestHive {
  /// Bekleme süresine rağmen hasada alındıysa gerekçesi; değilse null.
  WithdrawalOverride? get withdrawalOverride =>
      switch ((withdrawalTreatmentId, withdrawalOverrideReason)) {
        (final treatmentId?, final reason?) => WithdrawalOverride(
          treatmentId: treatmentId,
          reason: reason,
        ),
        _ => null,
      };
}

/// Yazılacak hasadın değerleri.
typedef HarvestPlan = ({
  String apiaryId,
  DateTime harvestedAt,
  HoneyKind honeyKind,
  HarvestUnit unit,
  int unitCount,

  /// Süzülen bal, kilogram.
  double netKg,
});

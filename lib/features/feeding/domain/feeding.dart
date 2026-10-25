import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'feeding.freezed.dart';
part 'feeding.g.dart';

/// Besleme türü (`public.feeding_kind`).
@JsonEnum(valueField: 'value')
enum FeedingKind implements ServerEnum {
  /// Şurup 1:1 (ağırlıkça şeker:su); teşvik.
  syrup1to1('syrup_1_1'),

  /// Şurup 2:1; kışlık.
  syrup2to1('syrup_2_1'),
  beeCake('bee_cake'),
  pollenSubstitute('pollen_substitute');

  new(this.value);

  @override
  final String value;

  /// Şurup: miktarı litre, bal katına karışabilir. Değilse (kek, polen
  /// ikamesi) miktarı kilogram.
  bool get isSyrup => this == syrup1to1 || this == syrup2to1;
}

/// Kovana besleme (`feedings`). Olay kaydı: yalnız eklenir, yanlış kayıt
/// silinir. Miktar kovan başına; şurupta litre, kek ve polen ikamesinde
/// kilogram. Şeker ve su saklanmaz, okurken hesaplanır (`syrupRecipe`).
@freezed
abstract class Feeding with _$Feeding implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,

    /// Beslemenin yapıldığı arılık; kovan sonra taşınsa da değişmez.
    required String apiaryId,

    /// Aynı anda birçok kovana yazılan beslemenin ortak kimliği; tek
    /// kovanda da dolu.
    required String feedingGroupId,
    required DateTime fedAt,
    required FeedingKind kind,

    /// Kovan başına; şurupta litre, değilse kilogram.
    required double amount,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Feeding;

  factory fromJson(Map<String, Object?> json) => _$FeedingFromJson(json);
}

/// Kovana ya da arılığın tümüne yazılan beslemenin değerleri.
typedef FeedingPlan = ({
  FeedingKind kind,

  /// Kovan başına; şurupta litre, değilse kilogram.
  double amount,
  DateTime fedAt,
});

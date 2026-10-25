import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'mite_count.freezed.dart';
part 'mite_count.g.dart';

/// Varroa ölçüm yöntemi (`public.mite_count_method`).
@JsonEnum(valueField: 'value')
enum MiteCountMethod implements ServerEnum {
  sugarRoll('sugar_roll'),
  alcoholWash('alcohol_wash'),

  /// Yapışkan alt tabla: örnek arı yok, kaç gün kaldığı yazılır.
  stickyBoard('sticky_board');

  new(this.value);

  @override
  final String value;

  /// Örnek arıyla yapılan yöntem; sonucu bulaşıklık yüzdesi. Değilse
  /// (alt tabla) sonuç günlük akar dökümü.
  bool get usesSample => this != stickyBoard;
}

/// Varroa ölçümü (`mite_counts`). Olay kaydı: yalnız eklenir, yanlış kayıt
/// silinir. Yüzde ya da günlük döküm saklanmaz, okurken hesaplanır
/// (`miteLoadOf`).
@freezed
abstract class MiteCount with _$MiteCount implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,

    /// Ölçümün yapıldığı arılık; kovan sonra taşınsa da değişmez.
    required String apiaryId,
    required DateTime countedAt,
    required MiteCountMethod method,

    /// Bulunan (alt tablada dökülen) akar.
    required int mites,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Yıkanan arı; yalnız örnekli yöntemlerde.
    int? sampleBees,

    /// Tablanın kovanda kaldığı gün; yalnız alt tablada.
    int? days,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _MiteCount;

  factory fromJson(Map<String, Object?> json) => _$MiteCountFromJson(json);
}

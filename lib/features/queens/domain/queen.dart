import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'queen.freezed.dart';
part 'queen.g.dart';

/// Ana arı işaret rengi: uluslararası beş renk (`public.queen_mark_color`,
/// değerler adıyla aynı). Görünümü `AppColors.queenMark`'ta.
enum QueenMarkColor { white, yellow, red, green, blue }

/// Kendi üretimi, satın alınan yetiştirici, sertifikalı damızlık
/// (`public.queen_source`).
@JsonEnum(valueField: 'value')
enum QueenSource implements ServerEnum {
  ownRearing('own_rearing'),
  purchased('purchased'),
  certifiedBreeder('certified_breeder');

  new(this.value);

  @override
  final String value;
}

/// `public.queen_mating_status`.
@JsonEnum(valueField: 'value')
enum QueenMatingStatus implements ServerEnum {
  virgin('virgin'),
  mated('mated');

  new(this.value);

  @override
  final String value;
}

/// Ana arı kartı (`queens`). Durum kaydı: son yazan kazanır.
@freezed
abstract class Queen with _$Queen implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Doğum ya da alım yılı; işaret rengi önerisi buradan çıkar.
    int? year,

    /// Boş: işaretsiz. Değerler `public.queen_mark_color` ile aynı.
    QueenMarkColor? markColor,
    String? breed,
    String? breedLine,
    QueenSource? source,

    /// Boş: bilinmiyor.
    QueenMatingStatus? matingStatus,
    @Default(false) bool wingClipped,
    String? motherQueenId,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Queen;

  factory fromJson(Map<String, Object?> json) => _$QueenFromJson(json);
}

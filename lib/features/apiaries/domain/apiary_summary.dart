import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';

part 'apiary_summary.freezed.dart';

/// Arılık listesinin satırı ve detayın üst kısmı.
@freezed
abstract class ApiarySummary with _$ApiarySummary {
  const factory({
    required Apiary apiary,

    /// Arılıktaki aktif kovanlar; sönen, birleşen, satılan ve kaybolan
    /// kovanlar sayılmaz.
    required int activeHiveCount,

    /// Son ziyaret. Muayene kayıtları gelene kadar hep boş.
    DateTime? lastVisitAt,
  }) = _ApiarySummary;
}

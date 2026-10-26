import 'package:freezed_annotation/freezed_annotation.dart';

part 'apiary_tour.freezed.dart';
part 'apiary_tour.g.dart';

/// Arılık turu (teknik.md §9): arılığın aktif kovanları sırayla muayene
/// edilir. Yalnız bu telefonda (`local_settings`) saklanır, senkronlanmaz;
/// uygulama kapansa da tur kaldığı yerden sürer. Aynı anda tek tur var.
@freezed
abstract class ApiaryTour with _$ApiaryTour {
  const factory({
    required String orgId,
    required String apiaryId,
    required DateTime startedAt,

    /// Tur başladığında muayene edilebilen kovanlar, numara sırasıyla.
    required List<String> hiveIds,

    /// Turda muayene edilen kovan → muayenenin kimliği.
    @Default({}) Map<String, String> inspections,

    /// Atlanan kovanlar, atlanma sırasıyla; muayene edilince düşer.
    @Default([]) List<String> skipped,

    /// "Turu bitir" anı; özet ekranı açıkken dolu.
    DateTime? finishedAt,
  }) = _ApiaryTour;

  factory fromJson(Map<String, Object?> json) => _$ApiaryTourFromJson(json);
}

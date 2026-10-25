import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';

part 'treatment.freezed.dart';
part 'treatment.g.dart';

/// Kovana ilaç uygulaması (`treatments`). Olay kaydı: yalnız eklenir,
/// yanlış kayıt silinir. İlaç ya referans listeden (`refDrugId`) ya da
/// işletmenin listesinden (`drugId`); ad ve etken madde uygulama anındaki
/// hâliyle kopyalanır.
@freezed
abstract class Treatment with _$Treatment implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,

    /// Uygulamanın yapıldığı arılık; kovan sonra taşınsa da değişmez.
    required String apiaryId,
    required String productName,
    required DrugActiveIngredient activeIngredient,

    /// Kovan başına doz.
    required double dose,
    required DrugDoseUnit doseUnit,
    required DateTime startedAt,

    /// Çıkarmadan (yoksa başlangıçtan) sonra bal katı ve hasat için gün.
    required int withdrawalDays,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? refDrugId,
    String? drugId,
    String? batchNo,

    /// Şeridin çıkarılacağı gün; tek seferlik uygulamada boş.
    DateTime? plannedRemovalAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Treatment;

  factory fromJson(Map<String, Object?> json) => _$TreatmentFromJson(json);
}

/// Bir ya da birçok kovana aynı anda yazılan uygulamanın değerleri.
@freezed
abstract class TreatmentPlan with _$TreatmentPlan {
  const factory({
    required DrugChoice drug,

    /// Kovan başına doz; birimi ilacın.
    required double dose,
    required DateTime startedAt,
    required int withdrawalDays,
    String? batchNo,
    DateTime? plannedRemovalAt,
  }) = _TreatmentPlan;
}

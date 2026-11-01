import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';

part 'lot.freezed.dart';
part 'lot.g.dart';

/// Lotun durumu (`public.lot_status`).
@JsonEnum(valueField: 'value')
enum LotStatus implements ServerEnum {
  /// Açık: hasat eklenebilir.
  open('open'),

  /// Kapalı: yeni hasat eklenmez.
  closed('closed');

  new(this.value);

  @override
  final String value;
}

/// Analizdeki kalıntı sonucu (`public.residue_result`).
@JsonEnum(valueField: 'value')
enum ResidueResult implements ServerEnum {
  /// Kalıntı bulunmadı.
  none('none'),

  /// Kalıntı bulundu.
  detected('detected');

  new(this.value);

  @override
  final String value;
}

/// Bir bal partisi (`lots`). Durum kaydı: son yazan kazanır. Numarası
/// yıl ve yıl içindeki sıra ("2026-07"). Kilogram ve stok saklanmaz:
/// bağlı hasatların toplamı ve satışlar düşülmüş hâli ([LotSummary]).
@freezed
abstract class Lot with _$Lot implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required int year,

    /// Yıl içindeki sıra; tekil değil (offline iki telefon aynısını
    /// verebilir).
    required int seq,
    required HoneyKind honeyKind,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(LotStatus.open) LotStatus status,

    /// Yöre (ör. arılığın adı); serbest metin.
    String? origin,

    /// Refraktömetre nemi, %.
    double? moisture,

    /// Herkese açık sayfası (`lot-page`) var mı. Yalnız owner değiştirir;
    /// başkasının yazmasını sunucu yok sayar.
    @Default(false) bool published,

    /// Sayfada işletme adı ve aktif kovan sayısı görünür.
    @Default(true) bool publicProducer,

    /// Sayfada yöre ve hasat ayı görünür.
    @Default(true) bool publicOrigin,

    /// Sayfada son analizin değerleri görünür.
    @Default(true) bool publicLab,

    /// Sayfada son analizin raporu açılır.
    @Default(true) bool publicReport,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _Lot;

  factory fromJson(Map<String, Object?> json) => _$LotFromJson(json);
}

/// Lota eklenen hasat (`lot_harvests`); olay kaydı. Bir hasat en çok bir
/// lotta.
@freezed
abstract class LotHarvest with _$LotHarvest implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String lotId,
    required String harvestId,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _LotHarvest;

  factory fromJson(Map<String, Object?> json) => _$LotHarvestFromJson(json);
}

/// Hasat lota eklenirken kovanın son ilaçlamasının kopyası
/// (`lot_treatments`); olay kaydı, sonradan değişmez.
@freezed
abstract class LotTreatment with _$LotTreatment implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String lotId,
    required String harvestId,
    required String hiveId,

    /// Kovanın hasat gününe kadarki son uygulaması.
    required String treatmentId,

    /// Son uygulamanın başlangıcı.
    required DateTime treatedAt,

    /// Hasat gününe kadar başlamış uygulamaların bekleme süresinin en geç
    /// bittiği gün (o gün serbest).
    @DateOnlyJsonConverter() required DateTime withdrawalEndsOn,

    /// Hasat günü bekleme süresindeydi.
    required bool withdrawalViolation,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _LotTreatment;

  factory fromJson(Map<String, Object?> json) => _$LotTreatmentFromJson(json);
}

/// Lotun laboratuvar analizi (`lab_results`); olay kaydı. Sonuçlardan en
/// az biri dolu. Rapor dosyası belge kasasında (`documentId`).
@freezed
abstract class LabResult with _$LabResult implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String lotId,
    @DateOnlyJsonConverter() required DateTime testedOn,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// HMF, mg/kg.
    double? hmf,

    /// Diastaz sayısı (Schade).
    double? diastase,

    /// Prolin, mg/kg.
    double? proline,

    /// Nem, %.
    double? moisture,
    ResidueResult? residue,
    String? documentId,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _LabResult;

  factory fromJson(Map<String, Object?> json) => _$LabResultFromJson(json);
}

/// Lottan satılan bal (`lot_sales`); olay kaydı. Finans modülü gelene kadar
/// elle düşülür.
@freezed
abstract class LotSale with _$LotSale implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String lotId,
    @DateOnlyJsonConverter() required DateTime soldOn,

    /// Satılan bal, kilogram.
    required double kg,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _LotSale;

  factory fromJson(Map<String, Object?> json) => _$LotSaleFromJson(json);
}

/// Lot ve hesaplanan değerleri: `kg` bağlı hasatların toplamı, `soldKg`
/// satışların toplamı, `hiveCount` hasatlara alınan farklı kovan sayısı,
/// `analyzed` en az bir analizi var, `violation` bekleme süresi ihlali var.
typedef LotSummary = ({
  Lot lot,
  double kg,
  double soldKg,
  int hiveCount,
  bool analyzed,
  bool violation,
});

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

part 'queen_rearing.freezed.dart';
part 'queen_rearing.g.dart';

/// Çiftleşme kutusunun içi (`public.mating_nuc_status`).
@JsonEnum(valueField: 'value')
enum MatingNucStatus implements ServerEnum {
  /// Boş; yeni seride kullanılabilir.
  empty('empty'),

  /// Kapalı meme verildi.
  cell('cell'),

  /// Ana çıktı, henüz çiftleşmedi (bakire).
  virgin('virgin'),

  /// Ana yumurtluyor: çiftleşme başarılı, kovana verilebilir.
  laying('laying'),

  /// Meme çıkmadı ya da ana kayboldu.
  failed('failed'),

  /// Ana kovana verildi; kaydı `queenId`.
  given('given');

  new(this.value);

  @override
  final String value;
}

/// Seri numarası ve aktarılan larva bu aralıkta (sunucudaki CHECK).
const maxRearingBatchNumber = 10000;
const maxGraftedCount = 1000;

/// Kutu numarası en çok bu kadar karakter.
const maxMatingNucNumberLength = 20;

/// Bir larva aktarma serisi (`queen_rearing_batches`). Durum kaydı: son
/// yazan kazanır. Takvim aktarma gününden hesaplanır
/// (`queen_rearing_rules.dart`).
@freezed
abstract class QueenRearingBatch
    with _$QueenRearingBatch
    implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,

    /// İşletmenin verdiği seri numarası ("Seri 3"); tekil değil.
    required int number,

    /// Larva aktarma günü.
    @DateOnlyJsonConverter() required DateTime graftedOn,

    /// Aktarılan larva sayısı.
    required int graftedCount,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Larvaların alındığı anne ana; bilinmiyorsa boş.
    String? motherQueenId,

    /// G1'de kabul edilen meme; sayılmadıysa boş. Aktarılandan fazla
    /// olamaz.
    int? acceptedCount,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _QueenRearingBatch;

  factory fromJson(Map<String, Object?> json) =>
      _$QueenRearingBatchFromJson(json);
}

/// Bir arılıktaki çiftleşme kutusu (`mating_nucs`). Durum kaydı: son yazan
/// kazanır. Boş olmayan kutu bir serinin memesini taşır; kutu yeni seride
/// yeniden kullanılınca seri değişir.
@freezed
abstract class MatingNuc with _$MatingNuc implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,

    /// Kutunun numarası ("1", "K-12").
    required String number,
    required String apiaryId,
    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(MatingNucStatus.empty) MatingNucStatus status,

    /// Kutudaki memenin serisi; boş kutuda boş olabilir.
    String? rearingBatchId,

    /// Kutudan kovana verilen ananın kaydı; yalnız [MatingNucStatus.given]
    /// durumunda dolu.
    String? queenId,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _MatingNuc;

  factory fromJson(Map<String, Object?> json) => _$MatingNucFromJson(json);
}

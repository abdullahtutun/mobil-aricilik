import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';

part 'media_item.freezed.dart';
part 'media_item.g.dart';

/// Medya türü (`public.media_kind`).
@JsonEnum(valueField: 'value')
enum MediaKind implements ServerEnum {
  /// JPEG, uzun kenarı en çok [maxPhotoEdge] px.
  photo('photo'),

  /// AAC sesli not (`.m4a`).
  audio('audio');

  new(this.value);

  @override
  final String value;

  /// Dosya uzantısı; sunucudaki yol kuralıyla aynı.
  String get extension => switch (this) {
    photo => 'jpg',
    audio => 'm4a',
  };

  /// Yüklenirken gönderilen tür; bucket yalnız bunları kabul eder.
  String get contentType => switch (this) {
    photo => 'image/jpeg',
    audio => 'audio/mp4',
  };
}

/// Fotoğrafın uzun kenarı sıkıştırmadan sonra en çok bu kadar piksel.
const maxPhotoEdge = 1600;

/// Bu telefonda çekilmiş, henüz bir kayda bağlanmamış dosya. Muayene
/// sırasında çekilenler taslakta bekler, muayene kaydedilince medya
/// kaydına dönüşür.
@freezed
abstract class MediaCapture with _$MediaCapture {
  const factory({
    /// Uygulamanın medya klasöründeki dosya adı.
    required String fileName,
    required MediaKind kind,
    required DateTime capturedAt,
    required int byteSize,

    /// Sesli notun süresi.
    int? durationMs,
  }) = _MediaCapture;

  factory fromJson(Map<String, Object?> json) => _$MediaCaptureFromJson(json);
}

/// Foto ya da sesli not (`media`); kovana, muayene sırasında çekildiyse o
/// muayeneye, reçete fotoğrafıysa ilaç uygulamasına da bağlı. Olay kaydı:
/// yalnız eklenir, yanlış kayıt silinir.
/// Satır yalnız meta veri; dosya Storage'da `storage_path`'te.
@freezed
abstract class MediaItem with _$MediaItem implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required String hiveId,
    required MediaKind kind,

    /// `media` bucket'ındaki yol (`mediaStoragePath`).
    required String storagePath,
    required DateTime capturedAt,
    required int byteSize,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? inspectionId,

    /// Reçete / fatura fotoğrafıysa bağlı olduğu ilaç uygulaması.
    String? treatmentId,
    int? durationMs,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _MediaItem;

  factory fromJson(Map<String, Object?> json) => _$MediaItemFromJson(json);
}

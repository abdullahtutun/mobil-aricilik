import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/db/server_enum.dart';
import 'package:mobil_arici/core/db/synced_record.dart';
import 'package:mobil_arici/core/utils/date_only.dart';

part 'document.freezed.dart';
part 'document.g.dart';

/// Belge türü (`public.document_type`). TR profilinde hazır türler
/// ([trDocumentTypes]) seçilir; diğer bölgelerde kullanıcı kendi türünü
/// yazar ([custom]). Hazır türün adı ekranda kullanıcının dilinde üretilir.
@JsonEnum(valueField: 'value')
enum DocumentType implements ServerEnum {
  healthReport('health_report'),
  transportPermit('transport_permit'),

  /// Gezginci arıcı belgesi.
  migratoryCertificate('migratory_certificate'),
  businessRegistration('business_registration'),
  landPermit('land_permit'),

  /// Bal analiz raporu.
  analysisReport('analysis_report'),

  /// Kullanıcı tanımlı; adı `custom_type`'ta.
  custom('custom');

  new(this.value);

  @override
  final String value;
}

/// TR profilinde seçilebilen hazır türler, formdaki sırasıyla.
const List<DocumentType> trDocumentTypes = [
  DocumentType.healthReport,
  DocumentType.transportPermit,
  DocumentType.migratoryCertificate,
  DocumentType.businessRegistration,
  DocumentType.landPermit,
  DocumentType.analysisReport,
];

/// Belge dosyasının türü (`public.document_file_kind`).
@JsonEnum(valueField: 'value')
enum DocumentFileKind implements ServerEnum {
  /// JPEG, uzun kenarı en çok ~1600 px.
  photo('photo'),
  pdf('pdf');

  new(this.value);

  @override
  final String value;

  /// Dosya uzantısı; sunucudaki yol kuralıyla aynı.
  String get extension => switch (this) {
    photo => 'jpg',
    pdf => 'pdf',
  };

  /// Yüklenirken gönderilen tür; bucket yalnız bunları kabul eder.
  String get contentType => switch (this) {
    photo => 'image/jpeg',
    pdf => 'application/pdf',
  };
}

/// Belge dosyasının bucket sınırı (20 MB).
const int maxDocumentFileBytes = 20 * 1024 * 1024;

/// Belgenin adı ve kullanıcı tanımlı türün adı en çok bu kadar karakter.
const maxDocumentNameLength = 120;
const maxDocumentTypeLength = 60;
const maxDocumentDescriptionLength = 500;

/// Kasadaki belge (`documents`): türü, adı, açıklaması, son geçerlilik
/// günü ve tek dosyası (foto ya da PDF). Durum kaydı: son yazan kazanır.
/// Satır yalnız meta veri; dosya Storage'da `storage_path`'te ve bu
/// telefonda aynı adla (`documentFileName`) saklanır.
@freezed
abstract class VaultDocument with _$VaultDocument implements SyncedRecord {
  const factory({
    required String id,
    required String orgId,
    required DocumentType type,
    required String name,
    required DocumentFileKind fileKind,

    /// `documents` bucket'ındaki yol (`documentStoragePath`).
    required String storagePath,
    required int byteSize,
    required DateTime createdAt,
    required DateTime updatedAt,

    /// Kullanıcı tanımlı türün adı; hazır türde boş.
    String? customTypeName,
    String? description,

    /// Son geçerlilik günü (o gün dahil); boşsa süresiz.
    @DateOnlyJsonConverter() DateTime? expiresOn,
    String? createdBy,
    DateTime? deletedAt,
    @JsonKey(includeToJson: false) int? serverSeq,
  }) = _VaultDocument;

  factory fromJson(Map<String, Object?> json) => _$VaultDocumentFromJson(json);
}

/// Bu telefonda seçilmiş, henüz belgeye bağlanmamış dosya; belge
/// kaydedilince belgenin dosyası olur. Belge klasöründeki adı
/// `fileId.uzantı`; Storage yolunun son parçasıyla aynı.
typedef DocumentFileCapture = ({
  String fileId,
  DocumentFileKind kind,
  int byteSize,
});

extension DocumentFileCaptureName on DocumentFileCapture {
  String get fileName => '$fileId.${kind.extension}';
}

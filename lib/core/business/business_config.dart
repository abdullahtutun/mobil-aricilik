import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/region/region_config.dart' show RegionConfig;
import 'package:mobil_arici/features/organization/domain/organization.dart';

part 'business_config.freezed.dart';

/// İşletme türüne bağlı modül bayrakları. Bölgeden ([RegionConfig]) ayrı:
/// bölge ülkeden, bunlar işletme türünden çıkar. Kapalı modülün verisi
/// silinmez; tür geri değişince kayıtlar yeniden görünür.
@freezed
abstract class BusinessFeatures with _$BusinessFeatures {
  const factory({
    /// Gezginci modülleri: göç planı, duraklar, taşıma (yükleme/indirme),
    /// gidere taşıma bağlama ve offline haritadaki göç durakları.
    @Default(true) bool migratory,
  }) = _BusinessFeatures;
}

/// Ekranların işletme türü kararlarını verdiği tek yapılandırma.
@freezed
abstract class BusinessConfig with _$BusinessConfig {
  const factory({
    required OperationType operationType,
    required BusinessFeatures features,
  }) = _BusinessConfig;
}

/// İşletme türünden yapılandırma; saf fonksiyon.
BusinessConfig resolveBusinessConfig(OperationType operationType) =>
    BusinessConfig(
      operationType: operationType,
      features: BusinessFeatures(
        migratory: operationType == OperationType.migratory,
      ),
    );

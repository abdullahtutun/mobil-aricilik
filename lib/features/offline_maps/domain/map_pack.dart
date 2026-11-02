import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_pack.freezed.dart';

/// Coğrafi kutu, WGS84 derece. Tarih çizgisini aşan kutu yok (kesme betiği
/// de desteklemiyor).
@freezed
abstract class MapBounds with _$MapBounds {
  const factory({
    required double west,
    required double south,
    required double east,
    required double north,
  }) = _MapBounds;
}

/// Katalogdaki bir bölge paketi (`map-packs` bucket'ındaki MBTiles).
@freezed
abstract class MapPack with _$MapPack {
  const factory({
    /// `tr-48`; dosya adı olur.
    required String id,

    /// Dil kodundan ada (`{"tr": "Muğla", "en": "Mugla"}`).
    required Map<String, String> names,
    required MapBounds bounds,
    required int minZoom,
    required int maxZoom,

    /// İndirme adresi (public bucket).
    required String url,

    /// İndirilecek dosyanın tam boyutu.
    required int bytes,

    /// Küçük harf hex SHA-256; indirmeden sonra doğrulanır.
    required String sha256,
  }) = _MapPack;
}

/// Storage'daki `catalog.json`: paketlerin sürümü ve listesi.
@freezed
abstract class MapPackCatalog with _$MapPackCatalog {
  const factory({
    required String version,

    /// Paketlerin kesildiği gün; "güncelleme: Eyl 2026".
    required DateTime generatedAt,
    required List<MapPack> packs,
  }) = _MapPackCatalog;
}

/// Bu telefona indirilmiş paket. Dosyası `<id>.mbtiles`.
@freezed
abstract class InstalledMapPack with _$InstalledMapPack {
  const factory({
    required MapPack pack,

    /// Katalogun sürümü ve kesildiği gün.
    required String version,
    required DateTime generatedAt,
    required DateTime downloadedAt,
  }) = _InstalledMapPack;
}

/// İndirilmemiş ama arılıkların ya da göç duraklarının içinde kaldığı
/// paket.
@freezed
abstract class MapPackSuggestion with _$MapPackSuggestion {
  const factory({
    required MapPack pack,

    /// Paketin içindeki konumlu arılık sayısı.
    required int apiaryCount,

    /// Paketin içindeki, geçmişte kalmamış göç duraklarının adları.
    required List<String> stopNames,
  }) = _MapPackSuggestion;
}

/// Öneri için bir göç durağı: bağlı arılığın konumu ya da "yer" metni.
typedef MapStopPlace = ({
  String name,
  String? place,
  double? latitude,
  double? longitude,
});

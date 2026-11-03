import 'package:freezed_annotation/freezed_annotation.dart';

part 'map_area.freezed.dart';

/// Coğrafi kutu, WGS84 derece. Tarih çizgisini aşan kutu yok.
@freezed
abstract class MapBounds with _$MapBounds {
  const factory({
    required double west,
    required double south,
    required double east,
    required double north,
  }) = _MapBounds;
}

/// İnternetsiz açılması için indirilecek alan: bir arılığın çevresi.
@freezed
abstract class MapArea with _$MapArea {
  const factory({
    /// Arılığın kimliği; dosya adı olur.
    required String id,

    /// Arılığın adı (indirildiği andaki).
    required String name,
    required double latitude,
    required double longitude,
  }) = _MapArea;
}

/// Bu telefona indirilmiş alan. Dosyası `<id>.mbtiles`.
@freezed
abstract class InstalledMapArea with _$InstalledMapArea {
  const factory({
    required MapArea area,

    /// Paketteki karolar ve dosyanın boyutu.
    required int tileCount,
    required int bytes,
    required DateTime downloadedAt,
  }) = _InstalledMapArea;
}

/// Ekranda indirilmeye aday arılık.
@freezed
abstract class MapAreaCandidate with _$MapAreaCandidate {
  const factory({
    required MapArea area,

    /// Arılığa bağlı, geçmişte kalmamış göç duraklarının adları.
    required List<String> stopNames,

    /// İndirilmiş ama arılık o zamandan beri taşınmış; yeniden indirilmeli.
    @Default(false) bool moved,
  }) = _MapAreaCandidate;
}

/// Slippy map karosu (XYZ).
typedef TileId = ({int z, int x, int y});

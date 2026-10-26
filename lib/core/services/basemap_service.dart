import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:vector_map_tiles/vector_map_tiles.dart';

/// Harita altlığı yüklenemedi: internet yok, sunucuya ulaşılamadı ya da
/// stil okunamadı. Ekran haritanın yerine liste gösterir.
class BasemapUnavailable implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'BasemapUnavailable($cause)';
}

/// Yüklenmiş harita altlığı: `FlutterMap`'in en alttaki karo katmanı.
abstract interface class Basemap {
  Widget tileLayer();
}

/// Altlığı ağdan okur. Ağa giden çağrı; ekranlar buna provider üzerinden
/// ulaşır. Çevrimdışı paketler Faz E'de gelecek.
abstract interface class BasemapService {
  /// Hata [BasemapUnavailable] olarak gelir.
  Future<Basemap> load();
}

/// OpenFreeMap "Liberty" stili; OpenMapTiles şemasında vektör karolar.
/// Hesap ve anahtar istemez. Karolar telefonda önbelleklenir.
class OpenFreeMapService implements BasemapService {
  const new();

  static const styleUri = 'https://tiles.openfreemap.org/styles/liberty';

  /// Sahada zayıf çekimde stil bundan uzun sürerse harita yok sayılır.
  static const timeout = Duration(seconds: 15);

  @override
  Future<Basemap> load() async {
    try {
      final style = await StyleReader(uri: styleUri).read().timeout(timeout);
      return _VectorBasemap(style);
    } on Object catch (error) {
      // Bağlantı hatası, zaman aşımı, HTTP hatası ya da beklenmeyen stil.
      throw BasemapUnavailable(error);
    }
  }
}

class _VectorBasemap implements Basemap {
  const new(this._style);

  final Style _style;

  @override
  Widget tileLayer() => VectorTileLayer(
    theme: _style.theme,
    sprites: _style.sprites,
    tileProviders: _style.providers,
  );
}

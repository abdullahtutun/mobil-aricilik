import 'package:flutter/widgets.dart';
import 'package:mobil_arici/core/services/basemap_service.dart';

/// Ağsız harita altlığı: [fail] doğruysa internet yokmuş gibi hata atar,
/// değilse karo katmanı boş bir kutudur. Çağrıları sayar. Varsayılan
/// çevrimdışı; testler ağa çıkmaz.
class FakeBasemapService implements BasemapService {
  new({this.fail = true});

  bool fail;
  int loadCount = 0;

  @override
  Future<Basemap> load() async {
    loadCount++;
    if (fail) throw const BasemapUnavailable('çevrimdışı');
    return const _BlankBasemap();
  }
}

class _BlankBasemap implements Basemap {
  const new();

  @override
  Widget tileLayer() => const SizedBox.expand();

  @override
  bool get offline => false;

  @override
  void dispose() {}
}

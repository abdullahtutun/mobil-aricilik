import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobil_arici/features/health/domain/drug_info.dart';

/// Referans ilaçların Bakanlık onaylı ürün bilgileri; uygulamayla gelir,
/// internet istemez. Liste `ref_drugs` migration'ıyla birlikte güncellenir.
class DrugInfoRepository {
  new(this.bundle);

  static const assetPath = 'assets/drugs/ilaclar.json';

  final AssetBundle bundle;

  /// Ürün bilgileri, referans ilaç kimliğine göre.
  Future<Map<String, DrugInfo>> loadAll() async => parseDrugInfos(
    jsonDecode(await bundle.loadString(assetPath)) as List<Object?>,
  );
}

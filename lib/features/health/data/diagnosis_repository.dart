import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:mobil_arici/features/health/domain/diagnosis.dart';
import 'package:mobil_arici/features/health/domain/diagnosis_rules.dart';

/// Teşhis yardımcısının kural tablosu; uygulamayla gelir, internet
/// istemez.
class DiagnosisRepository {
  new(this.bundle);

  static const assetPath = 'assets/diagnosis/rules.json';

  final AssetBundle bundle;

  /// Tablo bozuksa [FormatException] atar.
  Future<DiagnosisTable> load() async =>
      parseDiagnosisTable(jsonDecode(await bundle.loadString(assetPath)));
}

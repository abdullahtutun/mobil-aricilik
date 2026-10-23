import 'package:flutter/services.dart';

/// Saha titreşimleri (teknik.md §10): eldivenle, ekrana bakmadan anlaşılan
/// geri bildirim. Kaydet ve uyarı titreşimleri kendi adımlarında gelecek.
/// Cihazın dokunma titreşimi ayarı kapalıysa titreşmez.
abstract final class AppHaptics {
  /// Okutma başarılı: kod bir kovanı açtı.
  static Future<void> scanSuccess() => HapticFeedback.heavyImpact();
}

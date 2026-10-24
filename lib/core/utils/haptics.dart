import 'package:flutter/services.dart';

/// Saha titreşimleri (teknik.md §10): eldivenle, ekrana bakmadan anlaşılan
/// geri bildirim. Her olayın titreşimi ayrı. Uyarı titreşimi kendi adımında
/// gelecek. Cihazın dokunma titreşimi ayarı kapalıysa titreşmez.
abstract final class AppHaptics {
  /// Okutma başarılı: kod bir kovanı açtı.
  static Future<void> scanSuccess() => HapticFeedback.heavyImpact();

  /// Kayıt yerel DB'ye yazıldı.
  static Future<void> saved() => HapticFeedback.mediumImpact();
}

import 'package:flutter/widgets.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Bütün sayfaları telefonun alt sistem çubuğunun (Android'de geri / ana
/// ekran tuşları ya da hareket çizgisi) üstünde bitirir. Android 15 ve
/// sonrası uygulamayı kenardan kenara çizer; alt boşluğu her ekranın ayrı
/// ayrı bırakması gerekmesin diye uygulamanın kökünde bir kez uygulanır.
///
/// Üst kenar ekranlara kalır: AppBar durum çubuğunun altını zaten boşaltır,
/// tam ekran sayfalar (okut, harita) oraya kadar çizilebilir. Alttaki şerit
/// sayfa zemini renginde boyanır; alt gezinme çubuğu da aynı renkte olduğu
/// için tek parça görünür. Bu alan tüketildiği için içerideki `SafeArea`'lar
/// alta ikinci kez boşluk koymaz. Klavye açıkken alt boşluk sıfırlanır,
/// klavye payını yine `Scaffold` bırakır.
class SystemBarsSafeArea extends StatelessWidget {
  const new({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => ColoredBox(
    color: context.colors.surface,
    child: SafeArea(top: false, child: child),
  );
}

import 'dart:ui' show lerpDouble;

import 'package:flutter/material.dart';

/// Bileşen içi ölçüler (dp): ikon, gösterge noktası, illüstrasyon.
class AppSizes extends ThemeExtension<AppSizes> {
  const new({
    required this.iconSmall,
    required this.icon,
    required this.strengthDot,
    required this.queenDot,
    required this.illustration,
    required this.illustrationIcon,
    required this.hiveTile,
    required this.scanWindow,
    required this.honeycomb,
    required this.mediaThumbnail,
    required this.chart,
    required this.avatar,
    required this.dayDot,
    required this.mapPin,
    required this.stopDot,
    required this.weatherTable,
  });

  static const standard = AppSizes(
    iconSmall: 20,
    icon: 24,
    strengthDot: 12,
    queenDot: 20,
    illustration: 64,
    illustrationIcon: 48,
    hiveTile: 104,
    scanWindow: 240,
    honeycomb: 240,
    mediaThumbnail: 72,
    chart: 160,
    avatar: 40,
    dayDot: 6,
    mapPin: 120,
    stopDot: 20,
    weatherTable: 340,
  );

  /// Rozet ve chip içindeki ikonlar.
  final double iconSmall;

  /// Buton ve uyarı ikonları.
  final double icon;

  /// Güç puanı noktası (1–5).
  final double strengthDot;

  /// Ana arı renk noktası.
  final double queenDot;

  /// Boş durum altıgeni; ikonu [icon] boyunda.
  final double illustration;

  /// Tek başına duran büyük durum ikonu (okutma, ilk eşitleme).
  final double illustrationIcon;

  /// Izgaradaki kovan karosunun asgari eni; 360dp ekranda üç sütun
  /// (eldiven modunda boşluklar büyüdüğü için iki).
  final double hiveTile;

  /// Okut ekranında kodun getirileceği kare çerçeve; 360dp ekranda iki
  /// yanda başparmak payı kalır.
  final double scanWindow;

  /// Giriş ekranlarının köşesindeki petek deseni.
  final double honeycomb;

  /// Zaman tünelindeki foto küçük resmi (kare); dokunma hedefinden büyük.
  final double mediaThumbnail;

  /// Çubuk grafiğin çizim alanının yüksekliği (varroa ölçümleri); eksen
  /// yazıları hariç.
  final double chart;

  /// Kişi rozeti (görevin atandığı üyenin baş harfi); daire.
  final double avatar;

  /// Gün şeridinde o gün görev olduğunu gösteren nokta.
  final double dayDot;

  /// Haritadaki arılık pininin kutusu (kare); pin bunun içinde alta
  /// yaslanır, 1.5x yazıda da sığar. Kutunun boş kısmı haritaya geçer.
  final double mapPin;

  /// Göç planı zaman çizelgesinde durağın noktası (daire).
  final double stopDot;

  /// Hava ekranındaki günlük listenin tablo olarak (tek satırda gün, simge,
  /// sıcaklık, yağış, rüzgar, kovan) sığdığı en dar en, 1x yazıda; daha
  /// dar ya da büyük yazıda her gün iki satır.
  final double weatherTable;

  @override
  AppSizes copyWith({
    double? iconSmall,
    double? icon,
    double? strengthDot,
    double? queenDot,
    double? illustration,
    double? illustrationIcon,
    double? hiveTile,
    double? scanWindow,
    double? honeycomb,
    double? mediaThumbnail,
    double? chart,
    double? avatar,
    double? dayDot,
    double? mapPin,
    double? stopDot,
    double? weatherTable,
  }) {
    return AppSizes(
      iconSmall: iconSmall ?? this.iconSmall,
      icon: icon ?? this.icon,
      strengthDot: strengthDot ?? this.strengthDot,
      queenDot: queenDot ?? this.queenDot,
      illustration: illustration ?? this.illustration,
      illustrationIcon: illustrationIcon ?? this.illustrationIcon,
      hiveTile: hiveTile ?? this.hiveTile,
      scanWindow: scanWindow ?? this.scanWindow,
      honeycomb: honeycomb ?? this.honeycomb,
      mediaThumbnail: mediaThumbnail ?? this.mediaThumbnail,
      chart: chart ?? this.chart,
      avatar: avatar ?? this.avatar,
      dayDot: dayDot ?? this.dayDot,
      mapPin: mapPin ?? this.mapPin,
      stopDot: stopDot ?? this.stopDot,
      weatherTable: weatherTable ?? this.weatherTable,
    );
  }

  @override
  AppSizes lerp(AppSizes? other, double t) {
    if (other == null) return this;
    return AppSizes(
      iconSmall: lerpDouble(iconSmall, other.iconSmall, t)!,
      icon: lerpDouble(icon, other.icon, t)!,
      strengthDot: lerpDouble(strengthDot, other.strengthDot, t)!,
      queenDot: lerpDouble(queenDot, other.queenDot, t)!,
      illustration: lerpDouble(illustration, other.illustration, t)!,
      illustrationIcon: lerpDouble(
        illustrationIcon,
        other.illustrationIcon,
        t,
      )!,
      hiveTile: lerpDouble(hiveTile, other.hiveTile, t)!,
      scanWindow: lerpDouble(scanWindow, other.scanWindow, t)!,
      honeycomb: lerpDouble(honeycomb, other.honeycomb, t)!,
      mediaThumbnail: lerpDouble(mediaThumbnail, other.mediaThumbnail, t)!,
      chart: lerpDouble(chart, other.chart, t)!,
      avatar: lerpDouble(avatar, other.avatar, t)!,
      dayDot: lerpDouble(dayDot, other.dayDot, t)!,
      mapPin: lerpDouble(mapPin, other.mapPin, t)!,
      stopDot: lerpDouble(stopDot, other.stopDot, t)!,
      weatherTable: lerpDouble(weatherTable, other.weatherTable, t)!,
    );
  }
}

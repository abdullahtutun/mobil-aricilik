import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:map_launcher/map_launcher.dart';

part 'directions_service.freezed.dart';

/// Yol tarifi verebilen, cihazda kurulu bir harita uygulaması.
@freezed
abstract class DirectionsApp with _$DirectionsApp {
  const factory({
    /// Kalıcı kimlik (ör. `google`, `waze`).
    required String id,

    /// Uygulamanın kendi adı (ör. "Apple Maps"); çevrilmez.
    required String name,
  }) = _DirectionsApp;
}

/// Uygulama açılamadı (kaldırılmış, bağlantıyı reddetti).
class DirectionsUnavailable implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'DirectionsUnavailable($cause)';
}

/// Telefondaki harita uygulamalarında bir noktaya yol tarifi. Ekranlar buna
/// provider üzerinden ulaşır.
abstract interface class DirectionsService {
  /// Cihazda kurulu, bu noktaya yol tarifi verebilen uygulamalar. Bulunamazsa
  /// (ör. platform desteklemiyor) boş liste.
  Future<List<DirectionsApp>> installedApps(double latitude, double longitude);

  /// [app]'te yol tarifini açar; hedefin adı [title]. Hata
  /// [DirectionsUnavailable] olarak gelir.
  Future<void> open(
    DirectionsApp app,
    double latitude,
    double longitude, {
    String? title,
  });
}

/// `map_launcher` ile. Sorgulanan uygulamalar iOS'ta
/// `LSApplicationQueriesSchemes`, Android'de `<queries>` içinde tanımlı
/// olmalı; tanımsız uygulama kurulu olsa da bulunmaz.
class MapLauncherDirectionsService implements DirectionsService {
  const new();

  /// Önerilen uygulamalar, sayfada bu sırayla.
  static const apps = <MapApp>[
    MapApp.apple,
    MapApp.google,
    MapApp.googleGo,
    MapApp.yandexNavi,
    MapApp.yandexMaps,
    MapApp.waze,
    MapApp.petal,
    MapApp.here,
    MapApp.osmand,
    MapApp.osmandplus,
    MapApp.mapswithme,
    MapApp.magicEarth,
    MapApp.tomtomgo,
    MapApp.sygicTruck,
  ];

  @override
  Future<List<DirectionsApp>> installedApps(
    double latitude,
    double longitude,
  ) async {
    try {
      final maps = await MapLauncher.directions(.coords(latitude, longitude))
          .getSupportedMaps(apps);
      return [
        for (final map in maps)
          if (map.isInstalled) DirectionsApp(id: map.map.id, name: map.name),
      ];
    } on Object {
      return const [];
    }
  }

  @override
  Future<void> open(
    DirectionsApp app,
    double latitude,
    double longitude, {
    String? title,
  }) async {
    final map = apps.where((map) => map.id == app.id).firstOrNull;
    if (map == null) throw DirectionsUnavailable('bilinmeyen: ${app.id}');
    try {
      await MapLauncher.directions(.coords(latitude, longitude, title: title))
          .show(map: map);
    } on Object catch (error) {
      throw DirectionsUnavailable(error);
    }
  }
}

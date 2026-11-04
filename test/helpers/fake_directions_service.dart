import 'package:mobil_arici/core/services/directions_service.dart';

/// Cihazsız yol tarifi: kurulu uygulamalar [apps]; açılanları kaydeder.
/// [fail] doğruysa açma hata atar. Varsayılan hiç uygulama yok.
class FakeDirectionsService implements DirectionsService {
  new({this.apps = const [], this.fail = false});

  List<DirectionsApp> apps;
  bool fail;
  final opened =
      <
        ({DirectionsApp app, double latitude, double longitude, String? title})
      >[];

  @override
  Future<List<DirectionsApp>> installedApps(
    double latitude,
    double longitude,
  ) async => apps;

  @override
  Future<void> open(
    DirectionsApp app,
    double latitude,
    double longitude, {
    String? title,
  }) async {
    if (fail) throw const DirectionsUnavailable('açılamadı');
    opened.add((
      app: app,
      latitude: latitude,
      longitude: longitude,
      title: title,
    ));
  }
}

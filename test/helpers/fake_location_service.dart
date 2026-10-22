import 'dart:async';

import 'package:mobil_arici/core/services/location_service.dart';

const testFix = GpsFix(
  latitude: 40.123456,
  longitude: 29.654321,
  accuracyM: 8.4,
);

/// Cihazsız konum servisi: istenen konumu ya da hatayı verir, çağrıları
/// kaydeder.
class FakeLocationService implements LocationService {
  GpsFix fix = testFix;

  /// Sonraki isteğin atacağı hata; null ise [fix] döner.
  LocationFailure? failure;

  /// Doluysa konum bu tamamlanana kadar bekler (uydu aranıyor).
  Completer<void>? gate;

  int requestCount = 0;
  final openedSettings = <LocationFailure>[];

  @override
  Future<GpsFix> currentFix() async {
    requestCount++;
    await gate?.future;
    if (failure case final failure?) throw LocationServiceException(failure);
    return fix;
  }

  @override
  Future<void> openSettings(LocationFailure failure) async =>
      openedSettings.add(failure);
}

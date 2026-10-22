import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

part 'location_service.freezed.dart';

/// Cihazın GPS'ten aldığı tek bir konum (WGS 84).
@freezed
abstract class GpsFix with _$GpsFix {
  const factory({
    required double latitude,
    required double longitude,

    /// Yatay doğruluk yarıçapı, metre.
    required double accuracyM,
  }) = _GpsFix;
}

/// Konum alınamadığında nedeni.
enum LocationFailure {
  /// Cihazın konum servisi kapalı.
  serviceDisabled,

  /// Kullanıcı izni bu sefer vermedi; yeniden sorulabilir.
  permissionDenied,

  /// İzin kalıcı olarak reddedildi; yalnız uygulama ayarlarından açılır.
  permissionDeniedForever,

  /// Süre içinde uydu bulunamadı.
  timeout,

  unknown,
}

class LocationServiceException implements Exception {
  const new(this.failure);

  final LocationFailure failure;

  @override
  String toString() => 'LocationServiceException(${failure.name})';
}

/// Tek seferlik konum. Sürekli takip yok (pil); yalnız istendiğinde alınır.
/// GPS ağ gerektirmez.
abstract interface class LocationService {
  /// Şu anki konum. İzin henüz sorulmadıysa sorar. Hata
  /// [LocationServiceException] olarak gelir.
  Future<GpsFix> currentFix();

  /// [LocationFailure.serviceDisabled] için cihazın konum ayarlarını,
  /// [LocationFailure.permissionDeniedForever] için uygulama ayarlarını açar.
  Future<void> openSettings(LocationFailure failure);
}

class GeolocatorLocationService implements LocationService {
  const new();

  /// İnternetsiz (A-GPS'siz) ilk konum dakikalar sürebilir; kullanıcı
  /// beklemeyi ekrandan bırakabilir.
  static const timeLimit = Duration(minutes: 2);

  GeolocatorPlatform get _platform => GeolocatorPlatform.instance;

  @override
  Future<GpsFix> currentFix() async {
    if (!await _platform.isLocationServiceEnabled()) {
      throw const LocationServiceException(LocationFailure.serviceDisabled);
    }
    var permission = await _platform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _platform.requestPermission();
    }
    switch (permission) {
      case LocationPermission.whileInUse || LocationPermission.always:
        break;
      case LocationPermission.deniedForever:
        throw const LocationServiceException(
          LocationFailure.permissionDeniedForever,
        );
      case LocationPermission.denied || LocationPermission.unableToDetermine:
        throw const LocationServiceException(LocationFailure.permissionDenied);
    }

    try {
      final position = await _platform.getCurrentPosition(
        locationSettings: const LocationSettings(timeLimit: timeLimit),
      );
      return GpsFix(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracyM: position.accuracy,
      );
    } on TimeoutException {
      throw const LocationServiceException(LocationFailure.timeout);
    } on LocationServiceDisabledException {
      throw const LocationServiceException(LocationFailure.serviceDisabled);
    } on PermissionDeniedException {
      throw const LocationServiceException(LocationFailure.permissionDenied);
    } on Exception {
      throw const LocationServiceException(LocationFailure.unknown);
    }
  }

  @override
  Future<void> openSettings(LocationFailure failure) async {
    switch (failure) {
      case LocationFailure.serviceDisabled:
        await _platform.openLocationSettings();
      case LocationFailure.permissionDeniedForever:
        await _platform.openAppSettings();
      case LocationFailure.permissionDenied ||
          LocationFailure.timeout ||
          LocationFailure.unknown:
        break;
    }
  }
}

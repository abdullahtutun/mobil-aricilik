import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobil_arici/core/services/location_service.dart';

/// Cihazın konum katmanını taklit eder.
class _FakeGeolocator extends GeolocatorPlatform {
  bool serviceEnabled = true;
  LocationPermission permission = LocationPermission.whileInUse;

  /// İzin sorulunca kullanıcının cevabı.
  LocationPermission answer = LocationPermission.whileInUse;
  Exception? positionError;

  int permissionRequests = 0;
  LocationSettings? requestedSettings;
  final openedSettings = <String>[];

  @override
  Future<bool> isLocationServiceEnabled() async => serviceEnabled;

  @override
  Future<LocationPermission> checkPermission() async => permission;

  @override
  Future<LocationPermission> requestPermission() async {
    permissionRequests++;
    return permission = answer;
  }

  @override
  Future<Position> getCurrentPosition({
    LocationSettings? locationSettings,
  }) async {
    requestedSettings = locationSettings;
    if (positionError case final error?) throw error;
    return Position(
      latitude: 40.123456,
      longitude: 29.654321,
      accuracy: 6.5,
      timestamp: DateTime.utc(2026, 10, 22),
      altitude: 1250,
      altitudeAccuracy: 3,
      heading: 0,
      headingAccuracy: 0,
      speed: 0,
      speedAccuracy: 0,
    );
  }

  @override
  Future<bool> openAppSettings() async {
    openedSettings.add('app');
    return true;
  }

  @override
  Future<bool> openLocationSettings() async {
    openedSettings.add('location');
    return true;
  }
}

Matcher _failsWith(LocationFailure failure) => throwsA(
  isA<LocationServiceException>().having((e) => e.failure, 'failure', failure),
);

void main() {
  late _FakeGeolocator platform;
  const service = GeolocatorLocationService();

  setUp(() {
    final original = GeolocatorPlatform.instance;
    platform = _FakeGeolocator();
    GeolocatorPlatform.instance = platform;
    addTearDown(() => GeolocatorPlatform.instance = original);
  });

  group('GeolocatorLocationService.currentFix', () {
    test('konum ve doğruluk döner; süre sınırı verilir', () async {
      expect(
        await service.currentFix(),
        const GpsFix(latitude: 40.123456, longitude: 29.654321, accuracyM: 6.5),
      );
      expect(
        platform.requestedSettings?.timeLimit,
        GeolocatorLocationService.timeLimit,
      );
      expect(platform.permissionRequests, 0);
    });

    test('izin sorulmadıysa sorulur, verilince konum alınır', () async {
      platform.permission = LocationPermission.denied;

      expect(await service.currentFix(), isA<GpsFix>());
      expect(platform.permissionRequests, 1);
    });

    test('izin verilmezse permissionDenied', () async {
      platform
        ..permission = LocationPermission.denied
        ..answer = LocationPermission.denied;

      await expectLater(
        service.currentFix(),
        _failsWith(LocationFailure.permissionDenied),
      );
    });

    test('kalıcı ret varsa izin yeniden sorulmaz', () async {
      platform.permission = LocationPermission.deniedForever;

      await expectLater(
        service.currentFix(),
        _failsWith(LocationFailure.permissionDeniedForever),
      );
      expect(platform.permissionRequests, 0);
    });

    test('soru kalıcı retle sonuçlanırsa permissionDeniedForever', () async {
      platform
        ..permission = LocationPermission.denied
        ..answer = LocationPermission.deniedForever;

      await expectLater(
        service.currentFix(),
        _failsWith(LocationFailure.permissionDeniedForever),
      );
    });

    test('konum servisi kapalıysa izin bile sorulmaz', () async {
      platform
        ..serviceEnabled = false
        ..permission = LocationPermission.denied;

      await expectLater(
        service.currentFix(),
        _failsWith(LocationFailure.serviceDisabled),
      );
      expect(platform.permissionRequests, 0);
    });

    test('platform hataları çevrilir', () async {
      for (final (error, failure) in [
        (TimeoutException('gps'), LocationFailure.timeout),
        (
          const LocationServiceDisabledException(),
          LocationFailure.serviceDisabled,
        ),
        (
          const PermissionDeniedException('no'),
          LocationFailure.permissionDenied,
        ),
        (const PositionUpdateException('x'), LocationFailure.unknown),
      ]) {
        platform.positionError = error;
        await expectLater(
          service.currentFix(),
          _failsWith(failure),
          reason: '$error',
        );
      }
    });
  });

  group('GeolocatorLocationService.openSettings', () {
    test(
      'servis kapalıysa konum ayarı, kalıcı ret varsa uygulama ayarı',
      () async {
        await service.openSettings(LocationFailure.serviceDisabled);
        await service.openSettings(LocationFailure.permissionDeniedForever);
        await service.openSettings(LocationFailure.permissionDenied);
        await service.openSettings(LocationFailure.timeout);

        expect(platform.openedSettings, ['location', 'app']);
      },
    );
  });
}

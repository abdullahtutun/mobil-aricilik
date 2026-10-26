import 'package:mobil_arici/core/services/app_info_service.dart';

/// Sabit sürüm ve cihaz; platform kanalına gitmez.
class FakeAppInfoService implements AppInfoService {
  AppInfo info = (
    appVersion: '1.0.0+1',
    platform: 'android',
    osVersion: 'Android 14 (SDK 34)',
    model: 'Google Pixel 7',
  );

  @override
  Future<AppInfo> read() async => info;
}

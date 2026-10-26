import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

/// Uygulama sürümü ve cihaz; görüşe ("Cihaz ve sürüm bilgisini ekle") ve
/// kullanım olaylarına (yalnız sürüm ve platform) eklenir.
typedef AppInfo = ({
  /// `1.0.0+1` biçiminde sürüm ve derleme numarası.
  String appVersion,

  /// `android`, `ios` ya da `other`.
  String platform,
  String osVersion,

  /// Cihaz modeli (ör. `Pixel 7`, `iPhone15,2`).
  String model,
});

abstract interface class AppInfoService {
  Future<AppInfo> read();
}

/// package_info_plus ve device_info_plus ile; sonuç uygulama açık kaldıkça
/// değişmediği için bir kez okunur.
class DeviceAppInfoService implements AppInfoService {
  new();

  Future<AppInfo>? _info;

  @override
  Future<AppInfo> read() => _info ??= _read();

  static Future<AppInfo> _read() async {
    final package = await PackageInfo.fromPlatform();
    final version = package.buildNumber.isEmpty
        ? package.version
        : '${package.version}+${package.buildNumber}';
    final device = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final android = await device.androidInfo;
      return (
        appVersion: version,
        platform: 'android',
        osVersion:
            'Android ${android.version.release} '
            '(SDK ${android.version.sdkInt})',
        model: '${android.manufacturer} ${android.model}',
      );
    }
    if (Platform.isIOS) {
      final ios = await device.iosInfo;
      return (
        appVersion: version,
        platform: 'ios',
        osVersion: '${ios.systemName} ${ios.systemVersion}',
        model: ios.utsname.machine,
      );
    }
    return (
      appVersion: version,
      platform: 'other',
      osVersion: Platform.operatingSystemVersion,
      model: Platform.operatingSystem,
    );
  }
}

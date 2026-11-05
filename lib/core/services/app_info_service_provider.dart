import 'package:mobil_arici/core/services/app_info_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_info_service_provider.g.dart';

/// Testler sabit bilgi veren sahteyle override eder.
@Riverpod(keepAlive: true)
AppInfoService appInfoService(Ref ref) => DeviceAppInfoService();

/// Ayarların altında gösterilen sürüm (`1.0.0+1`).
@riverpod
Future<String> appVersion(Ref ref) async =>
    (await ref.watch(appInfoServiceProvider).read()).appVersion;

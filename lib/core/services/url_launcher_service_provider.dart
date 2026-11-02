import 'package:mobil_arici/core/services/url_launcher_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'url_launcher_service_provider.g.dart';

/// Testler sahte açıcıyla override eder.
@Riverpod(keepAlive: true)
UrlLauncherService urlLauncherService(Ref ref) =>
    const SystemUrlLauncherService();

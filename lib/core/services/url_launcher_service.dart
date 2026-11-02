import 'package:url_launcher/url_launcher.dart';

/// Adresi telefondaki uygulamayla açar (ör. `wa.me` → WhatsApp). Açacak
/// uygulama yoksa false döner.
abstract interface class UrlLauncherService {
  Future<bool> open(Uri uri);
}

class SystemUrlLauncherService implements UrlLauncherService {
  const new();

  @override
  Future<bool> open(Uri uri) =>
      launchUrl(uri, mode: LaunchMode.externalApplication);
}

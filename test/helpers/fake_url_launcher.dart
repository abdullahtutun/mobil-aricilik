import 'package:mobil_arici/core/services/url_launcher_service.dart';

/// Açılan adresleri biriktirir; [available] yanlışsa açacak uygulama yok
/// gibi davranır.
class FakeUrlLauncher implements UrlLauncherService {
  final opened = <Uri>[];
  bool available = true;

  @override
  Future<bool> open(Uri uri) async {
    if (!available) return false;
    opened.add(uri);
    return true;
  }
}

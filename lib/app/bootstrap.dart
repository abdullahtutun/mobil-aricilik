import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/features/auth/data/secure_session_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Uygulamayı verilen flavor ile başlatır.
Future<void> bootstrap(Flavor flavor) async {
  // Native --flavor ile giriş dosyası uyuşmazsa (ör. prod paketi
  // main_dev.dart ile derlenmişse) yanlış ortamla açılmasın.
  if (appFlavor != null && appFlavor != flavor.name) {
    throw StateError(
      'Giriş dosyası "${flavor.name}", --flavor "$appFlavor" ile uyuşmuyor.',
    );
  }

  WidgetsFlutterBinding.ensureInitialized();

  // Inter, SIL OFL 1.1 ile dağıtılıyor; lisans sayfasında görünsün.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/fonts/inter/LICENSE.txt',
    );
    yield LicenseEntryWithLineBreaks(const ['Inter'], license);
  });

  // Ağı beklemez: kayıtlı oturum diskten okunur, süresi dolmuşsa yenileme
  // arka planda denenir. Çevrimdışı yenileme hatası oturumu kapatmaz;
  // otomatik yenileme ağ gelince token'ı tazeler.
  await Supabase.initialize(
    url: flavor.supabaseUrl,
    publishableKey: flavor.supabaseAnonKey,
    authOptions: FlutterAuthClientOptions(
      localStorage: SecureSessionStorage(supabaseUrl: flavor.supabaseUrl),
      // Giriş yalnızca e-postadaki kodla; linkle oturum açılmaz, derin
      // linkler router'a kalır.
      detectSessionInUri: false,
    ),
  );

  runApp(
    ProviderScope(
      overrides: [flavorProvider.overrideWithValue(flavor)],
      child: const App(),
    ),
  );
}

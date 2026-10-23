import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/background_sync.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/supabase_setup.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';

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

  await initializeSupabase(flavor);

  final container =
      ProviderContainer(overrides: [flavorProvider.overrideWithValue(flavor)])
        // Senkron tetikleri uygulama açık kaldıkça çalışır.
        ..listen(syncTriggersProvider, (_, _) {});

  runApp(UncontrolledProviderScope(container: container, child: const App()));

  // Açılışı bekletmez.
  unawaited(registerBackgroundSync(flavor));
}

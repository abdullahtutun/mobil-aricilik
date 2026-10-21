import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_aricilik/app/app.dart';
import 'package:mobil_aricilik/app/flavor.dart';

/// Uygulamayı verilen flavor ile başlatır.
void bootstrap(Flavor flavor) {
  // Native --flavor ile giriş dosyası uyuşmazsa (ör. prod paketi
  // main_dev.dart ile derlenmişse) yanlış ortamla açılmasın.
  if (appFlavor != null && appFlavor != flavor.name) {
    throw StateError(
      'Giriş dosyası "${flavor.name}", --flavor "$appFlavor" ile uyuşmuyor.',
    );
  }

  // Inter, SIL OFL 1.1 ile dağıtılıyor; lisans sayfasında görünsün.
  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle.loadString(
      'assets/fonts/inter/LICENSE.txt',
    );
    yield LicenseEntryWithLineBreaks(const ['Inter'], license);
  });

  runApp(
    ProviderScope(
      overrides: [flavorProvider.overrideWithValue(flavor)],
      child: const App(),
    ),
  );
}

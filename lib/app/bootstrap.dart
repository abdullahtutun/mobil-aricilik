import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/background_sync.dart';
import 'package:mobil_arici/app/error_reporting.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/supabase_setup.dart';
import 'package:mobil_arici/core/sync/document_file_triggers.dart';
import 'package:mobil_arici/core/sync/knowledge_update_triggers.dart';
import 'package:mobil_arici/core/sync/media_upload_triggers.dart';
import 'package:mobil_arici/core/sync/receipt_file_triggers.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_triggers.dart';
import 'package:mobil_arici/features/documents/presentation/document_reminders.dart';
import 'package:mobil_arici/features/tasks/presentation/task_push.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';

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

  // Supabase açılışındaki hatalar da Sentry'ye gitsin.
  await runWithErrorReporting(flavor, () async {
    await initializeSupabase(flavor);

    final container =
        ProviderContainer(overrides: [flavorProvider.overrideWithValue(flavor)])
          // Senkron, medya, görüş ve kullanım olayı gönderimi, belge ve fiş
          // dosyalarının yüklenip indirilmesi, bilgi bankası güncellemesi,
          // görev ve belge hatırlatmalarının eşitlemesi, push token kaydı
          // ve bildirimden görev açma uygulama açık kaldıkça çalışır.
          ..listen(syncTriggersProvider, (_, _) {})
          ..listen(mediaUploadTriggersProvider, (_, _) {})
          ..listen(telemetryUploadTriggersProvider, (_, _) {})
          ..listen(documentFileTriggersProvider, (_, _) {})
          ..listen(receiptFileTriggersProvider, (_, _) {})
          ..listen(knowledgeUpdateTriggersProvider, (_, _) {})
          ..listen(taskRemindersProvider, (_, _) {})
          ..listen(documentRemindersProvider, (_, _) {})
          ..listen(pushRegistrationProvider, (_, _) {})
          ..listen(pushTaskLinksProvider, (_, _) {});

    runApp(UncontrolledProviderScope(container: container, child: const App()));

    // Açılışı bekletmez.
    unawaited(registerBackgroundSync(flavor));
  });
}

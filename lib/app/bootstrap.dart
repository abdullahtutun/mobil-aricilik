import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/app/app.dart';
import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/background_sync.dart';
import 'package:mobil_arici/app/error_reporting.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/sync/sync_reminder.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/sync/document_file_triggers.dart';
import 'package:mobil_arici/core/sync/knowledge_update_triggers.dart';
import 'package:mobil_arici/core/sync/logo_file_triggers.dart';
import 'package:mobil_arici/core/sync/media_upload_triggers.dart';
import 'package:mobil_arici/core/sync/receipt_file_triggers.dart';
import 'package:mobil_arici/core/sync/sync_backend.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:mobil_arici/core/sync/telemetry_upload_triggers.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/locale_sync.dart';
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

  // Inter, Vazirmatn ve Noto Sans Devanagari SIL OFL 1.1 ile dağıtılıyor;
  // lisans sayfasında görünsünler.
  LicenseRegistry.addLicense(() async* {
    for (final (family, folder) in [
      ('Inter', 'inter'),
      ('Vazirmatn', 'vazirmatn'),
      ('Noto Sans Devanagari', 'noto_sans_devanagari'),
    ]) {
      final license = await rootBundle.loadString(
        'assets/fonts/$folder/LICENSE.txt',
      );
      yield LicenseEntryWithLineBreaks([family], license);
    }
  });

  // Sunucu istemcisinin açılış hataları da Sentry'ye gitsin.
  await runWithErrorReporting(flavor, () async {
    final backend = resolveBackend(flavor);
    final backendOverrides = await initializeBackend(flavor, backend);

    final container = ProviderContainer(
      overrides: [
        flavorProvider.overrideWithValue(flavor),
        ...backendOverrides,
      ],
    );
    // Sunucu değiştiyse (BACKEND, PB_URL, flavor) eski imleçlerle
    // çekilmesin; ilk senkron turundan ve ilk çekme ekranının kararından
    // önce. Yalnız yerel DB, ağı beklemez.
    await resetCursorsIfBackendChanged(
      container.read(appDatabaseProvider),
      syncBackendIdentity(flavor, backend),
    );
    container
      // Senkron, medya, görüş ve kullanım olayı gönderimi; belge, fiş
      // ve işletme logosu dosyalarının yüklenip indirilmesi; bilgi
      // bankası güncellemesi; görev, belge ve gönderilemeyen kayıt
      // hatırlatmalarının eşitlemesi; push token kaydı ve bildirimden
      // görev açma; arayüz dilinin hesaba yazılması uygulama açık
      // kaldıkça çalışır.
      ..listen(syncTriggersProvider, (_, _) {})
      ..listen(mediaUploadTriggersProvider, (_, _) {})
      ..listen(telemetryUploadTriggersProvider, (_, _) {})
      ..listen(documentFileTriggersProvider, (_, _) {})
      ..listen(receiptFileTriggersProvider, (_, _) {})
      ..listen(logoFileTriggersProvider, (_, _) {})
      ..listen(knowledgeUpdateTriggersProvider, (_, _) {})
      ..listen(taskRemindersProvider, (_, _) {})
      ..listen(documentRemindersProvider, (_, _) {})
      ..listen(syncReminderProvider, (_, _) {})
      ..listen(pushRegistrationProvider, (_, _) {})
      ..listen(pushTaskLinksProvider, (_, _) {})
      ..listen(localeSyncProvider, (_, _) {});

    useLatinDigitsForDates();
    runApp(UncontrolledProviderScope(container: container, child: const App()));

    // Açılışı bekletmez. Token yenilemesi çevrimdışıyken oturumu kapatmaz
    // (K-6).
    unawaited(container.read(authServiceProvider).refreshSession());
    unawaited(registerBackgroundSync(flavor));
  });
}

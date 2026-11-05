import 'dart:io';

import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/services/reminder_notifications.dart';
import 'package:mobil_arici/features/offline_maps/data/map_area_store.dart';

/// Hesap silme talebinden sonra bu telefonda hesaptan iz bırakmaz: yerel
/// veritabanının her tablosu (kayıtlar, outbox'ta bekleyenler, imleçler,
/// yerel ayarlar), foto, ses, belge, fiş ve logo dosyaları, indirilmiş
/// harita paketleri, kurulu hatırlatma bildirimleri, geçici dosyalar
/// (dışa aktarma kopyaları) ve güvenli depodaki anahtarlar (oturum, işletme
/// kopyası).
///
/// Oturum kapatıldıktan ve senkron durduktan sonra çağrılır. Her adım
/// diğerinden bağımsız denenir; biri başarısız olsa da kalanlar silinir,
/// sonunda ilk hata fırlatılır.
class DeviceDataWiper {
  new({
    required this.db,
    required this.fileStores,
    required this.mapAreas,
    required this.reminders,
    required this.clearSecureStorage,
    required this.temporaryDirectory,
  });

  final AppDatabase db;

  /// Uygulama klasöründeki dosya klasörleri (media, documents, receipts,
  /// logos).
  final List<MediaFileStore> fileStores;
  final MapAreaStore mapAreas;
  final ReminderNotifications reminders;

  /// Keychain/Keystore'daki her anahtarı siler.
  final Future<void> Function() clearSecureStorage;

  /// İçi boşaltılacak geçici klasör; null ise atlanır.
  final Future<Directory?> Function() temporaryDirectory;

  Future<void> wipe() async {
    Object? firstError;
    StackTrace? firstStack;
    Future<void> step(Future<void> Function() action) async {
      try {
        await action();
      } on Object catch (error, stack) {
        firstError ??= error;
        firstStack ??= stack;
      }
    }

    await step(_wipeDatabase);
    for (final store in fileStores) {
      await step(store.clear);
    }
    await step(mapAreas.clear);
    await step(reminders.cancelAll);
    await step(_wipeTemporaryFiles);
    await step(clearSecureStorage);

    if (firstError case final error?) {
      Error.throwWithStackTrace(error, firstStack!);
    }
  }

  /// Her tablo tek transaction'da boşaltılır; sonra VACUUM silinen
  /// satırların dosyada kalan sayfalarını da siler.
  Future<void> _wipeDatabase() async {
    await db.transaction(() async {
      for (final table in db.allTables) {
        await db.delete(table).go();
      }
    });
    await db.customStatement('VACUUM');
  }

  Future<void> _wipeTemporaryFiles() async {
    final directory = await temporaryDirectory();
    if (directory == null || !directory.existsSync()) return;
    for (final entity in directory.listSync()) {
      try {
        entity.deleteSync(recursive: true);
      } on FileSystemException {
        // Sistemin o an kullandığı dosya; geçici klasör zaten temizlenir.
      }
    }
  }
}

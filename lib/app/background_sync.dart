import 'dart:ui' show IsolateNameServer;

import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/connectivity_service.dart';
import 'package:mobil_arici/core/services/media_file_store.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
import 'package:mobil_arici/core/sync/media_upload_scheduler.dart';
import 'package:mobil_arici/core/sync/media_upload_triggers.dart';
import 'package:mobil_arici/core/sync/sync_backend.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:workmanager/workmanager.dart';

/// Periyodik senkron görevinin kimliği. iOS'ta `AppDelegate` ve
/// `Info.plist`'teki (`BGTaskSchedulerPermittedIdentifiers`) kimlikle aynı
/// olmalı.
const backgroundSyncTask = 'com.tutunsoft.mobilarici.sync';

/// Periyodik arka plan senkronunu kaydeder: Android en sık 15 dakikada
/// bir ve yalnız ağ varken çalıştırır; iOS zamanı kullanıma göre kendisi
/// seçer. Kayıt zaten varsa ayarları güncellenir, sayaç sıfırlanmaz.
/// Medya yükleme görevi ([backgroundMediaUploadTask]) aynı giriş noktasını
/// kullanır; `MediaUploadScheduler` planlar.
Future<void> registerBackgroundSync(Flavor flavor) async {
  await Workmanager().initialize(backgroundSyncDispatcher);
  await Workmanager().registerPeriodicTask(
    backgroundSyncTask,
    backgroundSyncTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    inputData: {backgroundFlavorKey: flavor.name},
  );
}

/// workmanager'ın arka plan motorunda çalışan giriş noktası.
///
/// Uygulama açıksa (aynı süreçte) işi ona devreder ve hemen biter: iki
/// motor aynı oturumu yenilerse refresh token yeniden kullanılmış sayılıp
/// oturum düşebilir, iki tur da aynı outbox'ı gönderir. Uygulama kapalıysa
/// sunucu istemcisini ([backendDefine] ya da flavor'ın varsayılanı) ve DB'yi
/// kendisi açar. Oturum yoksa bir şey yapmaz. Sunucu son turdakinden
/// farklıysa önce imleçleri sıfırlar (`resetCursorsIfBackendChanged`).
///
/// Periyodik görev senkron turundan sonra bekleyen medyayı da yükler.
/// Medya görevi yalnız yükler; geçici hatada false döner ve Android
/// görevi üstel bekleyerek yeniden dener.
@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    final media = task == backgroundMediaUploadTask;
    final portName = media ? foregroundMediaPortName : foregroundSyncPortName;
    if (IsolateNameServer.lookupPortByName(portName) case final port?) {
      port.send(null);
      return true;
    }
    final flavor = Flavor.values.asNameMap()[inputData?[backgroundFlavorKey]];
    if (flavor == null) return true;

    final backend = resolveBackend(flavor);
    final connection = await openBackgroundConnection(flavor, backend);
    if (connection == null) return true;

    final db = openAppDatabase();
    try {
      if (!media) {
        // Güncellenen uygulama yeni sunucuyla ilk kez arka planda açılırsa
        // eski sunucunun imleçleriyle çekmesin.
        await resetCursorsIfBackendChanged(
          db,
          syncBackendIdentity(flavor, backend),
        );
        await SyncService(
          db,
          connection.sync,
          refreshSession: connection.refreshSession,
        ).sync();
      }
      final uploaded = await MediaSyncService(
        db,
        connection.files,
        MediaFileStore.app(),
        PlusConnectivityService(),
      ).uploadPending();
      return !media || uploaded.outcome != MediaUploadOutcome.retryLater;
    } finally {
      await db.close();
    }
  });
}

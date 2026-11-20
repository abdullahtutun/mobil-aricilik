import 'dart:ui' show IsolateNameServer;

import 'package:mobil_arici/app/backend_setup.dart';
import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/sync/sync_backend.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:workmanager/workmanager.dart';

/// Periyodik senkron görevinin kimliği. iOS'ta `AppDelegate` ve
/// `Info.plist`'teki (`BGTaskSchedulerPermittedIdentifiers`) kimlikle aynı
/// olmalı.
const backgroundSyncTask = 'com.tutunsoft.mobilarici.sync';

/// Eski medya yükleme görevinin kimliği. Fotoğraf ve sesli notlar artık
/// sunucuya gitmiyor (2026-11-20); güncellenen telefonda planlı kalan görev
/// iptal edilir, yine de çalışırsa bir şey yapmaz.
const legacyMediaUploadTask = 'com.tutunsoft.mobilarici.media';

/// Arka plan görevlerinin `inputData`'sında çalışan flavor'ın adı.
const backgroundFlavorKey = 'flavor';

/// Periyodik arka plan senkronunu kaydeder: Android en sık 15 dakikada
/// bir ve yalnız ağ varken çalıştırır; iOS zamanı kullanıma göre kendisi
/// seçer. Kayıt zaten varsa ayarları güncellenir, sayaç sıfırlanmaz.
Future<void> registerBackgroundSync(Flavor flavor) async {
  await Workmanager().initialize(backgroundSyncDispatcher);
  await Workmanager().cancelByUniqueName(legacyMediaUploadTask);
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
/// sunucu istemcisini (flavor'ın adresi ya da `PB_URL`) ve DB'yi kendisi
/// açar. Oturum yoksa bir şey yapmaz. Sunucu son turdakinden
/// farklıysa önce imleçleri sıfırlar (`resetCursorsIfBackendChanged`).
///
/// Eski medya görevi ([legacyMediaUploadTask]) bir şey yapmadan biter.
@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == legacyMediaUploadTask) return true;
    if (IsolateNameServer.lookupPortByName(foregroundSyncPortName)
        case final port?) {
      port.send(null);
      return true;
    }
    final flavor = Flavor.values.asNameMap()[inputData?[backgroundFlavorKey]];
    if (flavor == null) return true;

    final connection = await openBackgroundConnection(flavor);
    if (connection == null) return true;

    final db = openAppDatabase();
    try {
      // Güncellenen uygulama yeni sunucuyla ilk kez arka planda açılırsa
      // eski sunucunun imleçleriyle çekmesin.
      await resetCursorsIfBackendChanged(db, syncBackendIdentity(flavor));
      await SyncService(
        db,
        connection.sync,
        refreshSession: connection.refreshSession,
      ).sync();
      return true;
    } finally {
      await db.close();
    }
  });
}

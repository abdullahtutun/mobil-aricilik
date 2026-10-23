import 'dart:ui' show IsolateNameServer;

import 'package:mobil_arici/app/flavor.dart';
import 'package:mobil_arici/app/supabase_setup.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/sync/sync_service.dart';
import 'package:mobil_arici/core/sync/sync_triggers.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:workmanager/workmanager.dart';

/// Periyodik senkron görevinin kimliği. iOS'ta `AppDelegate` ve
/// `Info.plist`'teki (`BGTaskSchedulerPermittedIdentifiers`) kimlikle aynı
/// olmalı.
const backgroundSyncTask = 'com.abdullahtutun.mobilarici.sync';

const _flavorKey = 'flavor';

/// Periyodik arka plan senkronunu kaydeder: Android en sık 15 dakikada
/// bir ve yalnız ağ varken çalıştırır; iOS zamanı kullanıma göre kendisi
/// seçer. Kayıt zaten varsa ayarları güncellenir, sayaç sıfırlanmaz.
Future<void> registerBackgroundSync(Flavor flavor) async {
  await Workmanager().initialize(backgroundSyncDispatcher);
  await Workmanager().registerPeriodicTask(
    backgroundSyncTask,
    backgroundSyncTask,
    frequency: const Duration(minutes: 15),
    constraints: Constraints(networkType: NetworkType.connected),
    existingWorkPolicy: ExistingPeriodicWorkPolicy.update,
    inputData: {_flavorKey: flavor.name},
  );
}

/// workmanager'ın arka plan motorunda çalışan giriş noktası.
///
/// Uygulama açıksa (aynı süreçte) turu ona devreder ve hemen biter: iki
/// motor aynı oturumu yenilerse refresh token yeniden kullanılmış sayılıp
/// oturum düşebilir, iki tur da aynı outbox'ı gönderir. Uygulama kapalıysa
/// Supabase'i ve DB'yi kendisi açıp bir tur çalıştırır. Oturum yoksa bir şey
/// yapmaz.
@pragma('vm:entry-point')
void backgroundSyncDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (IsolateNameServer.lookupPortByName(foregroundSyncPortName)
        case final port?) {
      port.send(null);
      return true;
    }
    final flavor = Flavor.values.asNameMap()[inputData?[_flavorKey]];
    if (flavor == null) return true;

    await initializeSupabase(flavor);
    final client = Supabase.instance.client;
    if (client.auth.currentSession == null) return true;

    final db = openAppDatabase();
    try {
      await SyncService(db, client).sync();
    } finally {
      await db.close();
    }
    return true;
  });
}

import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';

/// `local_settings`'te bu telefonun son senkronlandığı sunucu:
/// `<backend>|<adres>` (ör. `pocketbase|https://arici-api-dev.tutunsoft.com`).
const syncBackendKey = 'sync_backend';

/// Senkronun sunucusu [identity] değilse (adres değişti, ör. dev ↔ prod, ya
/// da değer hiç yazılmamış) imleçleri sıfırlar ve [identity]'yi yazar;
/// sıfırladıysa true döner. Uygulama ve arka plan görevi ilk senkron
/// turundan önce çağırır.
///
/// Tek transaction'da: bütün `sync_state` satırları, [fullPullMarker] dahil,
/// silinir; ilk tam çekme yeni sunucudan baştan yapılır (ilk çekme ekranı
/// açılır). Outbox ve yerel kayıtlar korunur: bekleyen kayıtlar yeni
/// sunucuya gönderilir, çekme bekleyen outbox satırını zaten ezmez. Yerel
/// satırların `server_seq`'i okunmadığı için dokunulmaz.
///
/// Değer hiç yoksa da sıfırlanır: önceki sürüm hangi sunucuya bağlıydı
/// bilinmez; gereksiz sıfırlamanın bedeli yalnız bir tam çekme.
Future<bool> resetCursorsIfBackendChanged(AppDatabase db, String identity) =>
    db.transaction(() async {
      final settings = LocalSettingsRepository(db);
      if (await settings.readValue(syncBackendKey) == identity) return false;
      await db.delete(db.syncState).go();
      await settings.writeValue(syncBackendKey, identity);
      return true;
    });

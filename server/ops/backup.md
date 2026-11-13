# Yedek, Mac'e kopya ve geri yükleme (P1.4, K-15)

## Sunucuda gece yedeği

PocketBase'in yerleşik yedeği. Ayar yalnız Coolify ortam değişkeninden gelir (K-10); panelden girilmez.

| Ad | Değer | Not |
| --- | --- | --- |
| `BACKUPS_CRON` | `0 3 * * *` | PocketBase cron'u her zaman UTC'dir (`tools/cron`): `0 3 * * *` = 06:00 TR, 03:00 TR için `0 0 * * *` |
| `BACKUPS_MAX_KEEP` | `7` | Yalnız otomatik (`@auto_pb_backup_…`) yedekler silinir; elle alınanlar kalır |
| `BACKUPS_S3_ENDPOINT`, `…_BUCKET`, `…_REGION`, `…_ACCESS_KEY`, `…_SECRET` | boş | Beşi birden doluysa S3 açılır |

Sunucu her açılışta (`OnBootstrap`) bu değişkenleri PocketBase ayarına yazar ve logda `Backup settings applied from environment cron=… maxKeep=… s3=…` satırını basar. Değer zaten aynıysa yazmaz, satır çıkmaz.

- Değişken boşsa saklı ayara dokunulmaz. Değişkeni silmek yedeği kapatmaz; kapatmak için panelde Settings → Backups'taki cron'u boşaltın.
- `BACKUPS_MAX_KEEP` 1'den küçük ya da sayı değilse, ya da cron ifadesi geçersizse, sunucu yine açılır. Logda değişkenin ya da alanın adı yazar, saklı ayar olduğu gibi kalır.
- S3 değişkenlerinden yalnız bir kısmı doluysa S3 açılmaz, eksik olanların adı loglanır. S3 bir kez açıldıysa, değişkenler sonradan boşaltılsa da açık kalır.
- Yedek zip'i `pb_data`'nın tamamıdır (`data.db`, `auxiliary.db`, `storage/`). `backups/` klasörü zip'e girmez. Ayarlar zip içinde `PB_ENCRYPTION_KEY` ile şifreli durur, bu yüzden geri yüklemede aynı anahtar gerekir.

Panelde Settings → Backups'ta gece yedekleri `@auto_pb_backup_<ad>_<zaman>.zip` adıyla görünür. "Initialize new backup" ile elle bir yedek de alınabilir.

## Mac'e indirme: `pull_backup.sh`

Her ortam için ayrı çalıştırılır. Superuser bilgisi yalnız kendi kabuğunuzdaki ortam değişkenindedir.

```sh
export PB_URL=https://arici-api.tutunsoft.com          # dev: https://arici-api-dev.tutunsoft.com
export PB_SUPERUSER_EMAIL='…'
read -rs PB_SUPERUSER_PASSWORD && export PB_SUPERUSER_PASSWORD   # ekrana ve geçmişe düşmez
server/ops/pull_backup.sh
```

Betik şunları yapar:

1. `/api/app/info` üzerinden ortamı (`dev` ya da `prod`) öğrenir.
2. Superuser olarak giriş yapar ve `/api/backups`'tan en yeni yedeği seçer.
3. Kısa ömürlü bir dosya token'ı alır ve yedeği `~/Yedekler/mobil-arici/pb-<env>/` altına indirir.
4. Boyutu ve zip bütünlüğünü denetler, yanına `<ad>.zip.sha256` yazar.
5. 8 haftadan eski kopyaları siler.

Aynı yedek daha önce indirildiyse yeniden indirmez. Sunucuya yazmaz. Parola ve token'lar komut satırına ya da çıktıya düşmez.

Klasörü değiştirmek için `BACKUP_ROOT` kullanılır.

## Geri yükleme denemesi: `restore_check.sh`

```sh
read -rs PB_ENCRYPTION_KEY && export PB_ENCRYPTION_KEY   # zip'in geldiği ortamın anahtarı
server/ops/restore_check.sh ~/Yedekler/mobil-arici/pb-prod/<ad>.zip
```

Betik önce SHA-256'yı denetler. Sonra zip'i geçici bir `pb_data`'ya açar ve bu checkout'tan `go build` ile derlenen `arici`'yi `127.0.0.1:18090`'da başlatır. Sunucu yalnız `PATH` ve `PB_ENCRYPTION_KEY` ile açılır; kabuktaki `BACKUPS_*` ya da `SMTP_*` değişkenleri ona geçmez. Ardından `health: ok` ve `collections: N (system …, app …)` yazar, sunucuyu kapatır ve geçici kopyayı siler. Zip'e dokunmaz.

Anahtar yanlışsa ya da boşsa sunucu açılmaz: ayarlar çözülemez, betik logun son satırlarını basar. Böylece parola yöneticisindeki anahtar da denenmiş olur.

İsteğe bağlı değişkenler:

- `RESTORE_PORT`: başka bir port.
- `ARICI_BIN`: hazır derlenmiş bir ikili. Örneğin sunucuda çalışan commit'ten derlenmiş bir ikiliyle denemek için.

## Haftalık otomatik indirme (launchd)

launchd kabuk ortamını görmez. Parola dosyaya yazılmaz, macOS Anahtar Zinciri'nden okunur. Her ortam için bir kez kaydedin (`-w` değeri sorar, komut satırına düşmez):

```sh
security add-generic-password -U -s mobil-arici-pb -a prod-email -w
security add-generic-password -U -s mobil-arici-pb -a prod-password -w
security add-generic-password -U -s mobil-arici-pb -a dev-email -w
security add-generic-password -U -s mobil-arici-pb -a dev-password -w
```

`~/Library/LaunchAgents/com.tutunsoft.arici-backup.plist` (her pazartesi 09:00; Mac uykudaysa uyanınca çalışır). `REPO` yerine reponun tam yolunu yazın:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>Label</key>
  <string>com.tutunsoft.arici-backup</string>
  <key>ProgramArguments</key>
  <array>
    <string>/bin/bash</string>
    <string>-c</string>
    <string>
      set -euo pipefail
      kc() { security find-generic-password -s mobil-arici-pb -a "$1" -w; }
      for env in prod dev; do
        if [ "$env" = prod ]; then url=https://arici-api.tutunsoft.com; else url=https://arici-api-dev.tutunsoft.com; fi
        PB_URL="$url" PB_SUPERUSER_EMAIL="$(kc $env-email)" PB_SUPERUSER_PASSWORD="$(kc $env-password)" \
          REPO/server/ops/pull_backup.sh
      done
    </string>
  </array>
  <key>EnvironmentVariables</key>
  <dict>
    <key>PATH</key>
    <string>/opt/homebrew/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
  </dict>
  <key>StartCalendarInterval</key>
  <dict>
    <key>Weekday</key>
    <integer>1</integer>
    <key>Hour</key>
    <integer>9</integer>
    <key>Minute</key>
    <integer>0</integer>
  </dict>
  <key>StandardOutPath</key>
  <string>/tmp/arici-backup.log</string>
  <key>StandardErrorPath</key>
  <string>/tmp/arici-backup.log</string>
</dict>
</plist>
```

```sh
launchctl bootstrap gui/$(id -u) ~/Library/LaunchAgents/com.tutunsoft.arici-backup.plist
launchctl kickstart -k gui/$(id -u)/com.tutunsoft.arici-backup   # hemen bir kez dene
cat /tmp/arici-backup.log
```

İlk çalışmada Anahtar Zinciri `security`'ye erişim izni sorar; "Her Zaman İzin Ver" seçilir. Kaldırmak için:

```sh
launchctl bootout gui/$(id -u)/com.tutunsoft.arici-backup
```

## Sunucuya geri yükleme

Önce aynı yedeği `restore_check.sh` ile yerelde deneyin. Ardından iki yoldan biriyle geri yükleyin.

### A. Panelden (yedek sunucudaki `backups/` klasöründeyse)

1. Coolify'da geri yüklenecek ortamı seçin. Prod'a dokunmadan önce o anın yedeğini alın: panelde Settings → Backups → "Initialize new backup", ardından `pull_backup.sh`.
2. Panelde Settings → Backups'ta yedeğin satırında "Restore"a basın. PocketBase `pb_data`'yı değiştirir ve kendini yeniden başlatır. Konteyner kapanırsa Coolify onu yeniden açar.
3. `curl -fsS https://<adres>/api/health` ile 200 aldığınızı, `/api/app/info` ile `env`'in doğru olduğunu denetleyin. Ardından panele giriş yapın.

Mac'teki bir zip için önce panelde "Upload backup" ile yükleyin, sonra aynı adımları izleyin.

### B. Volume üzerinden (panel açılmıyorsa)

1. Coolify'da kaynağı **Stop** edin.
2. VPS'e SSH ile bağlanın. `docker volume ls` ile kaynağın `pb_data` volume'ünü bulun.
3. Mevcut içeriği bir kenara taşıyın; silmeyin. Zip'i bir klasöre açın. Kökünde `data.db` olmalı. İçeriği volume'e kopyalayın. Dosyaların sahibi uid 10001 (`arici`) olmalı:

   ```sh
   docker run --rm -v <volume>:/data -v /root/restore:/src alpine:3.24.4 \
     sh -c 'mkdir -p /data/.old && find /data -mindepth 1 -maxdepth 1 ! -name .old -exec mv {} /data/.old/ \; \
            && cp -a /src/. /data/ && chown -R 10001:10001 /data'
   ```

4. Coolify'da **Start** edin. `PB_ENCRYPTION_KEY` yedeğin alındığı ortamınkiyle aynı olmalı.
5. A'nın 3. adımındaki denetimleri yapın. Her şey yerindeyse `.old` klasörünü silin.

### Geri yüklemeden sonra

- Yedekten sonra sunucuya gelen yazmalar kaybolur.
- Ortam değişkenlerindeki yedek ayarı açılışta yeniden yazılır. Yedekteki ayar ondan farklıysa env kazanır.

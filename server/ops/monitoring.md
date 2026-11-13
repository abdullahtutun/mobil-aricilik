# Prod izleme (P10.2)

Prod: `https://arici-api.tutunsoft.com`, Coolify'da "Mobil Arıcı" → **prod**. Bu belge dört şeyi anlatır: kim, neyi, nereden haber verir; ve bir şey ters gidince nereye bakılır. Kararlar: K-9 (Coolify), K-15 (yedek). Geri dönüş tetikleyicileri `docs/pocketbase-gecis.md` "Geçiş günü kontrol listesi"nin sonundadır.

| Ne izlenir | Nereden | Haber nasıl gelir |
| --- | --- | --- |
| Deploy başarısız, konteyner durdu ya da yeniden başladı | Coolify bildirimleri | E-posta |
| Sunucu dışarıdan erişilemiyor (DNS, sertifika, proxy, VPS) | Dışarıdan uptime denetimi, `/api/health`, 5 dk | E-posta |
| Uygulamadaki çökme ve yakalanmayan hata | Sentry (uygulama tarafı) | Sentry e-postası |
| Sunucudaki hata ve uyarı satırları | PocketBase panel → Logs; Coolify konteyner logu | Yok, elle bakılır (aşağıdaki kalıplar) |
| Gece yedeği | PocketBase panel → Settings → Backups; haftalık `pull_backup.sh` | Yok, haftada bir elle bakılır |

## 1. Coolify bildirimleri

**Sen yaparsın.**

1. panel.tutunsoft.com → **Notifications** → **Email**. Coolify bildirim ayarları takım düzeyindedir, dev'i de kapsar.
2. SMTP ayarı: Coolify'ın instance SMTP'si varsa "Use system wide (transactional) email settings" açılır. Yoksa Hostinger SMTP girilir: `smtp.hostinger.com`, `465`, SSL. Gönderici olarak `noreply@tutunsoft.com` ya da ayrı bir kutu kullanılır, parola yalnız panele girilir. Alıcı kendi adresin.
3. **Send Test Email** ile deneme e-postası gelmeli. Spam klasörünü de kontrol et.
4. Açılacak olaylar:
   - **Deployment Failure**: açık.
   - **Container Status Changes**: açık. Konteyner durunca, sağlık denetimi düşünce ya da yeniden başlayınca e-posta gelir. Bellek yüzünden (OOM) yeniden başlama da buraya düşer; bu bir geri dönüş tetikleyicisidir.
   - **Server Disk Usage** ya da **Server Reachable/Unreachable** varsa: açık. Yedekler ve `pb_data` aynı diskte.
   - **Deployment Success**: isteğe bağlı. Prod yalnız elle deploy edildiği için gürültü yapmaz.
5. Deneme: prod'da **Restart**'a bas. "Container Status Changes" e-postası gelmeli. Prod'da Health Check açık olmalı (`coolify.md`: `/api/health`, 8090).

## 2. Dışarıdan çalışma süresi denetimi

Coolify aynı VPS'te çalışıyor. VPS ya da ağ giderse kendi bildirimini de gönderemez. Bu yüzden dışarıdan bir denetim gerekir.

**Öneri:** UptimeRobot'un ücretsiz planı (50 monitör, 5 dk aralık, e-posta). Benzer ücretsiz bir servis de olur (ör. Better Stack, Freshping).

**Sen yaparsın.**

1. Yeni monitör: tür **HTTP(s)**, adres `https://arici-api.tutunsoft.com/api/health`, aralık **5 dakika**, yöntem GET. Yalnız 2xx başarılı sayılır.
2. İsteğe bağlı: **Keyword** türünde aynı adres, anahtar kelime `healthy`. PocketBase'in yanıtı `{"message":"API is healthy.","code":200,...}` biçimindedir.
3. SSL sertifika süresi uyarısını aç (varsa, 14 gün önce). Sertifikayı Coolify'ın Traefik'i yeniler; yenileme takılırsa önce bu uyarı gelir.
4. Bildirim kanalı: e-posta. "Down" için hemen gönderilir; çok sık oynarsa "2 ardışık hata" eşiği seçilebilir.
5. İsteğe bağlı ikinci monitör: dev (`https://arici-api-dev.tutunsoft.com/api/health`). Daha az önemlidir.
6. Kurunca durumun **Up** (yeşil) olduğunu gör.

Sağlık yolu kimlik istemez ve veri okumaz; 5 dakikada bir istek sunucuya yük bindirmez. Genel `/api/` hız sınırına (IP başına 10 sn'de 300) girer, ama bu aralıkla yaklaşmaz bile.

## 3. Sentry (uygulama tarafı)

Sentry uygulamada zaten kurulu (`lib/app/error_reporting.dart`). Yeni bir şey kurulmaz.

- Yalnız `--dart-define=SENTRY_DSN=...` ile derlenen sürümde açıktır. Mağaza ve prod derlemeleri README'deki komutla DSN'li derlenir. DSN'siz derlemede hata izleme kapalıdır.
- `environment` flavor adıdır (`prod` / `dev`). Sentry'de prod sorunları `environment:prod` ile süzülür.
- Kullanıcı kimliği, e-posta ve IP gönderilmez (`sendDefaultPii = false`). Çevrimdışıyken en fazla 100 olay diskte bekler, ağ gelince gönderilir. Sahadan gelen hatalar bu yüzden gecikmeli düşebilir.
- Sunucu Sentry'ye bağlı değil. Sunucu hataları aşağıdaki loglardan izlenir.

**Sen yaparsın.** Sentry projesinde **Alerts** → "a new issue is created" kuralı e-postayla açık olsun (varsayılan genelde açıktır, kontrol et). İsteğe bağlı olarak `environment:prod` süzgeci eklenir.

## 4. Loglar: nerede ne var

Sunucunun iki log yeri var:

| Yer | İçerik |
| --- | --- |
| **Coolify** → prod → **Logs** (konteynerin stdout/stderr'i) | Açılış satırları (`Mobil Arıcı server starting env=prod version=…`, `Missing environment variables …`, `Backup settings applied …`), PocketBase'in `Server started at …` satırı, Go panic'leri, konteynerin kapanıp açılması |
| **PocketBase panel** (`https://arici-api.tutunsoft.com/_/`) → **Logs** | Her HTTP isteği (yol, durum kodu, süre, hata) ve uygulama kodunun `app.Logger()` satırları: senkron, OTP e-postası, hesap silme, lot sayfası, ekip, cron. Saklama süresi panelde Settings → Logs'tadır (PocketBase varsayılanı 5 gün). |

PocketBase `--dev` dışında `app.Logger()`'ı konsola yazmaz. Bu yüzden `sync push rolled back` ya da `OTP e-mail not sent` gibi satırlar Coolify'da görünmez, panelin Logs sayfasında görünür. Coolify'da `level=ERROR` yalnız açılış hatalarında çıkar.

### Aranacak kalıplar

Coolify logunda (arama kutusu ya da indirip `grep`):

| Kalıp | Anlamı | Ne yapılır |
| --- | --- | --- |
| `level=ERROR` | Açılışta yapılandırma hatası (ör. `APP_ENV must be dev or prod`) | Ortam değişkenini düzelt, yeniden deploy |
| `level=WARN msg="Missing environment variables"` | Bir özellik kapalı açıldı (`feature=` adı söyler: hava 503, e-posta 503…) | Eksik değişkeni gir |
| `panic:` / `fatal error:` | Go çöktü, konteyner yeniden başlar | Satırları sakla, Claude'a ver |
| Art arda `Mobil Arıcı server starting` | Konteyner sık yeniden başlıyor; çoğu zaman bellek (OOM) | Coolify'da Memory sınırı ve `GOMEMLIMIT` (prod `512m` / `448MiB`); tekrarlıyorsa geri dönüş tetikleyicisi |

PocketBase panel → Logs'ta (filtre kutusu; seviye: hata 8, uyarı 4):

| Filtre | Anlamı |
| --- | --- |
| `level >= 8` | Bütün hata satırları. Prod'da her gün boş olmalı. |
| `message ~ 'sync push'` | `sync push rolled back`: bir gönderim paketi geri alındı (uyarı, `data.error` nedeni söyler). Tek tük olabilir; aynı kullanıcıda tekrarlıyorsa senkron takılıyordur. |
| `data.error ~ 'database is locked'` | SQLite yazma kilidi zaman aşımı (R5). Görünürse istek sayısı ve süreleri not edilip Claude'a verilir. |
| `data.status >= 500` | Sunucu hatası dönen istekler. Tekrarlayan 5xx bir geri dönüş tetikleyicisidir. |
| `message ~ 'OTP e-mail not sent'` | Giriş kodu gönderilemedi (SMTP). 1 saatte çözülemezse geri dönüş tetikleyicisi. |
| `message ~ 'account-deletion-purge'` | Saatlik kalıcı silme cron'u hata verdi. |
| `data.status = 429` | Hız sınırına takılan istekler. Normal kullanıcıda görünüyorsa sınır gözden geçirilir. |

## 5. Günlük yedeğin kontrolü

Gece yedeği PocketBase'in kendi yedeğidir (`backup.md`). `BACKUPS_CRON=0 3 * * *` UTC, yani TR saatiyle 06:00. `BACKUPS_MAX_KEEP=7`.

**Sen yaparsın.**

- **İlk hafta her gün, sonra haftada bir:** panel → Settings → Backups'ta en üstte bugünün `@auto_pb_backup_…` dosyası olmalı ve boyutu bir öncekinden belirgin küçük olmamalı. Yoksa Coolify logunda `Backup settings applied` satırını ve panelde cron ayarını kontrol et.
- **Haftada bir:** Mac'e kopya (`pull_backup.sh`; launchd kuruluysa pazartesi 09:00'da kendiliğinden). `~/Yedekler/mobil-arici/pb-prod/` altında yeni zip ve `.sha256` olmalı.
- **Ayda bir:** en yeni kopyayla `restore_check.sh`. Sonuç `health: ok` olmalı, koleksiyon sayısı bir öncekiyle aynı olmalı (2026-11-13: 58).
- Disk: Coolify → Server → disk kullanımı. Yedekler ve `pb_data` aynı diskte (R3); %80'i geçerse eski elle alınmış yedekler silinir.

## 6. Gözlem süresi (14 gün) için günlük kısa kontrol

P10.2'den sonraki 14 gün (P11.1'in ön koşulu):

1. Uptime servisinde son 24 saat yeşil mi?
2. Coolify'dan "Container Status Changes" e-postası geldi mi? Geldiyse neden?
3. Panel → Logs: `level >= 8` ve `data.status >= 500` boş mu?
4. Sentry: `environment:prod`'da yeni issue var mı?
5. Bugünün gece yedeği var mı?

Herhangi biri kötüyse durumu `docs/progress.md`'ye tarihle yaz. Geri dönüş tetikleyicilerinden biri olursa P10.2 "Ters giderse" uygulanır.

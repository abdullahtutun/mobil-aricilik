# Coolify ayarları (P1.3)

panel.tutunsoft.com'da, proje "Mobil Arıcı", iki ortam: **dev** ve **prod**. Her ortamda bir Application kaynağı. Kararlar: K-8 (alan adları), K-9 (Coolify), K-10 (gizli anahtarlar), K-15 (yedek).

## İki kaynağın ayarları

| Ayar | dev | prod |
| --- | --- | --- |
| Kaynak türü | Application → Private Repository (with GitHub App) | aynı |
| Repo | `abdullahtutun/mobil-aricilik` | aynı |
| Dal | `pocketbase-gecis` (P11.2'de `main`) | `pocketbase-gecis` (P11.2'de `main`) |
| Build Pack | Dockerfile | Dockerfile |
| Base Directory | `/server` | `/server` |
| Dockerfile Location | `/Dockerfile` (Base Directory'ye göre) | aynı |
| Watch Paths | `server/**` | `server/**` |
| Ports Exposes | `8090` | `8090` |
| Domains | `https://arici-api-dev.tutunsoft.com` | `https://arici-api.tutunsoft.com` |
| Persistent Storage | Volume → hedef `/pb/pb_data` (kaynağa özel volume) | Volume → hedef `/pb/pb_data` (ayrı volume) |
| Resource Limits → Memory | `384m` | `512m` |
| Resource Limits → CPU | `1` | `1` |
| Health Check | açık, yol `/api/health`, port `8090`, yöntem GET, 200 | aynı |
| Auto Deploy | **açık** | **kapalı** (yalnız elle "Deploy") |
| Advanced → Include Source Commit in Build | açık | açık |

"Include Source Commit in Build" açıkken Coolify `SOURCE_COMMIT` build argümanını verir; Dockerfile onu `-ldflags` ile ikiliye yazar ve `GET /api/app/info` `version` alanında gösterir. Kapalıysa `version` `unknown` olur (Coolify bu ayarı Docker önbelleği bozulmasın diye varsayılan kapalı tutar). Build context yalnız `server/` olduğu için `.git` imaja girmez; commit başka yoldan okunmaz.

HTTPS ve yönlendirme Coolify'ın kendi proxy'sinde (Traefik); ayrı Caddy/Nginx kurulmaz. Dockerfile'da da bir `HEALTHCHECK` var (`wget` ile `/api/health`); Coolify'ın kendi denetimi açıksa o kullanılır.

## Ortam değişkenleri

Hepsi **runtime**; hiçbiri "Build Variable" olarak işaretlenmez (gizli değer imaj katmanına girmesin). Değerler yalnız panelde; repoya, prompta, Claude'a verilmez.

P1.3'te girilenler (her ortamda ayrı değer):

| Ad | dev | prod |
| --- | --- | --- |
| `APP_ENV` | `dev` | `prod` |
| `APP_URL` | `https://arici-api-dev.tutunsoft.com` | `https://arici-api.tutunsoft.com` |
| `PB_ENCRYPTION_KEY` | `openssl rand -hex 16` (32 karakter), parola yöneticisine de kaydet | ayrı üret |
| `GOMEMLIMIT` | `320MiB` | `448MiB` |
| `TRUSTED_PROXY_HEADERS` | `X-Forwarded-For` | `X-Forwarded-For` |

`PB_ENCRYPTION_KEY` bir kez üretilir ve değiştirilmez: değişirse PocketBase ayarları (SMTP, yedek) çözülemez.

İlgili adımda girilecekler (şimdilik boş bırakılır; sunucu açılışta eksik adları loglar):

| Ad | Adım |
| --- | --- |
| `BACKUPS_CRON`, `BACKUPS_MAX_KEEP` | P1.4 (ayrıntı: `backup.md`) |
| `BACKUPS_S3_ENDPOINT`, `BACKUPS_S3_BUCKET`, `BACKUPS_S3_REGION`, `BACKUPS_S3_ACCESS_KEY`, `BACKUPS_S3_SECRET` | S3 hedefi alınınca (K-15) |
| `SMTP_HOST`, `SMTP_PORT`, `MAIL_NOREPLY_USER`, `MAIL_NOREPLY_PASS` | P4.2 (`smtp.hostinger.com`, `465`, `noreply@tutunsoft.com`; dördü birlikte, yoksa OTP 503) |
| `MAIL_FEEDBACK_USER`, `MAIL_FEEDBACK_PASS`, `FEEDBACK_TO_EMAIL` | P5.7 |
| `WEATHERAPI_KEY`, `WEATHERAPI_DAYS` | P5.5 |
| `FCM_SERVICE_ACCOUNT_B64` | P5.6 |

## İlk deploy'dan sonra

1. Deploy logunda `Successfully built` ve konteyner logunda `Mobil Arıcı server starting env=dev` (prod'da `env=prod`) satırını gör. `Missing environment variables feature=core` satırı varsa P1.3'teki beş değişkenden biri eksik.
2. Superuser'ı hemen aç: kaynağın Terminal sekmesinde `/pb/arici superuser upsert <e-posta> <güçlü parola>`. İlk açılışta log bir `pbinstall` bağlantısı basar; superuser açılınca bu bağlantı işe yaramaz. Parola yalnız parola yöneticisinde.
3. Dışarıdan denetim: `curl -fsS https://arici-api-dev.tutunsoft.com/api/health` ve `curl -fsS https://arici-api-dev.tutunsoft.com/api/app/info` (`env` doğru mu, `version` commit mi).
4. Volume kalıcılığı: yeniden deploy et, superuser girişi hâlâ çalışmalı.

# Supabase → PocketBase geçişi

Kasım 2026 · Abdullah Tutun

## Özet

Mobil Arıcı'nın backend'i Supabase'den, Hosting.com.tr'deki (Türkiye) VPS'te Coolify ile çalışan PocketBase'e taşınır. PocketBase Go ile genişletilmiş kendi ikilimiz olarak `server/` klasöründe yaşar. Senkron, yetki, hesap silme, bildirim ve hava durumu bu ikilinin içindeki Go kodudur. Flutter'da önce bir backend soyutlaması kurulur. Supabase ve PocketBase uygulamaları yan yana yaşar, `BACKEND` ayarı hangisinin kullanılacağını seçer. Önce dev, en son prod geçer.

Uygulama yayında değil; Supabase'deki veri demo ve test verisi (4 kullanıcı, 3 işletme, 47 kovan, 7 dosya ≈ 0,9 MB). Bu yüzden kademeli geçiş, zorunlu güncelleme ve kullanıcı taşıma yok (K-11, K-12). Supabase yine de geçiş bitip 14 günlük gözlem süresi dolana kadar olduğu gibi çalışır; hiçbir adım onu kapatmaz ya da verisini silmez.

Bu dosyanın her adımı tek bir Claude oturumunda bitecek büyüklüktedir. Her adımın "Prompt" bölümü kopyalanıp yeni bir oturuma yapıştırılır. Adımlar kontrol listesindeki **satır sırasıyla** yapılır; bir adım ancak "Bağımlı" sütunundaki adımlar bitince başlar. Dosyalar (P6) birkaç P5 adımının ön koşulu olduğu için listede P3'ün hemen arkasında durur; bölümler ise kod sırasıyla yazılmıştır.

### Kontrol listesi

Durum: ☐ yapılmadı · ◐ sürüyor · ☑ bitti. Adım bitince Claude bu tabloda durumu ☑ yapar.

| Kod | Başlık | Bağımlı | Durum |
| --- | --- | --- | --- |
| P0.1 | Geçiş dalı, karar kaydı, CLAUDE.md notu | — | ☑ |
| P0.2 | Supabase'in tam yedeği | P0.1 | ☑ |
| P1.1 | DNS A kayıtları | P0.1 | ☑ |
| P1.2 | `server/` iskeleti: Go + PocketBase + Dockerfile | P0.1 | ☑ |
| P1.3 | Coolify'da dev ve prod servisleri | P1.1, P1.2 | ☑ |
| P1.4 | Günlük yedek, Mac'e kopya, geri yükleme denemesi | P1.3 | ☐ |
| P2.1 | Şema kalıbı, ortak alanlar, `server_seq` sayacı, users, organizations, memberships | P1.2 | ☐ |
| P2.2 | Koleksiyonlar: arılıklar, kovanlar, ana arılar, kovan geçmişi | P2.1 | ☐ |
| P2.3 | Koleksiyonlar: muayene, medya, varroa, ilaçlar, ilaçlama, besleme | P2.2 | ☐ |
| P2.4 | Koleksiyonlar: görev, hasat, belge, göç, taşıma | P2.3 | ☐ |
| P2.5 | Koleksiyonlar: stok, ana yetiştirme, lotlar ve analiz | P2.4 | ☐ |
| P2.6 | Koleksiyonlar: finans, müşteri, destek dönemleri; referans verinin taşınması | P2.5 | ☐ |
| P2.7 | Senkronlanmayan koleksiyonlar: davet, token, görüş, analitik, hava önbelleği, silme | P2.6 | ☐ |
| P2.8 | Şema dökümü ve Flutter `schema_mirror_test` uyarlaması | P2.7 | ☐ |
| P3.1 | Yetki katmanı (`authz`) ve politika testleri | P2.8 | ☐ |
| P3.2 | API kuralları ve "kuralsız koleksiyon yok" testi | P3.1 | ☐ |
| P6.1 | Dosya koleksiyonları (7 bucket'ın karşılığı) | P3.2 | ☐ |
| P6.2 | Bilgi bankası paketi ve yayımlama aracı | P6.1 | ☐ |
| P4.1 | OTP girişi: ilk istekte kullanıcı açma, 9 dilli e-posta, demo hesap | P3.2 | ☐ |
| P4.2 | SMTP (Hostinger) ve oturum ayarları ortam değişkeninden; canlı e-posta denemesi | P4.1, P1.3 | ☐ |
| P5.1 | Senkron çekme: `/api/sync/pull` | P3.2 | ☐ |
| P5.2 | Senkron gönderme çekirdeği: `/api/sync/push`, LWW, olay, sonuçlar | P5.1 | ☐ |
| P5.3 | Gönderme özel kuralları: işletme, üyelik, korumalar, doğrulama | P5.2 | ☐ |
| P5.4 | İşletme kurma ve ekip daveti route'ları | P5.3 | ☐ |
| P5.5 | Hava durumu: `weather-bundle` | P5.1 | ☐ |
| P5.6 | Push bildirim: FCM, cihaz token'ı, görev ataması, destek dönemi cron'u | P5.4 | ☐ |
| P5.7 | Görüş e-postası | P5.4, P4.2, P6.1 | ☐ |
| P5.8 | Hesap silme: kod, talep, iptal, durum | P5.6 | ☐ |
| P5.9 | Hesap silme: saatlik kalıcı silme cron'u, 3 yıllık kayıt, e-postalar | P5.8, P6.1 | ☐ |
| P5.10 | Lotun herkese açık sayfası (açılıyor) | P5.3, P6.1 | ☐ |
| P7.1 | Flutter backend soyutlaması ve seçim ayarı | P0.1 | ☐ |
| P7.2 | PocketBase istemcisi, oturum saklama, OTP girişi | P7.1, P4.1 | ☐ |
| P7.3 | Senkron taşıyıcısı, backend değişiminde imleç sıfırlama, arka plan görevi | P7.2, P5.3 | ☐ |
| P7.4 | Dosya yükleme ve indirme | P7.3, P6.2 | ☐ |
| P7.5 | Servisler: işletme, ekip, hava, push token, görüş ve analitik, hesap silme | P7.4, P5.4–P5.9 | ☐ |
| P7.6 | Lot sayfası adresi, yasal metinler, dev'de varsayılan PocketBase | P7.5, P5.10 | ☐ |
| P8.1 | Referans veri ve demo hesap tohumu (idempotent, dry-run) | P7.6 | ☐ |
| P9.1 | İki cihaz ve çevrimdışı senkron testleri (yerel PocketBase) | P8.1 | ☐ |
| P9.2 | Dev sunucusunda uçtan uca: roller, hesap silme, dosyalar, push, e-posta | P9.1 | ☐ |
| P9.3 | Yük ve RAM kontrolü | P9.2 | ☐ |
| P10.1 | Prod hazırlığı ve Supabase yazmalarının dondurulması | P9.3 | ☐ |
| P10.2 | Geçiş: prod varsayılanı PocketBase, sürüm, izleme | P10.1 | ☐ |
| P11.1 | Flutter'dan Supabase'in kaldırılması (gözlemden sonra) | P10.2 + 14 gün | ☐ |
| P11.2 | Dokümanlar, CLAUDE.md, araçlar ve hafıza | P11.1 | ☐ |
| P11.3 | Supabase projesinin duraklatılması | P11.2 | ☐ |

## Kararlar

Kullanıcıyla 2026-11-09'da kararlaştırıldı. Promptlar bu kodlara atıf yapar.

- **K-1 Sunucu dili.** PocketBase, Go ile genişletilmiş kendi ikilimiz olarak derlenir (`github.com/pocketbase/pocketbase` modülü, Go framework kullanımı). JS hook kullanılmaz. Neden: FCM için RS256 imzası JS hook'larda yok; 35 tablolu senkron ve hesap silme `go test` ile test edilmeli; transaction'lar Go'da güvenilir.
- **K-2 Sürüm.** PocketBase **v0.40.6** (2026-10-23, GitHub'daki "Latest"). `server/go.mod`'da tam sürüm sabit, `go.sum` repoda. Release notu bunun GitHub'daki muhtemelen son sürüm olduğunu ve güncellemelerin yeni bir host'a taşınacağını söylüyor; sürüm yükseltme bu geçişin kapsamı dışında, ayrı bir karar.
- **K-3 Şema migration'ları.** PocketBase'in `pb_migrations` karşılığı Go framework'te `server/migrations/` paketindeki Go migration'larıdır (`migratecmd`, `Automigrate: false`). Panelden şema değişikliği yapılmaz; panelde yapılan değişiklik dosya üretmez ve P2.8'deki şema dökümü testi farkı yakalar.
- **K-4 Kimlikler.** Tüm koleksiyonlarda `id` alanı UUID kabul eder: desen `^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$`, min = max = 36, otomatik üretimde UUIDv7. (PocketBase `core/field_text.go`: birincil anahtarda desen zorunlu, tire yasaklı karakter değil.) İstemcinin UUIDv7 kimlikleri aynen kullanılır.
- **K-5 Senkron zaman alanları.** `created_at`, `updated_at`, `deleted_at` ve diğer senkron zamanları PocketBase tarih alanı değil, **metin** alanıdır: UTC, mikrosaniyeli ISO-8601 (`2026-11-09T10:15:30.123456Z`, sabit genişlik), desenle doğrulanır. LWW karşılaştırması bu metin üzerinden yapılır (sabit genişlikli UTC'de sözlük sırası = zaman sırası). Gün kolonları (`expires_on` vb.) `YYYY-MM-DD` metni. PocketBase'in kendi `created`/`updated` autodate alanları senkron koleksiyonlarında yoktur.
- **K-6 Oturum.** users koleksiyonunda auth token süresi 90 gün. Uygulama her açılışta ve her senkron turunda token'ı yeniler (`authRefresh`). 90 günden uzun çevrimdışı kalan kullanıcı yeniden kodla girer. Ağ hatası oturumu kapatmaz.
- **K-7 Senkron sözleşmesi.** Senkron PocketBase'in kayıt API'si ve `/api/batch` ile değil, özel route'larla yapılır: `POST /api/sync/push`, `GET /api/sync/pull`. Neden: batch API bir satır hatasında bütün paketi düşürüyor; bizim sözleşmemiz satır başına `ok`/`rejected` ve neden döndürür. Senkron koleksiyonlarının API kuralları null'dır (yalnız sunucu kodu yazar ve okur). `server_seq` tek satırlık bir sayaçtan, kaydın yazıldığı transaction içinde verilir; SQLite tek yazıcılı olduğu için numara sırası commit sırasıdır ve geriye bakma payı gerekmez.
- **K-8 Alan adları.** Prod: `https://arici-api.tutunsoft.com`. Dev: `https://arici-api-dev.tutunsoft.com`. İkisi aynı alan adında olamaz: PocketBase alt yol (base path) desteklemiyor, yönetim paneli ve dosya adresleri kökten çalışıyor. Bu yüzden dev ayrı alt alan adıdır.
- **K-9 Coolify.** İki uygulama kaynağı, ikisi de bu GitHub reposundan, build pack Dockerfile, **Base Directory `/server`**, **Watch Paths `server/**`**. Geçiş boyunca ikisi de `pocketbase-gecis` dalını izler: dev otomatik deploy, prod yalnız elle "Deploy". P11.2'de ikisi `main`'e alınır. HTTPS ve reverse proxy Coolify'ın kendi proxy'sindedir; ayrı Caddy/Nginx kurulmaz.
- **K-10 Gizli anahtarlar.** WeatherAPI, SMTP, FCM servis hesabı, `PB_ENCRYPTION_KEY` yalnız Coolify'da ortam değişkeni. Repoya, prompta, istemciye girmez. Sunucu açılışta SMTP ve yedek ayarlarını ortam değişkeninden PocketBase ayarlarına yazar; panelden girilmez. Superuser yalnız konteyner terminalinde CLI ile açılır, bilgisi parola yöneticisinde durur, hiçbir zaman istemciye verilmez. Superuser gerektiren yerel araçlar bilgiyi kullanıcının kendi kabuğundaki ortam değişkeninden okur; Claude bu değerleri görmez.
- **K-11 Eski sürümler.** Uygulama yayında değil; kademeli geçiş, zorunlu güncelleme ve geçiş süresi yok. Elde kalan eski dev derlemeleri Supabase'e yazmasın diye P10.1'de Supabase'in `sync_push`'u tüm sürümlere 426 dönecek şekilde dondurulur (geri alınabilir, veri silinmez). Supabase salt okunur olarak 14 gün gözlemde kalır, sonra duraklatılır (silinmez).
- **K-12 Veri.** Supabase'deki kullanıcılar ve kayıtlar demo/test; taşınmaz. Taşınan: referans veri (ilaç listesi, destek dönemleri) ve demo hesabı (`demo@tutunsoft.com`), P8.1'deki idempotent tohum aracıyla yeniden kurulur. Supabase kullanıcı UUID'leri korunmaz. Taşınmayanlar: cihaz token'ları (uygulama yeniden kaydeder), davetler, hava önbelleği, analitik olaylar (P0.2 yedeğinde arşivlenir), silme talepleri.
- **K-13 Dosyalar.** Her bucket bir dosya koleksiyonu olur; dosya kaydı satırdan bağımsız yüklenir (bugünkü kuyruk mantığı korunur). Kaydın `id`'si yoldaki son UUID, `path` alanı bugünkü `storage_path` metni, `org_id` yolun ilk klasörü. Harita paketi bucket'ı yok (2026-11-03'te kaldırıldı; telefon OpenFreeMap'ten doğrudan indiriyor), bu yüzden büyük dosya çözümü gerekmiyor.
- **K-14 Lot sayfası.** Kendi alan adımızda HTML sorunsuz sunulduğu için lotun herkese açık sayfası taşımayla açılır: `GET /l/{id}` ve `GET /l/{id}/report`.
- **K-15 Yedek.** Şimdilik sunucu dışı nesne deposu yok. PocketBase'in yerleşik yedeği her gece 03:00'te volume'deki `backups` klasörüne alınır, 7 kopya tutulur. Kullanıcı yedeği haftada bir Mac'ine indirir (P1.4 betiği). S3 uyumlu hedef alınınca yalnız ortam değişkenleri doldurulur.
- **K-16 Konum.** VPS Türkiye'de (Hosting.com.tr). Gizlilik politikasındaki "Supabase AB" ifadesi P7.6'da güncellenir.
- **K-17 Dev verisi.** Dev PocketBase boş başlar; referans veri migration'la, demo hesap P8.1 aracıyla gelir.
- **K-18 Fazlar.** Önerilen fazlardan sapmalar: P6'da harita paketi işi yok (K-13); lot sayfası P5.10'da; yetki (P3) senkron route'unun kullandığı tek bir Go katmanıdır; P8 kullanıcı taşıma değil, referans + demo tohumudur (K-12); P10'da bakım penceresi ve kademeli geçiş yok (K-11).

## Envanter (2026-11-09)

Kaynak: `supabase/migrations` (43 dosya), `supabase/functions`, `supabase/config.toml`, `supabase/templates/otp.html`, `docs/progress.md`, `lib/` ve canlı proje `jcddnelaboueazhordfz` (salt okunur sayım).

**Senkron tabloları (35).** Hepsinde `id uuid`, `org_id`, `created_at`, `updated_at`, `created_by`, `deleted_at`, `server_seq`.

- Durum (son yazan kazanır): apiaries, queens, hives, drugs, tasks, documents, migrations, migration_stops, transports, transport_items, inventory_items, queen_rearing_batches, mating_nucs, lots, customers.
- Olay (yalnız eklenir, bir kez silinir): hive_location_history, hive_status_events, inspections, media, mite_counts, treatments, feedings, harvests, harvest_hives, inventory_moves, lot_harvests, lot_treatments, lab_results, lot_sales, transactions, customer_payments.
- Özel: organizations (yalnız `create_organization` ile kurulur; owner ve partner günceller), memberships (yalnız `invite` fonksiyonu yazar; `sync_push` üyenin kendi satırını "uygulanmadı" döner).
- Referans (salt okunur): ref_drugs, ref_support_periods.

**Senkronlanmayan:** invites, device_tokens, feedback, analytics_events, weather_cache, deletion_requests; private şemada deletion_log, deletion_codes, support_period_notifications.

**Postgres'e özgü yapılar:** ~40 enum; PostGIS `apiaries.location` (istemcide enlem + boylam); işletmeler arası bağı engelleyen bileşik FK'ler `(x_id, org_id)`; silinmemiş kovanlarda tekil etiket kodu (kısmi index); CHECK'ler (tutar ≤ 10¹² `numeric(18,2)`, konum aralığı, alan aralıkları); trigger'lar: `set_server_seq`, `guard_lot_publication`, `keep_hive_quarantine`, `check_customer_payment`, `notify_task_assigned`, `notify_feedback_mail`, `retire_deleted_user_memberships`, `protect_deletion_log`, `sync_member_deletion_schedule`.

**RPC'ler:** `sync_push` (şema sürümü 1–26, desteklenmeyende `PT426`; ret nedenleri forbidden/conflict/missing_reference/unsupported/invalid; 5 dk'dan büyük saat sapmasında uyarı), `sync_pull` (1000 numaralık geriye bakma payı), `create_organization`, `weather_locations`, `lot_public_page`, 11 adet `account_deletion_*`.

**RLS özeti:**

- Olağan veri tabloları: üye okur; owner, partner, worker ekler ve günceller; viewer yalnız okur; silme politikası yok.
- Finans (transactions, customers, customer_payments, receipts dosyaları): yalnız owner ve partner.
- organizations: üye görür; owner ve partner günceller; kurma yalnız RPC.
- memberships: üye işletmenin üyeliklerini görür; çıkarılan kullanıcı kendi satırını da görür.
- invites: owner ve partner kendi işletmesinin davetlerini görür ve üretir.
- device_tokens: kullanıcı yalnız kendi token'larını görür; istemci yazamaz.
- feedback: üye kendi işletmesi adına ekler; okuma yok.
- analytics_events: oturumlu herkes ekler; okuma yok.
- deletion_requests: kullanıcı yalnız kendi talebini görür.
- weather_cache: hiçbir erişim yok (yalnız service role).
- ref_*: girişli herkes okur.
- Storage: yolun ilk klasörü işletme; üye okur, yazabilen rol yükler, güncelleme ve silme yok. receipts yalnız owner ve partner; org-logos yüklemesi owner ve partner; knowledge girişli herkes okur; public-lots yalnız service role.

**Edge Function'lar ve secret adları:**

| Fonksiyon | Görev | Secret'lar |
| --- | --- | --- |
| weather-bundle | Arılık hücreleri için WeatherAPI tahmini, 1 saat önbellek | `WEATHERAPI_KEY`, `WEATHERAPI_DAYS` |
| invite | create, redeem, members, set_role, remove | standart |
| device-token | Push token kaydı ve silme | standart |
| notify | FCM HTTP v1 (görev ataması, destek dönemi); gizli başlıkla | `NOTIFY_SECRET`, `FCM_SERVICE_ACCOUNT` |
| feedback-mail | Görüşü Hostinger SMTP ile (465/SSL) yollar | `FEEDBACK_MAIL_SECRET`, `FEEDBACK_SMTP_USER/PASS`, `FEEDBACK_TO_EMAIL`, `SMTP_HOST/PORT/USER/PASS` |
| account-delete | send_code, verify_code, request, cancel, status; cron ile kalıcı silme | `ACCOUNT_DELETE_CRON_SECRET`, `ACCOUNT_MAIL_SMTP_USER/PASS`, `SMTP_*` |
| lot-page | Herkese açık lot sayfası; uygulamada gizli | standart |

"Standart": `SUPABASE_URL`, `SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY`. Vault: `notify_url/secret`, `feedback_mail_url/secret`, `account_delete_url/secret`.

**pg_cron:** `notify-support-periods` (her gün 06:00 UTC), `account-deletion-purge` (her saat :17).

**Storage:** media 10 MB (jpeg, m4a), documents 20 MB (jpeg, pdf), receipts 10 MB (jpeg), feedback 5 MB (jpeg), org-logos 2 MB (jpeg), knowledge 10 MB (json), public-lots 20 MB (jpeg, pdf). Canlıda 7 dosya, ≈ 0,9 MB.

**Auth:** e-posta OTP, 6 hane, 600 sn, 60 sn'de bir gönderim; oturum süresiz, token 1 saat; şablon `supabase/templates/otp.html` dokuz dilli, dil `user_metadata.locale`'den; SMTP Hostinger (noreply@tutunsoft.com); demo hesap parolayla.

**Flutter'da Supabase'e dokunan dosyalar:** `lib/app/supabase_setup.dart`, `lib/app/flavor.dart`, `lib/app/background_sync.dart`, `lib/core/services/supabase_client_provider.dart`, `lib/features/auth/data/auth_service.dart`, `lib/features/auth/data/secure_session_storage.dart`, `lib/core/sync/sync_service.dart`, `lib/core/sync/storage_file_sync.dart`, `lib/core/sync/media_sync_service.dart`, `lib/core/sync/document_sync_service.dart`, `lib/core/sync/receipt_sync_service.dart`, `lib/core/sync/logo_sync_service.dart`, `lib/core/sync/knowledge_update_service_provider.dart`, `lib/core/sync/telemetry_upload_service.dart`, `lib/features/organization/data/organization_service.dart`, `lib/features/organization/data/organization_cache.dart`, `lib/features/team/data/team_service.dart`, `lib/features/weather/data/weather_service.dart`, `lib/features/tasks/data/device_token_service.dart`, `lib/features/account_deletion/data/account_deletion_service.dart`; araçlar `tool/publish_knowledge.dart`, `tool/store_screenshots.py`, `supabase/admin/*.sql`; testler `integration_test/*` ve `test/` altındaki ilgili servis testleri. Realtime kullanılmıyor.

**Yasal sayfalar:** `docs/legal/account-deletion.html` statik, backend'e dokunmuyor (uygulama içi akış + e-postayla talep). `docs/legal/privacy-policy.html` "Supabase AB" diyor.

## Eşleme tablosu

| Supabase parçası | PocketBase karşılığı | Adım |
| --- | --- | --- |
| Postgres tabloları (35 senkron) | Base koleksiyonlar, UUID `id` (K-4), metin zaman alanları (K-5), `server_seq` sayı alanı, `(org_id, server_seq)` index'i | P2.1–P2.6 |
| Enum'lar | `select` alanları (aynı değerler) | P2.1–P2.6 |
| CHECK kısıtları | Alan min/max/desen + `server/internal/validate` Go doğrulaması | P2.x, P5.3 |
| Bileşik FK (aynı işletme) | Push'ta referans denetimi → `missing_reference` | P5.3 |
| Kısmi tekil index (etiket kodu) | SQLite `CREATE UNIQUE INDEX … WHERE deleted_at = ''` | P2.2 |
| PostGIS `location` | `latitude` + `longitude` sayı alanları | P2.2 |
| `numeric(18,2)` tutar | number alanı + Go'da 10¹² ve 2 ondalık denetimi | P2.6 |
| `private.sync_seq` + `set_server_seq` trigger | `sync_meta` sayaç satırı + kayıt hook'u (aynı transaction) | P2.1 |
| `sync_pull` RPC | `GET /api/sync/pull` | P5.1 |
| `sync_push` RPC (+ `sync_push_change`) | `POST /api/sync/push` | P5.2, P5.3 |
| `guard_lot_publication`, `keep_hive_quarantine`, `check_customer_payment` | Push özel kuralları (Go) | P5.3 |
| `own_membership` / `set_own_member_name` | Push'ta "uygulanmadı" (`applied: false`) | P5.3 |
| `create_organization` RPC | `POST /api/app/organizations` | P5.4 |
| `organizations` select (istemci) | `GET /api/app/organizations/mine` | P5.4 |
| RLS `is_member` / `has_role` | `server/internal/authz` + testler | P3.1 |
| RLS (doğrudan erişilen tablolar) | API kuralları | P3.2 |
| `rls_enabled.test.sql` | "kuralı tanımsız koleksiyon yok" Go testi | P3.2 |
| pgTAP testleri | `go test` (`tests.NewTestApp`, `tests.ApiScenario`) | P3–P6 |
| Auth e-posta OTP | users auth koleksiyonu, OTP 6 hane / 600 sn + ilk istekte kullanıcı açan route | P4.1 |
| `otp.html` (9 dil) | Go şablonu, kullanıcının `locale` alanına göre | P4.1 |
| Supabase Auth SMTP | PocketBase mailer, açılışta ortam değişkeninden | P4.2 |
| Demo hesabın parola girişi | Parola girişi açık, hook yalnız demo adrese izin verir | P4.1 |
| Oturum süresiz + refresh | 90 günlük token + açılışta `authRefresh` (K-6) | P4.2, P7.2 |
| `auth.users` silinince üyelik yumuşak silinir | users silme hook'u | P5.9 |
| Edge `weather-bundle` + `weather_cache` + `weather_locations` | `POST /api/app/weather` + `weather_cache` koleksiyonu (kural null) | P5.5 |
| Edge `invite` | `POST /api/app/team/{action}` | P5.4 |
| Edge `device-token` | `POST /api/app/device-token` | P5.6 |
| Edge `notify` + `notify_task_assigned` (pg_net) | Görev kaydı hook'u → FCM gönderici (Go, RS256) | P5.6 |
| pg_cron `notify-support-periods` | Uygulama cron'u `0 6 * * *` | P5.6 |
| Edge `feedback-mail` + `notify_feedback_mail` | feedback kaydı hook'u → SMTP (feedback kutusu) | P5.7 |
| Edge `account-delete` (kod, talep, iptal, durum) | `POST /api/app/account-deletion/{action}` | P5.8 |
| pg_cron `account-deletion-purge` | Uygulama cron'u `17 * * * *` | P5.9 |
| `private.deletion_log` (3 yıl, değiştirilemez) | `deletion_log` koleksiyonu, kural null, güncelleme/silme hook'u 3 yıl dolmadan reddeder | P2.7, P5.9 |
| `private.deletion_codes` | `deletion_codes` koleksiyonu, kural null | P2.7, P5.8 |
| Edge `lot-page` + `lot_public_page` + `public-lots` bucket | `GET /l/{id}`, `GET /l/{id}/report` + `public_lot_files` | P5.10 |
| Vault + Edge secret'lar | Coolify ortam değişkenleri (K-10) | P1.3 |
| Storage `media`, `documents`, `receipts`, `feedback`, `org-logos` | `media_files`, `document_files`, `receipt_files`, `feedback_files`, `org_logo_files` (K-13) | P6.1 |
| Storage `knowledge` + `publish_knowledge.dart` | `knowledge_packs` koleksiyonu + uyarlanmış araç | P6.2 |
| Storage `map-packs` | Yok (kaldırılmıştı) | — |
| `supabase/admin/ref_support_periods.sql` | Go migration'ı + superuser ile çalışan tohum aracı | P2.6, P8.1 |
| `supabase/admin/demo_account.sql` | `arici seed demo` komutu | P8.1 |
| `supabase db push` + MCP doğrulaması | Coolify deploy (migration'lar açılışta uygulanır) + `/api/health` + şema dökümü | P1.3, P2.8 |
| Supabase yedekleri | PocketBase yerleşik yedeği + Mac'e kopya (K-15) | P1.4 |
| `supabase_flutter` | `pocketbase` Dart SDK 0.25.3 (sürüm P7.2'de pub.dev'den doğrulanıp sabitlenir) | P7.2 |
| `SecureSessionStorage` | `AsyncAuthStore` + `flutter_secure_storage` | P7.2 |
| `schema_mirror_test.dart` (migration SQL'ini okur) | `server/schema/collections.json` dökümünü okur | P2.8 |
| İki cihaz testleri (yerel Supabase) | Yerel PocketBase'e karşı | P9.1 |
| `tool/store_screenshots.py` (yerel Supabase) | Yerel PocketBase + `arici seed demo` | P11.2 |
| Gizlilik politikası "Supabase AB" | "Türkiye, Hosting.com.tr" | P7.6 |
| Supabase projesi | 14 gün salt okunur gözlem, sonra duraklatma | P10.1, P11.3 |

## Ortak bilgiler

**Klasör yapısı (hedef):**

```text
server/
  Dockerfile              # çok aşamalı; Go derleme + küçük çalışma imajı
  go.mod, go.sum          # pocketbase v0.40.6 sabit
  main.go                 # app, migratecmd, route ve hook kaydı
  migrations/             # Go şema migration'ları (K-3)
  schema/collections.json # şema dökümü (P2.8, testle üretilir)
  internal/
    authz/                # is_member, has_role (P3.1)
    sync/                 # push, pull, seq (P5.1–P5.3)
    validate/             # alan ve iş kuralı doğrulaması
    auth/                 # OTP, e-posta şablonları (P4)
    mail/                 # SMTP gönderici
    fcm/                  # FCM HTTP v1 (P5.6)
    weather/              # WeatherAPI (P5.5)
    deletion/             # hesap silme (P5.8–P5.9)
    lotpage/              # lot sayfası (P5.10)
    files/                # dosya koleksiyonları (P6)
    seed/                 # demo tohumu (P8.1)
  ops/                    # yedek indirme, yük testi, runbook'lar
```

**Yerel çalıştırma:** `cd server && go run . serve --http 127.0.0.1:8090`. Testler: `cd server && go test ./...`. Android emülatöründen adres `http://10.0.2.2:8090`, iOS simülatöründen `http://127.0.0.1:8090`; uygulamaya `--dart-define=PB_URL=...` ile verilir.

**Ortam değişkenleri (adlar; değerler yalnız Coolify'da):**

| Ad | Açıklama |
| --- | --- |
| `APP_ENV` | `dev` ya da `prod` |
| `APP_URL` | Kendi kök adresi (`https://arici-api…`) |
| `PB_ENCRYPTION_KEY` | 32 karakter; ayarları şifreler |
| `GOMEMLIMIT` | dev `320MiB`, prod `448MiB` |
| `SMTP_HOST`, `SMTP_PORT` | `smtp.hostinger.com`, `465` |
| `MAIL_NOREPLY_USER`, `MAIL_NOREPLY_PASS` | noreply@tutunsoft.com (OTP, hesap silme) |
| `MAIL_FEEDBACK_USER`, `MAIL_FEEDBACK_PASS`, `FEEDBACK_TO_EMAIL` | Görüş e-postası |
| `WEATHERAPI_KEY`, `WEATHERAPI_DAYS` | Hava durumu |
| `FCM_SERVICE_ACCOUNT_B64` | Firebase servis hesabı JSON'u, base64 |
| `BACKUPS_CRON`, `BACKUPS_MAX_KEEP` | `0 3 * * *`, `7` |
| `BACKUPS_S3_ENDPOINT`, `…_BUCKET`, `…_REGION`, `…_ACCESS_KEY`, `…_SECRET` | Boşsa S3 kapalı (K-15) |
| `TRUSTED_PROXY_HEADERS` | `X-Forwarded-For` (gerçek istemci IP'si) |

Bir değişken eksikse ilgili özellik açılışta loglanır ve kapalı kalır (hava 503, e-posta 503 gibi); sunucu yine açılır.

**Sorumluluk ayrımı:** "Claude yapar" bölümleri bu repoda kod, test ve betik yazmaktır. "Sen yaparsın" bölümleri DNS paneli, Coolify paneli, VPS'e SSH, superuser oluşturma ve gizli değer girişidir. Claude hiçbir gizli değeri istemez; gerekirse "değişkeni girdin mi?" diye sorar.

---

## P0 Hazırlık

### P0.1 Geçiş dalı, karar kaydı, CLAUDE.md notu

**Amaç.** Geçiş ayrı bir dalda yürüsün, kararlar repoda dursun, sonraki oturumlar bu dosyayı okusun.

**Ön koşul.** Bu doküman yazılmış ve çalışma ağacı temiz (doküman dışında).

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P0.1 (docs/pocketbase-gecis.md):
1. `main`'den `pocketbase-gecis` dalını aç; geçişin bütün commit'leri bu dala gider.
2. docs/pocketbase-gecis.md'yi bu dala commit et (henüz edilmediyse).
3. CLAUDE.md'nin en üstüne, "Teknoloji yığını"ndan önce kısa bir "Geçiş sürüyor" notu ekle: backend Supabase'den PocketBase'e taşınıyor, plan ve kararlar docs/pocketbase-gecis.md'de; geçiş bitene kadar yeni Supabase migration'ı yalnız bu planın söylediği yerde yazılır; yeni sunucu kodu `server/` altında Go'dur. CLAUDE.md'nin geri kalanına dokunma (P11.2'de yeniden yazılacak).
4. docs/progress.md'de "Tamamlanan adımlar"ın sonuna bugünün tarihiyle "PocketBase geçişi başladı" girdisi ekle: kararların K-1…K-18 olarak dokümanda olduğunu, Supabase'in açık kaldığını yaz.
Kod yazma.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** `pocketbase-gecis` dalı var; CLAUDE.md notu ve progress girdisi commit'te; kontrol listesinde P0.1 ☑.

**Doğrulama.** `git branch --show-current` → `pocketbase-gecis`; `git log -1 --stat`.

**Ters giderse.** `git checkout main && git branch -D pocketbase-gecis`; main'e dokunulmadığı için başka bir şey gerekmez.

### P0.2 Supabase'in tam yedeği

**Amaç.** Supabase'in şeması, verisi ve dosyaları repo dışında, geri yüklenebilir biçimde saklansın. Analitik olaylar burada arşivlenir (K-12).

**Ön koşul.** P0.1. Supabase CLI kurulu ve proje bağlı (`supabase link` yapılmış). Veritabanı parolası sende.

**Claude yapar.** `tool/backup_supabase.sh` betiği: hedef klasörü argüman alır (repo içi hedefi reddeder); `supabase db dump --linked` ile `schema.sql`, `--data-only` ile `data.sql`, `--role-only` ile `roles.sql`; Storage nesnelerini Storage REST API ile indirir (`SUPABASE_URL` ve `SUPABASE_SERVICE_ROLE_KEY` kabuktan okunur, betikte ve çıktıda görünmez); sonunda tablo başına satır sayısı ve dosya listesiyle `manifest.txt` yazar; SHA-256 özetleri `SHA256SUMS`'a.

**Sen yaparsın.** Betiği kendi terminalinde, ortam değişkenlerini kendin vererek çalıştırırsın: `SUPABASE_URL=… SUPABASE_SERVICE_ROLE_KEY=… tool/backup_supabase.sh ~/Yedekler/mobil-arici/supabase-2026-11-XX`. Klasörü harici diske de kopyalarsın.

> **Not (2026-11-09, betik yazılınca teyit).** Komut bu haliyle doğru; repo kökünden çalıştırılır. `SUPABASE_URL` tam olarak `https://jcddnelaboueazhordfz.supabase.co` olmalı (bağlı projeyle uyuşmazsa betik durur); hedef klasör yoksa açılır, varsa boş olmalı. Veritabanı parolası gerekmez: CLI 2.117 `db dump` ve `db query --linked` için Management API üzerinden geçici bir giriş rolü açıyor (`supabase login` yeterli). Docker (ya da Colima, `DOCKER_HOST` ile) açık olmalı, çünkü `db dump` pg_dump'ı konteynerde çalıştırır. Her dökümde görülen `could not translate host name "db.….supabase.co"` hatası ve "IPv6 desteklenmiyor… IPv4 pooler'la yeniden deneniyor" uyarısı zararsızdır: doğrudan bağlantı yalnız IPv6, CLI pooler'a geçip dökümü tamamlar. Storage'da yeni gizli anahtar (`sb_secret_…`) yalnız `apikey` başlığında, eski `service_role` JWT'si iki başlıkta da gider; istek reddedilirse betik HTTP yanıtını (anahtarsız) yazıp durur. `data.sql` `--column-inserts --rows-per-insert 100000` ile yazılır; `grep -c INSERT` satır değil tablo başına deyim sayar, satır sayıları `manifest.txt`'tedir. Anahtarı geçmişe yazdırmamak için komutun başına boşluk koyabilir (zsh `HIST_IGNORE_SPACE`) ya da `read -rs SUPABASE_SERVICE_ROLE_KEY && export SUPABASE_SERVICE_ROLE_KEY` kullanabilirsin.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P0.2: tool/backup_supabase.sh betiğini docs/pocketbase-gecis.md'deki "Claude yapar" maddesine göre yaz. Kurallar: bash, `set -euo pipefail`; gizli değerler yalnız ortam değişkeninden okunur, hiçbir yere yazılmaz ve loglanmaz (`set -x` yok); hedef klasör repo içindeyse ya da boş değilse betik durur; Storage indirmesi bucket listesini API'den alır (media, documents, receipts, feedback, org-logos, knowledge, public-lots), sayfalı listeler, her dosyayı yoluyla aynı klasör yapısında yazar; manifest'te her tablo için `select count(*)` sonucu ve bucket başına dosya sayısı ve toplam bayt bulunur. Betiği çalıştırma; gizli değer isteme. `shellcheck` kuruluysa çalıştır. docs/pocketbase-gecis.md'de P0.2'ye "Sen yaparsın" komutunu teyit eden kısa bir not ekle. Kullanıcı betiği çalıştırıp manifest'i paylaşınca progress'e sayıları yaz (paylaşmazsa "kullanıcı çalıştıracak" yaz).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Betik repoda; sen çalıştırdın; `manifest.txt`'teki sayılar canlıdakiyle (4 kullanıcı, 3 işletme, 47 kovan, 7 dosya) uyuşuyor; yedek iki yerde (Mac + harici disk).

**Doğrulama.** `shasum -a 256 -c SHA256SUMS` (yedek klasöründe); `grep -c "INSERT\|COPY" data.sql`; isteğe bağlı: boş bir yerel Supabase'e `psql -f roles.sql -f schema.sql -f data.sql` ile yükleyip sayım.

**Ters giderse.** Betik yalnız okur; Supabase'de hiçbir şey değişmez. Yarım yedek klasörü silinip yeniden çalıştırılır.

---

## P1 Sunucu

### P1.1 DNS A kayıtları

**Amaç.** İki alt alan adı VPS'e çözülsün (K-8).

**Ön koşul.** P0.1. VPS'in genel IPv4 adresi.

**Sen yaparsın.** tutunsoft.com'un DNS'inin yönetildiği panelde:

| Tür | Ad | Değer | TTL |
| --- | --- | --- | --- |
| A | `arici-api` | VPS IPv4 | 300 |
| A | `arici-api-dev` | VPS IPv4 | 300 |

VPS'in IPv6'sı varsa ve Coolify proxy'si IPv6'yı dinliyorsa AAAA kayıtları da eklenir; emin değilsen ekleme (yanlış AAAA, Let's Encrypt doğrulamasını bozar).

**Claude yapar.** Bu adımda kod yok. Prompt yalnız doğrulamayı yapar ve progress'e yazar.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P1.1: Kullanıcı DNS'te arici-api.tutunsoft.com ve arici-api-dev.tutunsoft.com için A kaydı ekledi. `dig +short A arici-api.tutunsoft.com`, `dig +short A arici-api-dev.tutunsoft.com`, `dig +short AAAA` (ikisi için) ve `dig @1.1.1.1` ile doğrula; iki adın aynı IPv4'e çözüldüğünü ve beklenmeyen AAAA olmadığını raporla. IP'yi kullanıcıya sorup karşılaştır. Kod yazma. Sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** İki ad da genel çözücülerde VPS IP'sine çözülüyor.

**Doğrulama.** `dig +short A arici-api.tutunsoft.com @1.1.1.1`; `dig +short A arici-api-dev.tutunsoft.com @8.8.8.8`.

**Ters giderse.** Kayıtlar silinir; başka hiçbir şey bunlara bağlı değil.

### P1.2 `server/` iskeleti: Go + PocketBase + Dockerfile

**Amaç.** Coolify'ın derleyeceği, sürümü sabit, sağlık denetimi olan, migration altyapısı hazır ama şeması boş bir PocketBase ikilisi.

**Ön koşul.** P0.1. Mac'te Go kurulu (sürüm bu adımda belirlenir).

**Claude yapar.** `server/` iskeleti; `go.mod`'da `github.com/pocketbase/pocketbase v0.40.6`; Go sürümü PocketBase'in kendi `go.mod`'undaki `go` satırından alınır; Dockerfile çok aşamalı: `golang:<o sürüm>-alpine` (digest ile sabit) içinde `CGO_ENABLED=0` derleme, çalışma imajı `alpine:<sabit sürüm>` (digest ile) + `ca-certificates` + `tzdata`, kullanıcı root değil, `EXPOSE 8090`, `VOLUME /pb/pb_data`, `HEALTHCHECK` `/api/health`'e, komut `serve --http 0.0.0.0:8090 --dir /pb/pb_data --encryptionEnv PB_ENCRYPTION_KEY`. `main.go`: `migratecmd` (`Automigrate: false`), ortam değişkeni okuyucu (`internal/config`), `APP_ENV`'i loglayan açılış; `server/README.md`; `go test ./...` iskelet testi (uygulama açılır, `/api/health` 200). `.dockerignore`. `server/ops/coolify.md`: P1.3'te kullanılacak panel ayarları listesi.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P1.2: docs/pocketbase-gecis.md'deki "Ortak bilgiler"e ve K-1, K-2, K-3, K-9, K-10'a göre server/ iskeletini kur.
- Önce doğrula, hafızana güvenme: PocketBase v0.40.6'nın GitHub'daki go.mod'unu oku, `go` satırını al; Docker Hub'da o Go sürümünün alpine imajının ve güncel alpine sürümünün varlığını ve digest'ini kontrol et. Mac'teki `go version` uyumsuzsa kullanıcıya hangi sürümü kuracağını söyle ve dur.
- `go mod init` modül adı `github.com/abdullahtutun/mobil-aricilik/server`. pocketbase v0.40.6 tam sürüm, go.sum commit'e girer.
- main.go: pocketbase.New(); migratecmd.MustRegister(..., Automigrate: false, Dir: "migrations"); `internal/config` ortam değişkenlerini okur, eksikleri adıyla (değersiz) loglar; tek route `GET /api/app/info` → `{env: APP_ENV, version: <git commit, derlemede -ldflags ile>}` (oturumsuz; gizli değer içermez; araçlar dev/prod ayrımını buradan yapar).
- Dockerfile ve .dockerignore yukarıdaki maddeye göre; imajlar etiket + digest ile sabit.
- server/README.md: yerel çalıştırma, test, Docker ile yerel deneme (`docker build -t arici-pb server && docker run -p 8090:8090 -v arici-data:/pb/pb_data arici-pb`).
- server/ops/coolify.md: Coolify'da iki kaynak için tam ayar listesi (K-9): GitHub App kaynağı, dal pocketbase-gecis, build pack Dockerfile, Base Directory /server, Watch Paths server/**, port 8090, kalıcı volume /pb/pb_data, alan adı, ortam değişkeni adları (değersiz), bellek sınırı (dev 384 MB, prod 512 MB), health check yolu, dev otomatik deploy açık, prod kapalı.
- Test: tests.NewTestApp ile /api/health 200 ve /api/app/info'nun env'i döndürmesi.
Docker derlemesini yerelde dene (Colima açıksa; değilse kullanıcıya hangi komutla açacağını söyle) ve imaj boyutunu raporla.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** `go test ./...` geçiyor; `docker build` başarılı; konteyner açılınca `/api/health` 200; imajlar digest ile sabit; `server/ops/coolify.md` var.

**Doğrulama.** `cd server && go test ./...`; `docker build -t arici-pb server && docker run --rm -d -p 8090:8090 --name pbtest arici-pb && sleep 3 && curl -fsS localhost:8090/api/health; docker rm -f pbtest`.

**Ters giderse.** `server/` klasörü yalnız bu dalda; commit geri alınır (`git revert`). Uygulama etkilenmez.

### P1.3 Coolify'da dev ve prod servisleri

**Amaç.** İki PocketBase servisi HTTPS ile ayakta, kalıcı volume'lü, ortam değişkenleri girilmiş, RAM sınırlı.

**Ön koşul.** P1.1 (DNS çözülüyor), P1.2 (Dockerfile dalda ve push edilmiş).

**Sen yaparsın** (`server/ops/coolify.md`'yi izleyerek, panel.tutunsoft.com'da):

1. SSH ile VPS'e bağlan, mevcut durumu not et: `free -m`, `df -h`, `docker stats --no-stream`. Çıktıyı Claude'a ver (gizli değer içermez).
2. Yeni proje "Mobil Arıcı", iki ortam (dev, prod). Her birinde Application → GitHub App → `abdullahtutun/mobil-aricilik`, dal `pocketbase-gecis`, Build Pack Dockerfile, Base Directory `/server`, Watch Paths `server/**`.
3. Domains: dev `https://arici-api-dev.tutunsoft.com`, prod `https://arici-api.tutunsoft.com`. Port 8090.
4. Persistent Storage: volume → `/pb/pb_data` (her kaynağın ayrı volume'ü).
5. Environment Variables: tablodaki adlar. Bu adımda yalnız `APP_ENV`, `APP_URL`, `PB_ENCRYPTION_KEY` (her ortamda ayrı; `openssl rand -hex 16` ile 32 karakter), `GOMEMLIMIT`, `TRUSTED_PROXY_HEADERS` zorunlu; diğerleri ilgili adımda. Değerleri "Build Variable" değil, yalnız runtime olarak işaretle.
6. Resource Limits: dev 384 MB, prod 512 MB bellek; CPU 1.
7. Health check: yol `/api/health`, port 8090.
8. Auto deploy: dev açık, prod kapalı. Dev'i deploy et; prod'u "Deploy" ile elle deploy et.
9. Superuser: her kaynağın Terminal sekmesinde `/pb/arici superuser upsert <e-posta> <güçlü parola>` (ikili adı P1.2'deki Dockerfile'da ne ise o). Parolayı parola yöneticisine kaydet; Claude'a verme.
10. Panelde Settings → Application → "Superuser IP"'yi kendi IP'n ile sınırlamak isteğe bağlı (IP'n değişkense yapma).

**Claude yapar.** Kod yok; dışarıdan doğrulama ve RAM hesabının progress'e yazılması.

**RAM bütçesi (4 GB).** Coolify ve yan servisleri (Traefik, Postgres, Redis, Soketi) yaklaşık 1–1,5 GB; işletim sistemi ve önbellek 0,5 GB; PocketBase prod 512 MB sınır (`GOMEMLIMIT` 448 MiB), dev 384 MB (320 MiB); toplam ≈ 3 GB, en az 1 GB boşluk. Kullanıcının 1. adımda verdiği ölçümle bu bütçe teyit edilir; boşluk 700 MB'ın altındaysa dev sınırı 256 MB'a iner.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P1.3: Kullanıcı Coolify'da iki servisi docs/pocketbase-gecis.md P1.3'teki "Sen yaparsın" listesine göre kurdu. Kullanıcıdan `free -m`, `df -h`, `docker stats --no-stream` çıktılarını iste (gizli değer içermez) ve RAM bütçesini dokümandaki hesapla karşılaştır. Dışarıdan doğrula: `curl -sSI https://arici-api.tutunsoft.com/api/health` ve dev için aynısı (200, geçerli sertifika: `curl -vI 2>&1 | grep -i "issuer\|expire"`), `http://` isteğinin https'e yönlendiği, `/_/` panelinin açıldığı. Volume kalıcılığını doğrula: kullanıcıdan dev'i yeniden deploy etmesini iste, superuser girişinin hâlâ çalıştığını sor. Gizli değer isteme ve yazma. Sonuçları ve gözlenen RAM'i progress'e yaz; RAM boşluğu 700 MB'ın altındaysa dokümandaki dev sınırını 256 MB'a güncelle.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** İki adreste `/api/health` 200 ve geçerli Let's Encrypt sertifikası; yeniden deploy sonrası veri duruyor; superuser'lar açık; RAM boşluğu ≥ 700 MB.

**Doğrulama.** `curl -fsS https://arici-api.tutunsoft.com/api/health`; `curl -fsS https://arici-api-dev.tutunsoft.com/api/health`; VPS'te `docker stats --no-stream | grep -i arici`.

**Ters giderse.** Coolify'da kaynak durdurulur ya da silinir; volume'ler ayrı silinmedikçe kalır. DNS dışında hiçbir şey bu servislere bağlı değil; Supabase etkilenmez.

### P1.4 Günlük yedek, Mac'e kopya, geri yükleme denemesi

**Amaç.** Her gece yedek alınsın, haftada bir sunucu dışına (Mac) insin ve bir yedeğin geri yüklenebildiği kanıtlansın (K-15).

**Ön koşul.** P1.3.

**Claude yapar.** (1) `internal/config` + açılış hook'u: `BACKUPS_CRON` ve `BACKUPS_MAX_KEEP` varsa PocketBase ayarlarına yazılır; `BACKUPS_S3_*` doluysa S3 açılır, boşsa kapalı kalır; panelde elle ayar gerekmez; Go testi. (2) `server/ops/pull_backup.sh`: Mac'ten çalışır; superuser bilgisini kabuktaki ortam değişkeninden (`PB_URL`, `PB_SUPERUSER_EMAIL`, `PB_SUPERUSER_PASSWORD`) alır, `/api/backups` listesinden en yenisini indirir (`/api/backups/{key}` + dosya token'ı), `~/Yedekler/mobil-arici/pb-<env>/` altına koyar, 8 haftadan eskileri siler, SHA-256 yazar. (3) `server/ops/restore_check.sh`: indirilen zip'i geçici klasöre açar, yerelde aynı ikiliyle `serve` eder, `/api/health` ve koleksiyon sayısını raporlar, kapatır. (4) `server/ops/backup.md`: macOS'ta haftalık çalıştırma (launchd plist örneği) ve geri yükleme prosedürü (Coolify'da servis durdur → volume'deki `pb_data`'yı değiştir ya da panelden "Restore" → başlat).

**Sen yaparsın.** Coolify'da iki ortama `BACKUPS_CRON=0 3 * * *`, `BACKUPS_MAX_KEEP=7` gir, yeniden deploy et. Panelden bir kez "Initialize new backup" yap. Mac'te `pull_backup.sh`'yi kendi ortam değişkenlerinle çalıştır, sonra `restore_check.sh`'yi çalıştır. İstersen launchd görevini kur.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P1.4: docs/pocketbase-gecis.md P1.4 "Claude yapar" maddelerini uygula. Yedek ayarı yalnız ortam değişkeninden (K-10, K-15); değişken yoksa mevcut ayara dokunma. Betikler bash, `set -euo pipefail`, gizli değerleri loglamaz. PocketBase yedek API'sinin (list, download, file token) v0.40.6'daki yollarını pocketbase.io/docs ve kaynak koddan doğrula, tahmin etme. Go testleri: env doluyken ayarın yazılması, boşken dokunulmaması, S3 alanlarının yarım doluyken açılmaması. Betikleri çalıştırma; kullanıcının çalıştırıp sonucu paylaşmasını iste ve sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Panelde gece yedeği görünüyor; Mac'te en az bir dev ve bir prod yedeği; `restore_check.sh` başarılı; geri yükleme prosedürü yazılı.

**Doğrulama.** `cd server && go test ./internal/config/...`; Mac'te `ls ~/Yedekler/mobil-arici/pb-prod/`; `server/ops/restore_check.sh <zip>` çıktısında `health: ok`.

**Ters giderse.** Ortam değişkenleri silinir; yedek ayarı yerinde kalır, panelden kapatılabilir. Betikler yalnız okur.

---

## P2 Şema

Her P2 adımında ortak kalıp (P2.1'de kurulur, sonrakiler yeniden kullanır):

- Senkron koleksiyonu = `base` koleksiyon, adı Supabase tablosuyla aynı.
- `id`: K-4 deseni. `org_id`: metin, UUID deseni, zorunlu, index'li. `created_at`, `updated_at`: zorunlu metin, K-5 deseni. `deleted_at`: boş olabilir metin, K-5 deseni. `created_by`: boş olabilir metin, UUID deseni. `server_seq`: sayı, zorunlu, tam sayı.
- Index'ler: `(org_id, server_seq)`, `(server_seq)`; Supabase'deki diğer index'lerin SQLite karşılığı.
- Enum → `select` (tek değer), değerler Supabase enum'uyla birebir. Boş olabilen enum `required: false`.
- Başka kayda bağ: relation değil, UUID desenli metin (`hive_id` vb.); aynı işletme denetimi P5.3'te push'ta. Neden: yerelde ve sunucuda satırlar sırasız gelebilir ve relation alanı silinen kayda bağı reddeder.
- `jsonb` → `json` alanı (boyut sınırı Supabase CHECK'iyle aynı ya da makul).
- `date` → `YYYY-MM-DD` desenli metin. `numeric` → `number`.
- Tüm API kuralları (list, view, create, update, delete) **null** (yalnız sunucu kodu); P3.2'de doğrudan erişilen koleksiyonlar dışında böyle kalır.
- CHECK kısıtlarının alan düzeyinde ifade edilebilenleri alan seçenekleriyle (min, max, desen); ifade edilemeyenler `internal/validate` içinde, Supabase'deki CHECK adıyla eşleşen Go fonksiyonu olarak yazılır ve P5.3'te push'a bağlanır. Bu adımlarda yalnız fonksiyon ve testi yazılır.
- Her koleksiyon için Go testi: migration uygulanır, koleksiyon alanları ve index'ler beklenen listeyle karşılaştırılır, `down` migration koleksiyonu kaldırır.

### P2.1 Şema kalıbı, ortak alanlar, `server_seq` sayacı, users, organizations, memberships

**Amaç.** Bütün senkron koleksiyonlarının kullanacağı yardımcılar, numara sayacı ve kimlik/işletme koleksiyonları.

**Ön koşul.** P1.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.1: docs/pocketbase-gecis.md "P2 Şema" ortak kalıbına ve K-3, K-4, K-5, K-7'ye göre:
1. server/migrations/ altında yardımcılar (`syncedCollection(name, fields...)`: ortak alanlar + index'ler + null kurallar; UUID ve zaman desenleri tek yerde sabit).
2. `sync_meta` koleksiyonu (tek satır, `last_seq` sayı) ve `internal/sync/seq.go`: senkron koleksiyonlarına OnRecordCreate/OnRecordUpdate (model düzeyi, aynı transaction içinde çalışan hook) bağlanır; satıra `last_seq+1` yazılır, sayaç güncellenir; istemcinin gönderdiği server_seq yok sayılır. Hangi koleksiyonların senkron olduğu tek bir kayıt listesinde (`internal/sync/registry.go`; tablo adı, tür: state/event/organization/own_membership/reference, pull sırası). Bu adımda listeye yalnız organizations ve memberships girer.
3. `users` auth koleksiyonu: id K-4 (UUIDv7 otomatik), `email`, `verified`, `locale` (metin, `tr|en|de|es|pt|ru|uk|fa|hi`, varsayılan `en`). Auth ayarlarını bu adımda yapma (P4.1); yalnız alanlar.
4. `organizations` ve `memberships`: Supabase migration'larındaki son hâlleriyle (20261021200110, 20261022190700, 20261105120000 `tr_aks_hive_count`, 20261112120000 iş profili + `logo_path` + enum'lar, 20261115120000 `deletion_scheduled_for`, 20261116120000 düşen kolonlar). Supabase'de son hâli elde etmek için migration'ları sırayla oku; her alan için kaynak migration'ı yorumda yaz. memberships'te "bir kullanıcı bir işletmede tek etkin üyelik" kısmi tekil index'i (`deleted_at = ''`).
5. Go testleri: ortak alanlar, desenler (geçerli/geçersiz UUID ve zaman), sayaç: art arda yazmada artan numara, güncellemede yeni numara, iki eşzamanlı yazmada tekrar eden numara olmaması (goroutine'lerle), istemcinin verdiği server_seq'in yok sayılması.
Route ve kural yazma (P3–P5).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Üç koleksiyon + `sync_meta` migration'la kuruluyor; sayaç testleri (eşzamanlılık dahil) geçiyor; kayıt listesi var.

**Doğrulama.** `cd server && go test ./migrations/... ./internal/sync/...`; yerelde `go run . serve` → panelde koleksiyonlar (yalnız bakmak için).

**Ters giderse.** `go run . migrate down` (yerel); sunucuya henüz deploy edilse bile koleksiyonlar boş, dev servisi yeniden kurulabilir (volume silinir).

### P2.2 Koleksiyonlar: arılıklar, kovanlar, ana arılar, kovan geçmişi

**Amaç.** apiaries, queens, hives, hive_location_history, hive_status_events.

**Ön koşul.** P2.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.2: P2 ortak kalıbıyla apiaries, queens, hives, hive_location_history, hive_status_events koleksiyonlarını Go migration'ı olarak ekle. Kaynak: 20261021201714, 20261107120000 (karantina), 20261108120000 (durum olayları), 20261116120000 (düşen kolonlar) ve bu tablolara dokunan diğer migration'lar; her alanın kaynağını yorumda yaz. PostGIS `location` yerine `latitude` (−90…90) ve `longitude` (−180…180) sayı alanları; "ikisi birlikte dolu ya da boş" kuralı `internal/validate` içinde. `hives.tag_code` için `CREATE UNIQUE INDEX … WHERE tag_code != '' AND deleted_at = ''`. Enum'lar select. Kayıt listesine (registry) beş tabloyu Supabase'deki kind'larıyla (apiaries/queens/hives state, diğer ikisi event) ve lib/core/sync/sync_service.dart'taki pullTables sırasıyla ekle. CHECK'lerin Go karşılıkları + testleri. Koleksiyon testleri.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Beş koleksiyon; etiket tekilliği testi (silinmiş kovanın etiketi yeniden kullanılabilir); konum doğrulaması testi; kayıt listesi güncel.

**Doğrulama.** `cd server && go test ./...`.

**Ters giderse.** Migration'ın `down`'ı; commit `git revert`.

### P2.3 Koleksiyonlar: muayene, medya, varroa, ilaçlar, ilaçlama, besleme

**Amaç.** inspections, media, mite_counts, ref_drugs, drugs, treatments, feedings.

**Ön koşul.** P2.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.3: P2 ortak kalıbıyla inspections, media, mite_counts, ref_drugs, drugs, treatments, feedings koleksiyonlarını ekle. Kaynak: 20261024142500, 20261024190000, 20261025120000, 20261025200000, 20261025220000 (application_id, media.treatment_id), 20261031200000 ve 20261101120000 (TR ilaç listesi), 20261026120000 ve bunlara dokunan sonraki migration'lar. `inspections.data` json. `media.storage_path` deseni Supabase CHECK'iyle aynı (`org/kovan/kimlik.jpg|m4a`) — desen `internal/validate`'te, ayrıca yolun kimlik ve işletme parçasının satırla tutarlı olması kuralı. ref_drugs: org_id'siz referans koleksiyonu (ortak kalıp ama `org_id` yok; kind `reference`); Supabase'deki seed verisi bir Go veri migration'ı ile aynı kimliklerle eklenir (SQL'deki değerleri birebir aktar, satır sayısını testte sabitle). Kayıt listesine kind'larıyla ekle (drugs state, diğerleri event, ref_drugs reference). Testler.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Yedi koleksiyon; ref_drugs satır sayısı Supabase'dekiyle aynı (P0.2 manifest'i ya da migration SQL'i ile karşılaştırılır).

**Doğrulama.** `cd server && go test ./...`; `grep -c` ile migration SQL'indeki ilaç satırı sayısı = test sabiti.

**Ters giderse.** `down`; `git revert`.

### P2.4 Koleksiyonlar: görev, hasat, belge, göç, taşıma

**Amaç.** tasks, harvests, harvest_hives, documents, migrations, migration_stops, transports, transport_items.

**Ön koşul.** P2.3.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.4: P2 ortak kalıbıyla tasks, harvests, harvest_hives, documents, migrations, migration_stops, transports, transport_items koleksiyonlarını ekle. Kaynak: 20261026180000, 20261101200000 (planlı ilaçlama alanları), 20261105120000 (task_source aks_update), 20261026235000, 20261027180000, 20261028120000, 20261031120000 ve sonrakiler. `tasks.assigned_to` UUID desenli metin (kullanıcı silinince boşaltılır, P5.9). `documents.expires_on` gün metni; `storage_path` deseni. Kayıt listesine Supabase kind'larıyla ekle. Testler.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Sekiz koleksiyon ve testleri.

**Doğrulama.** `cd server && go test ./...`.

**Ters giderse.** `down`; `git revert`.

### P2.5 Koleksiyonlar: stok, ana yetiştirme, lotlar ve analiz

**Amaç.** inventory_items, inventory_moves, queen_rearing_batches, mating_nucs, lots, lot_harvests, lot_treatments, lab_results, lot_sales.

**Ön koşul.** P2.4.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.5: P2 ortak kalıbıyla inventory_items, inventory_moves, queen_rearing_batches, mating_nucs, lots, lot_harvests, lot_treatments, lab_results, lot_sales koleksiyonlarını ekle. Kaynak: 20261101180000, 20261101230000, 20261102120000, 20261102180000 (yayım alanları) ve sonrakiler. lot_harvests'te "bir hasat en çok bir lotta" kuralı (silinmemişler arasında tekil index). lab_results'ta "en az bir değer dolu" kuralı `internal/validate`'te. Kayıt listesine Supabase kind'larıyla ekle. Testler.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Dokuz koleksiyon ve testleri.

**Doğrulama.** `cd server && go test ./...`.

**Ters giderse.** `down`; `git revert`.

### P2.6 Koleksiyonlar: finans, müşteri, destek dönemleri; referans verinin taşınması

**Amaç.** transactions, customers, customer_payments, ref_support_periods ve destek dönemi verisi.

**Ön koşul.** P2.5.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.6: P2 ortak kalıbıyla transactions, customers, customer_payments ve ref_support_periods (org_id'siz, kind reference) koleksiyonlarını ekle. Kaynak: 20261103120000, 20261104120000, 20261105120000, 20261117120000 (tutar ≤ 10¹², 2 ondalık). Tutar kuralı `internal/validate`'te (sayı, > 0, ≤ 1e12, en çok 2 ondalık); float64 hassasiyetinin 1e12'de 2 ondalığı taşıdığını test et. `check_customer_payment` trigger'ının kuralını Go fonksiyonu olarak yaz (P5.3'te bağlanacak). Destek dönemleri: supabase/admin/ref_support_periods.sql'deki satırları aynı kimliklerle Go veri migration'ına aktar; canlıdaki güncel hâli için kullanıcıdan P0.2 yedeğindeki data.sql'de `ref_support_periods` satırlarını paylaşmasını iste, migration'ı ona göre yaz (paylaşmazsa admin SQL'indeki hâl). Kayıt listesine ekle. Testler.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Dört koleksiyon; kayıt listesinde 35 senkron tablosunun hepsi var (test: liste = `pullTables` sırasıyla aynı 35 ad).

**Doğrulama.** `cd server && go test ./...`; testte kayıt listesinin `lib/core/sync/sync_service.dart` pullTables ile ad ad karşılaştırılması.

**Ters giderse.** `down`; `git revert`.

### P2.7 Senkronlanmayan koleksiyonlar

**Amaç.** invites, device_tokens, feedback, analytics_events, weather_cache, deletion_requests, deletion_log, deletion_codes, support_period_notifications.

**Ön koşul.** P2.6.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.7: server_seq'siz şu koleksiyonları Go migration'ı ile ekle (id K-4, zamanlar K-5, kurallar null; P3.2 gerekenleri açacak): invites (20261027140000; kod tüm işletmelerde tekil, 0/O/1/I/L'siz alfabe deseni, expires_at, used_at, used_by), device_tokens (20261027160000; user_id, token tekil, platform, locale), feedback (20261027120000; tür select, mesaj 1–4000, screenshot_path deseni, cihaz json), analytics_events (kimliksiz; kurulum kimliği, ad, sayısal props json, sürüm, platform), weather_cache (hücre anahtarı tekil, json yük, fetched_at), deletion_requests (20261113120000, 20261114120000, 20261115120000; tür, kanal, durum enum'ları aynı değerlerle — `hesap`, `hesap_ve_isletme`, `uygulama`, `web`, `bekliyor`, `iptal`, `tamamlandi` —, scheduled_for, storage önekleri json), deletion_log (tarih, tür, kanal, user_hash; created alanı), deletion_codes (kullanıcı, kod özeti, deneme sayısı, kilit, gönderim zamanları), support_period_notifications (dönem kimliği tekil). deletion_log için hook: kayıt güncellenemez; created'tan itibaren 3 yıl dolmadan silinemez (Supabase protect_deletion_log ile aynı) — superuser dahil; testle kanıtla. Testler.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Dokuz koleksiyon; deletion_log koruma testi (güncelleme reddi, 3 yıl dolmadan silme reddi, dolunca silinebilir).

**Doğrulama.** `cd server && go test ./...`.

**Ters giderse.** `down`; `git revert`.

### P2.8 Şema dökümü ve Flutter `schema_mirror_test` uyarlaması

**Amaç.** Panelden elle değişiklik ve Drift aynası eksiği testle yakalansın (K-3).

**Ön koşul.** P2.7.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P2.8:
1. server/: `go run . schema dump` alt komutu (cobra) migration'ları uygulanmış uygulamanın koleksiyonlarını (ad, alanlar, tür, zorunluluk, select değerleri, desen, index'ler, kurallar) kararlı sırayla server/schema/collections.json'a yazar. Go testi: dökümü yeniden üretip repodakiyle karşılaştırır; fark varsa "go run . schema dump çalıştır" mesajıyla kırılır.
2. Canlı sapma denetimi: `GET /api/app/schema-hash` (yalnız superuser) dökümün SHA-256'sını döner; server/ops/schema_check.sh bunu repodaki dökümün özetiyle karşılaştırır (superuser bilgisi kabuktan).
3. Flutter: test/…/schema_mirror_test.dart şu an supabase/migrations SQL'ini okuyor. Ona ikinci bir kaynak ekle: server/schema/collections.json; her senkron koleksiyonunun alanları Drift tablosunda, select değerleri Dart enum'larında olmalı. SQL kaynağı P11.1'e kadar kalır; iki kaynak da geçmeli. Supabase'e özgü dönüşümler (location ↔ latitude/longitude) için mevcut istisnalar PocketBase tarafında gerekmez.
4. Supabase'deki `rls_enabled.test.sql` + `sync_seq.test.sql` karşılığı: Go testi, kayıt listesindeki her koleksiyonda server_seq alanı ve seq hook'u olduğunu, listede olmayan hiçbir koleksiyonda server_seq olmadığını denetler.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** `collections.json` repoda; dökümü bozan bir değişiklik Go testini kırıyor (denendi); Flutter `schema_mirror_test` iki kaynakla geçiyor; dev deploy sonrası `schema_check.sh` eşit.

**Doğrulama.** `cd server && go test ./... && go run . schema dump && git diff --exit-code server/schema/`; `flutter test test/core/db/schema_mirror_test.dart` (dosyanın gerçek yolu); `server/ops/schema_check.sh https://arici-api-dev.tutunsoft.com`.

**Ters giderse.** `git revert`; Flutter testi yalnız eklenen kaynağı okuduğu için geri almak yeterli.

---

## P3 Yetki

### P3.1 Yetki katmanı (`authz`) ve politika testleri

**Amaç.** Supabase'deki her RLS politikasının Go karşılığı tek bir pakette ve testli olsun. Senkron route'ları (P5) ve özel route'lar yetkiyi yalnız bu paketten sorar.

**Ön koşul.** P2.8.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P3.1: server/internal/authz paketini yaz.
- `IsMember(app, userID, orgID)` ve `HasRole(app, userID, orgID, roles...)`: memberships'te deleted_at boş satır; private.is_member/has_role ile aynı anlam.
- `Policy` tablosu: kayıt listesindeki her tablo için okuma, ekleme ve güncelleme rolleri. Supabase migration'larındaki `create policy` satırlarını tek tek oku ve tabloya aktar; özellikle: finans (transactions, customers, customer_payments) yalnız owner+partner; organizations güncelleme owner+partner (20261112120000 sonrası); memberships okuma: üyeler + kullanıcının kendi (çıkarılmış dahil) satırı; ref_* girişli herkes okur, kimse yazmaz; hive_status_events owner/partner/worker. Hiçbir tabloda silme yok (silme = deleted_at güncellemesi).
- `OrgIDsForUser(app, userID)` (pull süzgeci için) ve `CanSeeRow(table, row, userID)`.
- Testler: supabase/tests/database/*_rls.test.sql dosyalarındaki her senaryoyu Go'ya taşı (başka işletme göremez/yazamaz, worker yazar, viewer yazamaz, finansı worker göremez, çıkarılan üye erişimini kaybeder, çıkarılan kullanıcı kendi üyeliğini görür). Her test adında karşılık geldiği pgTAP dosyasını yaz. Bir tablo için politika tanımı yoksa test kırılsın (kayıt listesi ↔ Policy eşleşmesi).
Route yazma.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Her senkron tablosu için politika; taşınan pgTAP senaryolarının listesi progress'te; politika eksik tablo testi kırıyor.

**Doğrulama.** `cd server && go test ./internal/authz/... -v | grep -c PASS`.

**Ters giderse.** `git revert`; henüz kullanan route yok.

### P3.2 API kuralları ve "kuralsız koleksiyon yok" testi

**Amaç.** İstemcinin PocketBase kayıt API'siyle doğrudan eriştiği koleksiyonların kuralları, gerisinin kapalı olduğunun kanıtı.

**Ön koşul.** P3.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P3.2: Go migration'ı ile API kurallarını ayarla.
- Doğrudan erişilen ve kuralı açılanlar: users (list/view: yalnız kendisi `id = @request.auth.id`; create/update/delete: null — kullanıcıyı OTP route'u açar, locale güncellemesi P4.1'deki route ile), feedback (create: `@request.auth.id != ""` + gönderilen org_id'de etkin üyelik — `@collection.memberships` ile, alias kullanarak aynı satırda user_id, org_id ve deleted_at koşulu; list/view/update/delete null), analytics_events (create: `@request.auth.id != ""`; diğerleri null), deletion_requests (list/view: `user_id = @request.auth.id`; diğerleri null), device_tokens (list/view: kendi; yazma null, route ile).
- Dosya koleksiyonlarının kuralları P6.1'de.
- Geri kalan her koleksiyonun beş kuralı null kalır.
- Test (rls_enabled karşılığı): tüm koleksiyonları dolaşır; beklenen açık kural listesi dışında null olmayan kural varsa ya da `""` (herkese açık) kural varsa kırılır.
- tests.ApiScenario ile: başka kullanıcının users kaydı görünmez; üye olmadığı işletme adına feedback eklenemez; anon analytics ekleyemez; silme talebi yalnız sahibine görünür; senkron koleksiyonlarına kayıt API'si 403/404.
- Rate limiter: PocketBase'in yerleşik hız sınırlayıcısını ortam değişkeni ya da açılış hook'u ile aç (kural: `/api/` genel, OTP isteği ve davet kodu için sıkı). Değerleri ve doğrulamasını v0.40.6 kaynak/dokümanından kontrol et.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Kural testi geçiyor; bir koleksiyonun kuralını `""` yapınca test kırılıyor (denendi); senaryolar geçiyor.

**Doğrulama.** `cd server && go test ./...`; dev deploy sonrası `curl -s https://arici-api-dev.tutunsoft.com/api/collections/hives/records` → 403/404.

**Ters giderse.** Kuralları null'a döndüren migration; `git revert`.

---

## P4 Auth

### P4.1 OTP girişi: ilk istekte kullanıcı açma, 9 dilli e-posta, demo hesap

**Amaç.** Supabase'deki "e-postayı yaz → 6 haneli kod → gir" akışı aynen; yeni kullanıcı ilk istekte açılır; e-posta kullanıcının dilinde.

**Ön koşul.** P3.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P4.1: Önce pocketbase.io/docs (authentication, api-records auth bölümü, Go "sending emails" ve "event hooks") ve v0.40.6 kaynağından OTP akışını, `OnMailerRecordOTPSend` (ya da v0.40.6'daki karşılığı) hook'unu ve otp ayarlarını doğrula.
1. users auth ayarları (Go migration): OTP açık, uzunluk 6, süre 600 sn; parola girişi açık (yalnız demo için, aşağıda); OAuth2 kapalı; token süresi 90 gün (K-6).
2. `POST /api/app/auth/otp` route'u {email, locale}: e-postayı normalleştirir ve doğrular; kullanıcı yoksa rastgele 32+ karakterli parola ve locale ile açar (verified false); varsa locale'e dokunmaz (Supabase'de de ilk kayıttaki dil kalıyordu; dil değişimi 3. maddede); aynı e-postaya 60 sn'den sık kod göndermez (429 `too_many_requests`); PocketBase'in OTP üretimini kullanıp `{otpId}` döner. Kullanıcı numaralandırmasına izin vermez (hata metinleri aynı).
3. `POST /api/app/auth/locale` {locale}: oturumlu kullanıcının locale alanını günceller.
4. OTP e-postası: supabase/templates/otp.html'deki dokuz dilin metnini ve görünümünü Go html/template'e taşı (`internal/auth/templates/otp.html` + konu satırları); dil kullanıcının locale'inden, bilinmiyorsa İngilizce; kod dışında link yok; "10 dakika" metni süre sabitine bağlı (tek kaynaktan). supabase/functions/_shared/locale.ts'deki dil çözümüyle aynı kural.
5. Demo hesap: parola girişi hook'u yalnız `demo@tutunsoft.com` için izin verir, diğer herkese genel "kod yanlış" hatası. Parola repoda yok.
6. Testler: yeni kullanıcı açılır ve e-posta gider (test mailer), mevcut kullanıcıda locale değişmez, 60 sn sınırı, yanlış kod, süresi dolmuş kod, aynı kodun ikinci kullanımı, dokuz dilde konu satırı, locale'siz kullanıcıda İngilizce, demo dışı parola girişinin reddi, numaralandırma (var/yok aynı yanıt).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; şablon dokuz dilde üretiliyor (test çıktısı HTML'leri geçici klasöre yazılıp gözle bakılabilir).

**Doğrulama.** `cd server && go test ./internal/auth/...`; yerelde `go run . serve` + `curl -X POST localhost:8090/api/app/auth/otp -d '{"email":"a@b.c","locale":"tr"}' -H 'content-type: application/json'` → `otpId` (SMTP yokken e-posta logda).

**Ters giderse.** `git revert`; istemci henüz bağlı değil.

### P4.2 SMTP ve oturum ayarları ortam değişkeninden; canlı e-posta denemesi

**Amaç.** OTP e-postası dev sunucudan Hostinger üzerinden gerçekten gitsin; SMTP bilgisi yalnız ortam değişkeninde.

**Ön koşul.** P4.1, P1.3. Hostinger'da noreply@tutunsoft.com kutusu; SPF/DKIM/DMARC zaten tutunsoft.com için tanımlı (Supabase'de çalışıyordu).

**Claude yapar.** Açılış hook'u: `SMTP_HOST`, `SMTP_PORT`, `MAIL_NOREPLY_USER`, `MAIL_NOREPLY_PASS` doluysa PocketBase mail ayarlarına yazılır (gönderen adı "Mobil Arıcı", adres kullanıcı adı, TLS 465); eksikse e-posta özellikleri 503 döner ve açılış logu adları söyler. "User IP proxy headers" `TRUSTED_PROXY_HEADERS`'tan. Testler.

**Sen yaparsın.** Coolify dev ortamına dört SMTP değişkenini gir, deploy et. Kendi e-postana uygulama olmadan kod iste: `curl -X POST https://arici-api-dev.tutunsoft.com/api/app/auth/otp -H 'content-type: application/json' -d '{"email":"<sen>","locale":"tr"}'`; e-postanın geldiğini, spam'e düşmediğini ve başlıklarda SPF/DKIM "pass" olduğunu kontrol et.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P4.2: docs/pocketbase-gecis.md P4.2 "Claude yapar" maddesini uygula (K-10: SMTP bilgisi yalnız ortam değişkeninden, panelden girilmez; ayar her açılışta env'den yeniden yazılır, env boşsa mevcut ayar korunur ve e-posta özellikleri 503 verir). Gizli değer isteme. Testler: env dolu/boş/yarım. Kullanıcının dev'de canlı denemesinin sonucunu sor ve progress'e yaz (e-posta geldi mi, spam mi, SPF/DKIM).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Dev'den Türkçe OTP e-postası gelen kutusuna düşüyor; SPF ve DKIM pass.

**Doğrulama.** Yukarıdaki `curl`; e-postanın "Orijinali göster" başlıkları.

**Ters giderse.** Değişkenler silinir; OTP 503 döner, başka bir şey etkilenmez.

---

## P5 Sunucu mantığı

Senkron sözleşmesi (P5.1–P5.3, istemci P7.3 bunu kullanır). Biçim Supabase RPC'leriyle aynı tutulur ki istemci değişikliği taşıyıcıda kalsın.

- `POST /api/sync/push` gövde `{changes: [{id, table, operation, payload}], client_time, schema_version}` → `{results: [{status: "ok", applied} | {status: "rejected", reason, message}], server_time, warning?}`. Desteklenmeyen `schema_version` → HTTP 426 `{code: "upgrade_required"}`, hiçbir şey yazılmaz. Geçici hata (SQLite meşgul vb.) → 503, paket geri alınır.
- `GET /api/sync/pull?table=&since_seq=&page_size=` → `{rows, next_seq, has_more}`; `page_size` 1–1000; satırlar sunucu kolon adlarıyla, `server_seq` dahil; silinenler `deleted_at` dolu.
- Desteklenen şema sürümleri tek sabitte (`internal/sync/versions.go`), başlangıçta yalnız Drift'in güncel `schemaVersion`'u (26). Uygulama yayında olmadığı için eski sürümler eklenmez.

### P5.1 Senkron çekme: `/api/sync/pull`

**Amaç.** İstemci her tabloyu imleçten sayfa sayfa, yalnız görmeye yetkili olduğu satırlarla çeksin.

**Ön koşul.** P3.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.1: docs/pocketbase-gecis.md P5 "Senkron sözleşmesi"ne ve K-7'ye göre `GET /api/sync/pull`'u yaz (internal/sync/pull.go). Oturum zorunlu. Tablo kayıt listesinde değilse 400 `unsupported`. Süzgeç: authz.OrgIDsForUser + Policy okuma rolleri (finans tabloları worker/viewer'a boş gelir); memberships için kullanıcının kendi çıkarılmış satırı da; organizations için üyesi olduğu işletmeler; reference tablolar herkese. Sorgu `server_seq > since order by server_seq limit n`, `(org_id, server_seq)` index'ini kullanır (EXPLAIN ile doğrula). Geriye bakma payı yok (K-7 gerekçesi kod yorumunda). Satır JSON'u Drift'in beklediği adlarla: apiaries'te latitude/longitude zaten alan. supabase/migrations/20261023174000_sync_pull.sql'deki davranışı ve supabase/tests/database/sync_pull.test.sql senaryolarını Go testlerine taşı (sayfalama, başka işletme satırının sayfaya sayılmaması, tam dolan son sayfada has_more false, boş sayfada imlecin yerinde kalması, silinen satırın yeni seq ile gelmesi). Ek test: eşzamanlı yazma sürerken çekmede satır kaçmaması (goroutine'lerle 1000 yazma + paralel çekme, sonunda tüm kimlikler alınmış).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Taşınan senaryolar + eşzamanlılık testi geçiyor; worker finans çekemiyor.

**Doğrulama.** `cd server && go test ./internal/sync/... -run Pull -race`.

**Ters giderse.** `git revert`; istemci henüz bağlı değil.

### P5.2 Senkron gönderme çekirdeği

**Amaç.** Durum kayıtlarında son yazan kazanır, olay kayıtlarında yalnız ekleme + bir kez silme, satır başına sonuç, idempotentlik.

**Ön koşul.** P5.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.2: `POST /api/sync/push` çekirdeğini yaz (internal/sync/push.go), Supabase'deki private.sync_push_change ve public.sync_push'un son hâline (20261112120000 + 20261116120000) birebir uyarak:
- Oturum zorunlu; schema_version sözleşmedeki gibi (426). Paket en çok 100 kayıt.
- Paket tek `app.RunInTransaction` içinde; her satır kendi savepoint'inde (ya da satır önce doğrulanıp sonra yazılır) — bir satırın reddi diğerlerini etkilemez; geçici hata bütün paketi geri alır ve 503 döner.
- Doğrulama: table, operation (upsert|delete), payload nesne, id ve updated_at zorunlu (K-5 deseni); delete'te deleted_at zorunlu; tablo kayıt listesinde değilse `unsupported`.
- Yetki: authz ile; yetkisiz → `forbidden`. Başka işletmenin satırına eski updated_at ile yazma da `forbidden` (Supabase'de not exists ile düzeltilen durum — bu testi mutlaka taşı).
- state: satır yoksa ekle; varsa yalnız gelen updated_at > mevcut ise id, org_id, created_at, created_by, server_seq dışındaki alanları yaz; eşit/eski → ok, applied false.
- event: yoksa ekle; varsa yalnız deleted_at boşken dolu gelirse deleted_at ve updated_at'i yaz; diğer her şey ok, applied false.
- created_by her zaman çağıran; istemcinin değeri yok sayılır. org_id güncellemede değişmez.
- Bilinmeyen payload anahtarları yok sayılır (eski sürüm uyumu Supabase'deki jsonb_populate_record gibi); select değeri geçersizse `invalid`.
- Saat sapması: |client_time − şimdi| > 5 dk → warning {code: clock_skew, skew_seconds}.
- Ret nedenleri: forbidden, conflict (tekillik), missing_reference (P5.3'te), unsupported, invalid.
Bu adımda organizations, memberships ve tabloya özel kurallar (P5.3) yok: o tablolar geçici olarak `unsupported` döner.
Testler: supabase/tests/database/sync_push.test.sql ve inspections_sync.test.sql senaryolarını taşı (aynı paketin iki kez gelmesinde ikinci yazmanın olmaması ve server_seq'in ilerlememesi; eski/yeni updated_at; yetkisiz işletme ve paketin geri kalanının yazılması; viewer; durum ve olay silme; eski paketin silinen satırı geri getirmemesi; bozuk veri; saat sapması; anon 401). Ek: 100 kayıtlık pakette süre ölçümü (log).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Taşınan senaryolar geçiyor; idempotentlik ve "başka işletmeye eski tarihle yazma = forbidden" testi var.

**Doğrulama.** `cd server && go test ./internal/sync/... -run Push -race`.

**Ters giderse.** `git revert`.

### P5.3 Gönderme özel kuralları: işletme, üyelik, korumalar, doğrulama

**Amaç.** Supabase trigger'larının ve CHECK/FK'lerin push'taki karşılığı.

**Ön koşul.** P5.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.3: push'a tabloya özel kuralları ekle:
- organizations (kind organization): yeni işletme açılmaz (`forbidden`, mesaj "create_organization ile kurulur"); yalnız owner+partner, yalnız daha yeni updated_at; eksik alanlar sunucudaki satırdan tamamlanır (Supabase'deki existing_row || row_data).
- memberships (own_membership): upsert → ok, applied false; delete → unsupported.
- Aynı işletme referansları (bileşik FK karşılığı): her tablodaki *_id alanları için hedef satır aynı org_id'de var olmalı → yoksa `missing_reference`. Hangi alanın hangi tabloya bağlı olduğunu migration'lardaki `references` satırlarından çıkar ve tek bir tabloda topla (internal/sync/refs.go). Silinmiş hedefe bağ Supabase'deki gibi kabul edilir.
- Tekillik ihlali (hives.tag_code, lot_harvests hasat, invites kodu vb.) → `conflict`.
- `internal/validate`'teki CHECK fonksiyonlarını bağla (konum, tutar, lab sonucu, media/document yolu, alan aralıkları) → `invalid`.
- Korumalar: guard_lot_publication (owner olmayan yazmada published ve public_* alanları sunucudaki değerde tutulur, yazma reddedilmez; eski sürümün bu alanları göndermemesi durumunda da korunur), keep_hive_quarantine (20261107120000'deki kural), check_customer_payment (20261104120000'deki kural).
- Kayıt hook'ları: görev ataması bildirimi P5.6'da; burada yalnız push yazmasının model hook'larından geçtiğini (seq dahil) doğrula.
Testler: hives_consistency, lot_publish, hive_quarantine, customers_rls, treatment_groups, tasks_plan, business_profile pgTAP senaryolarını taşı; her taşınan testin adında kaynak dosya.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** 35 tablonun hepsi push'ta destekleniyor; referans tablosu migration'lardaki tüm `references`'ı kapsıyor (test: SQL'den çıkarılan liste = Go tablosu).

**Doğrulama.** `cd server && go test ./... -race`.

**Ters giderse.** `git revert`.

### P5.4 İşletme kurma ve ekip daveti route'ları

**Amaç.** `create_organization` RPC'si, istemcinin `organizations` sorgusu ve `invite` Edge Function'ının karşılıkları.

**Ön koşul.** P5.3.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.4:
1. `POST /api/app/organizations` {id, name, country_code, currency, hive_count_range, …}: 20261022190700 + 20261112120000'deki create_organization ile aynı: işletme + çağıranın owner üyeliği tek transaction'da (üyelik id'si UUIDv7), ad kırpılır, boş ad reddedilir, aynı id ile tekrar çağrı mevcut işletmeyi döner, başkasının id'si 409.
2. `GET /api/app/organizations/mine`: lib/features/organization/data/organization_service.dart'ın yaptığı sorgunun karşılığı (üye olunan en eski işletme; sırayı o dosyadaki koddan al).
3. `POST /api/app/team/{create|redeem|members|set_role|remove}`: supabase/functions/invite/index.ts ve code.ts'yi Go'ya taşı; yanıt ve hata kodları aynı (invalid_code, already_member, member_leaving 409 vb.); redeem tek transaction'da kodu "alır" ve üyelik ekler; davet 48 saat; owner rolüyle davet yok; set_role/remove yalnız owner, owner'ın kendisine dokunulmaz, silinmek üzere olan üyeye 409 member_leaving. Kod denemesine hız sınırı (kullanıcı başına dakikada 10).
Testler: create_organization.test.sql, invites_rls.test.sql, memberships_rls.test.sql senaryoları + invite fonksiyonunun davranışları.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Route'lar ve testleri; yanıt biçimleri Flutter servislerinin beklediğiyle aynı (testte örnek JSON'lar `test/` altındaki sahte HTTP yanıtlarıyla karşılaştırılır).

**Doğrulama.** `cd server && go test ./...`.

**Ters giderse.** `git revert`.

### P5.5 Hava durumu: `weather-bundle`

**Amaç.** Arılık konumlarını sunucuda okuyup WeatherAPI tahmini dönen, 1 saat önbellekli uç.

**Ön koşul.** P5.1.

**Claude yapar.** `POST /api/app/weather`; supabase/functions/weather-bundle/index.ts + weather_api.ts'nin Go'ya taşınması; konumlar `weather_locations()` karşılığı (kullanıcının görebildiği silinmemiş, konumlu arılıklar); 0,01° hücre; `weather_cache` 1 saat; aynı anda en çok 5 istek; alınamayan hücre eski önbellek ya da 502; anahtar loglanmaz; `WEATHERAPI_KEY` yoksa 503.

**Sen yaparsın.** Coolify dev'e `WEATHERAPI_KEY` ve `WEATHERAPI_DAYS` gir (değer Supabase secret'larındakiyle aynı; Supabase panelinden kopyala, kimseye yapıştırma).

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.5: docs/pocketbase-gecis.md P5.5 "Claude yapar"ı uygula. Yanıt JSON'u Edge Function'ınkiyle birebir aynı olmalı (lib/features/weather/data/weather_service.dart ve testlerindeki örnek yanıtla karşılaştır). WeatherAPI çağrısı httptest sunucusuyla test edilir: önbellekten gelme, 1 saati aşan hücrenin yenilenmesi, sağlayıcı hatasında eski önbellek, önbellek yokken 502, anahtarın logda olmaması, konumsuz arılığın atlanması, başka işletmenin arılığının gelmemesi. Gerçek anahtarla deneme yapma; kullanıcı dev'de denediğinde sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; dev'de anahtar girildikten sonra oturumlu çağrı 200 (P9.2'de uygulamayla).

**Doğrulama.** `cd server && go test ./internal/weather/...`.

**Ters giderse.** `git revert`; değişken silinirse uç 503 döner.

### P5.6 Push bildirim: FCM, cihaz token'ı, görev ataması, destek dönemi cron'u

**Amaç.** `device-token`, `notify`, `notify_task_assigned` ve pg_cron `notify-support-periods` karşılıkları.

**Ön koşul.** P5.4.

**Claude yapar.** `internal/fcm`: servis hesabı JSON'undan (base64 ortam değişkeni) RS256 imzalı JWT ile Google OAuth erişim anahtarı (önbellekli), FCM HTTP v1 gönderimi, geçersiz token'ın silinmesi. `POST /api/app/device-token` {action: register|unregister, token, platform, locale}. Görev hook'u: tasks kaydı (push ya da başka yol) eklenince ya da `assigned_to` değişince, atanan çağıran değilse bildirim — **transaction commit'inden sonra**, arka planda (yazmayı bekletmez, hata yazmayı geri almaz). Metinler supabase/functions/notify/message.ts'den, alıcının dilinde; `data.task_id`. Cron `notify-support-periods` `0 6 * * *`: başlamış, bitmemiş, bildirilmemiş dönem → TR işletmelerinin owner + partner üyelerine, bir kez (`support_period_notifications`).

**Sen yaparsın.** Firebase konsolunda yeni bir servis hesabı anahtarı üret (progress'te eskisinin sohbete yapıştırıldığı ve yenilenmesinin önerildiği yazıyor); JSON'u `base64 -i key.json | pbcopy` ile Coolify dev'e `FCM_SERVICE_ACCOUNT_B64` olarak gir; JSON dosyasını sil.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.6: docs/pocketbase-gecis.md P5.6 "Claude yapar"ı uygula. Kaynaklar: supabase/functions/notify/*, device-token/index.ts, 20261027160000, 20261105120000. Önce doğrula: v0.40.6'da uygulama cron'unun (app.Cron()) hangi saat diliminde çalıştığını kaynak koddan bul; UTC değilse ifadeyi UTC 06:00'a karşılık gelecek şekilde ayarla ve yorumda yaz. Commit sonrası çalıştırma için v0.40.6'nın uygun hook'unu (ör. *AfterCreateSuccess / AfterUpdateSuccess) kaynak koddan doğrula. Testler: JWT imzası (sahte anahtar), OAuth ve FCM için httptest; geçersiz token (404/UNREGISTERED) silinir; kendine atamada bildirim yok; dil seçimi; cron'da bir kez bildirim ve TR dışı işletmenin dışarıda kalması; FCM env yokken yazmanın etkilenmemesi. Gerçek gönderim yapma.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; cron panelde (Settings → Crons) görünüyor.

**Doğrulama.** `cd server && go test ./internal/fcm/... ./internal/...`; dev panelde cron listesi.

**Ters giderse.** `git revert`; env silinirse bildirimler sessizce kapanır.

### P5.7 Görüş e-postası

**Amaç.** Yeni feedback kaydı geldiğinde feedback@tutunsoft.com'a e-posta.

**Ön koşul.** P5.4, P4.2, P6.1.

**Claude yapar.** feedback kaydı hook'u (commit sonrası, arka planda); supabase/functions/feedback-mail/message.ts'deki konu ve gövde; gönderici `MAIL_FEEDBACK_USER/PASS` ile ayrı SMTP istemcisi (PocketBase mailer'ı noreply için ayrılmış); Reply-To kullanıcı; ekran görüntüsü için 7 gün geçerli imzalı adres (P6.1'deki `feedback_files` için superuser dosya token'ı yerine kendi imzalı route'umuz: `GET /api/app/feedback-shot/{id}?exp=&sig=`, HMAC anahtarı `PB_ENCRYPTION_KEY`'den türetilir); env yoksa görüş yine yazılır, e-posta atlanır.

**Sen yaparsın.** Coolify dev'e `MAIL_FEEDBACK_USER`, `MAIL_FEEDBACK_PASS`, `FEEDBACK_TO_EMAIL` gir.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.7: docs/pocketbase-gecis.md P5.7 "Claude yapar"ı uygula. Ekran görüntüsü feedback_files koleksiyonundadır (P6.1); link route'u dosyayı oradan sunar. Testler: test SMTP sunucusuyla konu/gövde/Reply-To; env yokken görüşün yazılması; imzalı linkin süresi dolunca 403, imza bozulunca 403.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; P9.2'de gerçek e-posta denenir.

**Doğrulama.** `cd server && go test ./internal/mail/... ./internal/...`.

**Ters giderse.** `git revert`.

### P5.8 Hesap silme: kod, talep, iptal, durum

**Amaç.** `account-delete` fonksiyonunun kullanıcıya dönük eylemleri ve SQL kuralları birebir.

**Ön koşul.** P5.6 (talepte token'lar silinir).

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.8: `POST /api/app/account-deletion/{send_code|verify_code|request|cancel|status}` route'larını yaz. Kaynaklar: supabase/functions/account-delete/handler.ts, mail.ts; migration'lar 20261113120000, 20261114120000, 20261115120000, 20261116120000. Kurallar birebir:
- Bekleme süresi tek sabit: 7 gün.
- send_code: 6 haneli kod, özeti deletion_codes'ta, 10 dk geçerli, 5 yanlışta kilit, 60 sn'den sık ve saatte 5'ten çok gönderilmez; "Mobil Arıcı hesap silme kodun" e-postası dokuz dilde (mail.ts'deki metinler), noreply kutusundan.
- verify_code; request yalnız son 15 dk'da doğrulanmış kodla (yoksa 403 code_required), kodu tüketir.
- request: tür (hesap / hesap_ve_isletme), transfer_to (yalnız etkin ortağa, kendi talebi bekleyen ortağa değil → 422 invalid_transfer_target), ekipli işletmenin owner'ı devretmeden ya da işletmeyi silmeyi seçmeden 409 (DL409 karşılığı), aynı kullanıcı/e-posta özeti için 24 saatte en çok 3 talep (429), devir ve talep tek transaction'da, talep anında kullanıcının bütün oturumları geçersiz (users tokenKey yenilenir), device_tokens silinir, bekleyen davetler iptal, memberships.deletion_scheduled_for dolar (senkronla iner), "şu tarihte silinecek" e-postası; yanıtta sayılar (kovan, arılık, muayene, hasat, belge, fotoğraf, yayımdaki lot sayfası).
- cancel: talep iptal, deletion_scheduled_for boşalır.
- status: bekleyen talep var mı ve tarihi (uygulamadaki account_deletion_pending).
Testler: account_deletion.test.sql, account_deletion_transfer.test.sql, account_deletion_code.test.sql ve handler_test.ts senaryolarını taşı; her testin adında kaynak. Kalıcı silme bu adımda değil (P5.9).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Taşınan senaryolar geçiyor; talepten sonra eski token 401 alıyor.

**Doğrulama.** `cd server && go test ./internal/deletion/... -race`.

**Ters giderse.** `git revert`.

### P5.9 Hesap silme: saatlik kalıcı silme cron'u, 3 yıllık kayıt, e-postalar

**Amaç.** Süresi dolan talepleri tamamlayan, tekrar çalıştırılabilir kalıcı silme.

**Ön koşul.** P5.8, P6.1 (dosyalar da silinir).

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.9: Cron `account-deletion-purge` `17 * * * *` (saat dilimi P5.6'da bulunduğu gibi). Süresi dolan her talep için sırayla ve her adım tekrar çalışabilir şekilde: (1) hesap_ve_isletme ise işletmenin tüm senkron satırları ve dosya kayıtları (P6.1 koleksiyonları, dosyalarıyla) kalıcı silinir; (2) hesap ise kullanıcının üyelikleri yumuşak silinir (retire_deleted_user_memberships), girdiği kayıtların created_by'ı ve görevlerin assigned_to'su boşaltılır — her biri yeni server_seq alır (diğer cihazlara iner); (3) kullanıcının dosyaları (feedback_files vb.) silinir; (4) users kaydı silinir; (5) deletion_log'a tarih, tür, kanal, kullanıcı kimliğinin SHA-256 özeti yazılır (3 yıl korunur, P2.7); (6) talep tamamlandi; (7) kısa onay e-postası. Yarıda kalan silme sonraki turda tamamlanır (adım durumu talep satırında). users silme hook'u: başka bir yoldan silinse de (2) uygulanır. Testler: handler_test.ts'deki cron senaryoları; erken cron hiçbir şey silmez; süre dolunca işletme, kayıtlar, dosyalar ve kullanıcı gider, log yazılır; yarıda kesilen silmenin tamamlanması; ekipli işletmede üyenin kayıtlarının kalması ve "silinmiş kullanıcı" (boş created_by) olarak inmesi; deletion_log'un silinememesi.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; cron panelde.

**Doğrulama.** `cd server && go test ./internal/deletion/... -race`.

**Ters giderse.** `git revert`; cron kaldırılır. Silinen veri geri gelmez — bu yüzden P9.2'de yalnız test hesabıyla denenir.

### P5.10 Lotun herkese açık sayfası

**Amaç.** `lot-page` artık kendi alan adımızda HTML olarak açılır (K-14).

**Ön koşul.** P5.3, P6.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P5.10: `GET /l/{id}` ve `GET /l/{id}/report` (HEAD de) route'larını yaz. Kaynak: supabase/functions/lot-page/page.ts ve index.ts, 20261102180000 (lot_public_page). Sayfa page.ts'deki HTML'in Go html/template karşılığı: dış kaynak yok, Accept-Language'e göre TR/EN, karanlık mod, `Content-Type: text/html; charset=utf-8`, 60 sn önbellek. Yalnız yayımdaki lot ve seçilen alanlar; kişisel veri (telefon, adres, konum, tescil/AKS no, e-posta) hiç seçilmez. Rapor: ilk istekte belge dosyasını public_lot_files'a kopyalar, her istekte yayımı ve public_report'u yeniden denetler; kaldırılınca kopyayı siler ve 404. Testler: lot_publish.test.sql'in sayfa kısmı; yayımda olmayan 404; alan seçimleri; kişisel verinin HTML'de olmaması; rapor erişiminin yayımdan kalkınca kesilmesi. Rota adresinin `/api/` ve `/_/` ile çakışmadığını doğrula.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; dev'de `curl -I https://arici-api-dev.tutunsoft.com/l/<olmayan-uuid>` → 404 `text/html`.

**Doğrulama.** `cd server && go test ./internal/lotpage/...`.

**Ters giderse.** `git revert`; uygulamada bölüm `LOT_PAGE_BASE_URL` olmadan gizli kalır.

---

## P6 Dosyalar

### P6.1 Dosya koleksiyonları

**Amaç.** Yedi bucket'ın karşılığı; bugünkü yükleme kuyruğu mantığı değişmeden çalışsın (K-13).

**Ön koşul.** P3.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P6.1: K-13'e göre media_files, document_files, receipt_files, feedback_files, org_logo_files, public_lot_files koleksiyonlarını ekle. Ortak alanlar: id (yoldaki son UUID, K-4), org_id, path (tekil; bugünkü storage_path metni, bucket'a özgü desenle — 20261024190000, 20261027180000, 20261103120000, 20261027120000, 20261112120000, 20261102180000'deki *_object_org_id fonksiyonlarının desenleri), file (tek dosya, korumalı/protected, maxSize ve mime bucket'la aynı: media 10 MB jpeg+audio/mp4, documents 20 MB jpeg+pdf, receipts 10 MB jpeg, feedback 5 MB jpeg, org-logos 2 MB jpeg, public-lots 20 MB jpeg+pdf), created. Kurallar (API kuralı + create hook'u): create: path'teki org_id = org_id alanı ve id = yoldaki son UUID ve rol (media/documents: owner/partner/worker; receipts ve org-logos: owner/partner; feedback: üye, viewer dahil); view/list: o işletmenin üyesi (receipts: owner/partner); update/delete: null (Supabase'de de yok); public_lot_files: tüm kurallar null. Aynı id ile ikinci yükleme 400 döner; istemci bunu "zaten yüklendi" sayacak (bugünkü 409 karşılığı) — hata yanıtının biçimini testte sabitle ve docs/pocketbase-gecis.md P7.4'e not düş. Thumbnail kapalı (RAM). Testler: media_rls, documents_rls, transactions_rls (dosya kısmı), feedback_analytics (dosya), business_profile (logo) senaryoları; yanlış yol, yanlış işletme, viewer yükleme, worker fiş okuma, boyut ve mime sınırı, dosya token'ı olmadan korumalı dosyanın 404/403 olması.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Altı koleksiyon ve senaryolar; `go test` geçiyor; `collections.json` güncel.

**Doğrulama.** `cd server && go test ./... && go run . schema dump && git diff --exit-code server/schema/`.

**Ters giderse.** `down`; `git revert`.

### P6.2 Bilgi bankası paketi ve yayımlama aracı

**Amaç.** `knowledge` bucket'ı ve `tool/publish_knowledge.dart`'ın karşılığı.

**Ön koşul.** P6.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P6.2: `knowledge_packs` koleksiyonu: id K-4, name (`manifest.json` ya da paket adı, tekil), file (json, 10 MB, korumalı değil ama view/list kuralı `@request.auth.id != ""`), kurallar: create/update/delete null. tool/publish_knowledge.dart'a `--backend pocketbase` seçeneği ekle: `PB_URL`, `PB_SUPERUSER_EMAIL`, `PB_SUPERUSER_PASSWORD` kabuktan okunur, önce paket sonra manifest yüklenir (aynı ad varsa dosyası güncellenir), mevcut Supabase yolu varsayılan olarak P11.1'e kadar kalır. Gizli değerler loglanmaz. Go testi kural için; Dart aracı için mevcut test kalıbında sahte HTTP testi. Aracı çalıştırma; kullanıcı dev'e yayımladığında sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Koleksiyon + araç; kullanıcı dev'e en az bir paket yayımladı.

**Doğrulama.** `cd server && go test ./...`; `flutter test test/tool/` (aracın testi nerede ise); `PB_URL=… dart run tool/publish_knowledge.dart --backend pocketbase --version N` (kullanıcı).

**Ters giderse.** `git revert`; dev'deki paket kaydı panelden değil, aynı araçla eski sürüm yayımlanarak düzeltilir.

---

## P7 Flutter

### P7.1 Flutter backend soyutlaması ve seçim ayarı

**Amaç.** Uygulamanın her ağ dokunuşu bir arayüzün arkasında; hangi backend'in kullanılacağını tek bir ayar seçer. Bu adımda davranış değişmez (hep Supabase).

**Ön koşul.** P0.1 (sunucu adımlarından bağımsız; P2 ile paralel yapılabilir).

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P7.1: docs/pocketbase-gecis.md "Envanter → Flutter'da Supabase'e dokunan dosyalar" listesindeki her dosyayı oku.
1. `lib/app/flavor.dart`: Flavor'a `defaultBackend` (`Backend.supabase | Backend.pocketbase`, ikisinde de şimdilik supabase) ve `pocketbaseUrl` (dev https://arici-api-dev.tutunsoft.com, prod https://arici-api.tutunsoft.com) ekle. `--dart-define=BACKEND=supabase|pocketbase` varsayılanı ezer, `--dart-define=PB_URL=` adresi ezer. `backendProvider` (@riverpod, keepAlive). Ekranlar backend'i bilmez.
2. Arayüzler: zaten arayüz olanlar (AuthService, OrganizationService, TeamService, DeviceTokenService, AccountDeletionService) korunur. Yeni arayüzler: `SyncTransport` (push(batch, clientTime, schemaVersion) → yanıt modeli; pull(table, sinceSeq, pageSize) → sayfa modeli; hata sınıfları: geçici, upgradeRequired, kalıcı), `FileStore` (upload(bucket, path, bytes, contentType) → ok|alreadyExists; download(bucket, path) → bytes), `WeatherApi`, `TelemetryApi` (insertFeedback, insertAnalytics). SyncService, storage_file_sync, telemetry, weather ve knowledge servisleri SupabaseClient yerine bu arayüzleri alır.
3. Supabase uygulamaları bu arayüzleri uygular (mevcut kod taşınır, davranış aynı). Provider'lar backendProvider'a göre seçer; pocketbase dalı şimdilik `UnimplementedError` atar ve BACKEND=pocketbase verilmedikçe hiç seçilmez.
4. Testler: mevcut testlerin hepsi değişmeden (ya da yalnız kurulum satırı değişerek) geçmeli; sahte HTTP'li Supabase testleri arayüz uygulamalarının testi olur. backendProvider ve dart-define çözümü için birim testi.
Hiçbir ekran ya da ARB değişmez. Supabase'e dokunan kodun yalnız `…/supabase_*.dart` uygulama dosyalarında kaldığını grep ile doğrula ve listeyi progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Tüm testler geçiyor; `grep -rl "supabase_flutter" lib` yalnız Supabase uygulama dosyalarını ve kurulumu gösteriyor; uygulama dev'de eskisi gibi çalışıyor.

**Doğrulama.** `flutter analyze`; `flutter test`; `grep -rln "package:supabase_flutter" lib | grep -v "/supabase_"`; `flutter run --flavor dev -t lib/main_dev.dart` ile giriş + senkron.

**Ters giderse.** `git revert` (yalnız Flutter; sunucu etkilenmez).

### P7.2 PocketBase istemcisi, oturum saklama, OTP girişi

**Amaç.** BACKEND=pocketbase iken giriş, oturum saklama, yenileme ve çıkış çalışsın.

**Ön koşul.** P7.1, P4.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P7.2:
1. pub.dev'den `pocketbase` paketinin güncel sürümünü doğrula (dokümanda 0.25.3 yazıyor), changelog'unda v0.40 sunucusuyla uyumu kontrol et, pubspec'e tam sürümle (`pocketbase: 0.25.x` caret'siz) ekle.
2. `pocketbaseClientProvider` (@riverpod, keepAlive): `PocketBase(flavor.pocketbaseUrl, authStore: AsyncAuthStore(...))`; AsyncAuthStore flutter_secure_storage'a adres başına ayrı anahtarla yazar (SecureSessionStorage'daki iOS/Android seçenekleri aynen; çözülemeyen kayıt silinip yeniden giriş). Sunucu adresi değişirse eski oturum yüklenmez.
3. `PocketBaseAuthService implements AuthService`: sendCode → POST /api/app/auth/otp {email, locale}; dönen otpId secure storage'da e-postayla birlikte tutulur (uygulama arka plana gidip öldürülse de kod girilebilsin; 10 dk sonra silinir). verifyCode → authWithOTP(otpId, code); demo adresi (reviewDemoEmail) için authWithPassword. Kod doğrulanınca locale farklıysa POST /api/app/auth/locale (başarısızlık girişi bozmaz). Hata eşleme mevcut AuthFailure'lara (ağ, geçersiz e-posta, yanlış/süresi dolmuş kod, çok sık istek). currentUser / userChanges authStore'dan. signOut çevrimdışıyken de yerel oturumu siler.
4. Yenileme (K-6): uygulama açılışında ve SyncService turunun başında authRefresh; ağ hatası oturumu kapatmaz; yalnız 401 (token geçersiz) kapatır. Çevrimdışıyken süresi dolmuş token da açılışta kurulur (UI kilitlenmez); senkron turu 401'de oturumu kapatır.
5. Testler: mevcut auth_service_test.dart kalıbında sahte HTTP ile istek gövdeleri, hata eşleme, otpId'nin saklanması ve süresi, demo dalı, locale eşitleme, çevrimdışı çıkış; "çevrimdışı oturum açık kalır, ağ gelince yenilenir" ve "reddedilen token oturumu kapatır" sahte zamanlı senaryoları; secure storage testleri.
Ekran değişmez. BACKEND=pocketbase ile yerel sunucuya karşı (go run . serve) simülatörde giriş dene ve sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; yerel PocketBase'e karşı simülatörde OTP ile giriş (kod sunucu logundan) ve uygulama yeniden açılınca oturum duruyor.

**Doğrulama.** `flutter test test/features/auth/`; `cd server && go run . serve` + `flutter run --flavor dev -t lib/main_dev.dart --dart-define=BACKEND=pocketbase --dart-define=PB_URL=http://127.0.0.1:8090`.

**Ters giderse.** `git revert`; varsayılan backend hâlâ Supabase olduğu için kullanıcı etkilenmez.

### P7.3 Senkron taşıyıcısı, backend değişiminde imleç sıfırlama, arka plan görevi

**Amaç.** SyncService PocketBase ile push/pull yapsın; backend değişince yerel imleçler sıfırlansın ama outbox korunsun.

**Ön koşul.** P7.2, P5.3.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P7.3:
1. `PocketBaseSyncTransport implements SyncTransport`: docs/pocketbase-gecis.md "Senkron sözleşmesi"ne göre POST /api/sync/push ve GET /api/sync/pull. Hata sınıflaması SyncService'in bugünkü listesine eşlenir: bağlantı hatası, zaman aşımı, 408/429/500/502/503/504 → geçici; 426 → upgradeRequired; 401 → oturum (kapat); diğer 4xx → kalıcı. Yanıt modeli Supabase'inkiyle aynı olduğu için SyncService mantığı değişmez.
2. Backend kimliği: yerel `local_settings`'e `sync_backend` = "<backend>|<url>" yazılır. Açılışta değer mevcut backend'den farklıysa tek transaction'da: tüm `sync_state` imleçleri ve `:full_pull` işareti silinir (yeni ilk tam çekme ekranı açılır), outbox ve yerel kayıtlar korunur (çekme, bekleyen outbox satırını zaten ezmiyor), yerel satırların server_seq'i dokunulmaz (kullanılmıyor). Testle kanıtla: Supabase'de yazılmış ve outbox'ta bekleyen kayıt, backend değişince PocketBase'e gönderilir.
3. app/background_sync.dart: arka plan isolate'i backend'e göre Supabase'i ya da PocketBase istemcisini (aynı AsyncAuthStore anahtarıyla) açar; port devri aynen.
4. Testler: sync_service_test.dart kalıbında sahte HTTP ile PocketBase yolları (paketleme, ret işareti, 426, geçici hata beklemeleri, pull sayfaları ve imleç); backend değişimi testi.
5. Yerel PocketBase'e karşı simülatörde: arılık ve kovan ekle → sunucuda kayıtlar (panelde ya da superuser'lı curl ile) → ikinci simülatör/temiz kurulumda ilk tam çekme. Sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; yerel sunucuya karşı iki kurulum arasında senkron çalışıyor; backend değişiminde outbox korunuyor.

**Doğrulama.** `flutter test test/core/sync/`; simülatör denemesi.

**Ters giderse.** `git revert`; varsayılan Supabase.

### P7.4 Dosya yükleme ve indirme

**Amaç.** Medya, belge, fiş, logo, görüş ekran görüntüsü ve bilgi bankası paketi PocketBase'e yüklenip oradan insin.

**Ön koşul.** P7.3, P6.2.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P7.4: `PocketBaseFileStore implements FileStore`. Bucket → koleksiyon eşlemesi K-13 ve P6.1'deki gibi. upload: multipart create {id: yoldaki son UUID, org_id: yolun ilk parçası, path, file}; P6.1'de sabitlenen "id zaten var" yanıtı → alreadyExists (bugünkü 409 karşılığı). download: path ile kaydı bul (filter `path = {:path}`, parametreli), dosya token'ı al (pb.files.getToken), dosyayı indir; token önbelleği ~1 dk. knowledge: knowledge_packs'ten ada göre. Mevcut kuyruk, geri çekilme, Wi-Fi şartı ve kalıcı/geçici hata ayrımı değişmez; yalnız hata sınıflaması yeni yanıtlara eşlenir. Testler: media/document/receipt/logo/telemetry/knowledge servis testlerinin PocketBase yolları (sahte HTTP): ilk yükleme, ikinci yükleme = ok, 413/400 boyut → kalıcı, ağ hatası → geçici, indirmede token ve 404. Yerel sunucuya karşı simülatörde bir fotoğraf ve bir belge dene.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Testler geçiyor; yerelde fotoğraf yüklenip ikinci kurulumda açılıyor.

**Doğrulama.** `flutter test test/core/sync/`.

**Ters giderse.** `git revert`.

### P7.5 Servisler: işletme, ekip, hava, push token, görüş ve analitik, hesap silme

**Amaç.** Kalan ağ servislerinin PocketBase uygulamaları.

**Ön koşul.** P7.4 ve P5.4–P5.9.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P7.5: PocketBase uygulamalarını yaz ve provider seçimine bağla:
- OrganizationService → /api/app/organizations, /api/app/organizations/mine.
- TeamService → /api/app/team/{action}; çevrimdışı hatası bugünkü "durum 0" davranışıyla aynı.
- WeatherApi → POST /api/app/weather.
- DeviceTokenService → /api/app/device-token.
- TelemetryApi → feedback ve analytics_events kayıt API'si (create); "id zaten var" → duplicate (bugünkü 23505 karşılığı).
- AccountDeletionService → /api/app/account-deletion/{action}; hata kodları (code_required, invalid_transfer_target, member_leaving, 409, 429) mevcut failure'lara.
Her biri için mevcut servis testinin PocketBase eşi (sahte HTTP; istek gövdeleri ve hata eşleme). BACKEND=pocketbase ile tam akışı yerelde dene: onboarding (işletme kur), davet kodu üret/kullan (iki simülatör), Bugün'de hava (yerelde WEATHERAPI_KEY yoksa 503 → ekranın bunu nasıl gösterdiğini not et), görüş gönder, hesap silme akışının kod adımına kadar. Sonuçları progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** BACKEND=pocketbase ile hiçbir provider `UnimplementedError` atmıyor (test: tüm provider'lar iki backend'de kurulabiliyor); servis testleri geçiyor.

**Doğrulama.** `flutter test`; `grep -rn "UnimplementedError" lib | grep -i pocketbase` boş.

**Ters giderse.** `git revert`.

### P7.6 Lot sayfası adresi, yasal metinler, dev'de varsayılan PocketBase

**Amaç.** Lot sayfası açılır (K-14), gizlilik politikası Türkiye'yi yazar (K-16), dev flavor artık PocketBase'i kullanır.

**Ön koşul.** P7.5, P5.10.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P7.6:
1. Lot sayfası: lotPageBaseUrlProvider BACKEND=pocketbase iken `${flavor.pocketbaseUrl}/l` döner (LOT_PAGE_BASE_URL verilirse o ezer); Supabase'deyken bugünkü gibi null (gizli). lotPageUrl kuralı ve testleri güncelle; "adres yokken bölüm gizli" testi Supabase için kalsın, PocketBase için "bölüm görünür" testi eklensin. docs/progress.md "Sona bırakılanlar"daki lot sayfası maddesini "P5.10/P7.6 ile açıldı; uçtan uca P9.2'de denenecek" olarak güncelle.
2. Yasal: docs/legal/privacy-policy.html'de Supabase AB → sunucunun Türkiye'de (Hosting.com.tr) olduğu, TR ve EN; yurt dışı aktarım bölümünde yalnız gerçekten yurt dışına giden hizmetler kalır (FCM, Sentry, WeatherAPI, OpenFreeMap, Nominatim; Hostinger e-postası — Hostinger'ın sunucu konumunu metne yazmadan önce kullanıcıya sor). docs/legal/account-deletion.html'i oku: süreler (7 gün, 3 yıl), "oturumlarınız kapanır" ve e-posta yolu PocketBase akışıyla aynı mı denetle; yalnız fark varsa düzelt. Sayfaların siteye yüklenmesini kullanıcı yapar; progress'e not düş.
3. Dev flavor'ın defaultBackend'i pocketbase olur; prod supabase kalır. .vscode/launch.json'da dev için PB, prod için Supabase; README'ye BACKEND ve PB_URL kullanımını ekle.
4. Testler: flavor varsayılanları; lot bölümü.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Dev derleme varsayılan olarak `arici-api-dev`'e bağlanıyor; gizlilik metni güncel; testler geçiyor.

**Doğrulama.** `flutter test`; `flutter run --flavor dev -t lib/main_dev.dart` → giriş e-postası dev sunucudan geliyor.

**Ters giderse.** Dev varsayılanı tek satırla supabase'e döner; `git revert`.

---

## P8 Veri

### P8.1 Referans veri ve demo hesap tohumu

**Amaç.** K-12 gereği kullanıcı verisi taşınmaz; referans verinin tam olduğu doğrulanır ve demo hesap PocketBase'de idempotent bir araçla kurulur.

**Ön koşul.** P7.6 (uygulama demo hesabıyla dev'de denenebilsin).

**Claude yapar.** `go run . seed demo [--dry-run] [--date YYYY-MM-DD]` alt komutu: `supabase/admin/demo_account.sql`'in yazdığı her şeyi (Demo Arıcılık, 3 arılık, 15 kovan ve anaları, 28 muayene, varroa, besleme, ilaçlama, hasat, 4 görev, 6 gelir/gider) aynı mantıkla, sabit kimliklerle (UUIDv5 ya da sabit liste) yazar; demo kullanıcı yoksa parolasız hata verir; işletme varsa hiçbir şey yazmaz (`--force-reset` yalnız demo işletmeyi silip yeniden yazar); dry-run yazılacak satır sayılarını tablo tablo basar. Komut sunucu ikilisinin içinde çalışır (konteyner terminalinden). `seed verify-ref`: ref_drugs ve ref_support_periods sayısını ve örnek 3 kaydın alanlarını P0.2 yedeğindeki değerlerle (argümanla verilen JSON) karşılaştırır.

**Sen yaparsın.** Dev'in Coolify konteyner terminalinde demo kullanıcıyı aç: `/pb/arici seed demo-user --email demo@tutunsoft.com` (parolayı terminal sorar, ekrana basılmaz; App Store/Play inceleme formundaki kodla aynı 6 hane). Sonra `/pb/arici seed demo --dry-run`, çıktıyı Claude'a ver; sonra `/pb/arici seed demo`. Aynısı P10.1'de prod için. (İkili adı P1.2'deki Dockerfile'da neyse o; burada `arici` varsayıldı.)

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P8.1: docs/pocketbase-gecis.md P8.1 "Claude yapar"ı uygula. demo_account.sql'i satır satır oku; tarihler betikteki gibi çalıştırıldığı güne göre kayar. Kayıtlar push ile değil doğrudan uygulama API'siyle ama aynı doğrulama ve seq hook'larından geçerek yazılır. `seed demo-user`: parolayı terminalden gizli okur (golang.org/x/term), kullanıcıyı locale `en`, verified true açar; parola hiçbir yere yazılmaz. Testler: dry-run hiçbir şey yazmaz; ikinci çalıştırma hiçbir şey yazmaz (idempotent); tablo başına sayılar SQL betiğindekiyle aynı (testte sabit; SQL'den sayımı yorumda gerekçelendir); --force-reset yalnız demo işletmeye dokunur. verify-ref için test. Kullanıcı dev'de çalıştırınca dry-run çıktısını ve son sayıları progress'e yaz; uygulamada demo hesapla giriş yapılıp verinin göründüğünü sor.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Dev'de demo hesapla giriş yapılıyor ve Supabase'deki demo işletmeyle aynı sayıda arılık, kovan, muayene görünüyor; `verify-ref` eşit; ikinci `seed demo` 0 yazma.

**Doğrulama.** Konteynerde `seed demo --dry-run` (ikinci kez: hepsi 0); `seed verify-ref --expect ref.json`; Supabase tarafı için P0.2 manifest'i.

**Ters giderse.** `seed demo --force-reset` ya da demo işletmenin kalıcı silinmesi için hesap silme akışı; ref verisi migration'la geldiği için etkilenmez.

---

## P9 Uçtan uca test

### P9.1 İki cihaz ve çevrimdışı senkron testleri (yerel PocketBase)

**Amaç.** `integration_test/two_devices_sync_test.dart`'ın PocketBase'e karşı geçmesi; çakışma ve çevrimdışı senaryoları.

**Ön koşul.** P8.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P9.1: integration_test/helpers/test_device.dart ve two_devices_sync_test.dart'ı backend'den bağımsız yap: BACKEND=pocketbase iken test hesaplarını yerel PocketBase'de bir test yardımcı route'u ile değil, superuser'lı yerel betikle (`server/ops/test_users.sh`, yalnız 127.0.0.1'e izin verir) açar ve OTP yerine demo dalındaki gibi parola girişini yalnız test derlemesinde kullanır — bunu nasıl yapacağını önce öner ve onay al (sunucuya test arka kapısı açılmamalı). Mevcut senaryoların hepsi PocketBase'de geçmeli: iki cihaz offline yazıp eşitlenir, aynı kovana iki muayene iki kayıt olur, durum kaydında son yazan kazanır, silme yayılır, 600 kovanlık test, imleç ilerlemesi. Ek senaryolar: (1) Supabase'de yazılıp outbox'ta kalan kaydın backend değişince PocketBase'e gitmesi (P7.3), (2) token süresi dolmuşken çevrimdışı açılış ve ağ gelince yenileme, (3) etiket kodu çakışmasında `conflict` ve senkron ekranında görünmesi, (4) viewer yazmasının `forbidden` ile reddi. Çalıştırma komutunu README'ye ve progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** İki cihaz testleri yerel PocketBase'e karşı iOS simülatöründe geçiyor; ek dört senaryo geçiyor.

**Doğrulama.** `cd server && go run . serve &`; `flutter test integration_test --flavor dev -d <iOS simülatörü> --dart-define=BACKEND=pocketbase --dart-define=PB_URL=http://127.0.0.1:8090`.

**Ters giderse.** `git revert`; Supabase yolu testlerde kalır.

### P9.2 Dev sunucusunda uçtan uca

**Amaç.** Gerçek cihazda, gerçek dev sunucusuna karşı her özelliğin denenmesi.

**Ön koşul.** P9.1. Dev'de tüm ortam değişkenleri girilmiş (SMTP ×2, WeatherAPI, FCM).

**Claude yapar.** `docs/pocketbase-e2e.md` kontrol listesi (aşağıdaki maddeler, her biri "beklenen" ile) ve sonuçların progress'e işlenmesi; çıkan hataların düzeltilmesi (ayrı commit'ler).

**Sen yaparsın.** İki gerçek telefonla (biri Android) listeyi yürütürsün:

1. Yeni e-postayla giriş (TR ve EN e-posta), uygulamayı öldürüp kodu sonra girme.
2. Onboarding, arılık + 20 toplu kovan, QR okut, muayene + foto + sesli not, ikinci telefonda görünmesi.
3. Uçak modunda 10 kayıt, ağ gelince eşitlenme; iki telefonda aynı kovanın durumunu çevrimdışı değiştirip son yazanın kazanması.
4. Ekip: davet kodu, worker ve viewer rolleri (worker finansı görmez, viewer yazamaz), rol değiştirme, çıkarma.
5. Görev başkasına atanınca push gelmesi, bildirime dokununca görevin açılması.
6. Belge (PDF) ve fiş yükleme, diğer telefonda açılması; işletme logosu.
7. Hava kartları; bilgi bankası güncellemesi.
8. Görüş bildir (ekran görüntülü) → feedback@ e-postası ve 7 günlük link.
9. Lot yayımla → QR'ı başka bir telefonda tarayıcıyla aç (HTML), raporu aç, yayımdan kaldır → 404.
10. Hesap silme: test hesabıyla kod e-postası, talep, oturumun kapanması, bekleme ekranı, iptal; ikinci test hesabıyla talep → Coolify terminalinde talebin tarihini geçmişe çekip (`seed` aracına eklenecek `deletion expire --user <e-posta>` yalnız dev'de çalışır) cron'u panelden elle tetikle → kullanıcı, işletme, dosyalar silinir, `deletion_log`'da kayıt, onay e-postası.
11. Demo hesapla parola girişi.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P9.2: docs/pocketbase-gecis.md P9.2'deki 11 maddeyi docs/pocketbase-e2e.md'de beklenen sonuçlarıyla, işaretlenebilir bir kontrol listesi olarak yaz. `seed` aracına yalnız APP_ENV=dev iken çalışan `deletion expire --user <e-posta>` alt komutunu ekle (prod'da hata verir; testle kanıtla). Kullanıcı listeyi yürütüp sonuçları verdikçe başarısız maddeleri tek tek düzelt (her düzeltme ayrı commit, testli); geçen maddeleri işaretle. Bu oturumda bitmeyen maddeler progress'te açık kalır ve adım ◐ olarak işaretlenir.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** `docs/pocketbase-e2e.md`'deki 11 madde ☑.

**Doğrulama.** Kontrol listesi; Coolify loglarında hata yok (`level=ERROR` araması).

**Ters giderse.** Düzeltme commit'leri tek tek geri alınabilir; prod etkilenmez.

### P9.3 Yük ve RAM kontrolü

**Amaç.** 4 GB'lık VPS'te, Coolify ile birlikte, beklenen yükte PocketBase'in bellek sınırında kaldığını görmek.

**Ön koşul.** P9.2.

**Claude yapar.** `server/cmd/loadtest` (Go): N sanal kullanıcı (her biri ayrı test işletmesi), her biri 100'lük paketlerle push, ardından tam pull, ara ara 1 MB'lık dosya yükleme; süre, hata oranı, p50/p95 gecikme raporu; yalnız `APP_ENV=dev` sunucusuna ve dev'deki `loadtest-*` hesaplarına çalışır; bitince kendi işletmelerini temizler. Senaryo: 50 kullanıcı × 2000 kayıt, 10 eşzamanlı.

**Sen yaparsın.** Mac'ten aracı dev'e çalıştırırken VPS'te `docker stats` izlersin, en yüksek bellek ve CPU'yu not edersin. Prod'a çalıştırma.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P9.3: docs/pocketbase-gecis.md P9.3 "Claude yapar"ı uygula. Test hesaplarını açmak için P9.1'deki yerel betik yaklaşımını dev sunucusuna superuser bilgisi kabuktan okunarak uygula; prod adresine karşı çalışmayı reddet (verilen adres + /api/app/info yanıtındaki env `dev` olmalı). Aracı çalıştırma; kullanıcının sonuçlarını (araç raporu + docker stats en yüksek değerleri) progress'e yaz ve şunlara göre karar öner: bellek dev sınırının %80'ini aşıyorsa GOMEMLIMIT ve sınır ayarı; p95 push > 2 sn ise paket boyutu ya da index; SQLite "database is locked" görüldüyse busy timeout.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Hata oranı %0; dev konteyneri bellek sınırının %80'inin altında; VPS'te boş RAM ≥ 500 MB; sonuçlar progress'te.

**Doğrulama.** Araç raporu; `docker stats --no-stream`.

**Ters giderse.** Araç kendi verisini siler; silemezse dev volume'ü sıfırlanabilir (dev verisi önemsiz, K-17).

---

## P10 Geçiş

### P10.1 Prod hazırlığı ve Supabase yazmalarının dondurulması

**Amaç.** Prod PocketBase dev'le aynı kodda, bütün değişkenleriyle hazır; Supabase'e artık yazılmasın (K-11).

**Ön koşul.** P9.3.

**Sen yaparsın.**

1. Coolify prod'a dev'deki tüm değişken adlarını gir (değerler: SMTP ve WeatherAPI aynı; `PB_ENCRYPTION_KEY` prod'a özel; `FCM_SERVICE_ACCOUNT_B64` aynı Firebase projesi).
2. Prod'u "Deploy" ile elle deploy et (`pocketbase-gecis` dalının son commit'i).
3. Prod konteyner terminalinde `seed demo-user` ve `seed demo`, sonra `seed verify-ref`.
4. Panelde bir yedek al, Mac'e indir (`pull_backup.sh`).

**Claude yapar.** (1) `supabase/migrations/<zaman>_freeze_sync_push.sql`: `sync_push`'un desteklenen sürüm dizisini boşaltır (her çağrı 426, hiçbir şey yazmaz); başka hiçbir şeye dokunmaz; geri alma SQL'i dosyanın yorumunda. pgTAP: her sürüm 426. (2) Bu migration'ı uzak projeye uygular (hafızadaki "Migration'ı uzağa uygula" kuralı: `supabase db push`, proje ref'i `jcddnelaboueazhordfz` doğrulanarak) ve anon/oturumlu çağrının 426 döndüğünü doğrular. (3) Prod için `schema_check.sh` ve `/api/health` doğrulaması.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P10.1: Önce kullanıcıya P10.1 "Sen yaparsın" maddelerinin bitip bitmediğini sor; bitmediyse dur. Sonra "Claude yapar" maddelerini uygula. Supabase'de veri silme, tablo düşürme, auth kapatma yapma; yalnız sync_push sürüm listesini boşalt. MCP/CLI'nin Mobil Arıcı projesine (jcddnelaboueazhordfz) bağlı olduğunu tablo listesiyle doğrulamadan SQL çalıştırma. Prod'a karşı yalnız okuma doğrulaması yap: /api/health, schema_check.sh (superuser kullanıcı kendi kabuğunda çalıştırır), /api/sync/pull oturumsuz 401.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Prod sağlıklı, şema dev'le aynı, demo hesap prod'da; Supabase `sync_push` her sürüme 426; Supabase verisi yerinde.

**Doğrulama.** `curl -fsS https://arici-api.tutunsoft.com/api/health`; `server/ops/schema_check.sh https://arici-api.tutunsoft.com`; Supabase'de `select count(*) from hives` = 47 (değişmedi).

**Ters giderse.** Dondurma migration'ının yorumundaki geri alma SQL'i yeni bir migration olarak uygulanır (sürüm listesi geri gelir). Prod PocketBase durdurulur; Supabase hiç değişmediği için uygulama prod derlemesi Supabase'le çalışmaya devam eder.

### P10.2 Geçiş: prod varsayılanı PocketBase, sürüm, izleme

**Amaç.** Prod flavor PocketBase'e geçer; yayın derlemesi hazır; izleme kurulur.

**Ön koşul.** P10.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P10.2:
1. Prod flavor'ın defaultBackend'i pocketbase olur. Supabase uygulamaları kodda kalır (BACKEND=supabase ile hâlâ seçilebilir) — geri dönüş için.
2. pubspec sürümünü artır (build numarası +1, sürüm adını kullanıcıya sor).
3. `flutter clean` sonra prod AAB ve iOS derlemesi (README'deki komutlar). Derleme çıktılarını ve boyutlarını raporla.
4. İzleme: server/ops/monitoring.md — Coolify'da prod için bildirim (deploy başarısız, konteyner durdu; e-posta kanalı), dışarıdan çalışma süresi denetimi önerisi (ücretsiz bir uptime servisi, /api/health, 5 dk), Sentry'nin uygulama tarafında zaten açık olduğu, Coolify loglarında aranacak kalıplar (`level=ERROR`, `sync push`, `database is locked`), günlük yedeğin kontrolü. Kullanıcının kuracağı adımlar açıkça "Sen yaparsın" diye ayrılır.
5. docs/pocketbase-gecis.md "Geçiş günü kontrol listesi"ni bu adımda doldurulan değerlerle işaretle.
Kullanıcı prod derlemesini cihazda deneyince (demo hesapla giriş, kayıt, ikinci cihazda görünme) sonucu progress'e yaz.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Prod derlemesi `arici-api.tutunsoft.com`'a bağlanıyor; cihazda giriş, kayıt ve senkron çalışıyor; izleme kurulu; geçiş günü listesi ☑; gözlem süresinin başlangıç tarihi progress'te.

**Doğrulama.** Prod derlemesiyle giriş; Coolify prod loglarında istekler; uptime servisinde yeşil.

**Ters giderse.** **Geri dönüş planı:** (1) Prod flavor'ın defaultBackend'i tek satırla supabase'e alınır; (2) P10.1'in dondurma migration'ı geri alma migration'ıyla kaldırılır; (3) yeni build numarasıyla derlenir. Uygulama yayında olmadığı için kullanıcıya dağıtım gerekmez. PocketBase'de geçişten sonra yazılmış veri varsa (yalnız test/demo) Supabase'e geri taşınmaz; gerekirse P8.1'in tersi bir araç yazılır.

---

## P11 Temizlik

### P11.1 Flutter'dan Supabase'in kaldırılması

**Amaç.** Supabase bağımlılığı uygulamadan çıkar. **Ön koşul:** P10.2'den sonra 14 gün; bu sürede prod'da kritik hata yok ve P1.4 yedekleri düzenli iniyor.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P11.1: Önce progress'teki P10.2 tarihinden bu yana 14 gün geçtiğini ve kullanıcının prod'da açık kritik hata olmadığını onayladığını kontrol et; değilse dur. Sonra: supabase_flutter bağımlılığını, Supabase uygulama dosyalarını (supabase_*), supabase_setup.dart'ı, supabaseClientProvider'ı, Flavor'daki Supabase alanlarını ve Backend.supabase seçeneğini kaldır; BACKEND dart-define'ı kalkar (PB_URL kalır). Arayüzler (SyncTransport, FileStore vb.) kalır — test edilebilirlik için. Backend değişiminde imleç sıfırlama (P7.3) kalır, artık adresler arası (dev↔prod) için. schema_mirror_test'ten SQL kaynağını kaldır, yalnız collections.json'u okusun. tool/publish_knowledge.dart'tan Supabase yolunu kaldır. Supabase'e özgü testleri sil, PocketBase eşlerinin kapsamı düşmesin (test sayısını önce/sonra raporla). supabase/ klasörüne dokunma (P11.2). `grep -rni supabase lib test integration_test tool` sonucunu progress'e yaz (yalnız yorum/tarih kalabilir).

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** `pubspec.yaml`'da supabase_flutter yok; `flutter analyze` ve `flutter test` temiz; uygulama prod'da çalışıyor.

**Doğrulama.** `grep -n supabase pubspec.yaml` boş; `flutter test`; prod derlemesiyle duman testi.

**Ters giderse.** `git revert` (P10.2 sürümüne dönülür; Supabase hâlâ duruyor).

### P11.2 Dokümanlar, CLAUDE.md, araçlar ve hafıza

**Amaç.** Proje dokümanları ve kurallar PocketBase'i anlatsın; geçiş dalı main'e girsin.

**Ön koşul.** P11.1.

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P11.2:
1. CLAUDE.md: Teknoloji yığını, Mimari kurallar ("Supabase istemcisi UI'da yok" → PocketBase istemcisi; senkron `core/sync/` + `server/internal/sync/`), Klasör yapısı (server/ eklenir, supabase/ arşiv), ve "Yeni kayıt türü kalıbı"nın 1–3. adımları PocketBase'e göre yeniden yazılır: Go migration (P2 ortak kalıbı) + authz Policy + kayıt listesi + schema dump + Go testleri; Drift aynası ve supported versions (`server/internal/sync/versions.go`) kuralı; deploy = dalı push et, Coolify dev otomatik, prod elle. En üstteki "Geçiş sürüyor" notu kalkar. Oturum sonu listesine `cd server && go test ./...` eklenir.
2. docs/teknik.md (backend, auth, storage, edge functions, cron, güvenlik/KVKK veri bölgesi, CI/CD) ve docs/ozellikler.md'deki Supabase anlatımlarını güncelle; README.
3. supabase/ klasörünü `archive/supabase/` altına taşı ve başına bir OKU-BENI: "2026-11'e kadar kullanılan backend; P0.2 yedeği şurada; yeni migration yazılmaz". tool/store_screenshots.py'yi yerel PocketBase + `seed demo` ile çalışacak şekilde uyarla.
4. Kullanıcıya sor: Claude hafızasındaki Supabase'e özgü kayıtlar (supabase-projects, verify-supabase-project, apply-migrations-remote) güncellensin mi? Onay verirse: apply-migrations-remote yerine "server değişikliği pocketbase dalına push → dev otomatik; prod elle deploy" kuralı; Supabase kayıtları arşiv notuna çevrilir.
5. Coolify'da iki kaynağın dalını `main` yapmak için kullanıcıya talimat yaz; `pocketbase-gecis` dalını main'e birleştirmeden önce kullanıcıdan onay al, birleştirme `--no-ff`.
6. Bu dokümanın başına "Tamamlandı (tarih)" notu.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** CLAUDE.md'de "Supabase" yalnız arşiv bağlamında; dal main'de; Coolify `main`'i izliyor.

**Doğrulama.** `grep -n -i supabase CLAUDE.md docs/teknik.md`; `git log main --oneline -1`; Coolify'da dal adı.

**Ters giderse.** Birleştirme commit'i geri alınır; Coolify dalı `pocketbase-gecis`'e döner.

### P11.3 Supabase projesinin duraklatılması

**Amaç.** Supabase artık hiçbir şeye hizmet etmiyor; veri silinmeden duraklatılır.

**Ön koşul.** P11.2.

**Sen yaparsın.** Son bir P0.2 yedeği daha al (`tool/backup_supabase.sh` arşivden). Supabase panelinde projeyi "Pause". Projeyi silmek ayrı ve senin vereceğin bir karar; bu plan silmez. Edge Function secret'larını (WeatherAPI, SMTP, FCM) Supabase'den sil — değerler zaten Coolify'da; eski FCM anahtarını Firebase'den iptal et (P5.6'da yenisi üretildi).

**Prompt.**

```text
[BAŞ] CLAUDE.md, docs/progress.md ve docs/pocketbase-gecis.md'yi oku. Sadece aşağıdaki adımı yap, fazlasını yapma. Belirsizlik varsa başlamadan sor.

Adım P11.3: Kod yazma. Kullanıcıya P11.3 "Sen yaparsın" maddelerini tek tek sor; yaptıklarını progress'e yaz (tarih, son yedeğin manifest sayıları, duraklatma). Supabase'de kendin hiçbir işlem yapma.

[SON] Bitince: ilgili testleri, flutter analyze ve flutter test'i çalıştır, hataları düzelt, docs/progress.md'ye 3-5 madde ekle, kontrol listesinde adımı işaretle, anlamlı bir mesajla commit at.
```

**Bitti sayılma kriterleri.** Supabase duraklatıldı; son yedek iki yerde; Supabase'deki secret'lar silindi; eski FCM anahtarı iptal.

**Doğrulama.** Supabase panelinde proje durumu "Paused".

**Ters giderse.** Panelden "Restore project" (Supabase'in duraklatılmış projeyi geri yükleme süresi sınırlıdır; uzun vadeli kopya P0.2/P11.3 yedekleridir).

---

## Riskler

| # | Risk | Etki | Önlem |
| --- | --- | --- | --- |
| R1 | PocketBase GitHub'dan ayrılıyor (v0.40.6 notu); Go modülü ileride farklı yoldan gelebilir | Sürüm yükseltme zorlaşır | v0.40.6 + go.sum sabit; Docker imajı digest'li; yükseltme ayrı karar. `GOFLAGS=-mod=mod` ile proxy önbelleği yeterli; istenirse `go mod vendor`. |
| R2 | PocketBase 1.0 öncesi; küçük sürümlerde kırıcı değişiklik | Yükseltmede kod değişir | Sürüm sabit; yükseltme önce dev'de, `go test` + P9.1 ile. |
| R3 | Sunucu dışı yedek yok (K-15); disk ya da VPS kaybı | Son haftalık Mac kopyasından sonrası kaybolur | Gece yedeği + haftalık Mac kopyası; uygulama yayına girmeden önce S3 uyumlu hedef alınması (env hazır). Telefonlardaki yerel DB + outbox ikincil kopya. |
| R4 | 4 GB RAM'i Coolify ile paylaşma; thumbnail ve büyük yükleme | OOM, konteyner yeniden başlar | Bellek sınırları + `GOMEMLIMIT`; thumbnail kapalı; dosya sınırları 20 MB; P9.3 ölçümü. |
| R5 | SQLite tek yazıcı; uzun push transaction'ı diğer yazmaları bekletir | Gecikme, "database is locked" | Paket 100 kayıt; busy timeout; P9.3'te p95 ölçümü. |
| R6 | PocketBase'te refresh token yok; 90 gün çevrimdışı kalan kullanıcı | Yeniden kodla giriş | K-6; outbox korunur, veri kaybolmaz. |
| R7 | Cron saat dilimi belirsiz (dokümanda yok) | Destek bildirimi yanlış saatte | P5.6'da kaynaktan doğrulanır. |
| R8 | Commit'ten önce gönderilen bildirim/e-posta (geri alınan yazma için bildirim) | Yanlış push | Commit sonrası hook (P5.6, P5.7). |
| R9 | OTP e-postası Hostinger limitleri / spam | Giriş yapılamaz | P4.2'de SPF/DKIM doğrulaması; limit teknik.md §13'te izleniyor; 60 sn sınırı ve hız sınırlayıcı. |
| R10 | Panelden elle şema değişikliği | Kod ve sunucu ayrışır | K-3, P2.8 şema özeti denetimi; superuser yalnız sende. |
| R11 | Superuser bilgisinin sızması | Tüm veri | Yalnız CLI ile açılır, parola yöneticisinde; isteğe bağlı IP sınırı; superuser için OTP/MFA (PocketBase üretim önerisi) P1.3'te açılabilir. |
| R12 | Dosya kaydı ile satır arası tutarsızlık (dosya yüklendi, satır reddedildi) | Sahipsiz dosya | Bugünkü Supabase davranışıyla aynı; P5.9 işletme silmede dosya koleksiyonlarını da temizler. |
| R13 | Lot QR'ları API alan adını taşıyor | Alan adı değişirse eski QR'lar kırılır | `arici-api.tutunsoft.com/l/...` kalıcı tutulur; değişirse eski adresten yönlendirme. |
| R14 | Supabase duraklatılmış projeyi süresiz saklamıyor | Eski veriye erişim | P0.2 ve P11.3 yedekleri kalıcı kopya. |
| R15 | FCM servis hesabı anahtarı daha önce sohbete yapıştırılmıştı | Kötüye kullanım | P5.6'da yeni anahtar, P11.3'te eskisinin iptali. |
| R16 | Hesap silme kalıcıdır | Yanlış testte gerçek veri kaybı | Silme testleri yalnız dev'de ve test hesaplarıyla; `deletion expire` prod'da çalışmaz. |
| R17 | KVKK: e-posta (Hostinger), FCM, Sentry yurt dışında | Aydınlatma metni eksik | P7.6'da gizlilik politikası güncellenir; Hostinger konumu kullanıcıya sorulur. |

## Geçiş günü kontrol listesi (P10)

Önce (P10.1):

- [ ] P9.2 e2e listesi tamamen ☑, P9.3 sonuçları sınırların içinde.
- [ ] Prod Coolify'da bütün ortam değişkenleri girili (adlar ortak bilgiler tablosundaki gibi), `PB_ENCRYPTION_KEY` prod'a özel.
- [ ] Prod `/api/health` 200, sertifika geçerli, `schema_check.sh` eşit.
- [ ] Prod superuser açık, parola yöneticisinde.
- [ ] Prod'da `seed demo` ve `seed verify-ref` geçti.
- [ ] Prod'un ilk yedeği alındı ve Mac'e indi; `restore_check.sh` başarılı.
- [ ] Supabase'in son yedeği (P0.2 betiği) alındı.
- [ ] Supabase `sync_push` donduruldu, 426 doğrulandı; Supabase verisi yerinde (sayım).

Geçiş (P10.2):

- [ ] Prod flavor varsayılanı PocketBase; build numarası artırıldı.
- [ ] `flutter clean` + prod AAB ve iOS derlemesi.
- [ ] Gerçek cihazda prod derlemesi: yeni e-postayla giriş, demo hesapla giriş, kayıt, ikinci cihazda görünme, foto yükleme, push.
- [ ] Lot sayfası prod adresinde HTML açılıyor.
- [ ] Coolify bildirimleri ve dışarıdan uptime denetimi açık.
- [ ] Gözlem süresinin başlangıç tarihi progress'te (P11.1 bu tarihten 14 gün sonra).

Geri dönüş tetikleyicileri (biri olursa P10.2 "Ters giderse" uygulanır): girişte e-posta gelmiyor ve 1 saatte çözülemiyor; senkronda veri kaybı ya da tekrarlayan 5xx; prod konteyneri bellek yüzünden yeniden başlıyor.

## Kapsam denetimi

Her Supabase parçası bir adıma bağlı:

| Supabase parçası | Adım |
| --- | --- |
| 35 senkron tablosu (+ enum, CHECK, FK, index) | P2.1–P2.6, P5.3 |
| invites, device_tokens, feedback, analytics_events, weather_cache, deletion_requests, deletion_log, deletion_codes, support_period_notifications | P2.7 |
| `set_server_seq`, `sync_seq`, `last_server_seq` | P2.1, P5.1 |
| `sync_push`, `sync_push_change`, `sync_pull` | P5.1–P5.3 |
| `guard_lot_publication`, `keep_hive_quarantine`, `check_customer_payment` | P5.3 |
| `set_own_member_name` | P5.3 |
| `create_organization`, istemcinin organizations sorgusu | P5.4 |
| `is_member`, `has_role`, tüm RLS politikaları | P3.1, P3.2 |
| `weather_locations`, weather-bundle | P5.5 |
| invite | P5.4 |
| device-token, notify, `notify_task_assigned`, `support_period_recipients`, `notify_support_periods`, cron 06:00 | P5.6 |
| feedback-mail, `notify_feedback_mail` | P5.7 |
| account-delete, 11 `account_deletion_*`, `deletion_hash`, `deletion_code_hash`, `account_deletion_grace`, `sync_member_deletion_schedule`, `cancel_deletion_on_sign_in` (kaldırılmıştı; karşılığı yok, bilinçli) | P5.8 |
| `account_deletion_cron`, `account_deletion_purge_records`, `account_deletion_storage_objects`, `retire_deleted_user_memberships`, `protect_deletion_log`, cron :17 | P5.9 |
| lot-page, `lot_public_page`, public-lots | P5.10 |
| `*_object_org_id` storage fonksiyonları ve storage politikaları; media, documents, receipts, feedback, org-logos | P6.1 |
| knowledge bucket + publish_knowledge | P6.2 |
| map-packs | Yok (kaldırılmıştı) |
| Auth OTP, şablon, SMTP, oturum, demo parola girişi | P4.1, P4.2, P7.2 |
| Vault ve secret'lar | P1.3, P4.2, P5.5–P5.7 |
| Yedek | P0.2, P1.4 |
| ref_drugs seed, ref_support_periods + admin SQL | P2.3, P2.6, P8.1 |
| demo_account.sql | P8.1 |
| pgTAP testleri | P2–P6 (Go testlerine taşınır) |
| Flutter'daki 20 dosya | P7.1–P7.5, P11.1 |
| integration_test, store_screenshots | P9.1, P11.2 |
| Gizlilik ve silme sayfaları | P7.6 |

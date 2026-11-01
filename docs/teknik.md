# Mobil Arıcı – Teknik Altyapı ve UI/UX Taslağı

Oct 21, 2026 · @Abdullah Tutun

Flutter istemci, Supabase backend ve cihazda tam çalışan yerel veritabanı üzerine kurulu offline-first bir mimari; arayüz eldivenle, güneş altında ve tek elle kullanım için tasarlanır.

## 1. Teknoloji yığını

Temel karar: Uygulama her zaman **yerel SQLite veritabanından** okur ve yazar; Supabase "gerçeğin yedeği ve ekip paylaşımı" rolündedir. Arayüz hiçbir zaman doğrudan ağa bağlı değildir.

| Katman | Seçim | Not |
| --- | --- | --- |
| Dil / framework | Flutter (stable), Dart 3 | Android öncelikli (sahada ağırlık Android), iOS aynı kod tabanından |
| State yönetimi | Riverpod (riverpod\_generator) | Test edilebilir, reaktif; yerel DB stream'leriyle doğal uyum |
| Navigasyon | go\_router | Derin bağlantı (QR okutunca kovan sayfası), sekmeli kabuk (StatefulShellRoute) |
| Yerel veritabanı | SQLite — Drift (reaktif sorgular, migration) | Senkron motoru bizim: outbox + delta çekme (3. bölüm) |
| Modeller | freezed + json\_serializable | Değişmez modeller, kopyalama, eşitlik |
| Backend | Supabase: Postgres, Auth, Storage, Edge Functions, pg\_cron | RLS ile çok kiracılı (işletme bazında) veri izolasyonu |
| Push bildirim | Firebase Cloud Messaging | Supabase push sağlamaz; tetikleme Edge Function'dan |
| Yerel bildirim | flutter\_local\_notifications | Hatırlatıcılar internetsiz çalar |
| Arka plan işleri | workmanager | Periyodik eşitleme, foto yükleme kuyruğu; ağ değişimi connectivity\_plus ile |
| Harita | flutter\_map + OpenFreeMap vektör karoları | Ücretsiz, API anahtarı yok, ticari kullanım serbest; veri OpenStreetMap (atfı zorunlu). Offline için bölge paketi indirme |
| QR / NFC | mobile\_scanner, nfc\_manager | Kovan etiketleri |
| Medya | camera / image\_picker, flutter\_image\_compress, record | Foto sıkıştırma, sesli not |
| Grafik | fl\_chart | Varroa, verim, finans grafikleri |
| Yerelleştirme | flutter\_localizations + ARB (intl) | Türkçe ve İngilizce ilk sürümden; cihaz diline göre, ayarlardan değiştirilebilir |
| Güvenli saklama | flutter\_secure\_storage | Oturum token'ları |
| Hata izleme | sentry\_flutter | Saha hataları offline birikir, ağ gelince gönderilir |
| Hava durumu | WeatherAPI.com (Edge Function üzerinden) | Sunucu tarafı önbellek, istemciye arılık bazında paket; ücretsiz plan ticari kullanıma açık, ayda 100 bin çağrı ve 3 günlük tahmin, 7 gün için Starter planı (13. bölüm kontrol listesi) |

Senkronizasyon hazır bir servis yerine kendi motorumuzla yapılır; ayrıntılar 3. bölümde.

## 2. Mimari

&#91;embedded content: uygulama mimarisi · cihaz ve Supabase\]

Ekranlar ağı asla beklemez: Her okuma ve yazma telefondaki SQLite'a gider, senkron ve medya yüklemesi ağ geldiğinde arka planda gerçekleşir. Supabase'e doğrudan giden tek çağrılar giriş ve Edge Function'lardır; push bildirimleri (FCM) ve hava durumu servisi Edge Function'lar üzerinden bağlanır.

## 3. Offline-first veri katmanı ve kendi senkron motorumuz

Karar: Hazır bir sync servisi kullanılmaz; **Drift (SQLite) + outbox + delta çekme** ile kendi senkron motorumuzu yazarız. İşletme başına veri hacmi küçük ve kayıtların çoğu "eklenir, değiştirilmez" olay tipinde olduğu için bu yaklaşım yönetilebilir; bedeli yaklaşık bir sprintlik ek geliştirme ve titiz test.

**Temel kurallar**

- **UUID'ler istemcide üretilir** (UUIDv7, zamana göre sıralı): Offline oluşturulan kovan anında gerçek kimliğine sahip olur, QR etiketine yazılabilir.
- **Her yazma, tek bir Drift transaction'ında yerel tabloya + outbox'a** gider; UI ağı hiç beklemez.
- **Olay tabanlı kayıtlar** (muayene, besleme, ilaçlama, hasat, varroa): Sadece eklenir; iki kişi aynı kovana offline muayene girse iki kayıt oluşur, çakışma olmaz.
- **Durum kayıtları** (kovan, arılık, ana arı, görev): Son yazan kazanır, `updated_at` ile.
- **Yumuşak silme:** `deleted_at` alanı; silme de bir güncellemedir ve diğer cihazlara ulaşır.
- **Türetilmiş alanlar yerelde hesaplanır:** Güç puanı, bekleme süresi kilidi, kışlık stok tahmini sunucuya ihtiyaç duymaz.
- **Kapsam:** Kullanıcı sadece üyesi olduğu işletmelerin verisini çeker (RLS zaten filtreler); fotoğraflar meta veri olarak iner, dosya istenince indirilir.

**Yerel yardımcı tablolar**

- `outbox`: id, tablo adı, satır id, işlem (upsert/delete), payload (JSON), oluşturulma zamanı, deneme sayısı, son hata.
- `sync_state`: tablo başına son çekilen imleç (`last_pulled_seq`).
- `sync_conflicts`: kullanıcıya gösterilecek kritik çakışmalar.

**Gönderme (push)**

1. Sync servisi outbox'ı oluşturulma sırasıyla 100'lük paketler halinde `sync_push` RPC'sine (Postgres fonksiyonu, tek transaction) yollar.
2. Sunucu her satırı idempotent upsert eder: Aynı paket tekrar gelirse zararsızdır. Durum tablolarında yalnızca gelen `updated_at` mevcut kayıttan yeniyse yazar.
3. Başarılı paket outbox'tan silinir. Geçici hata → üstel bekleme ile yeniden deneme; kalıcı hata (RLS reddi, geçersiz veri) senkron ekranında kullanıcıya gösterilir, kuyruğun geri kalanını kilitlemez.

**Çekme (pull)**

1. Postgres'te global bir sequence; her insert/update'te bir trigger satırın `server_seq` alanını günceller.
2. İstemci `sync_pull(since_seq)` RPC'si ile imleçten büyük satırları tablo tablo, sayfalı çeker.
3. Gelen satırlar Drift'e upsert edilir; outbox'ta bekleyen yerel değişikliği olan satır ezilmez (önce push, sonra pull).
4. İmleç sadece sayfa yerel DB'ye başarıyla yazılınca ilerler; kesilen senkron kaldığı yerden devam eder.
5. Eşzamanlı transaction'larda sıra atlamasını önlemek için çekme kısa bir geriye bakma payıyla yapılır; upsert idempotent olduğu için tekrar gelen satır zararsızdır.

**Çakışma ve zaman**

- Kovan sayısını etkileyen alanlarda (sönme, birleştirme, satış) çakışma sessizce çözülmez; `sync_conflicts`'e yazılır ve kullanıcıya sorulur.
- Cihaz saati yanlış olabilir: Sunucu her push'ta istemci saatinin sapmasını kontrol eder, büyük sapmada uyarı döner.

**Ne zaman çalışır**

- Uygulama açılışında, kayıttan kısa süre sonra (birkaç saniyelik gecikmeyle toplu), ağ geri geldiğinde (connectivity\_plus) ve arka planda periyodik (workmanager; Android'in arka plan kısıtlarına tabi).
- Yeni cihaz / ilk giriş: Sayfalı tam çekme, ilerleme çubuğuyla.
- Her istek `schema_version` taşır; sunucu desteklemiyorsa push reddedilir ve uygulama güncelleme ister — eski sürüm veriyi bozamaz.

**Medya kuyruğu**

1. Foto/ses çekilir → sıkıştırılır (uzun kenar \~1600 px) → uygulama klasörüne kaydedilir.
2. `media` tablosuna yerel yol + `upload_status = pending` satırı yazılır.
3. workmanager, ağ (ayarlara göre sadece Wi‑Fi) gelince Supabase Storage'a yükler, satırı `uploaded` yapar.
4. Başarısız yükleme üstel bekleme ile yeniden denenir; kullanıcı ayarlardan bekleyenleri görür.

**Senkron durumunun görünürlüğü:** Üst barda küçük bir bulut ikonu — eşitlendi / X kayıt bekliyor / hata. Arıcı "kaydettim mi?" diye hiç endişelenmemeli.

## 4. Supabase backend

Her veri bir **işletmeye (organization)** aittir; kullanıcı bir veya birden fazla işletmeye rol ile üyedir. Bu tek kural RLS'i, senkron kapsamını ve ekip kullanımını birlikte çözer.

**Kimlik doğrulama**

- Birincil: **E-posta + tek kullanımlık kod (OTP)** — Supabase Auth'un e-posta OTP akışı; kullanıcı e-postasına gelen 6 haneli kodu girer, şifre yok.
- E-posta teslimi için Hostinger'daki kendi alan adımızın bir posta kutusu (ör. no-reply@alanadi) Supabase'e özel SMTP olarak bağlanır (smtp.hostinger.com); SPF, DKIM ve DMARC kayıtları tanımlanır. Hostinger günlük gönderim limitini posta kutusu başına ve plana göre uygular (hosting'e dahil e-postada düşük, Business planlarda 1.000–3.000/gün); kayıt sayısı arttıkça plan yükseltilir. Kod e-postası kullanıcının diline göre Türkçe veya İngilizce şablonla gider.
- İkincil: Google ve Apple ile giriş.
- Oturum uzun ömürlü tutulur; offline iken süresi dolan token uygulamayı kilitlemez, ağ gelince sessizce yenilenir.
- Ekip daveti: E-posta adresine davet kodu.

**Temel tablolar**

| Tablo | İçerik | Tür |
| --- | --- | --- |
| organizations | İşletme, ülke kodu, bölge profili (TR / diğer), para birimi; yalnız TR'de: tescil no, AKS bilgileri | Durum |
| memberships | user\_id, org\_id, role (owner / partner / worker / viewer) | Durum |
| apiaries | Arılık, konum (PostGIS point), arazi sahibi, notlar | Durum |
| hives | Numara, QR/NFC kodu, tip, durum, güncel arılık, güncel ana | Durum |
| hive\_location\_history | Kovanın arılık geçmişi | Olay |
| queens | Ana arı kartı, yıl, renk, ırk, kaynak, anne ana | Durum |
| inspections | Muayene; standart alanlar + esnek `data jsonb` | Olay |
| treatments | İlaçlama: ürün, parti no, doz, başlangıç/bitiş, bekleme süresi | Olay |
| mite\_counts | Varroa ölçümleri | Olay |
| feedings | Besleme | Olay |
| harvests, lots | Hasat ve parti/lot; lot ↔ kovan ilişkisi | Olay |
| tasks | Görevler, atanan kişi, bağlı kovan/arılık, son tarih | Durum |
| inventory\_items, inventory\_moves | Stok kalemleri ve hareketleri | Durum / olay |
| migrations, migration\_stops | Gezginci göç planları ve taşımalar | Durum |
| transactions, customers | Gelir-gider, müşteri | Olay / durum |
| documents | Belge kasası, geçerlilik tarihi | Durum |
| media | Foto/ses meta verisi, storage yolu, bağlı kayıt | Olay |
| ref\_\* | Referans veriler: ilaçlar, ırklar, flora takvimi, hastalıklar — ülke koduna (veya GLOBAL) göre etiketli, TR/EN adlarla (salt okunur) | Referans |

Tüm senkronlanan tablolarda: `id uuid`, `org_id`, `created_at`, `updated_at`, `created_by`, `deleted_at`, `server_seq bigint` (senkron imleci). Senkron uçları Edge Function değil, Postgres RPC'leridir: `sync_push` ve `sync_pull` — RLS ile aynı kuralları kullanır.

**Row Level Security**

- Her tabloda RLS açık; politika tek bir yardımcı fonksiyon üzerinden: `is_member(org_id)` ve yazma için `has_role(org_id, ['owner','partner','worker'])`.
- Finans tabloları sadece owner/partner'a açık; worker muayene ve görev girer, para görmez.
- ref\_\* tabloları herkese salt okunur.

**Storage**

- `media` (private): `org_id/hive_id/uuid.jpg` yolu; erişim imzalı URL ile, policy yine üyeliğe bağlı.
- `documents` (private): belge kasası.
- `public-lots` (private): parti QR sayfasında gösterilmesine izin verilen analiz raporlarının kopyası. Dosyayı yalnız `lot-page` yayım durumunu denetleyerek sunar; yayımdan kalkan lotun raporu hemen erişilmez olur.

**Edge Functions**

- `weather-bundle`: Kullanıcının tüm arılıkları için WeatherAPI.com tahminini tek pakette döner, sunucuda önbellekler (çağrı sayısını düşük tutar). Anahtar `WEATHERAPI_KEY` secret'ında; uygulamada "Powered by WeatherAPI.com" atfı gösterilir.
- `notify`: Ekip görev ataması, kritik uyarı push'ları (FCM).
- `lot-page`: Parti QR'ı okutulduğunda herkese açık izlenebilirlik sayfası. Yazıldı ve deploy edildi, ama **şimdilik kullanıma kapalı**: Supabase varsayılan `*.supabase.co` alanında `text/html` yanıtını `text/plain`'e çeviriyor. Sayfa ancak özel alan adıyla (Supabase Custom Domain, ücretli) ya da önüne konan bir proxy ile (ör. ücretsiz Cloudflare Worker) HTML olarak açılır. Uygulamadaki "Herkese açık sayfa" bölümü `--dart-define=LOT_PAGE_BASE_URL=<sayfa kökü>` verilmeden derlenince gizli; alan adı hazır olunca bu değerle derlemek özelliği açar.
- `reports`: Denetim/sezon PDF raporları (alternatif: PDF cihazda üretilir, offline çalışır — tercih edilen).
- `invite`: Ekip davet kodu doğrulama.

**Zamanlanmış işler (pg\_cron):** Belge süre dolumu, destek başvuru dönemi gibi sunucu tarafı hatırlatmalar; kişisel hatırlatıcılar ise cihazda planlanır.

## 5. Flutter proje yapısı ve kod mimarisi

Özellik bazlı (feature-first) klasörleme + her özellikte üç katman: **data** (yerel DB, repository), **domain** (modeller, iş kuralları), **presentation** (ekranlar, widget'lar, Riverpod provider'ları).

```text
lib/
  main.dart
  app/
    app.dart              # MaterialApp.router, tema, l10n
    router.dart           # go_router, sekmeli kabuk, derin linkler
    bootstrap.dart        # DB açma, Supabase init, sync başlatma
  core/
    db/                   # Drift şeması, migration'lar
    sync/                 # outbox, push/pull, imleç, medya kuyruğu
    design_system/        # tokenlar, tema, ortak bileşenler
    l10n/                 # ARB dosyaları (tr, en ...)
    utils/                # tarih, birim, uuid v7, haptik
    services/             # konum, kamera, nfc, bildirim, ses
  features/
    today/                # Bugün paneli
    apiaries/
    hives/
    inspections/
    queens/
    health/               # varroa, ilaçlama, hastalık
    feeding/
    harvest/
    migration/            # gezginci
    tasks/
    inventory/
    finance/
    documents/
    knowledge/            # bilgi bankası, hesaplayıcılar
    settings/
    auth/
  each feature/
    data/  domain/  presentation/
```

**Kurallar**

- Ekranlar sadece provider dinler; provider'lar repository çağırır; repository yalnızca yerel DB ile konuşur. **Supabase istemcisi UI'da hiç görünmez** (auth ve edge function çağrıları hariç).
- Listeler DB'den `Stream` olarak gelir: Sync yeni veri indirdiğinde ekran kendiliğinden güncellenir.
- İş kuralları (güç puanı, bekleme süresi, ana renk kodu, şurup hesabı) saf Dart fonksiyonları — birim testine en uygun yer.
- Muayene formu şema-güdümlü: alanlar kod yerine bir yapılandırmadan üretilir; mevsim şablonları ve gelecekteki alanlar yeni sürüm gerektirmez.
- Flavor'lar: `dev`, `staging`, `prod` — ayrı Supabase projeleri.
- Kod üretimi: freezed, riverpod\_generator, json\_serializable, ARB → `build_runner`.

## 6. Saha teknolojileri

| İhtiyaç | Çözüm | Saha detayı |
| --- | --- | --- |
| Kovan tanıma | QR (mobile\_scanner) + NFC (nfc\_manager) | QR içeriği: `mobilarici://h/<uuid>` — uygulama içinde açılır, internet gerektirmez. Etiket PDF'i cihazda üretilir (A4'e 24 etiket), UV'ye dayanıklı etiket önerisi. NFC tag kovan içine/kapak altına. |
| Toplu kovan ekleme | "20 kovan oluştur, 101'den başla" | Etiketler toplu basılır, sahada okutularak eşleştirilir |
| Harita | flutter\_map + OpenFreeMap (ücretsiz, OSM verisi) | Ayarlar → "Bölgemin haritasını indir" (zoom aralığı sınırlı, boyut önceden gösterilir). Online görünüm OpenFreeMap'in herkese açık sunucusundan gelir. Offline bölge paketleri, OpenFreeMap'in yayımladığı MBTiles dünya dosyasından bölge bölge kesilip kendi depolamamızdan sunulur; böylece ücretsiz genel sunucuya toplu indirme yükü bindirilmez. |
| Konum | geolocator | Sadece arılık kaydı ve "yakınımdaki arılık" için; sürekli takip yok (pil) |
| Sesli not | record (AAC, düşük bit hızı) | Kayıt her zaman offline. Metne çevirme: cihazın yerleşik Türkçe tanıma desteği varsa anında, yoksa senkron sonrası sunucuda (ileri faz). |
| Sesli hızlı giriş (ileri faz) | Basit komut sözlüğü | "Ana var, yedi çerçeve, sakin" → form alanlarını doldurur |
| Foto | camera + sıkıştırma | Kovan kartından tek dokunuşla, muayeneye otomatik bağlanır |
| Bildirim | flutter\_local\_notifications + FCM | Hatırlatıcılar yerel; ekip atamaları push. Android'de kesin zamanlı alarm izni akışı düşünülmeli. |
| PDF / yazdırma | pdf + printing | Denetim raporu, ilaç kayıt defteri, etiketler — hepsi cihazda |
| Pil ve depolama | Ayarlar ekranı | Kullanılan alan, foto önbelleği temizleme, "sadece Wi‑Fi'da yükle" |

## 7. Tasarım dili

Uygulamanın adı **Mobil Arıcı**. Tasarım sistemi ve tüm ekran tasarımları bu bölümdeki dil esas alınarak Claude tarafından hazırlanır; ayrı bir tasarımcı yoktur. Ekran tasarımları `docs/design/` altında, ekran adıyla PNG olarak durur (ör. `Kovan kartı.png`); tasarım sisteminin kendisi `Tasarım sistemi v1.png`. Bir ekran yazılırken önce o ekranın tasarımı açılır.

Karakter: **Sıcak, sakin, güvenilir** — bal ve petekten ilham alan, ama "çocuk uygulaması" gibi durmayan, iş aracı ciddiyetinde bir arayüz. Material 3 temelinde, tokenlar `ThemeExtension` ile taşınır.

**Renk tokenları (tasarım sistemi v1)**

Kaynak `core/design_system/tokens/app_colors.dart`; güneş modu paletinin değerleri orada.

| Token | Açık tema | Koyu tema | Kullanım |
| --- | --- | --- | --- |
| primary (Koyu bal) | #9A5B00 | #FFB74D | Ana butonlar, seçili chip ve sekme |
| on-primary | #FFFFFF | #2B1700 | Primary üzerindeki yazı |
| honey (Bal) | #F2B544 | #F2B544 | Vurgu dolgusu, bildirimdeki Geri al |
| secondary (Çam yeşili) | #2F5D50 | #8CC7B4 | İşletme rozeti, ikincil vurgu |
| surface (Petek kreması) | #FFF8EE | #17140F | Ekran zemini |
| surface-container (Kart zemini) | #F6EBDA | #231F18 | Sayaç, not kartı, seçici izi |
| tile (Yüzey) | #FFFFFF | #2A251D | Kartlar, karolar, metin alanları |
| divider (Çizgi) | #E8DCC8 | #3B342A | Kart ve chip kenarlığı, ayraç |
| text-primary (Mürekkep) | #1F1A14 | #F3ECE2 | Ana metin, bildirim zemini |
| text-secondary | #5E554A | #BDB2A4 | Yardımcı metin |
| status-good / zemin | #2E7D32 / #E3F0E3 | #81C784 / #1E3320 | Güçlü kovan, eşitlendi |
| status-warning / zemin | #A23B00 / #FCE9DA | #FFAB40 / #3D2414 | Zayıf, süre yaklaşıyor |
| status-critical / zemin | #B3261E / #FBE3E3 | #EF9A9A / #3D1C1C | Anasız, bekleme süresi, ihbarı mecburi |
| status-info / zemin | #1557A8 / #E1ECF8 | #90CAF9 / #1A2A3D | Bilgi, görev |

Durum rozetleri ve uyarı kartları durumun açık zemininde, yazı ve ikon durum renginde çizilir. Güneş modunda birincil renk siyah.

Durum renkleri asla tek başına anlam taşımaz: her durum ikon + kelime ile birlikte gösterilir (renk körlüğü ve güneş altında okunabilirlik).

**Tipografi**

- Yazı tipi: Inter (ya da Nunito Sans) — Türkçe karakterlerde (İ, ı, ş, ğ) temiz, rakamlar tabular (sayı sütunları hizalı).
- Ölçek: Gövde 16, sahada 18; başlık 22/28 kalın; büyük sayılar (kovan no, kg, çerçeve) 32–40 kalın, kovan kartının numarası 72 — göz ilk sayıyı yakalar. Buton etiketi 18 kalın. Bölüm başlıkları küçük, kalın ve büyük harf ("ANA ARI"); büyük harf uygulamanın dilinin kuralıyla yapılır.
- Sistem yazı boyutu büyütmeye 1.5x'e kadar layout kırılmadan uyum.

**Ölçü ve biçim**

- 4/8 aralık sistemi; kart köşe yarıçapı 16, buton 12, chip ve rozet tam yuvarlak.
- Büyük buton 60dp (eldivende 68), chip 56dp.
- Dokunma hedefi: en az 48dp (Material), **sahada eylemler 56–64dp**; hedefler arası en az 8dp boşluk.
- Petek/altıgen motifi ölçülü: boş durum illustrasyonları, güç puanı rozeti, açılış ekranı. Her yerde altıgen = yorucu.
- İkonlar: Material Symbols (Rounded) + arıcılığa özel çizilmiş küçük set (kovan, ana arı, çerçeve, körük, kat, meme, varroa).

**Saha modları**

- **Standart:** Açık/koyu tema sisteme uyar.
- **Güneş modu:** Saf beyaz zemin, siyah metin, kalın kenarlıklar, kontrast 7:1 üzeri, gölge yok. Arılık turu başladığında tek dokunuşla.
- **Eldiven modu:** Tüm hedefler bir kademe büyük, kaydırma/sürükleme yerine büyük +/− butonlar, uzun basma gerektiren eylem yok.
- **Gece modu:** Akşam taşımaları için koyu, kırmızımsı düşük parlaklık (arıyı ışığa çekmemek için de faydalı).

## 8. Bilgi mimarisi ve navigasyon

Alt navigasyonda 4 sekme + ortada büyük bir **Okut / Kaydet** butonu: Sahada en sık hareket "kovanı okut → kaydet", bu yüzden başparmağın tam altında.

| Sekme | İçerik | Neden |
| --- | --- | --- |
| Bugün | Günlük panel: hava, bugünkü görevler, dikkat isteyen kovanlar, senkron durumu | Uygulama açılınca "ne yapmalıyım" cevabı |
| Arılıklar | Liste / harita geçişi → arılık → kovanlar → kovan kartı | Kayıtların ana hiyerarşisi |
| ● Okut / Kaydet | Dokun: QR/NFC okut. Basılı tut veya yukarı kaydır: hızlı kayıt menüsü (muayene, besleme, ilaçlama, hasat, not, gider) | Her yerden 1 dokunuşla kayıt |
| Görevler | Takvim + liste, filtre: bugün / bu hafta / arılığa göre | Hatırlatıcıların evi |
| Daha fazla | Ana arılar, hasat & lotlar, stok, finans, gezginci, belgeler, bilgi bankası, raporlar, ayarlar | Daha seyrek kullanılan modüller |

**Navigasyon kuralları**

- Kovan kartına her yoldan en fazla 2 adımda ulaşılır: okut, ya da arılık → kovan.
- Kovan kartı, kovanla ilgili tüm geçmişi tek zaman tünelinde gösterir (muayene, ilaç, besleme, hasat, foto) — ayrı sekmeler arasında gezinmek yok.
- Arılık bazında toplu işlem, arılık sayfasının üstündeki eylem çubuğunda.
- Kayıt formları tam ekran alt sayfa (bottom sheet) olarak açılır; arkadaki bağlam (hangi kovan) her zaman görünür kalır.
- Arama: Global arama çubuğu kovan no, arılık adı, ana arı, lot no ile çalışır — tamamen offline.

## 9. Ana ekranlar ve akışlar

**Bugün paneli**

- Üstte selam + tarih + senkron ikonu; altında yatay kayan arılık hava kartları (ikon, sıcaklık, rüzgar, "kovan açılır" rozeti).
- "Dikkat isteyenler" kartı: anasız, zayıf, oğul eğilimli, ilacı çıkarılacak kovanlar — sayı büyük, dokununca filtreli liste.
- Bugünün görevleri (arılığa göre gruplı) ve "yanına al" malzeme listesi.
- İlk kullanımda boş durum: "İlk arılığını ekle" tek büyük buton + 3 adımlı kurulum.

**Arılık detayı**

- Üstte harita şeridi, ad, kovan sayısı, son ziyaret.
- Kovan ızgarası: Her kovan bir karo — büyük numara, güç puanı noktaları (1–5), ana arı renk noktası, uyarı ikonu. Liste/ızgara/kroki (sıra dizilimi) görünümü.
- Eylem çubuğu: Tur başlat, toplu besleme, toplu ilaçlama, taşı.

**Kovan kartı**

- Başlık: Kovan no (çok büyük), arılık, durum rozeti; altında ana arı şeridi (renk, yaş, ırk).
- Özet kartları: Son muayene, aktif ilaç (bekleme süresi geri sayımı kırmızı), son varroa oranı, toplam verim.
- Zaman tüneli: Tüm olaylar ikonlu, tarih sıralı; foto küçük resimleri satır içinde.
- Alt sabit buton: **Muayene başlat**.

**Hızlı muayene akışı (hedef: 15–20 saniye)**

1. Kovanı okut → kovan kartı + alttan muayene sayfası açılır; önceki muayenenin değerleri soluk olarak ön dolu.
2. Ana arı: üç büyük chip — Görüldü / Yumurta var / Yok.
3. Çerçeve sayıları: Arılı, yavrulu, ballı — büyük +/− stepper'lar (eldivenle kaydırma yok).
4. Durum chip'leri: Mizac, oğul belirtisi, meme türü, hastalık şüphesi (şüphe seçilirse foto ve teşhis yardımcısı önerilir).
5. Yapılan işlem chip'leri: Kat verildi, çerçeve eklendi, besleme...
6. Mikrofon butonu her adımda görünür; foto butonu da.
7. **Kaydet** → haptik titreşim + "Kaydedildi, 7 gün sonra hatırlatayım mı?" ipucu + Geri al. Tur modundaysa otomatik sonraki kovana geçer.

**Arılık turu modu**

- Ekran açık kalır (wakelock), güneş modu önerilir.
- Üstte ilerleme: "14 / 40 kovan"; atlanan kovanlar listede kalır.
- Tur sonu özeti: anasız / zayıf / oğul eğilimli sayıları ve oluşturulan görevler; tek dokunuşla ekibe paylaş.

**Gezginci taşıma akışı**

1. Taşıma oluştur: kaynak arılık, hedef, araç.
2. Yükleme kontrol listesi → kovanları okutarak yükle (sayaç büyük).
3. Hedefte indirirken tekrar okut → eksik kovan varsa uyarı.
4. Kovanların konumu otomatik güncellenir, geçmişe yazılır.

**İlk kurulum (onboarding)**

- E-posta ve 6 haneli kod ile giriş → üç adım: (1) dil ve ülke (cihazdan önerilir; ülkenin açtığı modüller, birimler ve para birimi altta özetlenir; Türkiye seçilirse TR modülleri açılır), (2) işletme adı ve "Kaç kovanın var?" (kovan bazlı mı grup bazlı mı takip önerisini buna göre yapar), (3) ilk arılık (konumu GPS'ten) ve kovanları toplu oluştur. Toplam 2 dakikayı geçmemeli.

## 10. Etkileşim desenleri ve erişilebilirlik

**Desenler**

- **Onay yerine geri al:** "Emin misiniz?" diyaloğu yok; işlem anında yapılır, 6 saniyelik "Geri al" snackbar'ı çıkar. İstisna: kovan söndü/satıldı gibi sayıyı etkileyen kayıtlar.
- **Her dokunuş kayıttır:** Formlar taslak olarak anında yerelde saklanır; telefon cebe girse, uygulama kapansa bile kaldığı yerden devam.
- **Haptik geri bildirim:** Kaydet, okutma başarılı, uyarı — üç farklı titreşim; eldivenle ekranı görmeden onay alınır.
- **Akıllı varsayılanlar:** Son muayene değerleri ön dolu, tarih/saat/konum otomatik, en son kullanılan ilaç en üstte.
- **Chip > metin kutusu:** Klavye son çare; serbest metin yerine sesli not.
- **Boş durumlar öğretir:** Her boş liste ne işe yaradığını tek cümlede anlatır ve ilk eylemi sunar.
- **Kritik uyarılar engelleyicidir:** Bekleme süresindeki kovana hasat veya bal katı — tam genişlikte kırmızı kart, bilerek geçilirse gerekçe istenir.
- **Animasyonlar kısa ve anlamlı:** 150–250 ms; kaydetmede kovan karosunun güç puanı noktalarının dolması gibi küçük ödüller. "Azaltılmış hareket" ayarına uyar.

**Erişilebilirlik**

- Kontrast: Metin için en az 4.5:1, güneş modunda 7:1.
- Tüm ikonlu butonlarda ekran okuyucu etiketi (Semantics), Türkçe.
- Sistem yazı boyutu 1.5x'e kadar desteklenir; sayılar ve kovan numaraları kırılmaz.
- Renk körlüğü: Durum = renk + ikon + kelime; ana arı renk kodu yanında yıl yazılır.
- Tek elle kullanım: Birincil eylemler ekranın alt yarısında; üst köşe yalnızca ikincil.
- Okuma-yazma seviyesi düşük kullanıcı: Kısa kelimeler, saha terimleri, ikon + etiket birlikte; sesli not her yerde.

## 11. Kalite: güvenlik, test, izleme, CI/CD

**Güvenlik ve KVKK**

- RLS her tabloda zorunlu; RLS'siz tablo migration'ı CI'da reddedilir (otomatik kontrol).
- `service_role` anahtarı sadece Edge Function'larda; istemcide yalnızca anon/public anahtar.
- Kişisel veri: e-posta, arazi sahibi iletişimi, müşteri bilgileri — KVKK (TR) ve GDPR (AB kullanıcıları) aydınlatma metni, açık rıza ve hesap/veri silme akışı uygulama içinde.
- Veri bölgesi: Supabase projesi Türkiye'ye en yakın bölgede (ör. Frankfurt); yurt dışı aktarımı için KVKK yükümlülükleri hukuk danışmanıyla netleştirilmeli.
- Yerel DB: Cihaz kaybolursa finans ve müşteri verisi için isteğe bağlı uygulama kilidi (PIN/biyometrik).

**Test stratejisi**

- Birim test: İş kuralları (güç puanı, bekleme süresi, şurup, ana renk kodu, stok düşümü) — %90+ kapsama hedefi.
- Repository testleri: Bellek içi SQLite ile.
- Widget ve golden testler: Tasarım sistemi bileşenleri, 3 tema × 2 yazı boyutu.
- Senkron testleri: "Offline 3 gün, iki cihaz aynı arılığa yazıyor" senaryoları; uçtan uca staging Supabase'e karşı.
- RLS testleri: Supabase tarafında SQL testleri (ör. pgTAP) — "worker finansı göremez".
- Saha testi: Her sürümden önce gerçek arılıkta, eldivenle, uçak modunda bir tur. Düşük donanımlı bir Android cihaz test listesinde mutlaka olmalı.

**İzleme**

- Sentry: Çökme ve hata; offline oturumların hataları kuyrukta bekler.
- Ürün analitiği (gizlilik dostu, olay bazlı): Muayene süresi, okutma başarı oranı, senkron gecikmesi, en çok kullanılan chip'ler — UX kararlarının verisi.

**CI/CD**

- GitHub Actions (veya Codemagic): lint (very\_good\_analysis), test, build.
- Supabase migration'ları repoda (`supabase/migrations`), staging → prod sıralı dağıtım.
- Dağıtım: Play Console iç test → açık test (beta) → aşamalı yayın; iOS için TestFlight.
- Uygulama içi "zorunlu güncelleme" kontrolü: Senkron şeması değiştiğinde eski sürümlerin veri bozmaması için.

## 12. Çok dil ve bölge profili (TR / Diğer)

Mobil Arıcı tüm dünyada kullanılacak; Türkiye'ye özel her şey bir **bölge profili** arkasında durur: TR profilinde görünür, diğer ülkelerde gizli ve pasiftir.

**Dil (i18n)**

- Türkçe ve İngilizce ilk sürümden: `app_tr.arb`, `app_en.arb`. Varsayılan cihaz dili; desteklenmeyen dillerde İngilizce.
- Dil ile ülke bağımsızdır: Türkiye'de İngilizce ya da yurt dışında Türkçe kullanan arıcı desteklenir.
- Referans veriler ve bilgi bankası çok dilli alanlarla tutulur; içerik çevirisi arayüz çevirisinden ayrı bir iş kalemidir.
- Tarih, sayı ve para biçimleri `intl` ile; birim tercihi: kg/lb, °C/°F, L/gal.

**Bölge profili**

- İşletme kurulurken ülke seçilir (cihaz konumundan önerilir); `organizations.country_code` tüm cihazlara senkronlanır. Profil şimdilik `TR` veya `OTHER`; ileride ülke ülke genişletilebilir.
- Kararlar tek bir `RegionConfig` üzerinden verilir; ekranlar ülke kodunu doğrudan kontrol etmez. Özellik bayrakları yerelde değerlendirilir, offline çalışır.

| Özellik | TR profili | Diğer ülkeler |
| --- | --- | --- |
| AKS, işletme tescil no, birlik üyeliği | Görünür | Gizli; yerine serbest "kayıt numarası" alanı |
| Arılı kovan desteği ve destek hatırlatıcıları | Görünür | Gizli |
| Mevzuat kütüphanesi | TR mevzuat özetleri | Gizli |
| Gezginci belgeleri | TR belge türleri (nakil evrakı, sağlık raporu vb.) | Genel belge kasası, kullanıcı tanımlı türler |
| İhbarı mecburi hastalık iletişimi | İl/ilçe tarım müdürlüğü rehberi | Kullanıcının girdiği yerel otorite + genel uyarı |
| İlaç listesi | TR'de ruhsatlı ürünler | Etken madde bazlı genel liste, kullanıcı ekleyebilir |
| Flora takvimi | TR bölgeleri hazır gelir | Boş başlar; kullanıcı kendi takvimini oluşturur |
| Mevsim şablonları | Kuzey yarımküre | Konumun yarımküresine göre (Güney'de \~6 ay kayar) |
| Para birimi | TRY | Ülkenin para birimi |

- Gizlenen modüllerin verisi silinmez; ülke sonradan değişirse kayıtlar yeniden görünür.
- Referans tablolar `country_code` (veya `GLOBAL`) ile etiketlenir; senkron yalnızca ilgili ülkenin ve global setin verisini indirir.

## 13. Geliştirme yol haritası (MVP)

Kaba tahmin: 1–2 Flutter geliştirici ile **7 sprint (2'şer hafta) ≈ 14 hafta** sonunda Google Play açık test (beta) sürümü. Kendi senkron motorumuz için ayrı bir sprint ayrıldı; ekran tasarımları her sprintin önünde Claude tarafından hazırlanır. Sezon açısından ideal: Kışın geliştir, ilkbahar açılışında beta.

| Sprint | Kapsam | Bittiğinde |
| --- | --- | --- |
| 0 | Proje iskeleti, flavor'lar, tasarım sistemi tokenları, Supabase şema v1 + RLS, e-posta kodu ile giriş (Hostinger SMTP), TR/EN dil ve bölge profili altyapısı | Giriş yapılıp boş "Bugün" ekranı görülür |
| 1 | Drift yerel DB, arılık ve kovan kayıtları, toplu kovan oluşturma, QR etiket üretme/okuma — tamamen offline | Arılık kurulur, kovan okutulur — uçak modunda |
| 2 | Senkron motoru: outbox + `sync_push`, `sync_pull` + imleç, çakışma kuralları, senkron durum ikonu, otomatik senkron testleri | İki cihaz offline çalışıp veri kaybı olmadan eşitlenir |
| 3 | Hızlı muayene, kovan kartı zaman tüneli, foto ve sesli not kuyruğu | 20 saniyelik muayene gerçek kovanda denenir |
| 4 | Ana arı kartı, varroa ölçümü, ilaç kayıt defteri + bekleme süresi kilidi, besleme | Sağlık kayıtları eksiksiz |
| 5 | Görevler ve bildirimler, Bugün paneli, hava durumu edge function, basit hasat | Uygulama "ne yapmalıyım"ı söyler |
| 6 | Arılık turu modu, güneş/eldiven modu, PDF çıktıları, performans ve ekibin kendi saha testleri, uygulama içi "Görüş bildir" | Google Play açık test (beta) |

**Başlamadan önce netleşmesi gerekenler**

- [ ] Hostinger e-postası: gönderim adresi, SPF/DKIM/DMARC kayıtları ve planın günlük limitinin beklenen kayıt sayısına yetip yetmediği.
- [ ] WeatherAPI.com planı: Ücretsiz plan ticari kullanıma açık; ayda 100 bin çağrı ve 3 günlük tahmin veriyor, atıf rica ediyor. 7 günlük tahmin ya da kullanıcı sayısı artınca daha fazla çağrı için Starter ve üstü plan gerekir.
- [ ] Offline harita paketleri için bölge kesme ve barındırma (OpenFreeMap MBTiles → bölge paketleri → depolama).
- [ ] İngilizce mağaza adı ve açıklaması (Mobil Arıcı markası korunarak).
- [ ] Pilot grup olmadığı için geri bildirim kanalı: Uygulama içi "Görüş bildir", beta yorumları ve kullanım analitiği ilk sürümden itibaren açık.
- [ ] Tasarım sistemi ve ana ekranların tasarımı (TR ve EN metinlerle), sprint 1 bitmeden (Claude).

## Kaynaklar

- [OpenFreeMap](https://openfreemap.org)
- [WeatherAPI.com planları](https://www.weatherapi.com/pricing.aspx)
- [Hostinger e-posta limitleri](https://support.hostinger.com/en/articles/4625828-parameters-and-limits-of-hostinger-email)

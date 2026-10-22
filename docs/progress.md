# İlerleme

## Tamamlanan adımlar

### 2026-10-21 — Proje iskeleti

- Flutter projesi oluşturuldu (Android + iOS). Uygulama kimliği `com.abdullahtutun.mobilaricilik`, Dart paket adı `mobil_aricilik`.
- Temel paketler eklendi: flutter_riverpod + riverpod_generator, go_router, freezed + json_serializable, drift (+ drift_dev), intl, flutter_localizations. Lint: very_good_analysis.
- `dev` ve `prod` flavor'ları kuruldu: Android'de productFlavors, iOS'ta `Debug|Release|Profile-dev/prod` yapılandırmaları ve `dev`/`prod` şemaları. Dev kimliği `.dev` ekli ve adı "Mobil Arıcılık Dev"; iki sürüm aynı cihaza birlikte kurulabilir. Girişler `lib/main_dev.dart` ve `lib/main_prod.dart`; `lib/main.dart` yok. `bootstrap` ile native `--flavor` uyuşmazsa uygulama başlamaz.
- teknik.md 5. bölümdeki klasör yapısı boş olarak kuruldu (`.gitkeep`). `app/` altında `MaterialApp.router` + tek rotalı go_router var; `TodayScreen` ortada ARB'den gelen "Mobil Arıcılık" yazısını gösteriyor.
- TR/EN ARB altyapısı kuruldu (`lib/core/l10n/`, çıktı `generated/`). Widget testi iki yerelde de başlığı doğruluyor.

### 2026-10-21 — Tasarım tokenları ve temalar

- `core/design_system/tokens/` altında altı `ThemeExtension` var: `AppColors` (açık/koyu/güneş paletleri), `AppTypography` (Inter, tüm stillerde tabular rakam; gövde standartta 16, sahada 18; başlık 22/28; sayılar 32/40 kalın), `AppSpacing` (4/8), `AppRadii` (8/12/16), `AppTouchTargets` (48/56/64, eldivende 56/64/72) ve `AppStrokes` (güneşte kalın). Bileşenler bunlara `context.colors`, `context.spacing` gibi erişimcilerle ulaşır. Tek import: `design_system.dart`.
- Inter 4.1 (Regular/Medium/SemiBold/Bold TTF) `assets/fonts/inter/` altına gömüldü, internet gerekmez. OFL lisansı `bootstrap` içinde `LicenseRegistry`'ye kaydedildi.
- Görünüm `AppearanceSettings` (freezed) ile tutuluyor: renk modu (`system`/`light`/`dark`/`sun`) ve ondan bağımsız eldiven modu. Seçim `appearanceProvider` (keepAlive) içinde. `AppTheme` bu ayardan M3 `ThemeData` üretir ve `App`'e bağlıdır. Güneş modu cihaz koyu olsa da beyaz kalır ve gölge çizmez. Eldiven modunda `visualDensity` +2 olur, Material bileşenleri de 8dp büyür.
- Token testleri kontrastı ölçüyor: standart temada metin en az 4.5:1, durum renkleri ve kenarlık en az 3:1; güneş modunda her çift en az 7:1. Bunun yanında ölçek değerleri, lerp/copyWith, tüm mod birleşimleri, provider ve mod değişince `App` temasının değişmesi de test ediliyor.

### 2026-10-21 — Ortak bileşenler ve bileşen galerisi

- `core/design_system/components/` altında yedi bileşen var: `BigButton` (birincil/ikincil), `ChoiceChipGroup` (tek/çok seçim; seçili chip'te onay ikonu var, tek seçimde seçili chip'e tekrar dokunmak seçimi kaldırır), `BigStepper` (sınırda ilgili buton pasifleşir, ekran okuyucu onu ayarlanabilir değer olarak okur), `StatusBadge` (`AppStatus` ile renk + ikon + kelime), `HiveTile`, `EmptyState` (petek altıgeniyle) ve `SectionCard`. Hepsi yalnızca token kullanıyor. Material butonlarında tema yoğunluğu kapalı; yoksa eldiven büyümesi iki kez eklenirdi.
- Eksik tokenlar eklendi: `AppSizes` (ikon, güç noktası, ana arı noktası, illüstrasyon) ve `AppColors` içinde beş ana arı işaret rengi (`QueenMarkColor`). `HiveTile` bir renk enum'u alıyor; yıldan renge kuralı ana arı adımında yazılacak.
- Flavor artık `flavorProvider` ile taşınıyor: `bootstrap` override ediyor, varsayılanı prod. Dev flavor'da Bugün ekranındaki geliştirici ikonu `/dev` (Geliştirici menüsü), oradan `/dev/components` (Bileşen galerisi) açılıyor. Prod'da bu rotalar hiç kaydedilmiyor.
- Galeri her bileşeni açık, koyu, güneş ve eldiven panellerinde alt alta gösteriyor; örnekler `GalleryComponent` enum'unda. Galeri metinleri ve bileşenlerin ekran okuyucu metinleri ARB'de (TR + EN).
- Golden testler galerideki bölümlerin aynısını çiziyor (`test/core/design_system/components/goldens/`, 7 görüntü). Aynı klasördeki `flutter_test_config.dart` Inter ve Material Icons'ı yüklüyor. Goldenlar macOS'ta üretildi; Linux CI'da piksel farkı çıkabilir. Bunlara ek olarak seçim, sayaç sınırları, karo semantiği ve dev/prod rota kapısı için davranış testleri var.

### 2026-10-21 — Dil seçimi, biçimleme ve birimler

- Dil seçimi `languageProvider` (keepAlive) içinde tutuluyor. `AppLanguage` değerleri `system`, `turkish` ve `english`; `App` seçimi `locale` olarak kullanıyor. Cihaz dili `resolveAppLocale` ile çözülüyor: cihazın dil listesinde desteklenen ilk dil seçiliyor, ülke kodu dikkate alınmıyor; desteklenen dil yoksa İngilizce açılıyor. Ayarlar ekranındaki seçici ayarlar adımında gelecek.
- `core/utils/app_format.dart` içindeki `AppFormat` tarih (`21 Eki 2026` / `Oct 21, 2026`), kısa tarih, saat, sayı, yüzde ve para (ISO 4217 koduyla, ör. `₺1.234,50`) biçimliyor. Widget içinde `AppFormat.of(context)` uygulamanın dilini kullanıyor.
- `core/utils/units.dart` içinde `MassUnit` (kg/lb), `TemperatureUnit` (°C/°F) ve `VolumeUnit` (L/ABD galonu) var; çeviri `convert(value, to:)` ile yapılıyor. Çarpanlar tanımdaki tam değerler (1 lb = 0,45359237 kg, 1 gal = 3,785411784 L).
- Galeri ve boş durum metinleri zaten ARB'deydi. Kovan karosunun ekran okuyucu metnindeki `', '` ayırıcısı da `listSeparator` anahtarına taşındı. Kodda kalan `'101'` gibi örnek kovan numaraları metin değil, veri.
- Testler: dil çözümü (desteklenmeyen dil, boş liste, ikinci tercih), provider, `App`'te seçilen dilin cihaz dilinin önüne geçmesi, TR/EN biçim çıktıları, birimlerde bilinen noktalar ve gidiş-dönüş.

### 2026-10-21 — Bölge profili (RegionConfig)

- `core/region/region_config.dart` içindeki saf `resolveRegionConfig(countryCode, latitude:)` freezed `RegionConfig` üretiyor. İçinde ülke kodu, profil (`TR` → `RegionProfile.tr`, diğer her kod → `other`), `RegionFeatures` (aks, subsidies, regulations, trDrugList, trFlora, trMigrationDocs; TR'de hepsi açık, diğerlerinde kapalı), ISO 4217 para birimi, `DefaultUnits` ve `Hemisphere` var. Kod `tr` gibi gelse de büyük harfe çevriliyor. Kod iki harf değilse ya da enlem -90..90 dışındaysa `ArgumentError` atılıyor.
- Para birimi `country_currencies.dart` tablosundan geliyor: Antarktika dışındaki 248 ISO 3166-1 ülkesi ve Kosova. Tabloda olmayan kodda USD. Tablo macOS'un CLDR verisiyle karşılaştırıldı. İki bilinçli fark var: Lesotho `LSL` (CLDR `ZAR`) ve Venezuela `VES` (CLDR `VED`). Bulgaristan 2026'dan beri `EUR`.
- Varsayılan birimler: ABD ve bağlı bölgeleri, Palau, Mikronezya, Marshall Adaları ve Liberya'da lb/°F/galon; Bahamalar, Belize ve Cayman'da yalnız sıcaklık °F; geri kalanı metrik. Yarımküre enlemden çıkıyor (0° Kuzey), enlem yoksa Kuzey. TR profili enlemden bağımsız olarak hep Kuzey.
- Seçim `regionSelectionProvider` (keepAlive) içinde tutuluyor: `RegionSettings` varsayılanı `TR`, enlem null. `setCountry` ve `setLatitude` ile değişiyor; geçersiz girişte seçim olduğu gibi kalıyor. Ekranlar yalnızca `regionConfigProvider`'ı dinleyecek. Yapılandırma aynı kalırsa (ör. aynı yarımkürede enlem değişirse) dinleyenler uyarılmıyor. Seçici arayüz ayarlar adımında gelecek.
- 46 yeni test: kod biçimi, yarımküre sınırları (ekvator, -0, kutuplar, NaN), iki profilin tam yapılandırması, para birimi ve birim istisnaları, provider akışı ve gereksiz bildirim olmaması. Bağımlı provider bir sonraki `pump`'ta yeniden kurulduğu için dinleyici testleri `container.pump()` bekliyor.

### 2026-10-21 — Sekmeli kabuk, Okut butonu ve ayarlar

- Router `StatefulShellRoute.indexedStack` ile dört dala ayrıldı: Bugün (`/`), Arılıklar (`/apiaries`), Görevler (`/tasks`), Daha fazla (`/more`). Her sekme kendi yığınını koruyor; açık sekmeye yeniden dokunmak başa dönüyor. Sekme ekranları şimdilik `EmptyState` gösteriyor. Dev menüsü yine Bugün'ün üst çubuğunda.
- `app/shell/` altında token tabanlı `AppNavigationBar` var: iki yanda ikişer sekme, ortada büyük Okut butonu (`fieldLarge`). Seçili sekme renk, dolu ikon ve kalın etiketle gösteriliyor. Butona dokunmak kabuğun üstünde açılan `/scan` yer tutucusunu açıyor. Basılı tutmak kök navigator'da hızlı kayıt menüsünü açıyor: muayene, besleme, ilaçlama, hasat, not, gider. Seçim şimdilik "yakında" bildirimi gösteriyor. Butonda tooltip yok, çünkü uzun basmayla çakışır. Ekran okuyucu basılı tutma ipucunu okuyor.
- Daha fazla → Ayarlar (`/more/settings`) ekranında dil (Sistem/Türkçe/English) ve tema (Sistem/Açık/Koyu/Güneş) chip'leri var. Ülke seçimi geçici: `/more/settings/country` para birimi tablosundaki 249 kodu "DE · EUR" biçiminde adsız listeliyor. Seçimler mevcut provider'lara yazılıyor; seçili chip'e yeniden dokunmak seçimi kaldırmıyor.
- Derin link hazırlığı: `app/deep_link.dart` içindeki `deepLinkLocation`, `mobilaricilik://x/y?q` adresini `/x/y?q` yapıyor (host ilk yol parçası). Bu çevrim router'ın üst düzey `redirect`'inde çalışıyor. Eşleşmeyen konumlar `onException` ile Bugün'e düşüyor. Şema AndroidManifest'e (VIEW/BROWSABLE intent-filter) ve Info.plist'e (`CFBundleURLTypes`) kaydedildi. Flutter iki platformda da tam URI'yi iletiyor.
- 26 yeni test: derin link çevrimi, sekmeler ve yığın korunması, Okut'a dokunma ve basılı tutma, menünün alttaki sekme yığınını kapatmaması, ekran okuyucu eylemleri, dokunma hedefleri (eldiven dahil), 360dp ekranda 1.5x yazı ve eldivenle taşma olmaması, platformdan gelen ve soğuk açılış derin linkleri, ayarlardaki üç seçim.

### 2026-10-21 — Supabase şema v1: işletmeler, üyelikler, RLS

- `supabase/` klasörü Supabase CLI ile kuruldu (`supabase init`, varsayılan `config.toml`, Postgres 17). İlk migration `20261021200110_organizations_memberships.sql`. İki tablo var: `organizations` (ad, `country_code`, `currency`, `tr_registration_no`, `tr_aks_no`) ve `memberships` (`org_id`, `user_id`, `role` enum: owner/partner/worker/viewer). İkisinde de standart alanlar var: istemcide üretilen `id`, `created_at`, `updated_at`, `created_by`, `deleted_at`, `server_seq`. Bir kullanıcının bir işletmede yalnız tek etkin üyeliği olabilir.
- Global `private.sync_seq` ve genel `private.set_server_seq()` trigger'ı her insert ve update'te `server_seq`'i yeniden yazıyor; istemcinin gönderdiği değer yok sayılıyor. `private` şeması API'ye açık değil. `is_member(org_id)` ve `has_role(org_id, roles[])` burada duruyor, güvenlik tanımlı. Çıkarılmış (`deleted_at` dolu) üyelik bu kontrollerde sayılmıyor.
- RLS iki tabloda da açık. Üyeler işletmeyi ve üyeliklerini görüyor. Kullanıcı kendi çıkarıldığı üyeliği de görüyor, cihazı çıkarıldığını böyle öğrenecek. İşletmeyi yalnız owner güncelliyor; partner, worker ve viewer yalnız okuyor. Giriş yapmış her kullanıcı `created_by` kendisi olacak şekilde işletme oluşturabiliyor; `add_owner_membership` trigger'ı onu owner yapıyor. Üye ekleme ve değiştirmeyi yalnız o işletmenin owner'ı yapıyor. Hiçbir tabloda silme politikası yok, silme `deleted_at` ile yapılıyor.
- `supabase/tests/database/` altında 27 pgTAP testi var: üye olmayan ve anon göremez; worker ve partner işletmeyi güncelleyemez, owner günceller; başkası adına işletme oluşturulamaz; oluşturan owner olur; worker üye ekleyemez ve rolünü yükseltemez; owner başka işletmeye üye ekleyemez; çıkarılan üye erişimini kaybeder. Bunlara ek olarak `server_seq` davranışı ve public şemasında RLS'siz tablo olmadığı test ediliyor. Çalıştırma: `supabase start` sonra `supabase test db`.

### 2026-10-21 — Supabase şema v2: arılıklar, kovanlar, ana arılar

- Migration `20261021201714_apiaries_hives_queens.sql` dört tablo ekliyor: `apiaries`, `queens`, `hives` ve olay tablosu `hive_location_history` (kovan, arılık, `moved_at`). Alanlar teknik.md §4 ile ozellikler.md §1 ve §3'teki kart alanlarından alındı. Arılıkta şu alanlar var: konum `geography(Point, 4326)` (PostGIS `extensions` şemasında; boş olabilir), rakım, arazi sahibi ve telefonu, arazi durumu, su kaynağı, araca uzaklık, yol notu ve not. Kovanda numara, etiket kodu, tip, durum, arılık, ana, kat ve çerçeve sayısı, kaynak ve işaret var. Anada yıl, işaret rengi, ırk, hat, kaynak, çiftleşme durumu, kanat kesimi ve anne ana var.
- Seçimli alanlar Postgres enum'u olarak tanımlandı. `hive_status` yaşam döngüsünü tutuyor: active/dead/merged/sold/lost. Güç burada tutulmuyor, yerelde hesaplanıyor. `queen_mark_color` istemcideki `QueenMarkColor` ile aynı. Kovan tipine `other` eklendi. Kovan numarası tekrar edebilir. Etiket kodu ise işletmenin silinmemiş kovanları arasında tekil; silinen kovanın etiketi yeniden kullanılabiliyor.
- Aynı işletme kuralı bileşik yabancı anahtarla kuruldu. Her tablo `unique (id, org_id)` taşıyor; bağlar `(apiary_id, org_id)`, `(queen_id, org_id)`, `(mother_queen_id, org_id)` ve `(hive_id, org_id)` üzerinden kuruluyor. Yabancı anahtar denetimi RLS'e takılmaz; bu kısıt olmasa id'yi bilen bir üye kendi kovanını başka işletmenin arılığına ya da anasına bağlayabilirdi. Kovanı olan arılık başka işletmeye geçirilemiyor, ana da kendi annesi olamıyor. Dört tabloda `set_server_seq` trigger'ı ve RLS var: üyeler okur; owner, partner ve worker ekler ve günceller; viewer yalnız okur. Silme politikası yok.
- 40 yeni pgTAP testi eklendi, toplam 67. `hives_rls` (21): başka işletmenin dört tablodaki kaydı görülemiyor, güncellenemiyor, o işletmeye kayıt eklenemiyor; worker yazabiliyor; viewer dört tabloda da ekleyemiyor ve güncelleyemiyor. `hives_consistency` (18): işletmeler arası her bağ 23503 ile reddediliyor; etiket tekilliği, anne ana kontrolü ve konumun nokta olması da test ediliyor. `sync_seq` testine, `server_seq` kolonu olan her tabloda trigger bulunduğu kontrolü eklendi.

### 2026-10-21 — E-posta OTP şablonu

- `supabase/templates/otp.html` tek bir TR/EN şablon. İçinde yalnız `{{ .Token }}` var, link yok. Yeni kullanıcıya "Confirm signup" (e-posta onayı açıksa), mevcut kullanıcıya "Magic Link" şablonu gidiyor; bu yüzden panelde ikisine de aynı dosya yapıştırılıyor. Dil `user_metadata.locale` alanından seçiliyor: `"tr"` ise Türkçe, başka bir değerde ya da alan boşsa İngilizce. Bu, uygulamadaki dil çözümüyle aynı. Konu satırı da aynı koşulla iki dilli.
- Yerel `config.toml` içinde `confirmation` ve `magic_link` şablonları bu dosyaya bağlandı. `otp_expiry` 3600'den 600'e indi. Şablondaki "10 dakika" metni bu değere bağlı; biri değişirse öbürü de değişmeli. Hostinger SMTP ve DNS ayarları panelde elle yapılacak, repoda SMTP bilgisi yok.
- Yerelde denendi. `tr`, `en` ve locale'siz yeni kullanıcı ile mevcut kullanıcı için Mailpit'e doğru dilde konu ve gövde düştü. Locale boşken şablon hata vermiyor. E-postadaki kod `verify` (`type: email`) ile oturum açtı, aynı kodun ikinci kullanımı `otp_expired` döndü. Yeni kod istemek eskisini geçersiz kılıyor. Görünüm 360dp genişlikte kontrol edildi.
- `signInWithOtp` içindeki `data` yalnız kullanıcı ilk oluşturulurken yazılıyor; mevcut kullanıcıda yok sayılıyor (denendi). Auth adımında ilk istek `data: {'locale': languageCode}` göndermeli, dil değişince de `updateUser` ile locale güncellenmeli. Yoksa e-posta ilk kayıttaki dilde gider. Davet, e-posta değişikliği ve şifre sıfırlama şablonları varsayılan İngilizce kaldı.

### 2026-10-22 — Uygulama adı: Mobil Arıcı

- Uygulamanın adı "Mobil Arıcılık"tan "Mobil Arıcı"ya değişti. ARB'deki `appTitle` (TR/EN) ve üretilen l10n dosyaları güncellendi. Android'de `appName` placeholder'ı ve iOS'ta altı yapılandırmadaki `APP_DISPLAY_NAME` değişti; dev sürümün adı artık "Mobil Arıcı Dev". OTP şablonunda ve `config.toml` konu satırlarında da yeni ad var; Türkçe ek "Mobil Arıcı'ya" oldu. CLAUDE.md, README, `pubspec.yaml` açıklaması, ozellikler.md ve teknik.md de güncellendi. Pencere başlığı testi yeni adı bekliyor.
- Teknik kimlikler değişmedi: Dart paket adı `mobil_aricilik`, uygulama kimliği `com.abdullahtutun.mobilaricilik`, derin link şeması `mobilaricilik://`, Supabase `project_id` ve klasör adı. Uygulama kimliği mağazaya çıktıktan, şema da QR etiketlere basıldıktan sonra değiştirilemez. Değiştirilecekse ilk yayından ve ilk etiket baskısından önce yapılmalı.
- OTP şablonu Supabase paneline daha önce yapıştırıldıysa, yeni dosya "Confirm signup" ve "Magic Link" şablonlarına yeniden yapıştırılmalı. Konu satırları da elle güncellenmeli.

## Notlar

- Çalıştırma: `flutter run --flavor dev -t lib/main_dev.dart` (prod için `prod` / `main_prod.dart`). VS Code'da `.vscode/launch.json` içinde hazır `dev` ve `prod` ayarları var.
- Flutter 3.47.7 / Dart 3.13 gerekiyor: freezed 4 ve very_good_analysis 11, Dart 3.13 istiyor. very_good_analysis 11, Dart 3.13'ün `const new(...)` kurucu sözdizimini zorunlu tutuyor.
- Üretilen kodlar (`*.g.dart`, l10n `generated/`) repoya dahil ve analizden hariç tutuluyor.
- teknik.md'de `staging` flavor'ı da geçiyor; bu adımda yalnızca `dev` ve `prod` kuruldu.
- Renklerde teknik.md önerisinden iki sapma var: açık tema primary `#B86E00` → `#995A00` ve status-warning `#E65100` → `#B33F00`. Öneri renkler 4.5:1 kontrastı sağlamıyordu; teknik.md tablosu henüz güncellenmedi.
- freezed factory'lerinde sınıf adı yazılmaz, `const factory({...}) = _X;` biçimi kullanılır (`unnecessary_type_name_in_constructor`). `factory new(...)` derlenmez.
- Yerel Supabase için Docker yerine Colima kullanılıyor (`colima start --cpu 4 --memory 6 --vm-type vz --mount-type virtiofs`). Supabase komutları `DOCKER_HOST=unix://$HOME/.colima/default/docker.sock` ile çalışıyor. `~/.docker/config.json` içinde eski Docker Desktop'tan kalan `"credsStore": "desktop"` satırı imaj çekmeyi bozuyor. Bu satır silinmeli ya da `DOCKER_CONFIG` temiz bir klasöre yönlendirilmeli.

## Bilinen sorunlar

- iOS proje şu an Swift Package Manager kullanıyor. İleride CocoaPods gerektiren bir eklenti gelirse `ios/Podfile` içindeki `project 'Runner', {...}` eşlemesine `Debug-dev`/`Debug-prod` → `:debug`, diğerleri → `:release` eklenmeli.
- Drift'in cihazda DB açması için `drift_flutter` (veya `sqlite3_flutter_libs`) henüz eklenmedi; DB adımında eklenecek.
- Görünüm, dil ve bölge seçimi yalnızca bellekte; uygulama yeniden açılınca varsayılana döner. Ayarlar ekranı geldi ama kalıcı kayıt ayrı bir adımda eklenecek (DB ya da shared_preferences kararıyla).
- Hızlı kayıt menüsü yalnızca Okut basılı tutulunca açılıyor. teknik.md'de eldiven modunda uzun basma gerektiren eylem olmaması isteniyor, §8'de ayrıca "yukarı kaydır" seçeneği geçiyor. Eldivenle menüye ulaşma yolu henüz yok.
- dev ve prod aynı `mobilaricilik://` şemasını kullanıyor; ikisi aynı cihazda kuruluysa Android hangi uygulamayla açılacağını soruyor. Derin linklerin henüz hedefi yok; `/scan` gibi kabuk dışı bir rotaya linkle gelinirse altında sekme olmadığı için geri tuşu uygulamadan çıkar.
- Tarih biçimleri `intl` yerel verisi istiyor. Bu veriyi Material yerelleştirmesi yüklüyor; widget ağacı dışında (bildirim, workmanager) `AppFormat` kullanılmadan önce `initializeDateFormatting` çağrılmalı.
- İstemci yeni işletmeyi `RETURNING` ile ya da upsert ile ekleyemez. Owner üyeliği satır eklendikten sonra trigger'la yazıldığı için seçme politikası satırı reddediyor; bu durum denendi. `sync_push` adımında işletme ekleme düz insert olmalı ya da ayrı ele alınmalı. Trigger'ın eklediği owner üyeliğinin id'si sunucuda üretiliyor ve UUIDv4. Postgres 17'de `uuidv7()` yok.
- Son owner kendi rolünü düşürebiliyor ya da kendini çıkarabiliyor; işletme owner'sız kalabilir. `auth.users` satırı silinirse üyelikler kalıcı olarak siliniyor ve bu silme diğer cihazlara senkronla ulaşmıyor. Hesap silme adımında ele alınacak.
- Sunucu iki durumu denetlemiyor: bir ananın aynı anda iki kovanda görünmesi ve `hives.apiary_id`'nin son geçmiş kaydıyla uyuşması. İkisini de istemci yazıyor. Kısıt eklenseydi offline çakışmada push reddedilirdi. Kovanların kroki dizilimi, yaşam döngüsü olayları (birleştirme, bölme) ve ana performansı ilgili adımlarda eklenecek.
- Kendi bileşenlerimiz kenarlık ve köşe tokenlarını doğrudan kullanıyor. Material'ın kendi bileşen temaları (girdi, AppBar, ListTile) ise hâlâ varsayılan. teknik.md'deki gece modu ve golden testlerde 2 yazı boyutu (§11) henüz yok.

# Mobil Arıcı

Arıcının defterini, kayıtlarını ve resmi evrakını tek telefonda toplayan, dağda internetsiz ve eldivenle kullanılabilen offline-first saha uygulaması. Arayüz TR/EN; Türkiye'ye özel modüller (AKS, mevzuat, destekler) yalnızca TR bölge profilinde görünür.
Ayrıntılar: [docs/ozellikler.md](docs/ozellikler.md) (ürün), [docs/teknik.md](docs/teknik.md) (mimari, tasarım dili, yol haritası), [server/README.md](server/README.md) (sunucu). Backend 2026-11'de Supabase'den PocketBase'e taşındı; kararlar (K-1…K-18) [docs/pocketbase-gecis.md](docs/pocketbase-gecis.md)'de, eski Supabase kodu `archive/supabase/`'te (yalnız arşiv, yeni migration yazılmaz).

## Teknoloji yığını

- Flutter (stable), Dart 3; Android öncelikli, iOS aynı kod tabanından
- Riverpod (riverpod_generator), go_router, freezed + json_serializable
- Drift (SQLite) yerel DB + kendi senkron motorumuz (outbox + delta çekme)
- Sunucu: PocketBase v0.40.6, Go ile genişletilmiş kendi ikilimiz (`server/`, K-1): SQLite, auth (e-posta OTP), dosya koleksiyonları, özel route'lar (`/api/sync/*`, `/api/app/*`, `/l/*`), cron. Türkiye'deki VPS'te Coolify ile; dev `arici-api-dev.tutunsoft.com`, prod `arici-api.tutunsoft.com`. İstemcide `pocketbase` Dart SDK'sı.
- flutter_local_notifications + FCM, workmanager, connectivity_plus, flutter_map (OpenFreeMap), mobile_scanner, nfc_manager, fl_chart, sentry_flutter
- Lint: very_good_analysis

## Mimari kurallar

- **Offline-first:** Her okuma/yazma yerel Drift DB'ye gider; ekran ağı asla beklemez. Senkron ve medya yüklemesi arka planda çalışır.
- **Katman akışı:** Widget → provider → repository → Drift. UI yalnızca provider dinler; repository yalnızca yerel Drift DB ile konuşur.
- **PocketBase istemcisi UI'da yok.** Ağa doğrudan giden tek çağrılar auth ve sunucunun `/api/app/*` route'larıdır; bunlar da data katmanındaki servislerden (arayüz + `Pocketbase…` uygulaması), provider üzerinden çağrılır. İstemci `core/services/pocketbase_client_provider.dart`'tan gelir. Senkron istemcide yalnızca `core/sync/`, sunucuda `server/internal/sync/` içinde.
- Her yazma tek bir Drift transaction'ında yerel tablo + `outbox`'a gider.
- UUID'ler istemcide üretilir (UUIDv7). Silme yumuşaktır (`deleted_at`).
- Olay kayıtları (muayene, besleme, ilaçlama, varroa, hasat) yalnızca eklenir; durum kayıtları (kovan, arılık, ana arı, görev) `updated_at` ile son yazan kazanır.
- Listeler DB'den `Stream` olarak gelir; senkron yeni veri indirince ekran kendiliğinden güncellenir.
- İş kuralları (güç puanı, bekleme süresi, ana renk kodu, şurup hesabı) saf Dart fonksiyonlarıdır ve birim testlidir.
- Bölge kararları tek bir `RegionConfig` üzerinden verilir; ekranlar ülke kodunu doğrudan kontrol etmez.

## Klasör yapısı

```text
lib/
  main_dev.dart           # dev flavor girişi (--flavor dev)
  main_prod.dart          # prod flavor girişi (--flavor prod)
  app/
    app.dart              # MaterialApp.router, tema, l10n
    router.dart           # go_router, sekmeli kabuk, derin linkler
    bootstrap.dart        # DB açma, PocketBase oturumu, sync başlatma
  core/
    db/                   # Drift şeması, migration'lar
    sync/                 # outbox, push/pull, imleç, medya kuyruğu
    design_system/        # tokenlar, tema, ortak bileşenler
    l10n/                 # ARB dosyaları (app_tr.arb, app_en.arb)
    utils/                # tarih, birim, uuid v7, haptik
    services/             # konum, kamera, nfc, bildirim, ses
  features/
    today/ apiaries/ hives/ inspections/ queens/ health/ feeding/ harvest/
    migration/ tasks/ inventory/ finance/ documents/ knowledge/ settings/ auth/
    <her özellik>/
      data/               # Drift erişimi, repository
      domain/             # freezed modeller, iş kuralları
      presentation/       # ekranlar, widget'lar, provider'lar
server/                   # PocketBase + Go (ayrıntı: server/README.md)
  main.go                 # app, migratecmd (Automigrate kapalı), bootstrap.Register
  migrations/             # Go şema migration'ları; schema.go ortak kalıp yardımcıları
  schema/collections.json # şema dökümü (elle düzenlenmez, `go run . schema dump`)
  internal/
    sync/                 # Tables (kayıt listesi), push, pull, Refs, rules, versions
    authz/                # Policies (rol kuralları), IsMember/HasRole
    validate/             # alan seçeneğiyle ifade edilemeyen kurallar
    auth/ files/ orgs/ team/ weather/ notify/ fcm/ deletion/ lotpage/ seed/ …
  ops/                    # Coolify, yedek, izleme runbook'ları ve betikler
archive/supabase/         # 2026-11'e kadarki backend; yalnız arşiv (OKU-BENI.md)
```

## Kodlama kuralları

- Provider'lar `@riverpod` (riverpod_generator) ile yazılır; elle `Provider(...)` tanımlanmaz.
- Modeller freezed (+ json_serializable). Kod üretimi: `dart run build_runner build --delete-conflicting-outputs`.
- Navigasyon yalnızca go_router ile (`app/router.dart`); `Navigator.push` kullanılmaz.
- Kullanıcıya görünen tüm metinler ARB'den (`AppLocalizations`); her yeni anahtar bütün ARB dosyalarına (TR, EN, DE, ES, PT, RU, UK, FA, HI) birlikte eklenir, `arb_consistency_test.dart` eksik anahtarı, yabancı yer tutucuyu ve eksik çoğul kategorisini yakalar. Kodda sabit metin yok. Yeni dil: ARB + `AppLanguage` + `tool/country_names.swift` + sunucuda `server/internal/auth/locale.go` ve dil başına metin tabloları (`auth/texts.go` OTP e-postası, `notify/message.go`, `deletion/mail.go`, `lotpage/texts.go`) + `users.locale` seçeneklerini genişleten bir Go migration'ı.
- Yön: Farsça sağdan soladır. Yatay boşluk ve hizada `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`, `BorderRadiusDirectional`; yalnız harita ve grafik gibi fiziksel yönlü yerlerde `left`/`right`. Sayısal metin alanlarında ilk biçimlendirici `AsciiDigitsFormatter`.
- Sabit renk/ölçü yok: `Color(0x...)`, `Colors.*`, sayısal padding/radius/font boyutu yerine yalnızca `core/design_system/` tokenları (`ThemeExtension`).
- Durum renkleri tek başına anlam taşımaz: renk + ikon + kelime birlikte.
- Dokunma hedefi en az 48dp, saha eylemlerinde 56–64dp.

## Yeni kayıt türü kalıbı

Yeni bir kayıt türü (ör. muayene, besleme) uçtan uca bu sırayla eklenir. 4–6. adımların örnekleri C2 (arılıklar) ve C3 (kovanlar) dilimlerinden; 1–3. adımların örnekleri PocketBase geçişinin P2–P5 adımlarından (`docs/pocketbase-gecis.md` "P2 Şema" ortak kalıbı).

1. **Go migration + yetki + kayıt listesi + şema dökümü + Go testleri.** `server/migrations/` altında sıradaki numarayla `<numara>_<ad>.go` (`up` + `down`); panelden şema değişikliği yapılmaz (K-3).
   - Koleksiyon `syncedCollection(ad, alanlar…)` ile (`migrations/schema.go`): `id` UUID (istemcinin UUIDv7'si, K-4), `org_id`, `created_at`/`updated_at`/`deleted_at` mikrosaniyeli UTC metin (K-5), `created_by`, `server_seq`; `(org_id, server_seq)` ve `(server_seq)` index'leri. İşletmesiz koleksiyon `syncedCollectionWithoutOrg`. Seçimli alan `select` (Dart enum değerleriyle birebir); başka kayda bağ relation değil UUID desenli metin (`hive_id`); boş olabilen sayı/bool `nullableNumberField` / `nullableBoolField` (json); gün `YYYY-MM-DD` metni; tekillik `CREATE UNIQUE INDEX … WHERE deleted_at = ''`. API kuralları (list/view/create/update/delete) **null**: senkron koleksiyonuna yalnız sunucu kodu erişir (K-7).
   - `server/internal/sync/registry.go` `Tables`: tablo `KindState` (son yazan kazanır) ya da `KindEvent` (yalnız eklenir), `SyncService.pullTables` ile aynı sırada; listede olmayan tablo push'ta `unsupported` alır, numara almaz ve çekilmez. Başka kayda bağlar `refs.go` `Refs`'e (`RefSameOrg` işletmeler arası bağı `missing_reference` ile reddeder). Alan seçeneğiyle ifade edilemeyen kurallar `internal/validate`'te fonksiyon, `rules.go` `tableChecks`'te push'a bağlanır.
   - `server/internal/authz/policy.go` `Policies`: tabloya `member` (üye okur; owner, partner, worker yazar; viewer yalnız okur), finans için `finance` (yalnız owner ve partner) ya da yeni bir `Policy`. Policy'siz tablo senkronda reddedilir.
   - `cd server && go run . schema dump` → `schema/collections.json` aynı commit'e girer (`TestDumpUpToDate`).
   - Go testleri (`tests.NewTestApp`, `tests.ApiScenario`): koleksiyon alanları ve index'ler, `down`; `validate` kuralları; push/pull senaryoları: başka işletme göremez ve yazamaz, worker yazar, viewer yazamaz, işletmeler arası bağ `missing_reference` alır. `registry_test.go` (Dart'taki `pullTables` ile sıra), `coverage_test.go` (`server_seq` ve hook), `api_rules_test.go` (kuralsız koleksiyon yok) yeni tabloyu kendiliğinden denetler. **Dikkat:** `authz/policy_test.go` `TestPoliciesMatchSupabase` ve `sync/push_rules_test.go` `TestRefsMatchMigrations` `Policies`/`Refs`'i `archive/supabase/migrations`'la karşılaştırır; arşivden sonra eklenen ilk tablo bu iki teste "arşiv sonrası tablolar" istisnasını ekler.
   - Örnek: `1794300003_apiaries_hives_queens.go` (`hives.tag_code` silinmemiş kovanlar arasında tekil; arılık konumu `latitude` + `longitude`, "ikisi birlikte dolu ya da boş" `internal/validate`'te), `apiaries_hives_queens_test.go`.
2. **Drift aynası + migration.** `core/db/tables/` altında `Table with SyncColumns, OrgColumns`, `@UseRowClass(<Model>, generateInsertable: true)` ve `org_id` dizini; tablo `@DriftDatabase(tables: [...])`'e eklenir. Yerelde FK ve tekillik yok, çünkü senkron satırları sırasız indirir. Model `domain/` içinde freezed ve `SyncedRecord`; `toJson` sunucunun alan adlarını verir ve `server_seq`'i dışarıda bırakır (outbox payload'u bu). Enum'lar `ServerEnum` + `ServerEnumConverter`. `test/core/db/schema_mirror_test.dart` `server/schema/collections.json`'u okur: her senkron koleksiyonunun alanı Drift tablosunda, her `select` değeri Dart enum'unda olmalı; yeni enum oradaki eşlemeye eklenir. `schemaVersion` artarsa önce `drift_dev make-migrations` ile şema dökümü ve migration testi kurulur; yeni sürüm `server/internal/sync/versions.go` `SupportedSchemaVersions`'a eklenir. Eksik kalırsa her gönderim 426 `upgrade_required` alır; `versions_test.go` Drift sürümünün listede olmasını denetler.
   - Örnek: `hive_tables.dart` içinde `Apiaries` (`latitude` + `longitude`, CHECK ile ikisi birlikte dolu ya da boş), `Hives`, `HiveLocationHistory`; modeller `Apiary`, `Hive`, `HiveLocationEntry`.
3. **SyncService tablo listesi + deploy.** Pull: tablo `SyncService.pullTables`'a, sunucudaki `Tables` ile aynı sıraya eklenir. Senkron ekranındaki kayıt türü adı `syncTableLabel` (`app/sync/sync_messages.dart`) ve `syncTable…` ARB anahtarıyla gelir. Deploy: dalı GitHub'a push et; Coolify dev'i (`server/**` değiştiyse) kendiliğinden deploy eder, prod yalnız Coolify'da elle "Deploy" ile. Migration'lar açılışta uygulanır; deploy sonrası `server/ops/schema_check.sh <adres>` canlı şemayı dökümle karşılaştırır. Sunucu değişikliği prod'a, uygulama yayımlanmadan önce gider.
   - Örnek: `apiaries` ve `hives` `state`, `hive_location_history` `event`.
4. **Repository + testler.** `features/<x>/data/<x>_repository.dart`, `BaseRepository<$XTable, X>`'ten türer (`table`, `toInsertable`). Durum kaydı `insertRecord` / `updateRecord` / `delete` üstüne yazmalar açar; olay kaydı yalnız ekler ve siler. Birden çok tabloya yazan işlem tek `db.transaction`'da. Okumalar `watchWhere` / `watchById` ile Stream. Saat `clock` ile verilir. Repository provider'ı `presentation/<x>_providers.dart` içinde `@riverpod`. İş kuralları `domain/<x>_rules.dart` içinde saf fonksiyon. Testler `openTestDatabase()` ile bellek içi DB'de: outbox payload'u, outbox SQL trigger ile engellenince tablonun da değişmemesi, yumuşak silme, Stream güncellemesi, süzme ve sıralama.
   - Örnek: `ApiaryRepository.watchSummaries` (aktif kovan sayısı join'i). `HiveRepository.create` kovanı ve ilk `hive_location_history` kaydını tek transaction'da yazar; `createMany` hepsini ya da hiçbirini yazar; `move`, `undoMove`, `setStatus`. Kurallar `hive_rules.dart` içinde: `bulkHiveNumbers`, `statusChangeNeedsConfirmation`.
5. **Ekranlar (tasarım sistemi + ARB).** Yeni ekran mevcut ekranların düzenine ve tasarım sistemine uyar; yalnız var olan veriye karşılığı olan kısımlar yapılır. Rotalar `app/router.dart`'ta: liste, `new`, `:id`, `:id/edit`. Ekleme ve düzenleme aynı form controller'ını ve alan widget'ını kullanır. Ekranlar yalnız provider dinler. Bileşenler `core/design_system/components/`'tan gelir (`BigButton`, `ChoiceChipGroup`, `BigStepper`, `StatusBadge`, `EmptyState`, `BottomActionLayout`, `LabeledField`, `DateField`, `InlineField`, `SectionLabel`, `ListGroup` + `ListRow`, `SegmentedTabs`, `NoteCard`, `SummaryTile`, `CriticalLockCard`, `showConfirmDialog`, `showUndoSnackBar`); metin alanının adı `LabeledField` ile üstte, `labelText` kullanılmaz. Eksik ölçü yeni token olur. Metinler ARB'de, bütün dillerde birlikte. Akış testleri `signedIn()` ile açılır ve Türkçe metinleri, 360dp'de 1.5x yazıyı ve eldiven modunu da dener.
   - Örnek: C2'de `ApiaryFormController` + `ApiaryFormFields` hem `/apiaries/new` ve `/apiaries/:id/edit`'te hem onboarding'in ilk arılık adımında. C3'te `HiveTile` ızgarası için `AppSizes.hiveTile` tokenı eklendi; kovan sayısını etkileyen durum değişikliği `showConfirmDialog` ister, diğerleri `showUndoSnackBar` gösterir. Testler `apiaries_flow_test.dart` ve `hives_flow_test.dart`.
6. **TR alanları RegionConfig bayrağıyla.** TR'ye özel alan (AKS no, TR ilaç listesi, göçer belgesi) ekranda `ref.watch(regionConfigProvider).features.<bayrak>` ile gösterilir ya da gizlenir; ülke kodu kontrol edilmez. Kolon her bölgede şemada durur, boş kalabilir ve senkronlanır. Gereken bayrak yoksa `RegionFeatures`'a ve `resolveRegionConfig` testlerine eklenir. Ekran testi iki profilde (TR ve diğer) çalışır.
   - Örnek: C2/C3'te TR'ye özel alan yoktu, bu adım atlandı. Hazır örnek: `organizations.tr_registration_no` ve `tr_aks_no` kolonları ile `RegionFeatures.aks`.

## Oturum sonu

1. `flutter analyze` temiz (uyarı/hata yok).
2. `flutter test` temiz (tüm testler geçiyor).
3. `cd server && go test ./...` temiz.
4. [docs/progress.md](docs/progress.md) güncellenir: tamamlanan adımlar, notlar, bilinen sorunlar.
5. Değişiklikler commit edilir.

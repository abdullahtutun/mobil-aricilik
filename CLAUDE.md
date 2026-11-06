# Mobil Arıcı

Arıcının defterini, kayıtlarını ve resmi evrakını tek telefonda toplayan, dağda internetsiz ve eldivenle kullanılabilen offline-first saha uygulaması. Arayüz TR/EN; Türkiye'ye özel modüller (AKS, mevzuat, destekler) yalnızca TR bölge profilinde görünür.
Ayrıntılar: [docs/ozellikler.md](docs/ozellikler.md) (ürün), [docs/teknik.md](docs/teknik.md) (mimari, tasarım dili, yol haritası).

## Teknoloji yığını

- Flutter (stable), Dart 3; Android öncelikli, iOS aynı kod tabanından
- Riverpod (riverpod_generator), go_router, freezed + json_serializable
- Drift (SQLite) yerel DB + kendi senkron motorumuz (outbox + delta çekme)
- Supabase: Postgres + RLS, Auth (e-posta OTP), Storage, Edge Functions, pg_cron
- flutter_local_notifications + FCM, workmanager, connectivity_plus, flutter_map (OpenFreeMap), mobile_scanner, nfc_manager, fl_chart, sentry_flutter
- Lint: very_good_analysis

## Mimari kurallar

- **Offline-first:** Her okuma/yazma yerel Drift DB'ye gider; ekran ağı asla beklemez. Senkron ve medya yüklemesi arka planda çalışır.
- **Katman akışı:** Widget → provider → repository → Drift. UI yalnızca provider dinler; repository yalnızca yerel Drift DB ile konuşur.
- **Supabase istemcisi UI'da yok.** Ağa doğrudan giden tek çağrılar auth ve Edge Function'lardır; bunlar da data katmanındaki servislerden, provider üzerinden çağrılır. Senkron yalnızca `core/sync/` içinde.
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
    bootstrap.dart        # DB açma, Supabase init, sync başlatma
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
supabase/migrations/      # şema + RLS (RLS'siz tablo yok)
```

## Kodlama kuralları

- Provider'lar `@riverpod` (riverpod_generator) ile yazılır; elle `Provider(...)` tanımlanmaz.
- Modeller freezed (+ json_serializable). Kod üretimi: `dart run build_runner build --delete-conflicting-outputs`.
- Navigasyon yalnızca go_router ile (`app/router.dart`); `Navigator.push` kullanılmaz.
- Kullanıcıya görünen tüm metinler ARB'den (`AppLocalizations`); her yeni anahtar bütün ARB dosyalarına (TR, EN, DE, ES, PT, RU, UK, FA, HI) birlikte eklenir, `arb_consistency_test.dart` eksik anahtarı, yabancı yer tutucuyu ve eksik çoğul kategorisini yakalar. Kodda sabit metin yok. Yeni dil: ARB + `AppLanguage` + `tool/country_names.swift` + `supabase/functions/_shared/locale.ts` (ve oradaki metin tabloları) + `supabase/templates/otp.html`.
- Yön: Farsça sağdan soladır. Yatay boşluk ve hizada `EdgeInsetsDirectional`, `AlignmentDirectional`, `PositionedDirectional`, `BorderRadiusDirectional`; yalnız harita ve grafik gibi fiziksel yönlü yerlerde `left`/`right`. Sayısal metin alanlarında ilk biçimlendirici `AsciiDigitsFormatter`.
- Sabit renk/ölçü yok: `Color(0x...)`, `Colors.*`, sayısal padding/radius/font boyutu yerine yalnızca `core/design_system/` tokenları (`ThemeExtension`).
- Durum renkleri tek başına anlam taşımaz: renk + ikon + kelime birlikte.
- Dokunma hedefi en az 48dp, saha eylemlerinde 56–64dp.

## Yeni kayıt türü kalıbı

Yeni bir kayıt türü (ör. muayene, besleme) uçtan uca bu sırayla eklenir. Örnekler C2 (arılıklar) ve C3 (kovanlar) dilimlerinden. Bu tabloların 1–3. adımları C2/C3'ten önce, şema v2, Drift ve senkron adımlarında yapılmıştı.

1. **Supabase migration + RLS + pgTAP.** `supabase/migrations/<zaman>_<ad>.sql`: standart kolonlar (`id`, `org_id`, `created_at`, `updated_at`, `created_by`, `deleted_at`, `server_seq`), `unique (id, org_id)`, başka kayda bağ bileşik FK ile (`(x_id, org_id)`), seçimli alanlar Postgres enum'u, `private.set_server_seq()` trigger'ı. RLS: okuma `private.is_member(org_id)`, ekleme ve güncelleme `private.has_role(org_id, '{owner,partner,worker}')`, silme politikası yok. pgTAP: başka işletme göremez ve yazamaz, worker yazar, viewer yazamaz, işletmeler arası bağ 23503 alır.
   - Örnek: `20261021201714_apiaries_hives_queens.sql` (`hives` arılığa `(apiary_id, org_id)` ile bağlı; etiket kodu silinmemiş kovanlar arasında tekil), `hives_rls.test.sql`, `hives_consistency.test.sql`. `sync_seq.test.sql` ve `rls_enabled.test.sql` yeni tabloyu kendiliğinden denetler.
2. **Drift aynası + migration.** `core/db/tables/` altında `Table with SyncColumns, OrgColumns`, `@UseRowClass(<Model>, generateInsertable: true)` ve `org_id` dizini; tablo `@DriftDatabase(tables: [...])`'e eklenir. Yerelde FK ve tekillik yok, çünkü senkron satırları sırasız indirir. Model `domain/` içinde freezed ve `SyncedRecord`; `toJson` sunucunun kolon adlarını verir ve `server_seq`'i dışarıda bırakır (outbox payload'u bu). Enum'lar `ServerEnum` + `ServerEnumConverter`. `schema_mirror_test.dart` migration'ları okur, ayna eksikse kırılır; yeni enum oradaki eşlemeye eklenir. `schemaVersion` artarsa önce `drift_dev make-migrations` ile şema dökümü ve migration testi kurulur; yeni sürüm bir sunucu migration'ıyla `sync_push`'taki `supported_versions`'a eklenir. Eksik kalırsa her gönderim `PT426` alır; `schema_mirror_test.dart` bunu yakalar. Sunucu migration'ı uygulama yayımlanmadan önce uzak projeye uygulanır.
   - Örnek: `hive_tables.dart` içinde `Apiaries` (sunucudaki `location` noktası yerelde `latitude` + `longitude`, CHECK ile ikisi birlikte dolu ya da boş), `Hives`, `HiveLocationHistory`; modeller `Apiary`, `Hive`, `HiveLocationEntry`.
3. **SyncService tablo listesi (push/pull).** Push: sunucuda `private.sync_push_change` içindeki `kind` eşlemesine tablo `state` (son yazan kazanır) ya da `event` (yalnız eklenir) olarak eklenir; eklenmezse kayıt `unsupported` ile reddedilir. Pull: tablo `SyncService.pullTables`'a eklenir; `sync_pull` `server_seq` kolonu olan her tabloyu zaten çeker. Senkron ekranındaki kayıt türü adı `syncTableLabel` (`app/sync/sync_messages.dart`) ve `syncTable…` ARB anahtarıyla gelir.
   - Örnek: `apiaries` ve `hives` `state`, `hive_location_history` `event`; arılık konumu push'ta noktaya, pull'da enlem + boylama çevrilir.
4. **Repository + testler.** `features/<x>/data/<x>_repository.dart`, `BaseRepository<$XTable, X>`'ten türer (`table`, `toInsertable`). Durum kaydı `insertRecord` / `updateRecord` / `delete` üstüne yazmalar açar; olay kaydı yalnız ekler ve siler. Birden çok tabloya yazan işlem tek `db.transaction`'da. Okumalar `watchWhere` / `watchById` ile Stream. Saat `clock` ile verilir. Repository provider'ı `presentation/<x>_providers.dart` içinde `@riverpod`. İş kuralları `domain/<x>_rules.dart` içinde saf fonksiyon. Testler `openTestDatabase()` ile bellek içi DB'de: outbox payload'u, outbox SQL trigger ile engellenince tablonun da değişmemesi, yumuşak silme, Stream güncellemesi, süzme ve sıralama.
   - Örnek: `ApiaryRepository.watchSummaries` (aktif kovan sayısı join'i). `HiveRepository.create` kovanı ve ilk `hive_location_history` kaydını tek transaction'da yazar; `createMany` hepsini ya da hiçbirini yazar; `move`, `undoMove`, `setStatus`. Kurallar `hive_rules.dart` içinde: `bulkHiveNumbers`, `statusChangeNeedsConfirmation`.
5. **Ekranlar (tasarım sistemi + ARB).** Önce `docs/design/` altındaki ekran tasarımı açılır; yalnız var olan veriye karşılığı olan kısımlar yapılır. Rotalar `app/router.dart`'ta: liste, `new`, `:id`, `:id/edit`. Ekleme ve düzenleme aynı form controller'ını ve alan widget'ını kullanır. Ekranlar yalnız provider dinler. Bileşenler `core/design_system/components/`'tan gelir (`BigButton`, `ChoiceChipGroup`, `BigStepper`, `StatusBadge`, `EmptyState`, `BottomActionLayout`, `LabeledField`, `DateField`, `InlineField`, `SectionLabel`, `ListGroup` + `ListRow`, `SegmentedTabs`, `NoteCard`, `SummaryTile`, `CriticalLockCard`, `showConfirmDialog`, `showUndoSnackBar`); metin alanının adı `LabeledField` ile üstte, `labelText` kullanılmaz. Eksik ölçü yeni token olur. Metinler ARB'de, bütün dillerde birlikte. Akış testleri `signedIn()` ile açılır ve Türkçe metinleri, 360dp'de 1.5x yazıyı ve eldiven modunu da dener.
   - Örnek: C2'de `ApiaryFormController` + `ApiaryFormFields` hem `/apiaries/new` ve `/apiaries/:id/edit`'te hem onboarding'in ilk arılık adımında. C3'te `HiveTile` ızgarası için `AppSizes.hiveTile` tokenı eklendi; kovan sayısını etkileyen durum değişikliği `showConfirmDialog` ister, diğerleri `showUndoSnackBar` gösterir. Testler `apiaries_flow_test.dart` ve `hives_flow_test.dart`.
6. **TR alanları RegionConfig bayrağıyla.** TR'ye özel alan (AKS no, TR ilaç listesi, göçer belgesi) ekranda `ref.watch(regionConfigProvider).features.<bayrak>` ile gösterilir ya da gizlenir; ülke kodu kontrol edilmez. Kolon her bölgede şemada durur, boş kalabilir ve senkronlanır. Gereken bayrak yoksa `RegionFeatures`'a ve `resolveRegionConfig` testlerine eklenir. Ekran testi iki profilde (TR ve diğer) çalışır.
   - Örnek: C2/C3'te TR'ye özel alan yoktu, bu adım atlandı. Hazır örnek: `organizations.tr_registration_no` ve `tr_aks_no` kolonları ile `RegionFeatures.aks`.

## Oturum sonu

1. `flutter analyze` temiz (uyarı/hata yok).
2. `flutter test` temiz (tüm testler geçiyor).
3. [docs/progress.md](docs/progress.md) güncellenir: tamamlanan adımlar, notlar, bilinen sorunlar.
4. Değişiklikler commit edilir.

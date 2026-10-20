# Mobil Arıcılık

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
- Kullanıcıya görünen tüm metinler ARB'den (`AppLocalizations`); her yeni anahtar TR ve EN'e birlikte eklenir. Kodda sabit metin yok.
- Sabit renk/ölçü yok: `Color(0x...)`, `Colors.*`, sayısal padding/radius/font boyutu yerine yalnızca `core/design_system/` tokenları (`ThemeExtension`).
- Durum renkleri tek başına anlam taşımaz: renk + ikon + kelime birlikte.
- Dokunma hedefi en az 48dp, saha eylemlerinde 56–64dp.

## Oturum sonu

1. `flutter analyze` temiz (uyarı/hata yok).
2. `flutter test` temiz (tüm testler geçiyor).
3. [docs/progress.md](docs/progress.md) güncellenir: tamamlanan adımlar, notlar, bilinen sorunlar.
4. Değişiklikler commit edilir.

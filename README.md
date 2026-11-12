# Mobil Arıcı

Offline-first arıcılık uygulaması (Flutter, Android ve iOS).

- Ürün: [docs/ozellikler.md](docs/ozellikler.md)
- Mimari ve tasarım dili: [docs/teknik.md](docs/teknik.md)
- İlerleme ve bilinen sorunlar: [docs/progress.md](docs/progress.md)
- Kod kuralları: [CLAUDE.md](CLAUDE.md)

## Çalıştırma

```sh
flutter run --flavor dev -t lib/main_dev.dart
```

Sunucu seçimi `--dart-define` ile:

- `BACKEND=pocketbase|supabase`: verilmezse dev PocketBase'e
  (`https://arici-api-dev.tutunsoft.com`), prod Supabase'e bağlanır.
  Geçiş bitene kadar böyle (docs/pocketbase-gecis.md).
- `PB_URL=<adres>`: flavor'ın PocketBase adresini ezer. Yerel sunucu için
  iOS simülatöründe `http://127.0.0.1:8090`, Android emülatöründe
  `http://10.0.2.2:8090`.
- `LOT_PAGE_BASE_URL=<adres>`: lot sayfası kökünü ezer; PocketBase'de
  verilmezse `<PB adresi>/l`.

```sh
# Yerel PocketBase'e karşı dev
flutter run --flavor dev -t lib/main_dev.dart --dart-define=PB_URL=http://127.0.0.1:8090

# dev'i Supabase'le çalıştırmak
flutter run --flavor dev -t lib/main_dev.dart --dart-define=BACKEND=supabase
```

VS Code'da `.vscode/launch.json` içinde `dev (PocketBase)`, `dev (Supabase)`
ve `prod` ayarları var.

## İki cihaz testleri

`integration_test/two_devices_sync_test.dart` iki (ve daha çok) telefonu
gerçek bir yerel sunucuya karşı eşitler. `flutter test` bunları koşmaz;
simülatör ve yerel sunucu gerekir.

Yerel PocketBase'e karşı:

```sh
# 1) Boş bir klasörle sunucu ve yalnız bu klasöre ait bir superuser
cd server
go run . superuser upsert <e-posta> <parola> --dir /tmp/arici-p91
go run . serve --http 127.0.0.1:8090 --dir /tmp/arici-p91

# 2) Başka bir terminalde, repo kökünde: test hesapları (yalnız 127.0.0.1)
export PB_SUPERUSER_EMAIL=<e-posta> PB_SUPERUSER_PASSWORD=<parola>
server/ops/test_users.sh http://127.0.0.1:8090

# 3) Testler
flutter test integration_test/two_devices_sync_test.dart --flavor dev \
  -d <iOS simülatörü> --dart-define=BACKEND=pocketbase \
  --dart-define=PB_URL=http://127.0.0.1:8090 \
  --dart-define-from-file=build/p91_accounts.json
```

`test_users.sh` hesapları superuser ile açar ve PocketBase'in impersonate
token'larını `build/p91_accounts.json`'a yazar. Sunucuda test route'u yok,
parola girişi yalnız demo hesaba açık kalır. Token'lar 4 saat geçerli; her
test havuzdan yeni hesap alır, bu yüzden her koşudan önce betik yeniden
çalıştırılır (varsayılan 40 hesap). Betik bu yerel sunucunun hız sınırını
da kapatır; sunucu yeniden başlayınca sınır geri gelir.

Yerel Supabase'e karşı (`supabase start` açıkken) aynı test dosyası
`--dart-define=BACKEND=supabase` ile koşar; PocketBase'e özgü iki senaryo
atlanır.

## Mağaza derlemesi

Önce `flutter clean`: `flutter test` üretilen Android eklenti listesine
`integration_test`'i ekliyor ve sonraki release derlemesi bu listeyi
yenilemeyip kırılıyor.

```sh
flutter clean

# Android (android/key.properties gerekli; anahtar ~/keys/mobil_arici_upload.jks)
flutter build appbundle --flavor prod -t lib/main_prod.dart \
  --dart-define=SENTRY_DSN=<dsn>

# iOS
flutter build ipa --flavor prod -t lib/main_prod.dart \
  --dart-define=SENTRY_DSN=<dsn>
```

Sürüm `pubspec.yaml`'daki `version`; her yüklemede `+` sonrası derleme
numarası artırılır.

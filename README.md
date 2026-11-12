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

# Mobil Arıcı

Offline-first arıcılık uygulaması (Flutter, Android ve iOS).

- Ürün: [docs/ozellikler.md](docs/ozellikler.md)
- Mimari ve tasarım dili: [docs/teknik.md](docs/teknik.md)
- İlerleme ve bilinen sorunlar: [docs/progress.md](docs/progress.md)
- Kod kuralları: [CLAUDE.md](CLAUDE.md)
- Sunucu (PocketBase + Go): [server/README.md](server/README.md)
- Supabase'den geçiş (2026-11) ve kararlar: [docs/pocketbase-gecis.md](docs/pocketbase-gecis.md); eski backend `archive/supabase/`

## Çalıştırma

```sh
flutter run --flavor dev -t lib/main_dev.dart
```

Sunucu PocketBase'dir: dev `https://arici-api-dev.tutunsoft.com`'a, prod
`https://arici-api.tutunsoft.com`'a bağlanır. `--dart-define` ile:

- `PB_URL=<adres>`: flavor'ın PocketBase adresini ezer. Yerel sunucu için
  iOS simülatöründe `http://127.0.0.1:8090`, Android emülatöründe
  `http://10.0.2.2:8090`.
- `LOT_PAGE_BASE_URL=<adres>`: lot sayfası kökünü ezer; verilmezse
  `<PB adresi>/l`.

```sh
# Yerel PocketBase'e karşı dev
flutter run --flavor dev -t lib/main_dev.dart --dart-define=PB_URL=http://127.0.0.1:8090
```

Yerel sunucu: `cd server && go run . serve --http 127.0.0.1:8090`
(ayrıntı [server/README.md](server/README.md)). VS Code'da
`.vscode/launch.json` içinde `dev` ve `prod` ayarları var.

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
  -d <iOS simülatörü> \
  --dart-define=PB_URL=http://127.0.0.1:8090 \
  --dart-define-from-file=build/p91_accounts.json
```

`test_users.sh` hesapları superuser ile açar ve PocketBase'in impersonate
token'larını `build/p91_accounts.json`'a yazar. Sunucuda test route'u yok,
parola girişi yalnız demo hesaba açık kalır. Token'lar 4 saat geçerli; her
test havuzdan yeni hesap alır, bu yüzden her koşudan önce betik yeniden
çalıştırılır (varsayılan 40 hesap). Betik bu yerel sunucunun hız sınırını
da kapatır; sunucu yeniden başlayınca sınır geri gelir.

## Mağaza ekran görüntüleri

`tool/store_screenshots.py` `integration_test/store_screenshots_test.dart`'ı
iOS simülatöründe yerel PocketBase'deki demo hesapla çalıştırır. Önce yerel
sunucu açık olmalı; betik her çekimde demo hesabı ve işletmesini `seed
demo-user` + `seed demo --force-reset` ile yeniden kurar, Türkçe dışında
`tool/store_demo/<dil>.sql` çevirisini `sqlite3` ile uygular:

```sh
cd server && go run . serve --http 127.0.0.1:8090 --dir /tmp/pb-shots
# başka terminalde, repo kökünde
python3 tool/store_screenshots.py --password 123456 --pb-dir /tmp/pb-shots \
  --out /tmp/raw --lang en
```

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

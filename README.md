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

## Mağaza derlemesi

```sh
# Android (android/key.properties gerekli)
flutter build appbundle --flavor prod -t lib/main_prod.dart \
  --dart-define=SENTRY_DSN=<dsn>

# iOS
flutter build ipa --flavor prod -t lib/main_prod.dart \
  --dart-define=SENTRY_DSN=<dsn>
```

Sürüm `pubspec.yaml`'daki `version`; her yüklemede `+` sonrası derleme
numarası artırılır.

# İlerleme

## Tamamlanan adımlar

### 2026-10-21 — Proje iskeleti

- Flutter projesi oluşturuldu (Android + iOS). Uygulama kimliği `com.abdullahtutun.mobilaricilik`, Dart paket adı `mobil_aricilik`.
- Temel paketler eklendi: flutter_riverpod + riverpod_generator, go_router, freezed + json_serializable, drift (+ drift_dev), intl, flutter_localizations. Lint: very_good_analysis.
- `dev` ve `prod` flavor'ları kuruldu: Android'de productFlavors, iOS'ta `Debug|Release|Profile-dev/prod` yapılandırmaları ve `dev`/`prod` şemaları. Dev kimliği `.dev` ekli ve adı "Mobil Arıcılık Dev"; iki sürüm aynı cihaza birlikte kurulabilir. Girişler `lib/main_dev.dart` ve `lib/main_prod.dart`; `lib/main.dart` yok. `bootstrap` ile native `--flavor` uyuşmazsa uygulama başlamaz.
- teknik.md 5. bölümdeki klasör yapısı boş olarak kuruldu (`.gitkeep`). `app/` altında `MaterialApp.router` + tek rotalı go_router var; `TodayScreen` ortada ARB'den gelen "Mobil Arıcılık" yazısını gösteriyor.
- TR/EN ARB altyapısı kuruldu (`lib/core/l10n/`, çıktı `generated/`). Widget testi iki yerelde de başlığı doğruluyor.

## Notlar

- Çalıştırma: `flutter run --flavor dev -t lib/main_dev.dart` (prod için `prod` / `main_prod.dart`). VS Code'da `.vscode/launch.json` içinde hazır `dev` ve `prod` ayarları var.
- Flutter 3.47.7 / Dart 3.13 gerekiyor: freezed 4 ve very_good_analysis 11, Dart 3.13 istiyor. very_good_analysis 11, Dart 3.13'ün `const new(...)` kurucu sözdizimini zorunlu tutuyor.
- Üretilen kodlar (`*.g.dart`, l10n `generated/`) repoya dahil ve analizden hariç tutuluyor.
- teknik.md'de `staging` flavor'ı da geçiyor; bu adımda yalnızca `dev` ve `prod` kuruldu.

## Bilinen sorunlar

- iOS proje şu an Swift Package Manager kullanıyor. İleride CocoaPods gerektiren bir eklenti gelirse `ios/Podfile` içindeki `project 'Runner', {...}` eşlemesine `Debug-dev`/`Debug-prod` → `:debug`, diğerleri → `:release` eklenmeli.
- Drift'in cihazda DB açması için `drift_flutter` (veya `sqlite3_flutter_libs`) henüz eklenmedi; DB adımında eklenecek.

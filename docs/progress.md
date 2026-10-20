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

## Notlar

- Çalıştırma: `flutter run --flavor dev -t lib/main_dev.dart` (prod için `prod` / `main_prod.dart`). VS Code'da `.vscode/launch.json` içinde hazır `dev` ve `prod` ayarları var.
- Flutter 3.47.7 / Dart 3.13 gerekiyor: freezed 4 ve very_good_analysis 11, Dart 3.13 istiyor. very_good_analysis 11, Dart 3.13'ün `const new(...)` kurucu sözdizimini zorunlu tutuyor.
- Üretilen kodlar (`*.g.dart`, l10n `generated/`) repoya dahil ve analizden hariç tutuluyor.
- teknik.md'de `staging` flavor'ı da geçiyor; bu adımda yalnızca `dev` ve `prod` kuruldu.
- Renklerde teknik.md önerisinden iki sapma var: açık tema primary `#B86E00` → `#995A00` ve status-warning `#E65100` → `#B33F00`. Öneri renkler 4.5:1 kontrastı sağlamıyordu; teknik.md tablosu henüz güncellenmedi.
- freezed factory'lerinde sınıf adı yazılmaz, `const factory({...}) = _X;` biçimi kullanılır (`unnecessary_type_name_in_constructor`). `factory new(...)` derlenmez.

## Bilinen sorunlar

- iOS proje şu an Swift Package Manager kullanıyor. İleride CocoaPods gerektiren bir eklenti gelirse `ios/Podfile` içindeki `project 'Runner', {...}` eşlemesine `Debug-dev`/`Debug-prod` → `:debug`, diğerleri → `:release` eklenmeli.
- Drift'in cihazda DB açması için `drift_flutter` (veya `sqlite3_flutter_libs`) henüz eklenmedi; DB adımında eklenecek.
- Görünüm seçimi yalnızca bellekte; uygulama yeniden açılınca varsayılana döner. Kalıcı kayıt ayarlar adımında eklenecek.
- Kenarlık ve köşe tokenları henüz bileşen temalarına (buton, kart, girdi) uygulanmadı; bileşen adımında yapılacak. teknik.md'deki gece modu da bu adımda yok.

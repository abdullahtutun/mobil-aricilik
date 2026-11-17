import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'language_provider.g.dart';

/// Arayüz dili seçimi. Bellekte tutulur; açılışta yerel DB'den geri
/// yüklenir ve her değişiklik oraya yazılır (`app/device_preferences.dart`).
@Riverpod(keepAlive: true)
class Language extends _$Language {
  @override
  AppLanguage build() => AppLanguage.system;

  AppLanguage get language => state;

  set language(AppLanguage language) => state = language;
}

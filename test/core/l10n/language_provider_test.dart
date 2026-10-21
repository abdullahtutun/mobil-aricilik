import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_aricilik/core/l10n/app_language.dart';
import 'package:mobil_aricilik/core/l10n/language_provider.dart';

void main() {
  group('languageProvider', () {
    test('varsayılan: cihaz dili', () {
      final container = ProviderContainer.test();

      expect(container.read(languageProvider), AppLanguage.system);
    });

    test('seçilen dil uygulanır ve cihaz diline geri dönülebilir', () {
      final container = ProviderContainer.test();
      final notifier = container.read(languageProvider.notifier)
        ..language = AppLanguage.turkish;

      expect(container.read(languageProvider), AppLanguage.turkish);
      expect(notifier.language, AppLanguage.turkish);

      notifier.language = AppLanguage.system;

      expect(container.read(languageProvider), AppLanguage.system);
    });
  });
}

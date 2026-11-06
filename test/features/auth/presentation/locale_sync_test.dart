import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/locale_sync.dart';

import '../../../helpers/fake_auth_service.dart';

void main() {
  group('localeSync', () {
    ProviderContainer open(FakeAuthService auth) {
      return ProviderContainer.test(
          overrides: [authServiceProvider.overrideWithValue(auth)],
        )
        ..read(languageProvider.notifier).language = AppLanguage.turkish
        ..listen(localeSyncProvider, (_, _) {});
    }

    test('oturum yokken dil yazılmaz', () {
      final auth = FakeAuthService();
      open(auth).read(languageProvider.notifier).language = AppLanguage.english;

      expect(auth.updatedLocales, isEmpty);
    });

    test('seçilen dil hesaba yazılır, değişince yeniden yazılır', () async {
      final auth = FakeAuthService(user: testUser);
      final container = open(auth);
      container.read(languageProvider.notifier).language = AppLanguage.english;
      await container.pump();

      expect(auth.updatedLocales, ['tr', 'en']);
    });

    test('giriş yapılınca dil yazılır', () async {
      final auth = FakeAuthService();
      final container = open(auth);
      auth.emit(testUser);
      await Future<void>.delayed(Duration.zero);
      await container.pump();

      expect(auth.updatedLocales, ['tr']);
    });
  });
}

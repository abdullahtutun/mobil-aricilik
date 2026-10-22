import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/onboarding/presentation/setup_in_progress.dart';

import '../../../helpers/fake_auth_service.dart';

void main() {
  test('başlar, biter; çıkışta sıfırlanır', () async {
    final auth = FakeAuthService(user: testUser);
    final container = ProviderContainer.test(
      overrides: [authServiceProvider.overrideWithValue(auth)],
    );
    final notifier = container.read(setupInProgressProvider.notifier);
    expect(container.read(setupInProgressProvider), isFalse);

    notifier.start();
    expect(container.read(setupInProgressProvider), isTrue);
    notifier.finish();
    expect(container.read(setupInProgressProvider), isFalse);

    container.read(setupInProgressProvider.notifier).start();
    await container.read(currentUserProvider.notifier).signOut();
    expect(container.read(setupInProgressProvider), isFalse);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';

import '../../helpers/test_database.dart';

void main() {
  test('sadece Wi‑Fi varsayılan kapalı; yazılan değer kalır ve akar, '
      'outbox’a gitmez', () async {
    final db = openTestDatabase();
    final settings = LocalSettingsRepository(db);
    expect(await settings.mediaWifiOnly(), isFalse);

    final values = settings.watchMediaWifiOnly();
    await settings.setMediaWifiOnly(enabled: true);
    expect(await settings.mediaWifiOnly(), isTrue);
    expect(await values.first, isTrue);
    await settings.setMediaWifiOnly(enabled: false);
    expect(await values.first, isFalse);
    expect(await readOutbox(db), isEmpty);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';

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

  test('varroa eşikleri varsayılan %3 ve günde 10; ayrı ayrı yazılır, '
      'bozuk değer varsayılana döner', () async {
    final db = openTestDatabase();
    final settings = LocalSettingsRepository(db);
    final thresholds = settings.watchVarroaThresholds();
    expect(await thresholds.first, defaultVarroaThresholds);

    await settings.setVarroaPercentThreshold(2);
    expect(await thresholds.first, (percent: 2.0, perDay: 10.0));
    await settings.setVarroaPerDayThreshold(20);
    expect(await thresholds.first, (percent: 2.0, perDay: 20.0));

    await db
        .into(db.localSettings)
        .insertOnConflictUpdate(
          LocalSettingsCompanion.insert(
            key: LocalSettingsRepository.varroaPercentKey,
            value: 'abc',
          ),
        );
    expect(await thresholds.first, (percent: 3.0, perDay: 20.0));
    expect(await readOutbox(db), isEmpty);
  });
}

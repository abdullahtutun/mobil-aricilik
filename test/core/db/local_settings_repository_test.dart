import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/local_settings_repository.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';

import '../../helpers/test_database.dart';

void main() {
  test('harita için sadece Wi‑Fi varsayılan açık; yazılan değer kalır ve '
      'akar, outbox’a gitmez', () async {
    final db = openTestDatabase();
    final settings = LocalSettingsRepository(db);
    expect(await settings.mapWifiOnly(), isTrue);

    final values = settings.watchMapWifiOnly();
    await settings.setMapWifiOnly(enabled: false);
    expect(await settings.mapWifiOnly(), isFalse);
    expect(await values.first, isFalse);
    await settings.setMapWifiOnly(enabled: true);
    expect(await values.first, isTrue);
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

  test('JSON değer yazılır, okunur, akar ve silinir; bozuk değer null, '
      'outbox’a gitmez', () async {
    final db = openTestDatabase();
    final settings = LocalSettingsRepository(db);
    Map<String, Object?> decode(Map<String, Object?> json) => json;

    final values = settings.watchJson('k', decode);
    expect(await values.first, isNull);

    await settings.writeJson('k', {'a': 1});
    expect(await settings.readJson('k', decode), {'a': 1});
    expect(await values.first, {'a': 1});

    await settings.writeValue('k', '{bozuk');
    expect(await settings.readJson('k', decode), isNull);

    await settings.removeValue('k');
    expect(await settings.readValue('k'), isNull);
    expect(await readOutbox(db), isEmpty);
  });
}

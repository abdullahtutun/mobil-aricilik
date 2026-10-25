import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';

/// Yalnız bu telefondaki ayarlar (`local_settings`). Outbox'a yazılmaz,
/// senkronlanmaz; arka plan görevi de aynı DB'den okur.
class LocalSettingsRepository {
  new(this.db);

  final AppDatabase db;

  /// Medya yalnız Wi‑Fi'da (kotasız ağda) yüklensin; varsayılan kapalı.
  static const mediaWifiOnlyKey = 'media_wifi_only';

  Stream<bool> watchMediaWifiOnly() =>
      _watch(mediaWifiOnlyKey).map((value) => value == 'true');

  Future<bool> mediaWifiOnly() async => await _read(mediaWifiOnlyKey) == 'true';

  Future<void> setMediaWifiOnly({required bool enabled}) =>
      _write(mediaWifiOnlyKey, '$enabled');

  /// Tam zamanlı alarm izninin neden gerektiği bu telefonda bir kez
  /// anlatıldı; sonra yalnız Ayarlar'dan istenir.
  static const exactAlarmPromptedKey = 'exact_alarm_prompted';

  Future<bool> exactAlarmPrompted() async =>
      await _read(exactAlarmPromptedKey) == 'true';

  Future<void> setExactAlarmPrompted() => _write(exactAlarmPromptedKey, 'true');

  /// Varroa uyarı eşikleri; ayar yoksa ya da okunamıyorsa
  /// [defaultVarroaThresholds].
  static const varroaPercentKey = 'varroa_threshold_percent';
  static const varroaPerDayKey = 'varroa_threshold_per_day';

  Stream<VarroaThresholds> watchVarroaThresholds() =>
      (db.select(db.localSettings)
            ..where((t) => t.key.isIn([varroaPercentKey, varroaPerDayKey])))
          .watch()
          .map((rows) {
            final values = {for (final row in rows) row.key: row.value};
            // Bozuk ya da sıfır değer varsayılana döner.
            double? read(String key) =>
                switch (double.tryParse(values[key] ?? '')) {
                  final value? when value > 0 => value,
                  _ => null,
                };
            return (
              percent:
                  read(varroaPercentKey) ?? defaultVarroaThresholds.percent,
              perDay: read(varroaPerDayKey) ?? defaultVarroaThresholds.perDay,
            );
          });

  Future<void> setVarroaPercentThreshold(double percent) =>
      _write(varroaPercentKey, '$percent');

  Future<void> setVarroaPerDayThreshold(double perDay) =>
      _write(varroaPerDayKey, '$perDay');

  Stream<String?> _watch(String key) =>
      _select(key).map((row) => row.value).watchSingleOrNull();

  Future<String?> _read(String key) =>
      _select(key).map((row) => row.value).getSingleOrNull();

  Future<void> _write(String key, String value) => db
      .into(db.localSettings)
      .insertOnConflictUpdate(
        LocalSettingsCompanion.insert(key: key, value: value),
      );

  SimpleSelectStatement<$LocalSettingsTable, LocalSetting> _select(
    String key,
  ) => db.select(db.localSettings)..where((t) => t.key.equals(key));
}

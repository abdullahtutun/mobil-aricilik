import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/weather/domain/weather_rules.dart';

/// Yalnız bu telefondaki ayarlar (`local_settings`). Outbox'a yazılmaz,
/// senkronlanmaz; arka plan görevi de aynı DB'den okur.
class LocalSettingsRepository {
  new(this.db);

  final AppDatabase db;

  /// Medya yalnız Wi‑Fi'da (kotasız ağda) yüklensin; varsayılan kapalı.
  static const mediaWifiOnlyKey = 'media_wifi_only';

  Stream<bool> watchMediaWifiOnly() =>
      watchValue(mediaWifiOnlyKey).map((value) => value == 'true');

  Future<bool> mediaWifiOnly() async =>
      await readValue(mediaWifiOnlyKey) == 'true';

  Future<void> setMediaWifiOnly({required bool enabled}) =>
      writeValue(mediaWifiOnlyKey, '$enabled');

  /// Offline harita paketleri yalnız Wi‑Fi'da (kotasız ağda) insin;
  /// varsayılan açık (paketler onlarca MB).
  static const mapWifiOnlyKey = 'map_wifi_only';

  Stream<bool> watchMapWifiOnly() =>
      watchValue(mapWifiOnlyKey).map((value) => value != 'false');

  Future<bool> mapWifiOnly() async =>
      await readValue(mapWifiOnlyKey) != 'false';

  Future<void> setMapWifiOnly({required bool enabled}) =>
      writeValue(mapWifiOnlyKey, '$enabled');

  /// Tam zamanlı alarm izninin neden gerektiği bu telefonda bir kez
  /// anlatıldı; sonra yalnız Ayarlar'dan istenir.
  static const exactAlarmPromptedKey = 'exact_alarm_prompted';

  Future<bool> exactAlarmPrompted() async =>
      await readValue(exactAlarmPromptedKey) == 'true';

  Future<void> setExactAlarmPrompted() =>
      writeValue(exactAlarmPromptedKey, 'true');

  /// "Kullanım verisi paylaş"; varsayılan açık (teknik.md §13: analitik
  /// ilk sürümden açık). Kapalıyken olay yazılmaz ve gönderilmez.
  static const analyticsEnabledKey = 'analytics_enabled';

  Stream<bool> watchAnalyticsEnabled() =>
      watchValue(analyticsEnabledKey).map((value) => value != 'false');

  Future<bool> analyticsEnabled() async =>
      await readValue(analyticsEnabledKey) != 'false';

  /// "Görev bildirimleri" (push); varsayılan açık. Kapalıyken bu telefonun
  /// token'ı sunucudan silinir, atanan görev için bildirim gelmez.
  static const pushEnabledKey = 'push_enabled';

  Stream<bool> watchPushEnabled() =>
      watchValue(pushEnabledKey).map((value) => value != 'false');

  Future<bool> pushEnabled() async =>
      await readValue(pushEnabledKey) != 'false';

  Future<void> setPushEnabled({required bool enabled}) =>
      writeValue(pushEnabledKey, '$enabled');

  /// Bildirim izni bu telefonda bir kez soruldu; sonra yalnız ayardan
  /// açılınca sorulur.
  static const pushPermissionAskedKey = 'push_permission_asked';

  Future<bool> pushPermissionAsked() async =>
      await readValue(pushPermissionAskedKey) == 'true';

  Future<void> setPushPermissionAsked() =>
      writeValue(pushPermissionAskedKey, 'true');

  /// Bu kurulumun analitik kimliği; analitik yeniden açılınca yenilenir.
  static const analyticsInstallIdKey = 'analytics_install_id';

  /// Son başarılı senkron turunun bittiği an (UTC, ISO 8601). Uygulamadaki
  /// ve arka plandaki tur yazar; yeniden açılışta da görünür.
  static const lastSyncedAtKey = 'sync_last_synced_at';

  Stream<DateTime?> watchLastSyncedAt() =>
      watchValue(lastSyncedAtKey)
          .map((value) => value == null ? null : DateTime.tryParse(value));

  Future<void> setLastSyncedAt(DateTime at) =>
      writeValue(lastSyncedAtKey, at.toUtc().toIso8601String());

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
      writeValue(varroaPercentKey, '$percent');

  Future<void> setVarroaPerDayThreshold(double perDay) =>
      writeValue(varroaPerDayKey, '$perDay');

  /// Kovan açma eşikleri (°C, km/s, %); ayar yoksa ya da okunamıyorsa
  /// [defaultHiveOpeningThresholds].
  static const hiveOpeningTemperatureKey = 'hive_opening_min_temperature_c';
  static const hiveOpeningWindKey = 'hive_opening_max_wind_kmh';
  static const hiveOpeningPrecipitationKey =
      'hive_opening_max_precipitation_probability';

  Stream<HiveOpeningThresholds> watchHiveOpeningThresholds() =>
      (db.select(db.localSettings)..where(
            (t) => t.key.isIn([
              hiveOpeningTemperatureKey,
              hiveOpeningWindKey,
              hiveOpeningPrecipitationKey,
            ]),
          ))
          .watch()
          .map((rows) {
            final values = {for (final row in rows) row.key: row.value};
            double? read(String key) => double.tryParse(values[key] ?? '');
            const defaults = defaultHiveOpeningThresholds;
            return (
              minTemperatureC:
                  read(hiveOpeningTemperatureKey) ?? defaults.minTemperatureC,
              maxWindKmh: read(hiveOpeningWindKey) ?? defaults.maxWindKmh,
              maxPrecipitationProbability:
                  read(hiveOpeningPrecipitationKey) ??
                  defaults.maxPrecipitationProbability,
            );
          });

  Future<void> setHiveOpeningMinTemperature(double celsius) =>
      writeValue(hiveOpeningTemperatureKey, '$celsius');

  Future<void> setHiveOpeningMaxWind(double kmh) =>
      writeValue(hiveOpeningWindKey, '$kmh');

  Future<void> setHiveOpeningMaxPrecipitation(double percent) =>
      writeValue(hiveOpeningPrecipitationKey, '$percent');

  /// [key]'in ham değeri; yoksa null. Tipli ayarlar ve başka özelliklerin
  /// yalnız bu telefonda tuttuğu kayıtlar (tur, hava paketi) bunun üstünde.
  Stream<String?> watchValue(String key) =>
      _select(key).map((row) => row.value).watchSingleOrNull();

  Future<String?> readValue(String key) =>
      _select(key).map((row) => row.value).getSingleOrNull();

  /// Önceki değerin yerine yazar.
  Future<void> writeValue(String key, String value) => db
      .into(db.localSettings)
      .insertOnConflictUpdate(
        LocalSettingsCompanion.insert(key: key, value: value),
      );

  Future<void> removeValue(String key) =>
      (db.delete(db.localSettings)..where((t) => t.key.equals(key))).go();

  /// [key]'deki JSON nesnesi; yoksa ya da okunamıyorsa (eski sürümün ya da
  /// bozuk bir yazmanın bıraktığı değer) null.
  Stream<T?> watchJson<T>(
    String key,
    T Function(Map<String, Object?>) fromJson,
  ) => watchValue(key).map((value) => _decodeJson(value, fromJson));

  Future<T?> readJson<T>(
    String key,
    T Function(Map<String, Object?>) fromJson,
  ) async => _decodeJson(await readValue(key), fromJson);

  Future<void> writeJson(String key, Object? json) =>
      writeValue(key, jsonEncode(json));

  static T? _decodeJson<T>(
    String? value,
    T Function(Map<String, Object?>) fromJson,
  ) {
    if (value == null) return null;
    try {
      return fromJson(jsonDecode(value) as Map<String, Object?>);
    } on Object {
      return null;
    }
  }

  SimpleSelectStatement<$LocalSettingsTable, LocalSetting> _select(
    String key,
  ) => db.select(db.localSettings)..where((t) => t.key.equals(key));
}

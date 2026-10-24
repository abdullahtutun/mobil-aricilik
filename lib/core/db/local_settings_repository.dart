import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';

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

import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/weather/domain/weather_bundle.dart';

/// Son alınan hava paketi; yalnız bu telefonda (`local_settings`), outbox'a
/// yazılmaz ve senkronlanmaz. Çevrimdışıyken ekranlar bunu gösterir.
class WeatherRepository {
  new(this.db);

  final AppDatabase db;

  static const bundleKey = 'weather_bundle';

  /// Saklanan paket; yoksa ya da okunamıyorsa null.
  Stream<WeatherBundle?> watchBundle() =>
      _select().map((row) => _decode(row.value)).watchSingleOrNull();

  Future<WeatherBundle?> readBundle() async =>
      _decode(await _select().map((row) => row.value).getSingleOrNull());

  /// Önceki paketin yerine yazar.
  Future<void> saveBundle(WeatherBundle bundle) => db
      .into(db.localSettings)
      .insertOnConflictUpdate(
        LocalSettingsCompanion.insert(
          key: bundleKey,
          value: jsonEncode(bundle.toJson()),
        ),
      );

  SimpleSelectStatement<$LocalSettingsTable, LocalSetting> _select() =>
      db.select(db.localSettings)..where((t) => t.key.equals(bundleKey));

  static WeatherBundle? _decode(String? value) {
    if (value == null) return null;
    try {
      return WeatherBundle.fromJson(jsonDecode(value) as Map<String, Object?>);
    } on Object {
      // Eski sürümün ya da bozuk bir yazmanın bıraktığı paket.
      return null;
    }
  }
}

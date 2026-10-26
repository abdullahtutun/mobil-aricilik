import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/inspections/domain/apiary_tour.dart';

/// Süren arılık turu; yalnız bu telefonda (`local_settings`), outbox'a
/// yazılmaz ve senkronlanmaz. Aynı anda tek tur var.
class TourRepository {
  new(this.db);

  final AppDatabase db;

  static const tourKey = 'apiary_tour';

  /// Süren tur; yoksa ya da okunamıyorsa null.
  Stream<ApiaryTour?> watchTour() =>
      _select().map((row) => _decode(row.value)).watchSingleOrNull();

  Future<ApiaryTour?> readTour() async =>
      _decode(await _select().map((row) => row.value).getSingleOrNull());

  /// Önceki turun yerine yazar.
  Future<void> saveTour(ApiaryTour tour) => db
      .into(db.localSettings)
      .insertOnConflictUpdate(
        LocalSettingsCompanion.insert(
          key: tourKey,
          value: jsonEncode(tour.toJson()),
        ),
      );

  Future<void> clearTour() =>
      (db.delete(db.localSettings)..where((t) => t.key.equals(tourKey))).go();

  SimpleSelectStatement<$LocalSettingsTable, LocalSetting> _select() =>
      db.select(db.localSettings)..where((t) => t.key.equals(tourKey));

  static ApiaryTour? _decode(String? value) {
    if (value == null) return null;
    try {
      return ApiaryTour.fromJson(jsonDecode(value) as Map<String, Object?>);
    } on Object {
      // Eski sürümün ya da bozuk bir yazmanın bıraktığı tur.
      return null;
    }
  }
}

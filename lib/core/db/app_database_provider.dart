import 'package:drift_flutter/drift_flutter.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_provider.g.dart';

/// Cihazdaki veritabanı (uygulama belgeleri klasöründe
/// `mobil_arici.sqlite`). Bağlantı ilk sorguda açılır, açılış beklemez.
/// Testler bellek içi DB ile override eder.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = AppDatabase(driftDatabase(name: 'mobil_arici'));
  ref.onDispose(db.close);
  return db;
}

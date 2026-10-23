import 'package:drift_flutter/drift_flutter.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_database_provider.g.dart';

/// Cihazdaki veritabanı (uygulama belgeleri klasöründe
/// `mobil_arici.sqlite`). Bağlantı ilk sorguda açılır, açılış beklemez.
///
/// Uygulama ve workmanager'ın arka plan motoru aynı süreçte çalışırsa tek
/// bağlantıyı paylaşır (`shareAcrossIsolates`); iki ayrı bağlantı aynı
/// dosyaya yazıp birbirini kilitlemez, birinin yazması diğerinin
/// akışlarına da ulaşır.
AppDatabase openAppDatabase() => AppDatabase(
  driftDatabase(
    name: 'mobil_arici',
    native: const DriftNativeOptions(shareAcrossIsolates: true),
  ),
);

/// Testler bellek içi DB ile override eder.
@Riverpod(keepAlive: true)
AppDatabase appDatabase(Ref ref) {
  final db = openAppDatabase();
  ref.onDispose(db.close);
  return db;
}

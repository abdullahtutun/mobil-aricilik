import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobil_arici/core/db/app_database.dart';

/// Bellek içi boş veritabanı; test bitince kapanır.
AppDatabase openTestDatabase() {
  final db = AppDatabase(NativeDatabase.memory());
  addTearDown(db.close);
  return db;
}

/// Elle ilerletilen saat; repository'lere `clock: clock.call` ile verilir.
class TestClock {
  new([DateTime? start]) : current = start ?? DateTime.utc(2026, 10, 22, 9);

  DateTime current;

  DateTime call() => current;

  void advance(Duration duration) => current = current.add(duration);
}

/// Outbox, gönderim sırasıyla.
Future<List<OutboxEntry>> readOutbox(AppDatabase db) =>
    (db.select(db.outbox)..orderBy([(t) => OrderingTerm.asc(t.id)])).get();

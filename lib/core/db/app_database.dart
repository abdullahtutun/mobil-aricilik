import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/hive_tables.dart';
import 'package:mobil_arici/core/db/tables/organization_tables.dart';
import 'package:mobil_arici/core/db/tables/sync_tables.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_location_entry.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

export 'tables/sync_tables.dart' show OutboxOperation, fullPullMarker;

part 'app_database.g.dart';

/// Yerel veritabanı. Her okuma ve yazma buraya gider; ekran ağı beklemez.
/// Senkronlanan tablolar `supabase/migrations` şemasının aynası.
@DriftDatabase(
  tables: [
    Organizations,
    Memberships,
    Apiaries,
    Queens,
    Hives,
    HiveLocationHistory,
    Outbox,
    SyncState,
  ],
)
class AppDatabase extends _$AppDatabase {
  new(super.e);

  @override
  int get schemaVersion => 1;
}

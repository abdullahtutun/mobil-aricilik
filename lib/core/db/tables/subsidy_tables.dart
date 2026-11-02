import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/converters.dart';
import 'package:mobil_arici/core/db/tables/sync_columns.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';

/// `public.ref_support_periods` aynası; salt okunur referans liste, yalnız
/// senkronla iner. İşletmeye ait değil, `org_id` yok.
@UseRowClass(SupportPeriod, generateInsertable: true)
class RefSupportPeriods extends Table with SyncColumns {
  TextColumn get name => text()();
  TextColumn get applicationStartsOn => text().map(const DateOnlyConverter())();
  TextColumn get applicationEndsOn => text().map(const DateOnlyConverter())();
  TextColumn get description => text().nullable()();
  TextColumn get sourceUrl => text().nullable()();
}

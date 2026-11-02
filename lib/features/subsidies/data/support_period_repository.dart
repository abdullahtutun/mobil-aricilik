import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';

/// Destek başvuru dönemleri; salt okunur referans liste, yalnız senkronla
/// iner. Uygulama buraya yazmaz.
class SupportPeriodRepository
    extends BaseRepository<$RefSupportPeriodsTable, SupportPeriod> {
  new(super.db, {super.clock});

  @override
  $RefSupportPeriodsTable get table => db.refSupportPeriods;

  @override
  Insertable<SupportPeriod> toInsertable(SupportPeriod record) =>
      record.toInsertable();

  /// Silinmemiş dönemler, başlangıç gününe göre. Senkron yeni dönem
  /// indirince yeniden yayar.
  Stream<List<SupportPeriod>> watchAll() => watchWhere(
    (t) => const Constant(true),
    orderBy: [
      (t) => OrderingTerm.asc(t.applicationStartsOn),
      (t) => OrderingTerm.asc(t.id),
    ],
  );
}

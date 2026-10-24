import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_draft.dart';

/// Yarım kalan hızlı muayeneler, kovan başına bir taslak. Yalnız bu
/// telefonda: outbox'a yazılmaz, senkronlanmaz.
class InspectionDraftRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  /// Yazma zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  /// Kovanın taslağı; yoksa null.
  Future<InspectionDraft?> find(String hiveId) async => (await (db.select(
    db.inspectionDrafts,
  )..where((t) => t.hiveId.equals(hiveId))).getSingleOrNull())?.draft;

  /// Kovanın taslağını yazar; öncekinin yerini alır.
  Future<void> save({
    required String orgId,
    required String hiveId,
    required InspectionDraft draft,
  }) => db
      .into(db.inspectionDrafts)
      .insertOnConflictUpdate(
        InspectionDraftsCompanion.insert(
          hiveId: hiveId,
          orgId: orgId,
          draft: draft,
          updatedAt: clock().toUtc(),
        ),
      );

  /// Kovanın taslağını siler; yoksa bir şey yapmaz.
  Future<void> discard(String hiveId) => (db.delete(
    db.inspectionDrafts,
  )..where((t) => t.hiveId.equals(hiveId))).go();
}

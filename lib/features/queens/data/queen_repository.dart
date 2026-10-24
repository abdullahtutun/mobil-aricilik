import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

/// Ana arılar; durum kaydı, son yazan kazanır.
class QueenRepository extends BaseRepository<$QueensTable, Queen> {
  new(super.db, {super.clock});

  @override
  $QueensTable get table => db.queens;

  @override
  Insertable<Queen> toInsertable(Queen record) => record.toInsertable();

  /// İşletmenin ana arıları, kayıt sırasıyla.
  Stream<List<Queen>> watchAll(String orgId) => watchWhere(
    (t) => t.orgId.equals(orgId),
    orderBy: [(t) => OrderingTerm.asc(t.createdAt)],
  );

  Future<Queen> create({
    required String orgId,
    int? year,
    QueenMarkColor? markColor,
    String? breed,
    String? breedLine,
    QueenSource? source,
    QueenMatingStatus? matingStatus,
    bool wingClipped = false,
    String? motherQueenId,
  }) {
    final at = now();
    return insertRecord(
      Queen(
        id: generateId(),
        orgId: orgId,
        year: year,
        markColor: markColor,
        breed: breed,
        breedLine: breedLine,
        source: source,
        matingStatus: matingStatus,
        wingClipped: wingClipped,
        motherQueenId: motherQueenId,
        createdAt: at,
        updatedAt: at,
      ),
    );
  }

  /// Ananın alanlarını yazar.
  Future<Queen> update(Queen queen) => updateRecord(queen);
}

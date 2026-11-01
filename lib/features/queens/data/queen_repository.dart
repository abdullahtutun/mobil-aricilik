import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/db/base_repository.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/hives/data/hive_repository.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';

/// Kovana verilen yeni ana: ana, kovanın yeni hâli ve kovandan çıkan ana
/// (yoksa null). Geri almak için [QueenRepository.undoGive]'a verilir.
typedef QueenGiven = ({Queen queen, Hive hive, String? previousQueenId});

/// Ana arılar; durum kaydı, son yazan kazanır. Kovana ana verme kovanı
/// ([HiveRepository]) aynı transaction'da yazar.
class QueenRepository extends BaseRepository<$QueensTable, Queen> {
  new(super.db, {super.clock});

  late final _hives = HiveRepository(db, clock: clock);

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

  /// Yeni anayı oluşturur ve kovana verir; kovandaki eski ana kovandan
  /// çıkar ama kaydı kalır (anne ana olarak seçilebilir). Hepsi tek
  /// transaction'da. Kovan yoksa ya da silinmişse [StateError] atar ve bir
  /// şey yazmaz.
  Future<QueenGiven> giveToHive(
    String hiveId, {
    int? year,
    QueenMarkColor? markColor,
    String? breed,
    String? breedLine,
    QueenSource? source,
    QueenMatingStatus? matingStatus,
    bool wingClipped = false,
    String? motherQueenId,
  }) => db.transaction(() async {
    final hive =
        await _hives.findById(hiveId) ??
        (throw StateError('hives/$hiveId yok ya da silinmiş'));
    final queen = await create(
      orgId: hive.orgId,
      year: year,
      markColor: markColor,
      breed: breed,
      breedLine: breedLine,
      source: source,
      matingStatus: matingStatus,
      wingClipped: wingClipped,
      motherQueenId: motherQueenId,
    );
    final updated = await _hives.update(hive.copyWith(queenId: queen.id));
    return (queen: queen, hive: updated, previousQueenId: hive.queenId);
  });

  /// Ana vermeyi geri alır: kovan eski anasına döner, yeni ana yumuşak
  /// silinir; tek transaction. Kovanın anası bu arada değiştiyse ya da
  /// kovan silindiyse bir şey yazmaz ve false döner.
  Future<bool> undoGive(QueenGiven given) => db.transaction(() async {
    final hive = await _hives.findById(given.hive.id);
    if (hive == null || hive.queenId != given.queen.id) return false;
    await _hives.update(hive.copyWith(queenId: given.previousQueenId));
    await delete(given.queen.id);
    return true;
  });
}

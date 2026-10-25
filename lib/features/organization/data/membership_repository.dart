import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

/// İşletmenin üyelikleri; yalnız okunur. Üyelikleri sunucu yazar
/// (`create_organization`, ekip yönetimi), buraya senkronla iner.
class MembershipRepository {
  new(this.db);

  final AppDatabase db;

  /// İşletmenin etkin üyelikleri, eklenme sırasıyla.
  Stream<List<Member>> watchMembers(String orgId) =>
      (db.select(db.memberships)
            ..where((t) => t.orgId.equals(orgId) & t.deletedAt.isNull())
            ..orderBy([
              (t) => OrderingTerm.asc(t.createdAt),
              (t) => OrderingTerm.asc(t.id),
            ]))
          .map((row) => (userId: row.userId, role: row.role))
          .watch();
}

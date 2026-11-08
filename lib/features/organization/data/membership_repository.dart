import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

/// İşletmenin üyelikleri. Üyelikleri ve rolleri sunucu yazar
/// (`create_organization`, ekip yönetimi), buraya senkronla iner; uygulama
/// üyeliğe yazmaz.
class MembershipRepository {
  new(this.db);

  final AppDatabase db;

  SimpleSelectStatement<$MembershipsTable, MembershipRow> _active(
    String orgId,
  ) => db.select(db.memberships)
    ..where((t) => t.orgId.equals(orgId) & t.deletedAt.isNull())
    ..orderBy([
      (t) => OrderingTerm.asc(t.createdAt),
      (t) => OrderingTerm.asc(t.id),
    ]);

  /// İşletmenin etkin üyelikleri, eklenme sırasıyla.
  Stream<List<Member>> watchMembers(String orgId) =>
      _active(orgId).map((row) => (userId: row.userId, role: row.role)).watch();

  /// Etkin üyelikler, eklenme sırasıyla (ekip kartı, profil).
  Stream<List<MemberProfile>> watchProfiles(String orgId) => _active(orgId)
      .map(
        (row) => (
          membershipId: row.id,
          userId: row.userId,
          role: row.role,
          deletionScheduledFor: row.deletionScheduledFor,
        ),
      )
      .watch();
}

import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';

/// İşletmenin üyelikleri. Üyelikleri ve rolleri sunucu yazar
/// (`create_organization`, ekip yönetimi), buraya senkronla iner. Üye
/// buradan yalnız kendi adını soyadını yazar ([setOwnName]); sunucu
/// payload'daki rolü ve diğer kolonları yok sayar.
class MembershipRepository {
  new(this.db, {this.clock = DateTime.now});

  final AppDatabase db;

  /// Yazma zamanının kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

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

  /// Etkin üyelikler adlarıyla, eklenme sırasıyla (ekip kartı, profil).
  Stream<List<MemberProfile>> watchProfiles(String orgId) => _active(orgId)
      .map(
        (row) => (
          membershipId: row.id,
          userId: row.userId,
          role: row.role,
          fullName: row.fullName,
        ),
      )
      .watch();

  /// [userId]'nin [orgId]'deki etkin üyeliğine adını soyadını yazar (boşsa
  /// siler); satır ve outbox tek transaction'da. Üyelik bu telefonda yoksa
  /// false; ad [maxFullNameLength]'ten uzunsa [ArgumentError].
  Future<bool> setOwnName({
    required String orgId,
    required String userId,
    required String? fullName,
  }) {
    final name = fullName?.trim();
    final value = name == null || name.isEmpty ? null : name;
    if (value != null && value.length > maxFullNameLength) {
      throw ArgumentError.value(fullName, 'fullName');
    }
    return db.transaction(() async {
      final row =
          await (db.select(db.memberships)..where(
                (t) =>
                    t.orgId.equals(orgId) &
                    t.userId.equals(userId) &
                    t.deletedAt.isNull(),
              ))
              .getSingleOrNull();
      if (row == null) return false;
      final at = clock().toUtc();
      await (db.update(
        db.memberships,
      )..where((t) => t.id.equals(row.id))).write(
        MembershipsCompanion(fullName: Value(value), updatedAt: Value(at)),
      );
      await db
          .into(db.outbox)
          .insert(
            OutboxCompanion.insert(
              recordTable: db.memberships.actualTableName,
              recordId: row.id,
              operation: OutboxOperation.upsert,
              payload: {
                'id': row.id,
                'org_id': row.orgId,
                'user_id': row.userId,
                'role': row.role.value,
                'full_name': value,
                'created_at': row.createdAt.toUtc().toIso8601String(),
                'updated_at': at.toIso8601String(),
                'created_by': row.createdBy,
                'deleted_at': null,
              },
              createdAt: at,
            ),
          );
      return true;
    });
  }
}

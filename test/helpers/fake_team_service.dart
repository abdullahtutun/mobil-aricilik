import 'package:drift/drift.dart' show Value;
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/data/team_service.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';

import 'fake_organization_service.dart';

var _memberSeq = 0;

/// Yerel DB'ye [role] rolüyle bir üyelik yazar (senkronla inmiş gibi).
Future<void> addMember(
  AppDatabase db, {
  required String userId,
  required MembershipRole role,
  String? orgId,
}) => db
    .into(db.memberships)
    .insert(
      MembershipRow(
        id: 'membership-$userId',
        orgId: orgId ?? testOrganization.id,
        userId: userId,
        role: role,
        createdAt: DateTime.utc(2026, 10, 27, 9, _memberSeq++),
        updatedAt: DateTime.utc(2026, 10, 27, 9),
      ),
    );

/// Ağsız ekip servisi: çağrıları kaydeder, istenen hatayı atar. Rol
/// değişikliği ve çıkarma, senkron indirmiş gibi [db]'ye yazılır.
class FakeTeamService implements TeamService {
  new({required this.db, this.emails = const {}});

  final AppDatabase db;

  /// Sunucunun verdiği e-postalar; kullanıcı kimliğine göre.
  Map<String, String?> emails;

  /// Sonraki çağrıların atacağı hata; null ise çağrı başarılı.
  TeamFailure? failure;

  /// `createInvite` çağrılarında dönecek kodlar, sırayla.
  final codes = <String>['AR7K2Q', 'BCDEFG', 'MN3PQ4'];

  final created = <({String orgId, MembershipRole role})>[];
  final redeemed = <String>[];
  final roleChanges = <({String userId, MembershipRole role})>[];
  final removed = <String>[];

  void _maybeFail() {
    if (failure case final failure?) throw TeamServiceException(failure);
  }

  @override
  Future<Invite> createInvite({
    required String orgId,
    required MembershipRole role,
  }) async {
    _maybeFail();
    created.add((orgId: orgId, role: role));
    return (
      code: codes.removeAt(0),
      role: role,
      expiresAt: DateTime.utc(2026, 10, 29, 9),
    );
  }

  @override
  Future<String> redeem(String code) async {
    redeemed.add(code);
    _maybeFail();
    return testOrganization.id;
  }

  @override
  Future<Map<String, String?>> fetchMemberEmails(String orgId) async {
    _maybeFail();
    return emails;
  }

  @override
  Future<void> setRole({
    required String orgId,
    required String userId,
    required MembershipRole role,
  }) async {
    _maybeFail();
    roleChanges.add((userId: userId, role: role));
    await (db.update(db.memberships)..where((t) => t.userId.equals(userId)))
        .write(MembershipsCompanion(role: Value(role)));
  }

  @override
  Future<void> removeMember({
    required String orgId,
    required String userId,
  }) async {
    _maybeFail();
    removed.add(userId);
    await (db.update(
      db.memberships,
    )..where((t) => t.userId.equals(userId))).write(
      MembershipsCompanion(deletedAt: Value(DateTime.utc(2026, 10, 27, 10))),
    );
  }
}

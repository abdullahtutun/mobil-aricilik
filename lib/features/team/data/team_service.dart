import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';

/// Davet kodu, koda katılma ve üyelik yönetimi.
/// Ağa doğrudan giden çağrı; ekranlar buna provider üzerinden ulaşır.
/// Hepsi online çalışır, hatalar [TeamServiceException] olarak gelir.
abstract interface class TeamService {
  /// Owner ya da partner [role] rolüyle 48 saat geçerli kod üretir.
  Future<Invite> createInvite({
    required String orgId,
    required MembershipRole role,
  });

  /// [code] ile kodun işletmesine kodun rolüyle katılır; işletme kimliğini
  /// döner.
  Future<String> redeem(String code);

  /// İşletmenin üyelerinin e-postaları; kullanıcı kimliğine göre.
  Future<Map<String, String?>> fetchMemberEmails(String orgId);

  /// Yalnız owner: üyenin rolünü değiştirir.
  Future<void> setRole({
    required String orgId,
    required String userId,
    required MembershipRole role,
  });

  /// Yalnız owner: üyeyi işletmeden çıkarır.
  Future<void> removeMember({required String orgId, required String userId});
}

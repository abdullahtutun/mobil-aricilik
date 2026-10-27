import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// `invite` Edge Function'ı: davet kodu, koda katılma ve üyelik yönetimi.
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

class SupabaseTeamService implements TeamService {
  const new(this._client);

  final SupabaseClient _client;

  @override
  Future<Invite> createInvite({
    required String orgId,
    required MembershipRole role,
  }) async {
    final data = await _call({
      'action': 'create',
      'org_id': orgId,
      'role': role.value,
    });
    return (
      code: data['code']! as String,
      role: role,
      expiresAt: DateTime.parse(data['expires_at']! as String),
    );
  }

  @override
  Future<String> redeem(String code) async {
    final data = await _call({'action': 'redeem', 'code': code});
    return data['org_id']! as String;
  }

  @override
  Future<Map<String, String?>> fetchMemberEmails(String orgId) async {
    final data = await _call({'action': 'members', 'org_id': orgId});
    return {
      for (final member
          in (data['members']! as List<Object?>).cast<Map<String, Object?>>())
        member['user_id']! as String: member['email'] as String?,
    };
  }

  @override
  Future<void> setRole({
    required String orgId,
    required String userId,
    required MembershipRole role,
  }) async {
    await _call({
      'action': 'set_role',
      'org_id': orgId,
      'user_id': userId,
      'role': role.value,
    });
  }

  @override
  Future<void> removeMember({
    required String orgId,
    required String userId,
  }) async {
    await _call({'action': 'remove', 'org_id': orgId, 'user_id': userId});
  }

  Future<Map<String, Object?>> _call(Map<String, Object?> body) async {
    try {
      final response = await _client.functions.invoke('invite', body: body);
      return response.data as Map<String, Object?>;
    } on FunctionException catch (error) {
      throw TeamServiceException(_failureOf(error));
    } on Object {
      // Bağlantı hatası, zaman aşımı.
      throw const TeamServiceException(TeamFailure.network);
    }
  }

  static TeamFailure _failureOf(FunctionException error) {
    final code = switch (error.details) {
      {'error': final String code} => code,
      _ => null,
    };
    return switch ((error.status, code)) {
      (404, 'invalid_code') => TeamFailure.invalidCode,
      (409, 'already_member') => TeamFailure.alreadyMember,
      (409, 'owner_locked') => TeamFailure.ownerLocked,
      (401 || 403, _) => TeamFailure.forbidden,
      // Bağlantı kurulamadı (FunctionsFetchException): durum kodu 0.
      (0 || >= 500, _) => TeamFailure.network,
      _ => TeamFailure.unknown,
    };
  }
}

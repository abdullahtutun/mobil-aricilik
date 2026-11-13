import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/data/team_service.dart';
import 'package:mobil_arici/features/team/domain/invite.dart';
import 'package:mobil_arici/features/team/domain/team_failure.dart';
import 'package:pocketbase/pocketbase.dart';

/// [TeamService]'in PocketBase uygulaması (`server/internal/team`): her
/// eylem ayrı route, `POST /api/app/team/{create|redeem|members|set_role|
/// remove}`, gövde `action`'sız. Yanıtlar, durumlar ve kodlar `invite` Edge
/// Function'ınkiyle aynı; kod gövdenin `error`'unda değil `data.code`'da.
class PocketBaseTeamService implements TeamService {
  const new(this._client, {this.timeout = pocketBaseAppRequestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const pathPrefix = '/api/app/team/';

  @override
  Future<Invite> createInvite({
    required String orgId,
    required MembershipRole role,
  }) async {
    final data = await _call('create', {'org_id': orgId, 'role': role.value});
    return _parse<Invite>(
      () => (
        code: data['code']! as String,
        role: role,
        expiresAt: DateTime.parse(data['expires_at']! as String),
      ),
    );
  }

  @override
  Future<String> redeem(String code) async {
    final data = await _call('redeem', {'code': code});
    return _parse<String>(() => data['org_id']! as String);
  }

  @override
  Future<Map<String, String?>> fetchMemberEmails(String orgId) async {
    final data = await _call('members', {'org_id': orgId});
    return _parse<Map<String, String?>>(
      () => {
        for (final member
            in (data['members']! as List<Object?>).cast<Map<String, Object?>>())
          member['user_id']! as String: member['email'] as String?,
      },
    );
  }

  @override
  Future<void> setRole({
    required String orgId,
    required String userId,
    required MembershipRole role,
  }) async {
    await _call('set_role', {
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
    await _call('remove', {'org_id': orgId, 'user_id': userId});
  }

  Future<Map<String, Object?>> _call(
    String action,
    Map<String, Object?> body,
  ) async {
    final Object? response;
    try {
      response = await sendPocketBaseAppRequest(
        _client,
        '$pathPrefix$action',
        body: body,
        timeout: timeout,
      );
    } on PocketBaseApiException catch (error) {
      throw TeamServiceException(failureOf(error.status, error.code));
    }
    if (response is Map<String, Object?>) return response;
    throw const TeamServiceException(TeamFailure.unknown);
  }

  /// Beklenen biçimde olmayan yanıt bilinmeyen hata.
  static T _parse<T>(T Function() read) {
    try {
      return read();
    } on Object {
      throw const TeamServiceException(TeamFailure.unknown);
    }
  }

  /// Sunucunun durum ve koduna karşılık gelen hata; 429 kod denemesi
  /// sınırı (kullanıcı başına dakikada 10).
  static TeamFailure failureOf(int status, String? code) =>
      switch ((status, code)) {
        (404, 'invalid_code') => TeamFailure.invalidCode,
        (409, 'already_member') => TeamFailure.alreadyMember,
        (409, 'owner_locked') => TeamFailure.ownerLocked,
        (409, 'member_leaving') => TeamFailure.memberLeaving,
        (429, _) => TeamFailure.tooManyAttempts,
        (401 || 403, _) => TeamFailure.forbidden,
        // Yanıt yok (bağlantı hatası, zaman aşımı): durum 0.
        (0 || >= 500, _) => TeamFailure.network,
        _ => TeamFailure.unknown,
      };
}

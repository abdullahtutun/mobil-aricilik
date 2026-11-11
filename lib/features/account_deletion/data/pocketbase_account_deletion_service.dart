import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/features/account_deletion/data/account_deletion_service.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:pocketbase/pocketbase.dart';

/// [AccountDeletionService]'in PocketBase uygulaması: `POST
/// /api/app/account-deletion/{send_code|verify_code|request|cancel|status}`
/// (`server/internal/deletion`). Gövdeler, yanıtlar ve durumlar
/// `account-delete` Edge Function'ınınkiyle aynı, gövde `action`'sız; kod
/// `data.code`'da.
///
/// Supabase'deki 502 `sign_out_failed` yolu yok: talep, kullanıcının bütün
/// oturumlarını aynı transaction'da geçersiz kılar (`tokenKey` yenilenir).
/// "Şu tarihte silinecek" e-postası gitmezse sunucu yalnız loglar, talep
/// yine 200 döner.
class PocketBaseAccountDeletionService implements AccountDeletionService {
  const new(this._client, {this.timeout = pocketBaseAppRequestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const pathPrefix = '/api/app/account-deletion/';

  @override
  Future<void> sendCode() async {
    await _call('send_code');
  }

  @override
  Future<void> verifyCode(String code) async {
    await _call('verify_code', {'code': code});
  }

  @override
  Future<DeletionRequestInfo> request({
    required String orgId,
    bool deleteOrganization = false,
    String? transferTo,
  }) async {
    final data = await _call('request', {
      'org_id': orgId,
      'delete_organization': deleteOrganization,
      'transfer_to': ?transferTo,
      'channel': 'uygulama',
    });
    return _requestOf(data['request']) ??
        (throw const AccountDeletionException(AccountDeletionFailure.unknown));
  }

  @override
  Future<DeletionRequestInfo?> pending() async =>
      _requestOf((await _call('status'))['request']);

  @override
  Future<bool> cancel() async => (await _call('cancel'))['cancelled'] == true;

  static DeletionRequestInfo? _requestOf(Object? request) => switch (request) {
    {'scheduled_for': final String scheduledFor, 'kind': final Object? kind} =>
      switch (DateTime.tryParse(scheduledFor)) {
        final scheduledFor? => (
          scheduledFor: scheduledFor,
          kind: DeletionKind.fromValue(kind as String?),
        ),
        null => null,
      },
    _ => null,
  };

  Future<Map<String, Object?>> _call(
    String action, [
    Map<String, Object?> body = const {},
  ]) async {
    final Object? response;
    try {
      response = await sendPocketBaseAppRequest(
        _client,
        '$pathPrefix$action',
        body: body,
        timeout: timeout,
      );
    } on PocketBaseApiException catch (error) {
      throw AccountDeletionException(failureOf(error.status, error.code));
    }
    if (response is Map<String, Object?>) return response;
    throw const AccountDeletionException(AccountDeletionFailure.unknown);
  }

  /// Sunucunun durum ve koduna karşılık gelen hata; Supabase uygulamasıyla
  /// aynı eşleme. 409'daki `data.org_ids` okunmaz (ekran kullanmıyor).
  /// `send_code`'da SMTP yokken 503 `mail_unavailable`, gönderilemezse 502
  /// `mail_failed`: ikisi de geçici, ağ hatası gibi.
  static AccountDeletionFailure failureOf(int status, String? code) => switch ((
    status,
    code,
  )) {
    (409, 'owner_must_transfer') => AccountDeletionFailure.ownerMustTransfer,
    (422, 'invalid_transfer_target') =>
      AccountDeletionFailure.invalidTransferTarget,
    (400, 'invalid_code') => AccountDeletionFailure.invalidCode,
    (429, 'too_many_attempts') => AccountDeletionFailure.tooManyAttempts,
    (429, _) => AccountDeletionFailure.rateLimited,
    (403, 'code_required') => AccountDeletionFailure.codeRequired,
    (401 || 403, _) => AccountDeletionFailure.forbidden,
    // Yanıt yok (bağlantı hatası, zaman aşımı): durum 0.
    (0 || >= 500, _) => AccountDeletionFailure.network,
    _ => AccountDeletionFailure.unknown,
  };
}

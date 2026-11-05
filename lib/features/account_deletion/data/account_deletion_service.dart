import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// `account-delete` Edge Function'ı: silme talebi, bekleyen talep ve iptal.
/// Ağa doğrudan giden çağrı; ekranlar buna provider üzerinden ulaşır. Hepsi
/// online çalışır, hatalar [AccountDeletionException] olarak gelir.
abstract interface class AccountDeletionService {
  /// Oturumdaki kullanıcının silme talebini açar; kalıcı silme 7 gün sonra.
  /// [deleteOrganization] ekipli işletmeyi tümüyle siler; [transferTo]
  /// sahipliği o ortağa devreder. Sunucu talepte bütün oturumları kapatır.
  Future<DeletionRequestInfo> request({
    required String orgId,
    bool deleteOrganization = false,
    String? transferTo,
  });

  /// Bekleyen talep; yoksa null.
  Future<DeletionRequestInfo?> pending();

  /// Bekleyen talebi iptal eder; iptal edildiyse true (kalıcı silme
  /// başladıysa false).
  Future<bool> cancel();
}

class SupabaseAccountDeletionService implements AccountDeletionService {
  const new(this._client);

  final SupabaseClient _client;

  static const functionName = 'account-delete';

  @override
  Future<DeletionRequestInfo> request({
    required String orgId,
    bool deleteOrganization = false,
    String? transferTo,
  }) async {
    final Map<String, Object?> data;
    try {
      data = await _call({
        'action': 'request',
        'org_id': orgId,
        'delete_organization': deleteOrganization,
        'transfer_to': ?transferTo,
        'channel': 'uygulama',
      });
    } on _SignOutFailed catch (error) {
      // Talep yazıldı, yalnız oturumlar kapatılamadı; cihazda oturum yine
      // kapanır, sunucudaki erişim token'ı süresi dolunca biter.
      return error.request;
    }
    return _requestOf(data['request'])!;
  }

  @override
  Future<DeletionRequestInfo?> pending() async =>
      _requestOf((await _call({'action': 'status'}))['request']);

  @override
  Future<bool> cancel() async =>
      (await _call({'action': 'cancel'}))['cancelled'] == true;

  static DeletionRequestInfo? _requestOf(Object? request) => switch (request) {
    {'scheduled_for': final String scheduledFor, 'kind': final Object? kind} =>
      (
        scheduledFor: DateTime.parse(scheduledFor),
        kind: DeletionKind.fromValue(kind as String?),
      ),
    _ => null,
  };

  Future<Map<String, Object?>> _call(Map<String, Object?> body) async {
    try {
      final response = await _client.functions.invoke(functionName, body: body);
      return response.data as Map<String, Object?>;
    } on FunctionException catch (error) {
      final request = error.status == 502
          ? _requestOf(_details(error)?['request'])
          : null;
      if (request != null) throw _SignOutFailed(request);
      throw AccountDeletionException(_failureOf(error));
    } on Object {
      // Bağlantı hatası, zaman aşımı.
      throw const AccountDeletionException(AccountDeletionFailure.network);
    }
  }

  static Map<Object?, Object?>? _details(FunctionException error) =>
      switch (error.details) {
        final Map<Object?, Object?> details => details,
        _ => null,
      };

  static AccountDeletionFailure _failureOf(FunctionException error) {
    final code = switch (_details(error)) {
      {'error': final String code} => code,
      _ => null,
    };
    return switch ((error.status, code)) {
      (409, 'owner_must_transfer') => AccountDeletionFailure.ownerMustTransfer,
      (422, 'invalid_transfer_target') =>
        AccountDeletionFailure.invalidTransferTarget,
      (429, _) => AccountDeletionFailure.rateLimited,
      (401 || 403, _) => AccountDeletionFailure.forbidden,
      // Bağlantı kurulamadı (FunctionsFetchException): durum kodu 0.
      (0 || >= 500, _) => AccountDeletionFailure.network,
      _ => AccountDeletionFailure.unknown,
    };
  }
}

class _SignOutFailed implements Exception {
  const new(this.request);

  final DeletionRequestInfo request;
}

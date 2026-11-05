import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// İşletmeyi sunucudan alır ve kurar. Yerel DB gelene kadar ağa doğrudan
/// giden çağrılardan biri; ekranlar buna provider üzerinden ulaşır. Hatalar
/// [OrganizationServiceException] olarak gelir.
abstract interface class OrganizationService {
  /// Kullanıcının üye olduğu en eski işletme; hiç yoksa null.
  Future<Organization?> fetchCurrent();

  /// [organization]'ı kullanıcının adına kurar ve onu owner yapar; sunucudaki
  /// hâlini döner. Aynı kimlikle yeniden çağrı yeni kayıt açmaz.
  Future<Organization> create(Organization organization);
}

class SupabaseOrganizationService implements OrganizationService {
  const new(this._client);

  final SupabaseClient _client;

  static const _columns =
      'id, name, country_code, currency, hive_count_range, operation_type';

  @override
  Future<Organization?> fetchCurrent() async {
    // RLS yalnız üye olunan işletmeleri döndürür.
    final row = await _guard(
      () => _client
          .from('organizations')
          .select(_columns)
          .isFilter('deleted_at', null)
          // supabase-dart'ta varsayılan sıra azalan.
          .order('created_at', ascending: true)
          .limit(1)
          .maybeSingle(),
    );
    return row == null ? null : Organization.fromJson(row);
  }

  @override
  Future<Organization> create(Organization organization) async {
    final row = await _guard(
      () => _client.rpc<Map<String, dynamic>>(
        'create_organization',
        params: {
          'id': organization.id,
          'name': organization.name,
          'country_code': organization.countryCode,
          'currency': organization.currency,
          'hive_count_range': organization.hiveCountRange?.value,
          'operation_type': organization.operationType.value,
        },
      ),
    );
    return Organization.fromJson(row);
  }

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on PostgrestException {
      throw const OrganizationServiceException(OrganizationFailure.unknown);
    } on AuthRetryableFetchException {
      // Süresi dolmuş token çevrimdışı yenilenemedi.
      throw const OrganizationServiceException(OrganizationFailure.network);
    } on AuthException {
      throw const OrganizationServiceException(OrganizationFailure.unknown);
    } on Exception {
      // Bağlantı hatası (ClientException, SocketException) ya da zaman aşımı.
      throw const OrganizationServiceException(OrganizationFailure.network);
    }
  }
}

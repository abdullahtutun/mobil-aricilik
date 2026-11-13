import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/features/organization/data/organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:pocketbase/pocketbase.dart';

/// [OrganizationService]'in PocketBase uygulaması (`server/internal/orgs`):
/// `POST /api/app/organizations` (`create_organization` karşılığı) ve
/// `GET /api/app/organizations/mine` (üye olunan en eski işletme ya da
/// `null`). Yanıt işletmenin pull'daki satırı; [Organization.fromJson]
/// yalnız kendi alanlarını okur.
class PocketBaseOrganizationService implements OrganizationService {
  const new(this._client, {this.timeout = pocketBaseAppRequestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const createPath = '/api/app/organizations';
  static const minePath = '/api/app/organizations/mine';

  @override
  Future<Organization?> fetchCurrent() async {
    final row = await _send(minePath, method: 'GET');
    return row == null ? null : _organizationOf(row);
  }

  @override
  Future<Organization> create(Organization organization) async {
    final row = await _send(
      createPath,
      body: {
        'id': organization.id,
        'name': organization.name,
        'country_code': organization.countryCode,
        'currency': organization.currency,
        'hive_count_range': organization.hiveCountRange?.value,
        'operation_type': organization.operationType.value,
      },
    );
    return _organizationOf(row);
  }

  Future<Object?> _send(
    String path, {
    String method = 'POST',
    Map<String, Object?> body = const {},
  }) async {
    try {
      return await sendPocketBaseAppRequest(
        _client,
        path,
        method: method,
        body: body,
        timeout: timeout,
      );
    } on PocketBaseApiException catch (error) {
      // 400 `invalid`, 409 `conflict` (kimlik başkasının işletmesi), 401 ve
      // diğerleri bilinmeyen hata.
      throw OrganizationServiceException(
        error.isNetwork || error.status == 408 || error.status == 429
            ? OrganizationFailure.network
            : OrganizationFailure.unknown,
      );
    }
  }

  static Organization _organizationOf(Object? row) {
    try {
      return Organization.fromJson(row! as Map<String, Object?>);
    } on Object {
      throw const OrganizationServiceException(OrganizationFailure.unknown);
    }
  }
}

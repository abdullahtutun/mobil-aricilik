import 'package:mobil_arici/core/services/pocketbase_app_api.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';
import 'package:pocketbase/pocketbase.dart';

/// İşletmenin planını sunucudan okur. Ağa doğrudan giden çağrı; ekranlar
/// buna provider üzerinden, saklanan durum aracılığıyla ulaşır.
abstract interface class PlanService {
  /// Hata [PlanServiceException] olarak gelir.
  Future<PlanStatus> fetch(String orgId);
}

/// Plan alınamadı (çevrimdışı, sunucu hatası, beklenmeyen yanıt). Saklanan
/// durum geçerli kalır.
class PlanServiceException implements Exception {
  const new(this.cause);

  final Object cause;

  @override
  String toString() => 'PlanServiceException($cause)';
}

/// [PlanService]'in PocketBase uygulaması: `POST /api/app/plan` `{org_id}`
/// (`server/internal/plans`).
class PocketBasePlanService implements PlanService {
  const new(this._client, {this.timeout = pocketBaseAppRequestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const path = '/api/app/plan';

  @override
  Future<PlanStatus> fetch(String orgId) async {
    try {
      final response = await sendPocketBaseAppRequest(
        _client,
        path,
        body: {'org_id': orgId},
        timeout: timeout,
      );
      return PlanStatus.fromJson(response! as Map<String, Object?>);
    } on Object catch (error) {
      throw PlanServiceException(error);
    }
  }
}

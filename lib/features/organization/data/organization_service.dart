import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';

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

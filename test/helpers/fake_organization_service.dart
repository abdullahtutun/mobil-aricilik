import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:mobil_arici/features/organization/data/organization_cache.dart';
import 'package:mobil_arici/features/organization/data/organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

const testOrganization = Organization(
  id: '0199a3b2-7c1e-7d40-8a5b-3f2e1d0c9b8a',
  name: 'Petek Arıcılık',
  countryCode: 'TR',
  currency: 'TRY',
  hiveCountRange: HiveCountRange.upTo50,
);

/// Ağsız işletme servisi: sunucudaki işletmeyi taklit eder, çağrıları
/// kaydeder, istenen hatayı atar.
class FakeOrganizationService implements OrganizationService {
  new({this.serverOrganization});

  /// Sunucudaki işletme; null ise kullanıcının işletmesi yok.
  Organization? serverOrganization;

  /// Sonraki çağrıların atacağı hata; null ise çağrı başarılı.
  OrganizationFailure? fetchFailure;
  OrganizationFailure? createFailure;

  /// Doluysa sunucudan alma bu tamamlanana kadar bekler.
  Completer<void>? fetchGate;

  int fetchCount = 0;
  final created = <Organization>[];

  @override
  Future<Organization?> fetchCurrent() async {
    fetchCount++;
    await fetchGate?.future;
    if (fetchFailure case final failure?) {
      throw OrganizationServiceException(failure);
    }
    return serverOrganization;
  }

  @override
  Future<Organization> create(Organization organization) async {
    created.add(organization);
    if (createFailure case final failure?) {
      throw OrganizationServiceException(failure);
    }
    // Sunucu gibi: aynı kimlikle yeniden çağrı mevcut işletmeyi döner.
    return serverOrganization ??= organization;
  }
}

/// Cihazdaki kopyayı bellekte tutar.
class MemoryOrganizationCache implements OrganizationCache {
  ({String userId, Organization organization})? entry;

  @override
  Future<Organization?> read(String userId) async =>
      entry?.userId == userId ? entry?.organization : null;

  @override
  Future<void> write(String userId, Organization organization) async =>
      entry = (userId: userId, organization: organization);

  @override
  Future<void> clear() async => entry = null;
}

/// İşletme servisini ve cihazdaki kopyayı sahteleriyle değiştirir.
/// Varsayılan: sunucuda [testOrganization] var, cihazda kopya yok.
List<Override> organizationOverrides({
  FakeOrganizationService? service,
  MemoryOrganizationCache? cache,
}) => [
  organizationServiceProvider.overrideWithValue(
    service ?? FakeOrganizationService(serverOrganization: testOrganization),
  ),
  organizationCacheProvider.overrideWithValue(
    cache ?? MemoryOrganizationCache(),
  ),
];

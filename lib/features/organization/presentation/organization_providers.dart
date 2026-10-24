import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/services/supabase_client_provider.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/organization/data/organization_cache.dart';
import 'package:mobil_arici/features/organization/data/organization_service.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'organization_providers.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
OrganizationService organizationService(Ref ref) =>
    SupabaseOrganizationService(ref.watch(supabaseClientProvider));

@Riverpod(keepAlive: true)
OrganizationCache organizationCache(Ref ref) => const SecureOrganizationCache();

/// Hata hemen gösterilir, kullanıcı kendisi yeniden dener. Riverpod'un
/// otomatik yeniden denemesi (10 kez, 6,4 sn'ye kadar aralıkla) çevrimdışı
/// ilk açılışı dakikalarca "yükleniyor" gösterirdi.
Duration? _noRetry(int retryCount, Object error) => null;

/// Oturumdaki kullanıcının işletmesi; null ise işletmesi yok ve onboarding
/// açılır.
///
/// Cihazdaki kopya varsa ağ beklenmez, sunucudaki hâli arka planda alınır.
/// Kopya yoksa (ilk giriş) işletme sunucudan alınır; ağ yoksa hata verir.
/// Çıkışta kopya silinir.
@Riverpod(keepAlive: true, retry: _noRetry)
class CurrentOrganization extends _$CurrentOrganization {
  @override
  Future<Organization?> build() async {
    final userId = ref.watch(currentUserProvider.select((user) => user?.id));
    final cache = ref.watch(organizationCacheProvider);
    if (userId == null) {
      await cache.clear();
      return null;
    }

    final cached = await cache.read(userId);
    if (cached != null) {
      unawaited(_refresh(userId, cached));
      return cached;
    }

    final organization = await ref
        .read(organizationServiceProvider)
        .fetchCurrent();
    if (organization != null) await cache.write(userId, organization);
    return organization;
  }

  /// İşletmeyi kurar; para birimi ülkenin bölge yapılandırmasından çıkar.
  /// Aynı [id] ile yeniden çağrı (ör. yanıtı kaybolan istek) ikinci işletme
  /// açmaz. Hata [OrganizationServiceException] olarak gelir.
  Future<void> create({
    required String id,
    required String name,
    required String countryCode,
    HiveCountRange? hiveCountRange,
  }) async {
    final userId = ref.read(currentUserProvider)?.id;
    if (userId == null) return;
    final organization = await ref
        .read(organizationServiceProvider)
        .create(
          Organization(
            id: id,
            name: name,
            countryCode: countryCode,
            currency: resolveRegionConfig(countryCode).currencyCode,
            hiveCountRange: hiveCountRange,
          ),
        );
    if (!ref.mounted) return;
    await ref.read(organizationCacheProvider).write(userId, organization);
    if (ref.mounted) state = AsyncData(organization);
  }

  Future<void> _refresh(String userId, Organization cached) async {
    final Organization? fresh;
    try {
      fresh = await ref.read(organizationServiceProvider).fetchCurrent();
    } on OrganizationServiceException {
      return; // Çevrimdışı: cihazdaki kopya geçerli kalır.
    }
    // Boş yanıt kopyayı silmez; üyelikten çıkarılma senkron adımında ele
    // alınacak.
    if (!ref.mounted || fresh == null || fresh == cached) return;
    // Kurulumun sonucu önce uygulansın, sonra yerine geçilsin.
    await future;
    if (!ref.mounted) return;
    await ref.read(organizationCacheProvider).write(userId, fresh);
    if (ref.mounted) state = AsyncData(fresh);
  }
}

/// Oturumdaki işletmenin kimliği; işletme yoksa ya da henüz yüklenmediyse
/// null. Yalnız kimlik değişince yayar.
@Riverpod(keepAlive: true)
String? currentOrgId(Ref ref) => ref.watch(
  currentOrganizationProvider.select((organization) => organization.value?.id),
);

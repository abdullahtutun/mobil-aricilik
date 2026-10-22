// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `bootstrap` Supabase'i başlattıktan sonra okunur; testler sahtesiyle
/// override eder.

@ProviderFor(organizationService)
final organizationServiceProvider = OrganizationServiceProvider._();

/// `bootstrap` Supabase'i başlattıktan sonra okunur; testler sahtesiyle
/// override eder.

final class OrganizationServiceProvider
    extends
        $FunctionalProvider<
          OrganizationService,
          OrganizationService,
          OrganizationService
        >
    with $Provider<OrganizationService> {
  /// `bootstrap` Supabase'i başlattıktan sonra okunur; testler sahtesiyle
  /// override eder.
  OrganizationServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationServiceHash();

  @$internal
  @override
  $ProviderElement<OrganizationService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrganizationService create(Ref ref) {
    return organizationService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrganizationService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrganizationService>(value),
    );
  }
}

String _$organizationServiceHash() =>
    r'e932ae0a1eb27932b51afb0c9fef80fc1d626264';

@ProviderFor(organizationCache)
final organizationCacheProvider = OrganizationCacheProvider._();

final class OrganizationCacheProvider
    extends
        $FunctionalProvider<
          OrganizationCache,
          OrganizationCache,
          OrganizationCache
        >
    with $Provider<OrganizationCache> {
  OrganizationCacheProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationCacheProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationCacheHash();

  @$internal
  @override
  $ProviderElement<OrganizationCache> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrganizationCache create(Ref ref) {
    return organizationCache(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrganizationCache value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrganizationCache>(value),
    );
  }
}

String _$organizationCacheHash() => r'82687a049a96ba35f412f40884501490bcd580b1';

/// Oturumdaki kullanıcının işletmesi; null ise işletmesi yok ve onboarding
/// açılır.
///
/// Cihazdaki kopya varsa ağ beklenmez, sunucudaki hâli arka planda alınır.
/// Kopya yoksa (ilk giriş) işletme sunucudan alınır; ağ yoksa hata verir.
/// Çıkışta kopya silinir.

@ProviderFor(CurrentOrganization)
final currentOrganizationProvider = CurrentOrganizationProvider._();

/// Oturumdaki kullanıcının işletmesi; null ise işletmesi yok ve onboarding
/// açılır.
///
/// Cihazdaki kopya varsa ağ beklenmez, sunucudaki hâli arka planda alınır.
/// Kopya yoksa (ilk giriş) işletme sunucudan alınır; ağ yoksa hata verir.
/// Çıkışta kopya silinir.
final class CurrentOrganizationProvider
    extends $AsyncNotifierProvider<CurrentOrganization, Organization?> {
  /// Oturumdaki kullanıcının işletmesi; null ise işletmesi yok ve onboarding
  /// açılır.
  ///
  /// Cihazdaki kopya varsa ağ beklenmez, sunucudaki hâli arka planda alınır.
  /// Kopya yoksa (ilk giriş) işletme sunucudan alınır; ağ yoksa hata verir.
  /// Çıkışta kopya silinir.
  CurrentOrganizationProvider._()
    : super(
        from: null,
        argument: null,
        retry: _noRetry,
        name: r'currentOrganizationProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentOrganizationHash();

  @$internal
  @override
  CurrentOrganization create() => CurrentOrganization();
}

String _$currentOrganizationHash() =>
    r'13e3b34fd4afbb0233c18a5ef81cee77b2609607';

/// Oturumdaki kullanıcının işletmesi; null ise işletmesi yok ve onboarding
/// açılır.
///
/// Cihazdaki kopya varsa ağ beklenmez, sunucudaki hâli arka planda alınır.
/// Kopya yoksa (ilk giriş) işletme sunucudan alınır; ağ yoksa hata verir.
/// Çıkışta kopya silinir.

abstract class _$CurrentOrganization extends $AsyncNotifier<Organization?> {
  FutureOr<Organization?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Organization?>, Organization?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Organization?>, Organization?>,
              AsyncValue<Organization?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

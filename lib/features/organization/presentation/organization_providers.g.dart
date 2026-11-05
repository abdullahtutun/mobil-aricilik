// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'organization_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(organizationService)
final organizationServiceProvider = OrganizationServiceProvider._();

/// Testler sahtesiyle override eder.

final class OrganizationServiceProvider
    extends
        $FunctionalProvider<
          OrganizationService,
          OrganizationService,
          OrganizationService
        >
    with $Provider<OrganizationService> {
  /// Testler sahtesiyle override eder.
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
    r'7bb33ee2d4cb4ca15f087e22895fe88c6679794c';

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
    r'180da058827cd735bad8f4bb0e3d5aa33c2b9346';

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

/// Oturumdaki işletmenin kimliği; işletme yoksa ya da henüz yüklenmediyse
/// null. Yalnız kimlik değişince yayar.

@ProviderFor(currentOrgId)
final currentOrgIdProvider = CurrentOrgIdProvider._();

/// Oturumdaki işletmenin kimliği; işletme yoksa ya da henüz yüklenmediyse
/// null. Yalnız kimlik değişince yayar.

final class CurrentOrgIdProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// Oturumdaki işletmenin kimliği; işletme yoksa ya da henüz yüklenmediyse
  /// null. Yalnız kimlik değişince yayar.
  CurrentOrgIdProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentOrgIdProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentOrgIdHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return currentOrgId(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$currentOrgIdHash() => r'42b911b32ed632dce9ac43e1724ffd3789ec3635';

@ProviderFor(organizationRepository)
final organizationRepositoryProvider = OrganizationRepositoryProvider._();

final class OrganizationRepositoryProvider
    extends
        $FunctionalProvider<
          OrganizationRepository,
          OrganizationRepository,
          OrganizationRepository
        >
    with $Provider<OrganizationRepository> {
  OrganizationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationRepositoryHash();

  @$internal
  @override
  $ProviderElement<OrganizationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  OrganizationRepository create(Ref ref) {
    return organizationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OrganizationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OrganizationRepository>(value),
    );
  }
}

String _$organizationRepositoryHash() =>
    r'38aa529218607432cbc42a9d45e294066f927aeb';

@ProviderFor(membershipRepository)
final membershipRepositoryProvider = MembershipRepositoryProvider._();

final class MembershipRepositoryProvider
    extends
        $FunctionalProvider<
          MembershipRepository,
          MembershipRepository,
          MembershipRepository
        >
    with $Provider<MembershipRepository> {
  MembershipRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'membershipRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$membershipRepositoryHash();

  @$internal
  @override
  $ProviderElement<MembershipRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MembershipRepository create(Ref ref) {
    return membershipRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MembershipRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MembershipRepository>(value),
    );
  }
}

String _$membershipRepositoryHash() =>
    r'6e035224bba38334ffb356a8cfb29fdea350752f';

/// Oturumdaki işletmenin yerel satırındaki profil (ad, tür, para birimi,
/// avatar, logo); işletme yoksa ya da satır henüz inmemişse null.

@ProviderFor(localOrganizationProfile)
final localOrganizationProfileProvider = LocalOrganizationProfileProvider._();

/// Oturumdaki işletmenin yerel satırındaki profil (ad, tür, para birimi,
/// avatar, logo); işletme yoksa ya da satır henüz inmemişse null.

final class LocalOrganizationProfileProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrganizationProfile?>,
          OrganizationProfile?,
          Stream<OrganizationProfile?>
        >
    with
        $FutureModifier<OrganizationProfile?>,
        $StreamProvider<OrganizationProfile?> {
  /// Oturumdaki işletmenin yerel satırındaki profil (ad, tür, para birimi,
  /// avatar, logo); işletme yoksa ya da satır henüz inmemişse null.
  LocalOrganizationProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localOrganizationProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localOrganizationProfileHash();

  @$internal
  @override
  $StreamProviderElement<OrganizationProfile?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OrganizationProfile?> create(Ref ref) {
    return localOrganizationProfile(ref);
  }
}

String _$localOrganizationProfileHash() =>
    r'5f49b00228139740de536aee5de388d2a3a958f7';

/// İşletmenin para birimi: yerel satırdaki (profilde değişince hemen),
/// satır inmemişse cihazdaki işletme kopyasındaki. Yeni kayıtlar bununla
/// yazılır; eski kayıtlar kendi para birimini taşır.

@ProviderFor(organizationCurrency)
final organizationCurrencyProvider = OrganizationCurrencyProvider._();

/// İşletmenin para birimi: yerel satırdaki (profilde değişince hemen),
/// satır inmemişse cihazdaki işletme kopyasındaki. Yeni kayıtlar bununla
/// yazılır; eski kayıtlar kendi para birimini taşır.

final class OrganizationCurrencyProvider
    extends $FunctionalProvider<String?, String?, String?>
    with $Provider<String?> {
  /// İşletmenin para birimi: yerel satırdaki (profilde değişince hemen),
  /// satır inmemişse cihazdaki işletme kopyasındaki. Yeni kayıtlar bununla
  /// yazılır; eski kayıtlar kendi para birimini taşır.
  OrganizationCurrencyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationCurrencyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationCurrencyHash();

  @$internal
  @override
  $ProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String? create(Ref ref) {
    return organizationCurrency(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$organizationCurrencyHash() =>
    r'fb46fce35a5cf22af877fad089b8742a41e4a7c8';

/// Oturumdaki işletmenin üyeleri (görev atama); işletme yoksa boş.

@ProviderFor(organizationMembers)
final organizationMembersProvider = OrganizationMembersProvider._();

/// Oturumdaki işletmenin üyeleri (görev atama); işletme yoksa boş.

final class OrganizationMembersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Member>>,
          List<Member>,
          Stream<List<Member>>
        >
    with $FutureModifier<List<Member>>, $StreamProvider<List<Member>> {
  /// Oturumdaki işletmenin üyeleri (görev atama); işletme yoksa boş.
  OrganizationMembersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationMembersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationMembersHash();

  @$internal
  @override
  $StreamProviderElement<List<Member>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Member>> create(Ref ref) {
    return organizationMembers(ref);
  }
}

String _$organizationMembersHash() =>
    r'77e5778ea204331acf745325426e7a1a6720b1e2';

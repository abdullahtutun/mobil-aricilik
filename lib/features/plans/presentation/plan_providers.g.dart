// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plan_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(planService)
final planServiceProvider = PlanServiceProvider._();

/// Testler sahtesiyle override eder.

final class PlanServiceProvider
    extends $FunctionalProvider<PlanService, PlanService, PlanService>
    with $Provider<PlanService> {
  /// Testler sahtesiyle override eder.
  PlanServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planServiceHash();

  @$internal
  @override
  $ProviderElement<PlanService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanService create(Ref ref) {
    return planService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanService>(value),
    );
  }
}

String _$planServiceHash() => r'99eec7a0e74575a248133029b51fcbf6656c69d7';

@ProviderFor(planRepository)
final planRepositoryProvider = PlanRepositoryProvider._();

final class PlanRepositoryProvider
    extends $FunctionalProvider<PlanRepository, PlanRepository, PlanRepository>
    with $Provider<PlanRepository> {
  PlanRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planRepositoryHash();

  @$internal
  @override
  $ProviderElement<PlanRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanRepository create(Ref ref) {
    return planRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanRepository>(value),
    );
  }
}

String _$planRepositoryHash() => r'9617be2f42215476d3a6fae346b1df1b42cf5b96';

/// Testler sahtesiyle override eder.

@ProviderFor(purchaseService)
final purchaseServiceProvider = PurchaseServiceProvider._();

/// Testler sahtesiyle override eder.

final class PurchaseServiceProvider
    extends
        $FunctionalProvider<PurchaseService, PurchaseService, PurchaseService>
    with $Provider<PurchaseService> {
  /// Testler sahtesiyle override eder.
  PurchaseServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'purchaseServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$purchaseServiceHash();

  @$internal
  @override
  $ProviderElement<PurchaseService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PurchaseService create(Ref ref) {
    return purchaseService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PurchaseService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PurchaseService>(value),
    );
  }
}

String _$purchaseServiceHash() => r'59649f61d5d880c0e21b777b307ac0f68f927261';

/// İşletmenin telefonda saklanan plan durumu; hiç alınmadıysa null.

@ProviderFor(storedPlan)
final storedPlanProvider = StoredPlanProvider._();

/// İşletmenin telefonda saklanan plan durumu; hiç alınmadıysa null.

final class StoredPlanProvider
    extends
        $FunctionalProvider<
          AsyncValue<StoredPlanStatus?>,
          StoredPlanStatus?,
          Stream<StoredPlanStatus?>
        >
    with
        $FutureModifier<StoredPlanStatus?>,
        $StreamProvider<StoredPlanStatus?> {
  /// İşletmenin telefonda saklanan plan durumu; hiç alınmadıysa null.
  StoredPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storedPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedPlanHash();

  @$internal
  @override
  $StreamProviderElement<StoredPlanStatus?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<StoredPlanStatus?> create(Ref ref) {
    return storedPlan(ref);
  }
}

String _$storedPlanHash() => r'ff36bde1ae2d18c1e40746a889ff91accef8fafe';

/// Ekranların uyguladığı plan ([effectivePlan]). Durum yüklenirken ya da
/// hiç alınmamışken sınırsız: plan hiçbir zaman arıcıyı beklenmedik yerde
/// durdurmaz.

@ProviderFor(currentPlan)
final currentPlanProvider = CurrentPlanProvider._();

/// Ekranların uyguladığı plan ([effectivePlan]). Durum yüklenirken ya da
/// hiç alınmamışken sınırsız: plan hiçbir zaman arıcıyı beklenmedik yerde
/// durdurmaz.

final class CurrentPlanProvider
    extends $FunctionalProvider<PlanStatus, PlanStatus, PlanStatus>
    with $Provider<PlanStatus> {
  /// Ekranların uyguladığı plan ([effectivePlan]). Durum yüklenirken ya da
  /// hiç alınmamışken sınırsız: plan hiçbir zaman arıcıyı beklenmedik yerde
  /// durdurmaz.
  CurrentPlanProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentPlanProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentPlanHash();

  @$internal
  @override
  $ProviderElement<PlanStatus> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanStatus create(Ref ref) {
    return currentPlan(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanStatus>(value),
    );
  }
}

String _$currentPlanHash() => r'cecec85bc3727a78220471fe8c0ea69a8b2c7698';

/// Bugün'deki beta notu kapatıldı mı.

@ProviderFor(betaNoticeDismissed)
final betaNoticeDismissedProvider = BetaNoticeDismissedProvider._();

/// Bugün'deki beta notu kapatıldı mı.

final class BetaNoticeDismissedProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Bugün'deki beta notu kapatıldı mı.
  BetaNoticeDismissedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'betaNoticeDismissedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$betaNoticeDismissedHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return betaNoticeDismissed(ref);
  }
}

String _$betaNoticeDismissedHash() =>
    r'c2d7b862a28ac8f6412059fa403bf08ad035d8d6';

/// Mağazadaki Pro paketleri; satın alma kurulu değilse ya da işletme yoksa
/// boş. Hata [PurchaseException] olarak gelir.

@ProviderFor(planOffers)
final planOffersProvider = PlanOffersProvider._();

/// Mağazadaki Pro paketleri; satın alma kurulu değilse ya da işletme yoksa
/// boş. Hata [PurchaseException] olarak gelir.

final class PlanOffersProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PlanOffer>>,
          List<PlanOffer>,
          FutureOr<List<PlanOffer>>
        >
    with $FutureModifier<List<PlanOffer>>, $FutureProvider<List<PlanOffer>> {
  /// Mağazadaki Pro paketleri; satın alma kurulu değilse ya da işletme yoksa
  /// boş. Hata [PurchaseException] olarak gelir.
  PlanOffersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planOffersProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planOffersHash();

  @$internal
  @override
  $FutureProviderElement<List<PlanOffer>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PlanOffer>> create(Ref ref) {
    return planOffers(ref);
  }
}

String _$planOffersHash() => r'4c73c612ece5266309f86e4b3c434be76b703b9b';

/// Planlar açık mı: Pro ekranı ve satın alma yalnız o zaman görünür.

@ProviderFor(plansEnabled)
final plansEnabledProvider = PlansEnabledProvider._();

/// Planlar açık mı: Pro ekranı ve satın alma yalnız o zaman görünür.

final class PlansEnabledProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Planlar açık mı: Pro ekranı ve satın alma yalnız o zaman görünür.
  PlansEnabledProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'plansEnabledProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$plansEnabledHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return plansEnabled(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$plansEnabledHash() => r'ad740dd7de46fbbe454f770c546ecc07a62214af';

/// Kaç kovan daha eklenebilir; null sınırsız ([remainingHiveSlots]).
/// Kovan eklenip silindikçe yeniden yayar.

@ProviderFor(remainingHives)
final remainingHivesProvider = RemainingHivesProvider._();

/// Kaç kovan daha eklenebilir; null sınırsız ([remainingHiveSlots]).
/// Kovan eklenip silindikçe yeniden yayar.

final class RemainingHivesProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, Stream<int?>>
    with $FutureModifier<int?>, $StreamProvider<int?> {
  /// Kaç kovan daha eklenebilir; null sınırsız ([remainingHiveSlots]).
  /// Kovan eklenip silindikçe yeniden yayar.
  RemainingHivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remainingHivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remainingHivesHash();

  @$internal
  @override
  $StreamProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int?> create(Ref ref) {
    return remainingHives(ref);
  }
}

String _$remainingHivesHash() => r'b43a402ee3ef6f96298adc158e833852156586d8';

/// Planı sunucudan yeniler. Ağ yoksa ya da sunucu hata verirse saklanan
/// durum kalır; hata ekrana taşınmaz.

@ProviderFor(planRefresher)
final planRefresherProvider = PlanRefresherProvider._();

/// Planı sunucudan yeniler. Ağ yoksa ya da sunucu hata verirse saklanan
/// durum kalır; hata ekrana taşınmaz.

final class PlanRefresherProvider
    extends $FunctionalProvider<PlanRefresher, PlanRefresher, PlanRefresher>
    with $Provider<PlanRefresher> {
  /// Planı sunucudan yeniler. Ağ yoksa ya da sunucu hata verirse saklanan
  /// durum kalır; hata ekrana taşınmaz.
  PlanRefresherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'planRefresherProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$planRefresherHash();

  @$internal
  @override
  $ProviderElement<PlanRefresher> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PlanRefresher create(Ref ref) {
    return planRefresher(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlanRefresher value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlanRefresher>(value),
    );
  }
}

String _$planRefresherHash() => r'd8bf72892d39762d93ec3b65fcbce3f2d0a84208';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subsidy_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(supportPeriodRepository)
final supportPeriodRepositoryProvider = SupportPeriodRepositoryProvider._();

final class SupportPeriodRepositoryProvider
    extends
        $FunctionalProvider<
          SupportPeriodRepository,
          SupportPeriodRepository,
          SupportPeriodRepository
        >
    with $Provider<SupportPeriodRepository> {
  SupportPeriodRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportPeriodRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportPeriodRepositoryHash();

  @$internal
  @override
  $ProviderElement<SupportPeriodRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SupportPeriodRepository create(Ref ref) {
    return supportPeriodRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SupportPeriodRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SupportPeriodRepository>(value),
    );
  }
}

String _$supportPeriodRepositoryHash() =>
    r'f952a54adeaa84bee23d5421c195fcd9faa788f4';

/// Destek dönemleri ekrandaki sırayla: açıklar, yaklaşanlar, bitenler
/// ([sortSupportPeriods]). Senkron yeni dönem indirince yeniden yayar.

@ProviderFor(supportPeriods)
final supportPeriodsProvider = SupportPeriodsProvider._();

/// Destek dönemleri ekrandaki sırayla: açıklar, yaklaşanlar, bitenler
/// ([sortSupportPeriods]). Senkron yeni dönem indirince yeniden yayar.

final class SupportPeriodsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SupportPeriod>>,
          List<SupportPeriod>,
          Stream<List<SupportPeriod>>
        >
    with
        $FutureModifier<List<SupportPeriod>>,
        $StreamProvider<List<SupportPeriod>> {
  /// Destek dönemleri ekrandaki sırayla: açıklar, yaklaşanlar, bitenler
  /// ([sortSupportPeriods]). Senkron yeni dönem indirince yeniden yayar.
  SupportPeriodsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'supportPeriodsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$supportPeriodsHash();

  @$internal
  @override
  $StreamProviderElement<List<SupportPeriod>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SupportPeriod>> create(Ref ref) {
    return supportPeriods(ref);
  }
}

String _$supportPeriodsHash() => r'016b1479e716d6538728e69c083a3580fa5bac5e';

/// İşletmenin aktif kovan sayısı; işletme yoksa 0.

@ProviderFor(activeHiveCount)
final activeHiveCountProvider = ActiveHiveCountProvider._();

/// İşletmenin aktif kovan sayısı; işletme yoksa 0.

final class ActiveHiveCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// İşletmenin aktif kovan sayısı; işletme yoksa 0.
  ActiveHiveCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeHiveCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeHiveCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return activeHiveCount(ref);
  }
}

String _$activeHiveCountHash() => r'4127f1ade107f426afd4dc22b3f48ecb22730b5e';

/// İşletmenin AKS'de beyan ettiği kovan sayısı; girilmemişse ya da
/// işletme satırı henüz inmemişse null.

@ProviderFor(aksHiveCount)
final aksHiveCountProvider = AksHiveCountProvider._();

/// İşletmenin AKS'de beyan ettiği kovan sayısı; girilmemişse ya da
/// işletme satırı henüz inmemişse null.

final class AksHiveCountProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, Stream<int?>>
    with $FutureModifier<int?>, $StreamProvider<int?> {
  /// İşletmenin AKS'de beyan ettiği kovan sayısı; girilmemişse ya da
  /// işletme satırı henüz inmemişse null.
  AksHiveCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aksHiveCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aksHiveCountHash();

  @$internal
  @override
  $StreamProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int?> create(Ref ref) {
    return aksHiveCount(ref);
  }
}

String _$aksHiveCountHash() => r'c74e55ef0b6d6f36c8ec090e08ad09fda0877af7';

@ProviderFor(aksHiveCountCheck)
final aksHiveCountCheckProvider = AksHiveCountCheckProvider._();

final class AksHiveCountCheckProvider
    extends
        $FunctionalProvider<
          AsyncValue<AksHiveCountState>,
          AksHiveCountState,
          FutureOr<AksHiveCountState>
        >
    with
        $FutureModifier<AksHiveCountState>,
        $FutureProvider<AksHiveCountState> {
  AksHiveCountCheckProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'aksHiveCountCheckProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$aksHiveCountCheckHash();

  @$internal
  @override
  $FutureProviderElement<AksHiveCountState> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<AksHiveCountState> create(Ref ref) {
    return aksHiveCountCheck(ref);
  }
}

String _$aksHiveCountCheckHash() => r'9a2582039fdb363b9b29e4c37ee68cc9f22206c6';

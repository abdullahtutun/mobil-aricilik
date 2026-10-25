// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'treatment_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(refDrugRepository)
final refDrugRepositoryProvider = RefDrugRepositoryProvider._();

final class RefDrugRepositoryProvider
    extends
        $FunctionalProvider<
          RefDrugRepository,
          RefDrugRepository,
          RefDrugRepository
        >
    with $Provider<RefDrugRepository> {
  RefDrugRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refDrugRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refDrugRepositoryHash();

  @$internal
  @override
  $ProviderElement<RefDrugRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RefDrugRepository create(Ref ref) {
    return refDrugRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RefDrugRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RefDrugRepository>(value),
    );
  }
}

String _$refDrugRepositoryHash() => r'cb97fe34bf9ece7a1e9c98f6e06564387c9c40cd';

@ProviderFor(drugRepository)
final drugRepositoryProvider = DrugRepositoryProvider._();

final class DrugRepositoryProvider
    extends $FunctionalProvider<DrugRepository, DrugRepository, DrugRepository>
    with $Provider<DrugRepository> {
  DrugRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'drugRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$drugRepositoryHash();

  @$internal
  @override
  $ProviderElement<DrugRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DrugRepository create(Ref ref) {
    return drugRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DrugRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DrugRepository>(value),
    );
  }
}

String _$drugRepositoryHash() => r'0ee68a8e4055096003edb72563f8acf3ab8c0a13';

@ProviderFor(treatmentRepository)
final treatmentRepositoryProvider = TreatmentRepositoryProvider._();

final class TreatmentRepositoryProvider
    extends
        $FunctionalProvider<
          TreatmentRepository,
          TreatmentRepository,
          TreatmentRepository
        >
    with $Provider<TreatmentRepository> {
  TreatmentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'treatmentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$treatmentRepositoryHash();

  @$internal
  @override
  $ProviderElement<TreatmentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TreatmentRepository create(Ref ref) {
    return treatmentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TreatmentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TreatmentRepository>(value),
    );
  }
}

String _$treatmentRepositoryHash() =>
    r'411815204ae7cee48396dd51bf6a9feeb3ab9117';

@ProviderFor(refDrugs)
final refDrugsProvider = RefDrugsProvider._();

final class RefDrugsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RefDrug>>,
          List<RefDrug>,
          Stream<List<RefDrug>>
        >
    with $FutureModifier<List<RefDrug>>, $StreamProvider<List<RefDrug>> {
  RefDrugsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'refDrugsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$refDrugsHash();

  @$internal
  @override
  $StreamProviderElement<List<RefDrug>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RefDrug>> create(Ref ref) {
    return refDrugs(ref);
  }
}

String _$refDrugsHash() => r'38be510ae19f6873454797a8b1d2bd88d760f0a5';

/// İşletmenin eklediği ilaçlar; işletme yoksa boş.

@ProviderFor(organizationDrugs)
final organizationDrugsProvider = OrganizationDrugsProvider._();

/// İşletmenin eklediği ilaçlar; işletme yoksa boş.

final class OrganizationDrugsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Drug>>,
          List<Drug>,
          Stream<List<Drug>>
        >
    with $FutureModifier<List<Drug>>, $StreamProvider<List<Drug>> {
  /// İşletmenin eklediği ilaçlar; işletme yoksa boş.
  OrganizationDrugsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationDrugsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationDrugsHash();

  @$internal
  @override
  $StreamProviderElement<List<Drug>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Drug>> create(Ref ref) {
    return organizationDrugs(ref);
  }
}

String _$organizationDrugsHash() => r'11f37fdbc6f4de2c912e3137849416e767f8257a';

/// Formdaki ilaç listesi ([drugCatalog]) [languageCode] dilinde. TR
/// listesi bölge profilinin `trDrugList` bayrağıyla görünür.

@ProviderFor(drugCatalogOf)
final drugCatalogOfProvider = DrugCatalogOfFamily._();

/// Formdaki ilaç listesi ([drugCatalog]) [languageCode] dilinde. TR
/// listesi bölge profilinin `trDrugList` bayrağıyla görünür.

final class DrugCatalogOfProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<DrugChoice>>,
          List<DrugChoice>,
          FutureOr<List<DrugChoice>>
        >
    with $FutureModifier<List<DrugChoice>>, $FutureProvider<List<DrugChoice>> {
  /// Formdaki ilaç listesi ([drugCatalog]) [languageCode] dilinde. TR
  /// listesi bölge profilinin `trDrugList` bayrağıyla görünür.
  DrugCatalogOfProvider._({
    required DrugCatalogOfFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'drugCatalogOfProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$drugCatalogOfHash();

  @override
  String toString() {
    return r'drugCatalogOfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<DrugChoice>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<DrugChoice>> create(Ref ref) {
    final argument = this.argument as String;
    return drugCatalogOf(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DrugCatalogOfProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$drugCatalogOfHash() => r'21e59c0034d420d6efb42f2c25be574a19fc1972';

/// Formdaki ilaç listesi ([drugCatalog]) [languageCode] dilinde. TR
/// listesi bölge profilinin `trDrugList` bayrağıyla görünür.

final class DrugCatalogOfFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<DrugChoice>>, String> {
  DrugCatalogOfFamily._()
    : super(
        retry: null,
        name: r'drugCatalogOfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Formdaki ilaç listesi ([drugCatalog]) [languageCode] dilinde. TR
  /// listesi bölge profilinin `trDrugList` bayrağıyla görünür.

  DrugCatalogOfProvider call(String languageCode) =>
      DrugCatalogOfProvider._(argument: languageCode, from: this);

  @override
  String toString() => r'drugCatalogOfProvider';
}

/// Kaydetme, geri alma ve kilit denetimi. Bildirimin Geri al'ı form
/// kapandıktan sonra da çalışsın diye sürekli yaşar.

@ProviderFor(TreatmentActions)
final treatmentActionsProvider = TreatmentActionsProvider._();

/// Kaydetme, geri alma ve kilit denetimi. Bildirimin Geri al'ı form
/// kapandıktan sonra da çalışsın diye sürekli yaşar.
final class TreatmentActionsProvider
    extends $NotifierProvider<TreatmentActions, void> {
  /// Kaydetme, geri alma ve kilit denetimi. Bildirimin Geri al'ı form
  /// kapandıktan sonra da çalışsın diye sürekli yaşar.
  TreatmentActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'treatmentActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$treatmentActionsHash();

  @$internal
  @override
  TreatmentActions create() => TreatmentActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$treatmentActionsHash() => r'ca63711e06d109506c13f3b498cdb1d7771420af';

/// Kaydetme, geri alma ve kilit denetimi. Bildirimin Geri al'ı form
/// kapandıktan sonra da çalışsın diye sürekli yaşar.

abstract class _$TreatmentActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

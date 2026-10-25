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

/// Kovanın uygulamaları, en son başlayan önce.

@ProviderFor(hiveTreatments)
final hiveTreatmentsProvider = HiveTreatmentsFamily._();

/// Kovanın uygulamaları, en son başlayan önce.

final class HiveTreatmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Treatment>>,
          List<Treatment>,
          Stream<List<Treatment>>
        >
    with $FutureModifier<List<Treatment>>, $StreamProvider<List<Treatment>> {
  /// Kovanın uygulamaları, en son başlayan önce.
  HiveTreatmentsProvider._({
    required HiveTreatmentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveTreatmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveTreatmentsHash();

  @override
  String toString() {
    return r'hiveTreatmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Treatment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Treatment>> create(Ref ref) {
    final argument = this.argument as String;
    return hiveTreatments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveTreatmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveTreatmentsHash() => r'0b9c3f600242ac54721bd13bbe4019ee384fb07a';

/// Kovanın uygulamaları, en son başlayan önce.

final class HiveTreatmentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Treatment>>, String> {
  HiveTreatmentsFamily._()
    : super(
        retry: null,
        name: r'hiveTreatmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın uygulamaları, en son başlayan önce.

  HiveTreatmentsProvider call(String hiveId) =>
      HiveTreatmentsProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveTreatmentsProvider';
}

/// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine göre.

@ProviderFor(hivePrescriptions)
final hivePrescriptionsProvider = HivePrescriptionsFamily._();

/// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine göre.

final class HivePrescriptionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<MediaItem>>>,
          Map<String, List<MediaItem>>,
          Stream<Map<String, List<MediaItem>>>
        >
    with
        $FutureModifier<Map<String, List<MediaItem>>>,
        $StreamProvider<Map<String, List<MediaItem>>> {
  /// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine göre.
  HivePrescriptionsProvider._({
    required HivePrescriptionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hivePrescriptionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hivePrescriptionsHash();

  @override
  String toString() {
    return r'hivePrescriptionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, List<MediaItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, List<MediaItem>>> create(Ref ref) {
    final argument = this.argument as String;
    return hivePrescriptions(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HivePrescriptionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hivePrescriptionsHash() => r'779edbb6150c58b2b6a8cd1c1be88088e664055c';

/// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine göre.

final class HivePrescriptionsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, List<MediaItem>>>,
          String
        > {
  HivePrescriptionsFamily._()
    : super(
        retry: null,
        name: r'hivePrescriptionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine göre.

  HivePrescriptionsProvider call(String hiveId) =>
      HivePrescriptionsProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hivePrescriptionsProvider';
}

/// Arılıkta yapılan uygulamalar, en son başlayan önce (etken madde
/// rotasyonu).

@ProviderFor(apiaryTreatments)
final apiaryTreatmentsProvider = ApiaryTreatmentsFamily._();

/// Arılıkta yapılan uygulamalar, en son başlayan önce (etken madde
/// rotasyonu).

final class ApiaryTreatmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Treatment>>,
          List<Treatment>,
          Stream<List<Treatment>>
        >
    with $FutureModifier<List<Treatment>>, $StreamProvider<List<Treatment>> {
  /// Arılıkta yapılan uygulamalar, en son başlayan önce (etken madde
  /// rotasyonu).
  ApiaryTreatmentsProvider._({
    required ApiaryTreatmentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryTreatmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryTreatmentsHash();

  @override
  String toString() {
    return r'apiaryTreatmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Treatment>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Treatment>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryTreatments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryTreatmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryTreatmentsHash() => r'423511f2ebf2fedce37b535d56dcff66aeb342a1';

/// Arılıkta yapılan uygulamalar, en son başlayan önce (etken madde
/// rotasyonu).

final class ApiaryTreatmentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Treatment>>, String> {
  ApiaryTreatmentsFamily._()
    : super(
        retry: null,
        name: r'apiaryTreatmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılıkta yapılan uygulamalar, en son başlayan önce (etken madde
  /// rotasyonu).

  ApiaryTreatmentsProvider call(String apiaryId) =>
      ApiaryTreatmentsProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryTreatmentsProvider';
}

/// Kovanın şimdiki bekleme süresi kilidi (kovan kartındaki aktif ilaç);
/// kilit yoksa null. Uygulamalar değişince yeniden hesaplanır.

@ProviderFor(hiveWithdrawalLock)
final hiveWithdrawalLockProvider = HiveWithdrawalLockFamily._();

/// Kovanın şimdiki bekleme süresi kilidi (kovan kartındaki aktif ilaç);
/// kilit yoksa null. Uygulamalar değişince yeniden hesaplanır.

final class HiveWithdrawalLockProvider
    extends
        $FunctionalProvider<
          AsyncValue<WithdrawalLock?>,
          WithdrawalLock?,
          FutureOr<WithdrawalLock?>
        >
    with $FutureModifier<WithdrawalLock?>, $FutureProvider<WithdrawalLock?> {
  /// Kovanın şimdiki bekleme süresi kilidi (kovan kartındaki aktif ilaç);
  /// kilit yoksa null. Uygulamalar değişince yeniden hesaplanır.
  HiveWithdrawalLockProvider._({
    required HiveWithdrawalLockFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveWithdrawalLockProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveWithdrawalLockHash();

  @override
  String toString() {
    return r'hiveWithdrawalLockProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<WithdrawalLock?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<WithdrawalLock?> create(Ref ref) {
    final argument = this.argument as String;
    return hiveWithdrawalLock(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveWithdrawalLockProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveWithdrawalLockHash() =>
    r'fd8cc89ab1475a1313bece2036bf5e1423b9e8dd';

/// Kovanın şimdiki bekleme süresi kilidi (kovan kartındaki aktif ilaç);
/// kilit yoksa null. Uygulamalar değişince yeniden hesaplanır.

final class HiveWithdrawalLockFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<WithdrawalLock?>, String> {
  HiveWithdrawalLockFamily._()
    : super(
        retry: null,
        name: r'hiveWithdrawalLockProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın şimdiki bekleme süresi kilidi (kovan kartındaki aktif ilaç);
  /// kilit yoksa null. Uygulamalar değişince yeniden hesaplanır.

  HiveWithdrawalLockProvider call(String hiveId) =>
      HiveWithdrawalLockProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveWithdrawalLockProvider';
}

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

String _$treatmentActionsHash() => r'c34bbeed0bd084af95b282dd43b57f522c9a2416';

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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'lot_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(lotRepository)
final lotRepositoryProvider = LotRepositoryProvider._();

final class LotRepositoryProvider
    extends $FunctionalProvider<LotRepository, LotRepository, LotRepository>
    with $Provider<LotRepository> {
  LotRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotRepositoryHash();

  @$internal
  @override
  $ProviderElement<LotRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LotRepository create(Ref ref) {
    return lotRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LotRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LotRepository>(value),
    );
  }
}

String _$lotRepositoryHash() => r'6ca2eaa4cb1b379578f93edfd18841891fcdd465';

/// Oturumdaki işletmenin lotları ve hesaplanan değerleri, yeni önce;
/// işletme yoksa boş.

@ProviderFor(lotSummaries)
final lotSummariesProvider = LotSummariesProvider._();

/// Oturumdaki işletmenin lotları ve hesaplanan değerleri, yeni önce;
/// işletme yoksa boş.

final class LotSummariesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LotSummary>>,
          List<LotSummary>,
          Stream<List<LotSummary>>
        >
    with $FutureModifier<List<LotSummary>>, $StreamProvider<List<LotSummary>> {
  /// Oturumdaki işletmenin lotları ve hesaplanan değerleri, yeni önce;
  /// işletme yoksa boş.
  LotSummariesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotSummariesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotSummariesHash();

  @$internal
  @override
  $StreamProviderElement<List<LotSummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LotSummary>> create(Ref ref) {
    return lotSummaries(ref);
  }
}

String _$lotSummariesHash() => r'33c0ad4c61c01e8ab503364d2edd87f1d6ac835f';

/// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.

@ProviderFor(lotSummary)
final lotSummaryProvider = LotSummaryFamily._();

/// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.

final class LotSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<LotSummary?>,
          LotSummary?,
          Stream<LotSummary?>
        >
    with $FutureModifier<LotSummary?>, $StreamProvider<LotSummary?> {
  /// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.
  LotSummaryProvider._({
    required LotSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lotSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotSummaryHash();

  @override
  String toString() {
    return r'lotSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<LotSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<LotSummary?> create(Ref ref) {
    final argument = this.argument as String;
    return lotSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LotSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotSummaryHash() => r'8f1727bf8ddfc44010d2833f3efe607db78cc4c9';

/// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.

final class LotSummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<LotSummary?>, String> {
  LotSummaryFamily._()
    : super(
        retry: null,
        name: r'lotSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.

  LotSummaryProvider call(String id) =>
      LotSummaryProvider._(argument: id, from: this);

  @override
  String toString() => r'lotSummaryProvider';
}

/// Hasat eklenebilecek açık lotlar, yeni önce; işletme yoksa boş.

@ProviderFor(openLots)
final openLotsProvider = OpenLotsProvider._();

/// Hasat eklenebilecek açık lotlar, yeni önce; işletme yoksa boş.

final class OpenLotsProvider
    extends
        $FunctionalProvider<AsyncValue<List<Lot>>, List<Lot>, Stream<List<Lot>>>
    with $FutureModifier<List<Lot>>, $StreamProvider<List<Lot>> {
  /// Hasat eklenebilecek açık lotlar, yeni önce; işletme yoksa boş.
  OpenLotsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'openLotsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$openLotsHash();

  @$internal
  @override
  $StreamProviderElement<List<Lot>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Lot>> create(Ref ref) {
    return openLots(ref);
  }
}

String _$openLotsHash() => r'e8b506af0ed2b4686bcea5acde973657cec16217';

/// Lotun hasatları, yeni önce.

@ProviderFor(lotHarvests)
final lotHarvestsProvider = LotHarvestsFamily._();

/// Lotun hasatları, yeni önce.

final class LotHarvestsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LotHarvestRow>>,
          List<LotHarvestRow>,
          Stream<List<LotHarvestRow>>
        >
    with
        $FutureModifier<List<LotHarvestRow>>,
        $StreamProvider<List<LotHarvestRow>> {
  /// Lotun hasatları, yeni önce.
  LotHarvestsProvider._({
    required LotHarvestsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lotHarvestsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotHarvestsHash();

  @override
  String toString() {
    return r'lotHarvestsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<LotHarvestRow>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LotHarvestRow>> create(Ref ref) {
    final argument = this.argument as String;
    return lotHarvests(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LotHarvestsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotHarvestsHash() => r'05ed28f852b0328bca19a445973904d820741068';

/// Lotun hasatları, yeni önce.

final class LotHarvestsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<LotHarvestRow>>, String> {
  LotHarvestsFamily._()
    : super(
        retry: null,
        name: r'lotHarvestsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lotun hasatları, yeni önce.

  LotHarvestsProvider call(String lotId) =>
      LotHarvestsProvider._(argument: lotId, from: this);

  @override
  String toString() => r'lotHarvestsProvider';
}

/// Lota bağlı son ilaçlamalar; ihlaller önce.

@ProviderFor(lotTreatments)
final lotTreatmentsProvider = LotTreatmentsFamily._();

/// Lota bağlı son ilaçlamalar; ihlaller önce.

final class LotTreatmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LotTreatmentRow>>,
          List<LotTreatmentRow>,
          Stream<List<LotTreatmentRow>>
        >
    with
        $FutureModifier<List<LotTreatmentRow>>,
        $StreamProvider<List<LotTreatmentRow>> {
  /// Lota bağlı son ilaçlamalar; ihlaller önce.
  LotTreatmentsProvider._({
    required LotTreatmentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lotTreatmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotTreatmentsHash();

  @override
  String toString() {
    return r'lotTreatmentsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<LotTreatmentRow>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LotTreatmentRow>> create(Ref ref) {
    final argument = this.argument as String;
    return lotTreatments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LotTreatmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotTreatmentsHash() => r'1234227f4817403bda2881d2d3d4fef9c5e0d32d';

/// Lota bağlı son ilaçlamalar; ihlaller önce.

final class LotTreatmentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<LotTreatmentRow>>, String> {
  LotTreatmentsFamily._()
    : super(
        retry: null,
        name: r'lotTreatmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lota bağlı son ilaçlamalar; ihlaller önce.

  LotTreatmentsProvider call(String lotId) =>
      LotTreatmentsProvider._(argument: lotId, from: this);

  @override
  String toString() => r'lotTreatmentsProvider';
}

/// Lotun analizleri, yeni önce.

@ProviderFor(lotLabResults)
final lotLabResultsProvider = LotLabResultsFamily._();

/// Lotun analizleri, yeni önce.

final class LotLabResultsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LabResult>>,
          List<LabResult>,
          Stream<List<LabResult>>
        >
    with $FutureModifier<List<LabResult>>, $StreamProvider<List<LabResult>> {
  /// Lotun analizleri, yeni önce.
  LotLabResultsProvider._({
    required LotLabResultsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lotLabResultsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotLabResultsHash();

  @override
  String toString() {
    return r'lotLabResultsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<LabResult>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LabResult>> create(Ref ref) {
    final argument = this.argument as String;
    return lotLabResults(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LotLabResultsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotLabResultsHash() => r'989475b4566b96d4a4709aa954483a33eeb98b67';

/// Lotun analizleri, yeni önce.

final class LotLabResultsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<LabResult>>, String> {
  LotLabResultsFamily._()
    : super(
        retry: null,
        name: r'lotLabResultsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lotun analizleri, yeni önce.

  LotLabResultsProvider call(String lotId) =>
      LotLabResultsProvider._(argument: lotId, from: this);

  @override
  String toString() => r'lotLabResultsProvider';
}

/// Lotun satışları, yeni önce.

@ProviderFor(lotSales)
final lotSalesProvider = LotSalesFamily._();

/// Lotun satışları, yeni önce.

final class LotSalesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<LotSale>>,
          List<LotSale>,
          Stream<List<LotSale>>
        >
    with $FutureModifier<List<LotSale>>, $StreamProvider<List<LotSale>> {
  /// Lotun satışları, yeni önce.
  LotSalesProvider._({
    required LotSalesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'lotSalesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$lotSalesHash();

  @override
  String toString() {
    return r'lotSalesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<LotSale>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<LotSale>> create(Ref ref) {
    final argument = this.argument as String;
    return lotSales(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is LotSalesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$lotSalesHash() => r'7d171aa4f989241f38dc94f84e099cd1e9cf240c';

/// Lotun satışları, yeni önce.

final class LotSalesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<LotSale>>, String> {
  LotSalesFamily._()
    : super(
        retry: null,
        name: r'lotSalesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Lotun satışları, yeni önce.

  LotSalesProvider call(String lotId) =>
      LotSalesProvider._(argument: lotId, from: this);

  @override
  String toString() => r'lotSalesProvider';
}

/// Hasat; yoksa ya da silinmişse (Geri al) null.

@ProviderFor(harvest)
final harvestProvider = HarvestFamily._();

/// Hasat; yoksa ya da silinmişse (Geri al) null.

final class HarvestProvider
    extends
        $FunctionalProvider<AsyncValue<Harvest?>, Harvest?, Stream<Harvest?>>
    with $FutureModifier<Harvest?>, $StreamProvider<Harvest?> {
  /// Hasat; yoksa ya da silinmişse (Geri al) null.
  HarvestProvider._({
    required HarvestFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'harvestProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$harvestHash();

  @override
  String toString() {
    return r'harvestProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Harvest?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Harvest?> create(Ref ref) {
    final argument = this.argument as String;
    return harvest(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HarvestProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$harvestHash() => r'6d30376f2bfbcb9474267f20644a94b2a091cfc8';

/// Hasat; yoksa ya da silinmişse (Geri al) null.

final class HarvestFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Harvest?>, String> {
  HarvestFamily._()
    : super(
        retry: null,
        name: r'harvestProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hasat; yoksa ya da silinmişse (Geri al) null.

  HarvestProvider call(String id) =>
      HarvestProvider._(argument: id, from: this);

  @override
  String toString() => r'harvestProvider';
}

/// Belge kasasındaki analiz raporları (analize bağlanabilecek belgeler).

@ProviderFor(analysisReports)
final analysisReportsProvider = AnalysisReportsProvider._();

/// Belge kasasındaki analiz raporları (analize bağlanabilecek belgeler).

final class AnalysisReportsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VaultDocument>>,
          List<VaultDocument>,
          FutureOr<List<VaultDocument>>
        >
    with
        $FutureModifier<List<VaultDocument>>,
        $FutureProvider<List<VaultDocument>> {
  /// Belge kasasındaki analiz raporları (analize bağlanabilecek belgeler).
  AnalysisReportsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'analysisReportsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$analysisReportsHash();

  @$internal
  @override
  $FutureProviderElement<List<VaultDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<VaultDocument>> create(Ref ref) {
    return analysisReports(ref);
  }
}

String _$analysisReportsHash() => r'1c65a7eda0c32da844bc17c00942f168c61eb789';

/// Lot yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da çalışsın
/// diye sürekli yaşar.

@ProviderFor(LotActions)
final lotActionsProvider = LotActionsProvider._();

/// Lot yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da çalışsın
/// diye sürekli yaşar.
final class LotActionsProvider extends $NotifierProvider<LotActions, void> {
  /// Lot yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da çalışsın
  /// diye sürekli yaşar.
  LotActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lotActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lotActionsHash();

  @$internal
  @override
  LotActions create() => LotActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$lotActionsHash() => r'bc31cb55e3dbaab7b9a876bbc3263e036ce9257a';

/// Lot yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da çalışsın
/// diye sürekli yaşar.

abstract class _$LotActions extends $Notifier<void> {
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

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(reportRepository)
final reportRepositoryProvider = ReportRepositoryProvider._();

final class ReportRepositoryProvider
    extends
        $FunctionalProvider<
          ReportRepository,
          ReportRepository,
          ReportRepository
        >
    with $Provider<ReportRepository> {
  ReportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ReportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ReportRepository create(Ref ref) {
    return reportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportRepository>(value),
    );
  }
}

String _$reportRepositoryHash() => r'1be4e231be38c592cea2e614877f781d583c9682';

/// TR başlığının tescil ve AKS numaraları; rapor ekranı bunlarla dolar.

@ProviderFor(organizationRegistration)
final organizationRegistrationProvider = OrganizationRegistrationProvider._();

/// TR başlığının tescil ve AKS numaraları; rapor ekranı bunlarla dolar.

final class OrganizationRegistrationProvider
    extends
        $FunctionalProvider<
          AsyncValue<OrganizationRegistration>,
          OrganizationRegistration,
          Stream<OrganizationRegistration>
        >
    with
        $FutureModifier<OrganizationRegistration>,
        $StreamProvider<OrganizationRegistration> {
  /// TR başlığının tescil ve AKS numaraları; rapor ekranı bunlarla dolar.
  OrganizationRegistrationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationRegistrationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationRegistrationHash();

  @$internal
  @override
  $StreamProviderElement<OrganizationRegistration> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<OrganizationRegistration> create(Ref ref) {
    return organizationRegistration(ref);
  }
}

String _$organizationRegistrationHash() =>
    r'aeb8787031ed85d78c669a829d688bbc403d8c19';

/// Raporun verisi; ekranın önizlemesi ve PDF aynı veriden. Dönem [from]
/// ile [to] günleri arası (ikisi de dahil); [apiaryId] boşsa bütün
/// arılıklar; [hiveId] yalnız kovan geçmişinde, boşsa kapsamdaki kovanlar.
/// Rapor bir anın dökümüdür, kayıt değişince kendiliğinden yenilenmez.

@ProviderFor(reportData)
final reportDataProvider = ReportDataFamily._();

/// Raporun verisi; ekranın önizlemesi ve PDF aynı veriden. Dönem [from]
/// ile [to] günleri arası (ikisi de dahil); [apiaryId] boşsa bütün
/// arılıklar; [hiveId] yalnız kovan geçmişinde, boşsa kapsamdaki kovanlar.
/// Rapor bir anın dökümüdür, kayıt değişince kendiliğinden yenilenmez.

final class ReportDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<ReportData>,
          ReportData,
          FutureOr<ReportData>
        >
    with $FutureModifier<ReportData>, $FutureProvider<ReportData> {
  /// Raporun verisi; ekranın önizlemesi ve PDF aynı veriden. Dönem [from]
  /// ile [to] günleri arası (ikisi de dahil); [apiaryId] boşsa bütün
  /// arılıklar; [hiveId] yalnız kovan geçmişinde, boşsa kapsamdaki kovanlar.
  /// Rapor bir anın dökümüdür, kayıt değişince kendiliğinden yenilenmez.
  ReportDataProvider._({
    required ReportDataFamily super.from,
    required ({
      ReportKind kind,
      DateTime from,
      DateTime to,
      String? apiaryId,
      String? hiveId,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'reportDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$reportDataHash();

  @override
  String toString() {
    return r'reportDataProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<ReportData> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ReportData> create(Ref ref) {
    final argument =
        this.argument
            as ({
              ReportKind kind,
              DateTime from,
              DateTime to,
              String? apiaryId,
              String? hiveId,
            });
    return reportData(
      ref,
      kind: argument.kind,
      from: argument.from,
      to: argument.to,
      apiaryId: argument.apiaryId,
      hiveId: argument.hiveId,
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ReportDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reportDataHash() => r'4b694a185f0ca4c3dc436418530ec1ce6542e5f7';

/// Raporun verisi; ekranın önizlemesi ve PDF aynı veriden. Dönem [from]
/// ile [to] günleri arası (ikisi de dahil); [apiaryId] boşsa bütün
/// arılıklar; [hiveId] yalnız kovan geçmişinde, boşsa kapsamdaki kovanlar.
/// Rapor bir anın dökümüdür, kayıt değişince kendiliğinden yenilenmez.

final class ReportDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<ReportData>,
          ({
            ReportKind kind,
            DateTime from,
            DateTime to,
            String? apiaryId,
            String? hiveId,
          })
        > {
  ReportDataFamily._()
    : super(
        retry: null,
        name: r'reportDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Raporun verisi; ekranın önizlemesi ve PDF aynı veriden. Dönem [from]
  /// ile [to] günleri arası (ikisi de dahil); [apiaryId] boşsa bütün
  /// arılıklar; [hiveId] yalnız kovan geçmişinde, boşsa kapsamdaki kovanlar.
  /// Rapor bir anın dökümüdür, kayıt değişince kendiliğinden yenilenmez.

  ReportDataProvider call({
    required ReportKind kind,
    required DateTime from,
    required DateTime to,
    String? apiaryId,
    String? hiveId,
  }) => ReportDataProvider._(
    argument: (
      kind: kind,
      from: from,
      to: to,
      apiaryId: apiaryId,
      hiveId: hiveId,
    ),
    from: this,
  );

  @override
  String toString() => r'reportDataProvider';
}

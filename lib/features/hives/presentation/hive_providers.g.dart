// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(hiveRepository)
final hiveRepositoryProvider = HiveRepositoryProvider._();

final class HiveRepositoryProvider
    extends $FunctionalProvider<HiveRepository, HiveRepository, HiveRepository>
    with $Provider<HiveRepository> {
  HiveRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveRepositoryHash();

  @$internal
  @override
  $ProviderElement<HiveRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HiveRepository create(Ref ref) {
    return hiveRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveRepository>(value),
    );
  }
}

String _$hiveRepositoryHash() => r'9da2e27e0f176ed634cab8563a6a065ca32435f6';

@ProviderFor(hiveLocationRepository)
final hiveLocationRepositoryProvider = HiveLocationRepositoryProvider._();

final class HiveLocationRepositoryProvider
    extends
        $FunctionalProvider<
          HiveLocationRepository,
          HiveLocationRepository,
          HiveLocationRepository
        >
    with $Provider<HiveLocationRepository> {
  HiveLocationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveLocationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveLocationRepositoryHash();

  @$internal
  @override
  $ProviderElement<HiveLocationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HiveLocationRepository create(Ref ref) {
    return hiveLocationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveLocationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveLocationRepository>(value),
    );
  }
}

String _$hiveLocationRepositoryHash() =>
    r'ada8f1ada683faaa26a11135140324656aa87858';

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").

@ProviderFor(apiaryHives)
final apiaryHivesProvider = ApiaryHivesFamily._();

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").

final class ApiaryHivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Hive>>,
          List<Hive>,
          Stream<List<Hive>>
        >
    with $FutureModifier<List<Hive>>, $StreamProvider<List<Hive>> {
  /// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
  /// "10").
  ApiaryHivesProvider._({
    required ApiaryHivesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryHivesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryHivesHash();

  @override
  String toString() {
    return r'apiaryHivesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Hive>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Hive>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryHives(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryHivesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryHivesHash() => r'914a5de490a88eea1aa6581d01177de417399440';

/// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
/// "10").

final class ApiaryHivesFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Hive>>, String> {
  ApiaryHivesFamily._()
    : super(
        retry: null,
        name: r'apiaryHivesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılıktaki kovanlar (her durumda); numaralar sayı sırasıyla ("9" <
  /// "10").

  ApiaryHivesProvider call(String apiaryId) =>
      ApiaryHivesProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryHivesProvider';
}

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.

@ProviderFor(organizationHives)
final organizationHivesProvider = OrganizationHivesProvider._();

/// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
/// yoksa boş.

final class OrganizationHivesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Hive>>,
          List<Hive>,
          Stream<List<Hive>>
        >
    with $FutureModifier<List<Hive>>, $StreamProvider<List<Hive>> {
  /// İşletmenin kovanları (her durumda); numaralar sayı sırasıyla. İşletme
  /// yoksa boş.
  OrganizationHivesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationHivesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationHivesHash();

  @$internal
  @override
  $StreamProviderElement<List<Hive>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Hive>> create(Ref ref) {
    return organizationHives(ref);
  }
}

String _$organizationHivesHash() => r'66165a9e7ebc62f72f08c44cf062ff71ac080773';

/// Kovan kartı; kovan yoksa ya da silindiyse null.

@ProviderFor(hive)
final hiveProvider = HiveFamily._();

/// Kovan kartı; kovan yoksa ya da silindiyse null.

final class HiveProvider
    extends $FunctionalProvider<AsyncValue<Hive?>, Hive?, Stream<Hive?>>
    with $FutureModifier<Hive?>, $StreamProvider<Hive?> {
  /// Kovan kartı; kovan yoksa ya da silindiyse null.
  HiveProvider._({
    required HiveFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveHash();

  @override
  String toString() {
    return r'hiveProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Hive?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Hive?> create(Ref ref) {
    final argument = this.argument as String;
    return hive(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveHash() => r'c0a702a587ef56f1b0fb5137d9a606aeccf3c2f9';

/// Kovan kartı; kovan yoksa ya da silindiyse null.

final class HiveFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Hive?>, String> {
  HiveFamily._()
    : super(
        retry: null,
        name: r'hiveProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovan kartı; kovan yoksa ya da silindiyse null.

  HiveProvider call(String hiveId) =>
      HiveProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveProvider';
}

/// Arılıktaki kovanların güç puanları, her birinin son muayenesinden
/// ([strengthScore]); puanı olmayan kovan haritada yok.

@ProviderFor(apiaryHiveStrengths)
final apiaryHiveStrengthsProvider = ApiaryHiveStrengthsFamily._();

/// Arılıktaki kovanların güç puanları, her birinin son muayenesinden
/// ([strengthScore]); puanı olmayan kovan haritada yok.

final class ApiaryHiveStrengthsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          Stream<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $StreamProvider<Map<String, int>> {
  /// Arılıktaki kovanların güç puanları, her birinin son muayenesinden
  /// ([strengthScore]); puanı olmayan kovan haritada yok.
  ApiaryHiveStrengthsProvider._({
    required ApiaryHiveStrengthsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryHiveStrengthsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryHiveStrengthsHash();

  @override
  String toString() {
    return r'apiaryHiveStrengthsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, int>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryHiveStrengths(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryHiveStrengthsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryHiveStrengthsHash() =>
    r'5902bc7ab2644256b9613317c1827999d72aab58';

/// Arılıktaki kovanların güç puanları, her birinin son muayenesinden
/// ([strengthScore]); puanı olmayan kovan haritada yok.

final class ApiaryHiveStrengthsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Map<String, int>>, String> {
  ApiaryHiveStrengthsFamily._()
    : super(
        retry: null,
        name: r'apiaryHiveStrengthsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılıktaki kovanların güç puanları, her birinin son muayenesinden
  /// ([strengthScore]); puanı olmayan kovan haritada yok.

  ApiaryHiveStrengthsProvider call(String apiaryId) =>
      ApiaryHiveStrengthsProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryHiveStrengthsProvider';
}

/// Kovanın muayeneleri, en yeni önce.

@ProviderFor(hiveInspections)
final hiveInspectionsProvider = HiveInspectionsFamily._();

/// Kovanın muayeneleri, en yeni önce.

final class HiveInspectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Inspection>>,
          List<Inspection>,
          Stream<List<Inspection>>
        >
    with $FutureModifier<List<Inspection>>, $StreamProvider<List<Inspection>> {
  /// Kovanın muayeneleri, en yeni önce.
  HiveInspectionsProvider._({
    required HiveInspectionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveInspectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveInspectionsHash();

  @override
  String toString() {
    return r'hiveInspectionsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Inspection>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Inspection>> create(Ref ref) {
    final argument = this.argument as String;
    return hiveInspections(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveInspectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveInspectionsHash() => r'6f7ded8b5dd838596c674dd3183e3af4fc8ea0ad';

/// Kovanın muayeneleri, en yeni önce.

final class HiveInspectionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Inspection>>, String> {
  HiveInspectionsFamily._()
    : super(
        retry: null,
        name: r'hiveInspectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın muayeneleri, en yeni önce.

  HiveInspectionsProvider call(String hiveId) =>
      HiveInspectionsProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveInspectionsProvider';
}

/// Kovanın güç puanı, son muayenesinden ([strengthScore]); muayene ya da
/// arılı çerçeve yoksa null. Zaman tüneliyle aynı akışı okur.

@ProviderFor(hiveStrength)
final hiveStrengthProvider = HiveStrengthFamily._();

/// Kovanın güç puanı, son muayenesinden ([strengthScore]); muayene ya da
/// arılı çerçeve yoksa null. Zaman tüneliyle aynı akışı okur.

final class HiveStrengthProvider
    extends $FunctionalProvider<AsyncValue<int?>, int?, FutureOr<int?>>
    with $FutureModifier<int?>, $FutureProvider<int?> {
  /// Kovanın güç puanı, son muayenesinden ([strengthScore]); muayene ya da
  /// arılı çerçeve yoksa null. Zaman tüneliyle aynı akışı okur.
  HiveStrengthProvider._({
    required HiveStrengthFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveStrengthProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveStrengthHash();

  @override
  String toString() {
    return r'hiveStrengthProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int?> create(Ref ref) {
    final argument = this.argument as String;
    return hiveStrength(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveStrengthProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveStrengthHash() => r'a3fde43b0d30daa8cb197bf4588c3c1ecdc9113e';

/// Kovanın güç puanı, son muayenesinden ([strengthScore]); muayene ya da
/// arılı çerçeve yoksa null. Zaman tüneliyle aynı akışı okur.

final class HiveStrengthFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int?>, String> {
  HiveStrengthFamily._()
    : super(
        retry: null,
        name: r'hiveStrengthProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın güç puanı, son muayenesinden ([strengthScore]); muayene ya da
  /// arılı çerçeve yoksa null. Zaman tüneliyle aynı akışı okur.

  HiveStrengthProvider call(String hiveId) =>
      HiveStrengthProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveStrengthProvider';
}

@ProviderFor(hiveLocationHistory)
final hiveLocationHistoryProvider = HiveLocationHistoryFamily._();

final class HiveLocationHistoryProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HiveLocationEntry>>,
          List<HiveLocationEntry>,
          Stream<List<HiveLocationEntry>>
        >
    with
        $FutureModifier<List<HiveLocationEntry>>,
        $StreamProvider<List<HiveLocationEntry>> {
  HiveLocationHistoryProvider._({
    required HiveLocationHistoryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveLocationHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveLocationHistoryHash();

  @override
  String toString() {
    return r'hiveLocationHistoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<HiveLocationEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<HiveLocationEntry>> create(Ref ref) {
    final argument = this.argument as String;
    return hiveLocationHistory(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveLocationHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveLocationHistoryHash() =>
    r'74a19f57eaeb23bec08468624e887886ba823bda';

final class HiveLocationHistoryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<HiveLocationEntry>>, String> {
  HiveLocationHistoryFamily._()
    : super(
        retry: null,
        name: r'hiveLocationHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HiveLocationHistoryProvider call(String hiveId) =>
      HiveLocationHistoryProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveLocationHistoryProvider';
}

/// Kovanın zaman tüneli: bütün kayıt türlerinin olayları tek listede, en
/// yeni önce. Yeni bir tür kendi akışını izleyen bir provider yazar ve
/// olaylarını buradaki listeye ekler; kaynaklardan biri değişince tünel
/// yeniden kurulur.

@ProviderFor(hiveTimeline)
final hiveTimelineProvider = HiveTimelineFamily._();

/// Kovanın zaman tüneli: bütün kayıt türlerinin olayları tek listede, en
/// yeni önce. Yeni bir tür kendi akışını izleyen bir provider yazar ve
/// olaylarını buradaki listeye ekler; kaynaklardan biri değişince tünel
/// yeniden kurulur.

final class HiveTimelineProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HiveTimelineEvent>>,
          List<HiveTimelineEvent>,
          FutureOr<List<HiveTimelineEvent>>
        >
    with
        $FutureModifier<List<HiveTimelineEvent>>,
        $FutureProvider<List<HiveTimelineEvent>> {
  /// Kovanın zaman tüneli: bütün kayıt türlerinin olayları tek listede, en
  /// yeni önce. Yeni bir tür kendi akışını izleyen bir provider yazar ve
  /// olaylarını buradaki listeye ekler; kaynaklardan biri değişince tünel
  /// yeniden kurulur.
  HiveTimelineProvider._({
    required HiveTimelineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveTimelineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveTimelineHash();

  @override
  String toString() {
    return r'hiveTimelineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<HiveTimelineEvent>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HiveTimelineEvent>> create(Ref ref) {
    final argument = this.argument as String;
    return hiveTimeline(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveTimelineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveTimelineHash() => r'65ce1ccec6a5f6cbdd363f676dd98c2b4f436ed3';

/// Kovanın zaman tüneli: bütün kayıt türlerinin olayları tek listede, en
/// yeni önce. Yeni bir tür kendi akışını izleyen bir provider yazar ve
/// olaylarını buradaki listeye ekler; kaynaklardan biri değişince tünel
/// yeniden kurulur.

final class HiveTimelineFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<HiveTimelineEvent>>, String> {
  HiveTimelineFamily._()
    : super(
        retry: null,
        name: r'hiveTimelineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın zaman tüneli: bütün kayıt türlerinin olayları tek listede, en
  /// yeni önce. Yeni bir tür kendi akışını izleyen bir provider yazar ve
  /// olaylarını buradaki listeye ekler; kaynaklardan biri değişince tünel
  /// yeniden kurulur.

  HiveTimelineProvider call(String hiveId) =>
      HiveTimelineProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveTimelineProvider';
}

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.

@ProviderFor(HiveLayoutPreference)
final hiveLayoutPreferenceProvider = HiveLayoutPreferenceProvider._();

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.
final class HiveLayoutPreferenceProvider
    extends $NotifierProvider<HiveLayoutPreference, HiveLayout> {
  /// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
  /// uygulama yeniden açılınca ızgaraya döner.
  HiveLayoutPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveLayoutPreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveLayoutPreferenceHash();

  @$internal
  @override
  HiveLayoutPreference create() => HiveLayoutPreference();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveLayout value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveLayout>(value),
    );
  }
}

String _$hiveLayoutPreferenceHash() =>
    r'2b8a40d4c7efe1c1027cbd4ac8027eef4a8f84f9';

/// Arılık detayındaki kovan görünümü: ızgara ya da liste. Yalnız bellekte;
/// uygulama yeniden açılınca ızgaraya döner.

abstract class _$HiveLayoutPreference extends $Notifier<HiveLayout> {
  HiveLayout build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HiveLayout, HiveLayout>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HiveLayout, HiveLayout>,
              HiveLayout,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Arılık detayındaki aktif kovanların sırası: numara ya da zayıflar önce
/// ([sortWeakestFirst]). Izgaraya ve listeye birlikte uygulanır. Yalnız
/// bellekte; uygulama yeniden açılınca numara sırasına döner.

@ProviderFor(HiveSortPreference)
final hiveSortPreferenceProvider = HiveSortPreferenceProvider._();

/// Arılık detayındaki aktif kovanların sırası: numara ya da zayıflar önce
/// ([sortWeakestFirst]). Izgaraya ve listeye birlikte uygulanır. Yalnız
/// bellekte; uygulama yeniden açılınca numara sırasına döner.
final class HiveSortPreferenceProvider
    extends $NotifierProvider<HiveSortPreference, HiveSort> {
  /// Arılık detayındaki aktif kovanların sırası: numara ya da zayıflar önce
  /// ([sortWeakestFirst]). Izgaraya ve listeye birlikte uygulanır. Yalnız
  /// bellekte; uygulama yeniden açılınca numara sırasına döner.
  HiveSortPreferenceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveSortPreferenceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveSortPreferenceHash();

  @$internal
  @override
  HiveSortPreference create() => HiveSortPreference();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HiveSort value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HiveSort>(value),
    );
  }
}

String _$hiveSortPreferenceHash() =>
    r'a2a103646757eff74378a21b8eba99f38ded7cc7';

/// Arılık detayındaki aktif kovanların sırası: numara ya da zayıflar önce
/// ([sortWeakestFirst]). Izgaraya ve listeye birlikte uygulanır. Yalnız
/// bellekte; uygulama yeniden açılınca numara sırasına döner.

abstract class _$HiveSortPreference extends $Notifier<HiveSort> {
  HiveSort build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<HiveSort, HiveSort>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<HiveSort, HiveSort>,
              HiveSort,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma, karantina. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.

@ProviderFor(HiveActions)
final hiveActionsProvider = HiveActionsProvider._();

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma, karantina. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.
final class HiveActionsProvider extends $NotifierProvider<HiveActions, void> {
  /// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
  /// alma, karantina. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
  /// sürekli yaşar. Her şey yerel DB'ye yazılır.
  HiveActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hiveActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hiveActionsHash();

  @$internal
  @override
  HiveActions create() => HiveActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$hiveActionsHash() => r'a5f7a3290316b14fafa89248995ec34b2c991ddf';

/// Kovan kartındaki eylemler: durum değiştirme, taşıma ve taşımayı geri
/// alma, karantina. Geri al snackbar'ı ekran kapandıktan sonra da çalışsın diye
/// sürekli yaşar. Her şey yerel DB'ye yazılır.

abstract class _$HiveActions extends $Notifier<void> {
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

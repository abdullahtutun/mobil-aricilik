// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'migration_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(migrationRepository)
final migrationRepositoryProvider = MigrationRepositoryProvider._();

final class MigrationRepositoryProvider
    extends
        $FunctionalProvider<
          MigrationRepository,
          MigrationRepository,
          MigrationRepository
        >
    with $Provider<MigrationRepository> {
  MigrationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'migrationRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$migrationRepositoryHash();

  @$internal
  @override
  $ProviderElement<MigrationRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MigrationRepository create(Ref ref) {
    return migrationRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MigrationRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MigrationRepository>(value),
    );
  }
}

String _$migrationRepositoryHash() =>
    r'4e093de14a6d09bd19d276aa80970476f8d68ffb';

@ProviderFor(transportRepository)
final transportRepositoryProvider = TransportRepositoryProvider._();

final class TransportRepositoryProvider
    extends
        $FunctionalProvider<
          TransportRepository,
          TransportRepository,
          TransportRepository
        >
    with $Provider<TransportRepository> {
  TransportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportRepositoryHash();

  @$internal
  @override
  $ProviderElement<TransportRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  TransportRepository create(Ref ref) {
    return transportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TransportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TransportRepository>(value),
    );
  }
}

String _$transportRepositoryHash() =>
    r'c3881346683ff48ff7f81f4e8ac254aaca39ce8d';

/// Oturumdaki işletmenin göç planları, yeni yıl önce; işletme yoksa boş.

@ProviderFor(migrations)
final migrationsProvider = MigrationsProvider._();

/// Oturumdaki işletmenin göç planları, yeni yıl önce; işletme yoksa boş.

final class MigrationsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Migration>>,
          List<Migration>,
          Stream<List<Migration>>
        >
    with $FutureModifier<List<Migration>>, $StreamProvider<List<Migration>> {
  /// Oturumdaki işletmenin göç planları, yeni yıl önce; işletme yoksa boş.
  MigrationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'migrationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$migrationsHash();

  @$internal
  @override
  $StreamProviderElement<List<Migration>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Migration>> create(Ref ref) {
    return migrations(ref);
  }
}

String _$migrationsHash() => r'f0d10e5dcd1ff618b600724bd89a930369d31874';

/// Göç planı; yoksa ya da silinmişse null.

@ProviderFor(migration)
final migrationProvider = MigrationFamily._();

/// Göç planı; yoksa ya da silinmişse null.

final class MigrationProvider
    extends
        $FunctionalProvider<
          AsyncValue<Migration?>,
          Migration?,
          Stream<Migration?>
        >
    with $FutureModifier<Migration?>, $StreamProvider<Migration?> {
  /// Göç planı; yoksa ya da silinmişse null.
  MigrationProvider._({
    required MigrationFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'migrationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$migrationHash();

  @override
  String toString() {
    return r'migrationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Migration?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Migration?> create(Ref ref) {
    final argument = this.argument as String;
    return migration(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MigrationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$migrationHash() => r'15c32c62bb7516122f15bfebc08ccaf31e840a87';

/// Göç planı; yoksa ya da silinmişse null.

final class MigrationFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Migration?>, String> {
  MigrationFamily._()
    : super(
        retry: null,
        name: r'migrationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Göç planı; yoksa ya da silinmişse null.

  MigrationProvider call(String id) =>
      MigrationProvider._(argument: id, from: this);

  @override
  String toString() => r'migrationProvider';
}

/// Planın durakları rota sırasıyla.

@ProviderFor(migrationStops)
final migrationStopsProvider = MigrationStopsFamily._();

/// Planın durakları rota sırasıyla.

final class MigrationStopsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MigrationStop>>,
          List<MigrationStop>,
          Stream<List<MigrationStop>>
        >
    with
        $FutureModifier<List<MigrationStop>>,
        $StreamProvider<List<MigrationStop>> {
  /// Planın durakları rota sırasıyla.
  MigrationStopsProvider._({
    required MigrationStopsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'migrationStopsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$migrationStopsHash();

  @override
  String toString() {
    return r'migrationStopsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MigrationStop>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MigrationStop>> create(Ref ref) {
    final argument = this.argument as String;
    return migrationStops(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MigrationStopsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$migrationStopsHash() => r'936ef275a82f36b61f94f95b5c6729647d5eb12e';

/// Planın durakları rota sırasıyla.

final class MigrationStopsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MigrationStop>>, String> {
  MigrationStopsFamily._()
    : super(
        retry: null,
        name: r'migrationStopsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Planın durakları rota sırasıyla.

  MigrationStopsProvider call(String migrationId) =>
      MigrationStopsProvider._(argument: migrationId, from: this);

  @override
  String toString() => r'migrationStopsProvider';
}

/// Durak; yoksa ya da silinmişse null.

@ProviderFor(migrationStop)
final migrationStopProvider = MigrationStopFamily._();

/// Durak; yoksa ya da silinmişse null.

final class MigrationStopProvider
    extends
        $FunctionalProvider<
          AsyncValue<MigrationStop?>,
          MigrationStop?,
          Stream<MigrationStop?>
        >
    with $FutureModifier<MigrationStop?>, $StreamProvider<MigrationStop?> {
  /// Durak; yoksa ya da silinmişse null.
  MigrationStopProvider._({
    required MigrationStopFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'migrationStopProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$migrationStopHash();

  @override
  String toString() {
    return r'migrationStopProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<MigrationStop?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<MigrationStop?> create(Ref ref) {
    final argument = this.argument as String;
    return migrationStop(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MigrationStopProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$migrationStopHash() => r'ce7ca7da66df8f4373e124684bbb1818d4c966b3';

/// Durak; yoksa ya da silinmişse null.

final class MigrationStopFamily extends $Family
    with $FunctionalFamilyOverride<Stream<MigrationStop?>, String> {
  MigrationStopFamily._()
    : super(
        retry: null,
        name: r'migrationStopProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Durak; yoksa ya da silinmişse null.

  MigrationStopProvider call(String id) =>
      MigrationStopProvider._(argument: id, from: this);

  @override
  String toString() => r'migrationStopProvider';
}

/// Planın duraklarındaki hedef arılıkların plan yılından önceki verimi,
/// arılık kimliğine göre. Durak, hasat ya da plan yılı değişince yeniden
/// hesaplanır.

@ProviderFor(migrationYields)
final migrationYieldsProvider = MigrationYieldsFamily._();

/// Planın duraklarındaki hedef arılıkların plan yılından önceki verimi,
/// arılık kimliğine göre. Durak, hasat ya da plan yılı değişince yeniden
/// hesaplanır.

final class MigrationYieldsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, List<YearlyYield>>>,
          Map<String, List<YearlyYield>>,
          Stream<Map<String, List<YearlyYield>>>
        >
    with
        $FutureModifier<Map<String, List<YearlyYield>>>,
        $StreamProvider<Map<String, List<YearlyYield>>> {
  /// Planın duraklarındaki hedef arılıkların plan yılından önceki verimi,
  /// arılık kimliğine göre. Durak, hasat ya da plan yılı değişince yeniden
  /// hesaplanır.
  MigrationYieldsProvider._({
    required MigrationYieldsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'migrationYieldsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$migrationYieldsHash();

  @override
  String toString() {
    return r'migrationYieldsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Map<String, List<YearlyYield>>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, List<YearlyYield>>> create(Ref ref) {
    final argument = this.argument as String;
    return migrationYields(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is MigrationYieldsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$migrationYieldsHash() => r'c545868cef2e7191a5b507258b807ceaf47b3774';

/// Planın duraklarındaki hedef arılıkların plan yılından önceki verimi,
/// arılık kimliğine göre. Durak, hasat ya da plan yılı değişince yeniden
/// hesaplanır.

final class MigrationYieldsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          Stream<Map<String, List<YearlyYield>>>,
          String
        > {
  MigrationYieldsFamily._()
    : super(
        retry: null,
        name: r'migrationYieldsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Planın duraklarındaki hedef arılıkların plan yılından önceki verimi,
  /// arılık kimliğine göre. Durak, hasat ya da plan yılı değişince yeniden
  /// hesaplanır.

  MigrationYieldsProvider call(String migrationId) =>
      MigrationYieldsProvider._(argument: migrationId, from: this);

  @override
  String toString() => r'migrationYieldsProvider';
}

/// Göç planındaki silme eylemleri.

@ProviderFor(MigrationActions)
final migrationActionsProvider = MigrationActionsProvider._();

/// Göç planındaki silme eylemleri.
final class MigrationActionsProvider
    extends $NotifierProvider<MigrationActions, void> {
  /// Göç planındaki silme eylemleri.
  MigrationActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'migrationActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$migrationActionsHash();

  @$internal
  @override
  MigrationActions create() => MigrationActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$migrationActionsHash() => r'd1bc6fc836a1ee315eb8fe92539c473fedd7f261';

/// Göç planındaki silme eylemleri.

abstract class _$MigrationActions extends $Notifier<void> {
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

/// Göç durağına giden en son taşıma; yoksa null.

@ProviderFor(stopTransport)
final stopTransportProvider = StopTransportFamily._();

/// Göç durağına giden en son taşıma; yoksa null.

final class StopTransportProvider
    extends
        $FunctionalProvider<
          AsyncValue<Transport?>,
          Transport?,
          Stream<Transport?>
        >
    with $FutureModifier<Transport?>, $StreamProvider<Transport?> {
  /// Göç durağına giden en son taşıma; yoksa null.
  StopTransportProvider._({
    required StopTransportFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'stopTransportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$stopTransportHash();

  @override
  String toString() {
    return r'stopTransportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Transport?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Transport?> create(Ref ref) {
    final argument = this.argument as String;
    return stopTransport(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StopTransportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$stopTransportHash() => r'a7278b5b33f07bb567c4ba11bc137119732a4cee';

/// Göç durağına giden en son taşıma; yoksa null.

final class StopTransportFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Transport?>, String> {
  StopTransportFamily._()
    : super(
        retry: null,
        name: r'stopTransportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Göç durağına giden en son taşıma; yoksa null.

  StopTransportProvider call(String migrationStopId) =>
      StopTransportProvider._(argument: migrationStopId, from: this);

  @override
  String toString() => r'stopTransportProvider';
}

/// Taşımanın kovanları, yüklenme sırasıyla.

@ProviderFor(transportItems)
final transportItemsProvider = TransportItemsFamily._();

/// Taşımanın kovanları, yüklenme sırasıyla.

final class TransportItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransportItem>>,
          List<TransportItem>,
          Stream<List<TransportItem>>
        >
    with
        $FutureModifier<List<TransportItem>>,
        $StreamProvider<List<TransportItem>> {
  /// Taşımanın kovanları, yüklenme sırasıyla.
  TransportItemsProvider._({
    required TransportItemsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transportItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transportItemsHash();

  @override
  String toString() {
    return r'transportItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<TransportItem>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransportItem>> create(Ref ref) {
    final argument = this.argument as String;
    return transportItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransportItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transportItemsHash() => r'29778f30914f9cb50266c3e023771ce0bb5d094a';

/// Taşımanın kovanları, yüklenme sırasıyla.

final class TransportItemsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<TransportItem>>, String> {
  TransportItemsFamily._()
    : super(
        retry: null,
        name: r'transportItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Taşımanın kovanları, yüklenme sırasıyla.

  TransportItemsProvider call(String transportId) =>
      TransportItemsProvider._(argument: transportId, from: this);

  @override
  String toString() => r'transportItemsProvider';
}

/// Taşımanın yazmaları; hepsi yerel DB'de, ağ beklemez.

@ProviderFor(TransportActions)
final transportActionsProvider = TransportActionsProvider._();

/// Taşımanın yazmaları; hepsi yerel DB'de, ağ beklemez.
final class TransportActionsProvider
    extends $NotifierProvider<TransportActions, void> {
  /// Taşımanın yazmaları; hepsi yerel DB'de, ağ beklemez.
  TransportActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'transportActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$transportActionsHash();

  @$internal
  @override
  TransportActions create() => TransportActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$transportActionsHash() => r'f2ee815f96d79b5ba8a7e8c35f61db977da42e19';

/// Taşımanın yazmaları; hepsi yerel DB'de, ağ beklemez.

abstract class _$TransportActions extends $Notifier<void> {
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

/// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.

@ProviderFor(TransportVehicle)
final transportVehicleProvider = TransportVehicleFamily._();

/// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.
final class TransportVehicleProvider
    extends $NotifierProvider<TransportVehicle, String?> {
  /// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.
  TransportVehicleProvider._({
    required TransportVehicleFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transportVehicleProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transportVehicleHash();

  @override
  String toString() {
    return r'transportVehicleProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TransportVehicle create() => TransportVehicle();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TransportVehicleProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transportVehicleHash() => r'8fa9efe35a4f5fc101c13e9ce40c8ffa7f68c0fb';

/// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.

final class TransportVehicleFamily extends $Family
    with
        $ClassFamilyOverride<
          TransportVehicle,
          String?,
          String?,
          String?,
          String
        > {
  TransportVehicleFamily._()
    : super(
        retry: null,
        name: r'transportVehicleProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.

  TransportVehicleProvider call(String transportId) =>
      TransportVehicleProvider._(argument: transportId, from: this);

  @override
  String toString() => r'transportVehicleProvider';
}

/// Yüklemede seçili araç; taşıma ekranı açıkken yaşar. Boşsa ilk araç.

abstract class _$TransportVehicle extends $Notifier<String?> {
  late final _$args = ref.$arg as String;
  String get transportId => _$args;

  String? build(String transportId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Taşıma; yoksa ya da silinmişse null.

@ProviderFor(transport)
final transportProvider = TransportFamily._();

/// Taşıma; yoksa ya da silinmişse null.

final class TransportProvider
    extends
        $FunctionalProvider<
          AsyncValue<Transport?>,
          Transport?,
          Stream<Transport?>
        >
    with $FutureModifier<Transport?>, $StreamProvider<Transport?> {
  /// Taşıma; yoksa ya da silinmişse null.
  TransportProvider._({
    required TransportFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'transportProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$transportHash();

  @override
  String toString() {
    return r'transportProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Transport?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Transport?> create(Ref ref) {
    final argument = this.argument as String;
    return transport(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TransportProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$transportHash() => r'fe5a03d293183ab730d84febf0e4ca646df3b4fe';

/// Taşıma; yoksa ya da silinmişse null.

final class TransportFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Transport?>, String> {
  TransportFamily._()
    : super(
        retry: null,
        name: r'transportProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Taşıma; yoksa ya da silinmişse null.

  TransportProvider call(String id) =>
      TransportProvider._(argument: id, from: this);

  @override
  String toString() => r'transportProvider';
}

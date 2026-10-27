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

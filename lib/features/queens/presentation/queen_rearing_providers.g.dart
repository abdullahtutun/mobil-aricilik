// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen_rearing_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(queenRearingRepository)
final queenRearingRepositoryProvider = QueenRearingRepositoryProvider._();

final class QueenRearingRepositoryProvider
    extends
        $FunctionalProvider<
          QueenRearingRepository,
          QueenRearingRepository,
          QueenRearingRepository
        >
    with $Provider<QueenRearingRepository> {
  QueenRearingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queenRearingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queenRearingRepositoryHash();

  @$internal
  @override
  $ProviderElement<QueenRearingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  QueenRearingRepository create(Ref ref) {
    return queenRearingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueenRearingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueenRearingRepository>(value),
    );
  }
}

String _$queenRearingRepositoryHash() =>
    r'dd3e64cb10721f28733834f39a06105a358e43c9';

/// Oturumdaki işletmenin serileri, son aktarılan önce; işletme yoksa boş.

@ProviderFor(rearingBatches)
final rearingBatchesProvider = RearingBatchesProvider._();

/// Oturumdaki işletmenin serileri, son aktarılan önce; işletme yoksa boş.

final class RearingBatchesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<QueenRearingBatch>>,
          List<QueenRearingBatch>,
          Stream<List<QueenRearingBatch>>
        >
    with
        $FutureModifier<List<QueenRearingBatch>>,
        $StreamProvider<List<QueenRearingBatch>> {
  /// Oturumdaki işletmenin serileri, son aktarılan önce; işletme yoksa boş.
  RearingBatchesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rearingBatchesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rearingBatchesHash();

  @$internal
  @override
  $StreamProviderElement<List<QueenRearingBatch>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<QueenRearingBatch>> create(Ref ref) {
    return rearingBatches(ref);
  }
}

String _$rearingBatchesHash() => r'fe0944cf4a0239c9223e0a65ead1ad235eed2224';

/// Seri; yoksa ya da silinmişse null.

@ProviderFor(rearingBatch)
final rearingBatchProvider = RearingBatchFamily._();

/// Seri; yoksa ya da silinmişse null.

final class RearingBatchProvider
    extends
        $FunctionalProvider<
          AsyncValue<QueenRearingBatch?>,
          QueenRearingBatch?,
          Stream<QueenRearingBatch?>
        >
    with
        $FutureModifier<QueenRearingBatch?>,
        $StreamProvider<QueenRearingBatch?> {
  /// Seri; yoksa ya da silinmişse null.
  RearingBatchProvider._({
    required RearingBatchFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rearingBatchProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rearingBatchHash();

  @override
  String toString() {
    return r'rearingBatchProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<QueenRearingBatch?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<QueenRearingBatch?> create(Ref ref) {
    final argument = this.argument as String;
    return rearingBatch(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RearingBatchProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rearingBatchHash() => r'e51ad8791ab4ca49a1b74a59a22b9f900188917a';

/// Seri; yoksa ya da silinmişse null.

final class RearingBatchFamily extends $Family
    with $FunctionalFamilyOverride<Stream<QueenRearingBatch?>, String> {
  RearingBatchFamily._()
    : super(
        retry: null,
        name: r'rearingBatchProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Seri; yoksa ya da silinmişse null.

  RearingBatchProvider call(String id) =>
      RearingBatchProvider._(argument: id, from: this);

  @override
  String toString() => r'rearingBatchProvider';
}

/// Serinin kutuları, numara sırasıyla.

@ProviderFor(rearingBatchNucs)
final rearingBatchNucsProvider = RearingBatchNucsFamily._();

/// Serinin kutuları, numara sırasıyla.

final class RearingBatchNucsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MatingNuc>>,
          List<MatingNuc>,
          Stream<List<MatingNuc>>
        >
    with $FutureModifier<List<MatingNuc>>, $StreamProvider<List<MatingNuc>> {
  /// Serinin kutuları, numara sırasıyla.
  RearingBatchNucsProvider._({
    required RearingBatchNucsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rearingBatchNucsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rearingBatchNucsHash();

  @override
  String toString() {
    return r'rearingBatchNucsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MatingNuc>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MatingNuc>> create(Ref ref) {
    final argument = this.argument as String;
    return rearingBatchNucs(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RearingBatchNucsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rearingBatchNucsHash() => r'9026f6e3edb2c98e1e05babb29523ae2a9b99efd';

/// Serinin kutuları, numara sırasıyla.

final class RearingBatchNucsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MatingNuc>>, String> {
  RearingBatchNucsFamily._()
    : super(
        retry: null,
        name: r'rearingBatchNucsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Serinin kutuları, numara sırasıyla.

  RearingBatchNucsProvider call(String batchId) =>
      RearingBatchNucsProvider._(argument: batchId, from: this);

  @override
  String toString() => r'rearingBatchNucsProvider';
}

/// Arılığın kutuları; dağıtmada yeniden kullanılacak boş kutular buradan.

@ProviderFor(apiaryNucs)
final apiaryNucsProvider = ApiaryNucsFamily._();

/// Arılığın kutuları; dağıtmada yeniden kullanılacak boş kutular buradan.

final class ApiaryNucsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MatingNuc>>,
          List<MatingNuc>,
          Stream<List<MatingNuc>>
        >
    with $FutureModifier<List<MatingNuc>>, $StreamProvider<List<MatingNuc>> {
  /// Arılığın kutuları; dağıtmada yeniden kullanılacak boş kutular buradan.
  ApiaryNucsProvider._({
    required ApiaryNucsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryNucsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryNucsHash();

  @override
  String toString() {
    return r'apiaryNucsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MatingNuc>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MatingNuc>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryNucs(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryNucsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryNucsHash() => r'6251bc2223e0e6b260c8feeeda58c99b96b1039f';

/// Arılığın kutuları; dağıtmada yeniden kullanılacak boş kutular buradan.

final class ApiaryNucsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MatingNuc>>, String> {
  ApiaryNucsFamily._()
    : super(
        retry: null,
        name: r'apiaryNucsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılığın kutuları; dağıtmada yeniden kullanılacak boş kutular buradan.

  ApiaryNucsProvider call(String apiaryId) =>
      ApiaryNucsProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryNucsProvider';
}

/// Serinin takvim görevleri (tamamlananlar dahil).

@ProviderFor(rearingBatchTasks)
final rearingBatchTasksProvider = RearingBatchTasksFamily._();

/// Serinin takvim görevleri (tamamlananlar dahil).

final class RearingBatchTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// Serinin takvim görevleri (tamamlananlar dahil).
  RearingBatchTasksProvider._({
    required RearingBatchTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'rearingBatchTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$rearingBatchTasksHash();

  @override
  String toString() {
    return r'rearingBatchTasksProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<Task>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Task>> create(Ref ref) {
    final argument = this.argument as String;
    return rearingBatchTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RearingBatchTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$rearingBatchTasksHash() => r'121b6af8206ff2ff63c88038feecc686a200ab48';

/// Serinin takvim görevleri (tamamlananlar dahil).

final class RearingBatchTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  RearingBatchTasksFamily._()
    : super(
        retry: null,
        name: r'rearingBatchTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Serinin takvim görevleri (tamamlananlar dahil).

  RearingBatchTasksProvider call(String batchId) =>
      RearingBatchTasksProvider._(argument: batchId, from: this);

  @override
  String toString() => r'rearingBatchTasksProvider';
}

/// Ana yetiştirmenin yazmaları; hepsi yerel DB'de. Geri al snackbar'ı
/// ekran kapandıktan sonra da çalışsın diye sürekli yaşar.

@ProviderFor(RearingActions)
final rearingActionsProvider = RearingActionsProvider._();

/// Ana yetiştirmenin yazmaları; hepsi yerel DB'de. Geri al snackbar'ı
/// ekran kapandıktan sonra da çalışsın diye sürekli yaşar.
final class RearingActionsProvider
    extends $NotifierProvider<RearingActions, void> {
  /// Ana yetiştirmenin yazmaları; hepsi yerel DB'de. Geri al snackbar'ı
  /// ekran kapandıktan sonra da çalışsın diye sürekli yaşar.
  RearingActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'rearingActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$rearingActionsHash();

  @$internal
  @override
  RearingActions create() => RearingActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$rearingActionsHash() => r'b2889330d6a609fe38f25e2230bc92262a5beb14';

/// Ana yetiştirmenin yazmaları; hepsi yerel DB'de. Geri al snackbar'ı
/// ekran kapandıktan sonra da çalışsın diye sürekli yaşar.

abstract class _$RearingActions extends $Notifier<void> {
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

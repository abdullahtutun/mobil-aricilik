// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'varroa_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(miteCountRepository)
final miteCountRepositoryProvider = MiteCountRepositoryProvider._();

final class MiteCountRepositoryProvider
    extends
        $FunctionalProvider<
          MiteCountRepository,
          MiteCountRepository,
          MiteCountRepository
        >
    with $Provider<MiteCountRepository> {
  MiteCountRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miteCountRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miteCountRepositoryHash();

  @$internal
  @override
  $ProviderElement<MiteCountRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MiteCountRepository create(Ref ref) {
    return miteCountRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiteCountRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiteCountRepository>(value),
    );
  }
}

String _$miteCountRepositoryHash() =>
    r'd15a766b82ef4161bc00c51949a100f010066521';

/// Kovanın varroa ölçümleri, en yeni önce.

@ProviderFor(hiveMiteCounts)
final hiveMiteCountsProvider = HiveMiteCountsFamily._();

/// Kovanın varroa ölçümleri, en yeni önce.

final class HiveMiteCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MiteCount>>,
          List<MiteCount>,
          Stream<List<MiteCount>>
        >
    with $FutureModifier<List<MiteCount>>, $StreamProvider<List<MiteCount>> {
  /// Kovanın varroa ölçümleri, en yeni önce.
  HiveMiteCountsProvider._({
    required HiveMiteCountsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveMiteCountsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveMiteCountsHash();

  @override
  String toString() {
    return r'hiveMiteCountsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<MiteCount>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<MiteCount>> create(Ref ref) {
    final argument = this.argument as String;
    return hiveMiteCounts(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveMiteCountsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveMiteCountsHash() => r'70d67cda5d42102bef2d376f9905e02db4bf83dc';

/// Kovanın varroa ölçümleri, en yeni önce.

final class HiveMiteCountsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<MiteCount>>, String> {
  HiveMiteCountsFamily._()
    : super(
        retry: null,
        name: r'hiveMiteCountsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın varroa ölçümleri, en yeni önce.

  HiveMiteCountsProvider call(String hiveId) =>
      HiveMiteCountsProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveMiteCountsProvider';
}

/// Arılık grafiğinin çubukları ([apiaryVarroaBars]); arılıkta yapılan
/// ölçümlerle güncellenir.

@ProviderFor(apiaryVarroaBarsOf)
final apiaryVarroaBarsOfProvider = ApiaryVarroaBarsOfFamily._();

/// Arılık grafiğinin çubukları ([apiaryVarroaBars]); arılıkta yapılan
/// ölçümlerle güncellenir.

final class ApiaryVarroaBarsOfProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VarroaBar>>,
          List<VarroaBar>,
          Stream<List<VarroaBar>>
        >
    with $FutureModifier<List<VarroaBar>>, $StreamProvider<List<VarroaBar>> {
  /// Arılık grafiğinin çubukları ([apiaryVarroaBars]); arılıkta yapılan
  /// ölçümlerle güncellenir.
  ApiaryVarroaBarsOfProvider._({
    required ApiaryVarroaBarsOfFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryVarroaBarsOfProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryVarroaBarsOfHash();

  @override
  String toString() {
    return r'apiaryVarroaBarsOfProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<VarroaBar>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VarroaBar>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryVarroaBarsOf(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryVarroaBarsOfProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryVarroaBarsOfHash() =>
    r'dfd5dfe45995a54bea3a79a3308224756be42686';

/// Arılık grafiğinin çubukları ([apiaryVarroaBars]); arılıkta yapılan
/// ölçümlerle güncellenir.

final class ApiaryVarroaBarsOfFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<VarroaBar>>, String> {
  ApiaryVarroaBarsOfFamily._()
    : super(
        retry: null,
        name: r'apiaryVarroaBarsOfProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılık grafiğinin çubukları ([apiaryVarroaBars]); arılıkta yapılan
  /// ölçümlerle güncellenir.

  ApiaryVarroaBarsOfProvider call(String apiaryId) =>
      ApiaryVarroaBarsOfProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryVarroaBarsOfProvider';
}

/// Kaydettikten sonraki Geri al. Bildirim, form kapandıktan sonra da
/// çalışsın diye sürekli yaşar.

@ProviderFor(VarroaActions)
final varroaActionsProvider = VarroaActionsProvider._();

/// Kaydettikten sonraki Geri al. Bildirim, form kapandıktan sonra da
/// çalışsın diye sürekli yaşar.
final class VarroaActionsProvider
    extends $NotifierProvider<VarroaActions, void> {
  /// Kaydettikten sonraki Geri al. Bildirim, form kapandıktan sonra da
  /// çalışsın diye sürekli yaşar.
  VarroaActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'varroaActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$varroaActionsHash();

  @$internal
  @override
  VarroaActions create() => VarroaActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$varroaActionsHash() => r'072259a61455aef85c9fe6da5f01991fcf8307dc';

/// Kaydettikten sonraki Geri al. Bildirim, form kapandıktan sonra da
/// çalışsın diye sürekli yaşar.

abstract class _$VarroaActions extends $Notifier<void> {
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

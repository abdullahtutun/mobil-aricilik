// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(queenRepository)
final queenRepositoryProvider = QueenRepositoryProvider._();

final class QueenRepositoryProvider
    extends
        $FunctionalProvider<QueenRepository, QueenRepository, QueenRepository>
    with $Provider<QueenRepository> {
  QueenRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queenRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queenRepositoryHash();

  @$internal
  @override
  $ProviderElement<QueenRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  QueenRepository create(Ref ref) {
    return queenRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(QueenRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<QueenRepository>(value),
    );
  }
}

String _$queenRepositoryHash() => r'5420e29b9ed06092bb80548daf652d8ee6166007';

/// İşletmenin ana arıları, kayıt sırasıyla. İşletme yoksa boş.

@ProviderFor(organizationQueens)
final organizationQueensProvider = OrganizationQueensProvider._();

/// İşletmenin ana arıları, kayıt sırasıyla. İşletme yoksa boş.

final class OrganizationQueensProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Queen>>,
          List<Queen>,
          Stream<List<Queen>>
        >
    with $FutureModifier<List<Queen>>, $StreamProvider<List<Queen>> {
  /// İşletmenin ana arıları, kayıt sırasıyla. İşletme yoksa boş.
  OrganizationQueensProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'organizationQueensProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$organizationQueensHash();

  @$internal
  @override
  $StreamProviderElement<List<Queen>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Queen>> create(Ref ref) {
    return organizationQueens(ref);
  }
}

String _$organizationQueensHash() =>
    r'2af6e0d3d2c6a9cfb7c43050681fe08dc03de0ec';

/// Ana; yoksa ya da silindiyse null.

@ProviderFor(queen)
final queenProvider = QueenFamily._();

/// Ana; yoksa ya da silindiyse null.

final class QueenProvider
    extends $FunctionalProvider<AsyncValue<Queen?>, Queen?, Stream<Queen?>>
    with $FutureModifier<Queen?>, $StreamProvider<Queen?> {
  /// Ana; yoksa ya da silindiyse null.
  QueenProvider._({
    required QueenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'queenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$queenHash();

  @override
  String toString() {
    return r'queenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Queen?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Queen?> create(Ref ref) {
    final argument = this.argument as String;
    return queen(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is QueenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$queenHash() => r'afa60b8ecf627bcaa54428ff839d4d992a6f024f';

/// Ana; yoksa ya da silindiyse null.

final class QueenFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Queen?>, String> {
  QueenFamily._()
    : super(
        retry: null,
        name: r'queenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Ana; yoksa ya da silindiyse null.

  QueenProvider call(String queenId) =>
      QueenProvider._(argument: queenId, from: this);

  @override
  String toString() => r'queenProvider';
}

/// Kovandaki ana; kovan ya da ana yoksa null. Ana değişince yeniden kurulur.

@ProviderFor(hiveQueen)
final hiveQueenProvider = HiveQueenFamily._();

/// Kovandaki ana; kovan ya da ana yoksa null. Ana değişince yeniden kurulur.

final class HiveQueenProvider
    extends $FunctionalProvider<AsyncValue<Queen?>, Queen?, FutureOr<Queen?>>
    with $FutureModifier<Queen?>, $FutureProvider<Queen?> {
  /// Kovandaki ana; kovan ya da ana yoksa null. Ana değişince yeniden kurulur.
  HiveQueenProvider._({
    required HiveQueenFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'hiveQueenProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hiveQueenHash();

  @override
  String toString() {
    return r'hiveQueenProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Queen?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<Queen?> create(Ref ref) {
    final argument = this.argument as String;
    return hiveQueen(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is HiveQueenProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hiveQueenHash() => r'9d21ecd3318ad349b8e0671f8db2b09a8a22c401';

/// Kovandaki ana; kovan ya da ana yoksa null. Ana değişince yeniden kurulur.

final class HiveQueenFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<Queen?>, String> {
  HiveQueenFamily._()
    : super(
        retry: null,
        name: r'hiveQueenProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovandaki ana; kovan ya da ana yoksa null. Ana değişince yeniden kurulur.

  HiveQueenProvider call(String hiveId) =>
      HiveQueenProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'hiveQueenProvider';
}

/// Ana kimliğine göre işaret rengi; işaretsiz ana haritada yok. Kovan
/// karolarındaki renk noktası buradan.

@ProviderFor(queenMarkColors)
final queenMarkColorsProvider = QueenMarkColorsProvider._();

/// Ana kimliğine göre işaret rengi; işaretsiz ana haritada yok. Kovan
/// karolarındaki renk noktası buradan.

final class QueenMarkColorsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, QueenMarkColor>>,
          Map<String, QueenMarkColor>,
          FutureOr<Map<String, QueenMarkColor>>
        >
    with
        $FutureModifier<Map<String, QueenMarkColor>>,
        $FutureProvider<Map<String, QueenMarkColor>> {
  /// Ana kimliğine göre işaret rengi; işaretsiz ana haritada yok. Kovan
  /// karolarındaki renk noktası buradan.
  QueenMarkColorsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queenMarkColorsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queenMarkColorsHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, QueenMarkColor>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, QueenMarkColor>> create(Ref ref) {
    return queenMarkColors(ref);
  }
}

String _$queenMarkColorsHash() => r'0357a79dc8ea3fc7f471e3957e01ec714167c8b1';

/// Aktif kovanlardaki yaşlı analar ([oldQueensInHives]), en yaşlı önce.

@ProviderFor(oldQueens)
final oldQueensProvider = OldQueensProvider._();

/// Aktif kovanlardaki yaşlı analar ([oldQueensInHives]), en yaşlı önce.

final class OldQueensProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<HiveQueen>>,
          List<HiveQueen>,
          FutureOr<List<HiveQueen>>
        >
    with $FutureModifier<List<HiveQueen>>, $FutureProvider<List<HiveQueen>> {
  /// Aktif kovanlardaki yaşlı analar ([oldQueensInHives]), en yaşlı önce.
  OldQueensProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'oldQueensProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$oldQueensHash();

  @$internal
  @override
  $FutureProviderElement<List<HiveQueen>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<HiveQueen>> create(Ref ref) {
    return oldQueens(ref);
  }
}

String _$oldQueensHash() => r'1a7049b202ada9bb18fd848f78225bd95ca504ab';

/// Kovan kartındaki ana arı eylemleri: yeni ana verme ve geri alma. Geri al
/// snackbar'ı ekran kapandıktan sonra da çalışsın diye sürekli yaşar.

@ProviderFor(QueenActions)
final queenActionsProvider = QueenActionsProvider._();

/// Kovan kartındaki ana arı eylemleri: yeni ana verme ve geri alma. Geri al
/// snackbar'ı ekran kapandıktan sonra da çalışsın diye sürekli yaşar.
final class QueenActionsProvider extends $NotifierProvider<QueenActions, void> {
  /// Kovan kartındaki ana arı eylemleri: yeni ana verme ve geri alma. Geri al
  /// snackbar'ı ekran kapandıktan sonra da çalışsın diye sürekli yaşar.
  QueenActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'queenActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$queenActionsHash();

  @$internal
  @override
  QueenActions create() => QueenActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$queenActionsHash() => r'b74260b330d160ad24df93adc8f345e523e2311c';

/// Kovan kartındaki ana arı eylemleri: yeni ana verme ve geri alma. Geri al
/// snackbar'ı ekran kapandıktan sonra da çalışsın diye sürekli yaşar.

abstract class _$QueenActions extends $Notifier<void> {
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

/// Ana kimliğine göre içinde bulunduğu kovan (her durumda); kovanda olmayan
/// ana haritada yok. Anne ana "Kovan 88" diye buradan anılır.

@ProviderFor(hivesByQueen)
final hivesByQueenProvider = HivesByQueenProvider._();

/// Ana kimliğine göre içinde bulunduğu kovan (her durumda); kovanda olmayan
/// ana haritada yok. Anne ana "Kovan 88" diye buradan anılır.

final class HivesByQueenProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, Hive>>,
          Map<String, Hive>,
          FutureOr<Map<String, Hive>>
        >
    with
        $FutureModifier<Map<String, Hive>>,
        $FutureProvider<Map<String, Hive>> {
  /// Ana kimliğine göre içinde bulunduğu kovan (her durumda); kovanda olmayan
  /// ana haritada yok. Anne ana "Kovan 88" diye buradan anılır.
  HivesByQueenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hivesByQueenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hivesByQueenHash();

  @$internal
  @override
  $FutureProviderElement<Map<String, Hive>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, Hive>> create(Ref ref) {
    return hivesByQueen(ref);
  }
}

String _$hivesByQueenHash() => r'7bed7d542c36cda8ddbe98b74136cef91c76b634';

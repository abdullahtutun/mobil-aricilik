// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(harvestRepository)
final harvestRepositoryProvider = HarvestRepositoryProvider._();

final class HarvestRepositoryProvider
    extends
        $FunctionalProvider<
          HarvestRepository,
          HarvestRepository,
          HarvestRepository
        >
    with $Provider<HarvestRepository> {
  HarvestRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'harvestRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$harvestRepositoryHash();

  @$internal
  @override
  $ProviderElement<HarvestRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HarvestRepository create(Ref ref) {
    return harvestRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HarvestRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HarvestRepository>(value),
    );
  }
}

String _$harvestRepositoryHash() => r'14a8b25a0e6c27b332c79885882da298628d938d';

/// Şu an arılıkta duran kovanların uygulamaları (nerede yapılmış olursa
/// olsun); uygulamalar ya da kovanların arılığı değişince yeniden yayar.

@ProviderFor(apiaryHiveTreatments)
final apiaryHiveTreatmentsProvider = ApiaryHiveTreatmentsFamily._();

/// Şu an arılıkta duran kovanların uygulamaları (nerede yapılmış olursa
/// olsun); uygulamalar ya da kovanların arılığı değişince yeniden yayar.

final class ApiaryHiveTreatmentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Treatment>>,
          List<Treatment>,
          Stream<List<Treatment>>
        >
    with $FutureModifier<List<Treatment>>, $StreamProvider<List<Treatment>> {
  /// Şu an arılıkta duran kovanların uygulamaları (nerede yapılmış olursa
  /// olsun); uygulamalar ya da kovanların arılığı değişince yeniden yayar.
  ApiaryHiveTreatmentsProvider._({
    required ApiaryHiveTreatmentsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryHiveTreatmentsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryHiveTreatmentsHash();

  @override
  String toString() {
    return r'apiaryHiveTreatmentsProvider'
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
    return apiaryHiveTreatments(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryHiveTreatmentsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryHiveTreatmentsHash() =>
    r'f7a3369d53b97117670c2cc9e26e5c664931e010';

/// Şu an arılıkta duran kovanların uygulamaları (nerede yapılmış olursa
/// olsun); uygulamalar ya da kovanların arılığı değişince yeniden yayar.

final class ApiaryHiveTreatmentsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Treatment>>, String> {
  ApiaryHiveTreatmentsFamily._()
    : super(
        retry: null,
        name: r'apiaryHiveTreatmentsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Şu an arılıkta duran kovanların uygulamaları (nerede yapılmış olursa
  /// olsun); uygulamalar ya da kovanların arılığı değişince yeniden yayar.

  ApiaryHiveTreatmentsProvider call(String apiaryId) =>
      ApiaryHiveTreatmentsProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryHiveTreatmentsProvider';
}

/// Arılıktaki kovanlardan [day] günü bekleme süresinde olanların kilidi,
/// kovan kimliğine göre ([withdrawalLocksByHive]).

@ProviderFor(harvestLocks)
final harvestLocksProvider = HarvestLocksFamily._();

/// Arılıktaki kovanlardan [day] günü bekleme süresinde olanların kilidi,
/// kovan kimliğine göre ([withdrawalLocksByHive]).

final class HarvestLocksProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, WithdrawalLock>>,
          Map<String, WithdrawalLock>,
          FutureOr<Map<String, WithdrawalLock>>
        >
    with
        $FutureModifier<Map<String, WithdrawalLock>>,
        $FutureProvider<Map<String, WithdrawalLock>> {
  /// Arılıktaki kovanlardan [day] günü bekleme süresinde olanların kilidi,
  /// kovan kimliğine göre ([withdrawalLocksByHive]).
  HarvestLocksProvider._({
    required HarvestLocksFamily super.from,
    required (String, DateTime) super.argument,
  }) : super(
         retry: null,
         name: r'harvestLocksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$harvestLocksHash();

  @override
  String toString() {
    return r'harvestLocksProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, WithdrawalLock>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, WithdrawalLock>> create(Ref ref) {
    final argument = this.argument as (String, DateTime);
    return harvestLocks(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is HarvestLocksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$harvestLocksHash() => r'6884ebf71ee132e878b2f385e7a287e8571f133a';

/// Arılıktaki kovanlardan [day] günü bekleme süresinde olanların kilidi,
/// kovan kimliğine göre ([withdrawalLocksByHive]).

final class HarvestLocksFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, WithdrawalLock>>,
          (String, DateTime)
        > {
  HarvestLocksFamily._()
    : super(
        retry: null,
        name: r'harvestLocksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılıktaki kovanlardan [day] günü bekleme süresinde olanların kilidi,
  /// kovan kimliğine göre ([withdrawalLocksByHive]).

  HarvestLocksProvider call(String apiaryId, DateTime day) =>
      HarvestLocksProvider._(argument: (apiaryId, day), from: this);

  @override
  String toString() => r'harvestLocksProvider';
}

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.

@ProviderFor(HarvestActions)
final harvestActionsProvider = HarvestActionsProvider._();

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.
final class HarvestActionsProvider
    extends $NotifierProvider<HarvestActions, void> {
  /// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
  /// sürekli yaşar.
  HarvestActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'harvestActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$harvestActionsHash();

  @$internal
  @override
  HarvestActions create() => HarvestActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$harvestActionsHash() => r'200099aceceb5226fd185244731612f7552be76c';

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.

abstract class _$HarvestActions extends $Notifier<void> {
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

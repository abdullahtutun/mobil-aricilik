// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tour_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(tourRepository)
final tourRepositoryProvider = TourRepositoryProvider._();

final class TourRepositoryProvider
    extends $FunctionalProvider<TourRepository, TourRepository, TourRepository>
    with $Provider<TourRepository> {
  TourRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourRepositoryHash();

  @$internal
  @override
  $ProviderElement<TourRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TourRepository create(Ref ref) {
    return tourRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TourRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TourRepository>(value),
    );
  }
}

String _$tourRepositoryHash() => r'd768d2e328358144ebae4128e0b315f90a573904';

/// Süren tur; başka işletmenin turu sayılmaz.

@ProviderFor(currentTour)
final currentTourProvider = CurrentTourProvider._();

/// Süren tur; başka işletmenin turu sayılmaz.

final class CurrentTourProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiaryTour?>,
          ApiaryTour?,
          Stream<ApiaryTour?>
        >
    with $FutureModifier<ApiaryTour?>, $StreamProvider<ApiaryTour?> {
  /// Süren tur; başka işletmenin turu sayılmaz.
  CurrentTourProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentTourProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentTourHash();

  @$internal
  @override
  $StreamProviderElement<ApiaryTour?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ApiaryTour?> create(Ref ref) {
    return currentTour(ref);
  }
}

String _$currentTourHash() => r'b57bd6e46524f5c6f6db0f4fe62c6ff66ca539bc';

/// [apiaryId] arılığının süren turu; arılıkta tur yoksa null.

@ProviderFor(apiaryTour)
final apiaryTourProvider = ApiaryTourFamily._();

/// [apiaryId] arılığının süren turu; arılıkta tur yoksa null.

final class ApiaryTourProvider
    extends
        $FunctionalProvider<
          AsyncValue<TourProgress?>,
          TourProgress?,
          FutureOr<TourProgress?>
        >
    with $FutureModifier<TourProgress?>, $FutureProvider<TourProgress?> {
  /// [apiaryId] arılığının süren turu; arılıkta tur yoksa null.
  ApiaryTourProvider._({
    required ApiaryTourFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryTourProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryTourHash();

  @override
  String toString() {
    return r'apiaryTourProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TourProgress?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TourProgress?> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryTour(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryTourProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryTourHash() => r'cdcc4775963d1c4201dede8a8c002aebe8e90ef4';

/// [apiaryId] arılığının süren turu; arılıkta tur yoksa null.

final class ApiaryTourFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TourProgress?>, String> {
  ApiaryTourFamily._()
    : super(
        retry: null,
        name: r'apiaryTourProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [apiaryId] arılığının süren turu; arılıkta tur yoksa null.

  ApiaryTourProvider call(String apiaryId) =>
      ApiaryTourProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryTourProvider';
}

/// [apiaryId] turunda kaydedilen muayeneler.

@ProviderFor(tourInspections)
final tourInspectionsProvider = TourInspectionsFamily._();

/// [apiaryId] turunda kaydedilen muayeneler.

final class TourInspectionsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Inspection>>,
          List<Inspection>,
          Stream<List<Inspection>>
        >
    with $FutureModifier<List<Inspection>>, $StreamProvider<List<Inspection>> {
  /// [apiaryId] turunda kaydedilen muayeneler.
  TourInspectionsProvider._({
    required TourInspectionsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tourInspectionsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tourInspectionsHash();

  @override
  String toString() {
    return r'tourInspectionsProvider'
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
    return tourInspections(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TourInspectionsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tourInspectionsHash() => r'ebf7c2a9525a0b5cf85db8c6b4a27da0474869f4';

/// [apiaryId] turunda kaydedilen muayeneler.

final class TourInspectionsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Inspection>>, String> {
  TourInspectionsFamily._()
    : super(
        retry: null,
        name: r'tourInspectionsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [apiaryId] turunda kaydedilen muayeneler.

  TourInspectionsProvider call(String apiaryId) =>
      TourInspectionsProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'tourInspectionsProvider';
}

/// [apiaryId] turunun özeti; turda tur yoksa null.

@ProviderFor(apiaryTourSummary)
final apiaryTourSummaryProvider = ApiaryTourSummaryFamily._();

/// [apiaryId] turunun özeti; turda tur yoksa null.

final class ApiaryTourSummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<TourSummary?>,
          TourSummary?,
          FutureOr<TourSummary?>
        >
    with $FutureModifier<TourSummary?>, $FutureProvider<TourSummary?> {
  /// [apiaryId] turunun özeti; turda tur yoksa null.
  ApiaryTourSummaryProvider._({
    required ApiaryTourSummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryTourSummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryTourSummaryHash();

  @override
  String toString() {
    return r'apiaryTourSummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TourSummary?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TourSummary?> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryTourSummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryTourSummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryTourSummaryHash() => r'9cd9d3cdb39bac8bb92655a1f455a6093c82c4b7';

/// [apiaryId] turunun özeti; turda tur yoksa null.

final class ApiaryTourSummaryFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<TourSummary?>, String> {
  ApiaryTourSummaryFamily._()
    : super(
        retry: null,
        name: r'apiaryTourSummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [apiaryId] turunun özeti; turda tur yoksa null.

  ApiaryTourSummaryProvider call(String apiaryId) =>
      ApiaryTourSummaryProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryTourSummaryProvider';
}

/// [apiaryId] turundaki muayenelerden açılan "tekrar bak" görevleri.

@ProviderFor(tourReminderTasks)
final tourReminderTasksProvider = TourReminderTasksFamily._();

/// [apiaryId] turundaki muayenelerden açılan "tekrar bak" görevleri.

final class TourReminderTasksProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Task>>,
          List<Task>,
          Stream<List<Task>>
        >
    with $FutureModifier<List<Task>>, $StreamProvider<List<Task>> {
  /// [apiaryId] turundaki muayenelerden açılan "tekrar bak" görevleri.
  TourReminderTasksProvider._({
    required TourReminderTasksFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'tourReminderTasksProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$tourReminderTasksHash();

  @override
  String toString() {
    return r'tourReminderTasksProvider'
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
    return tourReminderTasks(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TourReminderTasksProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$tourReminderTasksHash() => r'a16512c4a76173f0da93eed0d84be5ba1a6f2454';

/// [apiaryId] turundaki muayenelerden açılan "tekrar bak" görevleri.

final class TourReminderTasksFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<Task>>, String> {
  TourReminderTasksFamily._()
    : super(
        retry: null,
        name: r'tourReminderTasksProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// [apiaryId] turundaki muayenelerden açılan "tekrar bak" görevleri.

  TourReminderTasksProvider call(String apiaryId) =>
      TourReminderTasksProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'tourReminderTasksProvider';
}

/// Turun eylemleri; yazmalar verildiği sırayla çalışır. Turda açılan
/// güneş modunu tur bitince eski moda döndürmek için bellekte iz tutar.

@ProviderFor(TourActions)
final tourActionsProvider = TourActionsProvider._();

/// Turun eylemleri; yazmalar verildiği sırayla çalışır. Turda açılan
/// güneş modunu tur bitince eski moda döndürmek için bellekte iz tutar.
final class TourActionsProvider extends $NotifierProvider<TourActions, void> {
  /// Turun eylemleri; yazmalar verildiği sırayla çalışır. Turda açılan
  /// güneş modunu tur bitince eski moda döndürmek için bellekte iz tutar.
  TourActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tourActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tourActionsHash();

  @$internal
  @override
  TourActions create() => TourActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$tourActionsHash() => r'd0ff2dded612bab4dae5a20c3e0af6fbb0bee542';

/// Turun eylemleri; yazmalar verildiği sırayla çalışır. Turda açılan
/// güneş modunu tur bitince eski moda döndürmek için bellekte iz tutar.

abstract class _$TourActions extends $Notifier<void> {
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

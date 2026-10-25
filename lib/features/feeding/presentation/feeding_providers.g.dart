// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feeding_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(feedingRepository)
final feedingRepositoryProvider = FeedingRepositoryProvider._();

final class FeedingRepositoryProvider
    extends
        $FunctionalProvider<
          FeedingRepository,
          FeedingRepository,
          FeedingRepository
        >
    with $Provider<FeedingRepository> {
  FeedingRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedingRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedingRepositoryHash();

  @$internal
  @override
  $ProviderElement<FeedingRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  FeedingRepository create(Ref ref) {
    return feedingRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedingRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedingRepository>(value),
    );
  }
}

String _$feedingRepositoryHash() => r'11a80252ce25cfa94320779a756c6f08f281d5f8';

/// Arılıkta şu an bal katı olan kovanların kimlikleri; muayeneler ya da
/// kovanların arılığı değişince yeniden hesaplanır.

@ProviderFor(apiaryHoneySuperHiveIds)
final apiaryHoneySuperHiveIdsProvider = ApiaryHoneySuperHiveIdsFamily._();

/// Arılıkta şu an bal katı olan kovanların kimlikleri; muayeneler ya da
/// kovanların arılığı değişince yeniden hesaplanır.

final class ApiaryHoneySuperHiveIdsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          Stream<Set<String>>
        >
    with $FutureModifier<Set<String>>, $StreamProvider<Set<String>> {
  /// Arılıkta şu an bal katı olan kovanların kimlikleri; muayeneler ya da
  /// kovanların arılığı değişince yeniden hesaplanır.
  ApiaryHoneySuperHiveIdsProvider._({
    required ApiaryHoneySuperHiveIdsFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiaryHoneySuperHiveIdsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiaryHoneySuperHiveIdsHash();

  @override
  String toString() {
    return r'apiaryHoneySuperHiveIdsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Set<String>> create(Ref ref) {
    final argument = this.argument as String;
    return apiaryHoneySuperHiveIds(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiaryHoneySuperHiveIdsProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiaryHoneySuperHiveIdsHash() =>
    r'7f9ae448adcbff9acc35c96d3ada2015aad520a7';

/// Arılıkta şu an bal katı olan kovanların kimlikleri; muayeneler ya da
/// kovanların arılığı değişince yeniden hesaplanır.

final class ApiaryHoneySuperHiveIdsFamily extends $Family
    with $FunctionalFamilyOverride<Stream<Set<String>>, String> {
  ApiaryHoneySuperHiveIdsFamily._()
    : super(
        retry: null,
        name: r'apiaryHoneySuperHiveIdsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Arılıkta şu an bal katı olan kovanların kimlikleri; muayeneler ya da
  /// kovanların arılığı değişince yeniden hesaplanır.

  ApiaryHoneySuperHiveIdsProvider call(String apiaryId) =>
      ApiaryHoneySuperHiveIdsProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiaryHoneySuperHiveIdsProvider';
}

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.

@ProviderFor(FeedingActions)
final feedingActionsProvider = FeedingActionsProvider._();

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.
final class FeedingActionsProvider
    extends $NotifierProvider<FeedingActions, void> {
  /// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
  /// sürekli yaşar.
  FeedingActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedingActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedingActionsHash();

  @$internal
  @override
  FeedingActions create() => FeedingActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$feedingActionsHash() => r'4f7bc43d0d20321f038313d685e556e8dedf5a50';

/// Geri alma. Bildirimin Geri al'ı form kapandıktan sonra da çalışsın diye
/// sürekli yaşar.

abstract class _$FeedingActions extends $Notifier<void> {
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

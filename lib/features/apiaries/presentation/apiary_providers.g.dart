// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'apiary_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(apiaryRepository)
final apiaryRepositoryProvider = ApiaryRepositoryProvider._();

final class ApiaryRepositoryProvider
    extends
        $FunctionalProvider<
          ApiaryRepository,
          ApiaryRepository,
          ApiaryRepository
        >
    with $Provider<ApiaryRepository> {
  ApiaryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiaryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiaryRepositoryHash();

  @$internal
  @override
  $ProviderElement<ApiaryRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ApiaryRepository create(Ref ref) {
    return apiaryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiaryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiaryRepository>(value),
    );
  }
}

String _$apiaryRepositoryHash() => r'8134ef935520ac00e5fc2babe81e1ac894082f6b';

/// İşletmenin arılıkları; adlar Türkçe harf ve sayı sırasıyla. İşletme
/// yoksa boş.

@ProviderFor(apiaryList)
final apiaryListProvider = ApiaryListProvider._();

/// İşletmenin arılıkları; adlar Türkçe harf ve sayı sırasıyla. İşletme
/// yoksa boş.

final class ApiaryListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ApiarySummary>>,
          List<ApiarySummary>,
          Stream<List<ApiarySummary>>
        >
    with
        $FutureModifier<List<ApiarySummary>>,
        $StreamProvider<List<ApiarySummary>> {
  /// İşletmenin arılıkları; adlar Türkçe harf ve sayı sırasıyla. İşletme
  /// yoksa boş.
  ApiaryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiaryListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiaryListHash();

  @$internal
  @override
  $StreamProviderElement<List<ApiarySummary>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ApiarySummary>> create(Ref ref) {
    return apiaryList(ref);
  }
}

String _$apiaryListHash() => r'7c9822824eeca81c9eb68c8b43faa68a9d059f92';

/// Detayın üst kısmı; arılık yoksa ya da silindiyse null.

@ProviderFor(apiarySummary)
final apiarySummaryProvider = ApiarySummaryFamily._();

/// Detayın üst kısmı; arılık yoksa ya da silindiyse null.

final class ApiarySummaryProvider
    extends
        $FunctionalProvider<
          AsyncValue<ApiarySummary?>,
          ApiarySummary?,
          Stream<ApiarySummary?>
        >
    with $FutureModifier<ApiarySummary?>, $StreamProvider<ApiarySummary?> {
  /// Detayın üst kısmı; arılık yoksa ya da silindiyse null.
  ApiarySummaryProvider._({
    required ApiarySummaryFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'apiarySummaryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$apiarySummaryHash();

  @override
  String toString() {
    return r'apiarySummaryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<ApiarySummary?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<ApiarySummary?> create(Ref ref) {
    final argument = this.argument as String;
    return apiarySummary(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ApiarySummaryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$apiarySummaryHash() => r'8d66cdc4a33f7ede88c6678e2567f72cfefd89e8';

/// Detayın üst kısmı; arılık yoksa ya da silindiyse null.

final class ApiarySummaryFamily extends $Family
    with $FunctionalFamilyOverride<Stream<ApiarySummary?>, String> {
  ApiarySummaryFamily._()
    : super(
        retry: null,
        name: r'apiarySummaryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Detayın üst kısmı; arılık yoksa ya da silindiyse null.

  ApiarySummaryProvider call(String apiaryId) =>
      ApiarySummaryProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'apiarySummaryProvider';
}

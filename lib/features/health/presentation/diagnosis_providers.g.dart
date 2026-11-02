// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'diagnosis_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(diagnosisRepository)
final diagnosisRepositoryProvider = DiagnosisRepositoryProvider._();

final class DiagnosisRepositoryProvider
    extends
        $FunctionalProvider<
          DiagnosisRepository,
          DiagnosisRepository,
          DiagnosisRepository
        >
    with $Provider<DiagnosisRepository> {
  DiagnosisRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diagnosisRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diagnosisRepositoryHash();

  @$internal
  @override
  $ProviderElement<DiagnosisRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DiagnosisRepository create(Ref ref) {
    return diagnosisRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DiagnosisRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DiagnosisRepository>(value),
    );
  }
}

String _$diagnosisRepositoryHash() =>
    r'9172baf74beafe6b0f6481b7178258b46c44479d';

/// Teşhis yardımcısının kural tablosu; bir kez okunur.

@ProviderFor(diagnosisTable)
final diagnosisTableProvider = DiagnosisTableProvider._();

/// Teşhis yardımcısının kural tablosu; bir kez okunur.

final class DiagnosisTableProvider
    extends
        $FunctionalProvider<
          AsyncValue<DiagnosisTable>,
          DiagnosisTable,
          FutureOr<DiagnosisTable>
        >
    with $FutureModifier<DiagnosisTable>, $FutureProvider<DiagnosisTable> {
  /// Teşhis yardımcısının kural tablosu; bir kez okunur.
  DiagnosisTableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'diagnosisTableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$diagnosisTableHash();

  @$internal
  @override
  $FutureProviderElement<DiagnosisTable> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<DiagnosisTable> create(Ref ref) {
    return diagnosisTable(ref);
  }
}

String _$diagnosisTableHash() => r'b23b5d70a0a8af4f65067846818e28142d8b3052';

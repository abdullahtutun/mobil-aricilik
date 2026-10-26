// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inspectionRepository)
final inspectionRepositoryProvider = InspectionRepositoryProvider._();

final class InspectionRepositoryProvider
    extends
        $FunctionalProvider<
          InspectionRepository,
          InspectionRepository,
          InspectionRepository
        >
    with $Provider<InspectionRepository> {
  InspectionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inspectionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inspectionRepositoryHash();

  @$internal
  @override
  $ProviderElement<InspectionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InspectionRepository create(Ref ref) {
    return inspectionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InspectionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InspectionRepository>(value),
    );
  }
}

String _$inspectionRepositoryHash() =>
    r'7c7a00f4f8d570e341325471e139dad940e7bf76';

@ProviderFor(inspectionDraftRepository)
final inspectionDraftRepositoryProvider = InspectionDraftRepositoryProvider._();

final class InspectionDraftRepositoryProvider
    extends
        $FunctionalProvider<
          InspectionDraftRepository,
          InspectionDraftRepository,
          InspectionDraftRepository
        >
    with $Provider<InspectionDraftRepository> {
  InspectionDraftRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inspectionDraftRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inspectionDraftRepositoryHash();

  @$internal
  @override
  $ProviderElement<InspectionDraftRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InspectionDraftRepository create(Ref ref) {
    return inspectionDraftRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InspectionDraftRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InspectionDraftRepository>(value),
    );
  }
}

String _$inspectionDraftRepositoryHash() =>
    r'8389852dd6334e466844511ec78745225ea8a7c6';

/// Kaydettikten sonraki eylemler: geri alma ve "tekrar bak" görevi.
/// Bildirim, muayene sayfası kapandıktan sonra da çalışsın diye sürekli
/// yaşar. Her şey yerel DB'ye yazılır.

@ProviderFor(InspectionActions)
final inspectionActionsProvider = InspectionActionsProvider._();

/// Kaydettikten sonraki eylemler: geri alma ve "tekrar bak" görevi.
/// Bildirim, muayene sayfası kapandıktan sonra da çalışsın diye sürekli
/// yaşar. Her şey yerel DB'ye yazılır.
final class InspectionActionsProvider
    extends $NotifierProvider<InspectionActions, void> {
  /// Kaydettikten sonraki eylemler: geri alma ve "tekrar bak" görevi.
  /// Bildirim, muayene sayfası kapandıktan sonra da çalışsın diye sürekli
  /// yaşar. Her şey yerel DB'ye yazılır.
  InspectionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inspectionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inspectionActionsHash();

  @$internal
  @override
  InspectionActions create() => InspectionActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$inspectionActionsHash() => r'3257927975d36bfdeb143084f153cb88620d78f4';

/// Kaydettikten sonraki eylemler: geri alma ve "tekrar bak" görevi.
/// Bildirim, muayene sayfası kapandıktan sonra da çalışsın diye sürekli
/// yaşar. Her şey yerel DB'ye yazılır.

abstract class _$InspectionActions extends $Notifier<void> {
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

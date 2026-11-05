// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_deletion_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Ayarlar > Hesabımı sil akışı. Ekran dinlediği sürece yaşar; raporlar
/// ekranına gidip dönünce de durum kalır (ekran yığında durur).

@ProviderFor(DeletionFlowController)
final deletionFlowControllerProvider = DeletionFlowControllerProvider._();

/// Ayarlar > Hesabımı sil akışı. Ekran dinlediği sürece yaşar; raporlar
/// ekranına gidip dönünce de durum kalır (ekran yığında durur).
final class DeletionFlowControllerProvider
    extends $NotifierProvider<DeletionFlowController, DeletionFlowState> {
  /// Ayarlar > Hesabımı sil akışı. Ekran dinlediği sürece yaşar; raporlar
  /// ekranına gidip dönünce de durum kalır (ekran yığında durur).
  DeletionFlowControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletionFlowControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletionFlowControllerHash();

  @$internal
  @override
  DeletionFlowController create() => DeletionFlowController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeletionFlowState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeletionFlowState>(value),
    );
  }
}

String _$deletionFlowControllerHash() =>
    r'a27755528b5c4aa7e97b7ad7908c4df4caab0957';

/// Ayarlar > Hesabımı sil akışı. Ekran dinlediği sürece yaşar; raporlar
/// ekranına gidip dönünce de durum kalır (ekran yığında durur).

abstract class _$DeletionFlowController extends $Notifier<DeletionFlowState> {
  DeletionFlowState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeletionFlowState, DeletionFlowState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeletionFlowState, DeletionFlowState>,
              DeletionFlowState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

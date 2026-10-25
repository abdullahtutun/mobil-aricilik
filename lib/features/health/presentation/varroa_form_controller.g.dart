// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'varroa_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
/// yoksa durum null. Ölçüm yerel DB'ye yazılır.

@ProviderFor(VarroaFormController)
final varroaFormControllerProvider = VarroaFormControllerFamily._();

/// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
/// yoksa durum null. Ölçüm yerel DB'ye yazılır.
final class VarroaFormControllerProvider
    extends $AsyncNotifierProvider<VarroaFormController, VarroaFormState?> {
  /// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
  /// yoksa durum null. Ölçüm yerel DB'ye yazılır.
  VarroaFormControllerProvider._({
    required VarroaFormControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'varroaFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$varroaFormControllerHash();

  @override
  String toString() {
    return r'varroaFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  VarroaFormController create() => VarroaFormController();

  @override
  bool operator ==(Object other) {
    return other is VarroaFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$varroaFormControllerHash() =>
    r'4e220e2bc62b904c648dc79e6f404a9872d8a6b6';

/// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
/// yoksa durum null. Ölçüm yerel DB'ye yazılır.

final class VarroaFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          VarroaFormController,
          AsyncValue<VarroaFormState?>,
          VarroaFormState?,
          FutureOr<VarroaFormState?>,
          String
        > {
  VarroaFormControllerFamily._()
    : super(
        retry: null,
        name: r'varroaFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
  /// yoksa durum null. Ölçüm yerel DB'ye yazılır.

  VarroaFormControllerProvider call(String hiveId) =>
      VarroaFormControllerProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'varroaFormControllerProvider';
}

/// Kovanın varroa ölçümü formu. Ekran açık kaldığı sürece yaşar. Kovan
/// yoksa durum null. Ölçüm yerel DB'ye yazılır.

abstract class _$VarroaFormController extends $AsyncNotifier<VarroaFormState?> {
  late final _$args = ref.$arg as String;
  String get hiveId => _$args;

  FutureOr<VarroaFormState?> build(String hiveId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<VarroaFormState?>, VarroaFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<VarroaFormState?>, VarroaFormState?>,
              AsyncValue<VarroaFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'queen_rearing_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
/// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
/// silinmişse durum null. Yeni serinin aktarma günü bugün.

@ProviderFor(QueenRearingFormController)
final queenRearingFormControllerProvider = QueenRearingFormControllerFamily._();

/// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
/// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
/// silinmişse durum null. Yeni serinin aktarma günü bugün.
final class QueenRearingFormControllerProvider
    extends
        $AsyncNotifierProvider<
          QueenRearingFormController,
          QueenRearingFormState?
        > {
  /// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
  /// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
  /// silinmişse durum null. Yeni serinin aktarma günü bugün.
  QueenRearingFormControllerProvider._({
    required QueenRearingFormControllerFamily super.from,
    required String? super.argument,
  }) : super(
         retry: null,
         name: r'queenRearingFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$queenRearingFormControllerHash();

  @override
  String toString() {
    return r'queenRearingFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  QueenRearingFormController create() => QueenRearingFormController();

  @override
  bool operator ==(Object other) {
    return other is QueenRearingFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$queenRearingFormControllerHash() =>
    r'ef9b46854684f9a581aa5c9e79840f7b4f667774';

/// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
/// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
/// silinmişse durum null. Yeni serinin aktarma günü bugün.

final class QueenRearingFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          QueenRearingFormController,
          AsyncValue<QueenRearingFormState?>,
          QueenRearingFormState?,
          FutureOr<QueenRearingFormState?>,
          String?
        > {
  QueenRearingFormControllerFamily._()
    : super(
        retry: null,
        name: r'queenRearingFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
  /// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
  /// silinmişse durum null. Yeni serinin aktarma günü bugün.

  QueenRearingFormControllerProvider call(String? batchId) =>
      QueenRearingFormControllerProvider._(argument: batchId, from: this);

  @override
  String toString() => r'queenRearingFormControllerProvider';
}

/// Seri ekleme ([batchId] null) ve düzenleme formu: anne ana, aktarma
/// günü, aktarılan ve kabul edilen sayısı. Düzenlenecek seri yoksa ya da
/// silinmişse durum null. Yeni serinin aktarma günü bugün.

abstract class _$QueenRearingFormController
    extends $AsyncNotifier<QueenRearingFormState?> {
  late final _$args = ref.$arg as String?;
  String? get batchId => _$args;

  FutureOr<QueenRearingFormState?> build(String? batchId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<QueenRearingFormState?>, QueenRearingFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<QueenRearingFormState?>,
                QueenRearingFormState?
              >,
              AsyncValue<QueenRearingFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

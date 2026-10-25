// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inspection_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
/// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
/// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
/// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
/// da silindiyse durum null.

@ProviderFor(InspectionFormController)
final inspectionFormControllerProvider = InspectionFormControllerFamily._();

/// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
/// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
/// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
/// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
/// da silindiyse durum null.
final class InspectionFormControllerProvider
    extends
        $AsyncNotifierProvider<InspectionFormController, InspectionFormState?> {
  /// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
  /// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
  /// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
  /// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
  /// da silindiyse durum null.
  InspectionFormControllerProvider._({
    required InspectionFormControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'inspectionFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$inspectionFormControllerHash();

  @override
  String toString() {
    return r'inspectionFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  InspectionFormController create() => InspectionFormController();

  @override
  bool operator ==(Object other) {
    return other is InspectionFormControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$inspectionFormControllerHash() =>
    r'3dafba61439d5fecc41678168fcad92549b5587f';

/// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
/// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
/// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
/// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
/// da silindiyse durum null.

final class InspectionFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          InspectionFormController,
          AsyncValue<InspectionFormState?>,
          InspectionFormState?,
          FutureOr<InspectionFormState?>,
          String
        > {
  InspectionFormControllerFamily._()
    : super(
        retry: null,
        name: r'inspectionFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
  /// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
  /// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
  /// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
  /// da silindiyse durum null.

  InspectionFormControllerProvider call(String hiveId) =>
      InspectionFormControllerProvider._(argument: hiveId, from: this);

  @override
  String toString() => r'inspectionFormControllerProvider';
}

/// Kovanın hızlı muayene formu (teknik.md §9). Taslak varsa ondan, yoksa
/// önceki muayenenin değerleriyle (öneri olarak) açılır. Her değişiklik
/// hemen taslak olarak yerel DB'ye yazılır; uygulama kapansa da form
/// kaldığı yerden açılır. Sayfa açık kaldığı sürece yaşar. Kovan yoksa ya
/// da silindiyse durum null.

abstract class _$InspectionFormController
    extends $AsyncNotifier<InspectionFormState?> {
  late final _$args = ref.$arg as String;
  String get hiveId => _$args;

  FutureOr<InspectionFormState?> build(String hiveId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<InspectionFormState?>, InspectionFormState?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<InspectionFormState?>,
                InspectionFormState?
              >,
              AsyncValue<InspectionFormState?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

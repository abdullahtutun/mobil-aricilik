// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'harvest_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
/// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
/// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
/// transaction'da yazılır.

@ProviderFor(HarvestFormController)
final harvestFormControllerProvider = HarvestFormControllerFamily._();

/// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
/// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
/// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
/// transaction'da yazılır.
final class HarvestFormControllerProvider
    extends $AsyncNotifierProvider<HarvestFormController, HarvestFormState> {
  /// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
  /// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
  /// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
  /// transaction'da yazılır.
  HarvestFormControllerProvider._({
    required HarvestFormControllerFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'harvestFormControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$harvestFormControllerHash();

  @override
  String toString() {
    return r'harvestFormControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  HarvestFormController create() => HarvestFormController();

  @override
  bool operator ==(Object other) {
    return other is HarvestFormControllerProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$harvestFormControllerHash() =>
    r'3c747593ec404948ef2af83818f308159072ced0';

/// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
/// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
/// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
/// transaction'da yazılır.

final class HarvestFormControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          HarvestFormController,
          AsyncValue<HarvestFormState>,
          HarvestFormState,
          FutureOr<HarvestFormState>,
          String
        > {
  HarvestFormControllerFamily._()
    : super(
        retry: null,
        name: r'harvestFormControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
  /// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
  /// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
  /// transaction'da yazılır.

  HarvestFormControllerProvider call(String apiaryId) =>
      HarvestFormControllerProvider._(argument: apiaryId, from: this);

  @override
  String toString() => r'harvestFormControllerProvider';
}

/// Hasat formu (arılığın hasadı). Ekran ve okutma ekranı açık kaldığı
/// sürece yaşar. Açılınca arılığın aktif kovanlarından o gün bekleme
/// süresinde olmayanlar seçili gelir. Hasat ve kovanları yerel DB'ye tek
/// transaction'da yazılır.

abstract class _$HarvestFormController
    extends $AsyncNotifier<HarvestFormState> {
  late final _$args = ref.$arg as String;
  String get apiaryId => _$args;

  FutureOr<HarvestFormState> build(String apiaryId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<HarvestFormState>, HarvestFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<HarvestFormState>, HarvestFormState>,
              AsyncValue<HarvestFormState>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

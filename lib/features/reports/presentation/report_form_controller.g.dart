// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Rapor ekranının seçimleri; ekran açık kaldığı sürece yaşar. Dönem bu
/// yılın başından bugüne açılır.

@ProviderFor(ReportFormController)
final reportFormControllerProvider = ReportFormControllerProvider._();

/// Rapor ekranının seçimleri; ekran açık kaldığı sürece yaşar. Dönem bu
/// yılın başından bugüne açılır.
final class ReportFormControllerProvider
    extends $NotifierProvider<ReportFormController, ReportFormState> {
  /// Rapor ekranının seçimleri; ekran açık kaldığı sürece yaşar. Dönem bu
  /// yılın başından bugüne açılır.
  ReportFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reportFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$reportFormControllerHash();

  @$internal
  @override
  ReportFormController create() => ReportFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReportFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReportFormState>(value),
    );
  }
}

String _$reportFormControllerHash() =>
    r'0c09cc0272acae75e688897bd5c48592a76de927';

/// Rapor ekranının seçimleri; ekran açık kaldığı sürece yaşar. Dönem bu
/// yılın başından bugüne açılır.

abstract class _$ReportFormController extends $Notifier<ReportFormState> {
  ReportFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ReportFormState, ReportFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ReportFormState, ReportFormState>,
              ReportFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

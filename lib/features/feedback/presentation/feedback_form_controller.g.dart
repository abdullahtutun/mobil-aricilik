// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// "Görüş bildir" formu. Görüş yerel kuyruğa yazılır; internet yoksa
/// bağlanınca gider. Ekran kapanırken gönderilmemiş görüşün ekran
/// görüntüsü silinir.

@ProviderFor(FeedbackFormController)
final feedbackFormControllerProvider = FeedbackFormControllerProvider._();

/// "Görüş bildir" formu. Görüş yerel kuyruğa yazılır; internet yoksa
/// bağlanınca gider. Ekran kapanırken gönderilmemiş görüşün ekran
/// görüntüsü silinir.
final class FeedbackFormControllerProvider
    extends $NotifierProvider<FeedbackFormController, FeedbackFormState> {
  /// "Görüş bildir" formu. Görüş yerel kuyruğa yazılır; internet yoksa
  /// bağlanınca gider. Ekran kapanırken gönderilmemiş görüşün ekran
  /// görüntüsü silinir.
  FeedbackFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'feedbackFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$feedbackFormControllerHash();

  @$internal
  @override
  FeedbackFormController create() => FeedbackFormController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FeedbackFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FeedbackFormState>(value),
    );
  }
}

String _$feedbackFormControllerHash() =>
    r'7c064e228c821acb435db9e2ffa1b441277de823';

/// "Görüş bildir" formu. Görüş yerel kuyruğa yazılır; internet yoksa
/// bağlanınca gider. Ekran kapanırken gönderilmemiş görüşün ekran
/// görüntüsü silinir.

abstract class _$FeedbackFormController extends $Notifier<FeedbackFormState> {
  FeedbackFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<FeedbackFormState, FeedbackFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<FeedbackFormState, FeedbackFormState>,
              FeedbackFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Dil → ülke → işletme adı → kovan sayısı akışı. Ekran açık kaldığı sürece
/// yaşar. İşletme kurulunca yönlendirmeyi (ilk arılık adımına) router yapar.

@ProviderFor(OnboardingController)
final onboardingControllerProvider = OnboardingControllerProvider._();

/// Dil → ülke → işletme adı → kovan sayısı akışı. Ekran açık kaldığı sürece
/// yaşar. İşletme kurulunca yönlendirmeyi (ilk arılık adımına) router yapar.
final class OnboardingControllerProvider
    extends $NotifierProvider<OnboardingController, OnboardingState> {
  /// Dil → ülke → işletme adı → kovan sayısı akışı. Ekran açık kaldığı sürece
  /// yaşar. İşletme kurulunca yönlendirmeyi (ilk arılık adımına) router yapar.
  OnboardingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'onboardingControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$onboardingControllerHash();

  @$internal
  @override
  OnboardingController create() => OnboardingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(OnboardingState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<OnboardingState>(value),
    );
  }
}

String _$onboardingControllerHash() =>
    r'71156d28232c36820445f652e6a1dd042610d2e5';

/// Dil → ülke → işletme adı → kovan sayısı akışı. Ekran açık kaldığı sürece
/// yaşar. İşletme kurulunca yönlendirmeyi (ilk arılık adımına) router yapar.

abstract class _$OnboardingController extends $Notifier<OnboardingState> {
  OnboardingState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<OnboardingState, OnboardingState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<OnboardingState, OnboardingState>,
              OnboardingState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

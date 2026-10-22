import 'package:flutter/widgets.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/core/utils/uuid.dart';
import 'package:mobil_arici/features/onboarding/domain/onboarding_rules.dart';
import 'package:mobil_arici/features/onboarding/presentation/setup_in_progress.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'onboarding_controller.freezed.dart';
part 'onboarding_controller.g.dart';

/// Onboarding adımları, sırasıyla. Dil seçimi doğrudan uygulamanın diline
/// yazılır; diğerleri işletme kurulurken gönderilir. İşletme kurulunca
/// yerel bir adım daha gelir: ilk arılık (`FirstApiaryScreen`).
enum OnboardingStep { language, country, name, hiveCount }

/// Adım sayacındaki toplam: işletme adımları ve ilk arılık.
int get onboardingStepCount => OnboardingStep.values.length + 1;

@freezed
abstract class OnboardingState with _$OnboardingState {
  const factory({
    /// Kurulacak işletmenin kimliği. Yeniden denemede aynı kalır; yanıtı
    /// kaybolan istek tekrarlanınca ikinci işletme açılmaz.
    required String organizationId,
    @Default(OnboardingStep.language) OnboardingStep step,

    /// Cihazın dil listesinden önerilen ülke; listede en üstte durur.
    String? suggestedCountryCode,

    /// Başta önerilen ülke.
    String? countryCode,
    @Default('') String name,
    HiveCountRange? hiveCountRange,

    /// İşletme kuruluyor.
    @Default(false) bool busy,
    OrganizationFailure? failure,
  }) = _OnboardingState;
}

extension OnboardingProgress on OnboardingState {
  bool get isFirstStep => step == OnboardingStep.values.first;

  bool get isLastStep => step == OnboardingStep.values.last;

  /// Bu adımın cevabı verildi; sonraki adıma geçilebilir ya da (son adımda)
  /// işletme kurulabilir.
  bool get canContinue =>
      !busy &&
      switch (step) {
        OnboardingStep.language => true,
        OnboardingStep.country => countryCode != null,
        OnboardingStep.name => name.trim().isNotEmpty,
        OnboardingStep.hiveCount => hiveCountRange != null,
      };
}

/// Dil → ülke → işletme adı → kovan sayısı akışı. Ekran açık kaldığı sürece
/// yaşar. İşletme kurulunca yönlendirmeyi (ilk arılık adımına) router yapar.
@riverpod
class OnboardingController extends _$OnboardingController {
  @override
  OnboardingState build() {
    final suggested = suggestCountryCode(
      WidgetsBinding.instance.platformDispatcher.locales,
    );
    return OnboardingState(
      organizationId: generateId(),
      suggestedCountryCode: suggested,
      countryCode: suggested,
    );
  }

  void next() {
    if (!state.canContinue || state.isLastStep) return;
    state = state.copyWith(step: OnboardingStep.values[state.step.index + 1]);
  }

  /// Bir önceki adıma döner; ilk adımdaysa false.
  bool back() {
    if (state.isFirstStep || state.busy) return false;
    state = state.copyWith(
      step: OnboardingStep.values[state.step.index - 1],
      failure: null,
    );
    return true;
  }

  void selectCountry(String countryCode) {
    state = state.copyWith(countryCode: countryCode);
  }

  void updateName(String name) {
    state = state.copyWith(name: name, failure: null);
  }

  void selectHiveCountRange(HiveCountRange? range) {
    state = state.copyWith(hiveCountRange: range, failure: null);
  }

  /// Son adımda işletmeyi kurar. Hata durumda gösterilir; aynı kimlikle
  /// yeniden denenebilir. Kurulunca router ilk arılık adımına geçer.
  Future<void> submit() async {
    final countryCode = state.countryCode;
    if (!state.isLastStep || !state.canContinue || countryCode == null) return;
    state = state.copyWith(busy: true, failure: null);
    // İşletme gelmeden önce: router işletmeyi görünce Bugün'e değil ilk
    // arılık adımına gitsin.
    ref.read(setupInProgressProvider.notifier).start();
    try {
      await ref
          .read(currentOrganizationProvider.notifier)
          .create(
            id: state.organizationId,
            name: state.name.trim(),
            countryCode: countryCode,
            hiveCountRange: state.hiveCountRange,
          );
    } on OrganizationServiceException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: error.failure);
      }
      return;
    }
    if (ref.mounted) state = state.copyWith(busy: false);
  }
}

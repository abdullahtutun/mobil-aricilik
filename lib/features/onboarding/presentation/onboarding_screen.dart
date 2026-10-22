import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/country_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/hive_count_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/language_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/name_step.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/onboarding_failure_message.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';

/// Girişten sonra işletmesi olmayan kullanıcının ilk kurulumu. İşletme önce
/// cihazdan, yoksa sunucudan aranır; bulunamazsa akış açılır. İşletme
/// kurulunca router ilk arılık adımına, bulununca Bugün'e geçer.
class OnboardingScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return switch (ref.watch(currentOrganizationProvider)) {
      AsyncValue(isLoading: true) => const _Loading(),
      AsyncError(:final error) => _LoadError(
        error is OrganizationServiceException
            ? error.failure
            : OrganizationFailure.unknown,
      ),
      AsyncData(value: null) => const _OnboardingFlow(),
      // İşletme bulundu; router Bugün'e geçiyor.
      AsyncValue() => const _Loading(),
    };
  }
}

/// Çıkış: yanlış hesapla girildiyse ya da sunucuya ulaşılamıyorsa kullanıcı
/// burada kalmasın.
class _SignOutButton extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      tooltip: AppLocalizations.of(context).settingsSignOut,
      icon: const Icon(Icons.logout_rounded),
      onPressed: () => ref.read(currentUserProvider.notifier).signOut(),
    );
  }
}

class _Loading extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(
          semanticsLabel: AppLocalizations.of(context).onboardingLoading,
        ),
      ),
    );
  }
}

/// İşletme cihazda yok ve sunucudan alınamadı (ör. çevrimdışı ilk açılış).
/// Kullanıcının işletmesi olabileceği için akış açılmaz; yoksa ikinci
/// işletme kurulurdu.
class _LoadError extends ConsumerWidget {
  const new(this.failure);

  final OrganizationFailure failure;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(actions: const [_SignOutButton()]),
      body: SafeArea(
        child: EmptyState(
          icon: Icons.cloud_off_rounded,
          title: l10n.onboardingLoadErrorTitle,
          message: onboardingFailureText(l10n, failure),
          actionLabel: l10n.actionRetry,
          onAction: () => ref.invalidate(currentOrganizationProvider),
        ),
      ),
    );
  }
}

class _OnboardingFlow extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final state = ref.watch(onboardingControllerProvider);
    final controller = ref.read(onboardingControllerProvider.notifier);
    final failure = state.failure;

    return PopScope(
      // Geri tuşu önceki adıma döner; ilk adımda uygulamadan çıkar.
      canPop: state.isFirstStep,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) controller.back();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leading: state.isFirstStep
              ? null
              : BackButton(onPressed: state.busy ? null : controller.back),
          title: Text(
            l10n.onboardingStepCounter(
              state.step.index + 1,
              onboardingStepCount,
            ),
          ),
          actions: const [_SignOutButton()],
        ),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: switch (state.step) {
                  OnboardingStep.language => const LanguageStep(),
                  OnboardingStep.country => const CountryStep(),
                  OnboardingStep.name => const NameStep(),
                  OnboardingStep.hiveCount => const HiveCountStep(),
                },
              ),
              // Birincil eylem başparmağın ulaştığı yerde, altta.
              Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (failure != null) ...[
                      OnboardingFailureMessage(failure),
                      SizedBox(height: spacing.md),
                    ],
                    if (state.isLastStep)
                      BigButton(
                        label: state.busy
                            ? l10n.onboardingFinishing
                            : l10n.onboardingFinish,
                        icon: Icons.check_rounded,
                        onPressed: state.canContinue ? controller.submit : null,
                      )
                    else
                      BigButton(
                        label: l10n.onboardingContinue,
                        icon: Icons.arrow_forward_rounded,
                        onPressed: state.canContinue ? controller.next : null,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

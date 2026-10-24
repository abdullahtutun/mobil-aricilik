import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_controller.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_form_fields.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/setup_in_progress.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/onboarding_stepper.dart';

/// Onboarding'in son adımı: işletme kurulduktan sonra ilk arılık. Arılık
/// formunun aynısı; her şey yerel DB'ye yazılır, ağ gerekmez. Kaydedince ya
/// da atlanınca kurulum biter ve router Bugün'e (ya da saklanan konuma)
/// geçer. İşletme kurulduğu için önceki adımlara dönülmez.
class FirstApiaryScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final provider = apiaryFormControllerProvider(null);
    final form = ref.watch(provider).value;
    final setup = ref.read(setupInProgressProvider.notifier);

    final saving = form?.saving ?? false;

    return Scaffold(
      body: BottomActionLayout(
        body: form == null
            ? const SizedBox.shrink()
            : ListView(
                padding: EdgeInsets.all(spacing.lg),
                children: [
                  OnboardingStepper(
                    current: onboardingStepCount,
                    total: onboardingStepCount,
                  ),
                  SizedBox(height: spacing.xl),
                  Semantics(
                    header: true,
                    child: Text(
                      l10n.onboardingApiaryTitle,
                      style: context.typography.headline,
                    ),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    l10n.onboardingApiaryMessage,
                    style: context.typography.body.copyWith(
                      color: context.colors.textSecondary,
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  const ApiaryFormFields(apiaryId: null),
                ],
              ),
        action: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            BigButton(
              label: l10n.onboardingApiarySave,
              onPressed: (form?.canSave ?? false)
                  ? () => _save(context, ref)
                  : null,
            ),
            SizedBox(height: spacing.sm),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: context.colors.textSecondary,
                minimumSize: Size.fromHeight(context.touchTargets.minimum),
                textStyle: context.typography.label,
              ),
              onPressed: saving ? null : setup.finish,
              child: Text(l10n.onboardingApiarySkip),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final id = await ref
        .read(apiaryFormControllerProvider(null).notifier)
        .save();
    if (id == null || !context.mounted) return;
    ref.read(setupInProgressProvider.notifier).finish();
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_form_controller.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_form_fields.dart';
import 'package:mobil_arici/features/onboarding/presentation/onboarding_controller.dart';
import 'package:mobil_arici/features/onboarding/presentation/setup_in_progress.dart';
import 'package:mobil_arici/features/onboarding/presentation/widgets/step_header.dart';

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

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          l10n.onboardingStepCounter(onboardingStepCount, onboardingStepCount),
        ),
        actions: [
          // Altta yalnız Kaydet; klavye açıkken form görünür kalsın.
          TextButton(
            style: TextButton.styleFrom(
              minimumSize: Size.square(context.touchTargets.minimum),
              textStyle: context.typography.label,
            ),
            onPressed: (form?.saving ?? false) ? null : setup.finish,
            child: Text(l10n.onboardingApiarySkip),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: form == null
                  ? const SizedBox.shrink()
                  : ListView(
                      padding: EdgeInsets.all(spacing.lg),
                      children: [
                        StepHeader(
                          title: l10n.onboardingApiaryTitle,
                          message: l10n.onboardingApiaryMessage,
                        ),
                        SizedBox(height: spacing.xl),
                        const ApiaryFormFields(apiaryId: null),
                      ],
                    ),
            ),
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: BigButton(
                label: l10n.onboardingApiarySave,
                icon: Icons.check_rounded,
                onPressed: (form?.canSave ?? false)
                    ? () => _save(context, ref)
                    : null,
              ),
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

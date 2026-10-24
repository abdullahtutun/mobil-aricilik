import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/sign_out_button.dart';

/// Kurulum adımlarının üstü: solda isteğe bağlı Geri, sağda "ADIM 2 / 3"
/// ve çıkış; altında her adım için bir çubuk, geçilenler dolu. Ekran
/// okuyucu adım sayısını okur, çubukları atlar.
class OnboardingStepper extends StatelessWidget {
  const new({
    required this.current,
    required this.total,
    super.key,
    this.onBack,
  });

  /// 1'den başlar.
  final int current;
  final int total;

  /// Null ise Geri gösterilmez (ilk adım ya da geri dönülemeyen adım).
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final onBack = this.onBack;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (onBack != null)
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: colors.textPrimary,
                  textStyle: context.typography.label,
                  minimumSize: Size.square(context.touchTargets.minimum),
                  padding: EdgeInsets.zero,
                ),
                onPressed: onBack,
                child: Text(
                  MaterialLocalizations.of(context).backButtonTooltip,
                ),
              ),
            // Büyük yazıda sayaç alt satıra geçsin, Geri'yi itmesin.
            Expanded(
              child: Align(
                alignment: AlignmentDirectional.centerEnd,
                child: SectionLabel(l10n.onboardingStepCounter(current, total)),
              ),
            ),
            const SignOutButton(),
          ],
        ),
        SizedBox(height: spacing.sm),
        ExcludeSemantics(
          child: Row(
            spacing: spacing.sm,
            children: [
              for (var step = 1; step <= total; step++)
                Expanded(
                  child: SizedBox(
                    height: spacing.sm,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: step <= current
                            ? colors.primary
                            : colors.divider,
                        borderRadius: BorderRadius.circular(context.radii.pill),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

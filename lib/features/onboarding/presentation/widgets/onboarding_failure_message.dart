import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/organization/domain/organization_failure.dart';

String onboardingFailureText(
  AppLocalizations l10n,
  OrganizationFailure failure,
) {
  return switch (failure) {
    OrganizationFailure.network => l10n.onboardingErrorNetwork,
    OrganizationFailure.unknown => l10n.onboardingErrorUnknown,
  };
}

/// İşletme kurulamadı: kritik durum ikonu ve rengiyle birlikte cümle. Ekran
/// okuyucu hata çıkınca kendiliğinden okur.
class OnboardingFailureMessage extends StatelessWidget {
  const new(this.failure, {super.key});

  final OrganizationFailure failure;

  @override
  Widget build(BuildContext context) {
    const status = AppStatus.critical;
    return Semantics(
      liveRegion: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            status.icon,
            size: context.sizes.icon,
            color: status.colorIn(context.colors),
          ),
          SizedBox(width: context.spacing.sm),
          Expanded(
            child: Text(
              onboardingFailureText(AppLocalizations.of(context), failure),
              style: context.typography.body,
            ),
          ),
        ],
      ),
    );
  }
}

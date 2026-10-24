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

/// İşletme kurulamadı: kritik durum cümlesi.
class OnboardingFailureMessage extends StatelessWidget {
  const new(this.failure, {super.key});

  final OrganizationFailure failure;

  @override
  Widget build(BuildContext context) {
    return StatusMessage(
      status: AppStatus.critical,
      message: onboardingFailureText(AppLocalizations.of(context), failure),
    );
  }
}

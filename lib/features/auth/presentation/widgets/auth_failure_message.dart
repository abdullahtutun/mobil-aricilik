import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';

/// Giriş hatası: kritik durum cümlesi.
class AuthFailureMessage extends StatelessWidget {
  const new(this.failure, {super.key});

  final AuthFailure failure;

  @override
  Widget build(BuildContext context) {
    return StatusMessage(
      status: AppStatus.critical,
      message: _message(AppLocalizations.of(context), failure),
    );
  }

  static String _message(AppLocalizations l10n, AuthFailure failure) {
    return switch (failure) {
      AuthFailure.network => l10n.authErrorNetwork,
      AuthFailure.invalidEmail => l10n.authErrorInvalidEmail,
      AuthFailure.invalidCode => l10n.authErrorInvalidCode,
      AuthFailure.tooManyRequests => l10n.authErrorTooManyRequests,
      AuthFailure.unknown => l10n.authErrorUnknown,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/sign_in_code_form.dart';

/// Girişin ikinci adımı: e-postaya gelen kod. Kod tamamlanınca kendiliğinden
/// doğrulanır; giriş olunca router Bugün'e geçer. Geri tuşu e-postayı
/// değiştirmeye döner.
class SignInCodeScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          const PositionedDirectional(
            top: 0,
            end: 0,
            child: HoneycombBackdrop(),
          ),
          SignInCodeForm(
            heading: l10n.signInCodeHeading,
            secondaryAction: (
              label: l10n.signInChangeEmail,
              onPressed: () => context.go(AppRoutes.signIn),
            ),
          ),
        ],
      ),
    );
  }
}

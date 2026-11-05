import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/code_entry_form.dart';

/// Girişin ikinci adımı: e-postaya gelen kod. Kod tamamlanınca kendiliğinden
/// doğrulanır; giriş olunca router Bugün'e geçer. Geri tuşu e-postayı
/// değiştirmeye döner.
class SignInCodeScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final state = ref.watch(signInControllerProvider);
    final controller = ref.read(signInControllerProvider.notifier);
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          const PositionedDirectional(
            top: 0,
            end: 0,
            child: HoneycombBackdrop(),
          ),
          CodeEntryForm(
            heading: l10n.signInCodeHeading,
            state: (
              email: state.email,
              resendSeconds: state.resendSeconds,
              busy: state.busy,
              failure: state.failure,
            ),
            onVerify: (code) => controller.verifyCode(code, locale: locale),
            onResend: () => controller.resendCode(locale: locale),
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

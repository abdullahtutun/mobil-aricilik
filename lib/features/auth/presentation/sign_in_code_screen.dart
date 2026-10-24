import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/auth_failure_message.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/otp_code_field.dart';

/// Girişin ikinci adımı: e-postaya gelen kod. Kod tamamlanınca kendiliğinden
/// doğrulanır; giriş olunca router Bugün'e geçer. Geri tuşu e-postayı
/// değiştirmeye döner.
class SignInCodeScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInCodeScreen> createState() => _SignInCodeScreenState();
}

class _SignInCodeScreenState extends ConsumerState<SignInCodeScreen> {
  final _code = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  String get _locale => Localizations.localeOf(context).languageCode;

  Future<void> _verify() async {
    await ref
        .read(signInControllerProvider.notifier)
        .verifyCode(_code.text, locale: _locale);
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final sent = await ref
        .read(signInControllerProvider.notifier)
        .resendCode(locale: _locale);
    if (!sent || !mounted) return;
    _code.clear();
    _focus.requestFocus();
    showMessageSnackBar(context, l10n.signInCodeResent);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final state = ref.watch(signInControllerProvider);
    final failure = state.failure;

    // Yanlış kodda alan boşalır, yeniden yazmaya hazır olur.
    ref.listen(signInControllerProvider.select((s) => s.failure), (_, next) {
      if (next != AuthFailure.invalidCode) return;
      _code.clear();
      _focus.requestFocus();
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.signInCodeTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text(
              l10n.signInCodeMessage(state.email ?? ''),
              style: context.typography.body,
            ),
            SizedBox(height: spacing.lg),
            OtpCodeField(
              controller: _code,
              focusNode: _focus,
              semanticLabel: l10n.signInCodeFieldLabel,
              enabled: !state.busy,
              onCompleted: (_) => _verify(),
            ),
            if (failure != null) ...[
              SizedBox(height: spacing.md),
              AuthFailureMessage(failure),
            ],
            SizedBox(height: spacing.xl),
            ListenableBuilder(
              listenable: _code,
              builder: (context, _) => BigButton(
                label: state.busy ? l10n.signInVerifying : l10n.signInVerify,
                icon: Icons.login_rounded,
                onPressed: state.busy || _code.text.length != otpLength
                    ? null
                    : _verify,
              ),
            ),
            SizedBox(height: spacing.md),
            BigButton(
              variant: BigButtonVariant.secondary,
              label: state.resendSeconds > 0
                  ? l10n.signInResendIn(state.resendSeconds)
                  : l10n.signInResend,
              icon: Icons.refresh_rounded,
              onPressed: state.busy || state.resendSeconds > 0 ? null : _resend,
            ),
          ],
        ),
      ),
    );
  }
}

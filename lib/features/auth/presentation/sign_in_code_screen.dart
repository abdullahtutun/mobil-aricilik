import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
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

  /// Panodaki ilk 6 rakamı alana yazar; tamamsa doğrular.
  Future<void> _paste() async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final digits = (data?.text ?? '').replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty || !mounted) return;
    final code = digits.length > otpLength
        ? digits.substring(0, otpLength)
        : digits;
    _code.value = TextEditingValue(
      text: code,
      selection: TextSelection.collapsed(offset: code.length),
    );
    if (code.length == otpLength) await _verify();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final state = ref.watch(signInControllerProvider);
    final failure = state.failure;

    // Yanlış kodda alan boşalır, yeniden yazmaya hazır olur.
    ref.listen(signInControllerProvider.select((s) => s.failure), (_, next) {
      if (next != AuthFailure.invalidCode) return;
      _code.clear();
      _focus.requestFocus();
    });

    final textAction = TextButton.styleFrom(
      minimumSize: Size(
        context.touchTargets.minimum,
        context.touchTargets.minimum,
      ),
      textStyle: context.typography.label,
    );

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          const PositionedDirectional(
            top: 0,
            end: 0,
            child: HoneycombBackdrop(),
          ),
          BottomActionLayout(
            body: ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                Semantics(
                  header: true,
                  child: Text(
                    l10n.signInCodeHeading,
                    style: context.typography.headline,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Text(
                  l10n.signInCodeMessage(state.email ?? ''),
                  style: context.typography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                SizedBox(height: spacing.xl),
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
                SizedBox(height: spacing.md),
                Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    TextButton(
                      style: textAction.copyWith(
                        foregroundColor: WidgetStatePropertyAll(
                          colors.textSecondary,
                        ),
                      ),
                      onPressed: state.busy || state.resendSeconds > 0
                          ? null
                          : _resend,
                      child: Text(
                        state.resendSeconds > 0
                            ? l10n.signInResendIn(state.resendSeconds)
                            : l10n.signInResend,
                      ),
                    ),
                    TextButton(
                      style: textAction,
                      onPressed: state.busy ? null : _paste,
                      child: Text(l10n.signInPasteCode),
                    ),
                  ],
                ),
                SizedBox(height: spacing.lg),
                NoteCard(
                  icon: Icons.mail_outline_rounded,
                  message: l10n.signInCodeSpamHint,
                ),
              ],
            ),
            action: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListenableBuilder(
                  listenable: _code,
                  builder: (context, _) => BigButton(
                    label: state.busy
                        ? l10n.signInVerifying
                        : l10n.signInVerify,
                    onPressed: state.busy || _code.text.length != otpLength
                        ? null
                        : _verify,
                  ),
                ),
                SizedBox(height: spacing.sm),
                TextButton(
                  style: textAction.copyWith(
                    foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
                  ),
                  onPressed: state.busy
                      ? null
                      : () => context.go(AppRoutes.signIn),
                  child: Text(l10n.signInChangeEmail),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

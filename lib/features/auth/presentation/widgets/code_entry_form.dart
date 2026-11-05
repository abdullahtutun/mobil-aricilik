import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/auth_failure_message.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/otp_code_field.dart';

/// Kod doğrulamanın altındaki metin düğmesi ("E-postayı değiştir").
typedef CodeFormAction = ({String label, VoidCallback onPressed});

/// Kod formunun durumu: kodun gittiği adres, yeni kod istenebilene kadar
/// kalan saniye, gönderiliyor/doğrulanıyor ve son hata.
typedef CodeFormState = ({
  String? email,
  int resendSeconds,
  bool busy,
  AuthFailure? failure,
});

/// E-postaya gelen 6 haneli kodun formu: alan, hata, yeniden gönder,
/// yapıştır, spam notu ve Doğrula. Kod tamamlanınca kendiliğinden doğrulanır.
/// Giriş ekranı (giriş kodu) ve hesap silmedeki kimlik doğrulama (silme
/// kodu) bu formu paylaşır; kodu gönderen ve doğrulayan [onVerify] /
/// [onResend]'i veren denetleyicidir. Doğrulanınca [onVerified].
class CodeEntryForm extends StatefulWidget {
  const new({
    required this.heading,
    required this.state,
    required this.onVerify,
    required this.onResend,
    super.key,
    this.overline,
    this.verifyLabel,
    this.secondaryAction,
    this.onVerified,
  });

  final String heading;
  final CodeFormState state;

  /// Kodu doğrular; doğrulandıysa true.
  final Future<bool> Function(String code) onVerify;

  /// Yeni kod ister; gönderildiyse true.
  final Future<bool> Function() onResend;

  /// Başlığın üstündeki küçük satır (ör. "Adım 3/4"); null ise yok.
  final String? overline;

  /// Doğrulama düğmesinin etiketi; null ise "Giriş yap".
  final String? verifyLabel;

  /// Doğrula'nın altındaki metin düğmesi; null ise yok.
  final CodeFormAction? secondaryAction;
  final VoidCallback? onVerified;

  @override
  State<CodeEntryForm> createState() => _CodeEntryFormState();
}

class _CodeEntryFormState extends State<CodeEntryForm> {
  final _code = TextEditingController();
  final _focus = FocusNode();

  @override
  void dispose() {
    _code.dispose();
    _focus.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(CodeEntryForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Yanlış kodda alan boşalır, yeniden yazmaya hazır olur.
    if (widget.state.failure == AuthFailure.invalidCode &&
        oldWidget.state.failure != AuthFailure.invalidCode) {
      _code.clear();
      _focus.requestFocus();
    }
  }

  Future<void> _verify() async {
    final verified = await widget.onVerify(_code.text);
    if (verified && mounted) widget.onVerified?.call();
  }

  Future<void> _resend() async {
    final l10n = AppLocalizations.of(context);
    final sent = await widget.onResend();
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
    final state = widget.state;
    final failure = state.failure;
    final secondary = widget.secondaryAction;
    final overline = widget.overline;

    final textAction = TextButton.styleFrom(
      minimumSize: Size(
        context.touchTargets.minimum,
        context.touchTargets.minimum,
      ),
      textStyle: context.typography.label,
    );

    return BottomActionLayout(
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          if (overline != null) ...[
            Text(
              overline,
              style: context.typography.label.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.xs),
          ],
          Semantics(
            header: true,
            child: Text(widget.heading, style: context.typography.headline),
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
                  foregroundColor: WidgetStatePropertyAll(colors.textSecondary),
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
                  : widget.verifyLabel ?? l10n.signInVerify,
              onPressed: state.busy || _code.text.length != otpLength
                  ? null
                  : _verify,
            ),
          ),
          if (secondary != null) ...[
            SizedBox(height: spacing.sm),
            TextButton(
              style: textAction.copyWith(
                foregroundColor: WidgetStatePropertyAll(colors.textPrimary),
              ),
              onPressed: state.busy ? null : secondary.onPressed,
              child: Text(secondary.label),
            ),
          ],
        ],
      ),
    );
  }
}

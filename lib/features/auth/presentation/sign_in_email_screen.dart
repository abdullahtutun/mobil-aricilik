import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/auth/presentation/sign_in_controller.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/auth_failure_message.dart';

/// Girişin ilk adımı: e-posta adresi. Kod gönderilince kod ekranı açılır.
class SignInEmailScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SignInEmailScreen> createState() => _SignInEmailScreenState();
}

class _SignInEmailScreenState extends ConsumerState<SignInEmailScreen> {
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    // Kod e-postası uygulamanın o anki dilinde gitsin.
    final locale = Localizations.localeOf(context).languageCode;
    final sent = await ref
        .read(signInControllerProvider.notifier)
        .sendCode(_email.text, locale: locale);
    if (sent && mounted) context.go(AppRoutes.signInCode);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final state = ref.watch(signInControllerProvider);
    final failure = state.failure;

    return Scaffold(
      body: Stack(
        children: [
          const PositionedDirectional(
            top: 0,
            end: 0,
            child: HoneycombBackdrop(),
          ),
          BottomActionLayout(
            body: ListView(
              padding: EdgeInsets.fromLTRB(
                spacing.lg,
                spacing.xxxl,
                spacing.lg,
                spacing.lg,
              ),
              children: [
                const Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: AppLogo(),
                ),
                SizedBox(height: spacing.xl),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.appTitle,
                    style: context.typography.headline,
                  ),
                ),
                SizedBox(height: spacing.sm),
                Text(
                  l10n.signInTagline,
                  style: context.typography.subtitle.copyWith(
                    color: context.colors.textSecondary,
                    fontWeight: context.typography.body.fontWeight,
                  ),
                ),
                SizedBox(height: spacing.xxl),
                LabeledField(
                  label: l10n.signInEmailLabelLong,
                  helper: l10n.signInEmailHelper,
                  child: TextField(
                    controller: _email,
                    // İstek sürerken klavye kapanmasın; hata çıkınca
                    // düzeltmeye hazır kalsın.
                    readOnly: state.busy,
                    autofocus: true,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.send,
                    autofillHints: const [AutofillHints.email],
                    autocorrect: false,
                    style: context.typography.subtitle.copyWith(
                      fontWeight: context.typography.body.fontWeight,
                    ),
                    decoration: InputDecoration(hintText: l10n.signInEmailHint),
                    onChanged: (_) => ref
                        .read(signInControllerProvider.notifier)
                        .clearFailure(),
                    onSubmitted: (_) => _submit(),
                  ),
                ),
                if (failure != null) ...[
                  SizedBox(height: spacing.md),
                  AuthFailureMessage(failure),
                ],
              ],
            ),
            action: BigButton(
              label: state.busy ? l10n.signInSending : l10n.signInSendCode,
              onPressed: state.busy ? null : _submit,
            ),
          ),
        ],
      ),
    );
  }
}

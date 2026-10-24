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
      appBar: AppBar(title: Text(l10n.signInTitle)),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text(l10n.signInEmailMessage, style: context.typography.body),
            SizedBox(height: spacing.lg),
            TextField(
              controller: _email,
              // İstek sürerken klavye kapanmasın; hata çıkınca düzeltmeye
              // hazır kalsın.
              readOnly: state.busy,
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.send,
              autofillHints: const [AutofillHints.email],
              autocorrect: false,
              style: context.typography.body,
              decoration: InputDecoration(labelText: l10n.signInEmailLabel),
              onChanged: (_) =>
                  ref.read(signInControllerProvider.notifier).clearFailure(),
              onSubmitted: (_) => _submit(),
            ),
            if (failure != null) ...[
              SizedBox(height: spacing.md),
              AuthFailureMessage(failure),
            ],
            SizedBox(height: spacing.xl),
            BigButton(
              label: state.busy ? l10n.signInSending : l10n.signInSendCode,
              icon: Icons.mail_rounded,
              onPressed: state.busy ? null : _submit,
            ),
          ],
        ),
      ),
    );
  }
}

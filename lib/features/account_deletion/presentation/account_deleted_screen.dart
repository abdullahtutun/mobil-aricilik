import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';

/// Silme akışının bitişi: kalıcı silmenin tarihi (talepten 7 gün sonra), o
/// tarihe kadar giriş yapmanın silmeyi iptal edeceği ve oturumun kapandığı.
/// Oturum kapanınca da açık kalır; telefon temizlenene kadar Tamam pasif.
class AccountDeletedScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final outcome = ref.watch(lastDeletionOutcomeProvider);
    final cleared = outcome?.deviceCleared ?? true;

    return PopScope(
      canPop: false,
      child: Scaffold(
        body: SafeArea(
          child: BottomActionLayout(
            body: ListView(
              padding: EdgeInsets.all(spacing.lg),
              children: [
                SizedBox(height: spacing.xl),
                Icon(
                  Icons.check_circle_outline_rounded,
                  size: context.sizes.illustrationIcon,
                  color: context.colors.statusGood,
                ),
                SizedBox(height: spacing.lg),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.deletionDoneTitle,
                    style: context.typography.headline,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: spacing.lg),
                if (outcome != null)
                  Text(
                    l10n.deletionDoneDate(
                      AppFormat.of(context)
                          .date(outcome.request.scheduledFor.toLocal()),
                    ),
                    style: context.typography.subtitle,
                    textAlign: TextAlign.center,
                  ),
                SizedBox(height: spacing.md),
                Text(
                  l10n.deletionDoneCancelHint,
                  style: context.typography.body,
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.md),
                Text(
                  l10n.deletionDoneEmail,
                  style: context.typography.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: spacing.xl),
                StatusMessage(
                  status: cleared ? AppStatus.good : AppStatus.info,
                  message: cleared
                      ? l10n.deletionDoneSignedOut
                      : l10n.deletionDoneClearing,
                ),
              ],
            ),
            action: BigButton(
              label: l10n.deletionDoneAction,
              onPressed: cleared ? () => context.go(AppRoutes.signIn) : null,
            ),
          ),
        ),
      ),
    );
  }
}

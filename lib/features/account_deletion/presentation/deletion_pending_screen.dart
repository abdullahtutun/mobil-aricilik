import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';

/// Bekleme süresinde giriş yapan kullanıcı önce bunu görür: "Hesabın
/// silinmek üzere. Devam edersen silme iptal olur." Devam ederse talep iptal
/// edilir ve router uygulamayı açar; çıkış yaparsa talep sürer, oturum
/// kapanır ve telefondaki veriler silinir.
class DeletionPendingScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<DeletionPendingScreen> createState() =>
      _DeletionPendingScreenState();
}

class _DeletionPendingScreenState extends ConsumerState<DeletionPendingScreen> {
  bool _busy = false;

  Future<void> _keep() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(pendingDeletionProvider.notifier).keepAccount();
      // Router bu ekranı kapatır; mesaj uygulamanın ilk ekranında görünür.
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: SnackBarRegion(child: Text(l10n.deletionPendingCancelled)),
          ),
        );
    } on AccountDeletionException {
      if (mounted) {
        showMessageSnackBar(context, l10n.deletionPendingCancelFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _leave() async {
    setState(() => _busy = true);
    await ref.read(pendingDeletionProvider.notifier).leave();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final request = ref.watch(pendingDeletionProvider).value;

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
                  Icons.hourglass_top_rounded,
                  size: context.sizes.illustrationIcon,
                  color: context.colors.statusWarning,
                ),
                SizedBox(height: spacing.lg),
                Semantics(
                  header: true,
                  child: Text(
                    l10n.deletionPendingTitle,
                    style: context.typography.headline,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: spacing.md),
                if (request != null)
                  Text(
                    l10n.deletionPendingMessage(
                      AppFormat.of(context)
                          .date(request.scheduledFor.toLocal()),
                    ),
                    style: context.typography.body,
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
            action: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                BigButton(
                  icon: Icons.check_rounded,
                  label: l10n.deletionPendingContinue,
                  onPressed: _busy ? null : () => unawaited(_keep()),
                ),
                SizedBox(height: spacing.sm),
                BigButton(
                  variant: BigButtonVariant.secondary,
                  icon: Icons.logout_rounded,
                  label: l10n.deletionPendingSignOut,
                  onPressed: _busy ? null : () => unawaited(_leave()),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

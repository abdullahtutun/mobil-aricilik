import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/plans/presentation/plan_providers.dart';

/// Ücretsiz planın bir sınırına gelindiğini söyleyen kart: kilit ikonu,
/// başlık, ne olacağı ve "Pro'yu incele". Planlar açıkken görünür; buton
/// yalnız bu yapıda satın alma kuruluysa çıkar.
class PlanLimitCard extends ConsumerWidget {
  const new({required this.title, required this.message, super.key});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canBuy = ref.watch(purchaseServiceProvider).available;
    return NoteCard(
      icon: Icons.lock_outline_rounded,
      title: title,
      message: message,
      child: canBuy
          ? BigButton(
              label: l10n.planSeePro,
              icon: Icons.workspace_premium_outlined,
              variant: BigButtonVariant.secondary,
              onPressed: () => unawaited(context.push(AppRoutes.plan)),
            )
          : null,
    );
  }
}

/// Beta notu: bütün özellikler şimdilik ücretsiz, ileride Pro'ya geçecek
/// üç özellik ve verilen sözler. [onDismiss] verilirse altında "Anladım".
class BetaNoticeCard extends StatelessWidget {
  const new({super.key, this.onDismiss});

  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final onDismiss = this.onDismiss;
    return NoteCard(
      icon: Icons.campaign_outlined,
      title: l10n.planBetaTitle,
      message: l10n.planBetaBody,
      child: onDismiss == null
          ? null
          : Align(
              alignment: AlignmentDirectional.centerEnd,
              child: TextButton(
                onPressed: onDismiss,
                child: Text(l10n.planBetaDismiss),
              ),
            ),
    );
  }
}

/// Bugün'deki beta notu; "Anladım" denince bu telefonda bir daha
/// görünmez (Ayarlar'da durur). [padding] yalnız görünürken uygulanır.
class TodayBetaNotice extends ConsumerWidget {
  const new({super.key, this.padding = EdgeInsetsDirectional.zero});

  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Okunana kadar gösterilmez: kapatılmışsa bir an bile yanıp sönmesin.
    if (ref.watch(betaNoticeDismissedProvider).value ?? true) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: padding,
      child: BetaNoticeCard(
        onDismiss: () =>
            unawaited(ref.read(planRepositoryProvider).dismissBetaNotice()),
      ),
    );
  }
}

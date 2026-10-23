import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/domain/hive_label_code.dart';

/// Okutulan kod hiçbir kovanı açmadı: nedenini söyler ve etiketi bir
/// kovana atamayı sunar. [onScanAgain] verilirse kamerayı yeniden açan
/// buton da çıkar.
class UnknownLabelView extends StatelessWidget {
  const new({required this.code, super.key, this.onScanAgain});

  final String code;
  final VoidCallback? onScanAgain;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final onScanAgain = this.onScanAgain;
    // Bizim etiketimiz ama kovanı bu telefonda yok (silinmiş ya da henüz
    // senkronla gelmemiş).
    final ownLabel = hiveIdFromLabelCode(code) != null;

    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Icon(
              Icons.help_outline_rounded,
              size: context.sizes.illustrationIcon,
              color: colors.statusWarning,
            ),
            SizedBox(height: spacing.lg),
            Semantics(
              header: true,
              child: Text(
                ownLabel ? l10n.labelUnknownOwnTitle : l10n.labelUnknownTitle,
                textAlign: TextAlign.center,
                style: context.typography.title,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              ownLabel ? l10n.labelUnknownOwnMessage : l10n.labelUnknownMessage,
              textAlign: TextAlign.center,
              style: context.typography.body.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.sm),
            Text(
              l10n.labelCode(code.trim()),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: context.typography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.xl),
            BigButton(
              label: l10n.labelAssign,
              icon: Icons.link_rounded,
              onPressed: () => context.push(AppRoutes.labelAssign(code)),
            ),
            if (onScanAgain != null) ...[
              SizedBox(height: context.touchTargets.gap),
              BigButton(
                variant: BigButtonVariant.secondary,
                label: l10n.scanAgain,
                icon: Icons.qr_code_scanner_rounded,
                onPressed: onScanAgain,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Kayıtlar günlerdir gönderilemediğinde uyarı: uyarı ikonu, başlık ve
/// kaç kaydın yalnız bu telefonda olduğu. Renk tek başına anlam taşımaz;
/// ikon ve kelime birlikte. [onTap] verilirse kart dokunulabilir (Bugün'de
/// senkron ekranını açar).
class SyncOverdueCard extends StatelessWidget {
  const new({required this.pending, super.key, this.onTap});

  /// Gönderilmeyi bekleyen kayıt sayısı.
  final int pending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    const status = AppStatus.warning;

    return MergeSemantics(
      child: AppCard(
        status: status,
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                status.icon,
                size: context.sizes.icon,
                color: status.colorIn(context.colors),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.syncOverdueTitle,
                      style: context.typography.label,
                    ),
                    SizedBox(height: spacing.xs),
                    Text(
                      l10n.syncOverdueMessage(pending),
                      style: context.typography.body,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

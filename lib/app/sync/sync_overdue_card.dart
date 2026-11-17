import 'package:flutter/material.dart';
import 'package:mobil_arici/app/sync/sync_alert_card.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Kayıtlar günlerdir gönderilemediğinde uyarı: uyarı ikonu, başlık ve
/// kaç kaydın yalnız bu telefonda olduğu. [onTap] verilirse kart
/// dokunulabilir (Bugün'de senkron ekranını açar).
class SyncOverdueCard extends StatelessWidget {
  const new({required this.pending, super.key, this.onTap});

  /// Gönderilmeyi bekleyen kayıt sayısı.
  final int pending;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return SyncAlertCard(
      status: AppStatus.warning,
      title: l10n.syncOverdueTitle,
      message: l10n.syncOverdueMessage(pending),
      onTap: onTap,
    );
  }
}

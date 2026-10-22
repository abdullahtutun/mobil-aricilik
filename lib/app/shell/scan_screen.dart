import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Okutma için yer tutucu; QR/NFC okuma kendi adımında gelecek.
class ScanScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTitle)),
      body: Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.qr_code_scanner_rounded,
            title: l10n.scanPlaceholderTitle,
            message: l10n.scanPlaceholderMessage,
          ),
        ),
      ),
    );
  }
}

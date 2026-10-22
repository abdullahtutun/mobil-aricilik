import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

class ApiariesScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.tabApiaries)),
      body: Center(
        child: SingleChildScrollView(
          child: EmptyState(
            icon: Icons.hive_rounded,
            title: l10n.apiariesEmptyTitle,
            message: l10n.apiariesEmptyMessage,
          ),
        ),
      ),
    );
  }
}

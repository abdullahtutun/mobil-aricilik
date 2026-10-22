import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Arılık yerel DB'de yok ya da silinmiş (ör. eski bir linkle gelindi,
/// başka cihazda silindi).
class ApiaryNotFound extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: SingleChildScrollView(
        child: EmptyState(
          icon: Icons.wrong_location_rounded,
          title: l10n.apiaryNotFoundTitle,
          message: l10n.apiaryNotFoundMessage,
        ),
      ),
    );
  }
}

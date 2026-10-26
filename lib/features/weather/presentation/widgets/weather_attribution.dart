import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// "Powered by WeatherAPI.com": WeatherAPI.com ücretsiz planda atıf rica
/// ediyor; hava görünen her yerde. Metin her dilde aynı.
class WeatherAttribution extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      AppLocalizations.of(context).weatherAttribution,
      style: context.typography.bodySmall.copyWith(
        color: context.colors.textSecondary,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

class TodayScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          AppLocalizations.of(context).appTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
    );
  }
}

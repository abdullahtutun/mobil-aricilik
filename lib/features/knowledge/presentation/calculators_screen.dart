import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';
import 'package:mobil_arici/features/knowledge/presentation/widgets/calculator_labels.dart';

/// Hesaplayıcılar: şurup, ilaç dozu, ana takvimi ve verim; her biri kendi
/// ekranında. Hepsi internetsiz, kayıt yazmaz.
class CalculatorsScreen extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.knowledgeCalculatorsTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          ListGroup(
            children: [
              for (final calculator in Calculator.values)
                ListRow(
                  title: calculator.title(l10n),
                  subtitle: calculator.subtitle(l10n),
                  onTap: () =>
                      unawaited(context.push(AppRoutes.calculator(calculator))),
                ),
            ],
          ),
          SizedBox(height: spacing.lg),
          Text(
            l10n.calculatorOffline,
            style: context.typography.label.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

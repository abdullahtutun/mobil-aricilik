import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';

extension CalculatorLabel on Calculator {
  String title(AppLocalizations l10n) => switch (this) {
    Calculator.syrup => l10n.calculatorSyrup,
    Calculator.dose => l10n.calculatorDose,
    Calculator.queen => l10n.calculatorQueen,
    Calculator.yield_ => l10n.calculatorYield,
  };

  String subtitle(AppLocalizations l10n) => switch (this) {
    Calculator.syrup => l10n.calculatorSyrupSubtitle,
    Calculator.dose => l10n.calculatorDoseSubtitle,
    Calculator.queen => l10n.calculatorQueenSubtitle,
    Calculator.yield_ => l10n.calculatorYieldSubtitle,
  };
}

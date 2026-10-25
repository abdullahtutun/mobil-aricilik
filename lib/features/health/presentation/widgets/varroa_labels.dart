import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';

extension MiteCountMethodLabel on MiteCountMethod {
  String label(AppLocalizations l10n) => switch (this) {
    MiteCountMethod.sugarRoll => l10n.varroaMethodSugarRoll,
    MiteCountMethod.alcoholWash => l10n.varroaMethodAlcoholWash,
    MiteCountMethod.stickyBoard => l10n.varroaMethodStickyBoard,
  };
}

/// Sonuç birimiyle: `%3,0` ya da `Günde 10,0 akar`.
String miteLoadText(AppLocalizations l10n, MiteLoad load) =>
    miteValueText(l10n, load.value, load.unit);

/// [unit] biriminde bir değer (sonuç ya da eşik).
String miteValueText(AppLocalizations l10n, double value, MiteLoadUnit unit) =>
    switch (unit) {
      MiteLoadUnit.percent => l10n.varroaPercent(value),
      MiteLoadUnit.perDay => l10n.varroaPerDay(value),
    };

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';

extension QueenMarkColorLabel on QueenMarkColor {
  String label(AppLocalizations l10n) => l10n.queenMarkColorName(name);
}

extension QueenSourceLabel on QueenSource {
  String label(AppLocalizations l10n) => switch (this) {
    QueenSource.ownRearing => l10n.queenSourceOwnRearing,
    QueenSource.purchased => l10n.queenSourcePurchased,
    QueenSource.certifiedBreeder => l10n.queenSourceCertifiedBreeder,
  };
}

extension QueenLabels on Queen {
  /// "2025 · Mavi"; yıl ya da işaret yoksa onu söyler.
  String title(AppLocalizations l10n) => [
    if (year case final year?) '$year' else l10n.queenYearUnknown,
    markColor?.label(l10n) ?? l10n.queenUnmarked,
  ].join(l10n.titleSeparator);

  /// Başka ekranda anılışı: kovandaysa "Kovan 88 · 2024 · Sarı", değilse
  /// yalnız [title].
  String reference(AppLocalizations l10n, {Hive? hive}) => [
    if (hive != null) l10n.hiveLabel(hive.number),
    title(l10n),
  ].join(l10n.titleSeparator);

  /// "1 yaşında · Kafkas"; yaş ya da ırk yoksa o kısım yazılmaz. İkisi de
  /// yoksa null.
  String? detail(AppLocalizations l10n, {required int currentYear}) {
    final parts = [
      if (year case final year?)
        l10n.queenAge(queenAge(year, currentYear: currentYear)),
      if (breed case final breed? when breed.isNotEmpty) breed,
    ];
    return parts.isEmpty ? null : parts.join(l10n.titleSeparator);
  }
}

/// Ananın işaret rengi dairede; işaretsiz anada kart zemininde taç ikonu.
/// Renk her zaman yanında kelimeyle de yazar; daire ekran okuyucuya
/// gösterilmez.
class QueenMarkCircle extends StatelessWidget {
  const new({required this.markColor, required this.dimension, super.key});

  final QueenMarkColor? markColor;
  final double dimension;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final markColor = this.markColor;

    return ExcludeSemantics(
      child: SizedBox.square(
        dimension: dimension,
        child: DecoratedBox(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: markColor == null
                ? colors.surfaceContainer
                : colors.queenMark(markColor),
            border: Border.all(
              color: colors.outline,
              width: context.strokes.border,
            ),
          ),
          child: markColor == null
              ? Icon(
                  Icons.workspace_premium_outlined,
                  size: context.sizes.icon,
                  color: colors.textSecondary,
                )
              : null,
        ),
      ),
    );
  }
}

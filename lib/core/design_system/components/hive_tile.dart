import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_card.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/components/strength_dots.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart'
    show QueenMarkColor;

/// Arılık ızgarasındaki kovan karosu: üstte ana arı renk noktası ve uyarı
/// ikonu, ortada büyük numara, altta güç puanı noktaları.
///
/// Uyarının kelimesi ([alertLabel]) ekran okuyucuya gider. Kritik uyarıda
/// (ör. anasız) karo durumun zemininde çizilir ve kelime noktaların yerinde
/// görünür; renk tek başına kalmaz.
class HiveTile extends StatelessWidget {
  const new({
    required this.number,
    super.key,
    this.strength,
    this.queenColor,
    this.alertStatus,
    this.alertLabel,
    this.onTap,
  }) : assert(
         strength == null || (strength >= 1 && strength <= maxStrength),
         'güç 1–5 arası olmalı',
       ),
       assert(
         (alertStatus == null) == (alertLabel == null),
         'uyarı ikonu kelimesiyle birlikte verilmeli',
       );

  static const int maxStrength = StrengthDots.max;

  final String number;

  /// 1–5. Null ise henüz puanlanmamış: tüm noktalar boş.
  final int? strength;

  /// Null ise renk noktası çizilmez (ana arı yok ya da rengi bilinmiyor).
  final QueenMarkColor? queenColor;
  final AppStatus? alertStatus;
  final String? alertLabel;
  final VoidCallback? onTap;

  String _semanticsLabel(AppLocalizations l10n) {
    return [
      l10n.hiveTileLabel(number),
      if (strength case final strength?) l10n.hiveTileStrength(strength),
      if (queenColor case final queenColor?)
        l10n.hiveTileQueenColor(queenColor.name),
      ?alertLabel,
    ].join(l10n.listSeparator);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final alertStatus = this.alertStatus;
    final alertLabel = this.alertLabel;
    final critical = alertStatus == AppStatus.critical;

    return Semantics(
      container: true,
      button: onTap != null,
      label: _semanticsLabel(AppLocalizations.of(context)),
      excludeSemantics: true,
      child: AppCard(
        onTap: onTap,
        status: critical ? alertStatus : null,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: context.touchTargets.fieldLarge,
            minHeight: context.touchTargets.fieldLarge,
          ),
          child: Padding(
            padding: EdgeInsets.all(spacing.md),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // İkon olmasa da yer tutar; ızgaradaki karolar aynı boyda
                // kalsın.
                SizedBox(
                  height: sizes.icon,
                  child: Row(
                    children: [
                      _QueenDot(color: queenColor),
                      const Spacer(),
                      if (alertStatus != null)
                        Icon(
                          alertStatus.icon,
                          size: sizes.icon,
                          color: alertStatus.colorIn(colors),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: spacing.xs),
                // Dar karoda ve büyük yazı boyutunda numara kırılmasın,
                // küçülsün.
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: AlignmentDirectional.centerStart,
                  child: Text(
                    number,
                    maxLines: 1,
                    style: context.typography.numberLarge,
                  ),
                ),
                SizedBox(height: spacing.sm),
                SizedBox(
                  height: sizes.queenDot,
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: AlignmentDirectional.centerStart,
                    child: critical && alertLabel != null
                        ? Text(
                            alertLabel,
                            maxLines: 1,
                            style: context.typography.labelSmall.copyWith(
                              color: alertStatus!.colorIn(colors),
                            ),
                          )
                        : StrengthDots(strength: strength),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _QueenDot extends StatelessWidget {
  const new({required this.color});

  final QueenMarkColor? color;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final color = this.color;
    return SizedBox.square(
      dimension: context.sizes.queenDot,
      child: color == null
          ? null
          : DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.queenMark(color),
                border: Border.all(
                  color: colors.outline,
                  width: context.strokes.border,
                ),
              ),
            ),
    );
  }
}

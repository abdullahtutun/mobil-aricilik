import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/components/app_status.dart';
import 'package:mobil_aricilik/core/design_system/theme_context.dart';
import 'package:mobil_aricilik/core/design_system/tokens/app_colors.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

/// Arılık ızgarasındaki kovan karosu: büyük numara, güç puanı noktaları,
/// ana arı renk noktası ve uyarı ikonu.
///
/// Karoda uyarı yalnızca ikon + renkle görünür; kelimesi ([alertLabel])
/// ekran okuyucuya gider.
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

  static const maxStrength = 5;

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
    ].join(', ');
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final alertStatus = this.alertStatus;

    return Semantics(
      container: true,
      button: onTap != null,
      label: _semanticsLabel(AppLocalizations.of(context)),
      excludeSemantics: true,
      child: Material(
        color: colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
          side: BorderSide(
            color: colors.divider,
            width: context.strokes.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Dar karoda ve büyük yazı boyutunda numara kırılmasın,
                      // küçülsün.
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: Text(
                            number,
                            maxLines: 1,
                            style: context.typography.numberLarge,
                          ),
                        ),
                      ),
                      if (alertStatus != null)
                        Icon(
                          alertStatus.icon,
                          size: sizes.icon,
                          color: alertStatus.colorIn(colors),
                        ),
                    ],
                  ),
                  SizedBox(height: spacing.sm),
                  Row(
                    children: [
                      Expanded(
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.centerStart,
                          child: _StrengthDots(strength: strength),
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      _QueenDot(color: queenColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _StrengthDots extends StatelessWidget {
  const new({required this.strength});

  final int? strength;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.sizes.strengthDot;
    final filledCount = strength ?? 0;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.spacing.xs,
      children: [
        for (var i = 0; i < HiveTile.maxStrength; i++)
          SizedBox.square(
            dimension: size,
            child: DecoratedBox(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < filledCount ? colors.primary : null,
                border: Border.all(
                  color: i < filledCount ? colors.primary : colors.outline,
                  width: context.strokes.border,
                ),
              ),
            ),
          ),
      ],
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
    // Renk yoksa da yer tutar; ızgaradaki karolar aynı boyda kalsın.
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

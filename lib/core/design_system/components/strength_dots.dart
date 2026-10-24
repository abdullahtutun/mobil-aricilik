import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Güç puanı noktaları (1–5): puan kadar nokta dolu, kalanı çerçeveli.
/// Puan yoksa hepsi boş.
///
/// Yalnız çizer; puanın kelimesini ekran okuyucuya kullanan widget verir.
class StrengthDots extends StatelessWidget {
  const new({required this.strength, super.key})
    : assert(
        strength == null || (strength >= 1 && strength <= max),
        'güç 1–5 arası olmalı',
      );

  static const max = 5;

  /// 1–5. Null ise henüz puanlanmamış.
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
        for (var i = 0; i < max; i++)
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

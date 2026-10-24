import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Sayaçla aynı görünümde tek satırlık alan: kart zemininde solda ad,
/// sağda beyaz kutuda büyük yazılı kısa giriş (ör. "İlk numara 101").
/// Ekran okuyucu adı alanla birlikte okur.
class InlineField extends StatelessWidget {
  const new({required this.label, required this.field, super.key});

  final String label;

  /// Genelde `TextField`; büyük sayı stili ve ortalama çağırana kalır
  /// (`typography.number`, `TextAlign.center`).
  final Widget field;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(context.radii.card),
          border: Border.all(
            color: colors.divider,
            width: context.strokes.border,
          ),
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: spacing.lg,
            end: spacing.sm,
            top: spacing.sm,
            bottom: spacing.sm,
          ),
          child: Row(
            children: [
              Expanded(child: Text(label, style: context.typography.subtitle)),
              SizedBox(width: context.touchTargets.gap),
              SizedBox(
                width:
                    context.touchTargets.field * 2 + context.touchTargets.gap,
                child: field,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Durum rozeti: renk + ikon + kelime, üçü birlikte.
class StatusBadge extends StatelessWidget {
  const new({required this.status, required this.label, super.key});

  final AppStatus status;

  /// Durumu anlatan kelime ("Anasız", "Zayıf"); ekran okuyucu da bunu okur.
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.colorIn(colors),
        borderRadius: BorderRadius.circular(context.radii.small),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.sm,
          vertical: spacing.xs,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              status.icon,
              size: context.sizes.iconSmall,
              color: colors.onStatus,
            ),
            SizedBox(width: spacing.xs),
            Flexible(
              child: Text(
                label,
                style: context.typography.label.copyWith(
                  color: colors.onStatus,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

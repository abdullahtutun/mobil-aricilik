import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Durum rozeti: renk + ikon + kelime, üçü birlikte. Durumun açık zemininde,
/// yazı ve ikon durum renginde; kenarları tam yuvarlak.
class StatusBadge extends StatelessWidget {
  const new({required this.status, required this.label, super.key});

  final AppStatus status;

  /// Durumu anlatan kelime ("Anasız", "Zayıf"); ekran okuyucu da bunu okur.
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final foreground = status.colorIn(colors);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.containerIn(colors),
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.md,
          vertical: spacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(status.icon, size: context.sizes.iconSmall, color: foreground),
            SizedBox(width: spacing.sm),
            Flexible(
              child: Text(
                label,
                style: context.typography.label.copyWith(color: foreground),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

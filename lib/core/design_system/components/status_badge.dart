import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Durum rozeti: renk + ikon + kelime, üçü birlikte. Durumun açık zemininde,
/// yazı ve ikon durum renginde; kenarları tam yuvarlak.
///
/// [icon] durumun varsayılan ikonunun yerine (ör. mavi "× Yağmur");
/// [dense] tablo hücresindeki küçük boy.
class StatusBadge extends StatelessWidget {
  const new({
    required this.status,
    required this.label,
    super.key,
    this.icon,
    this.dense = false,
  });

  final AppStatus status;

  /// Durumu anlatan kelime ("Anasız", "Zayıf"); ekran okuyucu da bunu okur.
  final String label;
  final IconData? icon;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final foreground = status.colorIn(colors);
    final style = dense
        ? context.typography.caption.copyWith(fontWeight: FontWeight.w600)
        : context.typography.label;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: status.containerIn(colors),
        borderRadius: BorderRadius.circular(context.radii.pill),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: dense ? spacing.sm : spacing.md,
          vertical: dense ? spacing.xs : spacing.sm,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon ?? status.icon,
              size: dense ? style.fontSize : context.sizes.iconSmall,
              color: foreground,
            ),
            SizedBox(width: dense ? spacing.xs : spacing.sm),
            Flexible(
              child: Text(label, style: style.copyWith(color: foreground)),
            ),
          ],
        ),
      ),
    );
  }
}

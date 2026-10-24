import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

enum BigButtonVariant {
  /// Ekranın tek birincil eylemi (Kaydet, Muayene başlat).
  primary,

  /// Yanındaki ikincil eylem; beyaz zeminde koyu bal çerçeveli.
  secondary,
}

/// Saha eylemleri için büyük buton (`touchTargets.button`, 60dp; eldivende
/// 68). Varsayılan olarak tam genişlikte; [expanded] false ise içeriği
/// kadar. [onPressed] null ise pasif görünür.
class BigButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = BigButtonVariant.primary,
    this.expanded = true,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final BigButtonVariant variant;
  final bool expanded;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final targets = context.touchTargets;
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        expanded
            ? Size.fromHeight(targets.button)
            : Size(targets.button, targets.button),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(
          horizontal: expanded ? context.spacing.lg : context.spacing.xl,
        ),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.button),
        ),
      ),
      textStyle: WidgetStatePropertyAll(context.typography.button),
      iconSize: WidgetStatePropertyAll(context.sizes.icon),
      // Eldiven büyümesi zaten tokenda; tema yoğunluğu bir kez daha eklemesin.
      visualDensity: VisualDensity.standard,
      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
    );
    final iconWidget = icon == null ? null : Icon(icon);
    final labelWidget = Text(label, textAlign: TextAlign.center);

    return switch (variant) {
      BigButtonVariant.primary => FilledButton.icon(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
        ).merge(style),
        icon: iconWidget,
        label: labelWidget,
      ),
      BigButtonVariant.secondary => OutlinedButton.icon(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: colors.tile,
          foregroundColor: colors.primary,
          side: BorderSide(
            color: onPressed == null ? colors.divider : colors.primary,
            width: context.strokes.focus,
          ),
        ).merge(style),
        icon: iconWidget,
        label: labelWidget,
      ),
    };
  }
}

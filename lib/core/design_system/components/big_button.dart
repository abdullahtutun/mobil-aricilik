import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/theme_context.dart';

enum BigButtonVariant {
  /// Ekranın tek birincil eylemi (Kaydet, Muayene başlat).
  primary,

  /// Yanındaki ikincil eylem; dolgusuz, çam yeşili çerçeveli.
  secondary,
}

/// Saha eylemleri için tam genişlikte, büyük saha hedefi (`fieldLarge`)
/// yüksekliğinde buton. [onPressed] null ise pasif görünür.
class BigButton extends StatelessWidget {
  const new({
    required this.label,
    required this.onPressed,
    super.key,
    this.icon,
    this.variant = BigButtonVariant.primary,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final BigButtonVariant variant;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final style = ButtonStyle(
      minimumSize: WidgetStatePropertyAll(
        Size.fromHeight(context.touchTargets.fieldLarge),
      ),
      padding: WidgetStatePropertyAll(
        EdgeInsets.symmetric(horizontal: context.spacing.lg),
      ),
      shape: WidgetStatePropertyAll(
        RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.button),
        ),
      ),
      textStyle: WidgetStatePropertyAll(context.typography.label),
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
          foregroundColor: colors.secondary,
          side: BorderSide(
            color: onPressed == null ? colors.outline : colors.secondary,
            width: context.strokes.border,
          ),
        ).merge(style),
        icon: iconWidget,
        label: labelWidget,
      ),
    };
  }
}

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Izgaradaki büyük eylem karosu (hızlı kayıt): üstte ikon, altta kelime.
/// [highlighted] karo koyu bal dolgulu; ekranın önerdiği ilk eylem.
class ActionTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
    this.iconColor,
    this.highlighted = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  /// Boşsa koyu bal; [highlighted] karoda hep dolgunun üstündeki renk.
  final Color? iconColor;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final foreground = highlighted ? colors.onPrimary : colors.textPrimary;

    return Semantics(
      button: true,
      container: true,
      child: Material(
        color: highlighted ? colors.primary : colors.tile,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
          side: BorderSide(
            color: highlighted ? colors.primary : colors.divider,
            width: context.strokes.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.touchTargets.fieldLarge + spacing.xl,
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: context.sizes.icon,
                    color: highlighted
                        ? colors.onPrimary
                        : iconColor ?? colors.primary,
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: context.typography.label.copyWith(color: foreground),
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

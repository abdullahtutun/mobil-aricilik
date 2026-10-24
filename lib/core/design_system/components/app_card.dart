import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Kart zemini. Gölge yerine ince kenarlık; güneş modunda kenarlık kalın ve
/// siyah. [onTap] verilirse kartın tamamı dokunulabilir.
class AppCard extends StatelessWidget {
  const new({required this.child, super.key, this.onTap});

  final Widget child;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onTap = this.onTap;

    return Material(
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.card),
        side: BorderSide(color: colors.divider, width: context.strokes.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: onTap == null ? child : InkWell(onTap: onTap, child: child),
    );
  }
}

/// Başka ekrana götüren kart: [child] solda, sağda ok. Ekran okuyucu kartı
/// tek öğe olarak okur.
class NavigationCard extends StatelessWidget {
  const new({
    required this.child,
    required this.onTap,
    super.key,
    this.padding,
  });

  final Widget child;
  final VoidCallback onTap;

  /// Boşsa her yönde `spacing.lg`.
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: padding ?? EdgeInsets.all(spacing.lg),
            child: Row(
              children: [
                Expanded(child: child),
                SizedBox(width: spacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  size: context.sizes.icon,
                  color: context.colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

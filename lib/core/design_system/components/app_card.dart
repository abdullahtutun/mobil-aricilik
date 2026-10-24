import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Kart yüzeyi: beyaz karo, gölge yerine ince çizgi; güneş modunda kenarlık
/// kalın ve siyah. [onTap] verilirse kartın tamamı dokunulabilir.
///
/// [status] verilirse kart o durumun açık zemini ve renginde kenarlıkla
/// çizilir (ör. anasız kovan); kelimesini içerik verir.
class AppCard extends StatelessWidget {
  const new({required this.child, super.key, this.onTap, this.status});

  final Widget child;
  final VoidCallback? onTap;
  final AppStatus? status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onTap = this.onTap;
    final status = this.status;

    return Material(
      color: status?.containerIn(colors) ?? colors.tile,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.card),
        side: BorderSide(
          color: status?.colorIn(colors) ?? colors.divider,
          width: context.strokes.border,
        ),
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

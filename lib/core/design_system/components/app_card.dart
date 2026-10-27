import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_status.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Kart yüzeyi: beyaz karo, gölge yerine ince çizgi; güneş modunda kenarlık
/// kalın ve siyah. [onTap] verilirse kartın tamamı dokunulabilir.
///
/// [status] verilirse kart o durumun açık zemininde, zemine yakın soluk
/// kenarlıkla çizilir (ör. anasız kovan; docs/design); güneş modunda
/// kenarlık durumun kendi rengi. Kelimesini içerik verir. [filled] false
/// ise zemin beyaz kalır, yalnız kenarlık durumun tonunda (ör. süresi
/// dolmak üzere belge; içindeki durum rozeti zeminde kaybolmaz).
class AppCard extends StatelessWidget {
  const new({
    required this.child,
    super.key,
    this.onTap,
    this.status,
    this.filled = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final AppStatus? status;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final onTap = this.onTap;
    final status = this.status;
    // Güneş paletinde kart zemini sayfa zeminiyle bir; ayrım kenarlıkta.
    final sun = colors.surfaceContainer == colors.surface;
    final border = switch (status) {
      null => colors.divider,
      _ when sun => status.colorIn(colors),
      _ => Color.lerp(status.containerIn(colors), status.colorIn(colors), 0.2)!,
    };

    return Material(
      color: filled ? status?.containerIn(colors) ?? colors.tile : colors.tile,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.card),
        side: BorderSide(color: border, width: context.strokes.border),
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

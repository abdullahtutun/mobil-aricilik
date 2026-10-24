import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Kart zemininde açıklama kutusu: isteğe bağlı ikon ve başlık, altında
/// ikincil metin ya da [child] (ör. birim chip'leri).
class NoteCard extends StatelessWidget {
  const new({super.key, this.icon, this.title, this.message, this.child})
    : assert(message != null || child != null, 'metin ya da içerik gerekli');

  final IconData? icon;
  final String? title;
  final String? message;

  /// Metnin altında.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final icon = this.icon;
    final title = this.title;
    final message = this.message;
    final child = this.child;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title, style: context.typography.subtitle),
          SizedBox(height: spacing.xs),
        ],
        if (message != null)
          Text(
            message,
            style: context.typography.body.copyWith(
              color: colors.textSecondary,
            ),
          ),
        if (child != null) ...[
          if (title != null || message != null) SizedBox(height: spacing.md),
          child,
        ],
      ],
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: BorderRadius.circular(context.radii.card),
        border: Border.all(
          color: colors.surfaceContainer == colors.surface
              ? colors.divider
              : colors.surfaceContainer,
          width: context.strokes.border,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: icon == null
            ? content
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    icon,
                    size: context.sizes.icon,
                    color: colors.textSecondary,
                  ),
                  SizedBox(width: spacing.md),
                  Expanded(child: content),
                ],
              ),
      ),
    );
  }
}

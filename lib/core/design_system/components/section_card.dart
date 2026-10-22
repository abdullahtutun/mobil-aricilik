import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Ekranı bölümlere ayıran kart: isteğe bağlı başlık ve içerik.
///
/// Gölge yerine ince kenarlık; güneş modunda kenarlık kalın ve siyah.
class SectionCard extends StatelessWidget {
  const new({required this.child, super.key, this.title});

  final String? title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final title = this.title;

    return Material(
      color: colors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(context.radii.card),
        side: BorderSide(color: colors.divider, width: context.strokes.border),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Semantics(
                header: true,
                child: Text(title, style: context.typography.subtitle),
              ),
              SizedBox(height: spacing.md),
            ],
            child,
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Zaman tünelinde bir olay: solda türünün ikonu ve bir sonraki olaya inen
/// çizgi; sağda başlık, zaman ve ayrıntı satırları.
///
/// İkon yalnız türü gösterir, anlamı başlıkta yazar. Ekran okuyucu satırı
/// tek parça okur.
class TimelineTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.time,
    super.key,
    this.details = const [],
    this.isLast = false,
  });

  final IconData icon;
  final String title;

  /// Biçimlenmiş tarih ve saat.
  final String time;

  /// Her biri ayrı satır.
  final List<String> details;

  /// Son olayın altında çizgi ve boşluk yok.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final typography = context.typography;

    return MergeSemantics(
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainer,
                    border: Border.all(
                      color: colors.outline,
                      width: context.strokes.border,
                    ),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(spacing.sm),
                    child: Icon(
                      icon,
                      size: sizes.iconSmall,
                      color: colors.textPrimary,
                    ),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: SizedBox(
                      width: context.strokes.border,
                      child: ColoredBox(color: colors.outline),
                    ),
                  ),
              ],
            ),
            SizedBox(width: spacing.md),
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(
                  top: spacing.xs,
                  bottom: isLast ? 0 : spacing.lg,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: typography.label),
                    Text(
                      time,
                      style: typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    for (final line in details) ...[
                      SizedBox(height: spacing.xs),
                      Text(line, style: typography.bodySmall),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

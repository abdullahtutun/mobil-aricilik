import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Zaman tünelinde bir olay: solda türünün ikonu kart zemininde bir
/// dairede ve bir sonraki olaya inen çizgi; sağda kalın başlık ve en sağda
/// zaman, altında ikincil ayrıntı satırları.
///
/// İkon yalnız türü gösterir, anlamı başlıkta yazar. Ekran okuyucu satırı
/// tek parça okur; [footer] (ör. foto küçük resimleri) kendi dokunma
/// hedefleriyle ayrı kalır.
class TimelineTile extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.time,
    super.key,
    this.details = const [],
    this.footer,
    this.isLast = false,
  });

  final IconData icon;
  final String title;

  /// Biçimlenmiş tarih ve saat.
  final String time;

  /// Her biri ayrı satır.
  final List<String> details;

  /// Ayrıntıların altında; satırın metniyle birleşmez.
  final Widget? footer;

  /// Son olayın altında çizgi ve boşluk yok.
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final secondary = typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );

    final footer = this.footer;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              SizedBox.square(
                dimension: context.touchTargets.minimum,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainer,
                    border: colors.surfaceContainer == colors.surface
                        ? Border.all(
                            color: colors.divider,
                            width: context.strokes.border,
                          )
                        : null,
                  ),
                  child: Icon(
                    icon,
                    size: context.sizes.iconSmall,
                    color: colors.primary,
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: SizedBox(
                    width: context.strokes.focus,
                    child: ColoredBox(color: colors.divider),
                  ),
                ),
            ],
          ),
          SizedBox(width: spacing.lg),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(
                top: spacing.sm,
                bottom: isLast ? 0 : spacing.xl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(title, style: typography.label),
                            ),
                            SizedBox(width: spacing.sm),
                            // Büyük yazıda zaman kendi sütununda kırılır.
                            Flexible(
                              child: Text(
                                time,
                                textAlign: TextAlign.end,
                                style: secondary,
                              ),
                            ),
                          ],
                        ),
                        for (final line in details) ...[
                          SizedBox(height: spacing.xs),
                          Text(line, style: secondary),
                        ],
                      ],
                    ),
                  ),
                  if (footer != null) ...[SizedBox(height: spacing.md), footer],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

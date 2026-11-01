import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/app_card.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Satırları tek kartta, aralarında çizgiyle toplar (Ayarlar, Senkron).
class ListGroup extends StatelessWidget {
  const new({required this.children, super.key});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final divider = Divider(
      height: context.strokes.border,
      thickness: context.strokes.border,
      color: context.colors.divider,
    );
    return AppCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, child) in children.indexed) ...[
            if (i > 0) divider,
            child,
          ],
        ],
      ),
    );
  }
}

/// [ListGroup] satırı: solda başlık (altında isteğe bağlı açıklama), sağda
/// değer ve [trailing]; [onTap] verilirse sağda ok çıkar. Ekran okuyucu
/// satırı tek parça okur.
class ListRow extends StatelessWidget {
  const new({
    required this.title,
    super.key,
    this.subtitle,
    this.value,
    this.valueColor,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? subtitle;

  /// Sağdaki kalın değer ("32", "Türkçe").
  final String? value;

  /// Değerin rengi (ör. gelir tutarı); boşsa dokunulabilir satırda ikincil,
  /// değilse birincil metin rengi. Anlamı değerin kendisi taşımalı.
  final Color? valueColor;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final subtitle = this.subtitle;
    final value = this.value;
    final trailing = this.trailing;
    final onTap = this.onTap;

    final row = ConstrainedBox(
      constraints: BoxConstraints(minHeight: context.touchTargets.field),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: spacing.lg,
          vertical: spacing.md,
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: context.typography.body),
                  if (subtitle != null)
                    Text(
                      subtitle,
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
            ),
            if (value != null) ...[
              SizedBox(width: spacing.md),
              // Değer sağa yaslı; ad ile yer yarı yarıya paylaşılır.
              Expanded(
                child: Text(
                  value,
                  textAlign: TextAlign.end,
                  style: context.typography.label.copyWith(
                    color:
                        valueColor ??
                        (onTap == null
                            ? colors.textPrimary
                            : colors.textSecondary),
                  ),
                ),
              ),
            ],
            if (trailing != null) ...[SizedBox(width: spacing.md), trailing],
            if (onTap != null) ...[
              SizedBox(width: spacing.sm),
              Icon(
                Icons.chevron_right_rounded,
                size: context.sizes.icon,
                color: colors.textSecondary,
              ),
            ],
          ],
        ),
      ),
    );

    return MergeSemantics(
      child: onTap == null ? row : InkWell(onTap: onTap, child: row),
    );
  }
}

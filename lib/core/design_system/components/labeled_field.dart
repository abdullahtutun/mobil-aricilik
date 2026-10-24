import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Alanın adı üstte, alan altında; altında isteğe bağlı açıklama.
///
/// Tek alanda (metin alanı) ekran okuyucu adı alanla birlikte okur. Altında
/// birden çok seçenek olan grupta ([group] true: chip'ler, seçim kartları)
/// ad ayrı okunur; seçenekler tek tek kalır.
class LabeledField extends StatelessWidget {
  const new({
    required this.label,
    required this.child,
    super.key,
    this.helper,
    this.group = false,
  });

  final String label;
  final Widget child;

  /// Alanın altında ikincil cümle ("Şifre yok. …").
  final String? helper;

  /// Altındaki öğeler ayrı ayrı seçilir; birleştirilmez.
  final bool group;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final helper = this.helper;

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          label,
          style: context.typography.label.copyWith(color: colors.textSecondary),
        ),
        SizedBox(height: spacing.sm),
        child,
        if (helper != null) ...[
          SizedBox(height: spacing.sm),
          Text(
            helper,
            style: context.typography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ],
    );
    return group ? content : MergeSemantics(child: content);
  }
}

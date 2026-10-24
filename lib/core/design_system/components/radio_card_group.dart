import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

class RadioCardOption<T> {
  const new({required this.value, required this.label, this.hint});

  final T value;
  final String label;

  /// Sağda ikincil kelime ("Cihaz dili").
  final String? hint;
}

/// Alt alta büyük seçim kartları; tek seçim. Seçili kart koyu bal
/// çerçeveli ve dolu daireli: seçim renk dışında daireyle de görünür.
class RadioCardGroup<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<RadioCardOption<T>> options;
  final T? selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: context.spacing.md,
      children: [
        for (final option in options)
          _RadioCard(
            option: option,
            selected: option.value == selected,
            onTap: () => onChanged(option.value),
          ),
      ],
    );
  }
}

class _RadioCard<T> extends StatelessWidget {
  const new({
    required this.option,
    required this.selected,
    required this.onTap,
  });

  final RadioCardOption<T> option;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final strokes = context.strokes;
    final hint = option.hint;
    final dot = context.sizes.icon;

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: colors.tile,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.card),
          side: BorderSide(
            color: selected ? colors.primary : colors.divider,
            width: strokes.focus,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.touchTargets.fieldLarge,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: spacing.lg,
                vertical: spacing.md,
              ),
              child: Row(
                children: [
                  SizedBox.square(
                    dimension: dot,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: selected ? colors.primary : colors.outline,
                          width: strokes.focus,
                        ),
                      ),
                      child: selected
                          ? Padding(
                              padding: EdgeInsets.all(spacing.xs),
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: colors.primary,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  SizedBox(width: spacing.lg),
                  Expanded(
                    child: Text(
                      option.label,
                      style: context.typography.subtitle,
                    ),
                  ),
                  if (hint != null) ...[
                    SizedBox(width: spacing.sm),
                    Flexible(
                      child: Text(
                        hint,
                        textAlign: TextAlign.end,
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

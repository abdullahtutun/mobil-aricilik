import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

class SegmentOption<T> {
  const new({required this.value, required this.label});

  final T value;
  final String label;
}

/// Görünüm seçici (Izgara / Liste): kart zemininde yan yana seçenekler;
/// seçili olan beyaz ve kalın yazılı. Seçim renk dışında dolgu ve ekran
/// okuyucunun "seçili" bilgisiyle de verilir.
class SegmentedTabs<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
  });

  final List<SegmentOption<T>> options;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(context.radii.button);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surfaceContainer,
        borderRadius: radius,
        border: Border.all(
          color: colors.surfaceContainer == colors.surface
              ? colors.divider
              : colors.surfaceContainer,
          width: context.strokes.border,
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.xs),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final option in options)
              _Segment(
                label: option.label,
                selected: option.value == selected,
                onTap: () => onChanged(option.value),
              ),
          ],
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const new({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final radius = BorderRadius.circular(context.radii.small);

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: true,
      child: Material(
        color: selected ? colors.tile : colors.surfaceContainer,
        shape: RoundedRectangleBorder(
          borderRadius: radius,
          side: selected && colors.tile == colors.surfaceContainer
              ? BorderSide(
                  color: colors.textPrimary,
                  width: context.strokes.border,
                )
              : BorderSide.none,
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.touchTargets.minimum,
              minWidth: context.touchTargets.minimum,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Center(
                widthFactor: 1,
                child: Text(
                  label,
                  style: context.typography.label.copyWith(
                    color: selected ? colors.textPrimary : colors.textSecondary,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

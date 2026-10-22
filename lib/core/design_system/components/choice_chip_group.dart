import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

class ChoiceChipOption<T> {
  const new({required this.value, required this.label});

  final T value;
  final String label;
}

/// Klavye yerine büyük chip'lerle seçim.
///
/// Tek seçimde ([multiSelect] false) en fazla bir değer seçilidir; seçili
/// chip'e yeniden dokunmak seçimi kaldırır. Seçim yalnızca renkle değil,
/// onay ikonuyla da gösterilir.
class ChoiceChipGroup<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
    this.multiSelect = false,
  });

  final List<ChoiceChipOption<T>> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final bool multiSelect;

  void _toggle(T value) {
    final isSelected = selected.contains(value);
    if (multiSelect) {
      onChanged(
        isSelected ? ({...selected}..remove(value)) : {...selected, value},
      );
    } else {
      onChanged(isSelected ? <T>{} : {value});
    }
  }

  @override
  Widget build(BuildContext context) {
    final gap = context.touchTargets.gap;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      children: [
        for (final option in options)
          _Chip(
            label: option.label,
            selected: selected.contains(option.value),
            exclusive: !multiSelect,
            onTap: () => _toggle(option.value),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const new({
    required this.label,
    required this.selected,
    required this.exclusive,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool exclusive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final foreground = selected ? colors.onSecondary : colors.textPrimary;
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.radii.small),
      side: BorderSide(
        color: selected ? colors.secondary : colors.outline,
        width: context.strokes.border,
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: exclusive,
      child: Material(
        color: selected ? colors.secondary : colors.surface,
        shape: shape,
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: context.touchTargets.field,
              minWidth: context.touchTargets.field,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.lg),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    Icon(
                      Icons.check_rounded,
                      size: context.sizes.iconSmall,
                      color: foreground,
                    ),
                    SizedBox(width: spacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      style: context.typography.label.copyWith(
                        color: foreground,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

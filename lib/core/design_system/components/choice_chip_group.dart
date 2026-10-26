import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

class ChoiceChipOption<T> {
  const new({required this.value, required this.label});

  final T value;
  final String label;
}

/// Klavye yerine büyük, yuvarlak kenarlı chip'lerle seçim (56dp).
///
/// Tek seçimde ([multiSelect] false) en fazla bir değer seçilidir; seçili
/// chip'e yeniden dokunmak seçimi kaldırır. Seçili chip koyu bal dolgulu
/// (docs/design); seçim ekran okuyucuya "seçili" olarak da iletilir.
///
/// [suggested] seçim bir öneridir (ör. önceki kayıttan): seçili chip dolu
/// değil koyu bal çerçeveli çizilir; içeriği kadar genişse geçmiş ikonu da
/// taşır. Öneriye dokunmak onu onaylar; seçim aynı kalır ve [onChanged]
/// çağrılır.
class ChoiceChipGroup<T> extends StatelessWidget {
  const new({
    required this.options,
    required this.selected,
    required this.onChanged,
    super.key,
    this.multiSelect = false,
    this.suggested = false,
    this.columns,
  }) : assert(columns == null || columns > 0, 'sütun sayısı pozitif olmalı');

  final List<ChoiceChipOption<T>> options;
  final Set<T> selected;
  final ValueChanged<Set<T>> onChanged;
  final bool multiSelect;
  final bool suggested;

  /// Verilirse chip'ler bu kadar eşit sütunda dizilir (ör. 2×2 aralık
  /// seçimi); boşsa içerikleri kadar geniş ve satıra sığdıkça yan yana.
  final int? columns;

  void _toggle(T value) {
    final isSelected = selected.contains(value);
    if (isSelected && suggested) {
      onChanged(selected);
    } else if (multiSelect) {
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
    Widget chip(ChoiceChipOption<T> option, {bool expand = false}) => _Chip(
      label: option.label,
      selected: selected.contains(option.value),
      suggested: suggested,
      exclusive: !multiSelect,
      expand: expand,
      onTap: () => _toggle(option.value),
    );

    final columns = this.columns;
    if (columns == null) {
      return Wrap(
        spacing: gap,
        runSpacing: gap,
        children: [for (final option in options) chip(option)],
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      spacing: gap,
      children: [
        for (var row = 0; row < options.length; row += columns)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: gap,
              children: [
                for (var i = row; i < row + columns; i++)
                  Expanded(
                    child: i < options.length
                        ? chip(options[i], expand: true)
                        : const SizedBox.shrink(),
                  ),
              ],
            ),
          ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const new({
    required this.label,
    required this.selected,
    required this.suggested,
    required this.exclusive,
    required this.expand,
    required this.onTap,
  });

  final String label;
  final bool selected;

  /// Seçim bir öneri; seçili chip çerçeveli ve geçmiş ikonlu.
  final bool suggested;
  final bool exclusive;

  /// Sütun düzeninde: hücreyi doldurur, içerik ortada.
  final bool expand;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final filled = selected && !suggested;
    final foreground = switch ((selected, suggested)) {
      (true, false) => colors.onPrimary,
      (true, true) => colors.textSecondary,
      (false, _) => colors.textPrimary,
    };
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(context.radii.pill),
      side: BorderSide(
        color: selected ? colors.primary : colors.divider,
        width: context.strokes.focus,
      ),
    );

    return Semantics(
      button: true,
      selected: selected,
      inMutuallyExclusiveGroup: exclusive,
      hint: selected && suggested
          ? AppLocalizations.of(context).suggestedValue
          : null,
      child: Material(
        color: filled ? colors.primary : colors.tile,
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
              // Sütunda dar hücreye sığsın; kelime bölünmesin.
              padding: EdgeInsets.symmetric(
                horizontal: expand ? spacing.sm : spacing.lg,
              ),
              child: Row(
                mainAxisSize: expand ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (selected && suggested && !expand) ...[
                    Icon(
                      Icons.history_rounded,
                      size: context.sizes.iconSmall,
                      color: foreground,
                    ),
                    SizedBox(width: spacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      textAlign: TextAlign.center,
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

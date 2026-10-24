import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Değer girilmemiş sayaçta sayının yerinde duran işaret; dilden bağımsız.
const _noValue = '–';

/// Eldivenle kaydırmadan sayı girmek için büyük −/+ butonlu sayaç.
///
/// Sınırda ilgili buton pasifleşir. [value] boşsa (girilmedi) − [min]'i,
/// + bir adım fazlasını verir. [suggested] değer bir öneridir (ör. önceki
/// kayıttan): sayı soluk çizilir, etiketin altında ikon ve kelimeyle
/// yazar. Ekran okuyucuda ayarlanabilir değer olarak görünür (yukarı/aşağı
/// kaydırma ile artar/azalır).
class BigStepper extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max,
    this.step = 1,
    this.suggested = false,
  }) : assert(max == null || min <= max, 'min, max değerini geçemez'),
       assert(step > 0, 'step pozitif olmalı');

  final String label;
  final int? value;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;
  final int step;
  final bool suggested;

  int? get _decreased => switch (value) {
    null => min,
    final value when value - step >= min => value - step,
    _ => null,
  };

  int? get _increased {
    final next = switch (value) {
      null => min + step,
      final value => value + step,
    };
    return max == null || next <= max! ? next : null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final targets = context.touchTargets;
    final decreased = _decreased;
    final increased = _increased;
    final value = this.value;

    return Semantics(
      container: true,
      label: label,
      value: value == null ? l10n.stepperNoValue : '$value',
      hint: suggested ? l10n.suggestedValue : null,
      increasedValue: increased == null ? null : '$increased',
      decreasedValue: decreased == null ? null : '$decreased',
      onIncrease: increased == null ? null : () => onChanged(increased),
      onDecrease: decreased == null ? null : () => onChanged(decreased),
      child: Row(
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: context.typography.body),
                  if (suggested)
                    Row(
                      children: [
                        Icon(
                          Icons.history_rounded,
                          size: context.sizes.iconSmall,
                          color: colors.textSecondary,
                        ),
                        SizedBox(width: spacing.xs),
                        Flexible(
                          child: Text(
                            l10n.suggestedValue,
                            style: context.typography.bodySmall.copyWith(
                              color: colors.textSecondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          SizedBox(width: targets.gap),
          _StepButton(
            icon: Icons.remove_rounded,
            tooltip: l10n.stepperDecrease,
            onPressed: decreased == null ? null : () => onChanged(decreased),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: targets.fieldLarge),
            child: ExcludeSemantics(
              child: Text(
                value == null ? _noValue : '$value',
                textAlign: TextAlign.center,
                style: suggested || value == null
                    ? context.typography.number.copyWith(
                        color: colors.textSecondary,
                      )
                    : context.typography.number,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            tooltip: l10n.stepperIncrease,
            onPressed: increased == null ? null : () => onChanged(increased),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.touchTargets.field;

    return IconButton.outlined(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        foregroundColor: colors.textPrimary,
        fixedSize: Size.square(size),
        minimumSize: Size.square(size),
        iconSize: context.sizes.icon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.button),
        ),
        side: BorderSide(
          color: onPressed == null ? colors.divider : colors.outline,
          width: context.strokes.border,
        ),
        // Eldiven büyümesi zaten tokenda; yoğunluk bir kez daha eklemesin.
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

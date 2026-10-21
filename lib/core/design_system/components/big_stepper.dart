import 'package:flutter/material.dart';
import 'package:mobil_aricilik/core/design_system/theme_context.dart';
import 'package:mobil_aricilik/core/l10n/generated/app_localizations.dart';

/// Eldivenle kaydırmadan sayı girmek için büyük −/+ butonlu sayaç.
///
/// Sınırda ilgili buton pasifleşir. Ekran okuyucuda ayarlanabilir değer
/// olarak görünür (yukarı/aşağı kaydırma ile artar/azalır).
class BigStepper extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.onChanged,
    super.key,
    this.min = 0,
    this.max,
    this.step = 1,
  }) : assert(max == null || min <= max, 'min, max değerini geçemez'),
       assert(step > 0, 'step pozitif olmalı');

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final int min;
  final int? max;
  final int step;

  bool get _canDecrease => value - step >= min;
  bool get _canIncrease => max == null || value + step <= max!;

  void _decrease() => onChanged(value - step);
  void _increase() => onChanged(value + step);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final targets = context.touchTargets;

    return Semantics(
      container: true,
      label: label,
      value: '$value',
      increasedValue: _canIncrease ? '${value + step}' : null,
      decreasedValue: _canDecrease ? '${value - step}' : null,
      onIncrease: _canIncrease ? _increase : null,
      onDecrease: _canDecrease ? _decrease : null,
      child: Row(
        children: [
          Expanded(
            child: ExcludeSemantics(
              child: Text(label, style: context.typography.body),
            ),
          ),
          SizedBox(width: targets.gap),
          _StepButton(
            icon: Icons.remove_rounded,
            tooltip: l10n.stepperDecrease,
            onPressed: _canDecrease ? _decrease : null,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(minWidth: targets.fieldLarge),
            child: ExcludeSemantics(
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: context.typography.number,
              ),
            ),
          ),
          _StepButton(
            icon: Icons.add_rounded,
            tooltip: l10n.stepperIncrease,
            onPressed: _canIncrease ? _increase : null,
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

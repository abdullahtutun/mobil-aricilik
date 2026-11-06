import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';
import 'package:mobil_arici/core/design_system/tokens/app_touch_targets.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';

/// Değer girilmemiş sayaçta sayının yerinde duran işaret; dilden bağımsız.
const _noValue = '–';

/// Eldivenle kaydırmadan sayı girmek için büyük −/+ butonlu sayaç. Kart
/// zemininde: solda etiket, sağda beyaz −, büyük sayı ve dolu +.
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
      child: DecoratedBox(
        // Kart zemininde kenarlıksız; güneş paletinde zemin sayfayla bir
        // olduğu için kenarlık çizilir.
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(context.radii.card),
          border: colors.surfaceContainer == colors.surface
              ? Border.all(color: colors.divider, width: context.strokes.border)
              : null,
        ),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            start: spacing.lg,
            end: spacing.sm,
            top: spacing.sm,
            bottom: spacing.sm,
          ),
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              children: [
                Expanded(
                  child: ExcludeSemantics(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(label, style: context.typography.subtitle),
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
                  filled: false,
                  onPressed: decreased == null
                      ? null
                      : () => onChanged(decreased),
                ),
                // Değer sığmazsa (ör. büyük yazıda 4 haneli yıl) küçülür;
                // etikete en az bir alan genişliği kalır.
                ConstrainedBox(
                  constraints: _valueConstraints(constraints.maxWidth, targets),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
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
                ),
                _StepButton(
                  icon: Icons.add_rounded,
                  tooltip: l10n.stepperIncrease,
                  filled: true,
                  onPressed: increased == null
                      ? null
                      : () => onChanged(increased),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Değerin genişliği: en az [AppTouchTargets.fieldLarge]; en çok satırdan
  /// iki buton, boşluk ve etikete bırakılan bir alan genişliği düşünce
  /// kalan.
  static BoxConstraints _valueConstraints(
    double rowWidth,
    AppTouchTargets targets,
  ) {
    final room =
        rowWidth - 2 * targets.field - targets.gap - targets.fieldLarge;
    final max = room.clamp(0.0, double.infinity);
    return BoxConstraints(
      minWidth: targets.fieldLarge.clamp(0.0, max),
      maxWidth: max,
    );
  }
}

/// + koyu bal dolgulu, − beyaz; pasifken ikisi de soluk.
class _StepButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.filled,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool filled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.touchTargets.field;

    return IconButton(
      onPressed: onPressed,
      tooltip: tooltip,
      icon: Icon(icon),
      style: IconButton.styleFrom(
        backgroundColor: filled ? colors.primary : colors.tile,
        foregroundColor: filled ? colors.onPrimary : colors.textPrimary,
        disabledBackgroundColor: filled ? colors.divider : colors.tile,
        disabledForegroundColor: colors.textSecondary,
        fixedSize: Size.square(size),
        minimumSize: Size.square(size),
        iconSize: context.sizes.icon,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.button),
        ),
        side: filled || colors.surfaceContainer != colors.surface
            ? BorderSide.none
            : BorderSide(color: colors.divider, width: context.strokes.border),
        // Eldiven büyümesi zaten tokenda; yoğunluk bir kez daha eklemesin.
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
    );
  }
}

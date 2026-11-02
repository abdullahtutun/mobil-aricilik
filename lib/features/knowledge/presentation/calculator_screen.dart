import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/domain/feeding_rules.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/knowledge/domain/calculator_rules.dart';
import 'package:mobil_arici/features/knowledge/presentation/widgets/calculator_labels.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_rearing_labels.dart';
import 'package:mobil_arici/features/subsidies/presentation/subsidy_providers.dart';

/// Yıl seçicide bugünden önceki ve sonraki yıllar.
const _pickerYears = 1;

/// Bir hesaplayıcı: girdiler üstte, sonuç altta koyu kartta; yazdıkça
/// güncellenir. Kovan sayısı işletmenin aktif kovanlarıyla dolu gelir,
/// değiştirilebilir. Miktarlar bölgenin biriminde. Hiçbir şey kaydedilmez.
///
/// - Şurup: tür (1:1, 2:1), kovan sayısı ve kovan başına miktar → toplam
///   şurup, ≈ şeker ve su ([syrupRecipe]).
/// - İlaç dozu: kovan sayısı, kovan başına doz ve birim → toplam
///   ([totalDose]).
/// - Ana takvimi: aktarma günü → adımların günleri ([queenCalendar]).
/// - Verim: toplam bal ve kovan sayısı → kovan başına ([yieldPerHive]).
class CalculatorScreen extends ConsumerStatefulWidget {
  const new({required this.calculator, super.key});

  /// Rotada tanınmayan hesaplayıcıda null.
  final Calculator? calculator;

  @override
  ConsumerState<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends ConsumerState<CalculatorScreen> {
  final _hives = TextEditingController();
  final _amount = TextEditingController();

  /// Kullanıcı kovan sayısını değiştirdiyse aktif sayı üstüne yazılmaz.
  bool _hivesEdited = false;
  FeedingKind _syrupKind = FeedingKind.syrup2to1;
  int _syrupPerHive = 3;
  DrugDoseUnit _doseUnit = DrugDoseUnit.strip;
  late DateTime _graftedOn;

  @override
  void initState() {
    super.initState();
    final now = clock.now();
    _graftedOn = DateTime(now.year, now.month, now.day);
    ref.listenManual(activeHiveCountProvider, (_, next) {
      final count = next.value;
      if (_hivesEdited || count == null || count == 0) return;
      setState(() => _hives.text = '$count');
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _hives.dispose();
    _amount.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final calculator = widget.calculator;
    if (calculator == null) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.calculatorNotFound)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(calculator.title(l10n))),
      body: ListView(
        padding: EdgeInsets.all(context.spacing.lg),
        children: switch (calculator) {
          Calculator.syrup => _syrup(context),
          Calculator.dose => _dose(context),
          Calculator.queen => _queen(context),
          Calculator.yield_ => _yield(context),
        },
      ),
    );
  }

  List<Widget> _syrup(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final units = ref.watch(regionConfigProvider).defaultUnits;
    final unit = units.volume.label(l10n);
    final hives = parseCalculatorHives(_hives.text);
    final total = hives == null ? null : hives * _syrupPerHive;
    final recipe = total == null
        ? null
        : syrupRecipe(
            _syrupKind,
            units.volume.convert(total.toDouble(), to: VolumeUnit.liter),
          );

    return [
      LabeledField(
        label: l10n.calculatorSyrupKind,
        group: true,
        child: ChoiceChipGroup<FeedingKind>(
          columns: 2,
          options: [
            for (final kind in FeedingKind.values)
              if (kind.isSyrup)
                ChoiceChipOption(value: kind, label: kind.label(l10n)),
          ],
          selected: {_syrupKind},
          onChanged: (selected) {
            // Seçili chip'e yeniden dokunmak seçimi kaldırmasın.
            if (selected.isEmpty) return;
            setState(() => _syrupKind = selected.single);
          },
        ),
      ),
      SizedBox(height: spacing.xl),
      _hivesField(context),
      SizedBox(height: context.touchTargets.gap),
      BigStepper(
        label: l10n.feedingAmount(unit),
        value: _syrupPerHive,
        min: 1,
        max: maxFeedingAmount,
        onChanged: (value) => setState(() => _syrupPerHive = value),
      ),
      SizedBox(height: spacing.xl),
      if (hives == null || total == null || recipe == null)
        _FillHint(l10n.calculatorFillHint)
      else
        _ResultCard(
          label: l10n.feedingPrepare,
          detail: l10n.feedingPrepareCount(
            hives,
            format.number(_syrupPerHive),
            unit,
          ),
          value: l10n.feedingTotalSyrup(format.number(total), unit),
          parts: [
            (
              label: l10n.feedingSugar,
              value: l10n.feedingApprox(
                _approx(
                  format,
                  MassUnit.kilogram.convert(recipe.sugarKg, to: units.mass),
                ),
                units.mass.label(l10n),
              ),
            ),
            (
              label: l10n.feedingWater,
              value: l10n.feedingApprox(
                _approx(
                  format,
                  VolumeUnit.liter.convert(
                    recipe.waterLiters,
                    to: units.volume,
                  ),
                ),
                unit,
              ),
            ),
          ],
        ),
    ];
  }

  List<Widget> _dose(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);
    final hives = parseCalculatorHives(_hives.text);
    final perHive = parseCalculatorAmount(_amount.text);

    return [
      _hivesField(context),
      SizedBox(height: context.touchTargets.gap),
      _amountField(context, label: l10n.calculatorDosePerHive),
      SizedBox(height: spacing.xl),
      LabeledField(
        label: l10n.calculatorDoseUnit,
        group: true,
        child: ChoiceChipGroup<DrugDoseUnit>(
          columns: 2,
          options: [
            for (final unit in DrugDoseUnit.values)
              ChoiceChipOption(value: unit, label: unit.label(l10n)),
          ],
          selected: {_doseUnit},
          onChanged: (selected) {
            if (selected.isEmpty) return;
            setState(() => _doseUnit = selected.single);
          },
        ),
      ),
      SizedBox(height: spacing.xl),
      if (hives == null || perHive == null)
        _FillHint(l10n.calculatorFillHint)
      else
        _ResultCard(
          label: l10n.calculatorTotal,
          detail: l10n.calculatorDoseCount(
            hives,
            '${format.number(perHive, maxFractionDigits: 3)} '
            '${_doseUnit.label(l10n)}',
          ),
          value: l10n.calculatorDoseTotal(
            _doseUnit.value,
            format.number(
              totalDose(hives: hives, perHive: perHive),
              maxFractionDigits: 3,
            ),
          ),
        ),
    ];
  }

  List<Widget> _queen(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final format = AppFormat.of(context);

    return [
      ListGroup(
        children: [
          ListRow(
            title: l10n.rearingFormGraftedOn,
            value: format.date(_graftedOn),
            onTap: () async {
              final day = await showDatePicker(
                context: context,
                initialDate: _graftedOn,
                firstDate: DateTime(_graftedOn.year - _pickerYears),
                lastDate: DateTime(_graftedOn.year + _pickerYears, 12, 31),
              );
              if (day != null) setState(() => _graftedOn = day);
            },
          ),
        ],
      ),
      SizedBox(height: spacing.xl),
      SectionLabel(l10n.calculatorQueenSteps),
      SizedBox(height: spacing.sm),
      ListGroup(
        children: [
          for (final entry in queenCalendar(_graftedOn))
            ListRow(
              title: rearingStepTitle(l10n, entry.step),
              subtitle: l10n.rearingDay(entry.step.day),
              value: format.date(entry.date),
            ),
        ],
      ),
    ];
  }

  List<Widget> _yield(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final units = ref.watch(regionConfigProvider).defaultUnits;
    final unit = units.mass.label(l10n);
    final hives = parseCalculatorHives(_hives.text);
    final total = parseCalculatorAmount(_amount.text);

    return [
      _amountField(context, label: l10n.calculatorYieldTotal(unit)),
      SizedBox(height: context.touchTargets.gap),
      _hivesField(context),
      SizedBox(height: context.spacing.xl),
      if (hives == null || total == null)
        _FillHint(l10n.calculatorFillHint)
      else
        _ResultCard(
          label: l10n.calculatorYieldPerHive,
          value: l10n.calculatorYieldValue(
            format.number(
              yieldPerHive(total: total, hives: hives),
              maxFractionDigits: 1,
            ),
            unit,
          ),
        ),
    ];
  }

  Widget _hivesField(BuildContext context) => InlineField(
    label: AppLocalizations.of(context).calculatorHives,
    field: TextField(
      controller: _hives,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      textAlign: TextAlign.center,
      style: context.typography.number,
      onChanged: (_) => setState(() => _hivesEdited = true),
    ),
  );

  Widget _amountField(BuildContext context, {required String label}) =>
      InlineField(
        label: label,
        field: TextField(
          controller: _amount,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
          ],
          textAlign: TextAlign.center,
          style: context.typography.number,
          onChanged: (_) => setState(() {}),
        ),
      );

  /// Yaklaşık miktar: 10 ve üstü tam sayı, altı bir ondalık.
  static String _approx(AppFormat format, double value) =>
      format.number(value, maxFractionDigits: value >= 10 ? 0 : 1);
}

/// Girdiler eksikken sonucun yerindeki ipucu.
class _FillHint extends StatelessWidget {
  const new(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: context.typography.body.copyWith(
      color: context.colors.textSecondary,
    ),
  );
}

/// Sonuç: koyu zeminde büyük harfli etiket ve [detail] ("37 kovan × 3 L"),
/// büyük değer; altında isteğe bağlı parçalar (şeker, su) yan yana.
class _ResultCard extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    this.detail,
    this.parts = const [],
  });

  final String label;
  final String value;
  final String? detail;
  final List<({String label, String value})> parts;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final format = AppFormat.of(context);
    final detail = this.detail;
    final onCard = colors.onInverseSurface;

    return MergeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.inverseSurface,
          borderRadius: BorderRadius.circular(context.radii.card),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                alignment: WrapAlignment.spaceBetween,
                spacing: spacing.sm,
                children: [
                  Text(
                    format.upperCase(label),
                    style: typography.labelSmall.copyWith(color: onCard),
                  ),
                  if (detail != null)
                    Text(
                      detail,
                      style: typography.bodySmall.copyWith(color: onCard),
                    ),
                ],
              ),
              SizedBox(height: spacing.sm),
              Text(value, style: typography.display.copyWith(color: onCard)),
              if (parts.isNotEmpty) ...[
                SizedBox(height: spacing.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  spacing: context.touchTargets.gap,
                  children: [
                    for (final part in parts)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              part.label,
                              style: typography.bodySmall.copyWith(
                                color: onCard,
                              ),
                            ),
                            Text(
                              part.value,
                              style: typography.number.copyWith(
                                color: colors.inversePrimary,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

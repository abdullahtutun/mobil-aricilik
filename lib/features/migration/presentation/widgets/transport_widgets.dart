import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/haptics.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';

/// Taşımanın adımı; üstteki çubuk ve ekran buna göre.
enum MoveStep { check, load, unload, done }

/// Okutmanın ya da elle girilen numaranın sonucu.
typedef ScanFeedback = ({AppStatus status, String message});

/// Üstte üç adım (docs/design "Taşıma · yükleme"): biten adım yeşil ve ✓,
/// şu anki koyu bal, sonraki soluk. Anlamı çizginin rengi değil adın
/// yanındaki ✓ ve ekran okuyucudaki "tamam" taşır.
class MoveStepBar extends StatelessWidget {
  const new({required this.step, super.key});

  final MoveStep step;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final steps = [
      (MoveStep.check, l10n.moveStepCheck),
      (MoveStep.load, l10n.moveStepLoad),
      (MoveStep.unload, l10n.moveStepUnload),
    ];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: spacing.sm,
      children: [
        for (final (value, label) in steps)
          Expanded(
            child: Builder(
              builder: (context) {
                final done = value.index < step.index;
                final current = value == step;
                final color = done
                    ? colors.statusGood
                    : current
                    ? colors.primary
                    : colors.textSecondary;
                return Semantics(
                  label: done ? l10n.moveStepDone(label) : label,
                  selected: current,
                  excludeSemantics: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(context.radii.pill),
                        child: ColoredBox(
                          color: done || current ? color : colors.divider,
                          child: SizedBox(
                            height: spacing.xs,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      SizedBox(height: spacing.sm),
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: context.typography.labelSmall.copyWith(
                                color: color,
                              ),
                            ),
                          ),
                          if (done) ...[
                            SizedBox(width: spacing.xs),
                            Icon(
                              Icons.check_rounded,
                              size: context.sizes.iconSmall,
                              color: color,
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }
}

/// Büyük sayaç: "YÜKLENEN 87 / 152", ilerleme çubuğu ve son okunan kovan.
class MoveCountCard extends StatelessWidget {
  const new({
    required this.title,
    required this.count,
    required this.total,
    super.key,
    this.lastNumber,
  });

  final String title;
  final int count;
  final int total;
  final String? lastNumber;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final lastNumber = this.lastNumber;

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          children: [
            SectionLabel(title),
            SizedBox(height: spacing.sm),
            Semantics(
              label: l10n.moveCountLabel(count, total),
              liveRegion: true,
              excludeSemantics: true,
              child: Text.rich(
                TextSpan(
                  children: [
                    TextSpan(text: '$count', style: typography.display),
                    const TextSpan(text: ' '),
                    TextSpan(
                      text: l10n.moveCountTotal(total),
                      style: typography.number.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: spacing.lg),
            ClipRRect(
              borderRadius: BorderRadius.circular(context.radii.pill),
              child: LinearProgressIndicator(
                value: total == 0 ? 0 : (count / total).clamp(0, 1),
                minHeight: spacing.md,
                color: colors.primary,
                backgroundColor: colors.divider,
              ),
            ),
            if (lastNumber != null) ...[
              SizedBox(height: spacing.lg),
              StatusBadge(
                status: AppStatus.good,
                label: l10n.moveLastScanned(lastNumber),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// "65 kovan henüz okunmadı · Listeyi gör"; hepsi okunduysa "Hepsi okundu".
/// Listeyi okunmayan kovanların numaralarıyla alt sayfada açar.
class MoveMissingCard extends StatelessWidget {
  const new({required this.numbers, super.key});

  /// Okunmayan kovanların numaraları, gösterilecek sırayla.
  final List<String> numbers;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    if (numbers.isEmpty) {
      return AppCard(
        status: AppStatus.good,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: StatusMessage(
            status: AppStatus.good,
            message: l10n.moveAllScanned,
          ),
        ),
      );
    }
    return AppCard(
      status: AppStatus.warning,
      onTap: () => showMissingHives(context, l10n.moveMissingTitle, numbers),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.touchTargets.field),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            spacing: spacing.md,
            children: [
              Expanded(
                child: StatusMessage(
                  status: AppStatus.warning,
                  message: l10n.moveNotScanned(numbers.length),
                ),
              ),
              Text(
                l10n.moveShowList,
                style: context.typography.label.copyWith(
                  color: context.colors.statusWarning,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Kovan numaralarını alt sayfada liste olarak açar.
Future<void> showMissingHives(
  BuildContext context,
  String title,
  List<String> numbers,
) {
  final l10n = AppLocalizations.of(context);
  return showOptionSheet<void>(
    context,
    (context) => OptionSheet<void>(
      title: title,
      options: [
        for (final number in numbers)
          SheetOption(
            value: null,
            icon: Icons.hive_outlined,
            iconColor: context.colors.statusWarning,
            label: l10n.hiveLabel(number),
          ),
      ],
    ),
  );
}

/// Araç seçimi: "Kamyon 1 · 72" chip'leri; seçili araca yüklenir.
class MoveVehicleChips extends StatelessWidget {
  const new({
    required this.counts,
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// Araçlar ve yüklü kovan sayıları, sırayla.
  final Map<String, int> counts;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return ChoiceChipGroup<String>(
      options: [
        for (final MapEntry(key: vehicle, value: count) in counts.entries)
          ChoiceChipOption(
            value: vehicle,
            label: l10n.moveVehicleCount(vehicle, count),
          ),
      ],
      selected: {selected},
      // Seçili araca yeniden dokunmak seçimi kaldırmasın.
      onChanged: (values) {
        if (values.isNotEmpty) onSelected(values.single);
      },
    );
  }
}

/// Tek metin alanlı diyalog (araç adı, kovan numarası). Girilen metni,
/// vazgeçilirse null döner. [validate] hata cümlesi dönerse diyalog açık
/// kalır.
Future<String?> showTextEntryDialog(
  BuildContext context, {
  required String title,
  required String label,
  required String confirmLabel,
  String initialValue = '',
  int? maxLength,
  String? Function(String value)? validate,
}) => showDialog<String>(
  context: context,
  builder: (context) => _TextEntryDialog(
    title: title,
    label: label,
    confirmLabel: confirmLabel,
    initialValue: initialValue,
    maxLength: maxLength,
    validate: validate,
  ),
);

class _TextEntryDialog extends StatefulWidget {
  const new({
    required this.title,
    required this.label,
    required this.confirmLabel,
    required this.initialValue,
    required this.maxLength,
    required this.validate,
  });

  final String title;
  final String label;
  final String confirmLabel;
  final String initialValue;
  final int? maxLength;
  final String? Function(String value)? validate;

  @override
  State<_TextEntryDialog> createState() => _TextEntryDialogState();
}

class _TextEntryDialogState extends State<_TextEntryDialog> {
  late final _controller = TextEditingController(text: widget.initialValue)
    ..selection = TextSelection(
      baseOffset: 0,
      extentOffset: widget.initialValue.length,
    );
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final value = _controller.text.trim();
    if (value.isEmpty) return;
    final error = widget.validate?.call(value);
    if (error != null) {
      setState(() => _error = error);
      return;
    }
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: LabeledField(
        label: widget.label,
        child: TextField(
          controller: _controller,
          autofocus: true,
          maxLength: widget.maxLength,
          textInputAction: TextInputAction.done,
          decoration: InputDecoration(errorText: _error),
          onChanged: (_) {
            if (_error != null) setState(() => _error = null);
          },
          onSubmitted: (_) => _submit(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.actionCancel),
        ),
        TextButton(onPressed: _submit, child: Text(widget.confirmLabel)),
      ],
    );
  }
}

/// Kovanı taşımanın adımına göre yükler ya da indirir ve sonucu döner.
/// Başarılı okutmada titreşir. Taşıma yükleme ya da indirme adımında
/// olmalı.
Future<ScanFeedback> applyHiveToTransport(
  WidgetRef ref,
  AppLocalizations l10n, {
  required Transport transport,
  required Hive hive,
  required String vehicle,
}) async {
  final actions = ref.read(transportActionsProvider.notifier);
  final number = hive.number;
  if (transport.status == TransportStatus.loading) {
    final result = await actions.load(
      transport.id,
      hiveId: hive.id,
      vehicle: vehicle,
    );
    switch (result) {
      case LoadResult.loaded:
        unawaited(AppHaptics.scanSuccess());
        return (
          status: AppStatus.good,
          message: l10n.moveScanLoaded(number, vehicle),
        );
      case LoadResult.loadedFromOtherApiary:
        unawaited(AppHaptics.scanSuccess());
        return (
          status: AppStatus.warning,
          message: l10n.moveScanLoadedOther(number),
        );
      case LoadResult.alreadyLoaded:
        return (
          status: AppStatus.info,
          message: l10n.moveScanAlreadyLoaded(number),
        );
    }
  }
  final result = await actions.unload(transport.id, hiveId: hive.id);
  switch (result) {
    case UnloadResult.unloaded:
      unawaited(AppHaptics.scanSuccess());
      return (status: AppStatus.good, message: l10n.moveScanUnloaded(number));
    case UnloadResult.alreadyUnloaded:
      return (
        status: AppStatus.info,
        message: l10n.moveScanAlreadyUnloaded(number),
      );
    case UnloadResult.notLoaded:
      return (
        status: AppStatus.warning,
        message: l10n.moveScanNotLoaded(number),
      );
  }
}

/// Yüklemede seçili araç: seçim yoksa ya da araç artık taşımada değilse
/// ilk araç.
String selectedVehicle(WidgetRef ref, Transport transport) {
  final selected = ref.watch(transportVehicleProvider(transport.id));
  return selected != null && transport.vehicles.contains(selected)
      ? selected
      : transport.vehicles.first;
}

import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';

/// Lota analiz ekleme: analiz günü, HMF, diastaz, prolin, nem, kalıntı ve
/// belge kasasındaki rapor (tür "Analiz raporu"). En az bir sonuç girilince
/// kaydedilir; lota dönülür ve 6 sn geri alınabilir.
class LabResultFormScreen extends ConsumerWidget {
  const new({required this.lotId, super.key});

  final String lotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(lotSummaryProvider(lotId))) {
      AsyncData(value: final summary?) => _LabResultForm(summary.lot),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.lotNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.lotsLoadError)),
      ),
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

/// Bir analiz değeri: ad, alan ve sınırı.
typedef _Measure = ({
  String label,
  TextEditingController controller,
  double min,
  double max,
});

class _LabResultForm extends ConsumerStatefulWidget {
  const new(this.lot);

  final Lot lot;

  @override
  ConsumerState<_LabResultForm> createState() => _LabResultFormState();
}

class _LabResultFormState extends ConsumerState<_LabResultForm> {
  final _hmf = TextEditingController();
  final _diastase = TextEditingController();
  final _proline = TextEditingController();
  final _moisture = TextEditingController();
  late DateTime _testedOn = DateUtils.dateOnly(clock.now());
  ResidueResult? _residue;
  String? _documentId;
  var _busy = false;

  @override
  void dispose() {
    for (final controller in [_hmf, _diastase, _proline, _moisture]) {
      controller.dispose();
    }
    super.dispose();
  }

  List<_Measure> _measures(AppLocalizations l10n) => [
    (label: l10n.labHmf, controller: _hmf, min: 0, max: maxLabHmf),
    (
      label: l10n.labDiastase,
      controller: _diastase,
      min: 0,
      max: maxLabDiastase,
    ),
    (label: l10n.labProline, controller: _proline, min: 0, max: maxLabProline),
    (
      label: l10n.lotMoisture,
      controller: _moisture,
      min: minLotMoisture,
      max: maxLotMoisture,
    ),
  ];

  double? _value(_Measure measure) => parseLotDecimal(
    measure.controller.text,
    min: measure.min,
    max: measure.max,
  );

  bool _invalid(_Measure measure) =>
      measure.controller.text.trim().isNotEmpty && _value(measure) == null;

  Future<void> _save(List<_Measure> measures) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(lotActionsProvider.notifier);
    setState(() => _busy = true);
    try {
      final result = await actions.addLabResult(widget.lot, (
        testedOn: _testedOn,
        hmf: _value(measures[0]),
        diastase: _value(measures[1]),
        proline: _value(measures[2]),
        moisture: _value(measures[3]),
        residue: _residue,
        documentId: _documentId,
      ));
      if (!mounted) return;
      showUndoSnackBar(
        context,
        message: l10n.labSaved,
        onUndo: () => unawaited(actions.undoLabResult(result)),
      );
      context.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _pickDate() async {
    final today = DateUtils.dateOnly(clock.now());
    final day = await showDatePicker(
      context: context,
      initialDate: _testedOn,
      firstDate: DateTime(today.year - 2),
      lastDate: today,
    );
    if (day != null) setState(() => _testedOn = day);
  }

  Future<void> _pickReport() async {
    final l10n = AppLocalizations.of(context);
    final reports = await ref.read(analysisReportsProvider.future);
    if (!mounted) return;
    final picked = await showOptionSheet<String>(
      context,
      (context) => OptionSheet<String>(
        title: l10n.labReport,
        emptyMessage: l10n.labReportEmpty,
        options: [
          if (reports.isNotEmpty)
            SheetOption(
              value: '',
              icon: Icons.block_rounded,
              label: l10n.labReportNone,
              selected: _documentId == null,
            ),
          for (final document in reports)
            SheetOption(
              value: document.id,
              icon: Icons.description_outlined,
              label: document.name,
              selected: _documentId == document.id,
            ),
        ],
      ),
    );
    if (picked != null) {
      setState(() => _documentId = picked.isEmpty ? null : picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final measures = _measures(l10n);
    final reports = ref.watch(analysisReportsProvider).value ?? const [];
    final report = reports.where((d) => d.id == _documentId).firstOrNull;
    final anyInvalid = measures.any(_invalid);
    final anyValue = _residue != null || measures.any((m) => _value(m) != null);

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.labTitle(widget.lot.number(l10n))),
      ),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            ListGroup(
              children: [
                ListRow(
                  title: l10n.labDate,
                  value: AppFormat.of(context).date(_testedOn),
                  onTap: _busy ? null : () => unawaited(_pickDate()),
                ),
              ],
            ),
            for (final measure in measures) ...[
              SizedBox(height: spacing.lg),
              LabeledField(
                label: measure.label,
                child: TextField(
                  controller: measure.controller,
                  enabled: !_busy,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                  ],
                  textInputAction: TextInputAction.next,
                  style: context.typography.number,
                  onChanged: (_) => setState(() {}),
                ),
              ),
              if (_invalid(measure)) ...[
                SizedBox(height: spacing.sm),
                StatusMessage(
                  status: AppStatus.warning,
                  message: l10n.labValueInvalid(
                    AppFormat.of(context).number(measure.min),
                    AppFormat.of(context).number(measure.max),
                  ),
                ),
              ],
            ],
            SizedBox(height: spacing.xl),
            LabeledField(
              label: l10n.labResidue,
              group: true,
              child: ChoiceChipGroup<ResidueResult>(
                options: [
                  for (final residue in ResidueResult.values)
                    ChoiceChipOption(
                      value: residue,
                      label: residue.label(l10n),
                    ),
                ],
                selected: {?_residue},
                onChanged: (selected) =>
                    setState(() => _residue = selected.firstOrNull),
              ),
            ),
            SizedBox(height: spacing.xl),
            ListGroup(
              children: [
                ListRow(
                  title: l10n.labReport,
                  value: report?.name ?? l10n.labReportNone,
                  onTap: _busy ? null : () => unawaited(_pickReport()),
                ),
              ],
            ),
            if (reports.isEmpty) ...[
              SizedBox(height: spacing.md),
              BigButton(
                label: l10n.labReportAdd,
                icon: Icons.upload_file_outlined,
                variant: BigButtonVariant.secondary,
                onPressed: () => context.go(AppRoutes.documentNew),
              ),
            ],
          ],
        ),
        action: BigButton(
          label: l10n.labSave,
          onPressed: anyValue && !anyInvalid && !_busy
              ? () => unawaited(_save(measures))
              : null,
        ),
      ),
    );
  }
}

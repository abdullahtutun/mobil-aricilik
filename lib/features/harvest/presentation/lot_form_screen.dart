import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_fields.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';

/// Lotu düzenleme: yöre, nem ve durum (açık lota hasat eklenir, kapalıya
/// eklenmez); altta lotu silme (onaylı; hasatlar kalır).
class LotFormScreen extends ConsumerWidget {
  const new({required this.lotId, super.key});

  final String lotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return switch (ref.watch(lotSummaryProvider(lotId))) {
      AsyncData(value: final summary?) => _LotForm(summary.lot),
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

class _LotForm extends ConsumerStatefulWidget {
  const new(this.lot);

  final Lot lot;

  @override
  ConsumerState<_LotForm> createState() => _LotFormState();
}

class _LotFormState extends ConsumerState<_LotForm> {
  late final _origin = TextEditingController(text: widget.lot.origin);
  late final _moisture = TextEditingController(
    text: switch (widget.lot.moisture) {
      final value? => value.toString().replaceAll('.', ','),
      null => '',
    },
  );
  late LotStatus _status = widget.lot.status;
  var _busy = false;

  @override
  void dispose() {
    _origin.dispose();
    _moisture.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      await ref
          .read(lotActionsProvider.notifier)
          .update(
            widget.lot.copyWith(
              origin: _origin.text,
              moisture: parseLotMoisture(_moisture.text),
              status: _status,
            ),
          );
      if (mounted) context.pop();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.lotDeleteTitle(widget.lot.number(l10n)),
      message: l10n.lotDeleteMessage,
      confirmLabel: l10n.lotDelete,
    );
    if (!confirmed || !mounted) return;
    await ref.read(lotActionsProvider.notifier).remove(widget.lot.id);
    if (!mounted) return;
    showMessageSnackBar(context, l10n.lotDeleted);
    context.go(AppRoutes.lots);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final valid = LotFields.moistureValid(_moisture.text);

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.lotEditTitle(widget.lot.number(l10n))),
      ),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text(
              [
                widget.lot.title(l10n),
                AppFormat.of(context).number(widget.lot.year),
              ].join(l10n.titleSeparator),
              style: context.typography.subtitle,
            ),
            SizedBox(height: spacing.lg),
            LotFields(
              origin: _origin,
              moisture: _moisture,
              enabled: !_busy,
              onChanged: () => setState(() {}),
            ),
            SizedBox(height: spacing.xl),
            LabeledField(
              label: l10n.lotStatus,
              helper: l10n.lotStatusHelper,
              group: true,
              child: SegmentedTabs<LotStatus>(
                expanded: true,
                options: [
                  for (final status in LotStatus.values)
                    SegmentOption(value: status, label: status.label(l10n)),
                ],
                selected: _status,
                onChanged: (status) => setState(() => _status = status),
              ),
            ),
            SizedBox(height: spacing.xl),
            BigButton(
              label: l10n.lotDelete,
              icon: Icons.delete_outline_rounded,
              variant: BigButtonVariant.secondary,
              onPressed: _busy ? null : () => unawaited(_delete()),
            ),
          ],
        ),
        action: BigButton(
          label: l10n.lotSave,
          onPressed: valid && !_busy ? () => unawaited(_save()) : null,
        ),
      ),
    );
  }
}

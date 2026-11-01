import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/harvest_labels.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_fields.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';

/// Kaydedilen hasadı lota ekleme adımı: "Yeni lot" (yöre arılığın adıyla
/// gelir, nem isteğe bağlı) ya da açık bir lot. Lot numarası hasadın
/// yılında sıradaki; o kovanların son ilaçlamaları lota kendiliğinden
/// bağlanır. "Şimdilik geç" lotsuz bırakır. Bitince arılığa dönülür.
/// Hasat bu arada geri alınırsa arılığa dönülür.
class HarvestLotScreen extends ConsumerWidget {
  const new({required this.apiaryId, required this.harvestId, super.key});

  final String apiaryId;
  final String harvestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final apiaryName = ref
        .watch(apiarySummaryProvider(apiaryId))
        .value
        ?.apiary
        .name;

    return switch (ref.watch(harvestProvider(harvestId))) {
      AsyncData(value: final harvest?) => _LotStep(
        apiaryId: apiaryId,
        harvest: harvest,
        defaultOrigin: apiaryName,
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: EmptyState(
          icon: Icons.undo_rounded,
          title: l10n.harvestLotGone,
          message: l10n.harvestLotGoneMessage,
          actionLabel: l10n.harvestLotBack,
          onAction: () => context.go(AppRoutes.apiary(apiaryId)),
          centered: true,
        ),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.lotsLoadError)),
      ),
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _LotStep extends ConsumerStatefulWidget {
  const new({
    required this.apiaryId,
    required this.harvest,
    required this.defaultOrigin,
  });

  final String apiaryId;
  final Harvest harvest;
  final String? defaultOrigin;

  @override
  ConsumerState<_LotStep> createState() => _LotStepState();
}

class _LotStepState extends ConsumerState<_LotStep> {
  late final _origin = TextEditingController(text: widget.defaultOrigin);
  final _moisture = TextEditingController();

  /// Seçili açık lot; null ise yeni lot.
  String? _lotId;
  var _busy = false;

  @override
  void dispose() {
    _origin.dispose();
    _moisture.dispose();
    super.dispose();
  }

  void _done() => context.go(AppRoutes.apiary(widget.apiaryId));

  Future<void> _save(List<Lot> openLots) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(lotActionsProvider.notifier);
    setState(() => _busy = true);
    try {
      final chosen = openLots.where((lot) => lot.id == _lotId).firstOrNull;
      final String message;
      if (chosen == null) {
        final lot = await actions.createWithHarvest(
          widget.harvest,
          origin: _origin.text,
          moisture: parseLotMoisture(_moisture.text),
        );
        message = l10n.harvestLotCreated(lot.number(l10n));
      } else {
        await actions.attachHarvest(chosen, widget.harvest);
        message = l10n.harvestLotAdded(chosen.number(l10n));
      }
      if (!mounted) return;
      showMessageSnackBar(context, message);
      _done();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final harvest = widget.harvest;
    final openLots = ref.watch(openLotsProvider).value ?? const <Lot>[];
    // Seçili lot bu arada kapandıysa yeni lota dönülür.
    final selected = openLots.any((lot) => lot.id == _lotId) ? _lotId : null;
    final creating = selected == null;
    final valid = !creating || LotFields.moistureValid(_moisture.text);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(l10n.harvestLotTitle),
      ),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            NoteCard(
              icon: Icons.check_circle_outline_rounded,
              title: l10n.harvestLotSaved(
                lotWeight(ref, context, harvest.netKg),
                harvest.honeyKind.label(l10n),
              ),
              message: l10n.harvestLotIntro,
            ),
            SizedBox(height: spacing.xl),
            RadioCardGroup<String>(
              options: [
                RadioCardOption(
                  value: '',
                  label: l10n.harvestLotNew,
                  hint: l10n.harvestLotNewHint(harvest.honeyKind.label(l10n)),
                ),
                for (final lot in openLots)
                  RadioCardOption(
                    value: lot.id,
                    label: lot.subtitle(l10n),
                    hint: lot.title(l10n),
                  ),
              ],
              selected: selected ?? '',
              onChanged: _busy
                  ? (_) {}
                  : (value) =>
                        setState(() => _lotId = value.isEmpty ? null : value),
            ),
            if (creating) ...[
              SizedBox(height: spacing.xl),
              LotFields(
                origin: _origin,
                moisture: _moisture,
                enabled: !_busy,
                onChanged: () => setState(() {}),
              ),
            ],
            SizedBox(height: spacing.xl),
            BigButton(
              label: l10n.harvestLotSkip,
              variant: BigButtonVariant.secondary,
              onPressed: _busy ? null : _done,
            ),
          ],
        ),
        action: BigButton(
          label: creating ? l10n.harvestLotCreate : l10n.harvestLotAdd,
          onPressed: valid && !_busy ? () => unawaited(_save(openLots)) : null,
        ),
      ),
    );
  }
}

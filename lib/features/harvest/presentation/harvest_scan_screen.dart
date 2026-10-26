import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/code_scanner_provider.dart';
import 'package:mobil_arici/core/utils/haptics.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_controller.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_form_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_hives_screen.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_providers.dart';
import 'package:mobil_arici/features/hives/presentation/hive_label_providers.dart';

/// Hasada okut: kamera açık kalır, okutulan her kovan seçime eklenir ve
/// altta sonucu yazar (eklendi, zaten seçili, bu arılıkta değil, aktif
/// değil, tanınmayan etiket). Bekleme süresindeki kovanda kilit diyaloğu
/// açılır; gerekçeyle eklenir. Kamera aynı kodu art arda verir; aynı kod
/// yeniden işlenmez. "Bitti" forma döner.
class HarvestScanScreen extends ConsumerStatefulWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  ConsumerState<HarvestScanScreen> createState() => _HarvestScanScreenState();
}

class _HarvestScanScreenState extends ConsumerState<HarvestScanScreen> {
  /// Son işlenen kod; kamera onu tekrar verince yok sayılır.
  String? _lastCode;
  var _busy = false;

  /// Son okutmanın sonucu.
  ({AppStatus status, String message})? _result;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final form = ref.watch(harvestFormControllerProvider(widget.apiaryId));
    final result = _result;
    final count = switch (form) {
      AsyncData(value: final form) => watchHarvestTargets(
        ref,
        widget.apiaryId,
        form,
      ).harvested.length,
      _ => 0,
    };

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.harvestScanTitle),
      ),
      body: BottomActionLayout(
        separated: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(child: ref.watch(codeScannerProvider)(_handle)),
            Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: result == null
                  ? Text(
                      l10n.scanHint,
                      textAlign: TextAlign.center,
                      style: context.typography.body,
                    )
                  : StatusMessage(
                      status: result.status,
                      message: result.message,
                    ),
            ),
          ],
        ),
        action: BigButton(
          label: l10n.harvestScanDone(count),
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  Future<void> _handle(String code) async {
    if (_busy || code == _lastCode) return;
    _busy = true;
    _lastCode = code;
    try {
      final l10n = AppLocalizations.of(context);
      final hive = await ref.read(hiveLabelActionsProvider.notifier).find(code);
      if (!mounted) return;
      if (hive == null) {
        return _show(AppStatus.warning, l10n.harvestScanUnknown);
      }
      final provider = harvestFormControllerProvider(widget.apiaryId);
      final form = ref.read(provider).value;
      if (form == null) return;
      final locks = await ref.read(
        harvestLocksProvider(widget.apiaryId, form.day).future,
      );
      if (!mounted) return;
      switch (ref
          .read(provider.notifier)
          .addScanned(hive, lock: locks[hive.id])) {
        case HarvestScanResult.added:
          unawaited(AppHaptics.scanSuccess());
          _show(AppStatus.good, l10n.harvestScanAdded(hive.number));
        case HarvestScanResult.alreadySelected:
          _show(AppStatus.info, l10n.harvestScanAlready(hive.number));
        case HarvestScanResult.otherApiary:
          _show(AppStatus.warning, l10n.harvestScanOtherApiary(hive.number));
        case HarvestScanResult.inactive:
          _show(AppStatus.warning, l10n.harvestScanInactive(hive.number));
        case HarvestScanResult.locked:
          final added = await selectForHarvest(
            context,
            ref,
            apiaryId: widget.apiaryId,
            hive: hive,
          );
          if (added && mounted) {
            _show(AppStatus.good, l10n.harvestScanAdded(hive.number));
          }
      }
    } finally {
      _busy = false;
    }
  }

  void _show(AppStatus status, String message) =>
      setState(() => _result = (status: status, message: message));
}

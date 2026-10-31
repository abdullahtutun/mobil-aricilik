import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/code_scanner_provider.dart';
import 'package:mobil_arici/core/services/screen_awake.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_label_providers.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/migration/presentation/widgets/transport_widgets.dart';

/// Taşımanın sürekli okutması: kamera açık kalır, kovanlar ard arda
/// okutulur; her kovan için ekran kapanıp açılmaz. Her başarılı okutmada
/// titreşir ve büyük sayaç artar. Yüklemede seçili araca yüklenir (araç
/// burada da değişir), indirmede yüklenen kovan indirilir. Kamera aynı
/// kodu art arda verir; aynı kod yeniden işlenmez. Ekran açıkken
/// kararmaz. İnternet gerekmez. "Bitti" taşıma ekranına döner.
class TransportScanScreen extends ConsumerStatefulWidget {
  const new({required this.transportId, super.key});

  final String transportId;

  @override
  ConsumerState<TransportScanScreen> createState() =>
      _TransportScanScreenState();
}

class _TransportScanScreenState extends ConsumerState<TransportScanScreen> {
  late final ScreenAwake _awake;

  /// Son işlenen kod; kamera onu tekrar verince yok sayılır.
  String? _lastCode;
  var _busy = false;
  ScanFeedback? _result;

  @override
  void initState() {
    super.initState();
    _awake = ref.read(screenAwakeProvider);
    unawaited(_awake.keepOn(enabled: true));
  }

  @override
  void dispose() {
    unawaited(_awake.keepOn(enabled: false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final transport = ref.watch(transportProvider(widget.transportId)).value;

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(
          transport?.status == TransportStatus.unloading
              ? l10n.moveStepUnload
              : l10n.moveStepLoad,
        ),
      ),
      body: BottomActionLayout(
        separated: true,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(flex: 3, child: ref.watch(codeScannerProvider)(_handle)),
            if (transport != null)
              Flexible(
                flex: 2,
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(context.spacing.lg),
                  child: _Panel(transport: transport, result: _result),
                ),
              ),
          ],
        ),
        action: BigButton(
          label: l10n.moveScanDone,
          onPressed: () => context.pop(),
        ),
      ),
    );
  }

  Future<void> _handle(String code) async {
    if (_busy || code == _lastCode) return;
    final transport = ref.read(transportProvider(widget.transportId)).value;
    if (transport == null || transport.status == TransportStatus.completed) {
      return;
    }
    _busy = true;
    _lastCode = code;
    try {
      final l10n = AppLocalizations.of(context);
      final hive = await ref.read(hiveLabelActionsProvider.notifier).find(code);
      if (!mounted) return;
      if (hive == null) {
        return _show((
          status: AppStatus.warning,
          message: l10n.moveScanUnknown,
        ));
      }
      final feedback = await applyHiveToTransport(
        ref,
        l10n,
        transport: transport,
        hive: hive,
        vehicle: selectedVehicle(ref, transport),
      );
      if (mounted) _show(feedback);
    } finally {
      _busy = false;
    }
  }

  void _show(ScanFeedback feedback) => setState(() => _result = feedback);
}

/// Kameranın altı: yüklemede araç chip'leri, büyük sayaç ve son okutmanın
/// sonucu.
class _Panel extends ConsumerWidget {
  const new({required this.transport, required this.result});

  final Transport transport;
  final ScanFeedback? result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final unloading = transport.status == TransportStatus.unloading;
    final items =
        ref.watch(transportItemsProvider(transport.id)).value ??
        const <TransportItem>[];
    final sourceHives =
        ref.watch(apiaryHivesProvider(transport.sourceApiaryId)).value ??
        const <Hive>[];
    final count = unloading
        ? items.length - itemsNotUnloaded(items).length
        : items.length;
    final total = unloading
        ? items.length
        : expectedLoadCount(sourceHives, items);
    final result = this.result;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!unloading) ...[
          MoveVehicleChips(
            counts: loadedPerVehicle(transport, items),
            selected: selectedVehicle(ref, transport),
            onSelected: (value) =>
                ref
                        .read(transportVehicleProvider(transport.id).notifier)
                        .vehicle =
                    value,
          ),
          SizedBox(height: spacing.md),
        ],
        Semantics(
          label: l10n.moveCountLabel(count, total),
          excludeSemantics: true,
          child: Text.rich(
            TextSpan(
              children: [
                TextSpan(text: '$count', style: context.typography.display),
                const TextSpan(text: ' '),
                TextSpan(
                  text: l10n.moveCountTotal(total),
                  style: context.typography.number.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(height: spacing.md),
        if (result == null)
          Text(
            l10n.scanHint,
            textAlign: TextAlign.center,
            style: context.typography.body,
          )
        else
          StatusMessage(status: result.status, message: result.message),
      ],
    );
  }
}

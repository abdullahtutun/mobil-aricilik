import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';
import 'package:mobil_arici/features/migration/domain/transport.dart';
import 'package:mobil_arici/features/migration/domain/transport_rules.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/migration/presentation/widgets/transport_widgets.dart';

/// Planın sıradaki taşıması (docs/design "Taşıma · yükleme"); başlıkta
/// nereden nereye. Adımlar: kontrol listesi → kovanları okutarak araçlara
/// yükleme → hedefte yeniden okutarak indirme. İndirme bitince indirilen
/// kovanlar hedef arılığa taşınır ve eksik kovanlar listede kalır. Hepsi
/// yerel DB'de; yol boyunca internet gerekmez. Planlı durak kalmadıysa
/// bunu söyler.
class MoveScreen extends ConsumerWidget {
  const new({required this.migrationId, super.key});

  final String migrationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(migrationStopsProvider(migrationId))) {
      AsyncData(value: final stops) => switch (nextMove(stops)) {
        (:final from, :final to) => Scaffold(
          appBar: AppBar(
            title: Text(
              l10n.moveTitle(
                from == null
                    ? to.name
                    : l10n.migrationRoute(from.name, to.name),
              ),
            ),
          ),
          body: _MoveBody(migrationId: migrationId, from: from, to: to),
        ),
        null => Scaffold(
          appBar: AppBar(),
          body: Center(child: Text(l10n.moveNone)),
        ),
      },
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.migrationsLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

/// Durağın taşımasının adımı: taşıma yoksa kontrol listesi, varsa yükleme,
/// indirme ya da özet.
class _MoveBody extends ConsumerWidget {
  const new({required this.migrationId, required this.from, required this.to});

  final String migrationId;
  final MigrationStop? from;
  final MigrationStop to;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return switch (ref.watch(stopTransportProvider(to.id))) {
      AsyncData(value: final transport?) => switch (transport.status) {
        TransportStatus.loading || TransportStatus.unloading => _ScanStep(
          migrationId: migrationId,
          transport: transport,
        ),
        TransportStatus.completed => _DoneStep(transport),
      },
      AsyncData() => switch (to.apiaryId) {
        final destination? => _ChecklistStep(
          stopId: to.id,
          sourceApiaryId: from?.apiaryId == destination ? null : from?.apiaryId,
          destinationApiaryId: destination,
        ),
        null => EmptyState(
          icon: Icons.local_shipping_outlined,
          title: l10n.moveNoDestinationTitle,
          message: l10n.moveNoDestinationMessage,
          actionLabel: l10n.moveEditStop,
          onAction: () =>
              context.go(AppRoutes.migrationStopEdit(migrationId, to.id)),
          centered: true,
        ),
      },
      AsyncError() => Center(child: Text(l10n.migrationsLoadError)),
      AsyncValue() => const SizedBox.shrink(),
    };
  }
}

/// Arılık kimliğinden ada.
Map<String, String> _apiaryNames(WidgetRef ref) => {
  for (final summary
      in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
    summary.apiary.id: summary.apiary.name,
};

/// Kontrol listesi: nereden, nereye, listedeki her madde ve araçlar.
/// Hepsi işaretlenince taşıma yükleme adımında başlar. Kaynak arılık
/// planın önceki durağından gelir; yoksa seçilir.
class _ChecklistStep extends ConsumerStatefulWidget {
  const new({
    required this.stopId,
    required this.sourceApiaryId,
    required this.destinationApiaryId,
  });

  final String stopId;
  final String? sourceApiaryId;
  final String destinationApiaryId;

  @override
  ConsumerState<_ChecklistStep> createState() => _ChecklistStepState();
}

class _ChecklistStepState extends ConsumerState<_ChecklistStep> {
  final _checked = <TransportCheck>{};
  late String? _sourceApiaryId = widget.sourceApiaryId;
  List<String>? _vehicles;
  var _starting = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    // Varsayılan ad dil değişince de güncel kalsın; listeye dokununca
    // sabitlenir.
    final vehicles = _vehicles ?? [l10n.moveVehicleDefault(1)];
    final summaries =
        ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[];
    final names = _apiaryNames(ref);
    final source = _sourceApiaryId;
    final activeHives = {
      for (final summary in summaries)
        summary.apiary.id: summary.activeHiveCount,
    };
    final ready =
        source != null && _checked.length == TransportCheck.values.length;
    final sectionGap = SizedBox(height: spacing.xl);
    final labelGap = SizedBox(height: spacing.sm);

    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          const MoveStepBar(step: MoveStep.check),
          sectionGap,
          if (widget.sourceApiaryId == null)
            LabeledField(
              label: l10n.moveFrom,
              group: true,
              helper: source == null
                  ? null
                  : l10n.moveSourceHives(activeHives[source] ?? 0),
              child: ChoiceChipGroup<String>(
                options: [
                  for (final summary in summaries)
                    if (summary.apiary.id != widget.destinationApiaryId)
                      ChoiceChipOption(
                        value: summary.apiary.id,
                        label: summary.apiary.name,
                      ),
                ],
                selected: {?source},
                onChanged: (values) => setState(
                  () => _sourceApiaryId = values.isEmpty ? null : values.single,
                ),
              ),
            ),
          if (widget.sourceApiaryId == null) labelGap,
          ListGroup(
            children: [
              if (widget.sourceApiaryId case final fixed?)
                ListRow(
                  title: l10n.moveFrom,
                  subtitle: l10n.moveSourceHives(activeHives[fixed] ?? 0),
                  value: names[fixed] ?? '',
                ),
              ListRow(
                title: l10n.moveTo,
                value: names[widget.destinationApiaryId] ?? '',
              ),
            ],
          ),
          sectionGap,
          SectionLabel(l10n.moveChecklist),
          labelGap,
          ListGroup(
            children: [
              for (final check in TransportCheck.values)
                CheckboxListTile(
                  value: _checked.contains(check),
                  onChanged: (value) => setState(
                    () => value ?? false
                        ? _checked.add(check)
                        : _checked.remove(check),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.symmetric(horizontal: spacing.md),
                  title: Text(
                    _checkLabel(l10n, check),
                    style: context.typography.label,
                  ),
                ),
            ],
          ),
          sectionGap,
          SectionLabel(l10n.moveVehicles),
          labelGap,
          ListGroup(
            children: [
              for (final vehicle in vehicles)
                ListRow(
                  title: vehicle,
                  trailing: vehicles.length > 1
                      ? IconButton(
                          tooltip: l10n.moveRemoveVehicle(vehicle),
                          onPressed: () => setState(
                            () => _vehicles = [...vehicles]..remove(vehicle),
                          ),
                          icon: const Icon(Icons.remove_circle_outline_rounded),
                        )
                      : null,
                ),
            ],
          ),
          labelGap,
          BigButton(
            label: l10n.moveAddVehicle,
            icon: Icons.add_rounded,
            variant: BigButtonVariant.secondary,
            onPressed: () => _addVehicle(vehicles),
          ),
          if (!ready) ...[
            sectionGap,
            Text(
              l10n.moveChecklistHint,
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
        ],
      ),
      action: BigButton(
        label: l10n.moveStartLoading,
        onPressed: ready && !_starting ? () => _start(source, vehicles) : null,
      ),
    );
  }

  Future<void> _addVehicle(List<String> vehicles) async {
    final l10n = AppLocalizations.of(context);
    final name = await showTextEntryDialog(
      context,
      title: l10n.moveAddVehicle,
      label: l10n.moveVehicleName,
      confirmLabel: l10n.moveAddVehicle,
      initialValue: l10n.moveVehicleDefault(vehicles.length + 1),
      maxLength: maxVehicleNameLength,
      validate: (value) =>
          vehicles.contains(value) ? l10n.moveVehicleExists : null,
    );
    if (name != null && mounted) {
      setState(() => _vehicles = [...vehicles, name]);
    }
  }

  Future<void> _start(String sourceApiaryId, List<String> vehicles) async {
    setState(() => _starting = true);
    try {
      await ref
          .read(transportActionsProvider.notifier)
          .start(
            migrationStopId: widget.stopId,
            sourceApiaryId: sourceApiaryId,
            destinationApiaryId: widget.destinationApiaryId,
            vehicles: vehicles,
          );
    } finally {
      if (mounted) setState(() => _starting = false);
    }
  }

  static String _checkLabel(AppLocalizations l10n, TransportCheck check) =>
      switch (check) {
        TransportCheck.entrancesClosed => l10n.moveCheckEntrances,
        TransportCheck.ventilation => l10n.moveCheckVentilation,
        TransportCheck.straps => l10n.moveCheckStraps,
        TransportCheck.water => l10n.moveCheckWater,
      };
}

/// Yükleme ya da indirme: büyük sayaç, okunmayan kovanlar, numara girme ve
/// sürekli okutma. Yüklemede araç seçilir; indirmede sayaç yüklenenler
/// üzerinden.
class _ScanStep extends ConsumerStatefulWidget {
  const new({required this.migrationId, required this.transport});

  final String migrationId;
  final Transport transport;

  @override
  ConsumerState<_ScanStep> createState() => _ScanStepState();
}

class _ScanStepState extends ConsumerState<_ScanStep> {
  /// Elle girilen son numaranın sonucu; sayacın altında yazar.
  ScanFeedback? _feedback;

  String get migrationId => widget.migrationId;
  Transport get transport => widget.transport;
  bool get _unloading => transport.status == TransportStatus.unloading;

  @override
  void didUpdateWidget(_ScanStep oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Adım değişince önceki adımın sonucu kalmasın.
    if (oldWidget.transport.status != transport.status) _feedback = null;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final items =
        ref.watch(transportItemsProvider(transport.id)).value ??
        const <TransportItem>[];
    final hives = {
      for (final hive
          in ref.watch(organizationHivesProvider).value ?? const <Hive>[])
        hive.id: hive,
    };
    final sourceHives =
        ref.watch(apiaryHivesProvider(transport.sourceApiaryId)).value ??
        const <Hive>[];
    final names = _apiaryNames(ref);
    String number(String hiveId) => hives[hiveId]?.number ?? '';

    final int count;
    final int total;
    final List<String> missing;
    if (_unloading) {
      final notUnloaded = itemsNotUnloaded(items);
      count = items.length - notUnloaded.length;
      total = items.length;
      missing = [for (final item in notUnloaded) number(item.hiveId)];
    } else {
      final notLoaded = hivesNotLoaded(sourceHives, items);
      count = items.length;
      total = items.length + notLoaded.length;
      missing = [for (final hive in notLoaded) hive.number];
    }
    final last = lastScanned(items, unloading: _unloading);
    final vehicle = selectedVehicle(ref, transport);
    final sectionGap = SizedBox(height: spacing.xl);

    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          MoveStepBar(step: _unloading ? MoveStep.unload : MoveStep.load),
          sectionGap,
          if (!_unloading) ...[
            MoveVehicleChips(
              counts: loadedPerVehicle(transport, items),
              selected: vehicle,
              onSelected: (value) =>
                  ref
                          .read(transportVehicleProvider(transport.id).notifier)
                          .vehicle =
                      value,
            ),
            SizedBox(height: spacing.sm),
            Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => _addVehicle(context, ref),
                icon: const Icon(Icons.add_rounded),
                label: Text(l10n.moveAddVehicle),
              ),
            ),
            SizedBox(height: spacing.md),
          ],
          MoveCountCard(
            title: _unloading ? l10n.moveUnloaded : l10n.moveLoaded,
            count: count,
            total: total,
            lastNumber: last == null ? null : number(last.hiveId),
          ),
          if (_feedback case final feedback?) ...[
            SizedBox(height: spacing.lg),
            StatusMessage(status: feedback.status, message: feedback.message),
          ],
          SizedBox(height: spacing.lg),
          MoveMissingCard(numbers: missing),
          SizedBox(height: spacing.lg),
          Text(
            _unloading
                ? l10n.moveUnloadingHint(
                    names[transport.destinationApiaryId] ?? '',
                  )
                : l10n.moveLoadingHint,
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          sectionGap,
          BigButton(
            label: _unloading ? l10n.moveFinish : l10n.moveToUnloading,
            variant: BigButtonVariant.secondary,
            // Boş taşıma indirilmez; yüklemeye bir kovan gerekir.
            onPressed: items.isEmpty
                ? null
                : () => _unloading
                      ? _finish(context, ref, missing.length, names)
                      : _toUnloading(context, ref, missing.length),
          ),
        ],
      ),
      // Numara gir yazısı kadar, en çok genişliğin %45'i; büyük yazıda iki
      // satıra sarar. Okutma birincil, kalan genişlikte.
      action: LayoutBuilder(
        builder: (context, constraints) => Row(
          spacing: context.touchTargets.gap,
          children: [
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: constraints.maxWidth * 0.45,
              ),
              child: BigButton(
                label: l10n.moveEnterNumber,
                variant: BigButtonVariant.secondary,
                expanded: false,
                onPressed: () => _enterNumber(
                  context,
                  ref,
                  candidates: _unloading
                      ? [for (final item in items) ?hives[item.hiveId]]
                      : sourceHives,
                  vehicle: vehicle,
                ),
              ),
            ),
            Expanded(
              child: BigButton(
                label: count == 0 ? l10n.moveScanStart : l10n.moveScanContinue,
                icon: Icons.qr_code_scanner_rounded,
                onPressed: () => context.go(
                  AppRoutes.migrationMoveScan(migrationId, transport.id),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addVehicle(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final name = await showTextEntryDialog(
      context,
      title: l10n.moveAddVehicle,
      label: l10n.moveVehicleName,
      confirmLabel: l10n.moveAddVehicle,
      initialValue: l10n.moveVehicleDefault(transport.vehicles.length + 1),
      maxLength: maxVehicleNameLength,
      validate: (value) =>
          transport.vehicles.contains(value) ? l10n.moveVehicleExists : null,
    );
    if (name == null) return;
    await ref
        .read(transportActionsProvider.notifier)
        .addVehicle(transport.id, name);
    ref.read(transportVehicleProvider(transport.id).notifier).vehicle = name;
  }

  /// Etiketi okunamayan kovan numarasıyla: yüklemede kaynak arılığın,
  /// indirmede yüklenen kovanların içinde aranır.
  Future<void> _enterNumber(
    BuildContext context,
    WidgetRef ref, {
    required List<Hive> candidates,
    required String vehicle,
  }) async {
    final l10n = AppLocalizations.of(context);
    final number = await showTextEntryDialog(
      context,
      title: l10n.moveEnterNumber,
      label: l10n.moveHiveNumber,
      confirmLabel: _unloading ? l10n.moveStepUnload : l10n.moveStepLoad,
    );
    if (number == null || !context.mounted) return;
    final hive = hiveByNumber(candidates, number);
    if (hive == null) {
      setState(
        () => _feedback = (
          status: AppStatus.warning,
          message: l10n.moveNumberNotFound(number),
        ),
      );
      return;
    }
    final feedback = await applyHiveToTransport(
      ref,
      l10n,
      transport: transport,
      hive: hive,
      vehicle: vehicle,
    );
    if (mounted) setState(() => _feedback = feedback);
  }

  Future<void> _toUnloading(
    BuildContext context,
    WidgetRef ref,
    int missing,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (missing > 0 &&
        !await showConfirmDialog(
          context,
          title: l10n.moveToUnloadingTitle(missing),
          message: l10n.moveToUnloadingMessage,
          confirmLabel: l10n.moveToUnloading,
        )) {
      return;
    }
    await ref
        .read(transportActionsProvider.notifier)
        .startUnloading(transport.id);
  }

  Future<void> _finish(
    BuildContext context,
    WidgetRef ref,
    int missing,
    Map<String, String> names,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (missing > 0 &&
        !await showConfirmDialog(
          context,
          title: l10n.moveFinishTitle(missing),
          message: l10n.moveFinishMessage(
            names[transport.sourceApiaryId] ?? '',
          ),
          confirmLabel: l10n.moveFinishConfirm,
        )) {
      return;
    }
    await ref.read(transportActionsProvider.notifier).complete(transport.id);
  }
}

/// Biten taşıma: yüklenen ve indirilen sayıları, kaç kovanın hedefe
/// taşındığı ve indirilmeyen kovanlar.
class _DoneStep extends ConsumerWidget {
  const new(this.transport);

  final Transport transport;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final items =
        ref.watch(transportItemsProvider(transport.id)).value ??
        const <TransportItem>[];
    final hives = {
      for (final hive
          in ref.watch(organizationHivesProvider).value ?? const <Hive>[])
        hive.id: hive,
    };
    final names = _apiaryNames(ref);
    final notUnloaded = itemsNotUnloaded(items);
    final unloaded = items.length - notUnloaded.length;

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          const MoveStepBar(step: MoveStep.done),
          SizedBox(height: spacing.xl),
          AppCard(
            status: notUnloaded.isEmpty ? AppStatus.good : AppStatus.warning,
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  StatusMessage(
                    status: notUnloaded.isEmpty
                        ? AppStatus.good
                        : AppStatus.warning,
                    message: l10n.moveDoneTitle,
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    l10n.moveDoneSummary(items.length, unloaded),
                    style: context.typography.title,
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    l10n.moveDoneMoved(
                      unloaded,
                      names[transport.destinationApiaryId] ?? '',
                    ),
                    style: context.typography.body,
                  ),
                ],
              ),
            ),
          ),
          if (notUnloaded.isNotEmpty) ...[
            SizedBox(height: spacing.xl),
            SectionLabel(l10n.moveDoneMissing),
            SizedBox(height: spacing.sm),
            ListGroup(
              children: [
                for (final item in notUnloaded)
                  ListRow(
                    title: l10n.hiveLabel(hives[item.hiveId]?.number ?? ''),
                    value: item.vehicle,
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

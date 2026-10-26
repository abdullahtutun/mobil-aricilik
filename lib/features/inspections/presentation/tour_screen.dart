import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/screen_awake.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/tour_rules.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_sheet.dart';
import 'package:mobil_arici/features/inspections/presentation/tour_providers.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_labels.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_reminder_choice.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/tour_labels.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';

/// Arılıkta turu açar: arılığın süren turu varsa ona döner; başka
/// arılığın turu sürüyorsa onay alıp yeni tur başlatır.
Future<void> openApiaryTour(
  BuildContext context,
  WidgetRef ref,
  String apiaryId,
) async {
  final l10n = AppLocalizations.of(context);
  final current = await ref.read(currentTourProvider.future);
  if (!context.mounted) return;
  if (current?.apiaryId == apiaryId) {
    return context.go(AppRoutes.apiaryTour(apiaryId));
  }
  if (current != null) {
    final other = await ref
        .read(apiaryRepositoryProvider)
        .findById(current.apiaryId);
    if (!context.mounted) return;
    // Silinmiş arılığın turu sorulmadan biter.
    if (other != null) {
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.tourReplaceTitle,
        message: l10n.tourReplaceMessage(other.name),
        confirmLabel: l10n.tourReplaceConfirm,
      );
      if (!confirmed || !context.mounted) return;
    }
  }
  await ref.read(tourActionsProvider.notifier).start(apiaryId);
  if (context.mounted) context.go(AppRoutes.apiaryTour(apiaryId));
}

/// Arılık turu (docs/design "Arılık turu"): üstte ilerleme ("14 / 40") ve
/// geçen süre, ortada sıradaki kovan ve geçen seferki muayenesi, altında
/// sıra ızgarası (bitti / atlandı / bekliyor). Atla kovanı sıranın sonuna
/// bırakır; atlananlar ızgarada kalır. Ekran açık kaldıkça telefon
/// kararmaz; güneş modu üst çubuktan tek dokunuşla açılır.
class TourScreen extends ConsumerStatefulWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  ConsumerState<TourScreen> createState() => _TourScreenState();
}

class _TourScreenState extends ConsumerState<TourScreen> {
  late final ScreenAwake _awake;
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _awake = ref.read(screenAwakeProvider);
    unawaited(_awake.keepOn(enabled: true));
    // Geçen süre dakikada bir ilerlesin.
    _ticker = Timer.periodic(const Duration(seconds: 30), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    unawaited(_awake.keepOn(enabled: false));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apiaryId = widget.apiaryId;

    return switch (ref.watch(apiaryTourProvider(apiaryId))) {
      AsyncValue(value: final progress?) => _TourBody(apiaryId, progress),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.tourNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _TourBody extends ConsumerWidget {
  const new(this.apiaryId, this.progress);

  final String apiaryId;
  final TourProgress progress;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final (:tour, :entries, :next) = progress;
    final done = entries.where((e) => e.state == TourHiveState.done).length;
    final skipped = entries
        .where((e) => e.state == TourHiveState.skipped)
        .length;
    final apiaryName =
        ref.watch(apiarySummaryProvider(apiaryId)).value?.apiary.name ?? '';
    final sunMode =
        ref.watch(appearanceProvider.select((a) => a.colorMode)) ==
        AppColorMode.sun;
    final actions = ref.read(tourActionsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: l10n.tourSunMode,
            isSelected: sunMode,
            icon: const Icon(Icons.wb_sunny_outlined),
            selectedIcon: const Icon(Icons.wb_sunny_rounded),
            onPressed: () => actions.setSunMode(enabled: !sunMode),
          ),
          _Elapsed(since: tour.startedAt),
          SizedBox(width: spacing.sm),
        ],
      ),
      body: BottomActionLayout(
        separated: true,
        // Sıra ızgarasının hepsi kurulu kalsın (ekran okuyucu da görür).
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: spacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Semantics(
                header: true,
                child: Text(
                  l10n.tourTitle(apiaryName),
                  style: context.typography.headline,
                ),
              ),
              SizedBox(height: spacing.sm),
              _Progress(done: done, total: entries.length),
              if (!sunMode && done == 0) ...[
                SizedBox(height: spacing.lg),
                NoteCard(
                  icon: Icons.wb_sunny_outlined,
                  message: l10n.tourSunSuggestion,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton(
                      onPressed: () => actions.setSunMode(enabled: true),
                      child: Text(l10n.tourSunOn),
                    ),
                  ),
                ),
              ],
              SizedBox(height: spacing.lg),
              if (next == null)
                StatusMessage(status: AppStatus.good, message: l10n.tourAllDone)
              else
                _NextCard(hive: next, onTap: () => _inspect(context, next)),
              SizedBox(height: spacing.xl),
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Expanded(
                    child: Semantics(
                      header: true,
                      child: Text(
                        l10n.tourQueue,
                        style: context.typography.title,
                      ),
                    ),
                  ),
                  if (skipped > 0)
                    Text(
                      l10n.tourSkippedCount(skipped),
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                ],
              ),
              SizedBox(height: spacing.md),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final entry in entries)
                    _QueueTile(
                      entry: entry,
                      isNext: entry.hive.id == next?.id,
                      onTap: entry.state == TourHiveState.done
                          ? null
                          : () => _inspect(context, entry.hive),
                    ),
                ],
              ),
              SizedBox(height: spacing.md),
              const _Legend(),
              SizedBox(height: spacing.lg),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: colors.statusCritical,
                  ),
                  onPressed: () => _finish(context, ref, entries.length - done),
                  icon: const Icon(Icons.flag_outlined),
                  label: Text(l10n.tourFinish),
                ),
              ),
            ],
          ),
        ),
        action: next == null
            ? BigButton(
                label: l10n.tourFinish,
                onPressed: () => _finish(context, ref, 0),
              )
            : Row(
                spacing: context.touchTargets.gap,
                children: [
                  Expanded(
                    child: BigButton(
                      variant: BigButtonVariant.secondary,
                      label: l10n.tourSkip,
                      onPressed: () => actions.skip(next.id),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: BigButton(
                      label: l10n.tourInspect(next.number),
                      onPressed: () => _inspect(context, next),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _inspect(BuildContext context, Hive hive) =>
      context.go(AppRoutes.apiaryTourInspect(apiaryId, hive.id));

  /// Bakılmayan ([remaining]) kovan varsa onay alır; turu bitirir ve
  /// özeti açar.
  Future<void> _finish(
    BuildContext context,
    WidgetRef ref,
    int remaining,
  ) async {
    final l10n = AppLocalizations.of(context);
    if (remaining > 0) {
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.tourFinishTitle,
        message: l10n.tourFinishMessage(remaining),
        confirmLabel: l10n.tourFinish,
      );
      if (!confirmed || !context.mounted) return;
    }
    await ref.read(tourActionsProvider.notifier).finish();
    if (context.mounted) context.go(AppRoutes.apiaryTourSummary(apiaryId));
  }
}

/// Üst çubukta saat ikonu ve turun geçen süresi.
class _Elapsed extends StatelessWidget {
  const new({required this.since});

  final DateTime since;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final duration = tourDuration(l10n, clock.now().difference(since));

    return Semantics(
      label: l10n.tourElapsedLabel(duration),
      excludeSemantics: true,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: context.colors.surfaceContainer,
          borderRadius: BorderRadius.circular(context.radii.button),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.timer_outlined, size: context.sizes.iconSmall),
              SizedBox(width: spacing.xs),
              Text(duration, style: context.typography.label),
            ],
          ),
        ),
      ),
    );
  }
}

/// İlerleme çubuğu ve "14 / 40".
class _Progress extends StatelessWidget {
  const new({required this.done, required this.total});

  final int done;
  final int total;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;

    return Semantics(
      label: l10n.tourProgressLabel(done, total),
      excludeSemantics: true,
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.radii.pill),
              child: LinearProgressIndicator(
                value: total == 0 ? 1 : done / total,
                minHeight: context.spacing.md,
                color: colors.statusGood,
                backgroundColor: colors.divider,
              ),
            ),
          ),
          SizedBox(width: context.spacing.md),
          Text(l10n.tourProgress(done, total), style: context.typography.title),
        ],
      ),
    );
  }
}

/// Sıradaki kovan: büyük numara, güç rozeti ve geçen seferki muayenenin
/// özeti. Dokununca muayene açılır.
class _NextCard extends ConsumerWidget {
  const new({required this.hive, required this.onTap});

  final Hive hive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final previous = ref
        .watch(hiveInspectionsProvider(hive.id))
        .value
        ?.firstOrNull;
    final score = previous == null ? null : strengthScore(previous.values);
    final weak = previous != null && isWeak(previous.values);

    return AppCard(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SectionLabel(l10n.tourNext),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Text(
                    hive.number,
                    style: context.typography.display,
                    semanticsLabel: l10n.hiveLabel(hive.number),
                  ),
                ),
                if (score != null)
                  StatusBadge(
                    status: weak ? AppStatus.warning : AppStatus.good,
                    label: [
                      if (weak) l10n.attentionWeak,
                      l10n.hiveTileStrength(score),
                    ].join(l10n.titleSeparator),
                  ),
              ],
            ),
            SizedBox(height: spacing.md),
            DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surfaceContainer,
                borderRadius: BorderRadius.circular(context.radii.button),
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      previous == null
                          ? l10n.inspectionFirst
                          : l10n.tourPreviousVisit(
                              AppFormat.of(context)
                                  .dayMonth(previous.inspectedAt.toLocal()),
                            ),
                      style: context.typography.label.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    if (previous != null)
                      for (final line in inspectionSummary(
                        l10n,
                        previous.values,
                      ))
                        Text(line, style: context.typography.body),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Sıradaki kovanın karosu: numara ve durumu; renk ikonla birlikte.
class _QueueTile extends StatelessWidget {
  const new({required this.entry, required this.isNext, this.onTap});

  final TourEntry entry;
  final bool isNext;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final (background, foreground, border, icon) = switch (entry.state) {
      _ when isNext => (
        colors.primary,
        colors.onPrimary,
        colors.primary,
        Icons.arrow_forward_rounded,
      ),
      TourHiveState.done => (
        colors.statusGood,
        colors.onStatus,
        colors.statusGood,
        Icons.check_rounded,
      ),
      TourHiveState.skipped => (
        colors.statusWarningContainer,
        colors.statusWarning,
        colors.statusWarning,
        Icons.skip_next_rounded,
      ),
      TourHiveState.pending => (
        colors.tile,
        colors.textPrimary,
        colors.divider,
        null,
      ),
    };
    final state = isNext ? l10n.tourStateNext : entry.state.label(l10n);

    return Semantics(
      button: onTap != null,
      label: l10n.tourHiveSemantics(entry.hive.number, state),
      excludeSemantics: true,
      child: Material(
        color: background,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(context.radii.button),
          side: BorderSide(color: border, width: context.strokes.focus),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minWidth: context.touchTargets.field,
              minHeight: context.touchTargets.field,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: spacing.sm),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(
                      icon,
                      size: context.sizes.iconSmall,
                      color: foreground,
                    ),
                    SizedBox(width: spacing.xs),
                  ],
                  Text(
                    entry.hive.number,
                    style: context.typography.label.copyWith(color: foreground),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Izgaranın açıklaması: ikon ve kelime.
class _Legend extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;

    Widget item(IconData icon, Color color, String label) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: context.sizes.iconSmall, color: color),
        SizedBox(width: spacing.xs),
        Text(label, style: context.typography.bodySmall),
      ],
    );

    return Wrap(
      spacing: spacing.lg,
      runSpacing: spacing.xs,
      children: [
        item(Icons.check_rounded, colors.statusGood, l10n.tourStateDone),
        item(
          Icons.skip_next_rounded,
          colors.statusWarning,
          l10n.tourStateSkipped,
        ),
        item(
          Icons.radio_button_unchecked_rounded,
          colors.textSecondary,
          l10n.tourStatePending,
        ),
      ],
    );
  }
}

/// Turda kovanın muayenesi. Önceki kovan kaydedilip bu sayfa açıldıysa
/// onun kaydı, hatırlatma seçimi ve Geri al'ı formun en üstünde durur;
/// alttaki bildirim Kaydet'i kapatırdı.
class TourInspectionSheet extends ConsumerStatefulWidget {
  const new({required this.apiaryId, required this.hiveId, super.key});

  final String apiaryId;
  final String hiveId;

  @override
  ConsumerState<TourInspectionSheet> createState() =>
      _TourInspectionSheetState();
}

class _TourInspectionSheetState extends ConsumerState<TourInspectionSheet> {
  TourSavedInspection? _previous;

  @override
  void initState() {
    super.initState();
    _previous = ref.read(tourActionsProvider.notifier).takePendingSaved();
  }

  @override
  Widget build(BuildContext context) {
    final previous = _previous;
    return InspectionSheet(
      hiveId: widget.hiveId,
      tourApiaryId: widget.apiaryId,
      notice: previous == null
          ? null
          : _SavedNotice(
              previous,
              onUndone: () => setState(() => _previous = null),
            ),
    );
  }
}

/// Önceki kovanın kaydı: "Kovan 101 muayenesi kaydedildi", "Tekrar bakmayı
/// hatırlat" ve Geri al.
class _SavedNotice extends ConsumerWidget {
  const new(this.previous, {required this.onUndone});

  final TourSavedInspection previous;
  final VoidCallback onUndone;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final saved = previous.saved;
    final actions = ref.read(inspectionActionsProvider.notifier);

    return NoteCard(
      icon: Icons.check_circle_outline_rounded,
      message: l10n.inspectionSaved(previous.hiveNumber),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: context.spacing.sm),
          InspectionReminderChoice(
            onChanged: (days) => actions.remind(saved.inspection, days),
          ),
          Align(
            alignment: AlignmentDirectional.centerEnd,
            child: TextButton(
              onPressed: () async {
                onUndone();
                await actions.undo(saved);
                await ref
                    .read(tourActionsProvider.notifier)
                    .undo(saved.inspection);
              },
              child: Text(l10n.actionUndo),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_sheets.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_timeline_section.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/presentation/media_controllers.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_action_row.dart';

/// Kovan kartı: üst çubukta arılık adı; dev numara, durum rozeti ve güç
/// puanı; ana arı şeridi ve son muayene özeti; taşıma ve durum değiştirme;
/// en altta zaman tüneli. Altta sabit foto ve mikrofon butonları kovana
/// tek dokunuşla foto ya da sesli not ekler; aktif kovanda yanlarındaki
/// "Muayene başlat" hızlı muayeneyi kartın üstünde açar. Diğer özet
/// karoları (ilaç, varroa, verim) kendi adımlarında gelecek.
///
/// [apiaryId] yoldaki arılık (geri tuşu oraya döner); gösterilen arılık
/// kovanın kendi arılığıdır.
class HiveCardScreen extends ConsumerWidget {
  const new({required this.apiaryId, required this.hiveId, super.key});

  final String apiaryId;
  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return switch (ref.watch(hiveProvider(hiveId))) {
      AsyncData(value: final hive?) => Scaffold(
        appBar: AppBar(
          title: _ApiaryTitle(hive.apiaryId),
          actions: [
            IconButton(
              tooltip: l10n.hiveEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => context.go(AppRoutes.hiveEdit(apiaryId, hiveId)),
            ),
          ],
        ),
        body: BottomActionLayout(
          separated: true,
          action: MediaActionRow(
            target: 'hive:$hiveId',
            onCaptured: (capture) => _addMedia(context, ref, hive, capture),
            action: canInspect(hive)
                ? BigButton(
                    label: l10n.hiveStartInspection,
                    onPressed: () =>
                        context.go(AppRoutes.hiveInspect(apiaryId, hiveId)),
                  )
                : const SizedBox.shrink(),
          ),
          body: ListView(
            padding: EdgeInsets.all(spacing.lg),
            children: [
              _Header(hive),
              SizedBox(height: spacing.lg),
              const _QueenStrip(),
              SizedBox(height: spacing.md),
              _LastInspection(hiveId),
              SizedBox(height: spacing.lg),
              BigButton(
                variant: BigButtonVariant.secondary,
                label: l10n.hiveMove,
                icon: Icons.local_shipping_outlined,
                onPressed: () => _move(context, ref, hive),
              ),
              SizedBox(height: context.touchTargets.gap),
              BigButton(
                variant: BigButtonVariant.secondary,
                label: l10n.hiveChangeStatus,
                icon: Icons.swap_horiz_rounded,
                onPressed: () => _changeStatus(context, ref, hive),
              ),
              // Geçmiş uzadıkça eylemler aşağı itilmesin diye en altta.
              SizedBox(height: spacing.xl),
              HiveTimelineSection(hiveId: hiveId),
            ],
          ),
        ),
      ),
      AsyncData() => Scaffold(appBar: AppBar(), body: const HiveNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }

  /// Çekilen foto ya da sesli not hemen kovana yazılır; Geri al kaydı ve
  /// dosyayı siler.
  Future<void> _addMedia(
    BuildContext context,
    WidgetRef ref,
    Hive hive,
    MediaCapture capture,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(mediaActionsProvider.notifier);
    final media = await actions.addToHive(hive, capture);
    if (!context.mounted) return;
    showUndoSnackBar(
      context,
      message: switch (capture.kind) {
        MediaKind.photo => l10n.mediaPhotoAdded(hive.number),
        MediaKind.audio => l10n.mediaVoiceAdded(hive.number),
      },
      onUndo: () => actions.undoAdd(media, capture),
    );
  }

  /// Arılık seçilince hemen taşır; Geri al kovanı eski arılığına döndürür.
  Future<void> _move(BuildContext context, WidgetRef ref, Hive hive) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(hiveActionsProvider.notifier);
    final target = await showHiveMoveSheet(context, hive);
    if (target == null) return;
    final move = await actions.move(hive.id, apiaryId: target.id);
    if (move == null || !context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.hiveMoved(hive.number, target.name),
      onUndo: () => actions.undoMove(move),
    );
  }

  /// Aktif kovan sayısını düşüren durum önce onay ister; öbürleri hemen
  /// yazılır ve geri alınabilir.
  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    Hive hive,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(hiveActionsProvider.notifier);
    final status = await showHiveStatusSheet(context, hive);
    if (status == null || !context.mounted) return;

    if (statusChangeNeedsConfirmation(from: hive.status, to: status)) {
      final confirmed = await confirmHiveStatusChange(
        context,
        number: hive.number,
        status: status,
      );
      if (confirmed) await actions.setStatus(hive.id, status);
      return;
    }

    final previous = hive.status;
    await actions.setStatus(hive.id, status);
    if (!context.mounted) return;
    showUndoSnackBar(
      context,
      message: l10n.hiveStatusChanged(hive.number, status.label(l10n)),
      onUndo: () => actions.setStatus(hive.id, previous),
    );
  }
}

/// Üst çubukta kovanın arılığı; ekran okuyucu "Arılık: Yayla" okur.
class _ApiaryTitle extends ConsumerWidget {
  const new(this.apiaryId);

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = ref.watch(apiarySummaryProvider(apiaryId)).value?.apiary.name;
    if (name == null) return const SizedBox.shrink();
    return Text(
      name,
      semanticsLabel: AppLocalizations.of(context).hiveCardApiary(name),
    );
  }
}

/// "KOVAN", altında dev numara; sağda durum rozeti, altında güç puanı.
class _Header extends ConsumerWidget {
  const new(this.hive);

  final Hive hive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final strength = ref.watch(hiveStrengthProvider(hive.id));

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Semantics(
                header: true,
                label: l10n.hiveLabel(hive.number),
                excludeSemantics: true,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionLabel(l10n.hiveCardKind),
                    // Uzun numara ve büyük yazı boyutunda kırılmasın,
                    // küçülsün.
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: AlignmentDirectional.centerStart,
                      child: Text(
                        hive.number,
                        maxLines: 1,
                        style: context.typography.display,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: spacing.md),
            Padding(
              padding: EdgeInsets.only(bottom: spacing.sm),
              child: StatusBadge(
                status: hive.status.appStatus,
                label: hive.status.label(l10n),
              ),
            ),
          ],
        ),
        // Aktif olmayan kovanın eski puanı yanıltır; ızgaradaki gibi
        // gösterilmez. Puan yüklenirken de boş kalır, "yok" yanıp sönmesin.
        if (hive.status.isCounted && strength.hasValue) ...[
          SizedBox(height: spacing.sm),
          _Strength(strength.value),
        ],
      ],
    );
  }
}

/// Güç puanı: noktalar ve kelimesi ("Güç 3/5"); puan yoksa nedenini yazar.
class _Strength extends StatelessWidget {
  const new(this.strength);

  final int? strength;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final strength = this.strength;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StrengthDots(strength: strength),
        SizedBox(width: context.spacing.sm),
        Flexible(
          child: strength == null
              ? Text(
                  l10n.hiveStrengthNone,
                  style: context.typography.body.copyWith(
                    color: colors.textSecondary,
                  ),
                )
              : Text(
                  l10n.hiveTileStrength(strength),
                  style: context.typography.label,
                ),
        ),
      ],
    );
  }
}

/// Ana arı şeridi; ana arı kartı gelene kadar yer tutucu. Boş renk noktası
/// karodaki yerini gösterir.
class _QueenStrip extends StatelessWidget {
  const new();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;

    return MergeSemantics(
      child: AppCard(
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              SizedBox.square(
                dimension: context.touchTargets.minimum,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: colors.surfaceContainer,
                  ),
                  child: Icon(
                    Icons.workspace_premium_outlined,
                    size: context.sizes.icon,
                    color: colors.textSecondary,
                  ),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.hiveQueenTitle, style: context.typography.label),
                    Text(
                      l10n.hiveQueenPlaceholder,
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Son muayene karosu: ne zaman ve girilen çerçeveler; muayene yoksa
/// "Henüz yok".
class _LastInspection extends ConsumerWidget {
  const new(this.hiveId);

  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final inspections = ref.watch(hiveInspectionsProvider(hiveId));
    // Yüklenirken boş kalır; "yok" yanıp sönmesin.
    if (!inspections.hasValue) return const SizedBox.shrink();
    final latest = inspections.value!.firstOrNull;
    if (latest == null) {
      return SummaryTile(
        label: l10n.hiveLastInspection,
        value: l10n.hiveLastInspectionNone,
      );
    }
    final values = latest.values;
    final frames = [
      if (values.beeFrames case final count?) l10n.timelineBeeFrames(count),
      if (values.broodFrames case final count?) l10n.timelineBroodFrames(count),
      if (values.honeyFrames case final count?) l10n.timelineHoneyFrames(count),
    ];
    return SummaryTile(
      label: l10n.hiveLastInspection,
      value: relativeDay(
        l10n,
        AppFormat.of(context),
        latest.inspectedAt,
        now: clock.now(),
      ),
      detail: frames.isEmpty ? null : frames.join(l10n.listSeparator),
    );
  }
}

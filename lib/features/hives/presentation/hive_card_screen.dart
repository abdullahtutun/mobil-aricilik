import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/relative_date.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/health/presentation/varroa_providers.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';
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
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';

/// Kovan kartı: üst çubukta arılık adı; dev numara, durum rozeti ve güç
/// puanı; ana arı şeridi (dokununca ana arı kartı), son muayene, aktif
/// ilaç ve son varroa oranı; varroa ölçümü, ilaç uygulaması, taşıma ve durum
/// değiştirme; en altta zaman
/// tüneli. Altta sabit foto ve
/// mikrofon butonları kovana tek dokunuşla foto ya da sesli not ekler;
/// aktif kovanda yanlarındaki
/// "Muayene başlat" hızlı muayeneyi kartın üstünde açar. Verim karosu
/// hasat adımında gelecek.
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
              _QueenStrip(apiaryId: apiaryId, hiveId: hiveId),
              SizedBox(height: spacing.md),
              // Uzun yazıda yan yana iki karo aynı boyda kalsın.
              IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(child: _LastInspection(hiveId)),
                    SizedBox(width: context.touchTargets.gap),
                    Expanded(child: _ActiveTreatment(hiveId)),
                  ],
                ),
              ),
              SizedBox(height: context.touchTargets.gap),
              // Verim karosu hasat adımında sağa gelecek.
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _LastVarroa(hiveId)),
                  SizedBox(width: context.touchTargets.gap),
                  const Spacer(),
                ],
              ),
              SizedBox(height: spacing.lg),
              if (canInspect(hive)) ...[
                BigButton(
                  variant: BigButtonVariant.secondary,
                  label: l10n.hiveVarroaCount,
                  icon: Icons.bug_report_outlined,
                  onPressed: () =>
                      context.go(AppRoutes.hiveVarroa(apiaryId, hiveId)),
                ),
                SizedBox(height: context.touchTargets.gap),
                BigButton(
                  variant: BigButtonVariant.secondary,
                  label: l10n.hiveTreat,
                  icon: Icons.medication_outlined,
                  onPressed: () =>
                      context.go(AppRoutes.hiveTreat(apiaryId, hiveId)),
                ),
                SizedBox(height: context.touchTargets.gap),
                BigButton(
                  variant: BigButtonVariant.secondary,
                  label: l10n.hiveFeed,
                  icon: Icons.local_drink_outlined,
                  onPressed: () =>
                      context.go(AppRoutes.hiveFeed(apiaryId, hiveId)),
                ),
                SizedBox(height: context.touchTargets.gap),
              ],
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

/// Ana arı şeridi: işaret rengi, "2025 · Mavi" ve "1 yaşında · Kafkas";
/// dokununca ana arı kartı açılır. Kovanda ana yoksa dokunmak yeni ana
/// verir.
class _QueenStrip extends ConsumerWidget {
  const new({required this.apiaryId, required this.hiveId});

  final String apiaryId;
  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final queen = ref.watch(hiveQueenProvider(hiveId));
    // Yüklenirken boş kalır; "kayıt yok" yanıp sönmesin.
    if (!queen.hasValue) return const SizedBox.shrink();
    final value = queen.value;
    final detail = value == null
        ? l10n.hiveQueenNoneHint
        : value.detail(l10n, currentYear: clock.now().year);

    return MergeSemantics(
      child: AppCard(
        onTap: () => context.go(
          value == null
              ? AppRoutes.hiveQueenNew(apiaryId, hiveId)
              : AppRoutes.hiveQueen(apiaryId, hiveId),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              QueenMarkCircle(
                markColor: value?.markColor,
                dimension: context.touchTargets.minimum,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hiveQueenTitle,
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                    Text(
                      value?.title(l10n) ?? l10n.hiveQueenNone,
                      style: context.typography.label,
                    ),
                    if (detail != null)
                      Text(
                        detail,
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: context.sizes.icon,
                color: colors.textSecondary,
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

/// Aktif ilaç karosu: bekleme süresindeyse kritik zeminde kalan gün,
/// etken madde ve "bal katı yok"; değilse "Yok".
class _ActiveTreatment extends ConsumerWidget {
  const new(this.hiveId);

  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final lock = ref.watch(hiveWithdrawalLockProvider(hiveId));
    // Yüklenirken boş kalır; "yok" yanıp sönmesin.
    if (!lock.hasValue) return const SizedBox.shrink();
    final active = lock.value;
    if (active == null) {
      return SummaryTile(
        label: l10n.hiveActiveTreatment,
        value: l10n.hiveActiveTreatmentNone,
      );
    }
    return SummaryTile(
      label: l10n.hiveActiveTreatment,
      status: AppStatus.critical,
      value: l10n.hiveActiveTreatmentLeft(active.daysLeft),
      detail: l10n.hiveActiveTreatmentDetail(
        active.treatment.activeIngredient.label(l10n),
      ),
    );
  }
}

/// Son varroa karosu: sonuç, yöntem ve ne zaman; eşiğe ulaştıysa uyarı
/// zemininde ve "Eşiğe ulaştı" yazar. Ölçüm yoksa "Ölçüm yok".
class _LastVarroa extends ConsumerWidget {
  const new(this.hiveId);

  final String hiveId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final counts = ref.watch(hiveMiteCountsProvider(hiveId));
    final thresholds =
        ref.watch(varroaThresholdsProvider).value ?? defaultVarroaThresholds;
    // Yüklenirken boş kalır; "yok" yanıp sönmesin.
    if (!counts.hasValue) return const SizedBox.shrink();
    final latest = counts.value!.firstOrNull;
    final load = latest == null ? null : miteLoadOf(latest);
    if (latest == null || load == null) {
      return SummaryTile(label: l10n.hiveVarroa, value: l10n.hiveVarroaNone);
    }
    final reached = reachesThreshold(load, thresholds);
    return SummaryTile(
      label: l10n.hiveVarroa,
      value: miteLoadText(l10n, load),
      status: reached ? AppStatus.warning : null,
      detail: [
        if (reached) l10n.hiveVarroaReached,
        latest.method.label(l10n),
        relativeDay(
          l10n,
          AppFormat.of(context),
          latest.countedAt,
          now: clock.now(),
        ),
      ].join(l10n.titleSeparator),
    );
  }
}

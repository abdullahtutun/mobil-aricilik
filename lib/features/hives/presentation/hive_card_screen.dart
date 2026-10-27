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
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
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
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

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
    final canWrite = ref.watch(canWriteRecordsProvider);

    return switch (ref.watch(hiveProvider(hiveId))) {
      AsyncData(value: final hive?) => Scaffold(
        appBar: AppBar(
          title: _ApiaryTitle(hive.apiaryId),
          actions: [
            // Seyrek eylemler ⋮ menüsünde (docs/design "Kovan kartı");
            // menünün hepsi kayıt eylemi, viewer görmez.
            if (canWrite)
              PopupMenuButton<VoidCallback>(
                icon: const Icon(Icons.more_vert_rounded),
                onSelected: (action) => action(),
                itemBuilder: (context) => [
                  if (canInspect(hive)) ...[
                    PopupMenuItem(
                      value: () =>
                          context.go(AppRoutes.hiveVarroa(apiaryId, hiveId)),
                      child: Text(l10n.hiveVarroaCount),
                    ),
                    PopupMenuItem(
                      value: () =>
                          context.go(AppRoutes.hiveTreat(apiaryId, hiveId)),
                      child: Text(l10n.hiveTreat),
                    ),
                    PopupMenuItem(
                      value: () =>
                          context.go(AppRoutes.hiveFeed(apiaryId, hiveId)),
                      child: Text(l10n.hiveFeed),
                    ),
                  ],
                  PopupMenuItem(
                    value: () => _move(context, ref, hive),
                    child: Text(l10n.hiveMove),
                  ),
                  PopupMenuItem(
                    value: () => _changeStatus(context, ref, hive),
                    child: Text(l10n.hiveChangeStatus),
                  ),
                  PopupMenuItem(
                    value: () =>
                        context.go(AppRoutes.hiveEdit(apiaryId, hiveId)),
                    child: Text(l10n.hiveEdit),
                  ),
                ],
              ),
          ],
        ),
        body: BottomActionLayout(
          separated: true,
          action: MediaActionRow(
            target: 'hive:$hiveId',
            onCaptured: (capture) => _addMedia(context, ref, hive, capture),
            action: canWrite && canInspect(hive)
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

/// "KOVAN", altında dev numara; sağda rozet: aktif ve puanlı kovanda güç
/// ("Güçlü · 4/5"), öbürlerinde durum. Aktif kovanın puanı yoksa nedeni
/// altta yazar.
class _Header extends ConsumerWidget {
  const new(this.hive);

  final Hive hive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final strength = ref.watch(hiveStrengthProvider(hive.id));
    // Aktif olmayan kovanın eski puanı yanıltır; ızgaradaki gibi
    // gösterilmez. Puan yüklenirken de boş kalır, "yok" yanıp sönmesin.
    final score = hive.status.isCounted ? strength.value : null;

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
            // Büyük yazıda rozet numaranın yerini almasın; en çok yarısı.
            Flexible(
              child: Padding(
                padding: EdgeInsets.only(bottom: spacing.sm),
                child: score == null
                    ? StatusBadge(
                        status: hive.status.appStatus,
                        label: hive.status.label(l10n),
                      )
                    : _StrengthBadge(score),
              ),
            ),
          ],
        ),
        if (hive.status.isCounted && strength.hasValue && score == null) ...[
          SizedBox(height: spacing.sm),
          Text(
            l10n.hiveStrengthNone,
            style: context.typography.body.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }
}

/// Güç rozeti: kelime ve puan ("Zayıf · 2/5"), noktalarla aynı renkte.
class _StrengthBadge extends StatelessWidget {
  const new(this.strength);

  final int strength;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (status, word) = switch (strengthLevel(strength)) {
      StrengthLevel.weak => (AppStatus.warning, l10n.hiveStrengthWeak),
      StrengthLevel.medium => (AppStatus.info, l10n.hiveStrengthMedium),
      StrengthLevel.strong => (AppStatus.good, l10n.hiveStrengthStrong),
    };
    return StatusBadge(
      status: status,
      label: l10n.hiveStrengthBadge(word, strength),
    );
  }
}

/// Ana arı şeridi: işaret rengi, "Ana arı · 2025 · Mavi" ve "1 yaşında ·
/// Kafkas";
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
                dimension: context.sizes.avatar,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.hiveQueenStripTitle(
                        value?.title(l10n) ?? l10n.hiveQueenNone,
                      ),
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

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/migration/presentation/widgets/migration_labels.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Göç planının zaman çizelgesi (docs/design "Gezginci · göç planı"):
/// üstte "Sıradaki taşıma" kartı, altında duraklar rota sırasıyla; her
/// durakta ay aralığı, yer, kovan sayısı ve hedef arılığın geçmiş yıl
/// verimi. Durağa dokununca düzenlenir; altta "Durak ekle" ve sıradaki
/// taşımayı açan "Taşıma başlat". Üst bardaki
/// "Evrak" belge kasasını açar. Viewer durak ekleyemez ve düzenleyemez.
class MigrationScreen extends ConsumerWidget {
  const new({required this.migrationId, super.key});

  final String migrationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);
    final migration = ref.watch(migrationProvider(migrationId));
    final stops = ref.watch(migrationStopsProvider(migrationId));

    return switch ((migration, stops)) {
      (AsyncData(value: final migration?), AsyncData(value: final stops)) =>
        Scaffold(
          appBar: AppBar(
            title: Text(migrationTitle(l10n, migration)),
            actions: [
              TextButton(
                onPressed: () => context.push(AppRoutes.documents),
                child: Text(l10n.migrationDocuments),
              ),
              if (canWrite)
                IconButton(
                  tooltip: l10n.migrationEdit,
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () =>
                      context.go(AppRoutes.migrationEdit(migrationId)),
                ),
            ],
          ),
          body: stops.isEmpty
              ? EmptyState(
                  icon: Icons.route_outlined,
                  title: l10n.migrationNoStopsTitle,
                  message: l10n.migrationNoStopsMessage,
                  actionLabel: canWrite ? l10n.migrationAddStop : null,
                  onAction: canWrite ? () => _addStop(context) : null,
                  centered: true,
                )
              : _Timeline(migration, stops, canWrite: canWrite),
        ),
      (AsyncData(value: null), _) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.migrationNotFound)),
      ),
      (AsyncError(), _) || (_, AsyncError()) => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.migrationsLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      _ => Scaffold(appBar: AppBar()),
    };
  }

  void _addStop(BuildContext context) =>
      context.go(AppRoutes.migrationStopNew(migrationId));
}

class _Timeline extends ConsumerWidget {
  const new(this.migration, this.stops, {required this.canWrite});

  final Migration migration;
  final List<MigrationStop> stops;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final next = nextMove(stops);
    final yields =
        ref.watch(migrationYieldsProvider(migration.id)).value ?? const {};

    final list = ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        if (next != null) ...[
          _NextMoveCard(next),
          SizedBox(height: spacing.xl),
        ],
        for (final (index, stop) in stops.indexed)
          _StopRow(
            stop,
            yields: stop.apiaryId == null
                ? null
                : yields[stop.apiaryId] ?? const [],
            isLast: index == stops.length - 1,
            onTap: canWrite
                ? () => context.go(
                    AppRoutes.migrationStopEdit(migration.id, stop.id),
                  )
                : null,
          ),
      ],
    );
    if (!canWrite) return SafeArea(child: list);
    return BottomActionLayout(
      separated: true,
      body: list,
      action: Row(
        spacing: context.touchTargets.gap,
        children: [
          // Durak ekle yazısı kadar, tek satır; Taşıma başlat birincil,
          // kalan genişlikte.
          BigButton(
            label: l10n.migrationAddStop,
            variant: BigButtonVariant.secondary,
            expanded: false,
            onPressed: () =>
                context.go(AppRoutes.migrationStopNew(migration.id)),
          ),
          Expanded(
            child: BigButton(
              label: l10n.moveStart,
              // Sıradaki taşıma yoksa (planlı durak kalmadı) pasif.
              onPressed: next == null
                  ? null
                  : () => context.go(AppRoutes.migrationMove(migration.id)),
            ),
          ),
        ],
      ),
    );
  }
}

/// "Sıradaki taşıma" kartı: koyu zeminde kalan gün, duraklar, yerler ve
/// kovan sayısı; TR profilinde taşımada gereken belgelerin durumu.
class _NextMoveCard extends ConsumerWidget {
  const new(this.move);

  final NextMove move;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final onCard = colors.onInverseSurface;
    final now = clock.now();
    final from = move.from;
    final to = move.to;

    final days = calendarDaysBetween(now, to.plannedStartOn);
    final heading = days < 0
        ? l10n.migrationNextMoveLate(-days)
        : l10n.migrationNextMoveIn(days);
    final title = from == null
        ? to.name
        : l10n.migrationRoute(from.name, to.name);
    // Kaynak ve hedefin yeri birlikte ("Ula → Köyceğiz"); yeri yazılmamış
    // durakta adı. İlk taşımada yalnız hedefin yeri.
    final places = from == null
        ? to.place
        : l10n.migrationRoute(stopPlace(from), stopPlace(to));
    final hiveCount = to.hiveCount ?? from?.hiveCount;
    final details = [
      ?places,
      if (hiveCount != null) l10n.apiaryHiveCount(hiveCount),
    ].join(' · ');

    final showDocuments = ref
        .watch(regionConfigProvider)
        .features
        .trMigrationDocs;
    final documents = showDocuments ? ref.watch(documentsProvider).value : null;

    return Material(
      color: colors.inverseSurface,
      borderRadius: BorderRadius.circular(context.radii.card),
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    format.upperCase(heading),
                    style: typography.labelSmall.copyWith(color: onCard),
                  ),
                  SizedBox(height: spacing.sm),
                  Text(
                    title,
                    style: typography.headline.copyWith(color: onCard),
                  ),
                  if (details.isNotEmpty) ...[
                    SizedBox(height: spacing.xs),
                    Text(
                      details,
                      style: typography.body.copyWith(color: onCard),
                    ),
                  ],
                ],
              ),
            ),
            if (documents != null) ...[
              SizedBox(height: spacing.md),
              Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                children: [
                  for (final document in migrationDocumentStatuses(
                    documents,
                    moveOn: to.plannedStartOn,
                    now: now,
                  ))
                    if (migrationDocumentBadge(l10n, document) case (
                      :final status,
                      :final label,
                    ))
                      StatusBadge(status: status, label: label),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Zaman çizelgesinde durak: solda durumuna göre nokta (geçmiş dolu
/// soluk, şu an dolu yeşil halkalı, plan boş halka) ve sonrakine inen
/// çizgi; sağda ad, ay aralığı, yer ve kovan, şu an rozeti ve verim.
/// [yields] null ise durağın hedef arılığı yok, verim satırı çıkmaz.
class _StopRow extends StatelessWidget {
  const new(
    this.stop, {
    required this.yields,
    required this.isLast,
    required this.onTap,
  });

  final MigrationStop stop;
  final List<YearlyYield>? yields;
  final bool isLast;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final secondary = typography.bodySmall.copyWith(
      color: colors.textSecondary,
    );
    final details = stopDetails(l10n, stop);
    final yields = this.yields;
    final current = stop.status == MigrationStopStatus.current;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.radii.button),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.touchTargets.minimum),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                width: context.touchTargets.minimum,
                child: Column(
                  children: [
                    SizedBox(height: spacing.xs),
                    _StopDot(stop.status),
                    if (!isLast)
                      Expanded(
                        child: SizedBox(
                          width: context.strokes.focus,
                          child: ColoredBox(color: colors.divider),
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : spacing.lg),
                  child: MergeSemantics(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                stop.name,
                                style: typography.subtitle,
                              ),
                            ),
                            SizedBox(width: spacing.sm),
                            Flexible(
                              child: Text(
                                stopDates(l10n, format, stop),
                                textAlign: TextAlign.end,
                                style: typography.label.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (details.isNotEmpty) Text(details, style: secondary),
                        // Noktanın anlattığı durum ekran okuyucuda kelimeyle;
                        // şu anki durakta rozet söyler.
                        if (!current)
                          Semantics(
                            label: stopStatusLabel(l10n, stop.status),
                            child: const SizedBox.shrink(),
                          ),
                        if (current) ...[
                          SizedBox(height: spacing.sm),
                          StatusBadge(
                            status: AppStatus.good,
                            label: l10n.migrationStopHere,
                          ),
                        ],
                        if (yields != null) ...[
                          SizedBox(height: spacing.xs),
                          Text(
                            stopYields(l10n, format, yields),
                            style: secondary,
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StopDot extends StatelessWidget {
  const new(this.status);

  final MigrationStopStatus status;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final ring = context.strokes.focus;
    return SizedBox.square(
      dimension: context.sizes.stopDot,
      child: DecoratedBox(
        decoration: switch (status) {
          MigrationStopStatus.past => BoxDecoration(
            shape: BoxShape.circle,
            color: colors.outline,
          ),
          MigrationStopStatus.current => BoxDecoration(
            shape: BoxShape.circle,
            color: colors.statusGood,
            border: Border.all(color: colors.statusGoodContainer, width: ring),
          ),
          MigrationStopStatus.planned => BoxDecoration(
            shape: BoxShape.circle,
            color: colors.surface,
            border: Border.all(color: colors.primary, width: ring),
          ),
        },
      ),
    );
  }
}

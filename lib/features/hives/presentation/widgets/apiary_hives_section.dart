import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_sheets.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Kovan ekle sayfasını açar; seçime göre tek kovan ya da toplu oluşturma
/// formuna geçer.
Future<void> openAddHives(BuildContext context, String apiaryId) async {
  final choice = await showAddHivesSheet(context);
  if (choice == null || !context.mounted) return;
  context.go(switch (choice) {
    AddHivesChoice.one => AppRoutes.hiveNew(apiaryId),
    AddHivesChoice.bulk => AppRoutes.hivesBulk(apiaryId),
  });
}

/// Arılık detayındaki kovanlar: aktifler ızgara ya da listede, güç
/// puanlarıyla ve numaraya göre ya da zayıflar önce; aktif olmayanlar
/// (söndü, birleşti, satıldı, kayboldu) altta ayrı bölümde, puansız ve
/// durumlarıyla. Karttan yeniden aktif yapılabilsinler diye gizlenmezler.
class ApiaryHivesSection extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return switch (ref.watch(apiaryHivesProvider(apiaryId))) {
      AsyncData(value: []) => EmptyState(
        icon: Icons.hive_rounded,
        title: l10n.hivesEmptyTitle,
        message: l10n.hivesEmptyMessage,
        actionLabel: canWrite ? l10n.hivesAdd : null,
        onAction: canWrite ? () => openAddHives(context, apiaryId) : null,
      ),
      AsyncData(value: final hives) => _HiveSections(
        apiaryId: apiaryId,
        hives: hives,
      ),
      AsyncError() => Text(l10n.hivesLoadError),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => const SizedBox.shrink(),
    };
  }
}

class _HiveSections extends ConsumerWidget {
  const new({required this.apiaryId, required this.hives});

  final String apiaryId;

  /// Numara sırasıyla.
  final List<Hive> hives;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final strengths =
        ref.watch(apiaryHiveStrengthsProvider(apiaryId)).value ?? const {};
    final counted = [
      for (final hive in hives)
        if (hive.status.isCounted) hive,
    ];
    final active = switch (ref.watch(hiveSortPreferenceProvider)) {
      HiveSort.number => counted,
      HiveSort.weakestFirst => sortWeakestFirst(counted, strengths),
    };
    final inactive = [
      for (final hive in hives)
        if (!hive.status.isCounted) hive,
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: spacing.md,
          runSpacing: spacing.sm,
          children: [
            const _LayoutToggle(),
            // Tek kovanda sıra seçimi anlamsız.
            if (active.length > 1) const _SortToggle(),
          ],
        ),
        if (active.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          _HiveCollection(
            apiaryId: apiaryId,
            hives: active,
            strengths: strengths,
          ),
        ],
        if (inactive.isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.hivesInactiveTitle(inactive.length)),
          SizedBox(height: spacing.md),
          // Sönen ya da satılan kovanın eski puanı yanıltır.
          _HiveCollection(
            apiaryId: apiaryId,
            hives: inactive,
            strengths: const {},
          ),
        ],
      ],
    );
  }
}

/// "Zayıflar önce" aç/kapa: açıkken aktif kovanlar puana göre, kapalıyken
/// numaraya göre. Açık hali renk dışında dolgu, onay ikonu ve ekran
/// okuyucunun "açık" bilgisiyle de görünür.
class _SortToggle extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final weakestFirst =
        ref.watch(hiveSortPreferenceProvider) == HiveSort.weakestFirst;

    // Aç/kapa bilgisi butonun kendi düğümüne yazılsın.
    return MergeSemantics(
      child: Semantics(
        toggled: weakestFirst,
        child: TextButton.icon(
          style: TextButton.styleFrom(
            minimumSize: Size.square(context.touchTargets.minimum),
            backgroundColor: weakestFirst
                ? colors.surfaceContainer
                : colors.surface,
            foregroundColor: weakestFirst
                ? colors.primary
                : colors.textSecondary,
            textStyle: context.typography.label,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.radii.button),
            ),
          ),
          onPressed: () => ref.read(hiveSortPreferenceProvider.notifier).sort =
              weakestFirst ? HiveSort.number : HiveSort.weakestFirst,
          icon: Icon(
            weakestFirst ? Icons.check_rounded : Icons.filter_list_rounded,
            size: context.sizes.iconSmall,
          ),
          label: Text(l10n.hiveSortWeakestFirst),
        ),
      ),
    );
  }
}

/// Izgara ya da liste görünümü seçimi.
class _LayoutToggle extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return SegmentedTabs<HiveLayout>(
      options: [
        SegmentOption(value: HiveLayout.grid, label: l10n.hiveLayoutGridShort),
        SegmentOption(value: HiveLayout.list, label: l10n.hiveLayoutListShort),
      ],
      selected: ref.watch(hiveLayoutPreferenceProvider),
      onChanged: (layout) =>
          ref.read(hiveLayoutPreferenceProvider.notifier).layout = layout,
    );
  }
}

class _HiveCollection extends ConsumerWidget {
  const new({
    required this.apiaryId,
    required this.hives,
    required this.strengths,
  });

  final String apiaryId;
  final List<Hive> hives;

  /// Kovan kimliğine göre güç puanı; puansız kovan yok.
  final Map<String, int> strengths;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void open(Hive hive) => context.go(AppRoutes.hive(apiaryId, hive.id));

    return switch (ref.watch(hiveLayoutPreferenceProvider)) {
      HiveLayout.grid => _HiveGrid(
        hives: hives,
        strengths: strengths,
        onOpen: open,
      ),
      HiveLayout.list => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.spacing.sm,
        children: [
          for (final hive in hives)
            _HiveListRow(
              hive: hive,
              strength: strengths[hive.id],
              onTap: () => open(hive),
            ),
        ],
      ),
    };
  }
}

/// Sütun sayısı genişlikten çıkar; karolar satırı eşit paylaşır. Karonun
/// boyu içeriğinden gelir, büyük yazı boyutunda kırpılmaz. Üstteki nokta
/// ananın işaret rengi; işaretsiz ya da anasız kovanda boş.
class _HiveGrid extends ConsumerWidget {
  const new({
    required this.hives,
    required this.strengths,
    required this.onOpen,
  });

  final List<Hive> hives;
  final Map<String, int> strengths;
  final ValueChanged<Hive> onOpen;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final gap = context.touchTargets.gap;
    final minWidth = context.sizes.hiveTile;
    final queenColors = ref.watch(queenMarkColorsProvider).value ?? const {};

    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = math.max(
          1,
          ((constraints.maxWidth + gap) / (minWidth + gap)).floor(),
        );
        final width = (constraints.maxWidth - gap * (columns - 1)) / columns;
        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final hive in hives)
              SizedBox(
                width: width,
                child: HiveTile(
                  number: hive.number,
                  queenColor: queenColors[hive.queenId],
                  strength: strengths[hive.id],
                  alertStatus: hive.status.isCounted
                      ? null
                      : hive.status.appStatus,
                  alertLabel: hive.status.isCounted
                      ? null
                      : hive.status.label(l10n),
                  onTap: () => onOpen(hive),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Listede kovan: büyük numara, tip ve kaynak; aktifse güç puanı
/// noktaları, değilse durum rozeti.
class _HiveListRow extends StatelessWidget {
  const new({required this.hive, required this.strength, required this.onTap});

  final Hive hive;
  final int? strength;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final type = hive.type.label(l10n);
    final details = switch (hive.source) {
      final source? => l10n.hiveTypeAndSource(type, source.label(l10n)),
      null => type,
    };

    return NavigationCard(
      onTap: onTap,
      padding: EdgeInsets.symmetric(
        horizontal: spacing.lg,
        vertical: spacing.sm,
      ),
      child: Row(
        children: [
          // Uzun numara ve büyük yazı boyutunda kırılmasın, küçülsün.
          Flexible(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: AlignmentDirectional.centerStart,
              child: Semantics(
                label: l10n.hiveLabel(hive.number),
                excludeSemantics: true,
                child: Text(
                  hive.number,
                  maxLines: 1,
                  style: context.typography.number,
                ),
              ),
            ),
          ),
          SizedBox(width: spacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  details,
                  style: context.typography.bodySmall.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
                SizedBox(height: spacing.xs),
                if (hive.status.isCounted)
                  Semantics(
                    label: switch (strength) {
                      final strength? => l10n.hiveTileStrength(strength),
                      null => null,
                    },
                    child: StrengthDots(strength: strength),
                  )
                else
                  StatusBadge(
                    status: hive.status.appStatus,
                    label: hive.status.label(l10n),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

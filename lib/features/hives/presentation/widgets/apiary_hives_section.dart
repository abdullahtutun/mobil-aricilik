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

    return switch (ref.watch(apiaryHivesProvider(apiaryId))) {
      AsyncData(value: []) => EmptyState(
        icon: Icons.hive_rounded,
        title: l10n.hivesEmptyTitle,
        message: l10n.hivesEmptyMessage,
        actionLabel: l10n.hivesAdd,
        onAction: () => openAddHives(context, apiaryId),
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
        Row(
          children: [
            Expanded(
              child: Semantics(
                header: true,
                child: Text(
                  l10n.apiaryHivesTitle,
                  style: context.typography.title,
                ),
              ),
            ),
            const _LayoutToggle(),
          ],
        ),
        // Tek kovanda sıra seçimi anlamsız.
        if (active.length > 1) ...[
          SizedBox(height: spacing.md),
          const _SortChoice(),
        ],
        if (active.isNotEmpty) ...[
          SizedBox(height: spacing.md),
          _HiveCollection(
            apiaryId: apiaryId,
            hives: active,
            strengths: strengths,
          ),
        ],
        if (inactive.isNotEmpty) ...[
          SizedBox(height: spacing.xl),
          Semantics(
            header: true,
            child: Text(
              l10n.hivesInactiveTitle(inactive.length),
              style: context.typography.subtitle,
            ),
          ),
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

/// Aktif kovanların sırası: numaraya göre ya da zayıflar önce.
class _SortChoice extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);

    return ChoiceChipGroup<HiveSort>(
      options: [
        ChoiceChipOption(value: HiveSort.number, label: l10n.hiveSortNumber),
        ChoiceChipOption(
          value: HiveSort.weakestFirst,
          label: l10n.hiveSortWeakestFirst,
        ),
      ],
      selected: {ref.watch(hiveSortPreferenceProvider)},
      onChanged: (selected) {
        // Her zaman bir sıra seçili; seçili chip'e yeniden dokunmak seçimi
        // kaldırmasın.
        if (selected.isEmpty) return;
        ref.read(hiveSortPreferenceProvider.notifier).sort = selected.single;
      },
    );
  }
}

/// Izgara ya da liste görünümü seçimi.
class _LayoutToggle extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final layout = ref.watch(hiveLayoutPreferenceProvider);
    void select(HiveLayout value) =>
        ref.read(hiveLayoutPreferenceProvider.notifier).layout = value;

    return Row(
      mainAxisSize: MainAxisSize.min,
      spacing: context.touchTargets.gap,
      children: [
        _LayoutButton(
          icon: Icons.grid_view_rounded,
          tooltip: l10n.hiveLayoutGrid,
          selected: layout == HiveLayout.grid,
          onPressed: () => select(HiveLayout.grid),
        ),
        _LayoutButton(
          icon: Icons.view_list_rounded,
          tooltip: l10n.hiveLayoutList,
          selected: layout == HiveLayout.list,
          onPressed: () => select(HiveLayout.list),
        ),
      ],
    );
  }
}

/// Seçili görünüm dolgulu; seçim yalnız renkle değil, dolgu ve ekran
/// okuyucunun "seçili" bilgisiyle de verilir.
class _LayoutButton extends StatelessWidget {
  const new({
    required this.icon,
    required this.tooltip,
    required this.selected,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final bool selected;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final size = context.touchTargets.minimum;

    // Seçim bilgisi butonun kendi düğümüne yazılsın.
    return MergeSemantics(
      child: Semantics(
        selected: selected,
        inMutuallyExclusiveGroup: true,
        child: IconButton(
          onPressed: onPressed,
          tooltip: tooltip,
          icon: Icon(icon),
          style: IconButton.styleFrom(
            backgroundColor: selected ? colors.secondary : null,
            foregroundColor: selected ? colors.onSecondary : colors.textPrimary,
            fixedSize: Size.square(size),
            minimumSize: Size.square(size),
            iconSize: context.sizes.icon,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(context.radii.button),
              side: BorderSide(
                color: selected ? colors.secondary : colors.outline,
                width: context.strokes.border,
              ),
            ),
            // Eldiven büyümesi zaten tokenda; yoğunluk bir kez daha eklemesin.
            visualDensity: VisualDensity.standard,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ),
      ),
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
/// boyu içeriğinden gelir, büyük yazı boyutunda kırpılmaz.
class _HiveGrid extends StatelessWidget {
  const new({
    required this.hives,
    required this.strengths,
    required this.onOpen,
  });

  final List<Hive> hives;
  final Map<String, int> strengths;
  final ValueChanged<Hive> onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final gap = context.touchTargets.gap;
    final minWidth = context.sizes.hiveTile;

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

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/queens/domain/queen_rules.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';

/// Yaşlı analar: aktif kovanlarda [queenReplacementAge] yaşına girmiş
/// analar, en yaşlı önce. Satırda kovan ve arılık, ananın yılı ve rengi;
/// yaşı uyarı rozetinde. Dokununca ana arı kartı açılır.
class OldQueensScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.oldQueensTitle)),
      body: switch (ref.watch(oldQueensProvider)) {
        AsyncData(value: []) => ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            EmptyState(
              icon: Icons.workspace_premium_outlined,
              title: l10n.oldQueensEmptyTitle,
              message: l10n.oldQueensEmptyMessage(queenReplacementAge),
            ),
          ],
        ),
        AsyncData(value: final entries) => ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text(
              l10n.oldQueensIntro(queenReplacementAge),
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.lg),
            _OldQueenList(entries),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.hivesLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _OldQueenList extends ConsumerWidget {
  const new(this.entries);

  final List<HiveQueen> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final currentYear = clock.now().year;
    final apiaries = {
      for (final summary
          in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
        summary.apiary.id: summary.apiary.name,
    };

    return ListGroup(
      children: [
        for (final (:hive, :queen) in entries)
          _OldQueenRow(
            title: [
              l10n.hiveLabel(hive.number),
              ?apiaries[hive.apiaryId],
            ].join(l10n.titleSeparator),
            subtitle: queen.title(l10n),
            age: l10n.queenAge(queenAge(queen.year!, currentYear: currentYear)),
            onTap: () =>
                context.go(AppRoutes.hiveQueen(hive.apiaryId, hive.id)),
          ),
      ],
    );
  }
}

/// Kovan ve arılık, altında ananın yılı ve rengi, en altta yaş uyarı
/// rozetinde. Rozet dar ekranda ve büyük yazıda sığsın diye yanda değil
/// altta.
class _OldQueenRow extends StatelessWidget {
  const new({
    required this.title,
    required this.subtitle,
    required this.age,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final String age;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return MergeSemantics(
      child: InkWell(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: spacing.lg,
              vertical: spacing.md,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: context.typography.body),
                      Text(
                        subtitle,
                        style: context.typography.bodySmall.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                      SizedBox(height: spacing.sm),
                      StatusBadge(status: AppStatus.warning, label: age),
                    ],
                  ),
                ),
                SizedBox(width: spacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  size: context.sizes.icon,
                  color: colors.textSecondary,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

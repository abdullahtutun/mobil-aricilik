import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';
import 'package:mobil_arici/features/today/presentation/today_providers.dart';
import 'package:mobil_arici/features/today/presentation/widgets/attention_labels.dart';

/// "Dikkat isteyenler"in bir grubu: kovan ve arılık, altında nedeninin
/// kaynağı (son muayene ya da çıkarma günü). Dokununca kovan kartı açılır.
/// Liste yerel DB'den gelir; kovan gruptan çıkınca kendiliğinden düşer.
class AttentionScreen extends ConsumerWidget {
  const new({required this.kind, super.key});

  final AttentionKind kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: Text(kind.title(l10n))),
      body: switch (ref.watch(todayAttentionProvider)) {
        AsyncData(:final value) => ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text(
              kind.intro(l10n),
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.lg),
            if (value[kind] case final entries? when entries.isNotEmpty)
              _AttentionList(entries)
            else
              EmptyState(
                icon: Icons.check_circle_outline_rounded,
                title: l10n.attentionEmpty,
                message: l10n.todayAttentionNone,
              ),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.hivesLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }
}

class _AttentionList extends ConsumerWidget {
  const new(this.entries);

  final List<AttentionEntry> entries;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final apiaries = ref.watch(apiaryNamesProvider).value ?? const {};

    return ListGroup(
      children: [
        for (final (:hive, :inspection, :removalDueAt) in entries)
          _AttentionRow(
            title: [
              l10n.hiveLabel(hive.number),
              ?apiaries[hive.apiaryId],
            ].join(l10n.titleSeparator),
            subtitle: [
              if (inspection != null) ...[
                if (strengthScore(inspection.values) case final score?)
                  l10n.hiveTileStrength(score),
                l10n.attentionLastInspection(
                  format.date(inspection.inspectedAt.toLocal()),
                ),
              ],
              if (removalDueAt != null)
                l10n.attentionRemovalDue(format.date(removalDueAt.toLocal())),
            ].join(l10n.titleSeparator),
            onTap: () => context.go(AppRoutes.hive(hive.apiaryId, hive.id)),
          ),
      ],
    );
  }
}

/// Kovan ve arılık, altında neden; sağda ok.
class _AttentionRow extends StatelessWidget {
  const new({required this.title, required this.subtitle, required this.onTap});

  final String title;
  final String subtitle;
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

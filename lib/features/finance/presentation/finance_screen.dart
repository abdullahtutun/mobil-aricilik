import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';

/// Finans (docs/design "Finans"): üstte koyu sezon kartı (net, gelir,
/// gider, kovan başı maliyet), altında son hareketler; en altta hızlı
/// "− Gider" ve "+ Gelir". Harekete dokununca ayrıntısı açılır.
class FinanceScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.financeYearTitle('${clock.now().year}'))),
      body: BottomActionLayout(
        separated: true,
        body: switch (ref.watch(transactionRowsProvider)) {
          AsyncData(value: final rows) => ListView(
            padding: EdgeInsets.all(spacing.lg),
            children: [
              const _SeasonCard(),
              SizedBox(height: spacing.xl),
              if (rows.isEmpty)
                EmptyState(
                  icon: Icons.account_balance_wallet_outlined,
                  title: l10n.financeEmptyTitle,
                  message: l10n.financeEmptyMessage,
                )
              else ...[
                SectionLabel(l10n.financeRecent),
                SizedBox(height: spacing.sm),
                _TransactionList(rows),
              ],
            ],
          ),
          AsyncError() => Center(child: Text(l10n.financeLoadError)),
          // Yerel DB'den okunuyor; hemen gelir.
          AsyncValue() => const SizedBox.shrink(),
        },
        action: Row(
          spacing: context.touchTargets.gap,
          children: [
            Expanded(
              child: BigButton(
                label: l10n.financeAddExpense,
                variant: BigButtonVariant.secondary,
                onPressed: () =>
                    context.go(AppRoutes.financeNew(TransactionKind.expense)),
              ),
            ),
            Expanded(
              child: BigButton(
                label: l10n.financeAddIncome,
                onPressed: () =>
                    context.go(AppRoutes.financeNew(TransactionKind.income)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Ters zeminde sezon neti (büyük, bal sarısı) ve altında gelir, gider,
/// kovan başı maliyet. Dar ekranda ve büyük yazıda üçlü alt alta kayar.
class _SeasonCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final currency = ref.watch(financeCurrencyProvider);
    final season = ref.watch(financeSeasonProvider).value;
    if (currency == null || season == null) return const SizedBox.shrink();

    String money(double amount) => financeMoney(context, amount, currency);
    final net = season.net < 0
        ? l10n.financeMinus(money(-season.net))
        : l10n.financePlus(money(season.net));
    final costPerHive = season.costPerHive;
    final labelStyle = context.typography.label.copyWith(
      color: colors.onInverseSurface,
    );
    final valueStyle = context.typography.subtitle.copyWith(
      color: colors.onInverseSurface,
      fontWeight: context.typography.title.fontWeight,
    );

    Widget figure(String label, String value) => MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: labelStyle),
          Text(value, style: valueStyle),
        ],
      ),
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.inverseSurface,
        borderRadius: BorderRadius.circular(context.radii.card),
      ),
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MergeSemantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppFormat.of(context).upperCase(l10n.financeSeasonNet),
                    style: labelStyle,
                  ),
                  Text(
                    net,
                    style: context.typography.numberLarge.copyWith(
                      color: colors.inversePrimary,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: spacing.lg),
            Wrap(
              spacing: spacing.xl,
              runSpacing: spacing.md,
              children: [
                figure(l10n.financeIncome, money(season.income)),
                figure(l10n.financeExpense, money(season.expense)),
                figure(
                  l10n.financeCostPerHive,
                  costPerHive == null ? '–' : money(_cents(costPerHive)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Kovan başı maliyet kuruşa yuvarlı; küsuratsızsa kuruşsuz yazılır.
  static double _cents(double value) => (value * 100).round() / 100;
}

class _TransactionList extends ConsumerWidget {
  const new(this.rows);

  final List<TransactionRow> rows;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    return ListGroup(
      children: [
        for (final row in rows)
          ListRow(
            title: financeRowTitle(l10n, row.transaction),
            subtitle: financeRowSubtitle(ref, context, row),
            value: financeSignedMoney(context, row.transaction),
            valueColor: row.transaction.kind == TransactionKind.income
                ? colors.statusGood
                : colors.textPrimary,
            onTap: () =>
                context.go(AppRoutes.financeTransaction(row.transaction.id)),
          ),
      ],
    );
  }
}

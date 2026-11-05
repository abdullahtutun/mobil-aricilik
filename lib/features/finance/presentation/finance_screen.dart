import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/finance/data/transaction_repository.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';

/// Finans (docs/design "Finans"): üstte koyu sezon kartı (net, gelir,
/// gider, kovan başı maliyet), konaklama kârlılığı (arılık başı net),
/// alacak ve müşteri defteri kartı, son hareketler; en altta hızlı
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
              const _ProfitCard(),
              SizedBox(height: spacing.lg),
              const _ReceivablesCard(),
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
/// Başka para biriminde hareket varsa (para birimi değişmeden önceki
/// kayıtlar) netleri altta para birimine göre ayrı yazılır, toplanmaz.
class _SeasonCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final currency = ref.watch(financeCurrencyProvider);
    final season = ref.watch(financeSeasonProvider).value;
    final others = ref.watch(financeOtherCurrenciesProvider).value ?? const {};
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
            if (others.isNotEmpty) ...[
              SizedBox(height: spacing.lg),
              Text(l10n.financeOtherCurrencies, style: labelStyle),
              for (final MapEntry(key: code, value: other) in others.entries)
                MergeSemantics(
                  child: Text(
                    l10n.financeOtherCurrencyLine(
                      code,
                      other.net < 0
                          ? l10n.financeMinus(
                              financeMoney(context, -other.net, code),
                            )
                          : l10n.financePlus(
                              financeMoney(context, other.net, code),
                            ),
                    ),
                    style: valueStyle,
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }

  /// Kovan başı maliyet kuruşa yuvarlı; küsuratsızsa kuruşsuz yazılır.
  static double _cents(double value) => (value * 100).round() / 100;
}

/// Konaklama kârlılığı: bu sezon arılık başı net, büyük önce; çubuk en
/// büyük tutara göre. Kâr yeşil "+", zarar kırmızı "−" ve ikonla. Arılığa
/// bağlanabilen hareket yoksa kart yok.
class _ProfitCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final currency = ref.watch(financeCurrencyProvider);
    final profits = ref.watch(apiaryProfitListProvider).value ?? const [];
    if (currency == null || profits.isEmpty) return const SizedBox.shrink();
    final apiaries = ref.watch(apiaryListProvider).value;
    final names = {
      for (final item in apiaries ?? const <ApiarySummary>[])
        item.apiary.id: item.apiary.name,
    };
    final largest = profits.fold<double>(
      0,
      (max, p) => p.net.abs() > max ? p.net.abs() : max,
    );

    return Padding(
      padding: EdgeInsets.only(top: spacing.lg),
      child: SectionCard(
        title: l10n.financeProfitTitle,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          spacing: spacing.md,
          children: [
            for (final profit in profits)
              _ProfitRow(
                name: names[profit.apiaryId] ?? l10n.financeProfitUnknownApiary,
                value: profit.net < 0
                    ? l10n.financeMinus(
                        financeMoney(context, -profit.net, currency),
                      )
                    : l10n.financePlus(
                        financeMoney(context, profit.net, currency),
                      ),
                loss: profit.net < 0,
                fill: largest == 0 ? 0 : profit.net.abs() / largest,
                color: profit.net < 0
                    ? colors.statusCritical
                    : colors.statusGood,
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfitRow extends StatelessWidget {
  const new({
    required this.name,
    required this.value,
    required this.loss,
    required this.fill,
    required this.color,
  });

  final String name;
  final String value;
  final bool loss;
  final double fill;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.xs,
        children: [
          Row(
            children: [
              Expanded(child: Text(name, style: context.typography.body)),
              SizedBox(width: spacing.sm),
              Icon(
                loss ? Icons.trending_down_rounded : Icons.trending_up_rounded,
                size: context.sizes.iconSmall,
                color: color,
              ),
              SizedBox(width: spacing.xs),
              Text(
                value,
                style: context.typography.label.copyWith(color: color),
              ),
            ],
          ),
          ExcludeSemantics(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(context.radii.pill),
              child: LinearProgressIndicator(
                value: fill,
                minHeight: spacing.md,
                color: color,
                backgroundColor: context.colors.divider,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Alacak özeti ve müşteri defterine geçiş: "₺24.500 alacak · 4 müşteri";
/// alacak yoksa "Alacak yok".
class _ReceivablesCard extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final currency = ref.watch(financeCurrencyProvider);
    final summary = ref.watch(receivablesProvider).value;
    final owed = summary != null && currency != null && summary.total > 0;
    final status = owed ? AppStatus.warning : null;
    final tone = status?.colorIn(colors) ?? colors.textPrimary;

    return MergeSemantics(
      child: AppCard(
        status: status,
        onTap: () => context.go(AppRoutes.customers),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: context.touchTargets.field),
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Wrap(
              spacing: spacing.md,
              runSpacing: spacing.sm,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (status != null) ...[
                      Icon(
                        status.icon,
                        size: context.sizes.iconSmall,
                        color: tone,
                      ),
                      SizedBox(width: spacing.xs),
                    ],
                    Flexible(
                      child: Text(
                        owed
                            ? l10n.financeReceivables(
                                financeMoney(context, summary.total, currency),
                                summary.customers,
                              )
                            : l10n.customerNoReceivable,
                        style: context.typography.label.copyWith(color: tone),
                      ),
                    ),
                  ],
                ),
                Text(
                  l10n.customersTitle,
                  style: context.typography.label.copyWith(
                    color: owed ? tone : colors.primary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
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

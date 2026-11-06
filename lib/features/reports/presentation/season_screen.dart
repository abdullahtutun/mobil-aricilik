import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/print_service_provider.dart';
import 'package:mobil_arici/core/services/share_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/csv.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';
import 'package:mobil_arici/features/reports/presentation/pdf/season_pdf.dart';
import 'package:mobil_arici/features/reports/presentation/season_providers.dart';
import 'package:mobil_arici/features/reports/presentation/widgets/season_labels.dart';

/// Sezon raporu (docs/design "Sezon raporu"): bu takvim yılının kovan
/// sayısı değişimi, kış kaybı (önceki kışla), toplam bal ve yeni analar;
/// kayıplar ve nedenleri; kış kaybının mücadele yöntemine, arılığa ve ana
/// hattına göre karşılaştırması; owner ve partner'da maliyet ve kâr.
/// Üstte "PDF" yazdırma ekranını (orada PDF olarak kaydet de var), tablo
/// ikonu CSV'yi (Excel) paylaşma sayfasını açar. Her şey yerel DB'den,
/// cihazda.
class SeasonScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<SeasonScreen> createState() => _SeasonScreenState();
}

class _SeasonScreenState extends ConsumerState<SeasonScreen> {
  final int _year = clock.now().year;

  /// Dışa aktarılırken butonlar pasif.
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final report = ref.watch(seasonReportDataProvider(_year));
    final ready = report.value != null && !_busy;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.seasonTitle('$_year')),
        actions: [
          IconButton(
            tooltip: l10n.seasonExportCsv,
            icon: const Icon(Icons.table_view_outlined),
            onPressed: ready ? () => _exportCsv(report.requireValue!) : null,
          ),
          TextButton(
            onPressed: ready ? () => _exportPdf(report.requireValue!) : null,
            child: Text(l10n.seasonPdf),
          ),
        ],
      ),
      body: switch (report) {
        AsyncData(value: final report?) => ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            _Tiles(report),
            SizedBox(height: spacing.lg),
            _LossCard(report),
            SizedBox(height: spacing.lg),
            _WinterCard(report),
            _FinanceCard(year: _year),
          ],
        ),
        AsyncError() => Center(child: Text(l10n.seasonLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        AsyncValue() => const SizedBox.shrink(),
      },
    );
  }

  Map<String, String> _apiaryNames() => {
    for (final item
        in ref.read(apiaryListProvider).value ?? const <ApiarySummary>[])
      item.apiary.id: item.apiary.name,
  };

  Future<void> _exportPdf(SeasonReport report) async {
    final l10n = AppLocalizations.of(context);
    // PDF'i basılamayan dilde (Hintçe) İngilizce.
    final pdfL10n = lookupAppLocalizations(
      AppLanguage.pdfLanguageFor(
        Localizations.localeOf(context).languageCode,
      ).locale!,
    );
    final region = ref.read(regionConfigProvider);
    final organization = ref.read(currentOrganizationProvider).value;
    final currency = ref.read(financeCurrencyProvider);
    final title = pdfL10n.seasonTitle('${report.year}');

    setState(() => _busy = true);
    try {
      final summary = await ref.read(seasonFinanceProvider(_year).future);
      final bytes = await buildSeasonPdf(
        report,
        organizationName: organization?.name ?? '',
        apiaryNames: _apiaryNames(),
        finance: switch ((summary, currency)) {
          (final summary?, final currency?) => (
            summary: summary,
            currency: currency,
          ),
          _ => null,
        },
        createdAt: clock.now(),
        l10n: pdfL10n,
        massUnit: region.defaultUnits.mass,
      );
      await ref.read(printServiceProvider).printPdf(bytes, name: title);
    } on Exception {
      if (mounted) showMessageSnackBar(context, l10n.seasonExportError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _exportCsv(SeasonReport report) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    try {
      final bytes = encodeCsv(
        seasonCsvRows(report, l10n: l10n, apiaryNames: _apiaryNames()),
        separator: seasonCsvSeparator(l10n),
      );
      await ref
          .read(shareServiceProvider)
          .shareFile(
            bytes,
            filename: csvFileName(l10n.seasonTitle('${report.year}')),
            mimeType: 'text/csv',
          );
    } on Exception {
      if (mounted) showMessageSnackBar(context, l10n.seasonExportError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// İki sütunlu dört karo: kovan, kış kaybı, toplam bal, yeni ana.
class _Tiles extends ConsumerWidget {
  const new(this.report);

  final SeasonReport report;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final gap = context.spacing.md;
    final mass = ref.watch(
      regionConfigProvider.select((region) => region.defaultUnits.mass),
    );
    final winter = report.winter;
    final previous = report.previousWinter;

    Widget row(Widget left, Widget right) => IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: gap,
        children: [
          Expanded(child: left),
          Expanded(child: right),
        ],
      ),
    );

    return Column(
      spacing: gap,
      children: [
        row(
          SummaryTile(
            label: l10n.seasonHives,
            value: l10n.seasonHiveChange(
              report.hivesAtStart,
              report.hivesAtEnd,
            ),
            detail: report.net(l10n),
          ),
          SummaryTile(
            label: l10n.seasonWinterLoss,
            value: winter == null ? '–' : winterRate(format, winter),
            detail: switch ((winter, previous)) {
              (null, _) => l10n.seasonWinterNotStarted,
              (_, final previous?) when previous.hives > 0 =>
                l10n.seasonPreviousWinterRate(
                  '${report.year - 1}',
                  winterRate(format, previous),
                ),
              (final winter?, _) => l10n.seasonHiveCount(winter.hives),
            },
          ),
        ),
        row(
          SummaryTile(
            label: l10n.seasonHoney,
            value: report.honey(l10n, format, mass),
          ),
          SummaryTile(
            label: l10n.seasonNewQueens,
            value: format.number(report.newQueens),
            detail: l10n.seasonOwnReared(report.ownRearedQueens),
          ),
        ),
      ],
    );
  }
}

/// "Kayıplar ve nedenleri": nedene göre kayıp sayısı, çok olan önce;
/// çubuk en büyük sayıya göre.
class _LossCard extends StatelessWidget {
  const new(this.report);

  final SeasonReport report;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final largest = report.losses.firstOrNull?.count ?? 0;

    return SectionCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.md,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Semantics(
                  header: true,
                  child: Text(
                    l10n.seasonLossesTitle,
                    style: context.typography.subtitle,
                  ),
                ),
              ),
              SizedBox(width: spacing.sm),
              Text(
                l10n.seasonHiveCount(report.lossTotal),
                style: context.typography.label,
              ),
            ],
          ),
          if (report.losses.isEmpty)
            Text(l10n.seasonNoLosses, style: context.typography.body)
          else
            for (final loss in report.losses)
              _BarRow(
                label: hiveLossReasonLabel(l10n, loss.reason),
                value: '${loss.count}',
                fill: loss.count / largest,
                color: context.colors.statusCritical,
              ),
        ],
      ),
    );
  }
}

/// Kış kaybı karşılaştırması: sekmeyle mücadele yöntemi, arılık ya da ana
/// hattı; düşük kayıp önce. Genel orandan düşük olan iyi (yeşil, ↘),
/// yüksek olan kötü (kırmızı, ↗). Altta "yanıltıcı olabilir" notu.
class _WinterCard extends ConsumerStatefulWidget {
  const new(this.report);

  final SeasonReport report;

  @override
  ConsumerState<_WinterCard> createState() => _WinterCardState();
}

class _WinterCardState extends ConsumerState<_WinterCard> {
  WinterComparison _axis = WinterComparison.treatment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final format = AppFormat.of(context);
    final names = {
      for (final item
          in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
        item.apiary.id: item.apiary.name,
    };
    final groups = widget.report.comparison(_axis, l10n, names);
    final overall = widget.report.winter?.rate;

    return SectionCard(
      title: winterComparisonTitle(l10n, _axis),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.md,
        children: [
          SegmentedTabs<WinterComparison>(
            expanded: true,
            options: [
              SegmentOption(
                value: WinterComparison.treatment,
                label: l10n.seasonTabTreatment,
              ),
              SegmentOption(
                value: WinterComparison.apiary,
                label: l10n.seasonTabApiary,
              ),
              SegmentOption(
                value: WinterComparison.queenLine,
                label: l10n.seasonTabQueenLine,
              ),
            ],
            selected: _axis,
            onChanged: (axis) => setState(() => _axis = axis),
          ),
          if (groups.isEmpty)
            Text(l10n.seasonNoWinterData, style: context.typography.body)
          else
            for (final group in groups)
              _BarRow(
                label: group.label,
                subtitle: winterGroupHives(l10n, group.loss),
                value: winterRate(format, group.loss),
                fill: group.loss.rate ?? 0,
                better: overall == null || (group.loss.rate ?? 0) <= overall,
                color: overall == null || (group.loss.rate ?? 0) <= overall
                    ? colors.statusGood
                    : colors.statusCritical,
              ),
          Text(
            l10n.seasonMisleadingNote,
            style: context.typography.bodySmall.copyWith(
              color: colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Owner ve partner'da sezonun geliri, gideri, kârı ve kovan başı
/// maliyeti; finansı göremeyen rolde kart yok.
class _FinanceCard extends ConsumerWidget {
  const new({required this.year});

  final int year;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final summary = ref.watch(seasonFinanceProvider(year)).value;
    final currency = ref.watch(financeCurrencyProvider);
    if (summary == null || currency == null) return const SizedBox.shrink();
    String money(double amount) => financeMoney(context, amount, currency);
    final costPerHive = summary.costPerHive;

    return Padding(
      padding: EdgeInsets.only(top: context.spacing.lg),
      child: SectionCard(
        title: l10n.seasonFinanceTitle,
        child: ListGroup(
          children: [
            ListRow(title: l10n.financeIncome, value: money(summary.income)),
            ListRow(title: l10n.financeExpense, value: money(summary.expense)),
            ListRow(
              title: l10n.seasonProfit,
              value: _signed(l10n, summary, money),
              valueColor: summary.net < 0
                  ? colors.statusCritical
                  : colors.statusGood,
            ),
            ListRow(
              title: l10n.financeCostPerHive,
              value: costPerHive == null
                  ? '–'
                  : money((costPerHive * 100).round() / 100),
            ),
          ],
        ),
      ),
    );
  }

  static String _signed(
    AppLocalizations l10n,
    SeasonSummary summary,
    String Function(double amount) money,
  ) => summary.net < 0
      ? l10n.financeMinus(money(-summary.net))
      : l10n.financePlus(money(summary.net));
}

/// Etiket, çubuk ve sağda değer; altta isteğe bağlı alt yazı. [better]
/// verilirse değerin önünde yön ikonu (renk tek başına anlam taşımaz).
class _BarRow extends StatelessWidget {
  const new({
    required this.label,
    required this.value,
    required this.fill,
    required this.color,
    this.subtitle,
    this.better,
  });

  final String label;
  final String? subtitle;
  final String value;
  final double fill;
  final Color color;
  final bool? better;

  @override
  Widget build(BuildContext context) {
    final spacing = context.spacing;
    final subtitle = this.subtitle;
    final better = this.better;
    return MergeSemantics(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.xs,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(label, style: context.typography.body),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        style: context.typography.bodySmall.copyWith(
                          color: context.colors.textSecondary,
                        ),
                      ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              if (better != null) ...[
                Icon(
                  better
                      ? Icons.trending_down_rounded
                      : Icons.trending_up_rounded,
                  size: context.sizes.iconSmall,
                  color: color,
                ),
                SizedBox(width: spacing.xs),
              ],
              Text(value, style: context.typography.label),
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

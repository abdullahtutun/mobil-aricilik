import 'dart:typed_data';

import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';
import 'package:mobil_arici/features/reports/presentation/pdf/report_pdf.dart';
import 'package:mobil_arici/features/reports/presentation/widgets/season_labels.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Sezon raporunun maliyet ve kârı; tutarlar `currency` ile yazılır.
typedef SeasonPdfFinance = ({SeasonSummary summary, String currency});

/// Sezon raporunun PDF'i; dikey A4, cihazda üretilir, ağ gerekmez.
Future<Uint8List> buildSeasonPdf(
  SeasonReport report, {
  required String organizationName,
  required Map<String, String> apiaryNames,
  required SeasonPdfFinance? finance,
  required DateTime createdAt,
  required AppLocalizations l10n,
  required MassUnit massUnit,
}) async {
  final document = seasonDocument(
    report,
    organizationName: organizationName,
    apiaryNames: apiaryNames,
    finance: finance,
    createdAt: createdAt,
    l10n: l10n,
    massUnit: massUnit,
    theme: await interPdfTheme(),
  );
  return await document.save();
}

/// [buildSeasonPdf]'in belgesi; testler buradan okur. Üstte özet tablosu,
/// kayıplar ve nedenleri, kış kaybı karşılaştırmaları (mücadele yöntemi,
/// arılık, ana hattı) ve varsa maliyet ve kâr.
pw.Document seasonDocument(
  SeasonReport report, {
  required String organizationName,
  required Map<String, String> apiaryNames,
  required SeasonPdfFinance? finance,
  required DateTime createdAt,
  required AppLocalizations l10n,
  required MassUnit massUnit,
  required pw.ThemeData theme,
}) {
  final format = AppFormat(l10n.localeName);
  final title = l10n.seasonTitle('${report.year}');
  final document = pw.Document(
    title: title,
    author: organizationName,
    theme: theme,
  );

  pw.Widget heading(String text) => pw.Header(
    text: text,
    textStyle: const pw.TextStyle(
      fontSize: ReportPdfStyle.headingSize,
      fontWeight: pw.FontWeight.bold,
    ),
    decoration: const pw.BoxDecoration(),
    margin: const pw.EdgeInsets.only(
      top: ReportPdfStyle.gap,
      bottom: ReportPdfStyle.cellPadding,
    ),
  );
  pw.Widget paragraph(String text) => pw.Text(
    text,
    style: const pw.TextStyle(fontSize: ReportPdfStyle.bodySize),
  );
  String money(double amount) => format.currency(
    amount,
    currencyCode: finance!.currency,
    decimalDigits: amount == amount.roundToDouble() ? 0 : null,
  );

  final winter = report.winter;
  final previous = report.previousWinter;

  document.addPage(
    pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(ReportPdfStyle.margin),
      footer: (context) => reportPdfFooter(context, l10n, format, createdAt),
      build: (context) => [
        pw.Text(
          title,
          style: const pw.TextStyle(
            fontSize: ReportPdfStyle.titleSize,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        pw.SizedBox(height: ReportPdfStyle.cellPadding),
        paragraph(organizationName),
        pw.SizedBox(height: ReportPdfStyle.gap),
        reportPdfTable(
          headers: [l10n.seasonPdfFigure, l10n.seasonPdfValue],
          widths: const [2, 3],
          rows: [
            [
              l10n.seasonHives,
              l10n.seasonPdfHiveChange(
                report.hivesAtStart,
                report.hivesAtEnd,
                report.net(l10n),
              ),
            ],
            [l10n.seasonHoney, report.honey(l10n, format, massUnit)],
            [
              l10n.seasonNewQueens,
              l10n.seasonPdfNewQueens(report.newQueens, report.ownRearedQueens),
            ],
            [
              l10n.seasonWinterLoss,
              if (winter == null)
                l10n.seasonWinterNotStarted
              else
                l10n.seasonPdfWinterLoss(
                  winterRate(format, winter),
                  winter.lost,
                  winter.hives,
                ),
            ],
            if (previous != null && previous.hives > 0)
              [
                l10n.seasonPreviousWinter('${report.year - 1}'),
                winterRate(format, previous),
              ],
          ],
        ),
        heading(l10n.seasonLossesTitle),
        if (report.losses.isEmpty)
          paragraph(l10n.seasonNoLosses)
        else
          reportPdfTable(
            headers: [l10n.seasonPdfReason, l10n.seasonPdfHives],
            widths: const [3, 1],
            rows: [
              for (final loss in report.losses)
                [hiveLossReasonLabel(l10n, loss.reason), '${loss.count}'],
              [l10n.seasonPdfTotal, '${report.lossTotal}'],
            ],
          ),
        for (final axis in WinterComparison.values) ...[
          heading(winterComparisonTitle(l10n, axis)),
          switch (report.comparison(axis, l10n, apiaryNames)) {
            [] => paragraph(l10n.seasonNoWinterData),
            final groups => reportPdfTable(
              headers: [
                l10n.seasonPdfGroup,
                l10n.seasonPdfHives,
                l10n.seasonPdfLost,
                l10n.seasonPdfRate,
              ],
              widths: const [3, 1, 1, 1],
              rows: [
                for (final group in groups)
                  [
                    if (group.loss.isSmall)
                      '${group.label} (${l10n.seasonFewData})'
                    else
                      group.label,
                    '${group.loss.hives}',
                    '${group.loss.lost}',
                    winterRate(format, group.loss),
                  ],
              ],
            ),
          },
        ],
        pw.SizedBox(height: ReportPdfStyle.cellPadding),
        pw.Text(
          l10n.seasonMisleadingNote,
          style: const pw.TextStyle(
            fontSize: ReportPdfStyle.smallSize,
            color: ReportPdfStyle.muted,
          ),
        ),
        if (finance != null) ...[
          heading(l10n.seasonFinanceTitle),
          reportPdfTable(
            headers: [l10n.seasonPdfFigure, l10n.seasonPdfValue],
            widths: const [2, 3],
            rows: [
              [l10n.financeIncome, money(finance.summary.income)],
              [l10n.financeExpense, money(finance.summary.expense)],
              [
                l10n.seasonProfit,
                if (finance.summary.net < 0)
                  l10n.financeMinus(money(-finance.summary.net))
                else
                  l10n.financePlus(money(finance.summary.net)),
              ],
              [
                l10n.financeCostPerHive,
                switch (finance.summary.costPerHive) {
                  final cost? => money((cost * 100).round() / 100),
                  null => '–',
                },
              ],
            ],
          ),
        ],
      ],
    ),
  );
  return document;
}

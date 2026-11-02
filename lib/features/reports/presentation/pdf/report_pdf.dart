import 'dart:typed_data';

import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/harvest_labels.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_labels.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// PDF'in başlığındaki işletme bilgisi.
typedef ReportHeader = ({
  String organizationName,

  /// Basılacak kayıt numaraları, her biri hazır metin ("AKS no 123");
  /// boşsa satır yazılmaz.
  List<String> registrations,
});

/// Kâğıt ölçüleri ve yazı boyutları (pt); ekran tokenı değil.
abstract final class ReportPdfStyle {
  static const double margin = 15 * PdfPageFormat.mm;
  static const double titleSize = 18;
  static const double headingSize = 12;
  static const double bodySize = 9;
  static const double smallSize = 8;
  static const double cellPadding = 4;
  static const double gap = 4 * PdfPageFormat.mm;

  /// Kâğıtta tablo çizgisi ve başlık satırının zemini; siyah beyaz
  /// yazıcıda da görünür.
  static const PdfColor rule = PdfColors.grey600;
  static const PdfColor headerFill = PdfColors.grey200;
  static const PdfColor muted = PdfColors.grey700;
}

/// Raporun başlığı ve dosya adı.
String reportTitle(AppLocalizations l10n, ReportKind kind) => switch (kind) {
  ReportKind.treatmentRegister => l10n.pdfTreatmentRegisterTitle,
  ReportKind.hiveHistory => l10n.pdfHiveHistoryTitle,
};

/// [data] raporunun PDF'i; A4, cihazda üretilir, ağ gerekmez. Metinler
/// [l10n]'un dilinde (uygulamanın dilinden bağımsız seçilebilir).
Future<Uint8List> buildReportPdf(
  ReportData data, {
  required ReportHeader header,
  required ReportPeriod period,
  required String? apiaryName,
  required DateTime createdAt,
  required AppLocalizations l10n,
  required DefaultUnits units,
}) async {
  final document = reportDocument(
    data,
    header: header,
    period: period,
    apiaryName: apiaryName,
    createdAt: createdAt,
    l10n: l10n,
    units: units,
    theme: await interPdfTheme(),
  );
  return await document.save();
}

/// [buildReportPdf]'in belgesi; testler sayfaları buradan sayar. İlaç
/// kayıt defteri yatay (sütunu çok), kovan geçmişi dikey A4. Başlık ilk
/// sayfada, tablo başlığı her sayfada; altta oluşturulma zamanı ve sayfa
/// numarası. [apiaryName] boşsa bütün arılıklar.
pw.Document reportDocument(
  ReportData data, {
  required ReportHeader header,
  required ReportPeriod period,
  required String? apiaryName,
  required DateTime createdAt,
  required AppLocalizations l10n,
  required DefaultUnits units,
  required pw.ThemeData theme,
}) {
  final format = AppFormat(l10n.localeName);
  final kind = switch (data) {
    TreatmentRegister() => ReportKind.treatmentRegister,
    HiveHistoryReport() => ReportKind.hiveHistory,
  };
  final title = reportTitle(l10n, kind);
  final document = pw.Document(
    title: title,
    author: header.organizationName,
    theme: theme,
  );
  final body = switch (data) {
    _ when data.isEmpty => [_paragraph(l10n.reportEmpty)],
    TreatmentRegister(:final entries) => [
      _treatmentTable(entries, data.apiaryNames, l10n, format),
    ],
    HiveHistoryReport(:final hives) => [
      for (final history in hives)
        ..._hiveSection(history, data.apiaryNames, l10n, format, units),
    ],
  };

  document.addPage(
    pw.MultiPage(
      pageFormat: switch (kind) {
        ReportKind.treatmentRegister => PdfPageFormat.a4.landscape,
        ReportKind.hiveHistory => PdfPageFormat.a4,
      },
      margin: const pw.EdgeInsets.all(ReportPdfStyle.margin),
      footer: (context) => reportPdfFooter(context, l10n, format, createdAt),
      build: (context) => [
        _header(
          title: title,
          header: header,
          period: period,
          apiaryName: apiaryName ?? l10n.reportAllApiaries,
          l10n: l10n,
          format: format,
        ),
        pw.SizedBox(height: ReportPdfStyle.gap),
        ...body,
      ],
    ),
  );
  return document;
}

pw.Widget _header({
  required String title,
  required ReportHeader header,
  required ReportPeriod period,
  required String apiaryName,
  required AppLocalizations l10n,
  required AppFormat format,
}) {
  const style = pw.TextStyle(fontSize: ReportPdfStyle.bodySize);
  return pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        title,
        style: const pw.TextStyle(
          fontSize: ReportPdfStyle.titleSize,
          fontWeight: pw.FontWeight.bold,
        ),
      ),
      pw.SizedBox(height: ReportPdfStyle.cellPadding),
      pw.Text(
        [
          header.organizationName,
          ...header.registrations,
        ].join(l10n.titleSeparator),
        style: style,
      ),
      pw.Text(
        [
          l10n.pdfPeriod(format.date(period.from), format.date(period.to)),
          l10n.pdfApiary(apiaryName),
        ].join(l10n.titleSeparator),
        style: style,
      ),
    ],
  );
}

/// Altta oluşturulma zamanı ve "Sayfa 1 / 2".
pw.Widget reportPdfFooter(
  pw.Context context,
  AppLocalizations l10n,
  AppFormat format,
  DateTime createdAt,
) {
  const style = pw.TextStyle(
    fontSize: ReportPdfStyle.smallSize,
    color: ReportPdfStyle.muted,
  );
  return pw.Padding(
    padding: const pw.EdgeInsets.only(top: ReportPdfStyle.gap),
    child: pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(l10n.pdfCreated(format.dateTime(createdAt)), style: style),
        pw.Text(
          l10n.pdfPage(context.pageNumber, context.pagesCount),
          style: style,
        ),
      ],
    ),
  );
}

pw.Widget _paragraph(String text) =>
    pw.Text(text, style: const pw.TextStyle(fontSize: ReportPdfStyle.bodySize));

pw.Widget _treatmentTable(
  List<TreatmentRegisterEntry> entries,
  Map<String, String> apiaryNames,
  AppLocalizations l10n,
  AppFormat format,
) => reportPdfTable(
  headers: [
    l10n.pdfColumnDate,
    l10n.pdfColumnApiary,
    l10n.pdfColumnProduct,
    l10n.pdfColumnHives,
    l10n.pdfColumnDose,
    l10n.pdfColumnRemoval,
    l10n.pdfColumnWithdrawalEnd,
  ],
  widths: const [1.1, 1.6, 2.6, 2.6, 1.2, 1.1, 1.1],
  rows: [
    for (final entry in entries)
      _treatmentRow(entry, apiaryNames, l10n, format),
  ],
);

List<String> _treatmentRow(
  TreatmentRegisterEntry entry,
  Map<String, String> apiaryNames,
  AppLocalizations l10n,
  AppFormat format,
) {
  final treatment = entry.treatment;
  final ingredient = treatment.activeIngredient.label(l10n);
  final details = [
    // Genel listedeki ilacın adı etken maddenin kendisi; iki kez yazılmaz.
    if (ingredient.toLowerCase() != treatment.productName.toLowerCase())
      ingredient,
    if (treatment.batchNo case final batch?) l10n.timelineTreatmentBatch(batch),
  ];
  return [
    format.shortDate(treatment.startedAt.toLocal()),
    apiaryNames[treatment.apiaryId] ?? l10n.timelineUnknownApiary,
    [
      treatment.productName,
      if (details.isNotEmpty) details.join(l10n.titleSeparator),
    ].join('\n'),
    [
      l10n.reportHiveCount(entry.hiveCount),
      if (entry.hiveNumbers.isNotEmpty)
        entry.hiveNumbers.join(l10n.listSeparator),
    ].join('\n'),
    l10n.treatmentDoseValue(
      format.number(treatment.dose),
      treatment.doseUnit.label(l10n),
    ),
    switch (treatment.plannedRemovalAt) {
      final removal? => format.shortDate(removal.toLocal()),
      null => l10n.reportNoValue,
    },
    format.shortDate(entry.withdrawalEnd),
  ];
}

List<pw.Widget> _hiveSection(
  HiveHistory history,
  Map<String, String> apiaryNames,
  AppLocalizations l10n,
  AppFormat format,
  DefaultUnits units,
) {
  String apiary(String id) => apiaryNames[id] ?? l10n.timelineUnknownApiary;
  final hive = history.hive;
  return [
    pw.Header(
      text: [
        l10n.hiveLabel(hive.number),
        apiary(hive.apiaryId),
      ].join(l10n.titleSeparator),
      textStyle: const pw.TextStyle(
        fontSize: ReportPdfStyle.headingSize,
        fontWeight: pw.FontWeight.bold,
      ),
      decoration: const pw.BoxDecoration(),
      margin: const pw.EdgeInsets.only(
        top: ReportPdfStyle.gap,
        bottom: ReportPdfStyle.cellPadding,
      ),
    ),
    if (history.items.isEmpty)
      _paragraph(l10n.reportEmpty)
    else
      reportPdfTable(
        headers: [
          l10n.pdfColumnDate,
          l10n.pdfColumnEvent,
          l10n.pdfColumnDetails,
        ],
        widths: const [1, 1.6, 4],
        rows: [
          for (final item in history.items)
            [
              format.shortDate(item.at.toLocal()),
              ..._historyCells(item, apiary, l10n, format, units),
            ],
        ],
      ),
  ];
}

/// Kaydın "Kayıt" ve "Ayrıntı" hücreleri.
List<String> _historyCells(
  HiveHistoryItem item,
  String Function(String id) apiary,
  AppLocalizations l10n,
  AppFormat format,
  DefaultUnits units,
) {
  String amount(double value, String unit) =>
      l10n.harvestWeightValue(format.number(value), unit);
  String join(List<String> parts) => parts.join(l10n.titleSeparator);

  return switch (item) {
    InspectionItem(:final inspection) => [
      l10n.timelineInspection,
      inspectionSummary(l10n, inspection.values).join('\n'),
    ],
    TreatmentItem(:final treatment) => [
      l10n.timelineTreatment(treatment.productName),
      treatmentSummary(l10n, format, treatment),
    ],
    FeedingItem(:final feeding) => [
      l10n.pdfEventFeeding,
      join([
        feeding.kind.label(l10n),
        if (feeding.kind.isSyrup)
          amount(
            VolumeUnit.liter.convert(feeding.amount, to: units.volume),
            units.volume.label(l10n),
          )
        else
          amount(
            MassUnit.kilogram.convert(feeding.amount, to: units.mass),
            units.mass.label(l10n),
          ),
      ]),
    ],
    MiteCountItem(:final count) => [
      l10n.pdfEventVarroa,
      join([
        count.method.label(l10n),
        if (miteLoadOf(count) case final load?) miteLoadText(l10n, load),
      ]),
    ],
    HarvestItem(:final harvest) => [
      l10n.pdfEventHarvest,
      join([
        harvest.honeyKind.label(l10n),
        l10n.pdfHarvestTotal(
          join([
            l10n.timelineField(
              harvest.unit.takenLabel(l10n),
              format.number(harvest.unitCount),
            ),
            amount(
              MassUnit.kilogram.convert(harvest.netKg, to: units.mass),
              units.mass.label(l10n),
            ),
          ]),
        ),
      ]),
    ],
    LocationItem(fromApiaryId: null, :final entry) => [
      l10n.timelineAdded,
      apiary(entry.apiaryId),
    ],
    LocationItem(:final fromApiaryId?, :final entry) => [
      l10n.timelineMoved,
      l10n.timelineMoveRoute(apiary(fromApiaryId), apiary(entry.apiaryId)),
    ],
  };
}

/// Çizgili tablo; başlık satırı her sayfada tekrar eder. [widths] sütunların
/// oranı.
pw.Widget reportPdfTable({
  required List<String> headers,
  required List<double> widths,
  required List<List<String>> rows,
}) {
  pw.Widget cell(String text, {bool bold = false}) => pw.Padding(
    padding: const pw.EdgeInsets.all(ReportPdfStyle.cellPadding),
    child: pw.Text(
      text,
      style: pw.TextStyle(
        fontSize: ReportPdfStyle.bodySize,
        fontWeight: bold ? pw.FontWeight.bold : null,
      ),
    ),
  );

  return pw.Table(
    border: pw.TableBorder.all(color: ReportPdfStyle.rule, width: 0.5),
    columnWidths: {
      for (final (i, width) in widths.indexed) i: pw.FlexColumnWidth(width),
    },
    children: [
      pw.TableRow(
        repeat: true,
        decoration: const pw.BoxDecoration(color: ReportPdfStyle.headerFill),
        children: [for (final header in headers) cell(header, bold: true)],
      ),
      for (final row in rows)
        pw.TableRow(children: [for (final text in row) cell(text)]),
    ],
  );
}

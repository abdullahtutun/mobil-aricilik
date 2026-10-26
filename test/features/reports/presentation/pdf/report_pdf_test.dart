import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:mobil_arici/features/reports/presentation/pdf/report_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final _at = DateTime.utc(2026, 10, 24, 9);
final ReportPeriod _period = (from: DateTime(2026), to: DateTime(2026, 10, 24));

Treatment _treatment(int i) => Treatment(
  id: 't$i',
  orgId: 'org',
  hiveId: 'h$i',
  apiaryId: 'a1',
  productName: 'Amitraz şerit',
  activeIngredient: DrugActiveIngredient.amitraz,
  dose: 2,
  doseUnit: DrugDoseUnit.strip,
  startedAt: _at,
  withdrawalDays: 14,
  batchNo: '24-118',
  plannedRemovalAt: _at.add(const Duration(days: 42)),
  createdAt: _at,
  updatedAt: _at,
);

TreatmentRegister _register(int rows) => TreatmentRegister(
  entries: [
    for (var i = 0; i < rows; i++)
      TreatmentRegisterEntry(
        treatment: _treatment(i),
        hiveCount: 1,
        hiveNumbers: ['${101 + i}'],
      ),
  ],
  apiaryNames: const {'a1': 'Çamlık Yaylası'},
);

final _hive = Hive(
  id: 'h1',
  orgId: 'org',
  number: '104',
  type: HiveType.langstroth,
  apiaryId: 'a1',
  createdAt: _at,
  updatedAt: _at,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late pw.ThemeData theme;

  setUpAll(() async {
    // Uygulamada tarih verisini Material yerelleştirmesi yükler.
    await initializeDateFormatting();
    theme = await interPdfTheme();
  });

  pw.Document document(ReportData data, {Locale locale = const Locale('tr')}) =>
      reportDocument(
        data,
        header: (
          organizationName: 'Petek Arıcılık',
          registrations: const ['İşletme tescil no TR-48-0001', 'AKS no 12345'],
        ),
        period: _period,
        apiaryName: null,
        createdAt: _at,
        l10n: lookupAppLocalizations(locale),
        units: const DefaultUnits(),
        theme: theme,
      );

  Future<List<PdfPage>> pages(pw.Document document) async {
    // Sayfalar kaydederken dizilir.
    await document.save();
    return document.document.pdfPageList.pages;
  }

  test('ilaç kayıt defteri yatay A4', () async {
    final page = (await pages(document(_register(3)))).single;
    expect(page.pageFormat.width, PdfPageFormat.a4.height);
    expect(page.pageFormat.height, PdfPageFormat.a4.width);
  });

  test('uzun defter sayfalara bölünür', () async {
    expect((await pages(document(_register(120)))).length, greaterThan(2));
  });

  test('kovan geçmişi dikey A4; her kovan bir bölüm', () async {
    final report = HiveHistoryReport(
      hives: [
        (
          hive: _hive,
          items: [
            FeedingItem(
              Feeding(
                id: 'f1',
                orgId: 'org',
                hiveId: 'h1',
                apiaryId: 'a1',
                feedingGroupId: 'f1',
                fedAt: _at,
                kind: FeedingKind.syrup2to1,
                amount: 2,
                createdAt: _at,
                updatedAt: _at,
              ),
            ),
            TreatmentItem(_treatment(1)),
          ],
        ),
        (hive: _hive.copyWith(id: 'h2', number: '105'), items: const []),
      ],
      apiaryNames: const {'a1': 'Çamlık Yaylası'},
    );

    final page = (await pages(document(report, locale: const Locale('en'))))
        .single;
    expect(page.pageFormat.width, PdfPageFormat.a4.width);
  });

  test('kayıt yoksa tek sayfa; PDF baytları geçerli', () async {
    final empty = document(
      const TreatmentRegister(entries: [], apiaryNames: {}),
    );
    final bytes = await empty.save();
    expect(empty.document.pdfPageList.pages, hasLength(1));
    expect(ascii.decode(bytes.sublist(0, 5)), '%PDF-');
  });

  test('başlık PDF dilinde', () {
    final tr = lookupAppLocalizations(const Locale('tr'));
    final en = lookupAppLocalizations(const Locale('en'));
    expect(reportTitle(tr, ReportKind.treatmentRegister), 'İlaç Kayıt Defteri');
    expect(reportTitle(en, ReportKind.hiveHistory), 'Hive History');
  });
}

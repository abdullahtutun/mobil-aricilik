import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_config.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';
import 'package:mobil_arici/features/reports/presentation/pdf/season_pdf.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

final _at = DateTime(2024);

SeasonReport _report(int hives) => seasonReport(
  (
    hives: [
      for (var i = 0; i < hives; i++)
        Hive(
          id: 'h$i',
          orgId: 'org',
          number: '${100 + i}',
          type: HiveType.langstroth,
          apiaryId: 'a$i',
          createdAt: _at,
          updatedAt: _at,
        ),
    ],
    events: const [],
    locations: const [],
    queens: const [],
    harvests: const [],
    treatments: const [],
  ),
  year: 2026,
  hemisphere: Hemisphere.northern,
  now: DateTime(2026, 11, 2),
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late pw.ThemeData theme;

  setUpAll(() async {
    await initializeDateFormatting();
    theme = await interPdfTheme();
  });

  Future<List<PdfPage>> pages(
    SeasonReport report, {
    Locale locale = const Locale('tr'),
    SeasonPdfFinance? finance,
  }) async {
    final document = seasonDocument(
      report,
      organizationName: 'Petek Arıcılık',
      apiaryNames: const {},
      finance: finance,
      createdAt: DateTime(2026, 11, 2, 9),
      l10n: lookupAppLocalizations(locale),
      massUnit: MassUnit.kilogram,
      theme: theme,
    );
    await document.save();
    return document.document.pdfPageList.pages;
  }

  test('dikey A4; kayıtsız sezon tek sayfa', () async {
    final page = (await pages(_report(0))).single;
    expect(page.pageFormat.width, PdfPageFormat.a4.width);
  });

  test('maliyet ve kârla İngilizce de üretilir', () async {
    expect(
      await pages(
        _report(3),
        locale: const Locale('en'),
        finance: (
          summary: (
            income: 56000,
            expense: 17500.5,
            net: 38499.5,
            costPerHive: 5833.5,
          ),
          currency: 'TRY',
        ),
      ),
      hasLength(1),
    );
  });

  test('çok arılıklı karşılaştırma sayfalara bölünür', () async {
    expect((await pages(_report(120))).length, greaterThan(1));
  });
}

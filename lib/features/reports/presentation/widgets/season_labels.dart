import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/csv.dart';
import 'package:mobil_arici/core/utils/date_only.dart';
import 'package:mobil_arici/core/utils/units.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';

/// Kış kaybı karşılaştırmasının ekseni; ekranda sekme, PDF'te bölüm.
enum WinterComparison { treatment, apiary, queenLine }

/// Sezon raporunun ekranda ve PDF'te aynı yazılan metinleri.
extension SeasonReportLabels on SeasonReport {
  /// Toplam bal bölgenin ağırlık biriminde: "1.840 kg".
  String honey(AppLocalizations l10n, AppFormat format, MassUnit unit) =>
      l10n.harvestWeightValue(
        format.number(
          MassUnit.kilogram.convert(honeyKg, to: unit),
          maxFractionDigits: 0,
        ),
        unit.label(l10n),
      );

  /// "+12 net", "−3 net", "0 net".
  String net(AppLocalizations l10n) => switch (netChange) {
    > 0 => l10n.seasonNetGain(netChange),
    < 0 => l10n.seasonNetLoss(-netChange),
    _ => l10n.seasonNetSame,
  };

  /// Karşılaştırmanın grupları, etiketleriyle.
  List<({String label, WinterLoss loss})> comparison(
    WinterComparison axis,
    AppLocalizations l10n,
    Map<String, String> apiaryNames,
  ) => switch (axis) {
    WinterComparison.treatment => [
      for (final group in byTreatment)
        (label: treatmentMethodLabel(l10n, group.key), loss: group.loss),
    ],
    WinterComparison.apiary => [
      for (final group in byApiary)
        (
          label: apiaryNames[group.key] ?? l10n.timelineUnknownApiary,
          loss: group.loss,
        ),
    ],
    WinterComparison.queenLine => [
      for (final group in byQueenLine)
        (label: group.key ?? l10n.seasonQueenLineUnknown, loss: group.loss),
    ],
  };
}

/// "Amitraz + Oksalik asit"; boşsa "İlaçlanmadı".
String treatmentMethodLabel(AppLocalizations l10n, TreatmentMethod method) {
  if (method.isEmpty) return l10n.seasonUntreated;
  final ordered = method.toList()..sort((a, b) => a.index.compareTo(b.index));
  return ordered
      .map((ingredient) => ingredient.label(l10n))
      .join(l10n.seasonMethodSeparator);
}

/// Kayıp oranı yüzde; oran yoksa "–".
String winterRate(AppFormat format, WinterLoss? loss) => switch (loss?.rate) {
  final rate? => format.percent(rate),
  null => '–',
};

String winterComparisonTitle(AppLocalizations l10n, WinterComparison axis) =>
    switch (axis) {
      WinterComparison.treatment => l10n.seasonByTreatment,
      WinterComparison.apiary => l10n.seasonByApiary,
      WinterComparison.queenLine => l10n.seasonByQueenLine,
    };

/// Grubun alt yazısı: "12 kovan", azsa "4 kovan · az veri".
String winterGroupHives(AppLocalizations l10n, WinterLoss loss) => [
  l10n.seasonHiveCount(loss.hives),
  if (loss.isSmall) l10n.seasonFewData,
].join(l10n.titleSeparator);

/// Sezon raporunun CSV'si (Excel): kovan başına bir satır, başlık
/// satırıyla. Metinler [l10n]'un dilinde, ayraç o dilin Excel'ine göre.
List<List<String>> seasonCsvRows(
  SeasonReport report, {
  required AppLocalizations l10n,
  required Map<String, String> apiaryNames,
}) {
  final format = AppFormat(l10n.localeName);
  String apiary(String id) => apiaryNames[id] ?? l10n.timelineUnknownApiary;
  String yesNo({required bool value}) =>
      value ? l10n.seasonCsvYes : l10n.seasonCsvNo;
  final rows = [...report.hiveRows]
    ..sort((a, b) => a.hive.number.compareTo(b.hive.number));
  return [
    [
      l10n.seasonCsvHive,
      l10n.seasonCsvApiary,
      l10n.seasonCsvStartStatus,
      l10n.seasonCsvEndStatus,
      l10n.seasonCsvLossDate,
      l10n.seasonCsvLossReason,
      l10n.seasonCsvInWinter,
      l10n.seasonCsvLostInWinter,
      l10n.seasonCsvWinterApiary,
      l10n.seasonCsvTreatment,
      l10n.seasonCsvQueenLine,
    ],
    for (final row in rows)
      [
        row.hive.number,
        apiary(row.hive.apiaryId),
        row.startStatus?.label(l10n) ?? l10n.seasonCsvAddedInSeason,
        row.endStatus.label(l10n),
        switch (row.loss) {
          // Excel her dilde "2027-02-10"yi tarih olarak tanır.
          final loss? => formatDateOnly(loss.changedAt.toLocal()),
          null => '',
        },
        switch (row.loss) {
          final loss? => hiveLossReasonLabel(l10n, loss.lossReason),
          null => '',
        },
        yesNo(value: row.inWinter),
        if (row.inWinter) yesNo(value: row.lostInWinter) else '',
        if (row.inWinter) apiary(row.winterApiaryId) else '',
        if (row.inWinter) treatmentMethodLabel(l10n, row.method) else '',
        row.queenLine ?? '',
      ],
    // Boş satırdan sonra özet; Excel'de tablonun altında okunur.
    [],
    [l10n.seasonHives, '${report.hivesAtStart}', '${report.hivesAtEnd}'],
    [l10n.seasonLossesTitle, '${report.lossTotal}'],
    [
      l10n.seasonHoney,
      format.number(report.honeyKg),
      MassUnit.kilogram.label(l10n),
    ],
    [l10n.seasonNewQueens, '${report.newQueens}', '${report.ownRearedQueens}'],
    [l10n.seasonWinterLoss, winterRate(format, report.winter)],
  ];
}

/// [encodeCsv] için dilin ayracı.
String seasonCsvSeparator(AppLocalizations l10n) =>
    csvSeparatorFor(l10n.localeName);

import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/core/utils/xlsx.dart';
import 'package:mobil_arici/features/export/domain/export_data.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/finance/presentation/widgets/finance_labels.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/harvest_labels.dart';
import 'package:mobil_arici/features/health/domain/varroa_rules.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/health/presentation/widgets/varroa_labels.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/presentation/widgets/inspection_labels.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/inventory_labels.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_labels.dart';

/// Dışa aktarılan Excel'in sayfaları, arayüz dilinde: arılıklar, kovanlar,
/// ana arılar, muayeneler, beslemeler, ilaçlamalar, varroa ölçümleri,
/// hasatlar, görevler, stok ve (yetki varsa) gelir/gider. Kimlikler yerine
/// arılık adı ve kovan numarası, seçimli alanlar çevrilmiş adlarıyla
/// yazılır; boş alan boş hücredir. Durum kayıtları ada/numaraya göre, olay
/// kayıtları yeniden eskiye sıralanır.
List<XlsxSheet> exportSheets(ExportData data, AppLocalizations l10n) {
  final apiaryNames = {
    for (final apiary in data.apiaries) apiary.id: apiary.name,
  };
  final hives = {for (final hive in data.hives) hive.id: hive};
  final queenHives = {for (final hive in data.hives) ?hive.queenId: hive};
  final queens = {for (final queen in data.queens) queen.id: queen};

  String? yesNo({required bool? value}) => switch (value) {
    null => null,
    true => l10n.exportYes,
    false => l10n.exportNo,
  };
  String? apiaryOf(String? id) => id == null ? null : apiaryNames[id];
  // Sayısal numara sayı olarak yazılır; Excel'de doğru sıralanır.
  Object? hiveNumber(Hive? hive) =>
      hive == null ? null : int.tryParse(hive.number) ?? hive.number;
  Object? hiveOf(String? id) => hiveNumber(id == null ? null : hives[id]);
  String? blank(String? text) => text?.isEmpty ?? true ? null : text;
  // Karantinadaysa "Evet · Amerikan yavru çürüklüğü"; değilse boş.
  String? quarantine(Hive hive) => switch (hive.quarantined) {
    true => [
      l10n.exportYes,
      ?blank(hive.quarantineDisease),
    ].join(l10n.titleSeparator),
    false => null,
  };
  // Kayıtta şurup litre, diğerleri kilogram (storedFeedingAmount).
  String feedingUnit(Feeding feeding) =>
      feeding.kind.isSyrup ? l10n.unitLiter : l10n.unitKilogram;

  int byHive(Hive a, Hive b) {
    final apiary = compareNatural(
      apiaryNames[a.apiaryId] ?? '',
      apiaryNames[b.apiaryId] ?? '',
    );
    return apiary != 0 ? apiary : compareNatural(a.number, b.number);
  }

  List<T> newestFirst<T>(List<T> rows, DateTime Function(T row) at) =>
      [...rows]..sort((a, b) => at(b).compareTo(at(a)));

  return [
    XlsxSheet(
      name: l10n.exportSheetApiaries,
      rows: [
        [
          l10n.exportColName,
          l10n.exportColActiveHives,
          l10n.exportColLatitude,
          l10n.exportColLongitude,
          l10n.exportColAltitude,
          l10n.exportColWaterSource,
          l10n.exportColVehicleDistance,
          l10n.exportColRoadNotes,
          l10n.exportColNotes,
          l10n.exportColCreated,
        ],
        for (final apiary in [
          ...data.apiaries,
        ]..sort((a, b) => compareNatural(a.name, b.name)))
          [
            apiary.name,
            data.hives
                .where(
                  (hive) => hive.apiaryId == apiary.id && hive.status.isCounted,
                )
                .length,
            apiary.latitude,
            apiary.longitude,
            apiary.altitudeM,
            blank(apiary.waterSource),
            apiary.vehicleDistanceM,
            blank(apiary.roadNotes),
            blank(apiary.notes),
            apiary.createdAt,
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetHives,
      rows: [
        [
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColType,
          l10n.exportColStatus,
          l10n.exportColBoxes,
          l10n.exportColFrames,
          l10n.exportColSource,
          l10n.exportColMarking,
          l10n.exportColTag,
          l10n.exportColQuarantine,
          l10n.exportColQueen,
          l10n.exportColCreated,
        ],
        for (final hive in [...data.hives]..sort(byHive))
          [
            apiaryOf(hive.apiaryId),
            hiveNumber(hive),
            hive.type.label(l10n),
            hive.status.label(l10n),
            hive.boxCount,
            hive.frameCount,
            hive.source?.label(l10n),
            blank(hive.marking),
            blank(hive.tagCode),
            quarantine(hive),
            switch (hive.queenId) {
              final id? => queens[id]?.title(l10n),
              null => null,
            },
            hive.createdAt,
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetQueens,
      rows: [
        [
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColYear,
          l10n.exportColColor,
          l10n.exportColBreed,
          l10n.exportColLine,
          l10n.exportColSource,
          l10n.exportColWingClipped,
          l10n.exportColCreated,
        ],
        for (final queen in newestFirst(data.queens, (q) => q.createdAt))
          [
            apiaryOf(queenHives[queen.id]?.apiaryId),
            hiveNumber(queenHives[queen.id]),
            queen.year,
            queen.markColor?.label(l10n),
            blank(queen.breed),
            blank(queen.breedLine),
            queen.source?.label(l10n),
            yesNo(value: queen.wingClipped),
            queen.createdAt,
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetInspections,
      rows: [
        [
          l10n.exportColDate,
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColQueenState,
          l10n.exportColBeeFrames,
          l10n.exportColBroodFrames,
          l10n.exportColHoneyFrames,
          l10n.exportColTemperament,
          l10n.exportColSwarmSigns,
          l10n.exportColQueenCells,
          l10n.exportColDisease,
          l10n.exportColActions,
        ],
        for (final inspection in newestFirst(
          data.inspections,
          (i) => i.inspectedAt,
        ))
          [
            inspection.inspectedAt,
            apiaryOf(inspection.apiaryId),
            hiveOf(inspection.hiveId),
            inspection.queenState?.label(l10n),
            inspection.beeFrames,
            inspection.broodFrames,
            inspection.honeyFrames,
            inspection.temperament?.label(l10n),
            yesNo(value: inspection.swarmSigns),
            inspection.queenCells?.label(l10n),
            yesNo(value: inspection.diseaseSuspected),
            blank(
              [for (final action in inspection.actions) action.label(l10n)]
                  .join(l10n.listSeparator),
            ),
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetFeedings,
      rows: [
        [
          l10n.exportColDate,
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColType,
          l10n.exportColAmount,
          l10n.exportColUnit,
        ],
        for (final feeding in newestFirst(data.feedings, (f) => f.fedAt))
          [
            feeding.fedAt,
            apiaryOf(feeding.apiaryId),
            hiveOf(feeding.hiveId),
            feeding.kind.label(l10n),
            feeding.amount,
            feedingUnit(feeding),
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetTreatments,
      rows: [
        [
          l10n.exportColDate,
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColProduct,
          l10n.exportColActiveIngredient,
          l10n.exportColDose,
          l10n.exportColUnit,
          l10n.exportColWithdrawal,
          l10n.exportColBatch,
          l10n.exportColPlannedRemoval,
        ],
        for (final treatment in newestFirst(
          data.treatments,
          (t) => t.startedAt,
        ))
          [
            treatment.startedAt,
            apiaryOf(treatment.apiaryId),
            hiveOf(treatment.hiveId),
            treatment.productName,
            treatment.activeIngredient.label(l10n),
            treatment.dose,
            treatment.doseUnit.label(l10n),
            treatment.withdrawalDays,
            blank(treatment.batchNo),
            treatment.plannedRemovalAt,
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetMiteCounts,
      rows: [
        [
          l10n.exportColDate,
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColMethod,
          l10n.exportColMites,
          l10n.exportColSampleBees,
          l10n.exportColDays,
          l10n.exportColResult,
        ],
        for (final count in newestFirst(data.miteCounts, (c) => c.countedAt))
          [
            count.countedAt,
            apiaryOf(count.apiaryId),
            hiveOf(count.hiveId),
            count.method.label(l10n),
            count.mites,
            count.sampleBees,
            count.days,
            switch (miteLoadOf(count)) {
              final load? => miteValueText(l10n, load.value, load.unit),
              null => null,
            },
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetHarvests,
      rows: [
        [
          l10n.exportColDate,
          l10n.exportColApiary,
          l10n.exportColHoneyKind,
          l10n.exportColUnit,
          l10n.exportColUnitCount,
          l10n.exportColNetKg,
          l10n.exportColHiveCount,
        ],
        for (final harvest in newestFirst(data.harvests, (h) => h.harvestedAt))
          [
            harvest.harvestedAt,
            apiaryOf(harvest.apiaryId),
            harvest.honeyKind.label(l10n),
            harvest.unit.label(l10n),
            harvest.unitCount,
            harvest.netKg,
            data.harvestHiveCounts[harvest.id] ?? 0,
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetTasks,
      rows: [
        [
          l10n.exportColDue,
          l10n.exportColTitle,
          l10n.exportColApiary,
          l10n.exportColHive,
          l10n.exportColCompleted,
        ],
        for (final task in newestFirst(data.tasks, (t) => t.dueAt))
          [
            task.dueAt,
            blank(
              task.source == TaskSource.manual
                  ? task.title
                  : autoTaskTitle(
                      l10n,
                      task.source,
                      hiveNumber: switch (task.hiveId) {
                        final id? => hives[id]?.number,
                        null => null,
                      },
                      step: task.sourceStep,
                    ),
            ),
            apiaryOf(task.apiaryId),
            hiveOf(task.hiveId),
            task.completedAt,
          ],
      ],
    ),
    XlsxSheet(
      name: l10n.exportSheetInventory,
      rows: [
        [
          l10n.exportColName,
          l10n.exportColCategory,
          l10n.exportColStock,
          l10n.exportColUnit,
          l10n.exportColThreshold,
          l10n.exportColPlace,
        ],
        for (final (:item, :quantity) in [
          ...data.inventory,
        ]..sort((a, b) => compareNatural(a.item.name, b.item.name)))
          [
            item.name,
            item.category.label(l10n),
            quantity,
            item.unit.label(l10n),
            item.threshold,
            blank(item.place),
          ],
      ],
    ),
    if (data.transactions case final transactions?)
      XlsxSheet(
        name: l10n.exportSheetFinance,
        rows: [
          [
            l10n.exportColDate,
            l10n.exportColType,
            l10n.exportColCategory,
            l10n.exportColAmount,
            l10n.exportColCurrency,
            l10n.exportColDescription,
            l10n.exportColApiary,
          ],
          for (final transaction in newestFirst(
            transactions,
            (t) => t.occurredOn,
          ))
            [
              XlsxDate(transaction.occurredOn),
              switch (transaction.kind) {
                TransactionKind.income => l10n.financeIncome,
                TransactionKind.expense => l10n.financeExpense,
              },
              transaction.category.label(l10n),
              transaction.amount,
              transaction.currency,
              blank(transaction.description),
              apiaryOf(transaction.apiaryId),
            ],
        ],
      ),
  ];
}

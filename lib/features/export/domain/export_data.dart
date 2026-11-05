import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/feeding/domain/feeding.dart';
import 'package:mobil_arici/features/finance/domain/finance_transaction.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/health/domain/mite_count.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/queens/domain/queen.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

part 'export_data.freezed.dart';

/// Dışa aktarılan işletme verisi: ana kayıtların silinmemiş hepsi, yerel
/// DB'deki hâliyle. Finans yalnız görme yetkisi olanda dolu.
@freezed
abstract class ExportData with _$ExportData {
  const factory({
    required List<Apiary> apiaries,
    required List<Hive> hives,
    required List<Queen> queens,
    required List<Inspection> inspections,
    required List<Feeding> feedings,
    required List<Treatment> treatments,
    required List<MiteCount> miteCounts,
    required List<Harvest> harvests,

    /// Hasat kimliği → hasada katılan kovan sayısı.
    required Map<String, int> harvestHiveCounts,
    required List<Task> tasks,
    required List<InventoryStock> inventory,

    /// Finansı görme yetkisi yoksa null; sayfa hiç yazılmaz.
    List<FinanceTransaction>? transactions,
  }) = _ExportData;
}

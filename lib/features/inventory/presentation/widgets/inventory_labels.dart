import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';

extension InventoryCategoryLabel on InventoryCategory {
  String label(AppLocalizations l10n) => switch (this) {
    InventoryCategory.consumable => l10n.inventoryCategoryConsumable,
    InventoryCategory.equipment => l10n.inventoryCategoryEquipment,
    InventoryCategory.comb => l10n.inventoryCategoryComb,
  };
}

extension InventoryUnitLabel on InventoryUnit {
  /// Miktarın yanındaki kısa ad ("kg", "ad").
  String label(AppLocalizations l10n) => switch (this) {
    InventoryUnit.kg => l10n.inventoryUnitKg,
    InventoryUnit.liter => l10n.inventoryUnitLiter,
    InventoryUnit.piece => l10n.inventoryUnitPiece,
    InventoryUnit.roll => l10n.inventoryUnitRoll,
    InventoryUnit.pack => l10n.inventoryUnitPack,
  };

  /// Formdaki seçimin adı ("Kilogram", "Adet").
  String fullName(AppLocalizations l10n) => switch (this) {
    InventoryUnit.kg => l10n.inventoryUnitNameKg,
    InventoryUnit.liter => l10n.inventoryUnitNameLiter,
    InventoryUnit.piece => l10n.inventoryUnitNamePiece,
    InventoryUnit.roll => l10n.inventoryUnitNameRoll,
    InventoryUnit.pack => l10n.inventoryUnitNamePack,
  };
}

extension InventoryMoveKindLabel on InventoryMoveKind {
  String label(AppLocalizations l10n) => switch (this) {
    InventoryMoveKind.stockIn => l10n.inventoryMoveIn,
    InventoryMoveKind.stockOut => l10n.inventoryMoveOut,
    InventoryMoveKind.adjustment => l10n.inventoryMoveAdjustment,
  };
}

/// Sayı, en çok üç ondalıkla ("12,5").
String inventoryNumber(AppFormat format, double value) =>
    format.number(value, maxFractionDigits: 3);

/// Miktar ve birimi ("150 kg", "40 ad").
String inventoryQuantity(
  AppLocalizations l10n,
  AppFormat format,
  double value,
  InventoryUnit unit,
) => l10n.inventoryQuantity(inventoryNumber(format, value), unit.label(l10n));

/// Hareketin işaretli miktarı ve birimi ("+12 kg", "-5 ad").
String inventorySignedQuantity(
  AppLocalizations l10n,
  AppFormat format,
  double value,
  InventoryUnit unit,
) {
  final quantity = inventoryQuantity(l10n, format, value, unit);
  return value > 0 ? l10n.inventoryIncrease(quantity) : quantity;
}

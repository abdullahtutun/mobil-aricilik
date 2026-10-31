import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/sync_indicator.dart';
import 'package:mobil_arici/core/sync/sync_result.dart';

/// Senkron durumunun rengi ve rozet ikonu.
AppStatus syncIndicatorStatus(SyncIndicator indicator) => switch (indicator) {
  SyncIndicator.synced => AppStatus.good,
  SyncIndicator.pending => AppStatus.info,
  SyncIndicator.error => AppStatus.critical,
};

/// Senkron durumunun bulut ikonu; renk ve kelimeyle birlikte kullanılır.
IconData syncIndicatorIcon(SyncIndicator indicator) => switch (indicator) {
  SyncIndicator.synced => Icons.cloud_done_outlined,
  SyncIndicator.pending => Icons.cloud_upload_outlined,
  SyncIndicator.error => Icons.sync_problem_rounded,
};

/// Senkron durumunu anlatan kelime: "Eşitlendi", "3 bekliyor", "Hata".
String syncIndicatorLabel(
  AppLocalizations l10n,
  SyncIndicator indicator, {
  required int pending,
}) => switch (indicator) {
  SyncIndicator.synced => l10n.syncStatusSynced,
  SyncIndicator.pending => l10n.syncStatusPending(pending),
  SyncIndicator.error => l10n.syncStatusError,
};

/// Turun neden bitemediği; tur başarıyla bittiyse null.
String? syncProblemText(AppLocalizations l10n, SyncStatus status) =>
    switch (status) {
      SyncStatus.done => null,
      SyncStatus.retryLater => l10n.syncProblemOffline,
      SyncStatus.failed => l10n.syncProblemFailed,
      SyncStatus.upgradeRequired => l10n.syncProblemUpgrade,
    };

String syncRejectionText(AppLocalizations l10n, SyncRejection rejection) =>
    switch (rejection) {
      SyncRejection.forbidden => l10n.syncRejectionForbidden,
      SyncRejection.conflict => l10n.syncRejectionConflict,
      SyncRejection.missingReference => l10n.syncRejectionMissingReference,
      SyncRejection.unsupported => l10n.syncRejectionUnsupported,
      SyncRejection.invalid => l10n.syncRejectionInvalid,
      SyncRejection.unknown => l10n.syncRejectionUnknown,
    };

/// Sunucu tablosunun kayıt türü olarak adı; tanınmayan tabloda adın
/// kendisi (veri, metin değil).
String syncTableLabel(AppLocalizations l10n, String table) => switch (table) {
  'organizations' => l10n.syncTableOrganizations,
  'memberships' => l10n.syncTableMemberships,
  'apiaries' => l10n.syncTableApiaries,
  'queens' => l10n.syncTableQueens,
  'hives' => l10n.syncTableHives,
  'hive_location_history' => l10n.syncTableHiveLocationHistory,
  'inspections' => l10n.syncTableInspections,
  'media' => l10n.syncTableMedia,
  'mite_counts' => l10n.syncTableMiteCounts,
  'ref_drugs' => l10n.syncTableRefDrugs,
  'drugs' => l10n.syncTableDrugs,
  'treatments' => l10n.syncTableTreatments,
  'feedings' => l10n.syncTableFeedings,
  'tasks' => l10n.syncTableTasks,
  'harvests' => l10n.syncTableHarvests,
  'harvest_hives' => l10n.syncTableHarvestHives,
  'documents' => l10n.syncTableDocuments,
  'migrations' => l10n.syncTableMigrations,
  'migration_stops' => l10n.syncTableMigrationStops,
  'transports' => l10n.syncTableTransports,
  'transport_items' => l10n.syncTableTransportItems,
  _ => table,
};

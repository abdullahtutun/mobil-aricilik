import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';

extension HiveTypeLabel on HiveType {
  String label(AppLocalizations l10n) => switch (this) {
    HiveType.langstroth => l10n.hiveTypeLangstroth,
    HiveType.dadant => l10n.hiveTypeDadant,
    HiveType.local => l10n.hiveTypeLocal,
    HiveType.other => l10n.hiveTypeOther,
  };
}

extension HiveStatusLabel on HiveStatus {
  String label(AppLocalizations l10n) => switch (this) {
    HiveStatus.active => l10n.hiveStatusActive,
    HiveStatus.dead => l10n.hiveStatusDead,
    HiveStatus.merged => l10n.hiveStatusMerged,
    HiveStatus.sold => l10n.hiveStatusSold,
    HiveStatus.lost => l10n.hiveStatusLost,
  };

  /// Rozetin rengi ve ikonu; kelimesi [label].
  AppStatus get appStatus => switch (this) {
    HiveStatus.active => AppStatus.good,
    HiveStatus.dead => AppStatus.critical,
    HiveStatus.lost => AppStatus.warning,
    HiveStatus.merged || HiveStatus.sold => AppStatus.info,
  };
}

extension HiveSourceLabel on HiveSource {
  String label(AppLocalizations l10n) => switch (this) {
    HiveSource.swarm => l10n.hiveSourceSwarm,
    HiveSource.split => l10n.hiveSourceSplit,
    HiveSource.purchase => l10n.hiveSourcePurchase,
    HiveSource.package => l10n.hiveSourcePackage,
  };
}

extension HiveLossReasonLabel on HiveLossReason {
  String label(AppLocalizations l10n) => switch (this) {
    HiveLossReason.wintering => l10n.hiveLossWintering,
    HiveLossReason.queenless => l10n.hiveLossQueenless,
    HiveLossReason.varroa => l10n.hiveLossVarroa,
    HiveLossReason.disease => l10n.hiveLossDisease,
    HiveLossReason.starvation => l10n.hiveLossStarvation,
    HiveLossReason.robbing => l10n.hiveLossRobbing,
    HiveLossReason.predator => l10n.hiveLossPredator,
    HiveLossReason.poisoning => l10n.hiveLossPoisoning,
    HiveLossReason.other => l10n.hiveLossOther,
  };

  IconData get icon => switch (this) {
    HiveLossReason.wintering => Icons.ac_unit_rounded,
    HiveLossReason.queenless => Icons.workspace_premium_outlined,
    HiveLossReason.varroa => Icons.bug_report_outlined,
    HiveLossReason.disease => Icons.coronavirus_outlined,
    HiveLossReason.starvation => Icons.no_food_outlined,
    HiveLossReason.robbing => Icons.swap_horiz_rounded,
    HiveLossReason.predator => Icons.pets_rounded,
    HiveLossReason.poisoning => Icons.science_outlined,
    HiveLossReason.other => Icons.more_horiz_rounded,
  };
}

/// Kaybın nedeni; boş neden "Belirtilmemiş".
String hiveLossReasonLabel(AppLocalizations l10n, HiveLossReason? reason) =>
    reason?.label(l10n) ?? l10n.hiveLossUnspecified;

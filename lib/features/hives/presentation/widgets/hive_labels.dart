import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';

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

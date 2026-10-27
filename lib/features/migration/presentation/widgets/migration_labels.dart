import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/domain/migration_rules.dart';

/// Planın başlığı: "Göç planı 2026".
String migrationTitle(AppLocalizations l10n, Migration migration) =>
    l10n.migrationTitle(migration.name, '${migration.year}');

String stopStatusLabel(AppLocalizations l10n, MigrationStopStatus status) =>
    switch (status) {
      MigrationStopStatus.past => l10n.migrationStopPast,
      MigrationStopStatus.current => l10n.migrationStopCurrent,
      MigrationStopStatus.planned => l10n.migrationStopPlanned,
    };

/// Planlanan konaklama ay aralığıyla ("Mar–Nis"); aynı aydaysa tek ay.
String stopDates(AppLocalizations l10n, AppFormat format, MigrationStop stop) {
  final start = stop.plannedStartOn;
  final end = stop.plannedEndOn;
  if (start.year == end.year && start.month == end.month) {
    return format.shortMonth(start);
  }
  return l10n.migrationStopDates(
    format.shortMonth(start),
    format.shortMonth(end),
  );
}

/// Durağın yeri ve kovan sayısı ("Ula, Muğla · 152 kovan"); ikisi de
/// yoksa boş.
String stopDetails(AppLocalizations l10n, MigrationStop stop) => [
  ?stop.place,
  if (stop.hiveCount case final count?) l10n.apiaryHiveCount(count),
].join(' · ');

/// Hedef arılığın geçmiş yıllardaki verimi ("Geçmiş verim · 2025: 26
/// kg/kovan · 2024: 22 kg/kovan"); hasat yoksa bunu söyler.
String stopYields(
  AppLocalizations l10n,
  AppFormat format,
  List<YearlyYield> yields,
) {
  if (yields.isEmpty) return l10n.migrationNoYield;
  return l10n.migrationYields(
    yields
        .map(
          (y) => l10n.migrationYield(
            '${y.year}',
            format.number(y.kgPerHive, maxFractionDigits: 1),
          ),
        )
        .join(' · '),
  );
}

/// Sıradaki taşımada belgenin rozeti: durum rengi + ikon + kelime.
({AppStatus status, String label}) migrationDocumentBadge(
  AppLocalizations l10n,
  MigrationDocumentStatus document,
) {
  final name = presetDocumentTypeLabel(l10n, document.type);
  return switch (document.level) {
    MigrationDocumentLevel.ready => (
      status: AppStatus.good,
      label: l10n.migrationDocReady(name),
    ),
    MigrationDocumentLevel.expiringSoon => (
      status: AppStatus.critical,
      label: l10n.migrationDocDays(name, document.daysLeft ?? 0),
    ),
    MigrationDocumentLevel.expiresBeforeMove => (
      status: AppStatus.critical,
      label: l10n.migrationDocBeforeMove(name),
    ),
    MigrationDocumentLevel.expired => (
      status: AppStatus.critical,
      label: l10n.migrationDocExpired(name),
    ),
    MigrationDocumentLevel.missing => (
      status: AppStatus.warning,
      label: l10n.migrationDocMissing(name),
    ),
  };
}

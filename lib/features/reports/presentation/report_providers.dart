import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/reports/data/report_repository.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:mobil_arici/features/reports/domain/report_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'report_providers.g.dart';

@Riverpod(keepAlive: true)
ReportRepository reportRepository(Ref ref) =>
    ReportRepository(ref.watch(appDatabaseProvider));

/// TR başlığının tescil ve AKS numaraları; rapor ekranı bunlarla dolar.
@riverpod
Stream<OrganizationRegistration> organizationRegistration(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const OrganizationRegistration());
  return ref.watch(reportRepositoryProvider).watchRegistration(orgId);
}

/// Raporun verisi; ekranın önizlemesi ve PDF aynı veriden. Dönem [from]
/// ile [to] günleri arası (ikisi de dahil); [apiaryId] boşsa bütün
/// arılıklar; [hiveId] yalnız kovan geçmişinde, boşsa kapsamdaki kovanlar.
/// Rapor bir anın dökümüdür, kayıt değişince kendiliğinden yenilenmez.
@riverpod
Future<ReportData> reportData(
  Ref ref, {
  required ReportKind kind,
  required DateTime from,
  required DateTime to,
  String? apiaryId,
  String? hiveId,
}) async {
  final period = (from: from, to: to);
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) {
    return switch (kind) {
      ReportKind.treatmentRegister => const TreatmentRegister(
        entries: [],
        apiaryNames: {},
      ),
      ReportKind.hiveHistory => const HiveHistoryReport(
        hives: [],
        apiaryNames: {},
      ),
    };
  }
  final repository = ref.watch(reportRepositoryProvider);
  final (hives, apiaryNames) = await (
    repository.findHives(orgId),
    repository.findApiaryNames(orgId),
  ).wait;

  switch (kind) {
    case ReportKind.treatmentRegister:
      return TreatmentRegister(
        entries: treatmentRegisterEntries(
          await repository.findTreatments(orgId),
          period: period,
          apiaryId: apiaryId,
          hiveNumbers: {for (final hive in hives) hive.id: hive.number},
        ),
        apiaryNames: apiaryNames,
      );
    case ReportKind.hiveHistory:
      final histories = <HiveHistory>[];
      for (final hive in reportHives(
        hives,
        apiaryId: apiaryId,
        hiveId: hiveId,
      )) {
        final items = hiveHistoryItems(
          await repository.findHiveRecords(hive.id),
          period: period,
        );
        if (items.isNotEmpty || hiveId != null) {
          histories.add((hive: hive, items: items));
        }
      }
      return HiveHistoryReport(hives: histories, apiaryNames: apiaryNames);
  }
}

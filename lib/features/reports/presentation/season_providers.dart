import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/finance/domain/finance_rules.dart';
import 'package:mobil_arici/features/finance/presentation/finance_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/reports/domain/season_rules.dart';
import 'package:mobil_arici/features/reports/presentation/report_providers.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'season_providers.g.dart';

/// [year] sezonunun raporu ([seasonReport]); yerel DB'deki kayıtlardan,
/// ekranın açıldığı ana kadar. Rapor bir anın dökümüdür, kayıt değişince
/// kendiliğinden yenilenmez. İşletme yoksa null.
@riverpod
Future<SeasonReport?> seasonReportData(Ref ref, int year) async {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return null;
  final hemisphere = ref.watch(
    regionConfigProvider.select((region) => region.hemisphere),
  );
  final records = await ref
      .watch(reportRepositoryProvider)
      .findSeasonRecords(orgId);
  return seasonReport(
    records,
    year: year,
    hemisphere: hemisphere,
    now: clock.now(),
  );
}

/// [year] sezonunun maliyet ve kârı (Finans'ın sezon özeti); kovan başı
/// maliyet sezon sonundaki aktif kovanlara göre. Finansı göremeyen rolde
/// (worker, viewer) ya da işletme yüklenmediyse null.
@riverpod
Future<SeasonSummary?> seasonFinance(Ref ref, int year) async {
  if (!ref.watch(canSeeFinanceProvider)) return null;
  final currency = ref.watch(financeCurrencyProvider);
  if (currency == null) return null;
  final report = await ref.watch(seasonReportDataProvider(year).future);
  final rows = await ref.watch(transactionRowsProvider.future);
  return seasonSummary(
    [for (final row in rows) row.transaction],
    year: year,
    currency: currency,
    activeHives: report?.hivesAtEnd ?? 0,
  );
}

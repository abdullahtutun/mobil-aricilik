import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/subsidies/data/support_period_repository.dart';
import 'package:mobil_arici/features/subsidies/domain/subsidy_rules.dart';
import 'package:mobil_arici/features/subsidies/domain/support_period.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subsidy_providers.g.dart';

@Riverpod(keepAlive: true)
SupportPeriodRepository supportPeriodRepository(Ref ref) =>
    SupportPeriodRepository(ref.watch(appDatabaseProvider));

/// Destek dönemleri ekrandaki sırayla: açıklar, yaklaşanlar, bitenler
/// ([sortSupportPeriods]). Senkron yeni dönem indirince yeniden yayar.
@riverpod
Stream<List<SupportPeriod>> supportPeriods(Ref ref) => ref
    .watch(supportPeriodRepositoryProvider)
    .watchAll()
    .map((periods) => sortSupportPeriods(periods, clock.now()));

/// Başvuru öncesi kontrol: uygulamadaki aktif kovan sayısı, AKS'de beyan
/// edilen sayı ve karşılaştırma.
typedef AksHiveCountState = ({
  int activeHives,
  int? declared,
  AksHiveCountCheck check,
});

/// İşletmenin aktif kovan sayısı; işletme yoksa 0.
@riverpod
Stream<int> activeHiveCount(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(0);
  return ref.watch(hiveRepositoryProvider).watchActiveCount(orgId);
}

/// İşletmenin AKS'de beyan ettiği kovan sayısı; girilmemişse ya da
/// işletme satırı henüz inmemişse null.
@riverpod
Stream<int?> aksHiveCount(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(null);
  return ref.watch(organizationRepositoryProvider).watchAksHiveCount(orgId);
}

@riverpod
Future<AksHiveCountState> aksHiveCountCheck(Ref ref) async {
  final activeHives = await ref.watch(activeHiveCountProvider.future);
  final declared = await ref.watch(aksHiveCountProvider.future);
  return (
    activeHives: activeHives,
    declared: declared,
    check: checkAksHiveCount(activeHives: activeHives, declared: declared),
  );
}

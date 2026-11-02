import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/apiaries/data/apiary_repository.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'apiary_providers.g.dart';

@Riverpod(keepAlive: true)
ApiaryRepository apiaryRepository(Ref ref) => ApiaryRepository(
  ref.watch(appDatabaseProvider),
  aksReminders: ref.watch(
    regionConfigProvider.select((region) => region.features.aks),
  ),
);

/// İşletmenin arılıkları; adlar Türkçe harf ve sayı sırasıyla. İşletme
/// yoksa boş.
@riverpod
Stream<List<ApiarySummary>> apiaryList(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref
      .watch(apiaryRepositoryProvider)
      .watchSummaries(orgId)
      .map(
        (summaries) =>
            summaries
              ..sort((a, b) => compareNatural(a.apiary.name, b.apiary.name)),
      );
}

/// Detayın üst kısmı; arılık yoksa ya da silindiyse null.
@riverpod
Stream<ApiarySummary?> apiarySummary(Ref ref, String apiaryId) =>
    ref.watch(apiaryRepositoryProvider).watchSummary(apiaryId);

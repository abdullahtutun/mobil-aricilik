import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/presentation/harvest_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'lot_providers.g.dart';

@Riverpod(keepAlive: true)
LotRepository lotRepository(Ref ref) =>
    LotRepository(ref.watch(appDatabaseProvider));

/// Oturumdaki işletmenin lotları ve hesaplanan değerleri, yeni önce;
/// işletme yoksa boş.
@riverpod
Stream<List<LotSummary>> lotSummaries(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(lotRepositoryProvider).watchSummaries(orgId);
}

/// Lot ve hesaplanan değerleri; yoksa ya da silinmişse null.
@riverpod
Stream<LotSummary?> lotSummary(Ref ref, String id) =>
    ref.watch(lotRepositoryProvider).watchSummary(id);

/// Hasat eklenebilecek açık lotlar, yeni önce; işletme yoksa boş.
@riverpod
Stream<List<Lot>> openLots(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(lotRepositoryProvider).watchOpen(orgId);
}

/// Lotun hasatları, yeni önce.
@riverpod
Stream<List<LotHarvestRow>> lotHarvests(Ref ref, String lotId) =>
    ref.watch(lotRepositoryProvider).watchHarvests(lotId);

/// Lota bağlı son ilaçlamalar; ihlaller önce.
@riverpod
Stream<List<LotTreatmentRow>> lotTreatments(Ref ref, String lotId) =>
    ref.watch(lotRepositoryProvider).watchTreatments(lotId);

/// Lotun analizleri, yeni önce.
@riverpod
Stream<List<LabResult>> lotLabResults(Ref ref, String lotId) =>
    ref.watch(lotRepositoryProvider).labResults.watchByLot(lotId);

/// Lotun satışları, yeni önce.
@riverpod
Stream<List<LotSale>> lotSales(Ref ref, String lotId) =>
    ref.watch(lotRepositoryProvider).sales.watchByLot(lotId);

/// Hasat; yoksa ya da silinmişse (Geri al) null.
@riverpod
Stream<Harvest?> harvest(Ref ref, String id) =>
    ref.watch(harvestRepositoryProvider).watchById(id);

/// Belge kasasındaki analiz raporları (analize bağlanabilecek belgeler).
@riverpod
Future<List<VaultDocument>> analysisReports(Ref ref) async => [
  for (final document in await ref.watch(documentsProvider.future))
    if (document.type == DocumentType.analysisReport) document,
];

/// Lot yazmaları. Bildirimin Geri al'ı sayfa kapandıktan sonra da çalışsın
/// diye sürekli yaşar.
@Riverpod(keepAlive: true)
class LotActions extends _$LotActions {
  @override
  void build() {}

  LotRepository get _lots => ref.read(lotRepositoryProvider);

  /// Hasat için yeni lot açar.
  Future<Lot> createWithHarvest(
    Harvest harvest, {
    String? origin,
    double? moisture,
  }) => _lots.createWithHarvest(harvest, origin: origin, moisture: moisture);

  /// Hasadı açık lota ekler.
  Future<void> attachHarvest(Lot lot, Harvest harvest) =>
      _lots.attachHarvest(lot, harvest);

  Future<Lot> update(Lot lot) => _lots.update(lot);

  Future<void> remove(String id) => _lots.remove(id);

  Future<LotSale> addSale(Lot lot, double kg, {required DateTime soldOn}) =>
      _lots.sales.add(lot, kg, soldOn: soldOn);

  /// Geri al: satış silinir.
  Future<void> undoSale(LotSale sale) => _lots.sales.delete(sale.id);

  Future<LabResult> addLabResult(Lot lot, LabResultValues values) =>
      _lots.labResults.add(lot, values);

  /// Geri al: analiz silinir.
  Future<void> undoLabResult(LabResult result) =>
      _lots.labResults.delete(result.id);
}

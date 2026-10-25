import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/features/health/data/drug_repository.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/drug_rules.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'treatment_providers.g.dart';

@Riverpod(keepAlive: true)
RefDrugRepository refDrugRepository(Ref ref) =>
    RefDrugRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
DrugRepository drugRepository(Ref ref) =>
    DrugRepository(ref.watch(appDatabaseProvider));

@Riverpod(keepAlive: true)
TreatmentRepository treatmentRepository(Ref ref) =>
    TreatmentRepository(ref.watch(appDatabaseProvider));

@riverpod
Stream<List<RefDrug>> refDrugs(Ref ref) =>
    ref.watch(refDrugRepositoryProvider).watchAll();

/// İşletmenin eklediği ilaçlar; işletme yoksa boş.
@riverpod
Stream<List<Drug>> organizationDrugs(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(drugRepositoryProvider).watchAll(orgId);
}

/// Formdaki ilaç listesi ([drugCatalog]) [languageCode] dilinde. TR
/// listesi bölge profilinin `trDrugList` bayrağıyla görünür.
@riverpod
Future<List<DrugChoice>> drugCatalogOf(Ref ref, String languageCode) async =>
    drugCatalog(
      refDrugs: await ref.watch(refDrugsProvider.future),
      drugs: await ref.watch(organizationDrugsProvider.future),
      trList: ref.watch(regionConfigProvider).features.trDrugList,
      languageCode: languageCode,
    );

/// Kaydetme, geri alma ve kilit denetimi. Bildirimin Geri al'ı form
/// kapandıktan sonra da çalışsın diye sürekli yaşar.
@Riverpod(keepAlive: true)
class TreatmentActions extends _$TreatmentActions {
  @override
  void build() {}

  /// İşletmeye yeni ilaç ekler ve formda seçilecek hâlini döner.
  Future<DrugChoice> addDrug({
    required String orgId,
    required String name,
    required DrugActiveIngredient activeIngredient,
    required DrugDoseUnit doseUnit,
    int? withdrawalDays,
  }) async => customDrugChoice(
    await ref
        .read(drugRepositoryProvider)
        .add(
          orgId: orgId,
          name: name,
          activeIngredient: activeIngredient,
          doseUnit: doseUnit,
          withdrawalDays: withdrawalDays,
        ),
  );

  Future<void> undoAdd(List<Treatment> treatments) =>
      ref.read(treatmentRepositoryProvider).deleteAll(treatments);

  /// Kovanın şu anki bekleme süresi kilidi; kilit yoksa null. Okunduğu
  /// anda hesaplanır.
  Future<WithdrawalLock?> lockFor(String hiveId) async => withdrawalLock(
    await ref.read(treatmentRepositoryProvider).findByHive(hiveId),
    now: clock.now(),
  );
}

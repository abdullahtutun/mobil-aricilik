import 'package:clock/clock.dart';
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/features/health/data/drug_repository.dart';
import 'package:mobil_arici/features/health/data/treatment_repository.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/drug_rules.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/domain/treatment_rules.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
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

/// Kovanın uygulamaları, en son başlayan önce.
@riverpod
Stream<List<Treatment>> hiveTreatments(Ref ref, String hiveId) =>
    ref.watch(treatmentRepositoryProvider).watchByHive(hiveId);

/// Kovanın uygulama gruplarının reçete fotoğrafları, grup kimliğine göre.
@riverpod
Stream<Map<String, List<MediaItem>>> hivePrescriptions(
  Ref ref,
  String hiveId,
) => ref.watch(treatmentRepositoryProvider).watchPrescriptionsByHive(hiveId);

/// Arılıkta yapılan uygulamalar, en son başlayan önce (etken madde
/// rotasyonu).
@riverpod
Stream<List<Treatment>> apiaryTreatments(Ref ref, String apiaryId) =>
    ref.watch(treatmentRepositoryProvider).watchByApiary(apiaryId);

/// Kovanın şimdiki bekleme süresi kilidi (kovan kartındaki aktif ilaç);
/// kilit yoksa null. Uygulamalar değişince yeniden hesaplanır.
@riverpod
Future<WithdrawalLock?> hiveWithdrawalLock(Ref ref, String hiveId) async =>
    withdrawalLock(
      await ref.watch(hiveTreatmentsProvider(hiveId).future),
      now: clock.now(),
    );

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

  /// Çıkarma gününün sabahına bu telefonda bildirim kurar (yalnız bu
  /// telefon; diğer cihazlara senkronla gitmez). Çıkarma yoksa ya da o an
  /// geçmişteyse kurmaz ve null döner; izin verilmezse false.
  Future<bool?> scheduleRemovalReminder(
    List<Treatment> treatments, {
    required String title,
    required String body,
    required String channelName,
  }) async {
    final first = treatments.firstOrNull;
    final at = removalReminderAt(first?.plannedRemovalAt, now: clock.now());
    if (first == null || at == null) return null;
    return await ref
        .read(reminderNotificationsProvider)
        .schedule(
          id: removalReminderId(first.groupId),
          at: at,
          title: title,
          body: body,
          channelName: channelName,
        );
  }

  /// Geri al: uygulamalar ve reçete fotoğrafı silinir, hatırlatıcı
  /// kaldırılır, fotoğraf dosyası da silinir.
  Future<void> undoAdd(
    List<Treatment> treatments, {
    MediaCapture? prescription,
  }) async {
    await ref.read(treatmentRepositoryProvider).deleteAll(treatments);
    if (treatments.firstOrNull case final first?) {
      await ref
          .read(reminderNotificationsProvider)
          .cancel(removalReminderId(first.groupId));
    }
    if (prescription != null) {
      await ref.read(mediaFileStoreProvider).delete(prescription.fileName);
    }
  }

  /// Kovanın şu anki bekleme süresi kilidi; kilit yoksa null. Okunduğu
  /// anda hesaplanır.
  Future<WithdrawalLock?> lockFor(String hiveId) async => withdrawalLock(
    await ref.read(treatmentRepositoryProvider).findByHive(hiveId),
    now: clock.now(),
  );
}

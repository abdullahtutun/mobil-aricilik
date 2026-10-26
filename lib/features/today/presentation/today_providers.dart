import 'package:clock/clock.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/inspections/presentation/inspection_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/today/domain/today_rules.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'today_providers.g.dart';

/// İşletmedeki her kovanın en son muayenesi, kovan kimliğine göre;
/// işletme yoksa boş.
@riverpod
Stream<Map<String, Inspection>> organizationLatestInspections(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const {});
  return ref.watch(inspectionRepositoryProvider).watchLatestByOrg(orgId);
}

/// Şerit çıkarma görevi açık olan uygulamalar; işletme yoksa boş.
@riverpod
Stream<List<Treatment>> openRemovalTreatments(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(const []);
  return ref.watch(treatmentRepositoryProvider).watchWithOpenRemoval(orgId);
}

/// "Dikkat isteyenler": aktif kovanlar gruba göre ([attentionGroups]).
/// Yalnız yerel DB'den birleşir; muayene, görev ya da uygulama değişince
/// yeniden hesaplanır.
@riverpod
Future<Map<AttentionKind, List<AttentionEntry>>> todayAttention(Ref ref) async {
  final (hives, latest, tasks, treatments) = await (
    ref.watch(organizationHivesProvider.future),
    ref.watch(organizationLatestInspectionsProvider.future),
    ref.watch(openTasksProvider.future),
    ref.watch(openRemovalTreatmentsProvider.future),
  ).wait;
  return attentionGroups(
    hives: hives,
    latest: latest,
    removalDue: removalDueHives(
      tasks: [for (final view in tasks) view.task],
      treatments: treatments,
      now: clock.now(),
    ),
  );
}

/// Arılık başına dikkat isteyen kovan sayısı; harita pinindeki uyarı
/// rozeti.
@riverpod
Future<Map<String, int>> apiaryAttentionCounts(Ref ref) async =>
    attentionHiveCountsByApiary(await ref.watch(todayAttentionProvider.future));

/// Bugün paneldeki görevler: açık ve günü bugün ya da geçmiş.
@riverpod
Future<List<TaskView>> todayTasks(Ref ref) async =>
    tasksDueToday(await ref.watch(openTasksProvider.future), now: clock.now());

/// İlk kullanım kurulumu: tamamlanan adımlar; kovan oluşturma adımının
/// açacağı arılık (ad sırasıyla ilki) ve muayene adımının açacağı, aktif
/// kovanı olan ilk arılık.
typedef SetupProgress = ({
  Set<SetupStep> completed,
  String? firstApiaryId,
  String? hiveApiaryId,
});

/// Kurulumun durumu; arılık, aktif kovan ve muayene verisinden.
@riverpod
Future<SetupProgress> setupProgress(Ref ref) async {
  final (apiaries, latest) = await (
    ref.watch(apiaryListProvider.future),
    ref.watch(organizationLatestInspectionsProvider.future),
  ).wait;
  final withHives = apiaries.where((summary) => summary.activeHiveCount > 0);
  return (
    completed: completedSetupSteps(
      hasApiary: apiaries.isNotEmpty,
      hasHive: withHives.isNotEmpty,
      hasInspection: latest.isNotEmpty,
    ),
    firstApiaryId: apiaries.firstOrNull?.apiary.id,
    hiveApiaryId: withHives.firstOrNull?.apiary.id,
  );
}

/// [ApiarySummary] listesinden arılık adları, kimliğe göre.
@riverpod
Future<Map<String, String>> apiaryNames(Ref ref) async => {
  for (final summary in await ref.watch(apiaryListProvider.future))
    summary.apiary.id: summary.apiary.name,
};

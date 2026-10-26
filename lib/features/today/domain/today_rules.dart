import 'package:mobil_arici/features/health/domain/treatment.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/strength_rules.dart';
import 'package:mobil_arici/features/inspections/domain/inspection.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';

/// "Dikkat isteyenler" kartının grupları, karttaki sırasıyla.
enum AttentionKind {
  /// Son muayenede ana arı yok.
  queenless,

  /// Son muayeneden güç puanı [weakStrengthMax] ya da altı.
  weak,

  /// Son muayenede oğul belirtisi ya da oğul memesi var.
  swarming,

  /// Şerit çıkarma görevi açık ve günü bugün ya da geçmiş.
  treatmentRemoval,
}

/// Bu puan ve altındaki kovan zayıf sayılır.
const weakStrengthMax = 2;

/// Dikkat isteyen bir kovan ve nedeninin kaynağı: dikkat son muayeneden
/// geliyorsa `inspection`, şerit çıkarmadan geliyorsa `removalDueAt` (en
/// eski açık görevin günü) dolu.
typedef AttentionEntry = ({
  Hive hive,
  Inspection? inspection,
  DateTime? removalDueAt,
});

/// Son muayenenin [values]'ına göre kovan anasız: ana arı "Yok". Ana kaydı
/// olmaması anasız saymaz; toplu oluşturulan kovanların çoğunda ana kaydı
/// yok.
bool isQueenless(InspectionValues values) =>
    values.queenState == QueenState.none;

/// Son muayenenin [values]'ından güç puanı [weakStrengthMax] ya da altı;
/// puan yoksa (arılı çerçeve girilmemiş) zayıf değil.
bool isWeak(InspectionValues values) {
  final score = strengthScore(values);
  return score != null && score <= weakStrengthMax;
}

/// Son muayenede oğul belirtisi işaretli ya da meme türü "oğul".
bool hasSwarmTendency(InspectionValues values) =>
    (values.swarmSigns ?? false) || values.queenCells == QueenCells.swarm;

/// Şeridi çıkarılacak kovanlar: açık şerit çıkarma görevi olan ve görevin
/// günü ([now]'a göre yerel takvimde) bugün ya da geçmiş olan uygulama
/// gruplarının kovanları. Değer, kovanın en eski böyle görevinin son
/// tarihi. Silinmiş uygulamalar ve görevler sayılmaz.
Map<String, DateTime> removalDueHives({
  required Iterable<Task> tasks,
  required Iterable<Treatment> treatments,
  required DateTime now,
}) {
  final today = localDay(now);
  final dueByGroup = <String, DateTime>{};
  for (final task in tasks) {
    final groupId = task.sourceId;
    if (task.source != TaskSource.treatment ||
        groupId == null ||
        task.completedAt != null ||
        task.deletedAt != null ||
        localDay(task.dueAt).isAfter(today)) {
      continue;
    }
    final current = dueByGroup[groupId];
    if (current == null || task.dueAt.isBefore(current)) {
      dueByGroup[groupId] = task.dueAt;
    }
  }
  final byHive = <String, DateTime>{};
  for (final treatment in treatments) {
    final dueAt = dueByGroup[treatment.groupId];
    if (dueAt == null || treatment.deletedAt != null) continue;
    final current = byHive[treatment.hiveId];
    if (current == null || dueAt.isBefore(current)) {
      byHive[treatment.hiveId] = dueAt;
    }
  }
  return byHive;
}

/// Dikkat isteyen aktif kovanlar, gruba göre; [hives] sırasıyla. Bir kovan
/// birden çok grupta olabilir (anasız kovan çoğu zaman zayıftır da). Her
/// grup haritada var, boş olabilir. [latest] kovanların son muayeneleri,
/// [removalDue] [removalDueHives]'ın sonucu.
Map<AttentionKind, List<AttentionEntry>> attentionGroups({
  required Iterable<Hive> hives,
  required Map<String, Inspection> latest,
  required Map<String, DateTime> removalDue,
}) {
  final groups = {
    for (final kind in AttentionKind.values) kind: <AttentionEntry>[],
  };
  for (final hive in hives) {
    if (hive.status != HiveStatus.active) continue;
    final inspection = latest[hive.id];
    if (inspection != null) {
      final values = inspection.values;
      final entry = (hive: hive, inspection: inspection, removalDueAt: null);
      if (isQueenless(values)) groups[AttentionKind.queenless]!.add(entry);
      if (isWeak(values)) groups[AttentionKind.weak]!.add(entry);
      if (hasSwarmTendency(values)) groups[AttentionKind.swarming]!.add(entry);
    }
    if (removalDue[hive.id] case final dueAt?) {
      groups[AttentionKind.treatmentRemoval]!.add((
        hive: hive,
        inspection: null,
        removalDueAt: dueAt,
      ));
    }
  }
  return groups;
}

/// Kaç ayrı kovan dikkat istiyor; birden çok grupta olan kovan bir kez
/// sayılır.
int attentionHiveCount(Map<AttentionKind, List<AttentionEntry>> groups) => {
  for (final entries in groups.values)
    for (final entry in entries) entry.hive.id,
}.length;

/// Arılık başına dikkat isteyen ayrı kovan sayısı, arılık kimliğine göre;
/// dikkat isteyen kovanı olmayan arılık haritada yok.
Map<String, int> attentionHiveCountsByApiary(
  Map<AttentionKind, List<AttentionEntry>> groups,
) {
  final hivesByApiary = <String, Set<String>>{};
  for (final entries in groups.values) {
    for (final entry in entries) {
      hivesByApiary
          .putIfAbsent(entry.hive.apiaryId, () => {})
          .add(entry.hive.id);
    }
  }
  return {
    for (final MapEntry(:key, :value) in hivesByApiary.entries)
      key: value.length,
  };
}

/// Bugün panelindeki görevler: açık ve günü bugün ya da geçmiş olanlar,
/// son tarih sırasıyla.
List<TaskView> tasksDueToday(
  Iterable<TaskView> tasks, {
  required DateTime now,
}) {
  final today = localDay(now);
  return [
    for (final view in tasks)
      if (view.task.completedAt == null &&
          view.task.deletedAt == null &&
          !localDay(view.task.dueAt).isAfter(today))
        view,
  ]..sort((a, b) {
    final byDue = a.task.dueAt.compareTo(b.task.dueAt);
    return byDue != 0 ? byDue : a.task.id.compareTo(b.task.id);
  });
}

/// Günün saatine göre selam.
enum Greeting { morning, afternoon, evening }

/// [now]'ın yerel saatine göre selam: 05–11 sabah, 12–17 gün, gerisi
/// akşam.
Greeting greetingAt(DateTime now) => switch (now.toLocal().hour) {
  >= 5 && < 12 => Greeting.morning,
  >= 12 && < 18 => Greeting.afternoon,
  _ => Greeting.evening,
};

/// İlk kullanım kurulumunun adımları, sırasıyla.
enum SetupStep {
  /// İlk arılığı ekle.
  apiary,

  /// Kovanları oluştur.
  hives,

  /// İlk muayeneyi yap.
  inspection,
}

/// Tamamlanmış kurulum adımları; adımlar sırayla sayılmaz, her biri
/// verisi varsa tamam.
Set<SetupStep> completedSetupSteps({
  required bool hasApiary,
  required bool hasHive,
  required bool hasInspection,
}) => {
  if (hasApiary) SetupStep.apiary,
  if (hasHive) SetupStep.hives,
  if (hasInspection) SetupStep.inspection,
};

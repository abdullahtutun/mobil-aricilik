import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';

/// Görev başlığının en uzun hâli (sunucudaki CHECK).
const maxTaskTitleLength = 200;

/// Yeni görevin ve ilaç çıkarma görevinin saati (yerel).
const defaultTaskHour = 9;

/// "Bu hafta" sekmesi bugünden başlayıp bu kadar gün.
const taskWeekDays = 7;

/// Bu telefonda aynı anda kurulu en fazla hatırlatma; iOS 64'ten
/// fazlasını sessizce bırakır.
const maxScheduledReminders = 50;

/// [at]'in yerel takvimdeki günü (gece yarısı).
DateTime localDay(DateTime at) {
  final local = at.toLocal();
  return DateTime(local.year, local.month, local.day);
}

/// [dueAt]'in [now]'dan kaç takvim günü önce kaldığı; bugün ya da
/// ilerideyse 0.
int overdueDays(DateTime dueAt, {required DateTime now}) {
  final days = _dayDifference(localDay(dueAt), localDay(now));
  return days < 0 ? -days : 0;
}

/// Görevin günü bugünden önce ve görev açık.
bool isOverdue(Task task, {required DateTime now}) =>
    task.completedAt == null && overdueDays(task.dueAt, now: now) > 0;

/// Görevi bu telefonun kullanıcısı ([userId]) mı yapacak: kendisine
/// atanmış ya da atanmamış.
bool isMine(Task task, String? userId) =>
    task.assignedTo == null || task.assignedTo == userId;

/// Görev listesinde bir gün (ya da gecikmiş görevler).
typedef TaskDayGroup = ({
  /// Gecikmişlerde null.
  DateTime? day,
  List<TaskView> tasks,
});

/// Açık [tasks] bugünden başlayan [days] güne bölünür: önce gecikmişler,
/// sonra görevi olan her gün kendi sırasıyla. Aralık dışındaki görevler
/// ve tamamlananlar düşer. Grup içinde son tarih sırası.
List<TaskDayGroup> tasksByDay(
  Iterable<TaskView> tasks, {
  required DateTime now,
  required int days,
}) {
  final today = localDay(now);
  final overdue = <TaskView>[];
  final byDay = <int, List<TaskView>>{};
  for (final view in _open(tasks)) {
    final offset = _dayDifference(localDay(view.task.dueAt), today);
    if (offset < 0) {
      overdue.add(view);
    } else if (offset < days) {
      (byDay[offset] ??= []).add(view);
    }
  }
  final offsets = byDay.keys.toList()..sort();
  return [
    if (overdue.isNotEmpty) (day: null, tasks: overdue),
    for (final offset in offsets)
      (
        day: DateTime(today.year, today.month, today.day + offset),
        tasks: byDay[offset]!,
      ),
  ];
}

/// Görev listesinde bir arılık; arılığa bağlı olmayanlarda `apiaryId` null.
typedef TaskApiaryGroup = ({
  String? apiaryId,
  String? apiaryName,
  List<TaskView> tasks,
});

/// Açık [tasks] arılığa göre: arılıklar ad sırasıyla
/// ([compareNatural]), arılıksız görevler en sonda. Grup içinde son tarih
/// sırası. Tarih sınırı yok.
List<TaskApiaryGroup> tasksByApiary(Iterable<TaskView> tasks) {
  final groups = <String?, List<TaskView>>{};
  for (final view in _open(tasks)) {
    (groups[view.task.apiaryId] ??= []).add(view);
  }
  final result = [
    for (final MapEntry(key: apiaryId, value: views) in groups.entries)
      (apiaryId: apiaryId, apiaryName: views.first.apiaryName, tasks: views),
  ];
  return result..sort((a, b) {
    if (a.apiaryId == null || b.apiaryId == null) {
      return (a.apiaryId == null ? 1 : 0) - (b.apiaryId == null ? 1 : 0);
    }
    return compareNatural(a.apiaryName ?? '', b.apiaryName ?? '');
  });
}

/// Bu telefonda kurulacak hatırlatmalar: [userId]'nin yapacağı
/// ([isMine]), açık ve son tarihi [now]'dan sonra olan görevler, en
/// yakını önce, en fazla [limit] tane.
List<TaskView> reminderPlan(
  Iterable<TaskView> tasks, {
  required String? userId,
  required DateTime now,
  int limit = maxScheduledReminders,
}) => [
  for (final view in _open(tasks))
    if (isMine(view.task, userId) && view.task.dueAt.isAfter(now)) view,
].take(limit).toList();

/// Görevin bildirim kimliği: aynı göreve her zaman aynı pozitif 31 bit
/// sayı (FNV-1a). Uygulama yeniden açılsa da değişmez; eşitleme kurulu
/// bildirimi bununla bulur.
int reminderNotificationId(String taskId) {
  var hash = 0x811c9dc5;
  for (final unit in taskId.codeUnits) {
    hash = ((hash ^ unit) * 0x01000193) & 0xffffffff;
  }
  return hash & 0x7fffffff;
}

/// Yeni görevin önerilen son tarihi (yerel): bugün [defaultTaskHour]'da;
/// o saat geçtiyse bugün bir sonraki tam saatte; gün bittiyse yarın
/// [defaultTaskHour]'da. Önerilen an hep [now]'dan sonra, hatırlatma çalar.
DateTime defaultTaskDueAt(DateTime now) {
  final local = now.toLocal();
  if (local.hour < defaultTaskHour) {
    return DateTime(local.year, local.month, local.day, defaultTaskHour);
  }
  if (local.hour < 23) {
    return DateTime(local.year, local.month, local.day, local.hour + 1);
  }
  return DateTime(local.year, local.month, local.day + 1, defaultTaskHour);
}

/// İlaç çıkarma görevinin son tarihi: planlanan çıkarma günü
/// [defaultTaskHour]'da (yerel). Çıkarma yoksa ya da günü [now]'dan önce
/// geçtiyse (sonradan girilen eski uygulama) null; görev açılmaz.
DateTime? treatmentRemovalDueAt(
  DateTime? plannedRemovalAt, {
  required DateTime now,
}) {
  if (plannedRemovalAt == null) return null;
  final day = localDay(plannedRemovalAt);
  if (day.isBefore(localDay(now))) return null;
  return DateTime(day.year, day.month, day.day, defaultTaskHour);
}

/// Açık ve silinmemiş görevler, son tarih sırasıyla; aynı anda olanlardan
/// kimliği (UUIDv7) küçük olan önce.
List<TaskView> _open(Iterable<TaskView> tasks) =>
    [
      for (final view in tasks)
        if (view.task.completedAt == null && view.task.deletedAt == null) view,
    ]..sort((a, b) {
      final byDue = a.task.dueAt.compareTo(b.task.dueAt);
      return byDue != 0 ? byDue : a.task.id.compareTo(b.task.id);
    });

/// Yerel takvimde [a] gününün [b] gününden kaç gün sonra olduğu; yaz saati
/// geçişinde de tam gün.
int _dayDifference(DateTime a, DateTime b) => DateTime.utc(
  a.year,
  a.month,
  a.day,
).difference(DateTime.utc(b.year, b.month, b.day)).inDays;

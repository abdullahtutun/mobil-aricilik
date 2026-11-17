import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';

/// Kovan sayısını etkileyen çakışma (teknik.md §3): iki cihaz kovanın
/// durumunu birbirinden habersiz değiştirdi. Son yazan kazanır kuralı
/// kovanın kendisini sessizce birine bırakır; olaylar ise ikisini de
/// saklar, bu yüzden çakışma olaylardan bulunur ve kullanıcıya sorulur.
///
/// `first` ve `second`, kovanın olay zincirinin koptuğu yerdeki iki olay:
/// `second` `first`'ün vardığı durumdan başlamıyor, yani `second`'ı
/// yazan `first`'ü görmemişti. Kullanıcı birini tutar, öbürü silinir;
/// silme senkronla ekibin her cihazına ulaşır ve çakışma her yerde kapanır.
typedef HiveStatusConflict = ({
  String hiveId,
  HiveStatusEvent first,
  HiveStatusEvent second,
});

/// [events] içindeki çakışmalar, kovan başına en eskisi; silinmiş olaylar
/// sayılmaz. Bir kovanda birden çok kopukluk varsa önce en eskisi sorulur,
/// o çözülünce sıradaki görünür.
///
/// Olaylar `changed_at`, sonra `created_at` ve kimlikle sıralanır. Zincir
/// her olayın `from_status`'ının bir öncekinin `to_status`'ına eşit
/// olmasıdır; eşit değilse iki cihaz aynı durumdan ayrılmıştır. İki cihaz
/// aynı durumu (ikisi de "söndü") yazdıysa da çakışmadır: kayıp iki kez
/// sayılır, birinin silinmesi gerekir.
List<HiveStatusConflict> findStatusConflicts(
  Iterable<HiveStatusEvent> events,
) {
  final byHive = <String, List<HiveStatusEvent>>{};
  for (final event in events) {
    if (event.deletedAt != null) continue;
    (byHive[event.hiveId] ??= []).add(event);
  }
  final conflicts = <HiveStatusConflict>[];
  for (final MapEntry(key: hiveId, value: hiveEvents) in byHive.entries) {
    hiveEvents.sort(compareStatusEvents);
    for (var i = 1; i < hiveEvents.length; i++) {
      final previous = hiveEvents[i - 1];
      final event = hiveEvents[i];
      if (event.fromStatus != previous.toStatus) {
        conflicts.add((hiveId: hiveId, first: previous, second: event));
        break;
      }
    }
  }
  conflicts.sort((a, b) => compareStatusEvents(a.second, b.second));
  return conflicts;
}

/// Olayların zincir sırası: `changed_at`, `created_at`, kimlik.
int compareStatusEvents(HiveStatusEvent a, HiveStatusEvent b) {
  final byChange = a.changedAt.compareTo(b.changedAt);
  if (byChange != 0) return byChange;
  final byCreation = a.createdAt.compareTo(b.createdAt);
  if (byCreation != 0) return byCreation;
  return a.id.compareTo(b.id);
}

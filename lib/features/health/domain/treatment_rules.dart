import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/treatment.dart';

/// Aynı etken madde bu kadar uygulama üst üste kullanıldıysa yeni
/// uygulamada direnç uyarısı çıkar (docs/design "İlaç kaydı": "son 2
/// uygulama da amitraz").
const rotationWarningStreak = 2;

/// [treatments] (bir arılıkta yapılanlar) içinde en son uygulamalardan
/// kaçının üst üste [ingredient] olduğu. Toplu uygulama tek uygulama
/// sayılır (`groupId`); silinmişler sayılmaz. "Diğer" etken madde
/// karşılaştırılamaz, hep 0.
int sameIngredientStreak(
  Iterable<Treatment> treatments,
  DrugActiveIngredient ingredient,
) {
  if (ingredient == DrugActiveIngredient.other) return 0;
  final groups = <String, Treatment>{};
  for (final treatment in treatments) {
    if (treatment.deletedAt != null) continue;
    final current = groups[treatment.groupId];
    if (current == null || treatment.startedAt.isAfter(current.startedAt)) {
      groups[treatment.groupId] = treatment;
    }
  }
  final latestFirst = groups.values.toList()
    ..sort((a, b) {
      final byTime = b.startedAt.compareTo(a.startedAt);
      return byTime != 0 ? byTime : b.id.compareTo(a.id);
    });
  var streak = 0;
  for (final treatment in latestFirst) {
    if (treatment.activeIngredient != ingredient) break;
    streak++;
  }
  return streak;
}

/// Yeni uygulamada direnç uyarısı gerekiyor mu ([rotationWarningStreak]).
bool needsRotationWarning(int streak) => streak >= rotationWarningStreak;

import 'package:mobil_arici/features/plans/domain/plan_status.dart';

/// Saklanan durum bundan eskiyse sunucudan yeniden istenir.
const planRefreshInterval = Duration(hours: 6);

/// Pro dönemi bittikten sonra telefonda Pro sayılmaya devam ettiği süre.
/// Yenileme mağazada olmuş ama telefon çevrimdışı kaldığı için henüz
/// duyulmamış olabilir; arıcı sahada kısıtlanmasın.
const planOfflineGrace = Duration(days: 7);

/// Ekranların uyguladığı durum. Saklanan yoksa sınırsız. Planlar açıkken
/// süresi [planOfflineGrace]'ten fazla geçmiş Pro, ücretsiz plan sınırlarını
/// sunucu gibi kendisi uygular ([freeLimitsOf]); sunucudan yeni durum
/// gelince o geçerli olur.
PlanStatus effectivePlan(StoredPlanStatus? stored, DateTime now) {
  if (stored == null) return PlanStatus.unlimited;
  final status = stored.status;
  final expiresAt = status.expiresAt;
  if (!status.plansEnabled ||
      status.plan != PlanTier.pro ||
      expiresAt == null ||
      now.isBefore(expiresAt.add(planOfflineGrace))) {
    return status;
  }
  return freeLimitsOf(status);
}

/// Ücretsiz planın sunucudaki sınırları (`server/internal/plans`). Yalnız
/// süresi geçmiş Pro'yu çevrimdışıyken düşürmek için; sunucunun söylediği
/// her zaman önce gelir.
const freeHiveLimit = 30;
const freeForecastDays = 3;

PlanStatus freeLimitsOf(PlanStatus status) => status.copyWith(
  plan: PlanTier.free,
  expiresAt: null,
  hiveLimit: freeHiveLimit,
  team: false,
  forecastDays: freeForecastDays,
);

/// Saklanan durum sunucudan yeniden istenmeli mi: hiç yoksa ya da
/// [planRefreshInterval]'dan eskiyse.
bool planNeedsRefresh(StoredPlanStatus? stored, DateTime now) =>
    stored == null ||
    now.difference(stored.fetchedAt) >= planRefreshInterval ||
    stored.fetchedAt.isAfter(now);

/// [activeHives] aktif kovanı olan işletmeye kaç kovan daha eklenebilir;
/// null sınırsız. Sınırın üstündeki kovanlar kalır, yalnız yenisi
/// eklenemez (0).
int? remainingHiveSlots({required int? hiveLimit, required int activeHives}) {
  if (hiveLimit == null) return null;
  final left = hiveLimit - activeHives;
  return left < 0 ? 0 : left;
}

/// [adding] kovan eklenebilir mi.
bool canAddHives({required int? remaining, required int adding}) =>
    remaining == null || adding <= remaining;

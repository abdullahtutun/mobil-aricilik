import 'package:clock/clock.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/core/db/app_database_provider.dart';
import 'package:mobil_arici/core/services/pocketbase_client_provider.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/plans/data/plan_repository.dart';
import 'package:mobil_arici/features/plans/data/plan_service.dart';
import 'package:mobil_arici/features/plans/data/purchase_service.dart';
import 'package:mobil_arici/features/plans/domain/plan_rules.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'plan_providers.g.dart';

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
PlanService planService(Ref ref) =>
    PocketBasePlanService(ref.watch(pocketbaseClientProvider));

@Riverpod(keepAlive: true)
PlanRepository planRepository(Ref ref) =>
    PlanRepository(ref.watch(appDatabaseProvider));

/// Testler sahtesiyle override eder.
@Riverpod(keepAlive: true)
PurchaseService purchaseService(Ref ref) => RevenueCatPurchaseService();

/// İşletmenin telefonda saklanan plan durumu; hiç alınmadıysa null.
@riverpod
Stream<StoredPlanStatus?> storedPlan(Ref ref) {
  final orgId = ref.watch(currentOrgIdProvider);
  if (orgId == null) return Stream.value(null);
  return ref.watch(planRepositoryProvider).watchStatus(orgId);
}

/// Ekranların uyguladığı plan ([effectivePlan]). Durum yüklenirken ya da
/// hiç alınmamışken sınırsız: plan hiçbir zaman arıcıyı beklenmedik yerde
/// durdurmaz.
@riverpod
PlanStatus currentPlan(Ref ref) =>
    effectivePlan(ref.watch(storedPlanProvider).value, clock.now());

/// Bugün'deki beta notu kapatıldı mı.
@riverpod
Stream<bool> betaNoticeDismissed(Ref ref) =>
    ref.watch(planRepositoryProvider).watchBetaNoticeDismissed();

/// Mağazadaki Pro paketleri; satın alma kurulu değilse ya da işletme yoksa
/// boş. Hata [PurchaseException] olarak gelir.
@riverpod
Future<List<PlanOffer>> planOffers(Ref ref) async {
  final purchases = ref.watch(purchaseServiceProvider);
  final orgId = ref.watch(currentOrgIdProvider);
  if (!purchases.available || orgId == null) return const [];
  return await purchases.fetchOffers(orgId);
}

/// Planlar açık mı: Pro ekranı ve satın alma yalnız o zaman görünür.
@riverpod
bool plansEnabled(Ref ref) =>
    ref.watch(currentPlanProvider.select((plan) => plan.plansEnabled));

/// Kaç kovan daha eklenebilir; null sınırsız ([remainingHiveSlots]).
/// Kovan eklenip silindikçe yeniden yayar.
@riverpod
Stream<int?> remainingHives(Ref ref) {
  final limit = ref.watch(currentPlanProvider.select((plan) => plan.hiveLimit));
  final orgId = ref.watch(currentOrgIdProvider);
  if (limit == null || orgId == null) return Stream.value(null);
  return ref
      .watch(hiveRepositoryProvider)
      .watchActiveCount(orgId)
      .map(
        (active) => remainingHiveSlots(hiveLimit: limit, activeHives: active),
      );
}

/// Kaydetme anında kaç kovan daha eklenebilir; null sınırsız. Formlar
/// yazmadan önce bununla bakar ([remainingHives] ekranın gösterdiği,
/// dinlenen hâli).
Future<int?> readRemainingHives(Ref ref, String orgId) async {
  final stored = await ref.read(planRepositoryProvider).readStatus(orgId);
  final limit = effectivePlan(stored, clock.now()).hiveLimit;
  if (limit == null) return null;
  final active = await ref
      .read(hiveRepositoryProvider)
      .watchActiveCount(orgId)
      .first;
  return remainingHiveSlots(hiveLimit: limit, activeHives: active);
}

/// Planı sunucudan yeniler. Ağ yoksa ya da sunucu hata verirse saklanan
/// durum kalır; hata ekrana taşınmaz.
@Riverpod(keepAlive: true)
PlanRefresher planRefresher(Ref ref) => PlanRefresher(ref);

class PlanRefresher {
  new(this._ref);

  final Ref _ref;
  Future<bool>? _running;

  /// Saklanan durum eskiyse ([planNeedsRefresh]) yeniler. Süren bir
  /// yenileme varsa onu bekler.
  Future<void> refreshIfStale() async {
    await (_running ??= _refresh().whenComplete(() => _running = null));
  }

  /// Beklemeden yeniler (satın almadan sonra). Alınamazsa false.
  Future<bool> refreshNow() async {
    await _running;
    final run = _refresh(force: true);
    _running = run;
    try {
      return await run;
    } finally {
      _running = null;
    }
  }

  Future<bool> _refresh({bool force = false}) async {
    final orgId = _ref.read(currentOrgIdProvider);
    if (orgId == null) return false;
    final repository = _ref.read(planRepositoryProvider);
    if (!force &&
        !planNeedsRefresh(await repository.readStatus(orgId), clock.now())) {
      return true;
    }
    try {
      final status = await _ref.read(planServiceProvider).fetch(orgId);
      await repository.saveStatus(
        orgId,
        StoredPlanStatus(status: status, fetchedAt: clock.now()),
      );
      return true;
    } on PlanServiceException {
      return false;
    }
  }
}

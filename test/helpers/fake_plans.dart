import 'package:mobil_arici/features/plans/data/plan_service.dart';
import 'package:mobil_arici/features/plans/data/purchase_service.dart';
import 'package:mobil_arici/features/plans/domain/plan_status.dart';

/// Ağsız plan servisi: [status]'u döner; boşsa ya da [fail] doğruysa
/// sunucuya ulaşılamamış gibi hata atar. Çağrıları sayar.
class FakePlanService implements PlanService {
  new({this.status});

  PlanStatus? status;
  bool fail = false;
  final requests = <String>[];

  @override
  Future<PlanStatus> fetch(String orgId) async {
    requests.add(orgId);
    final status = this.status;
    if (fail || status == null) throw const PlanServiceException('çevrimdışı');
    return status;
  }
}

/// Ücretsiz plan, planlar açık (sunucunun döndüğü gibi).
const freePlanStatus = PlanStatus(
  plansEnabled: true,
  hiveLimit: 30,
  team: false,
  forecastDays: 3,
);

/// Sahte mağaza. [available] yanlışsa satın alma kurulu değil gibi.
class FakePurchaseService implements PurchaseService {
  new({this.available = false, this.offers = const []});

  @override
  bool available;

  List<PlanOffer> offers;

  /// Verilirse satın alma ve geri yükleme bu hatayı atar.
  PurchaseFailure? failure;

  final purchases = <({String orgId, String offerId})>[];
  final restores = <String>[];

  @override
  Future<List<PlanOffer>> fetchOffers(String orgId) async => offers;

  @override
  Future<void> purchase(String orgId, PlanOffer offer) async {
    if (failure case final failure?) throw PurchaseException(failure);
    purchases.add((orgId: orgId, offerId: offer.id));
  }

  @override
  Future<void> restore(String orgId) async {
    if (failure case final failure?) throw PurchaseException(failure);
    restores.add(orgId);
  }
}

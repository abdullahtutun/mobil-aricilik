import 'dart:io' show Platform;

import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';

/// Mağazada satılan bir Pro paketi (RevenueCat'in "current" teklifinden).
/// `priceLabel` mağazanın yerel para birimiyle biçimlediği fiyat.
typedef PlanOffer = ({String id, String priceLabel, bool yearly});

/// Satın alma neden olmadı.
enum PurchaseFailure {
  /// Kullanıcı mağaza penceresini kapattı; hata gösterilmez.
  cancelled,

  /// Ağ yok ya da mağazaya ulaşılamadı.
  network,

  /// Cihazda satın alma kapalı (ebeveyn denetimi vb.).
  notAllowed,

  /// Satın alma bu yapıda kurulu değil (anahtar yok) ya da teklif yok.
  unavailable,

  unknown,
}

class PurchaseException implements Exception {
  const new(this.failure);

  final PurchaseFailure failure;

  @override
  String toString() => 'PurchaseException(${failure.name})';
}

/// Mağaza satın alması. Abonelik işletmeye aittir: mağaza hesabı işletme
/// kimliğiyle açılır, sunucu webhook'la `org_subscriptions`'a yazar ve
/// telefon planı sunucudan okur. Hatalar [PurchaseException] olarak gelir.
abstract interface class PurchaseService {
  /// Bu yapıda satın alma kurulu mu (mağaza anahtarı verildi mi).
  bool get available;

  /// Satıştaki paketler, önce yıllık.
  Future<List<PlanOffer>> fetchOffers(String orgId);

  /// [offer]'ı [orgId] işletmesi için satın alır.
  Future<void> purchase(String orgId, PlanOffer offer);

  /// Bu mağaza hesabının önceki satın alımlarını [orgId]'ye bağlar.
  Future<void> restore(String orgId);
}

/// RevenueCat ile [PurchaseService]. Anahtarlar `--dart-define` ile
/// verilir (`REVENUECAT_ANDROID_KEY`, `REVENUECAT_IOS_KEY`); verilmeyen
/// yapıda [available] false ve ekran satın almayı göstermez.
class RevenueCatPurchaseService implements PurchaseService {
  new({String? androidKey, String? iosKey})
    : _androidKey = androidKey ?? const String.fromEnvironment(androidKeyName),
      _iosKey = iosKey ?? const String.fromEnvironment(iosKeyName);

  static const androidKeyName = 'REVENUECAT_ANDROID_KEY';
  static const iosKeyName = 'REVENUECAT_IOS_KEY';

  final String _androidKey;
  final String _iosKey;

  /// [fetchOffers]'ın döndürdüğü paketler; satın almada kimlikten bulunur.
  final _packages = <String, Package>{};
  String? _orgId;

  String get _key => Platform.isAndroid
      ? _androidKey
      : Platform.isIOS
      ? _iosKey
      : '';

  @override
  bool get available => _key.isNotEmpty;

  /// İlk çağrıda kurar; işletme değiştiyse mağaza hesabını değiştirir.
  Future<void> _ready(String orgId) async {
    if (!available) throw const PurchaseException(PurchaseFailure.unavailable);
    if (!await Purchases.isConfigured) {
      await Purchases.configure(
        PurchasesConfiguration(_key)..appUserID = orgId,
      );
    } else if (_orgId != orgId) {
      await Purchases.logIn(orgId);
    }
    _orgId = orgId;
  }

  @override
  Future<List<PlanOffer>> fetchOffers(String orgId) => _guard(() async {
    await _ready(orgId);
    final offering = (await Purchases.getOfferings()).current;
    _packages.clear();
    final offers = <PlanOffer>[];
    for (final package in offering?.availablePackages ?? const <Package>[]) {
      _packages[package.identifier] = package;
      offers.add((
        id: package.identifier,
        priceLabel: package.storeProduct.priceString,
        yearly: package.packageType == PackageType.annual,
      ));
    }
    offers.sort((a, b) => (b.yearly ? 1 : 0) - (a.yearly ? 1 : 0));
    return offers;
  });

  @override
  Future<void> purchase(String orgId, PlanOffer offer) => _guard(() async {
    await _ready(orgId);
    final package = _packages[offer.id];
    if (package == null) {
      throw const PurchaseException(PurchaseFailure.unavailable);
    }
    await Purchases.purchase(PurchaseParams.package(package));
  });

  @override
  Future<void> restore(String orgId) => _guard(() async {
    await _ready(orgId);
    await Purchases.restorePurchases();
  });

  static Future<T> _guard<T>(Future<T> Function() run) async {
    try {
      return await run();
    } on PlatformException catch (error) {
      throw PurchaseException(switch (PurchasesErrorHelper.getErrorCode(
        error,
      )) {
        PurchasesErrorCode.purchaseCancelledError => PurchaseFailure.cancelled,
        PurchasesErrorCode.networkError ||
        PurchasesErrorCode.offlineConnectionError ||
        PurchasesErrorCode.storeProblemError => PurchaseFailure.network,
        PurchasesErrorCode.purchaseNotAllowedError =>
          PurchaseFailure.notAllowed,
        PurchasesErrorCode.configurationError ||
        PurchasesErrorCode.productNotAvailableForPurchaseError =>
          PurchaseFailure.unavailable,
        _ => PurchaseFailure.unknown,
      });
    }
  }
}

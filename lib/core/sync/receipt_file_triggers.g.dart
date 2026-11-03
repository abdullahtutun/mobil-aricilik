// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_file_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulama açıkken fiş fotoğraflarını yükler ve eksikleri indirir; belge
/// dosyalarıyla aynı anlarda ([listenStorageFileSync]). Finansı göremeyen
/// rolde (worker, viewer) hiç çalışmaz. `bootstrap` uygulama boyunca dinler.

@ProviderFor(receiptFileTriggers)
final receiptFileTriggersProvider = ReceiptFileTriggersProvider._();

/// Uygulama açıkken fiş fotoğraflarını yükler ve eksikleri indirir; belge
/// dosyalarıyla aynı anlarda ([listenStorageFileSync]). Finansı göremeyen
/// rolde (worker, viewer) hiç çalışmaz. `bootstrap` uygulama boyunca dinler.

final class ReceiptFileTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Uygulama açıkken fiş fotoğraflarını yükler ve eksikleri indirir; belge
  /// dosyalarıyla aynı anlarda ([listenStorageFileSync]). Finansı göremeyen
  /// rolde (worker, viewer) hiç çalışmaz. `bootstrap` uygulama boyunca dinler.
  ReceiptFileTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptFileTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptFileTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return receiptFileTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$receiptFileTriggersHash() =>
    r'12b27b11454f1f20ed3baea9a38ac1aef3f2c5be';

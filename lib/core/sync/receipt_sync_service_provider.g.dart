// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek fiş yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

@ProviderFor(receiptSyncService)
final receiptSyncServiceProvider = ReceiptSyncServiceProvider._();

/// Uygulamadaki tek fiş yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

final class ReceiptSyncServiceProvider
    extends
        $FunctionalProvider<
          ReceiptSyncService,
          ReceiptSyncService,
          ReceiptSyncService
        >
    with $Provider<ReceiptSyncService> {
  /// Uygulamadaki tek fiş yükleyicisi; kilit bu örneğe bağlı olduğu için
  /// canlı tutulur.
  ReceiptSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptSyncServiceHash();

  @$internal
  @override
  $ProviderElement<ReceiptSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ReceiptSyncService create(Ref ref) {
    return receiptSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ReceiptSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ReceiptSyncService>(value),
    );
  }
}

String _$receiptSyncServiceHash() =>
    r'8c14aa4e5a73912c1d9905ca559947deb2a80d99';

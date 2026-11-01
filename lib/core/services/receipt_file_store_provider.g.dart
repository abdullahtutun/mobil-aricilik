// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receipt_file_store_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Fiş fotoğrafları (uygulama klasöründe `receipts/`). Testler geçici
/// klasörle override eder.

@ProviderFor(receiptFileStore)
final receiptFileStoreProvider = ReceiptFileStoreProvider._();

/// Fiş fotoğrafları (uygulama klasöründe `receipts/`). Testler geçici
/// klasörle override eder.

final class ReceiptFileStoreProvider
    extends $FunctionalProvider<MediaFileStore, MediaFileStore, MediaFileStore>
    with $Provider<MediaFileStore> {
  /// Fiş fotoğrafları (uygulama klasöründe `receipts/`). Testler geçici
  /// klasörle override eder.
  ReceiptFileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'receiptFileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$receiptFileStoreHash();

  @$internal
  @override
  $ProviderElement<MediaFileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaFileStore create(Ref ref) {
    return receiptFileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaFileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaFileStore>(value),
    );
  }
}

String _$receiptFileStoreHash() => r'46b541675a4328936c4bb0c4c710c482d6be8c80';

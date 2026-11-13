// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek belge dosyası yükleyicisi; kilit bu örneğe bağlı
/// olduğu için canlı tutulur.

@ProviderFor(documentSyncService)
final documentSyncServiceProvider = DocumentSyncServiceProvider._();

/// Uygulamadaki tek belge dosyası yükleyicisi; kilit bu örneğe bağlı
/// olduğu için canlı tutulur.

final class DocumentSyncServiceProvider
    extends
        $FunctionalProvider<
          DocumentSyncService,
          DocumentSyncService,
          DocumentSyncService
        >
    with $Provider<DocumentSyncService> {
  /// Uygulamadaki tek belge dosyası yükleyicisi; kilit bu örneğe bağlı
  /// olduğu için canlı tutulur.
  DocumentSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentSyncServiceHash();

  @$internal
  @override
  $ProviderElement<DocumentSyncService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentSyncService create(Ref ref) {
    return documentSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentSyncService>(value),
    );
  }
}

String _$documentSyncServiceHash() =>
    r'9282f0e14ab16ddd581bd75c3c58bc1d327c59ec';

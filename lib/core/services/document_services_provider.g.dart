// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_services_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Belge kasasının dosyaları (uygulama klasöründe `documents/`). Testler
/// geçici klasörle override eder.

@ProviderFor(documentFileStore)
final documentFileStoreProvider = DocumentFileStoreProvider._();

/// Belge kasasının dosyaları (uygulama klasöründe `documents/`). Testler
/// geçici klasörle override eder.

final class DocumentFileStoreProvider
    extends $FunctionalProvider<MediaFileStore, MediaFileStore, MediaFileStore>
    with $Provider<MediaFileStore> {
  /// Belge kasasının dosyaları (uygulama klasöründe `documents/`). Testler
  /// geçici klasörle override eder.
  DocumentFileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentFileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentFileStoreHash();

  @$internal
  @override
  $ProviderElement<MediaFileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MediaFileStore create(Ref ref) {
    return documentFileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaFileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaFileStore>(value),
    );
  }
}

String _$documentFileStoreHash() => r'f4bc48c162541db22d29029425e145b1d6f8cd98';

/// Testler sahte seçiciyle override eder.

@ProviderFor(documentPicker)
final documentPickerProvider = DocumentPickerProvider._();

/// Testler sahte seçiciyle override eder.

final class DocumentPickerProvider
    extends $FunctionalProvider<DocumentPicker, DocumentPicker, DocumentPicker>
    with $Provider<DocumentPicker> {
  /// Testler sahte seçiciyle override eder.
  DocumentPickerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentPickerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentPickerHash();

  @$internal
  @override
  $ProviderElement<DocumentPicker> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DocumentPicker create(Ref ref) {
    return documentPicker(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentPicker value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentPicker>(value),
    );
  }
}

String _$documentPickerHash() => r'ef566c69b069cf97937fa4bbd5eee3e33b3c0053';

/// Testler sahte çiziciyle override eder.

@ProviderFor(pdfPageRenderer)
final pdfPageRendererProvider = PdfPageRendererProvider._();

/// Testler sahte çiziciyle override eder.

final class PdfPageRendererProvider
    extends
        $FunctionalProvider<PdfPageRenderer, PdfPageRenderer, PdfPageRenderer>
    with $Provider<PdfPageRenderer> {
  /// Testler sahte çiziciyle override eder.
  PdfPageRendererProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pdfPageRendererProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pdfPageRendererHash();

  @$internal
  @override
  $ProviderElement<PdfPageRenderer> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PdfPageRenderer create(Ref ref) {
    return pdfPageRenderer(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PdfPageRenderer value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PdfPageRenderer>(value),
    );
  }
}

String _$pdfPageRendererHash() => r'11b2636c934850fb81049473d293dac89119cfb3';

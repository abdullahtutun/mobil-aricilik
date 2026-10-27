// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(documentRepository)
final documentRepositoryProvider = DocumentRepositoryProvider._();

final class DocumentRepositoryProvider
    extends
        $FunctionalProvider<
          DocumentRepository,
          DocumentRepository,
          DocumentRepository
        >
    with $Provider<DocumentRepository> {
  DocumentRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentRepositoryHash();

  @$internal
  @override
  $ProviderElement<DocumentRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  DocumentRepository create(Ref ref) {
    return documentRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DocumentRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DocumentRepository>(value),
    );
  }
}

String _$documentRepositoryHash() =>
    r'e6f946b7c3ccb3c22113816d1f970d52bfb0808c';

/// Oturumdaki işletmenin belgeleri kasa sırasıyla; işletme yoksa boş.

@ProviderFor(documents)
final documentsProvider = DocumentsProvider._();

/// Oturumdaki işletmenin belgeleri kasa sırasıyla; işletme yoksa boş.

final class DocumentsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<VaultDocument>>,
          List<VaultDocument>,
          Stream<List<VaultDocument>>
        >
    with
        $FutureModifier<List<VaultDocument>>,
        $StreamProvider<List<VaultDocument>> {
  /// Oturumdaki işletmenin belgeleri kasa sırasıyla; işletme yoksa boş.
  DocumentsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentsHash();

  @$internal
  @override
  $StreamProviderElement<List<VaultDocument>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<VaultDocument>> create(Ref ref) {
    return documents(ref);
  }
}

String _$documentsHash() => r'da8ac6f3491b801c2d6d40bb4f349915bebea864';

/// Belge; yoksa ya da silinmişse null.

@ProviderFor(document)
final documentProvider = DocumentFamily._();

/// Belge; yoksa ya da silinmişse null.

final class DocumentProvider
    extends
        $FunctionalProvider<
          AsyncValue<VaultDocument?>,
          VaultDocument?,
          Stream<VaultDocument?>
        >
    with $FutureModifier<VaultDocument?>, $StreamProvider<VaultDocument?> {
  /// Belge; yoksa ya da silinmişse null.
  DocumentProvider._({
    required DocumentFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentHash();

  @override
  String toString() {
    return r'documentProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<VaultDocument?> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<VaultDocument?> create(Ref ref) {
    final argument = this.argument as String;
    return document(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentHash() => r'490ea92289dab474e4e4965e65503b1dc68e63ac';

/// Belge; yoksa ya da silinmişse null.

final class DocumentFamily extends $Family
    with $FunctionalFamilyOverride<Stream<VaultDocument?>, String> {
  DocumentFamily._()
    : super(
        retry: null,
        name: r'documentProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Belge; yoksa ya da silinmişse null.

  DocumentProvider call(String id) =>
      DocumentProvider._(argument: id, from: this);

  @override
  String toString() => r'documentProvider';
}

/// Daha önce yazılmış kullanıcı tanımlı türler (formda öneri).

@ProviderFor(customDocumentTypeNames)
final customDocumentTypeNamesProvider = CustomDocumentTypeNamesProvider._();

/// Daha önce yazılmış kullanıcı tanımlı türler (formda öneri).

final class CustomDocumentTypeNamesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<String>>,
          List<String>,
          FutureOr<List<String>>
        >
    with $FutureModifier<List<String>>, $FutureProvider<List<String>> {
  /// Daha önce yazılmış kullanıcı tanımlı türler (formda öneri).
  CustomDocumentTypeNamesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'customDocumentTypeNamesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$customDocumentTypeNamesHash();

  @$internal
  @override
  $FutureProviderElement<List<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<String>> create(Ref ref) {
    return customDocumentTypeNames(ref);
  }
}

String _$customDocumentTypeNamesHash() =>
    r'b924f9807f3c67f95f8cd70d1f2e495610473f2f';

/// Dosyası bu telefonda olan belgelerin `storage_path`'leri. Belgeler
/// değişince ve dosya indirilince (tetikleyici yeniler) yeniden hesaplanır.

@ProviderFor(documentLocalFiles)
final documentLocalFilesProvider = DocumentLocalFilesProvider._();

/// Dosyası bu telefonda olan belgelerin `storage_path`'leri. Belgeler
/// değişince ve dosya indirilince (tetikleyici yeniler) yeniden hesaplanır.

final class DocumentLocalFilesProvider
    extends
        $FunctionalProvider<
          AsyncValue<Set<String>>,
          Set<String>,
          FutureOr<Set<String>>
        >
    with $FutureModifier<Set<String>>, $FutureProvider<Set<String>> {
  /// Dosyası bu telefonda olan belgelerin `storage_path`'leri. Belgeler
  /// değişince ve dosya indirilince (tetikleyici yeniler) yeniden hesaplanır.
  DocumentLocalFilesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentLocalFilesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentLocalFilesHash();

  @$internal
  @override
  $FutureProviderElement<Set<String>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Set<String>> create(Ref ref) {
    return documentLocalFiles(ref);
  }
}

String _$documentLocalFilesHash() =>
    r'f0aa4234b26de5af0bb352961ed6c40b862937f4';

/// Belge dosyası bu telefonda varsa; yoksa null.

@ProviderFor(documentFile)
final documentFileProvider = DocumentFileFamily._();

/// Belge dosyası bu telefonda varsa; yoksa null.

final class DocumentFileProvider
    extends $FunctionalProvider<AsyncValue<File?>, File?, FutureOr<File?>>
    with $FutureModifier<File?>, $FutureProvider<File?> {
  /// Belge dosyası bu telefonda varsa; yoksa null.
  DocumentFileProvider._({
    required DocumentFileFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentFileProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentFileHash();

  @override
  String toString() {
    return r'documentFileProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<File?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<File?> create(Ref ref) {
    final argument = this.argument as String;
    return documentFile(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentFileProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentFileHash() => r'068d4dc31339831a708445aaa406c188614f0e49';

/// Belge dosyası bu telefonda varsa; yoksa null.

final class DocumentFileFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<File?>, String> {
  DocumentFileFamily._()
    : super(
        retry: null,
        name: r'documentFileProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Belge dosyası bu telefonda varsa; yoksa null.

  DocumentFileProvider call(String storagePath) =>
      DocumentFileProvider._(argument: storagePath, from: this);

  @override
  String toString() => r'documentFileProvider';
}

/// PDF belgenin sayfaları (PNG); dosya bu telefonda yoksa null.

@ProviderFor(documentPdfPages)
final documentPdfPagesProvider = DocumentPdfPagesFamily._();

/// PDF belgenin sayfaları (PNG); dosya bu telefonda yoksa null.

final class DocumentPdfPagesProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Uint8List>?>,
          List<Uint8List>?,
          FutureOr<List<Uint8List>?>
        >
    with $FutureModifier<List<Uint8List>?>, $FutureProvider<List<Uint8List>?> {
  /// PDF belgenin sayfaları (PNG); dosya bu telefonda yoksa null.
  DocumentPdfPagesProvider._({
    required DocumentPdfPagesFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'documentPdfPagesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$documentPdfPagesHash();

  @override
  String toString() {
    return r'documentPdfPagesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Uint8List>?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Uint8List>?> create(Ref ref) {
    final argument = this.argument as String;
    return documentPdfPages(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is DocumentPdfPagesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$documentPdfPagesHash() => r'b2f12c8f57684dd5d12280846d3c1130fa3356db';

/// PDF belgenin sayfaları (PNG); dosya bu telefonda yoksa null.

final class DocumentPdfPagesFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<Uint8List>?>, String> {
  DocumentPdfPagesFamily._()
    : super(
        retry: null,
        name: r'documentPdfPagesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// PDF belgenin sayfaları (PNG); dosya bu telefonda yoksa null.

  DocumentPdfPagesProvider call(String storagePath) =>
      DocumentPdfPagesProvider._(argument: storagePath, from: this);

  @override
  String toString() => r'documentPdfPagesProvider';
}

/// Belge kasasındaki eylemler.

@ProviderFor(DocumentActions)
final documentActionsProvider = DocumentActionsProvider._();

/// Belge kasasındaki eylemler.
final class DocumentActionsProvider
    extends $NotifierProvider<DocumentActions, void> {
  /// Belge kasasındaki eylemler.
  DocumentActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentActionsHash();

  @$internal
  @override
  DocumentActions create() => DocumentActions();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$documentActionsHash() => r'eb6c337b09b5d34652f6efd2e4dc826103bd7e01';

/// Belge kasasındaki eylemler.

abstract class _$DocumentActions extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'export_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(exportRepository)
final exportRepositoryProvider = ExportRepositoryProvider._();

final class ExportRepositoryProvider
    extends
        $FunctionalProvider<
          ExportRepository,
          ExportRepository,
          ExportRepository
        >
    with $Provider<ExportRepository> {
  ExportRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exportRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exportRepositoryHash();

  @$internal
  @override
  $ProviderElement<ExportRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ExportRepository create(Ref ref) {
    return exportRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ExportRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ExportRepository>(value),
    );
  }
}

String _$exportRepositoryHash() => r'560109b58ee49b9aea7ef593ff2a1d3fd90bf371';

/// "Verileri dışa aktar": işletmenin ana kayıtlarını tek Excel dosyasına
/// yazar ve sistemin paylaşma sayfasıyla telefondan çıkarır (Drive,
/// e-posta, WhatsApp, Dosyalar). İnternet gerekmez; dosya yerel DB'den
/// üretilir. Durum hazırlanıyor mu; sürerken yeni istek yok sayılır.

@ProviderFor(DataExport)
final dataExportProvider = DataExportProvider._();

/// "Verileri dışa aktar": işletmenin ana kayıtlarını tek Excel dosyasına
/// yazar ve sistemin paylaşma sayfasıyla telefondan çıkarır (Drive,
/// e-posta, WhatsApp, Dosyalar). İnternet gerekmez; dosya yerel DB'den
/// üretilir. Durum hazırlanıyor mu; sürerken yeni istek yok sayılır.
final class DataExportProvider extends $NotifierProvider<DataExport, bool> {
  /// "Verileri dışa aktar": işletmenin ana kayıtlarını tek Excel dosyasına
  /// yazar ve sistemin paylaşma sayfasıyla telefondan çıkarır (Drive,
  /// e-posta, WhatsApp, Dosyalar). İnternet gerekmez; dosya yerel DB'den
  /// üretilir. Durum hazırlanıyor mu; sürerken yeni istek yok sayılır.
  DataExportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dataExportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dataExportHash();

  @$internal
  @override
  DataExport create() => DataExport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$dataExportHash() => r'676f07cd91314de03b1e8ec1c61ea3a053d30525';

/// "Verileri dışa aktar": işletmenin ana kayıtlarını tek Excel dosyasına
/// yazar ve sistemin paylaşma sayfasıyla telefondan çıkarır (Drive,
/// e-posta, WhatsApp, Dosyalar). İnternet gerekmez; dosya yerel DB'den
/// üretilir. Durum hazırlanıyor mu; sürerken yeni istek yok sayılır.

abstract class _$DataExport extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// "Belge dosyalarını dışa aktar": belge kasasının bu telefondaki
/// dosyalarını tek ZIP'e yazar ([encodeDocumentArchive]) ve paylaşma
/// sayfasıyla çıkarır. Belge dosyaları sunucuya yüklenmediği için telefon
/// değişirken yedek budur. İnternet gerekmez. Durum hazırlanıyor mu;
/// sürerken yeni istek yok sayılır.

@ProviderFor(DocumentExport)
final documentExportProvider = DocumentExportProvider._();

/// "Belge dosyalarını dışa aktar": belge kasasının bu telefondaki
/// dosyalarını tek ZIP'e yazar ([encodeDocumentArchive]) ve paylaşma
/// sayfasıyla çıkarır. Belge dosyaları sunucuya yüklenmediği için telefon
/// değişirken yedek budur. İnternet gerekmez. Durum hazırlanıyor mu;
/// sürerken yeni istek yok sayılır.
final class DocumentExportProvider
    extends $NotifierProvider<DocumentExport, bool> {
  /// "Belge dosyalarını dışa aktar": belge kasasının bu telefondaki
  /// dosyalarını tek ZIP'e yazar ([encodeDocumentArchive]) ve paylaşma
  /// sayfasıyla çıkarır. Belge dosyaları sunucuya yüklenmediği için telefon
  /// değişirken yedek budur. İnternet gerekmez. Durum hazırlanıyor mu;
  /// sürerken yeni istek yok sayılır.
  DocumentExportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentExportProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentExportHash();

  @$internal
  @override
  DocumentExport create() => DocumentExport();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$documentExportHash() => r'64fd861b976a0a7269642341f0bd9f0ff648c0ef';

/// "Belge dosyalarını dışa aktar": belge kasasının bu telefondaki
/// dosyalarını tek ZIP'e yazar ([encodeDocumentArchive]) ve paylaşma
/// sayfasıyla çıkarır. Belge dosyaları sunucuya yüklenmediği için telefon
/// değişirken yedek budur. İnternet gerekmez. Durum hazırlanıyor mu;
/// sürerken yeni istek yok sayılır.

abstract class _$DocumentExport extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

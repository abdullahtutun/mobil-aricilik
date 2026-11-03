// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'document_file_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulama açıkken belge dosyalarını yükler ve eksikleri indirir; anlar
/// [listenStorageFileSync]'te. İndirilen dosya olursa kasadaki "internetsiz
/// açılır" durumu yenilenir. `bootstrap` uygulama boyunca dinler.

@ProviderFor(documentFileTriggers)
final documentFileTriggersProvider = DocumentFileTriggersProvider._();

/// Uygulama açıkken belge dosyalarını yükler ve eksikleri indirir; anlar
/// [listenStorageFileSync]'te. İndirilen dosya olursa kasadaki "internetsiz
/// açılır" durumu yenilenir. `bootstrap` uygulama boyunca dinler.

final class DocumentFileTriggersProvider
    extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Uygulama açıkken belge dosyalarını yükler ve eksikleri indirir; anlar
  /// [listenStorageFileSync]'te. İndirilen dosya olursa kasadaki "internetsiz
  /// açılır" durumu yenilenir. `bootstrap` uygulama boyunca dinler.
  DocumentFileTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'documentFileTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$documentFileTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return documentFileTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$documentFileTriggersHash() =>
    r'179c6e5f1db0718b33442948bc62763d9aada503';

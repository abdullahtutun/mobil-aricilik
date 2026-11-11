// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Senkronun sunucuyla konuştuğu taşıyıcı; [backendProvider]'a göre.

@ProviderFor(syncTransport)
final syncTransportProvider = SyncTransportProvider._();

/// Senkronun sunucuyla konuştuğu taşıyıcı; [backendProvider]'a göre.

final class SyncTransportProvider
    extends $FunctionalProvider<SyncTransport, SyncTransport, SyncTransport>
    with $Provider<SyncTransport> {
  /// Senkronun sunucuyla konuştuğu taşıyıcı; [backendProvider]'a göre.
  SyncTransportProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncTransportProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncTransportHash();

  @$internal
  @override
  $ProviderElement<SyncTransport> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncTransport create(Ref ref) {
    return syncTransport(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncTransport value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncTransport>(value),
    );
  }
}

String _$syncTransportHash() => r'974dcb13b441e415d592e61145b2545d9c608cb5';

/// Sunucudaki dosya deposu; [backendProvider]'a göre.

@ProviderFor(fileStore)
final fileStoreProvider = FileStoreProvider._();

/// Sunucudaki dosya deposu; [backendProvider]'a göre.

final class FileStoreProvider
    extends $FunctionalProvider<FileStore, FileStore, FileStore>
    with $Provider<FileStore> {
  /// Sunucudaki dosya deposu; [backendProvider]'a göre.
  FileStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fileStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fileStoreHash();

  @$internal
  @override
  $ProviderElement<FileStore> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  FileStore create(Ref ref) {
    return fileStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(FileStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<FileStore>(value),
    );
  }
}

String _$fileStoreHash() => r'0d0e84e920cb265cfab27de1f3c55932bcec0a33';

/// Görüş ve kullanım olayı satırlarının yazıldığı yer; [backendProvider]'a
/// göre.

@ProviderFor(telemetryApi)
final telemetryApiProvider = TelemetryApiProvider._();

/// Görüş ve kullanım olayı satırlarının yazıldığı yer; [backendProvider]'a
/// göre.

final class TelemetryApiProvider
    extends $FunctionalProvider<TelemetryApi, TelemetryApi, TelemetryApi>
    with $Provider<TelemetryApi> {
  /// Görüş ve kullanım olayı satırlarının yazıldığı yer; [backendProvider]'a
  /// göre.
  TelemetryApiProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'telemetryApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$telemetryApiHash();

  @$internal
  @override
  $ProviderElement<TelemetryApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  TelemetryApi create(Ref ref) {
    return telemetryApi(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(TelemetryApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<TelemetryApi>(value),
    );
  }
}

String _$telemetryApiHash() => r'1a5eae7526e67f7b1826d68765de8ed44b726b43';

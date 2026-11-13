// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Senkronun sunucuyla konuştuğu taşıyıcı.

@ProviderFor(syncTransport)
final syncTransportProvider = SyncTransportProvider._();

/// Senkronun sunucuyla konuştuğu taşıyıcı.

final class SyncTransportProvider
    extends $FunctionalProvider<SyncTransport, SyncTransport, SyncTransport>
    with $Provider<SyncTransport> {
  /// Senkronun sunucuyla konuştuğu taşıyıcı.
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

String _$syncTransportHash() => r'e941678733a19c734800b42f969d9922aeb05afa';

/// Sunucudaki dosya deposu.

@ProviderFor(fileStore)
final fileStoreProvider = FileStoreProvider._();

/// Sunucudaki dosya deposu.

final class FileStoreProvider
    extends $FunctionalProvider<FileStore, FileStore, FileStore>
    with $Provider<FileStore> {
  /// Sunucudaki dosya deposu.
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

String _$fileStoreHash() => r'80694c536f0666edf0b8078696fbbb685f3505ca';

/// Görüş ve kullanım olayı satırlarının yazıldığı yer.

@ProviderFor(telemetryApi)
final telemetryApiProvider = TelemetryApiProvider._();

/// Görüş ve kullanım olayı satırlarının yazıldığı yer.

final class TelemetryApiProvider
    extends $FunctionalProvider<TelemetryApi, TelemetryApi, TelemetryApi>
    with $Provider<TelemetryApi> {
  /// Görüş ve kullanım olayı satırlarının yazıldığı yer.
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

String _$telemetryApiHash() => r'60beb19ef35b4edbbf94417acd30e44452f7beb7';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek senkron servisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

@ProviderFor(syncService)
final syncServiceProvider = SyncServiceProvider._();

/// Uygulamadaki tek senkron servisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

final class SyncServiceProvider
    extends $FunctionalProvider<SyncService, SyncService, SyncService>
    with $Provider<SyncService> {
  /// Uygulamadaki tek senkron servisi; kilit bu örneğe bağlı olduğu için
  /// canlı tutulur.
  SyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncServiceHash();

  @$internal
  @override
  $ProviderElement<SyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncService create(Ref ref) {
    return syncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncService>(value),
    );
  }
}

String _$syncServiceHash() => r'aed05f2d5ae4c8f8a04610a99d71a25ba473c100';

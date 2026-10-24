// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_triggers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Senkronu tetikler (teknik.md §3, "Ne zaman çalışır"):
///
/// - açılış: oturum ve işletme hazır olunca (girişten sonra da),
/// - yerel yazmadan [syncDebounce] sonra,
/// - ağ geri gelince,
/// - workmanager'ın periyodik görevi uygulama açıkken çalışırsa
///   ([foregroundSyncPortName] üzerinden).
///
/// Oturum ya da işletme yokken tetikler tur başlatmaz
/// ([SyncController.sync]). `bootstrap` uygulama boyunca dinler.

@ProviderFor(syncTriggers)
final syncTriggersProvider = SyncTriggersProvider._();

/// Senkronu tetikler (teknik.md §3, "Ne zaman çalışır"):
///
/// - açılış: oturum ve işletme hazır olunca (girişten sonra da),
/// - yerel yazmadan [syncDebounce] sonra,
/// - ağ geri gelince,
/// - workmanager'ın periyodik görevi uygulama açıkken çalışırsa
///   ([foregroundSyncPortName] üzerinden).
///
/// Oturum ya da işletme yokken tetikler tur başlatmaz
/// ([SyncController.sync]). `bootstrap` uygulama boyunca dinler.

final class SyncTriggersProvider extends $FunctionalProvider<void, void, void>
    with $Provider<void> {
  /// Senkronu tetikler (teknik.md §3, "Ne zaman çalışır"):
  ///
  /// - açılış: oturum ve işletme hazır olunca (girişten sonra da),
  /// - yerel yazmadan [syncDebounce] sonra,
  /// - ağ geri gelince,
  /// - workmanager'ın periyodik görevi uygulama açıkken çalışırsa
  ///   ([foregroundSyncPortName] üzerinden).
  ///
  /// Oturum ya da işletme yokken tetikler tur başlatmaz
  /// ([SyncController.sync]). `bootstrap` uygulama boyunca dinler.
  SyncTriggersProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncTriggersProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncTriggersHash();

  @$internal
  @override
  $ProviderElement<void> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  void create(Ref ref) {
    return syncTriggers(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$syncTriggersHash() => r'de3f02fbddd66b8f2b38ad63cdf50b2ad000306c';

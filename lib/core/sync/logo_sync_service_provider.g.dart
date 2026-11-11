// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'logo_sync_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Uygulamadaki tek logo yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

@ProviderFor(logoSyncService)
final logoSyncServiceProvider = LogoSyncServiceProvider._();

/// Uygulamadaki tek logo yükleyicisi; kilit bu örneğe bağlı olduğu için
/// canlı tutulur.

final class LogoSyncServiceProvider
    extends
        $FunctionalProvider<LogoSyncService, LogoSyncService, LogoSyncService>
    with $Provider<LogoSyncService> {
  /// Uygulamadaki tek logo yükleyicisi; kilit bu örneğe bağlı olduğu için
  /// canlı tutulur.
  LogoSyncServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'logoSyncServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$logoSyncServiceHash();

  @$internal
  @override
  $ProviderElement<LogoSyncService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LogoSyncService create(Ref ref) {
    return logoSyncService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LogoSyncService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LogoSyncService>(value),
    );
  }
}

String _$logoSyncServiceHash() => r'5fe5446da4083a827285fad4720ca0b1fa86c151';

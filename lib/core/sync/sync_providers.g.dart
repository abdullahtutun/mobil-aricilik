// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(syncRepository)
final syncRepositoryProvider = SyncRepositoryProvider._();

final class SyncRepositoryProvider
    extends $FunctionalProvider<SyncRepository, SyncRepository, SyncRepository>
    with $Provider<SyncRepository> {
  SyncRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRepositoryHash();

  @$internal
  @override
  $ProviderElement<SyncRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SyncRepository create(Ref ref) {
    return syncRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SyncRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SyncRepository>(value),
    );
  }
}

String _$syncRepositoryHash() => r'a3749b090bdf027b8d71f7d4d310b31a223cfba0';

/// Gönderilmeyi bekleyen kayıt sayısı.

@ProviderFor(syncPendingCount)
final syncPendingCountProvider = SyncPendingCountProvider._();

/// Gönderilmeyi bekleyen kayıt sayısı.

final class SyncPendingCountProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// Gönderilmeyi bekleyen kayıt sayısı.
  SyncPendingCountProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncPendingCountProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncPendingCountHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return syncPendingCount(ref);
  }
}

String _$syncPendingCountHash() => r'3e8aa963cf6f81370a1554b0e3c41f7ece6be9c7';

/// Gönderilmeyi bekleyen kayıtların tabloya göre sayısı.

@ProviderFor(syncPendingByTable)
final syncPendingByTableProvider = SyncPendingByTableProvider._();

/// Gönderilmeyi bekleyen kayıtların tabloya göre sayısı.

final class SyncPendingByTableProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          Stream<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $StreamProvider<Map<String, int>> {
  /// Gönderilmeyi bekleyen kayıtların tabloya göre sayısı.
  SyncPendingByTableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncPendingByTableProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncPendingByTableHash();

  @$internal
  @override
  $StreamProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<Map<String, int>> create(Ref ref) {
    return syncPendingByTable(ref);
  }
}

String _$syncPendingByTableHash() =>
    r'a21998f536e3a298e6fc22ebe23220f4bcc66451';

/// Gönderilmeyi bekleyen en eski kaydın yazıldığı an; yoksa null.

@ProviderFor(syncOldestPendingAt)
final syncOldestPendingAtProvider = SyncOldestPendingAtProvider._();

/// Gönderilmeyi bekleyen en eski kaydın yazıldığı an; yoksa null.

final class SyncOldestPendingAtProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime?>, DateTime?, Stream<DateTime?>>
    with $FutureModifier<DateTime?>, $StreamProvider<DateTime?> {
  /// Gönderilmeyi bekleyen en eski kaydın yazıldığı an; yoksa null.
  SyncOldestPendingAtProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncOldestPendingAtProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncOldestPendingAtHash();

  @$internal
  @override
  $StreamProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime?> create(Ref ref) {
    return syncOldestPendingAt(ref);
  }
}

String _$syncOldestPendingAtHash() =>
    r'f4b6afb3f464b1726724e8a6c273c3cd27325ae1';

/// Son başarılı senkron turunun bittiği an (bu telefonda, kalıcı).

@ProviderFor(lastSyncedAt)
final lastSyncedAtProvider = LastSyncedAtProvider._();

/// Son başarılı senkron turunun bittiği an (bu telefonda, kalıcı).

final class LastSyncedAtProvider
    extends
        $FunctionalProvider<AsyncValue<DateTime?>, DateTime?, Stream<DateTime?>>
    with $FutureModifier<DateTime?>, $StreamProvider<DateTime?> {
  /// Son başarılı senkron turunun bittiği an (bu telefonda, kalıcı).
  LastSyncedAtProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastSyncedAtProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastSyncedAtHash();

  @$internal
  @override
  $StreamProviderElement<DateTime?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<DateTime?> create(Ref ref) {
    return lastSyncedAt(ref);
  }
}

String _$lastSyncedAtHash() => r'88be5176ef82f767aa990d115e32163262fd0344';

/// Bekleyen kayıt [syncOverdueAfter]'dan uzun süredir gönderilemedi;
/// Bugün ve senkron ekranı uyarır. Süre bekleyenler değişince yeniden
/// hesaplanır.

@ProviderFor(syncOverdue)
final syncOverdueProvider = SyncOverdueProvider._();

/// Bekleyen kayıt [syncOverdueAfter]'dan uzun süredir gönderilemedi;
/// Bugün ve senkron ekranı uyarır. Süre bekleyenler değişince yeniden
/// hesaplanır.

final class SyncOverdueProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Bekleyen kayıt [syncOverdueAfter]'dan uzun süredir gönderilemedi;
  /// Bugün ve senkron ekranı uyarır. Süre bekleyenler değişince yeniden
  /// hesaplanır.
  SyncOverdueProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncOverdueProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncOverdueHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return syncOverdue(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$syncOverdueHash() => r'0053496e4c99370c0111a094c9f916364b34d7d7';

/// Sunucunun reddettiği kayıtlar.

@ProviderFor(syncRejected)
final syncRejectedProvider = SyncRejectedProvider._();

/// Sunucunun reddettiği kayıtlar.

final class SyncRejectedProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<RejectedRecord>>,
          List<RejectedRecord>,
          Stream<List<RejectedRecord>>
        >
    with
        $FutureModifier<List<RejectedRecord>>,
        $StreamProvider<List<RejectedRecord>> {
  /// Sunucunun reddettiği kayıtlar.
  SyncRejectedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncRejectedProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncRejectedHash();

  @$internal
  @override
  $StreamProviderElement<List<RejectedRecord>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<RejectedRecord>> create(Ref ref) {
    return syncRejected(ref);
  }
}

String _$syncRejectedHash() => r'cf2b2de42916ce148011676d99f4f3ef47ff2d78';

/// Bu cihazda ilk tam çekme bitti mi; router ilk girişte sekmeleri bitene
/// kadar açmaz.

@ProviderFor(fullPullDone)
final fullPullDoneProvider = FullPullDoneProvider._();

/// Bu cihazda ilk tam çekme bitti mi; router ilk girişte sekmeleri bitene
/// kadar açmaz.

final class FullPullDoneProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, Stream<bool>>
    with $FutureModifier<bool>, $StreamProvider<bool> {
  /// Bu cihazda ilk tam çekme bitti mi; router ilk girişte sekmeleri bitene
  /// kadar açmaz.
  FullPullDoneProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'fullPullDoneProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$fullPullDoneHash();

  @$internal
  @override
  $StreamProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<bool> create(Ref ref) {
    return fullPullDone(ref);
  }
}

String _$fullPullDoneHash() => r'f57ac1edd0a202a15497d9e4bf078fa5fd8ee8bd';

/// Oturum açık ve işletme belli; senkron yalnız o zaman çalışır.

@ProviderFor(syncReady)
final syncReadyProvider = SyncReadyProvider._();

/// Oturum açık ve işletme belli; senkron yalnız o zaman çalışır.

final class SyncReadyProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// Oturum açık ve işletme belli; senkron yalnız o zaman çalışır.
  SyncReadyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'syncReadyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$syncReadyHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return syncReady(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$syncReadyHash() => r'ec2084a394030b8d611e1f650129915a6601241a';

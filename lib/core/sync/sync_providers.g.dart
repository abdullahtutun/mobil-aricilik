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

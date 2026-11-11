// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_deletion_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(accountDeletionService)
final accountDeletionServiceProvider = AccountDeletionServiceProvider._();

/// Testler sahtesiyle override eder.

final class AccountDeletionServiceProvider
    extends
        $FunctionalProvider<
          AccountDeletionService,
          AccountDeletionService,
          AccountDeletionService
        >
    with $Provider<AccountDeletionService> {
  /// Testler sahtesiyle override eder.
  AccountDeletionServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountDeletionServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountDeletionServiceHash();

  @$internal
  @override
  $ProviderElement<AccountDeletionService> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountDeletionService create(Ref ref) {
    return accountDeletionService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountDeletionService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountDeletionService>(value),
    );
  }
}

String _$accountDeletionServiceHash() =>
    r'aeed7a8d52489f505e075f37f927ff59bb0e6cca';

@ProviderFor(accountDeletionRepository)
final accountDeletionRepositoryProvider = AccountDeletionRepositoryProvider._();

final class AccountDeletionRepositoryProvider
    extends
        $FunctionalProvider<
          AccountDeletionRepository,
          AccountDeletionRepository,
          AccountDeletionRepository
        >
    with $Provider<AccountDeletionRepository> {
  AccountDeletionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountDeletionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountDeletionRepositoryHash();

  @$internal
  @override
  $ProviderElement<AccountDeletionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountDeletionRepository create(Ref ref) {
    return accountDeletionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountDeletionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountDeletionRepository>(value),
    );
  }
}

String _$accountDeletionRepositoryHash() =>
    r'ba7300c8fd50b3b661a25a367ceeee6084344e1c';

/// Testler geçici klasörlerle override eder.

@ProviderFor(deviceDataWiper)
final deviceDataWiperProvider = DeviceDataWiperProvider._();

/// Testler geçici klasörlerle override eder.

final class DeviceDataWiperProvider
    extends
        $FunctionalProvider<DeviceDataWiper, DeviceDataWiper, DeviceDataWiper>
    with $Provider<DeviceDataWiper> {
  /// Testler geçici klasörlerle override eder.
  DeviceDataWiperProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deviceDataWiperProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deviceDataWiperHash();

  @$internal
  @override
  $ProviderElement<DeviceDataWiper> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeviceDataWiper create(Ref ref) {
    return deviceDataWiper(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeviceDataWiper value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeviceDataWiper>(value),
    );
  }
}

String _$deviceDataWiperHash() => r'50640b37870242870356921adf3d2d5d9c7142e9';

/// Oturumdaki işletmede kullanıcının durumu (tek kişilik sahip, ekipli
/// sahip, üye); üyelik henüz inmediyse bilinmiyor.

@ProviderFor(deletionScenario)
final deletionScenarioProvider = DeletionScenarioProvider._();

/// Oturumdaki işletmede kullanıcının durumu (tek kişilik sahip, ekipli
/// sahip, üye); üyelik henüz inmediyse bilinmiyor.

final class DeletionScenarioProvider
    extends
        $FunctionalProvider<
          DeletionScenario,
          DeletionScenario,
          DeletionScenario
        >
    with $Provider<DeletionScenario> {
  /// Oturumdaki işletmede kullanıcının durumu (tek kişilik sahip, ekipli
  /// sahip, üye); üyelik henüz inmediyse bilinmiyor.
  DeletionScenarioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletionScenarioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletionScenarioHash();

  @$internal
  @override
  $ProviderElement<DeletionScenario> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DeletionScenario create(Ref ref) {
    return deletionScenario(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeletionScenario value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeletionScenario>(value),
    );
  }
}

String _$deletionScenarioHash() => r'38a1a316089202df7ffe7f6d6aabcb47bb6b2a1e';

/// İşletme silinirse gidecek kayıtların sayıları; yerel DB'den canlı.

@ProviderFor(deletionCounts)
final deletionCountsProvider = DeletionCountsProvider._();

/// İşletme silinirse gidecek kayıtların sayıları; yerel DB'den canlı.

final class DeletionCountsProvider
    extends
        $FunctionalProvider<
          AsyncValue<DeletionCounts>,
          DeletionCounts,
          Stream<DeletionCounts>
        >
    with $FutureModifier<DeletionCounts>, $StreamProvider<DeletionCounts> {
  /// İşletme silinirse gidecek kayıtların sayıları; yerel DB'den canlı.
  DeletionCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'deletionCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$deletionCountsHash();

  @$internal
  @override
  $StreamProviderElement<DeletionCounts> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<DeletionCounts> create(Ref ref) {
    return deletionCounts(ref);
  }
}

String _$deletionCountsHash() => r'3dba88546c2bf1f2607b1ea961260a4afcaac5e3';

/// Oturumdaki kullanıcının bekleyen silme talebi; varsa router kullanıcıyı
/// önce "Hesabın silinmek üzere" ekranına götürür. Giriş yapılınca bir kez
/// sorulur. Sorulamazsa (çevrimdışı) talep yok sayılır; uygulama yine açılır
/// ve sonraki açılışta yeniden sorulur.

@ProviderFor(PendingDeletion)
final pendingDeletionProvider = PendingDeletionProvider._();

/// Oturumdaki kullanıcının bekleyen silme talebi; varsa router kullanıcıyı
/// önce "Hesabın silinmek üzere" ekranına götürür. Giriş yapılınca bir kez
/// sorulur. Sorulamazsa (çevrimdışı) talep yok sayılır; uygulama yine açılır
/// ve sonraki açılışta yeniden sorulur.
final class PendingDeletionProvider
    extends $AsyncNotifierProvider<PendingDeletion, DeletionRequestInfo?> {
  /// Oturumdaki kullanıcının bekleyen silme talebi; varsa router kullanıcıyı
  /// önce "Hesabın silinmek üzere" ekranına götürür. Giriş yapılınca bir kez
  /// sorulur. Sorulamazsa (çevrimdışı) talep yok sayılır; uygulama yine açılır
  /// ve sonraki açılışta yeniden sorulur.
  PendingDeletionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pendingDeletionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pendingDeletionHash();

  @$internal
  @override
  PendingDeletion create() => PendingDeletion();
}

String _$pendingDeletionHash() => r'cb284ae0a2d4abbd5554f585d8002455add2639a';

/// Oturumdaki kullanıcının bekleyen silme talebi; varsa router kullanıcıyı
/// önce "Hesabın silinmek üzere" ekranına götürür. Giriş yapılınca bir kez
/// sorulur. Sorulamazsa (çevrimdışı) talep yok sayılır; uygulama yine açılır
/// ve sonraki açılışta yeniden sorulur.

abstract class _$PendingDeletion extends $AsyncNotifier<DeletionRequestInfo?> {
  FutureOr<DeletionRequestInfo?> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<AsyncValue<DeletionRequestInfo?>, DeletionRequestInfo?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<DeletionRequestInfo?>,
                DeletionRequestInfo?
              >,
              AsyncValue<DeletionRequestInfo?>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(LastDeletionOutcome)
final lastDeletionOutcomeProvider = LastDeletionOutcomeProvider._();

final class LastDeletionOutcomeProvider
    extends $NotifierProvider<LastDeletionOutcome, DeletionOutcome?> {
  LastDeletionOutcomeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'lastDeletionOutcomeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$lastDeletionOutcomeHash();

  @$internal
  @override
  LastDeletionOutcome create() => LastDeletionOutcome();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DeletionOutcome? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DeletionOutcome?>(value),
    );
  }
}

String _$lastDeletionOutcomeHash() =>
    r'd5eceef0f61ed3f14f4fded7c1878cf18c637f4d';

abstract class _$LastDeletionOutcome extends $Notifier<DeletionOutcome?> {
  DeletionOutcome? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<DeletionOutcome?, DeletionOutcome?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<DeletionOutcome?, DeletionOutcome?>,
              DeletionOutcome?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Talep ve cihaz temizliği. İşlem ağ beklerken ekranın dinlemesi bitebilir;
/// `keepAlive` olmazsa `ref` ilk `await`'ten sonra geçersiz olur.

@ProviderFor(accountDeletionActions)
final accountDeletionActionsProvider = AccountDeletionActionsProvider._();

/// Talep ve cihaz temizliği. İşlem ağ beklerken ekranın dinlemesi bitebilir;
/// `keepAlive` olmazsa `ref` ilk `await`'ten sonra geçersiz olur.

final class AccountDeletionActionsProvider
    extends
        $FunctionalProvider<
          AccountDeletionActions,
          AccountDeletionActions,
          AccountDeletionActions
        >
    with $Provider<AccountDeletionActions> {
  /// Talep ve cihaz temizliği. İşlem ağ beklerken ekranın dinlemesi bitebilir;
  /// `keepAlive` olmazsa `ref` ilk `await`'ten sonra geçersiz olur.
  AccountDeletionActionsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'accountDeletionActionsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$accountDeletionActionsHash();

  @$internal
  @override
  $ProviderElement<AccountDeletionActions> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AccountDeletionActions create(Ref ref) {
    return accountDeletionActions(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AccountDeletionActions value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AccountDeletionActions>(value),
    );
  }
}

String _$accountDeletionActionsHash() =>
    r'9fad4668d7ad853cc22561d4f7279a16fa0af205';

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pocketbase_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// `bootstrap`, uygulama açılmadan önce okunan oturumla override eder
/// (`initializePocketBase`); okuma asenkron, istemci senkron kurulur.
/// Override edilmezse oturum yok.

@ProviderFor(storedPocketBaseSession)
final storedPocketBaseSessionProvider = StoredPocketBaseSessionProvider._();

/// `bootstrap`, uygulama açılmadan önce okunan oturumla override eder
/// (`initializePocketBase`); okuma asenkron, istemci senkron kurulur.
/// Override edilmezse oturum yok.

final class StoredPocketBaseSessionProvider
    extends
        $FunctionalProvider<
          StoredPocketBaseSession?,
          StoredPocketBaseSession?,
          StoredPocketBaseSession?
        >
    with $Provider<StoredPocketBaseSession?> {
  /// `bootstrap`, uygulama açılmadan önce okunan oturumla override eder
  /// (`initializePocketBase`); okuma asenkron, istemci senkron kurulur.
  /// Override edilmezse oturum yok.
  StoredPocketBaseSessionProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'storedPocketBaseSessionProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$storedPocketBaseSessionHash();

  @$internal
  @override
  $ProviderElement<StoredPocketBaseSession?> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StoredPocketBaseSession? create(Ref ref) {
    return storedPocketBaseSession(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StoredPocketBaseSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StoredPocketBaseSession?>(value),
    );
  }
}

String _$storedPocketBaseSessionHash() =>
    r'd21137675ddb1c146c7d5dc7cde9fd845aaba281';

/// Oturumun ve bekleyen kod isteğinin güvenli deposu; anahtarlar sunucu
/// adresine özel.

@ProviderFor(pocketBaseSessionStorage)
final pocketBaseSessionStorageProvider = PocketBaseSessionStorageProvider._();

/// Oturumun ve bekleyen kod isteğinin güvenli deposu; anahtarlar sunucu
/// adresine özel.

final class PocketBaseSessionStorageProvider
    extends
        $FunctionalProvider<
          PocketBaseSessionStorage,
          PocketBaseSessionStorage,
          PocketBaseSessionStorage
        >
    with $Provider<PocketBaseSessionStorage> {
  /// Oturumun ve bekleyen kod isteğinin güvenli deposu; anahtarlar sunucu
  /// adresine özel.
  PocketBaseSessionStorageProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pocketBaseSessionStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pocketBaseSessionStorageHash();

  @$internal
  @override
  $ProviderElement<PocketBaseSessionStorage> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PocketBaseSessionStorage create(Ref ref) {
    return pocketBaseSessionStorage(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PocketBaseSessionStorage value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PocketBaseSessionStorage>(value),
    );
  }
}

String _$pocketBaseSessionStorageHash() =>
    r'c53bfe287fc624661e864c4ed9564d443a526a7e';

/// Uygulamadaki tek PocketBase istemcisi. Yalnız data katmanındaki
/// servisler (auth, senkron) alır; ekranlar dokunmaz. Kayıtlı oturum
/// başka bir adresten okunduysa yüklenmez.

@ProviderFor(pocketbaseClient)
final pocketbaseClientProvider = PocketbaseClientProvider._();

/// Uygulamadaki tek PocketBase istemcisi. Yalnız data katmanındaki
/// servisler (auth, senkron) alır; ekranlar dokunmaz. Kayıtlı oturum
/// başka bir adresten okunduysa yüklenmez.

final class PocketbaseClientProvider
    extends $FunctionalProvider<PocketBase, PocketBase, PocketBase>
    with $Provider<PocketBase> {
  /// Uygulamadaki tek PocketBase istemcisi. Yalnız data katmanındaki
  /// servisler (auth, senkron) alır; ekranlar dokunmaz. Kayıtlı oturum
  /// başka bir adresten okunduysa yüklenmez.
  PocketbaseClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pocketbaseClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$pocketbaseClientHash();

  @$internal
  @override
  $ProviderElement<PocketBase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  PocketBase create(Ref ref) {
    return pocketbaseClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PocketBase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PocketBase>(value),
    );
  }
}

String _$pocketbaseClientHash() => r'5d88efca77a993216b6562325a01a1795c0579b3';

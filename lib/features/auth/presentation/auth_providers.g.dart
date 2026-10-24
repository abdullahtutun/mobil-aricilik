// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Testler sahtesiyle override eder.

@ProviderFor(authService)
final authServiceProvider = AuthServiceProvider._();

/// Testler sahtesiyle override eder.

final class AuthServiceProvider
    extends $FunctionalProvider<AuthService, AuthService, AuthService>
    with $Provider<AuthService> {
  /// Testler sahtesiyle override eder.
  AuthServiceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authServiceHash();

  @$internal
  @override
  $ProviderElement<AuthService> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthService create(Ref ref) {
    return authService(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthService>(value),
    );
  }
}

String _$authServiceHash() => r'ae39ea777ca4a2561735f896d78112bc06520243';

/// Oturumdaki kullanıcı; null ise giriş yapılmamış. Çevrimdışıyken süresi
/// dolan token oturumu kapatmaz, yalnız sunucu refresh token'ı reddederse
/// ya da kullanıcı çıkış yaparsa null olur.

@ProviderFor(CurrentUser)
final currentUserProvider = CurrentUserProvider._();

/// Oturumdaki kullanıcı; null ise giriş yapılmamış. Çevrimdışıyken süresi
/// dolan token oturumu kapatmaz, yalnız sunucu refresh token'ı reddederse
/// ya da kullanıcı çıkış yaparsa null olur.
final class CurrentUserProvider
    extends $NotifierProvider<CurrentUser, AppUser?> {
  /// Oturumdaki kullanıcı; null ise giriş yapılmamış. Çevrimdışıyken süresi
  /// dolan token oturumu kapatmaz, yalnız sunucu refresh token'ı reddederse
  /// ya da kullanıcı çıkış yaparsa null olur.
  CurrentUserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentUserProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentUserHash();

  @$internal
  @override
  CurrentUser create() => CurrentUser();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUser? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUser?>(value),
    );
  }
}

String _$currentUserHash() => r'ef92731c48b9b2eba313f1522cacf9ef8ebc7b23';

/// Oturumdaki kullanıcı; null ise giriş yapılmamış. Çevrimdışıyken süresi
/// dolan token oturumu kapatmaz, yalnız sunucu refresh token'ı reddederse
/// ya da kullanıcı çıkış yaparsa null olur.

abstract class _$CurrentUser extends $Notifier<AppUser?> {
  AppUser? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppUser?, AppUser?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppUser?, AppUser?>,
              AppUser?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

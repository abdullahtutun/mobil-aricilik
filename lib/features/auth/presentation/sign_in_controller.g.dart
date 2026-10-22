// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sign_in_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// E-posta → kod → giriş akışı. İki giriş ekranı da dinlediği sürece yaşar;
/// giriş tamamlanınca ekranlar kapanır, durum da silinir. Başarılı girişten
/// sonra yönlendirmeyi router yapar.

@ProviderFor(SignInController)
final signInControllerProvider = SignInControllerProvider._();

/// E-posta → kod → giriş akışı. İki giriş ekranı da dinlediği sürece yaşar;
/// giriş tamamlanınca ekranlar kapanır, durum da silinir. Başarılı girişten
/// sonra yönlendirmeyi router yapar.
final class SignInControllerProvider
    extends $NotifierProvider<SignInController, SignInState> {
  /// E-posta → kod → giriş akışı. İki giriş ekranı da dinlediği sürece yaşar;
  /// giriş tamamlanınca ekranlar kapanır, durum da silinir. Başarılı girişten
  /// sonra yönlendirmeyi router yapar.
  SignInControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'signInControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$signInControllerHash();

  @$internal
  @override
  SignInController create() => SignInController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SignInState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SignInState>(value),
    );
  }
}

String _$signInControllerHash() => r'532d5211384644863446eecd4d874da91b1e3645';

/// E-posta → kod → giriş akışı. İki giriş ekranı da dinlediği sürece yaşar;
/// giriş tamamlanınca ekranlar kapanır, durum da silinir. Başarılı girişten
/// sonra yönlendirmeyi router yapar.

abstract class _$SignInController extends $Notifier<SignInState> {
  SignInState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SignInState, SignInState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SignInState, SignInState>,
              SignInState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

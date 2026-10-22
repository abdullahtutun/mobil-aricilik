import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sign_in_controller.freezed.dart';
part 'sign_in_controller.g.dart';

@freezed
abstract class SignInState with _$SignInState {
  const factory({
    /// Son kodun gönderildiği adres; kod ekranı bunu doğrular.
    String? email,

    /// Yeni kod istenebilene kadar kalan saniye.
    @Default(0) int resendSeconds,

    /// Kod gönderiliyor ya da doğrulanıyor.
    @Default(false) bool busy,
    AuthFailure? failure,
  }) = _SignInState;
}

/// E-posta → kod → giriş akışı. İki giriş ekranı da dinlediği sürece yaşar;
/// giriş tamamlanınca ekranlar kapanır, durum da silinir. Başarılı girişten
/// sonra yönlendirmeyi router yapar.
@riverpod
class SignInController extends _$SignInController {
  Timer? _countdown;

  @override
  SignInState build() {
    ref.onDispose(() => _countdown?.cancel());
    return const SignInState();
  }

  /// Kodu [email]'e gönderir; kod ekranına geçilebilecekse true. Aynı
  /// adrese bekleme süresi dolmadan yeni kod istenmez, eski kod geçerli.
  Future<bool> sendCode(String email, {required String locale}) async {
    final normalized = normalizeEmail(email);
    if (!isValidEmail(normalized)) {
      state = state.copyWith(failure: AuthFailure.invalidEmail);
      return false;
    }
    if (normalized == state.email && state.resendSeconds > 0) {
      state = state.copyWith(failure: null);
      return true;
    }
    return await _send(normalized, locale);
  }

  /// Yeni kod gönderildiyse true.
  Future<bool> resendCode({required String locale}) async {
    final email = state.email;
    if (email == null || state.resendSeconds > 0) return false;
    return await _send(email, locale);
  }

  Future<void> verifyCode(String code, {required String locale}) async {
    final email = state.email;
    if (email == null || state.busy || code.length != otpLength) return;
    state = state.copyWith(busy: true, failure: null);
    try {
      await ref
          .read(authServiceProvider)
          .verifyCode(email: email, code: code, locale: locale);
    } on AuthServiceException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: error.failure);
      }
      return;
    }
    if (ref.mounted) state = state.copyWith(busy: false);
  }

  void clearFailure() {
    if (state.failure != null) state = state.copyWith(failure: null);
  }

  Future<bool> _send(String email, String locale) async {
    if (state.busy) return false;
    state = state.copyWith(busy: true, failure: null);
    try {
      await ref
          .read(authServiceProvider)
          .sendCode(email: email, locale: locale);
    } on AuthServiceException catch (error) {
      if (ref.mounted) {
        state = state.copyWith(busy: false, failure: error.failure);
      }
      return false;
    }
    if (!ref.mounted) return false;
    state = state.copyWith(
      email: email,
      busy: false,
      resendSeconds: resendCooldown.inSeconds,
    );
    _startCountdown();
    return true;
  }

  void _startCountdown() {
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendSeconds - 1;
      state = state.copyWith(resendSeconds: remaining);
      if (remaining <= 0) timer.cancel();
    });
  }
}

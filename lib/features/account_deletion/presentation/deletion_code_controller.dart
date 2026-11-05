import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart'
    show ProviderListenableSelect;
import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';
import 'package:mobil_arici/features/account_deletion/presentation/account_deletion_providers.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:mobil_arici/features/auth/presentation/auth_providers.dart';
import 'package:mobil_arici/features/auth/presentation/widgets/code_entry_form.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'deletion_code_controller.g.dart';

/// Hesap silmedeki kimlik doğrulama: `account-delete` silme kodunu
/// ("hesap silme kodun") e-postaya yollar ve sunucuda doğrular. Giriş kodu
/// kullanılmaz, yeni oturum açılmaz. Form ([CodeEntryForm]) giriş ekranıyla
/// aynı; hata metinleri girişinkiler.
@riverpod
class DeletionCodeController extends _$DeletionCodeController {
  Timer? _countdown;

  @override
  CodeFormState build() {
    ref.onDispose(() => _countdown?.cancel());
    return (
      email: ref.watch(currentUserProvider.select((user) => user?.email)),
      resendSeconds: 0,
      busy: false,
      failure: null,
    );
  }

  /// Kodu gönderir; gönderildiyse true. Bekleme süresi dolmadan yeni kod
  /// istenmez.
  Future<bool> send() async {
    if (state.busy || state.resendSeconds > 0) return false;
    state = (email: state.email, resendSeconds: 0, busy: true, failure: null);
    try {
      await ref.read(accountDeletionServiceProvider).sendCode();
    } on AccountDeletionException catch (error) {
      if (ref.mounted) _fail(error.failure);
      return false;
    }
    if (!ref.mounted) return false;
    state = (
      email: state.email,
      resendSeconds: resendCooldown.inSeconds,
      busy: false,
      failure: null,
    );
    _startCountdown();
    return true;
  }

  /// Kod sunucuda doğrulandıysa true.
  Future<bool> verify(String code) async {
    if (state.busy || code.length != otpLength) return false;
    state = (
      email: state.email,
      resendSeconds: state.resendSeconds,
      busy: true,
      failure: null,
    );
    try {
      await ref.read(accountDeletionServiceProvider).verifyCode(code);
    } on AccountDeletionException catch (error) {
      if (ref.mounted) _fail(error.failure);
      return false;
    }
    if (ref.mounted) {
      state = (
        email: state.email,
        resendSeconds: state.resendSeconds,
        busy: false,
        failure: null,
      );
    }
    return true;
  }

  void _fail(AccountDeletionFailure failure) => state = (
    email: state.email,
    resendSeconds: state.resendSeconds,
    busy: false,
    failure: switch (failure) {
      AccountDeletionFailure.network => AuthFailure.network,
      AccountDeletionFailure.invalidCode => AuthFailure.invalidCode,
      AccountDeletionFailure.tooManyAttempts ||
      AccountDeletionFailure.rateLimited => AuthFailure.tooManyRequests,
      _ => AuthFailure.unknown,
    },
  );

  void _startCountdown() {
    _countdown?.cancel();
    _countdown = Timer.periodic(const Duration(seconds: 1), (timer) {
      final remaining = state.resendSeconds - 1;
      state = (
        email: state.email,
        resendSeconds: remaining,
        busy: state.busy,
        failure: state.failure,
      );
      if (remaining <= 0) timer.cancel();
    });
  }
}

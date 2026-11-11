import 'package:mobil_arici/features/auth/data/auth_service.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [AuthService]'in Supabase uygulaması: GoTrue e-posta OTP'si.
class SupabaseAuthService implements AuthService {
  const new(this._auth);

  final GoTrueClient _auth;

  /// OTP şablonu dili bu alandan seçer (`supabase/templates/otp.html`).
  static const String localeKey = 'locale';

  @override
  AppUser? get currentUser => _toAppUser(_auth.currentUser);

  @override
  Stream<AppUser?> get userChanges => _auth.onAuthStateChange
      .map((state) => _toAppUser(state.session?.user))
      // Token yenileme hataları (ör. çevrimdışı) akışa hata olarak düşer.
      // Oturum yerinde kalır; geçersiz token ise ayrı bir çıkış olayı gelir.
      .handleError((_) {});

  @override
  Future<void> sendCode({required String email, required String locale}) async {
    // Demo hesabın gelen kutusu yok; kod sabit (parola), e-posta gitmez.
    if (isReviewDemoEmail(email)) return;
    await _guard(
      // `data` yalnız hesap ilk açılırken yazılır, mevcut hesapta yok
      // sayılır.
      () => _auth.signInWithOtp(email: email, data: {localeKey: locale}),
    );
  }

  @override
  Future<void> verifyCode({
    required String email,
    required String code,
    required String locale,
  }) async {
    final response = await _guard(
      () => isReviewDemoEmail(email)
          ? _auth.signInWithPassword(email: email, password: code)
          : _auth.verifyOTP(type: OtpType.email, email: email, token: code),
    );
    if (response.user == null) return;
    // Giriş yine geçerli; dil yazılamazsa sonraki denemede düzelir.
    await updateLocale(locale);
  }

  @override
  Future<void> updateLocale(String locale) async {
    final user = _auth.currentUser;
    if (user == null || user.userMetadata?[localeKey] == locale) return;
    try {
      await _auth.updateUser(UserAttributes(data: {localeKey: locale}));
    } on Exception {
      // Çevrimdışı ya da sunucu hatası; dil ya da oturum değişince ya da
      // sonraki açılışta yeniden denenir.
    }
  }

  /// supabase_flutter token'ı kendisi yeniler (otomatik yenileme açık).
  @override
  Future<void> refreshSession() async {}

  @override
  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on AuthException {
      // Yerel oturum zaten silindi. Sunucudaki oturumu kapatma isteği
      // çevrimdışıyken gidemez; giriş ekranına geçmeye engel değil.
    }
  }

  static AppUser? _toAppUser(User? user) =>
      user == null ? null : AppUser(id: user.id, email: user.email);

  static Future<T> _guard<T>(Future<T> Function() call) async {
    try {
      return await call();
    } on AuthRetryableFetchException {
      throw const AuthServiceException(AuthFailure.network);
    } on AuthApiException catch (error) {
      throw AuthServiceException(_failureOf(error));
    } on AuthException {
      throw const AuthServiceException(AuthFailure.unknown);
    }
  }

  static AuthFailure _failureOf(AuthApiException error) {
    return switch (error.code) {
      // Demo hesapta kod parola olarak denenir; yanlışsa invalid_credentials.
      'otp_expired' || 'invalid_credentials' => AuthFailure.invalidCode,
      'email_address_invalid' ||
      'validation_failed' => AuthFailure.invalidEmail,
      'over_email_send_rate_limit' ||
      'over_request_rate_limit' => AuthFailure.tooManyRequests,
      _ when error.statusCode == '429' => AuthFailure.tooManyRequests,
      _ => AuthFailure.unknown,
    };
  }
}

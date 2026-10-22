import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Giriş ve çıkış. Ağa doğrudan giden az sayıdaki çağrıdan biri; ekranlar
/// buna provider üzerinden ulaşır. Hatalar [AuthServiceException] olarak
/// gelir.
abstract interface class AuthService {
  /// Kayıtlı oturumun kullanıcısı; süresi dolmuş token da oturum sayılır.
  AppUser? get currentUser;

  /// Giriş, çıkış ve sunucunun oturumu düşürmesi.
  Stream<AppUser?> get userChanges;

  /// [email]'e 6 haneli kod gönderir; hesap yoksa açar. [locale] yeni
  /// hesabın e-posta dilidir.
  Future<void> sendCode({required String email, required String locale});

  /// Kodu doğrular ve oturumu açar. E-posta dili [locale]'den farklıysa
  /// günceller ki sonraki kod e-postası bu dilde gitsin.
  Future<void> verifyCode({
    required String email,
    required String code,
    required String locale,
  });

  /// Yerel oturumu siler; çevrimdışı da çalışır.
  Future<void> signOut();
}

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
  Future<void> sendCode({required String email, required String locale}) =>
      _guard(
        // `data` yalnız hesap ilk açılırken yazılır, mevcut hesapta yok
        // sayılır.
        () => _auth.signInWithOtp(email: email, data: {localeKey: locale}),
      );

  @override
  Future<void> verifyCode({
    required String email,
    required String code,
    required String locale,
  }) async {
    final response = await _guard(
      () => _auth.verifyOTP(type: OtpType.email, email: email, token: code),
    );
    final user = response.user;
    if (user == null || user.userMetadata?[localeKey] == locale) return;
    try {
      await _auth.updateUser(UserAttributes(data: {localeKey: locale}));
    } on AuthException {
      // Giriş yine geçerli; e-posta dili bir sonraki girişte düzelir.
    }
  }

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
      'otp_expired' => AuthFailure.invalidCode,
      'email_address_invalid' ||
      'validation_failed' => AuthFailure.invalidEmail,
      'over_email_send_rate_limit' ||
      'over_request_rate_limit' => AuthFailure.tooManyRequests,
      _ when error.statusCode == '429' => AuthFailure.tooManyRequests,
      _ => AuthFailure.unknown,
    };
  }
}

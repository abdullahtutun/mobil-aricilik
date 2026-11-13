import 'dart:async';

import 'package:clock/clock.dart';
import 'package:mobil_arici/features/auth/data/auth_service.dart';
import 'package:mobil_arici/features/auth/data/pocketbase_session_storage.dart';
import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';
import 'package:mobil_arici/features/auth/domain/sign_in_rules.dart';
import 'package:pocketbase/pocketbase.dart';

/// [AuthService]'in PocketBase uygulaması: `POST /api/app/auth/otp` ile
/// kod, `auth-with-otp` ile giriş (`server/internal/auth`).
///
/// Oturum [PocketBase.authStore]'da (90 günlük token, refresh token yok);
/// [refreshSession] token'ı yeniler (K-6). Süresi dolmuş token da oturum
/// sayılır: çevrimdışı açılışta arayüz kilitlenmez, oturumu yalnız
/// sunucunun 401'i ya da çıkış kapatır.
class PocketBaseAuthService implements AuthService {
  new(this._client, this._storage);

  final PocketBase _client;
  final PocketBaseSessionStorage _storage;

  static const usersCollection = 'users';

  /// Kod e-postası ve bildirimlerin dili (users kaydının alanı).
  static const localeField = 'locale';

  /// Yenileme isteğinin en uzun süresi; senkron turu bunu bekler.
  static const refreshTimeout = Duration(seconds: 15);

  Future<void>? _refreshing;

  AuthStore get _store => _client.authStore;

  @override
  AppUser? get currentUser => _toAppUser(_store);

  @override
  Stream<AppUser?> get userChanges =>
      _store.onChange.map((_) => _toAppUser(_store));

  @override
  Future<void> sendCode({required String email, required String locale}) async {
    // Demo hesabın gelen kutusu yok; kod sabit (parola), e-posta gitmez.
    if (isReviewDemoEmail(email)) return;
    final response = await _guard(
      () => _client.send<Map<String, dynamic>>(
        '/api/app/auth/otp',
        method: 'POST',
        body: {'email': email, 'locale': locale},
      ),
    );
    final otpId = response['otpId'];
    if (otpId is! String || otpId.isEmpty) {
      throw const AuthServiceException(AuthFailure.unknown);
    }
    await _storage.savePendingOtp((
      email: email,
      otpId: otpId,
      sentAt: clock.now(),
    ));
  }

  @override
  Future<void> verifyCode({
    required String email,
    required String code,
    required String locale,
  }) async {
    final users = _client.collection(usersCollection);
    if (isReviewDemoEmail(email)) {
      await _guard(() => users.authWithPassword(email, code), verifying: true);
    } else {
      // Kod isteği yoksa, başka adrese aitse ya da 10 dakikadan eskiyse
      // sunucudaki kod da geçersiz.
      final pending = await _storage.readPendingOtp();
      if (pending == null || pending.email != email) {
        throw const AuthServiceException(AuthFailure.invalidCode);
      }
      await _guard(
        () => users.authWithOTP(pending.otpId, code),
        verifying: true,
      );
      await _storage.deletePendingOtp();
    }
    // Giriş yine geçerli; dil yazılamazsa sonraki denemede düzelir.
    await updateLocale(locale);
  }

  @override
  Future<void> updateLocale(String locale) async {
    final record = _store.record;
    if (_store.token.isEmpty ||
        record == null ||
        record.get<String>(localeField, '') == locale) {
      return;
    }
    try {
      final response = await _client.send<Map<String, dynamic>>(
        '/api/app/auth/locale',
        method: 'POST',
        body: {localeField: locale},
      );
      // Bu arada çıkış ya da başka hesapla giriş olduysa dokunulmaz.
      final current = _store.record;
      if (current == null || current.id != record.id) return;
      final updated = RecordModel(Map.of(current.data))
        ..set(localeField, response[localeField] as String? ?? locale);
      _store.save(_store.token, updated);
    } on Exception {
      // Çevrimdışı ya da sunucu hatası; dil ya da oturum değişince ya da
      // sonraki açılışta yeniden denenir.
    }
  }

  /// Token'ı yeniler (`auth-refresh`). Ağ hatası, zaman aşımı ve sunucu
  /// hatası oturumu kapatmaz; yalnız 401 (token süresi dolmuş ya da
  /// geçersiz kılınmış) kapatır. Aynı anda gelen çağrılar tek isteği
  /// bekler. Hata atmaz.
  @override
  Future<void> refreshSession() =>
      _refreshing ??= _refresh().whenComplete(() => _refreshing = null);

  Future<void> _refresh() async {
    final token = _store.token;
    if (token.isEmpty) return;
    try {
      // SDK'nın authRefresh'i yanıtı koşulsuz yazar; istek sürerken çıkış
      // yapılırsa oturum geri gelirdi. Token elle gönderilir (süresi
      // dolmuşsa SDK hiç göndermez) ve yanıt yalnız oturum aynıysa yazılır.
      final data = await _client
          .send<Map<String, dynamic>>(
            '/api/collections/$usersCollection/auth-refresh',
            method: 'POST',
            headers: {'Authorization': token},
          )
          .timeout(refreshTimeout);
      final auth = RecordAuth.fromJson(data);
      if (_store.token == token && auth.token.isNotEmpty) {
        _store.save(auth.token, auth.record);
      }
    } on ClientException catch (error) {
      if (error.statusCode == 401 && _store.token == token) _store.clear();
    } on Exception {
      // Zaman aşımı ya da beklenmeyen yanıt; sonraki turda yeniden denenir.
    }
  }

  @override
  Future<void> signOut() async {
    // PocketBase'de sunucu tarafı oturum yok; token yalnız telefonda.
    _store.clear();
    await _storage.deleteSession();
    await _storage.deletePendingOtp();
  }

  static AppUser? _toAppUser(AuthStore store) {
    final record = store.record;
    if (store.token.isEmpty || record == null || record.id.isEmpty) {
      return null;
    }
    final email = record.get<String>('email', '');
    return AppUser(id: record.id, email: email.isEmpty ? null : email);
  }

  static Future<T> _guard<T>(
    Future<T> Function() call, {
    bool verifying = false,
  }) async {
    try {
      return await call();
    } on ClientException catch (error) {
      throw AuthServiceException(failureOf(error, verifying: verifying));
    }
  }

  /// Sunucu yanıtını giriş hatasına çevirir. Hata kodu
  /// `{status, message, data: {code}}` gövdesinin `data.code`'unda;
  /// PocketBase'in kendi uçları (`auth-with-otp`, `auth-with-password`)
  /// yanlış, süresi dolmuş ya da kullanılmış kodu ayırmadan 400 döner.
  static AuthFailure failureOf(
    ClientException error, {
    required bool verifying,
  }) {
    final code = switch (error.response['data']) {
      {'code': final String code} => code,
      _ => null,
    };
    return switch (error.statusCode) {
      // Yanıt yok (ağ, bağlantı koptu) ya da sunucu geçici olarak yok
      // (`mail_unavailable`, `mail_failed`).
      0 || >= 500 => AuthFailure.network,
      429 => AuthFailure.tooManyRequests,
      _ when code == 'invalid_email' => AuthFailure.invalidEmail,
      400 || 404 when verifying => AuthFailure.invalidCode,
      _ => AuthFailure.unknown,
    };
  }
}

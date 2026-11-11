import 'dart:convert';

import 'package:clock/clock.dart';
import 'package:flutter/services.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mobil_arici/core/services/secure_storage.dart';
import 'package:pocketbase/pocketbase.dart';

/// Gönderilen kodun sunucudaki kimliği; kod ekranında girilen kodla
/// birlikte `auth-with-otp`'ye gider.
typedef PendingOtp = ({String email, String otpId, DateTime sentAt});

/// PocketBase oturumunu (token + kullanıcı kaydı) ve bekleyen kod isteğini
/// Keychain/Keystore'da tutar. Anahtarlar sunucu adresine özel: adres
/// değişirse (dev ↔ prod, `PB_URL`) eski sunucunun oturumu yüklenmez.
class PocketBaseSessionStorage {
  new(String serverUrl, {this.storage = appSecureStorage})
    : sessionKey = 'pb-auth-${Uri.parse(serverUrl).origin}',
      otpKey = 'pb-otp-${Uri.parse(serverUrl).origin}';

  final FlutterSecureStorage storage;

  /// Oturumun kayıt anahtarı.
  final String sessionKey;

  /// Bekleyen kod isteğinin kayıt anahtarı.
  final String otpKey;

  /// Sunucudaki kodun ömrü (`server/internal/auth`, 600 sn); bundan eski
  /// istek okunmaz ve silinir.
  static const otpLifetime = Duration(minutes: 10);

  /// Kayıtlı oturum; yoksa, bozuksa ya da çözülemiyorsa null (bozuk ve
  /// çözülemeyen kayıt silinir, yeniden giriş istenir).
  Future<String?> readSession() async {
    final data = await _read(sessionKey);
    if (data == null) return null;
    if (_isSession(data)) return data;
    await deleteSession();
    return null;
  }

  /// [initial] ile açılan, her değişikliği bu depoya yazan oturum.
  AsyncAuthStore authStore({String? initial}) => AsyncAuthStore(
    save: (data) => _write(sessionKey, data),
    clear: deleteSession,
    // AsyncAuthStore biçimi bozuk kaydı (ör. model alanı nesne değil)
    // yüklerken çöker; [readSession] süzer, burada yeniden denetlenir.
    initial: initial != null && _isSession(initial) ? initial : null,
  );

  Future<void> deleteSession() => _delete(sessionKey);

  /// Kod isteğini saklar: uygulama arka plana gidip kapatılsa da kod
  /// girilebilsin.
  Future<void> savePendingOtp(PendingOtp otp) => _write(
    otpKey,
    jsonEncode({
      'email': otp.email,
      'otp_id': otp.otpId,
      'sent_at': otp.sentAt.toUtc().toIso8601String(),
    }),
  );

  /// Son kod isteği; yoksa, [otpLifetime]'dan eskiyse ya da okunamıyorsa
  /// null (eskisi ve bozuğu silinir).
  Future<PendingOtp?> readPendingOtp() async {
    final data = await _read(otpKey);
    if (data == null) return null;
    final PendingOtp? otp;
    try {
      otp = switch (jsonDecode(data)) {
        {
          'email': final String email,
          'otp_id': final String otpId,
          'sent_at': final String sentAt,
        } =>
          (email: email, otpId: otpId, sentAt: DateTime.parse(sentAt)),
        _ => null,
      };
    } on FormatException {
      await deletePendingOtp();
      return null;
    }
    if (otp == null || clock.now().difference(otp.sentAt) >= otpLifetime) {
      await deletePendingOtp();
      return null;
    }
    return otp;
  }

  Future<void> deletePendingOtp() => _delete(otpKey);

  /// AsyncAuthStore'un yazdığı biçim: `{"token": "...", "model": {...}}`.
  static bool _isSession(String data) {
    try {
      return switch (jsonDecode(data)) {
        {'token': String _, 'model': Map<String, Object?>? _} => true,
        _ => false,
      };
    } on FormatException {
      return false;
    }
  }

  Future<String?> _read(String key) async {
    try {
      return await storage.read(key: key);
    } on PlatformException {
      // Anahtarı bu cihazda olmayan kayıt (ör. cihazdan cihaza aktarım)
      // çözülemez. Uygulama çökmesin; kayıt yok sayılır.
      await _delete(key);
      return null;
    }
  }

  Future<void> _write(String key, String value) async {
    try {
      await storage.write(key: key, value: value);
    } on PlatformException {
      // Oturum bellekte geçerli kalır; yazılamadıysa sonraki açılışta
      // yeniden giriş istenir. AsyncAuthStore'un kuyruğu hatayı
      // yakalamadığı için burada yutulur.
    }
  }

  Future<void> _delete(String key) async {
    try {
      await storage.delete(key: key);
    } on PlatformException {
      // Silinemeyen kayıt bir sonraki okumada yine çözülemez, yine yok
      // sayılır.
    }
  }
}

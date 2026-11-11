import 'package:mobil_arici/features/auth/domain/app_user.dart';
import 'package:mobil_arici/features/auth/domain/auth_failure.dart';

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

  /// Oturumdaki kullanıcının dilini [locale] yapar; sunucunun gönderdiği
  /// bildirim ve e-postalar bu dilde gider. Dil zaten buysa ağa gitmez.
  /// Hata atmaz: çevrimdışıysa sonraki denemede düzelir.
  Future<void> updateLocale(String locale);

  /// Yerel oturumu siler; çevrimdışı da çalışır.
  Future<void> signOut();
}

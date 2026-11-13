import 'package:mobil_arici/features/account_deletion/domain/account_deletion.dart';

/// Hesap silme: silme kodu, talep, bekleyen talep ve iptal.
/// Ağa doğrudan giden çağrı; ekranlar buna provider üzerinden ulaşır. Hepsi
/// online çalışır, hatalar [AccountDeletionException] olarak gelir.
abstract interface class AccountDeletionService {
  /// Hesabın e-postasına 6 haneli silme kodu gönderir ("hesap silme kodun";
  /// giriş kodu değil). Yeni oturum açılmaz.
  Future<void> sendCode();

  /// Kodu sunucuda doğrular; [request] bundan sonraki 15 dakikada kabul
  /// edilir.
  Future<void> verifyCode(String code);

  /// Oturumdaki kullanıcının silme talebini açar; kalıcı silme 7 gün sonra.
  /// Önce [verifyCode] gerekir; yoksa [AccountDeletionFailure.codeRequired].
  /// [deleteOrganization] ekipli işletmeyi tümüyle siler; [transferTo]
  /// sahipliği o ortağa devreder. Sunucu talepte bütün oturumları kapatır.
  Future<DeletionRequestInfo> request({
    required String orgId,
    bool deleteOrganization = false,
    String? transferTo,
  });

  /// Bekleyen talep; yoksa null.
  Future<DeletionRequestInfo?> pending();

  /// Bekleyen talebi iptal eder; iptal edildiyse true (kalıcı silme
  /// başladıysa false).
  Future<bool> cancel();
}

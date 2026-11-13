/// Giriş adımlarında kullanıcıya gösterilen hata türleri.
enum AuthFailure {
  /// Ağ yok ya da sunucu geçici olarak yanıt vermiyor.
  network,

  /// E-posta biçimi geçersiz.
  invalidEmail,

  /// Kod yanlış ya da süresi dolmuş; sunucu ikisini ayırmıyor.
  invalidCode,

  /// Çok sık kod istendi.
  tooManyRequests,

  unknown,
}

/// Auth servisinin attığı tek hata; sunucu hataları buna çevrilir.
class AuthServiceException implements Exception {
  const new(this.failure);

  final AuthFailure failure;

  @override
  String toString() => 'AuthServiceException(${failure.name})';
}

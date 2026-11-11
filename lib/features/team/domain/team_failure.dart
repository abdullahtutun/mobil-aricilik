/// Ekip işlemlerinde (davet, katılma, rol, çıkarma) çıkan hata türleri.
enum TeamFailure {
  /// Ağ yok ya da sunucu geçici olarak yanıt vermiyor.
  network,

  /// Kod yok, süresi dolmuş ya da kullanılmış; sunucu ayırt etmez.
  invalidCode,

  /// Kullanıcı kodun işletmesinin zaten üyesi.
  alreadyMember,

  /// Bu işlem için rolü yetmiyor.
  forbidden,

  /// Owner'ın rolü değişmez, owner çıkarılamaz.
  ownerLocked,

  /// Üye hesabını silmeyi onayladı; bekleme süresinde rolü değişmez,
  /// ekipten çıkarılamaz.
  memberLeaving,

  /// Kısa sürede çok fazla kod denemesi (kullanıcı başına dakikada 10);
  /// biraz beklenmeli.
  tooManyAttempts,

  unknown,
}

/// Ekip servisinin attığı tek hata; Supabase hataları buna çevrilir.
class TeamServiceException implements Exception {
  const new(this.failure);

  final TeamFailure failure;

  @override
  String toString() => 'TeamServiceException(${failure.name})';
}

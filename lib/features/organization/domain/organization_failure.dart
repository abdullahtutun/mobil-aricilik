/// İşletme bilgisini alırken ya da işletme kurarken çıkan hata türleri.
enum OrganizationFailure {
  /// Ağ yok ya da sunucu geçici olarak yanıt vermiyor.
  network,

  unknown,
}

/// İşletme servisinin attığı tek hata; sunucu hataları buna çevrilir.
class OrganizationServiceException implements Exception {
  const new(this.failure);

  final OrganizationFailure failure;

  @override
  String toString() => 'OrganizationServiceException(${failure.name})';
}

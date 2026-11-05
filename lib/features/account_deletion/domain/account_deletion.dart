/// Silinecek işletmenin kayıt sayıları (yerel DB'den) ve yayımdaki lot
/// sayfaları; sunucunun `account_deletion_counts`'uyla aynı ölçüler.
typedef DeletionCounts = ({
  int hives,
  int apiaries,
  int inspections,
  int harvests,
  int documents,
  int photos,
  int publicLotPages,
});

const DeletionCounts emptyDeletionCounts = (
  hives: 0,
  apiaries: 0,
  inspections: 0,
  harvests: 0,
  documents: 0,
  photos: 0,
  publicLotPages: 0,
);

/// Sunucudaki talebin türü (`deletion_requests.kind`).
enum DeletionKind {
  /// Yalnız hesap; işletme ve kayıtları kalır.
  account('hesap'),

  /// Hesap ve sahibi olunan işletme, tüm kayıtlarıyla.
  accountAndOrganization('hesap_ve_isletme');

  new(this.value);

  final String value;

  static DeletionKind fromValue(String? value) =>
      value == accountAndOrganization.value ? accountAndOrganization : account;
}

/// Bekleyen silme talebi: ne zaman kalıcı silineceği ve türü.
typedef DeletionRequestInfo = ({DateTime scheduledFor, DeletionKind kind});

enum AccountDeletionFailure {
  /// Bağlantı yok ya da sunucuya ulaşılamadı.
  network,

  /// Ekipli başka bir işletmenin de sahibisin; önce orada devret.
  ownerMustTransfer,

  /// Seçilen ortak artık uygun değil (ortak değil ya da kendi hesabını
  /// siliyor).
  invalidTransferTarget,

  /// Kısa sürede çok fazla talep.
  rateLimited,

  /// Oturum geçersiz ya da yetki yok.
  forbidden,
  unknown,
}

class AccountDeletionException implements Exception {
  const new(this.failure);

  final AccountDeletionFailure failure;

  @override
  String toString() => 'AccountDeletionException(${failure.name})';
}

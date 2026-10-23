import 'package:mobil_arici/core/sync/sync_result.dart';

/// Üst bardaki senkron ikonunun durumu.
enum SyncIndicator {
  /// Gönderilmeyi bekleyen kayıt yok.
  synced,

  /// Kayıtlar gönderilmeyi bekliyor (ör. çevrimdışı); hata değil.
  pending,

  /// Kullanıcının bakması gereken bir sorun var: sunucu bir kaydı reddetti
  /// ya da son tur yeniden denemekle düzelmeyecek bir hatayla bitti.
  error,
}

/// Önce hata, sonra bekleyen kayıt. Ağ olmaması ([SyncStatus.retryLater])
/// hata sayılmaz; kayıtlar bekliyor görünür.
SyncIndicator syncIndicatorOf({
  required int pending,
  required int rejected,
  SyncStatus? lastStatus,
}) {
  if (rejected > 0 ||
      lastStatus == SyncStatus.failed ||
      lastStatus == SyncStatus.upgradeRequired) {
    return SyncIndicator.error;
  }
  return pending > 0 ? SyncIndicator.pending : SyncIndicator.synced;
}

/// Sunucunun kaydı reddetme nedeni (sync_push `reason`).
enum SyncRejection {
  /// RLS: kullanıcının bu işletmede yazma yetkisi yok.
  forbidden,

  /// Tekillik çakışması, ör. etiket kodu başka bir kovanda.
  conflict,

  /// Bağlı olduğu kayıt (arılık, ana arı) sunucuda yok.
  missingReference,

  /// Bu tablo ya da işlem senkronla yazılamıyor.
  unsupported,

  /// Kayıttaki veri geçersiz.
  invalid,

  unknown,
}

/// Outbox'taki `last_error` (`<reason>: <message>`) değerinden neden.
SyncRejection syncRejectionOf(String lastError) {
  final separator = lastError.indexOf(': ');
  final reason = separator < 0 ? lastError : lastError.substring(0, separator);
  return switch (reason) {
    'forbidden' => SyncRejection.forbidden,
    'conflict' => SyncRejection.conflict,
    'missing_reference' => SyncRejection.missingReference,
    'unsupported' => SyncRejection.unsupported,
    'invalid' => SyncRejection.invalid,
    _ => SyncRejection.unknown,
  };
}

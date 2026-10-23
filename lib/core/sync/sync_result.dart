import 'package:freezed_annotation/freezed_annotation.dart';

part 'sync_result.freezed.dart';

/// Bir senkron turunun (gönderme, çekme ya da ikisi birden) nasıl bittiği.
enum SyncStatus {
  /// Gönderilecek kayıt kalmadı (reddedilenler outbox'ta işaretli kalır);
  /// çekmede her tablo güncel.
  done,

  /// Ağ yok ya da sunucu geçici hata verdi ve bekleyerek yapılan yeniden
  /// denemeler de tükendi. Kayıtlar ve imleçler yerinde; sonraki tur kaldığı
  /// yerden sürer.
  retryLater,

  /// Sunucu bu şema sürümünü kabul etmiyor (HTTP 426); uygulama
  /// güncellenmeli.
  upgradeRequired,

  /// Yeniden denemekle düzelmeyecek hata: oturum yok, istek reddedildi ya da
  /// yanıt beklenen biçimde değil. Kayıtlar ve imleçler yerinde kalır.
  failed,
}

@freezed
abstract class SyncResult with _$SyncResult {
  const factory({
    required SyncStatus status,

    /// Sunucunun kabul ettiği ve outbox'tan silinen kayıt sayısı.
    @Default(0) int pushed,

    /// Bu turda kalıcı olarak reddedilip işaretlenen kayıt sayısı.
    @Default(0) int rejected,

    /// Sunucudan inip yerel DB'ye yazılan satır sayısı.
    @Default(0) int pulled,
  }) = _SyncResult;
}

/// Süren çekmenin ilerleyişi. Sunucu toplam satır sayısını bildirmez; bu
/// yüzden ilerleme tablo tablo ölçülür, inen satırlar ayrıca sayılır.
@freezed
abstract class SyncProgress with _$SyncProgress {
  const factory({
    required int tablesDone,
    required int tableCount,
    required int rowsPulled,
  }) = _SyncProgress;
}

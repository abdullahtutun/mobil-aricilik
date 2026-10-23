import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_result.freezed.dart';

/// Bir gönderme turunun nasıl bittiği.
enum PushStatus {
  /// Gönderilecek kayıt kalmadı. Reddedilenler outbox'ta işaretli kalır.
  done,

  /// Ağ yok ya da sunucu geçici hata verdi ve bekleyerek yapılan yeniden
  /// denemeler de tükendi. Kayıtlar yerinde; sonraki tur kaldığı yerden
  /// sürer.
  retryLater,

  /// Sunucu bu şema sürümünü kabul etmiyor (HTTP 426); uygulama
  /// güncellenmeli.
  upgradeRequired,

  /// Yeniden denemekle düzelmeyecek hata: oturum yok, istek reddedildi ya da
  /// yanıt beklenen biçimde değil. Kayıtlar yerinde kalır.
  failed,
}

@freezed
abstract class PushResult with _$PushResult {
  const factory({
    required PushStatus status,

    /// Sunucunun kabul ettiği ve outbox'tan silinen kayıt sayısı.
    @Default(0) int pushed,

    /// Bu turda kalıcı olarak reddedilip işaretlenen kayıt sayısı.
    @Default(0) int rejected,
  }) = _PushResult;
}

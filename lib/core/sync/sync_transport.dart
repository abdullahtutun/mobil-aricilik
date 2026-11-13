/// Outbox'tan gönderilen tek değişiklik.
typedef SyncChange = ({
  /// Outbox satırının kimliği; yanıttaki sonuç buna göre eşlenir.
  int id,
  String table,

  /// `insert`, `update` ya da `delete`.
  String operation,
  Map<String, Object?> payload,
});

/// Senkronun sunucuyla konuştuğu tek yer: outbox paketini gönderir, tablo
/// satırlarını sayfa sayfa çeker. `SyncService` kuralları (paketleme,
/// yeniden deneme, imleç) backend'den bağımsız; backend'e özgü olan yalnız
/// bu arayüzün uygulamasıdır.
///
/// Hatalar [SyncTransportException] alt sınıflarıyla gelir; sınıflanamayan
/// başka bir [Exception] (ör. zaman aşımı) geçici sayılır.
abstract interface class SyncTransport {
  /// [batch]'i gönderir. [clientTime] telefonun saati (sunucu sapmayı
  /// ölçer), [schemaVersion] yerel şemanın sürümü (sunucu desteklemiyorsa
  /// [SyncUpgradeRequiredException]).
  Future<SyncPushResponse> push(
    List<SyncChange> batch, {
    required DateTime clientTime,
    required int schemaVersion,
  });

  /// [table]'ın `server_seq`'i [sinceSeq]'ten büyük satırlarını, en çok
  /// yaklaşık [pageSize] kadar, `server_seq` sırasıyla döner.
  Future<SyncPullPage> pull(
    String table, {
    required int sinceSeq,
    required int pageSize,
  });
}

/// Gönderilen paketin sonuçları, outbox kimliğine göre. Sonucu olmayan
/// ya da tanınmayan kayıt haritada yoktur.
class SyncPushResponse {
  const new(this.results);

  final Map<int, SyncPushOutcome> results;
}

sealed class SyncPushOutcome {
  const new();
}

/// Sunucu kaydı uyguladı (ya da zaten uygulanmıştı).
final class SyncPushAccepted extends SyncPushOutcome {
  const new();
}

/// Sunucu kaydı reddetti (yetki, geçersiz veri, eksik bağ); yeniden
/// göndermek işe yaramaz.
final class SyncPushRejected extends SyncPushOutcome {
  const new({required this.reason, required this.message});

  final String reason;
  final String message;
}

/// Çekmenin bir sayfası. Satırlar sunucunun kolon adlarıyla, ham JSON;
/// yerel kolonlara çevirmek `SyncService`'in işi.
class SyncPullPage {
  const new({required this.rows, required this.nextSeq, required this.hasMore});

  /// `server_seq` sırasında.
  final List<Object?> rows;

  /// Sonraki sayfanın imleci.
  final int nextSeq;
  final bool hasMore;
}

/// Taşıyıcı hatası; alt sınıfı turun nasıl biteceğini söyler.
sealed class SyncTransportException implements Exception {
  const new(this.message);

  final String message;

  @override
  String toString() => 'SyncTransportException: $message';
}

/// Ağ, zaman aşımı, sunucunun geri aldığı paket ya da çevrimdışı token
/// yenileme; aynı istek sonra yeniden denenir.
final class SyncTransientException extends SyncTransportException {
  const new(super.message);
}

/// Sunucu bu şema sürümünü artık kabul etmiyor; uygulama güncellenmeli.
final class SyncUpgradeRequiredException extends SyncTransportException {
  const new(super.message);
}

/// Yeniden denemenin işe yaramayacağı hata (reddedilen oturum, beklenmeyen
/// yanıt biçimi, istemci hatası).
final class SyncPermanentException extends SyncTransportException {
  const new(super.message);
}

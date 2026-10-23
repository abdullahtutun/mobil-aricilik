import 'package:drift/drift.dart';
import 'package:mobil_arici/core/db/app_database.dart';
import 'package:mobil_arici/core/sync/push_result.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Yerel DB ile sunucu arasındaki senkron (teknik.md §3). Supabase
/// istemcisine dokunan tek senkron sınıfı; ekranlar ve repository'ler ağa
/// gitmez.
///
/// Aynı anda tek tur çalışır. Tur sürerken gelen çağrı yeni tur başlatmaz,
/// süren turun sonucunu bekler. Kilit nesneye bağlıdır; uygulamada tek
/// örnek `syncServiceProvider`'dan gelir.
class SyncService {
  new(
    this._db,
    this._client, {
    this.clock = DateTime.now,
    this.delay = Future<void>.delayed,
  });

  final AppDatabase _db;
  final SupabaseClient _client;

  /// `client_time` kaynağı; testler sabit saat verir.
  final DateTime Function() clock;

  /// Yeniden denemeden önce bekler; testler beklemeden kaydeder.
  final Future<void> Function(Duration duration) delay;

  /// Bir pakette en fazla bu kadar kayıt gider.
  static const batchSize = 100;

  /// Geçici hatadan sonraki ilk bekleme; her denemede iki katına çıkar.
  static const initialBackoff = Duration(seconds: 1);

  /// Aynı paket geçici hatadan sonra en fazla bu kadar yeniden denenir
  /// (1 + 2 + 4 + 8 + 16 = 31 sn bekleme), sonra tur
  /// [PushStatus.retryLater] ile biter.
  static const maxRetries = 5;

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 30);

  Future<PushResult>? _running;

  /// Outbox'ı oluşturulma sırasıyla [batchSize]'lık paketler halinde
  /// `sync_push`'a gönderir.
  ///
  /// Sunucunun kabul ettiği kayıtlar silinir. Reddedilen kayıt (RLS, geçersiz
  /// veri) `last_error`'a `<reason>: <message>` olarak işaretlenir, outbox'ta
  /// kalır ve sonraki paketlere alınmaz; kuyruk onun yüzünden durmaz.
  /// Geçici hatada (ağ, zaman aşımı, sunucunun geri aldığı paket) aynı paket
  /// üstel bekleyerek yeniden gönderilir. Başarısız her gönderimde paketteki
  /// kayıtların `attempts` sayısı artar.
  Future<PushResult> push() =>
      _running ??= _push().whenComplete(() => _running = null);

  Future<PushResult> _push() async {
    var pushed = 0;
    var rejected = 0;
    var retries = 0;
    PushResult result(PushStatus status) =>
        PushResult(status: status, pushed: pushed, rejected: rejected);

    while (true) {
      final batch = await _nextBatch();
      if (batch.isEmpty) return result(PushStatus.done);

      final Map<String, dynamic> response;
      try {
        response = await _send(batch);
      } on Exception catch (error) {
        await _countAttempt(batch.map((entry) => entry.id));
        final status = _statusFor(error);
        if (status != PushStatus.retryLater || retries == maxRetries) {
          return result(status);
        }
        await delay(initialBackoff * (1 << retries++));
        continue;
      }
      retries = 0;

      final applied = await _apply(batch, response);
      pushed += applied.pushed;
      rejected += applied.rejected;
      // Sonucu gelmeyen kayıt yeniden gönderilirse tur dönüp durur.
      if (!applied.complete) return result(PushStatus.failed);
    }
  }

  /// Reddedilmemiş ilk [batchSize] kayıt, oluşturulma sırasıyla.
  Future<List<OutboxEntry>> _nextBatch() =>
      (_db.select(_db.outbox)
            ..where((t) => t.lastError.isNull())
            ..orderBy([(t) => OrderingTerm.asc(t.id)])
            ..limit(batchSize))
          .get();

  Future<Map<String, dynamic>> _send(List<OutboxEntry> batch) => _client
      .rpc<Map<String, dynamic>>(
        'sync_push',
        params: {
          'changes': [
            for (final entry in batch)
              {
                'id': entry.id,
                'table': entry.recordTable,
                'operation': entry.operation.name,
                'payload': entry.payload,
              },
          ],
          'client_time': clock().toUtc().toIso8601String(),
          'schema_version': _db.schemaVersion,
        },
      )
      // POST zaten kendiliğinden yeniden denenmez; burada yalnız süre sınırı
      // konur, yeniden denemeyi [_push] yapar.
      .retry(enabled: false, requestTimeout: requestTimeout);

  /// Yanıttaki sonuçları tek transaction'da işler: `ok` kayıtlar silinir,
  /// `rejected` kayıtlar işaretlenir. Yanıtta sonucu olmayan ya da tanınmayan
  /// kayıt yerinde kalır ve `complete` false döner.
  Future<({int pushed, int rejected, bool complete})> _apply(
    List<OutboxEntry> batch,
    Map<String, dynamic> response,
  ) async {
    final results = <int, Map<String, dynamic>>{
      if (response['results'] case final List<dynamic> list)
        for (final result in list)
          if (result case {'id': final int id} && final Map<String, dynamic> r)
            id: r,
    };
    final accepted = <int>[];
    final rejections = <int, String>{};
    for (final entry in batch) {
      switch (results[entry.id]) {
        case {'status': 'ok'}:
          accepted.add(entry.id);
        case {
          'status': 'rejected',
          'reason': final String reason,
          'message': final String message,
        }:
          rejections[entry.id] = '$reason: $message';
      }
    }

    await _db.transaction(() async {
      await (_db.delete(_db.outbox)..where((t) => t.id.isIn(accepted))).go();
      for (final MapEntry(key: id, value: error) in rejections.entries) {
        await _countAttempt([id], error: error);
      }
    });
    return (
      pushed: accepted.length,
      rejected: rejections.length,
      complete: accepted.length + rejections.length == batch.length,
    );
  }

  /// Kayıtların deneme sayısını artırır; [error] verilirse kalıcı ret
  /// olarak işaretler.
  Future<void> _countAttempt(Iterable<int> ids, {String? error}) =>
      (_db.update(_db.outbox)..where((t) => t.id.isIn(ids))).write(
        OutboxCompanion.custom(
          attempts: _db.outbox.attempts + const Constant(1),
          lastError: error == null ? null : Variable(error),
        ),
      );

  /// Gönderim hatasının turu nasıl bitireceği; [PushStatus.retryLater]
  /// geçici hata demek.
  static PushStatus _statusFor(Exception error) => switch (error) {
    // Süresi dolmuş token çevrimdışı yenilenemedi.
    AuthRetryableFetchException() => PushStatus.retryLater,
    // Refresh token reddedildi; oturum düşecek.
    AuthException() => PushStatus.failed,
    PostgrestException(code: 'PT426' || '426') => PushStatus.upgradeRequired,
    PostgrestException(:final code?) when _isTransient(code) =>
      PushStatus.retryLater,
    PostgrestException() => PushStatus.failed,
    // Bağlantı hatası (ClientException, SocketException) ya da zaman aşımı.
    _ => PushStatus.retryLater,
  };

  /// sync_push bu SQLSTATE sınıflarında paketi geri alır: bağlantı,
  /// kilitlenme, kaynak yetersizliği, iptal ve zaman aşımı, sistem hatası.
  static const _transientSqlStateClasses = {'08', '40', '53', '57', '58'};

  /// `55P03` kilit beklenemedi. `PGRST000`–`PGRST003` PostgREST'in
  /// veritabanına ulaşamaması. Sayılar, JSON dönmeyen ağ geçidinin HTTP
  /// durumu (postgrest kodu böyle doldurur).
  static const _transientCodes = {
    '55P03',
    'PGRST000',
    'PGRST001',
    'PGRST002',
    'PGRST003',
    '408',
    '429',
    '500',
    '502',
    '503',
    '504',
  };

  static bool _isTransient(String code) =>
      _transientCodes.contains(code) ||
      (code.length == 5 &&
          _transientSqlStateClasses.contains(code.substring(0, 2)));
}

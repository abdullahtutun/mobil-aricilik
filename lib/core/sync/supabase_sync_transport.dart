import 'package:mobil_arici/core/sync/sync_transport.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// [SyncTransport]'un Supabase uygulaması: `sync_push` ve `sync_pull`
/// RPC'leri.
class SupabaseSyncTransport implements SyncTransport {
  const new(this._client);

  final SupabaseClient _client;

  /// Tek isteğin süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 30);

  @override
  Future<SyncPushResponse> push(
    List<SyncChange> batch, {
    required DateTime clientTime,
    required int schemaVersion,
  }) async {
    final response = await _guard(
      () => _client
          .rpc<Map<String, dynamic>>(
            'sync_push',
            params: {
              'changes': [
                for (final change in batch)
                  {
                    'id': change.id,
                    'table': change.table,
                    'operation': change.operation,
                    'payload': change.payload,
                  },
              ],
              'client_time': clientTime.toUtc().toIso8601String(),
              'schema_version': schemaVersion,
            },
          )
          // POST zaten kendiliğinden yeniden denenmez; burada yalnız süre
          // sınırı konur, yeniden denemeyi SyncService yapar.
          .retry(enabled: false, requestTimeout: requestTimeout),
    );
    return SyncPushResponse({
      if (response['results'] case final List<dynamic> list)
        for (final result in list)
          if (_outcomeOf(result) case (final id, final outcome)) id: outcome,
    });
  }

  static (int, SyncPushOutcome)? _outcomeOf(Object? result) => switch (result) {
    {'id': final int id, 'status': 'ok'} => (id, const SyncPushAccepted()),
    {
      'id': final int id,
      'status': 'rejected',
      'reason': final String reason,
      'message': final String message,
    } =>
      (id, SyncPushRejected(reason: reason, message: message)),
    _ => null,
  };

  @override
  Future<SyncPullPage> pull(
    String table, {
    required int sinceSeq,
    required int pageSize,
  }) async {
    final response = await _guard(
      () => _client
          .rpc<Map<String, dynamic>>(
            'sync_pull',
            params: {
              'table_name': table,
              'since_seq': sinceSeq,
              'page_size': pageSize,
            },
          )
          .retry(enabled: false, requestTimeout: requestTimeout),
    );
    if (response case {
      'rows': final List<dynamic> rows,
      'next_seq': final int nextSeq,
      'has_more': final bool hasMore,
    }) {
      return SyncPullPage(rows: rows, nextSeq: nextSeq, hasMore: hasMore);
    }
    throw const SyncPermanentException(
      'sync_pull yanıtı beklenen biçimde değil',
    );
  }

  /// Supabase hatalarını [SyncTransportException]'a çevirir.
  static Future<T> _guard<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on Exception catch (error) {
      throw _classify(error);
    }
  }

  static SyncTransportException _classify(Exception error) => switch (error) {
    // Süresi dolmuş token çevrimdışı yenilenemedi.
    AuthRetryableFetchException() => SyncTransientException('$error'),
    // Refresh token reddedildi; oturum düşecek.
    AuthException() => SyncPermanentException('$error'),
    PostgrestException(code: 'PT426' || '426') => SyncUpgradeRequiredException(
      '$error',
    ),
    PostgrestException(:final code?) when _isTransient(code) =>
      SyncTransientException('$error'),
    PostgrestException() => SyncPermanentException('$error'),
    // Bağlantı hatası (ClientException, SocketException) ya da zaman aşımı.
    _ => SyncTransientException('$error'),
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

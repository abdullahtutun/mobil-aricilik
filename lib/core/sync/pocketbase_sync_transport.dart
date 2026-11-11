import 'dart:async';

import 'package:mobil_arici/core/sync/sync_transport.dart';
import 'package:pocketbase/pocketbase.dart';

/// [SyncTransport]'un PocketBase uygulaması: `POST /api/sync/push` ve
/// `GET /api/sync/pull` (`server/internal/sync`). Gövdeler Supabase'in
/// `sync_push` / `sync_pull` RPC'leriyle aynı biçimde (geçiş planı, P5
/// "Senkron sözleşmesi").
///
/// Token istekte elle gönderilir: SDK süresi dolmuş token'ı hiç göndermez,
/// 401'in sunucunun o token'a verdiği yanıt olduğu bilinsin. 401 oturumu
/// kapatır (SDK 0.25.3 kapatmaz), ama yalnız istek sürerken oturum
/// değişmediyse: araya giren yeni girişin token'ı silinmez.
class PocketBaseSyncTransport implements SyncTransport {
  const new(this._client, {this.timeout = requestTimeout});

  final PocketBase _client;

  /// Tek isteğin süre sınırı; testler kısaltır.
  final Duration timeout;

  static const pushPath = '/api/sync/push';
  static const pullPath = '/api/sync/pull';

  /// Varsayılan süre sınırı; askıda kalan bağlantı kilidi tutmasın.
  static const requestTimeout = Duration(seconds: 30);

  /// Sunucunun ya da aradaki proxy'nin geçici durumları; aynı istek sonra
  /// yeniden denenir. Push'ta 503 sunucunun geri aldığı paket.
  static const transientStatuses = {408, 429, 500, 502, 503, 504};

  @override
  Future<SyncPushResponse> push(
    List<SyncChange> batch, {
    required DateTime clientTime,
    required int schemaVersion,
  }) async {
    final response = await _send(
      pushPath,
      method: 'POST',
      body: {
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
    );
    if (response case {'results': final List<Object?> results}) {
      return SyncPushResponse({
        for (final result in results)
          if (_outcomeOf(result) case (final id, final outcome)) id: outcome,
      });
    }
    throw const SyncPermanentException(
      'sync/push yanıtı beklenen biçimde değil',
    );
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
    final response = await _send(
      pullPath,
      query: {'table': table, 'since_seq': sinceSeq, 'page_size': pageSize},
    );
    if (response case {
      'rows': final List<Object?> rows,
      'next_seq': final int nextSeq,
      'has_more': final bool hasMore,
    }) {
      return SyncPullPage(rows: rows, nextSeq: nextSeq, hasMore: hasMore);
    }
    throw const SyncPermanentException(
      'sync/pull yanıtı beklenen biçimde değil',
    );
  }

  /// İsteği oturumun token'ıyla gönderir; hataları
  /// [SyncTransportException]'a çevirir.
  Future<Object?> _send(
    String path, {
    String method = 'GET',
    Map<String, Object?> query = const {},
    Map<String, Object?> body = const {},
  }) async {
    final store = _client.authStore;
    final token = store.token;
    // Oturum yok (çıkış yapıldı ya da 401 kapattı): sunucu yine 401 derdi.
    if (token.isEmpty) throw const SyncPermanentException('oturum yok');
    try {
      return await _client
          .send<Object?>(
            path,
            method: method,
            query: query,
            body: body,
            headers: {'Authorization': token},
          )
          .timeout(timeout);
    } on TimeoutException catch (error) {
      throw SyncTransientException('$error');
    } on ClientException catch (error) {
      if (error.statusCode == 401 && store.token == token) store.clear();
      throw classify(error);
    }
  }

  /// SDK hatasını turun nasıl biteceğine çevirir. Durum kodu 0 yanıt yok
  /// demek (bağlantı hatası, kopan bağlantı); geçici. JSON olmayan 200
  /// gövdesi hata değil, metin olarak gelir ve biçim denetiminde kalıcı
  /// sayılır.
  static SyncTransportException classify(ClientException error) =>
      switch (error.statusCode) {
        0 => SyncTransientException('$error'),
        426 => SyncUpgradeRequiredException('$error'),
        final status when transientStatuses.contains(status) =>
          SyncTransientException('$error'),
        // 401 (oturum kapatıldı) ve diğer istemci hataları; yeniden
        // denemek işe yaramaz.
        _ => SyncPermanentException('$error'),
      };
}

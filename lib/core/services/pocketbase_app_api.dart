import 'dart:async';

import 'package:pocketbase/pocketbase.dart';

/// PocketBase'deki uygulama route'larının (`/api/app/...`) hata yanıtı:
/// `{status, message, data: {code}}` (`server/internal/auth.ErrorBody`).
/// [status] 0 yanıt yok demek (bağlantı hatası, kopan bağlantı, zaman
/// aşımı); [code] gövdede `data.code` yoksa null.
class PocketBaseApiException implements Exception {
  const new(this.status, {this.code, this.data = const {}, this.cause});

  final int status;
  final String? code;

  /// Gövdenin `data` nesnesi (ör. hesap silmede `org_ids`).
  final Map<String, Object?> data;
  final Object? cause;

  /// Yanıt gelmedi ya da sunucu geçici olarak hata verdi (5xx).
  bool get isNetwork => status == 0 || status >= 500;

  @override
  String toString() => 'PocketBaseApiException($status, $code)';
}

/// Uygulama route'larına oturumun token'ıyla JSON isteği atar; SDK'nın
/// hatasını [PocketBaseApiException]'a çevirir.
///
/// Token elle gönderilir: SDK süresi dolmuş token'ı hiç göndermez, oysa
/// karar sunucunun olmalı (K-6; süresi dolmuşsa sunucu 401 döner, oturumu
/// senkron turu yeniler ya da kapatır). Oturum yoksa istek token'sız gider,
/// sunucu 401 döner.
Future<Object?> sendPocketBaseAppRequest(
  PocketBase client,
  String path, {
  String method = 'POST',
  Map<String, Object?> body = const {},
  Duration timeout = pocketBaseAppRequestTimeout,
}) async {
  final token = client.authStore.token;
  try {
    return await client
        .send<Object?>(
          path,
          method: method,
          body: body,
          headers: {if (token.isNotEmpty) 'Authorization': token},
        )
        .timeout(timeout);
  } on TimeoutException catch (error) {
    throw PocketBaseApiException(0, cause: error);
  } on ClientException catch (error) {
    final data = switch (error.response['data']) {
      final Map<String, dynamic> data => data,
      _ => const <String, Object?>{},
    };
    throw PocketBaseApiException(
      error.statusCode,
      code: switch (data['code']) {
        final String code => code,
        _ => null,
      },
      data: data,
      cause: error,
    );
  }
}

/// Uygulama route'larında tek isteğin varsayılan süre sınırı; askıda kalan
/// bağlantı ekranı bekletmesin.
const pocketBaseAppRequestTimeout = Duration(seconds: 30);

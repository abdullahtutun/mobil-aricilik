import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:pocketbase/pocketbase.dart';

import 'fake_pocketbase_files.dart';

/// Uygulama route'larının (`/api/app/...`) hata gövdesi:
/// `{status, message, data: {code, ...}}` (`server/internal/auth.ErrorBody`).
http.Response fakePocketBaseAppError(
  int status,
  String code, {
  Map<String, Object?> data = const {},
}) => fakePocketBaseJson({
  'status': status,
  'message': '$code mesajı',
  'data': {'code': code, ...data},
}, status);

/// Oturumdaki kullanıcının kimliği.
const fakePocketBaseUserId = '0199a3b2-7c1e-7d40-8a5b-000000000001';

/// İstekleri kaydeden sahte PocketBase sunucusu; yanıtı [handler] verir
/// (varsayılan boş JSON nesnesi).
class FakePocketBaseApi {
  final requests = <http.Request>[];
  FutureOr<http.Response> Function(http.Request request) handler = (_) =>
      fakePocketBaseJson(<String, Object?>{});

  /// Bu sahte sunucuya bağlı istemci; oturum [token] (varsayılan bir saat
  /// geçerli), [signedIn] false ise oturum yok.
  PocketBase client({String? token, bool signedIn = true}) {
    final pb = PocketBase(
      fakePocketBaseUrl,
      httpClientFactory: () => MockClient((request) async {
        requests.add(request);
        return await handler(request);
      }),
    );
    if (signedIn) {
      pb.authStore.save(
        token ??
            fakePocketBaseJwt(DateTime.now().add(const Duration(hours: 1))),
        RecordModel({
          'id': fakePocketBaseUserId,
          'collectionName': 'users',
          'email': 'ari@example.com',
        }),
      );
    }
    return pb;
  }

  /// İsteğin JSON gövdesi.
  static Map<String, Object?> body(http.Request request) =>
      jsonDecode(request.body) as Map<String, Object?>;
}

// firebase_messaging 17 getToken/onTokenRefresh/deleteToken'ı kullanımdan
// kaldırdı; yerine gelen register() FID ile doğrudan gönderim içindir.
// Sunucumuz FCM HTTP v1'e kayıt token'ıyla gönderdiği için eski API'de
// kalındı.
// ignore_for_file: deprecated_member_use

import 'dart:async';
import 'dart:io' show Platform;

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:mobil_arici/app/firebase_options.dart';

/// Bu telefonun push (FCM) bağlantısı. Firebase hazır değilse (yapılandırma
/// yok, desteklenmeyen platform) her çağrı sessizce "yok" döner; uygulama
/// push olmadan çalışır.
abstract interface class PushService {
  /// Push gönderilebilecek platform (Android, iOS).
  String? get platform;

  /// Bildirim izni; [request] doğruysa gerekiyorsa sistem diyaloğunu açar.
  Future<bool> permission({required bool request});

  /// Cihazın FCM token'ı; alınamıyorsa null.
  Future<String?> token();

  /// Token yenilenince yeni değer.
  Stream<String> get tokenRefreshes;

  /// Bu telefonun token'ını siler; sunucudaki kayıt artık boşa gider.
  Future<void> deleteToken();

  /// Uygulama kapalıyken bildirime dokunularak açıldıysa görevin kimliği.
  Future<String?> launchTaskId();

  /// Uygulama arka plandayken bildirime dokunulunca görevin kimliği.
  Stream<String> get taskOpens;
}

/// Bildirimin `data.task_id` alanı; görev bildirimi değilse null.
String? taskIdOf(Map<String, Object?> data) =>
    switch ((data['type'], data['task_id'])) {
      ('task', final String id) when id.isNotEmpty => id,
      _ => null,
    };

class FirebasePushService implements PushService {
  Future<FirebaseMessaging?>? _messaging;

  Future<FirebaseMessaging?> _ready() => _messaging ??= () async {
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(options: firebaseOptions);
      }
      return FirebaseMessaging.instance;
    } on Object {
      return null;
    }
  }();

  @override
  String? get platform => switch (Platform.operatingSystem) {
    'android' => 'android',
    'ios' => 'ios',
    _ => null,
  };

  @override
  Future<bool> permission({required bool request}) async {
    final messaging = await _ready();
    if (messaging == null) return false;
    try {
      final settings = request
          ? await messaging.requestPermission()
          : await messaging.getNotificationSettings();
      return switch (settings.authorizationStatus) {
        AuthorizationStatus.authorized ||
        AuthorizationStatus.provisional => true,
        _ => false,
      };
    } on Object {
      return false;
    }
  }

  @override
  Future<String?> token() async {
    try {
      return await (await _ready())?.getToken();
    } on Object {
      // iOS'ta APNs token'ı gelmediyse ya da ağ yoksa.
      return null;
    }
  }

  @override
  Stream<String> get tokenRefreshes async* {
    final messaging = await _ready();
    if (messaging != null) yield* messaging.onTokenRefresh;
  }

  @override
  Future<void> deleteToken() async {
    try {
      await (await _ready())?.deleteToken();
    } on Object {
      // Silinemediyse sunucu token'ı ilk başarısız gönderimde atar.
    }
  }

  @override
  Future<String?> launchTaskId() async {
    final message = await (await _ready())?.getInitialMessage();
    return message == null ? null : taskIdOf(message.data);
  }

  @override
  Stream<String> get taskOpens async* {
    await _ready();
    if (Firebase.apps.isEmpty) return;
    yield* FirebaseMessaging.onMessageOpenedApp
        .map((message) => taskIdOf(message.data))
        .where((id) => id != null)
        .cast<String>();
  }
}

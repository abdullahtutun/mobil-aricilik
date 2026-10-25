import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Bu telefonda ileri bir zamana kurulan hatırlatma bildirimi (ör. ilaç
/// şeridini çıkarma günü). İnternet gerekmez; bildirimi işletim sistemi
/// gösterir, uygulama kapalı olsa da.
abstract interface class ReminderNotifications {
  /// [id]'li bildirimi [at] (yerel saat) anına kurar; aynı [id]'li eski
  /// bildirim yerine geçer. İzin verilmezse sessizce kurulmaz ve false
  /// döner. [channelName] Android ayarlarında bildirim kanalının adı.
  Future<bool> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    required String channelName,
  });

  /// [id]'li kurulu bildirimi kaldırır; yoksa bir şey yapmaz.
  Future<void> cancel(int id);
}

/// flutter_local_notifications ile. Eklenti ve saat dilimi ilk kullanımda
/// hazırlanır. Android'de tam zamanlı alarm izni istenmez; bildirim birkaç
/// dakika gecikebilir.
class DeviceReminderNotifications implements ReminderNotifications {
  new([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  @override
  Future<bool> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    required String channelName,
  }) async {
    await (_ready ??= _init());
    if (!await _requestPermission()) return false;
    await _plugin.zonedSchedule(
      id: id,
      title: title,
      body: body,
      scheduledDate: tz.TZDateTime.from(at, tz.local),
      notificationDetails: NotificationDetails(
        android: AndroidNotificationDetails(
          'reminders',
          channelName,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
    );
    return true;
  }

  @override
  Future<void> cancel(int id) async {
    await (_ready ??= _init());
    await _plugin.cancel(id: id);
  }

  Future<void> _init() async {
    tz_data.initializeTimeZones();
    final zone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(zone.identifier));
    await _plugin.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        // İzin açılışta değil, ilk hatırlatma kurulurken istenir.
        iOS: DarwinInitializationSettings(
          requestAlertPermission: false,
          requestBadgePermission: false,
          requestSoundPermission: false,
        ),
      ),
    );
  }

  Future<bool> _requestPermission() async {
    final android = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (android != null) {
      return await android.requestNotificationsPermission() ?? false;
    }
    final ios = _plugin
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >();
    if (ios != null) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }
}

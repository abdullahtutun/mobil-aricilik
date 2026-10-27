import 'dart:io' show Platform;

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Bu telefonda kurulacak bir hatırlatma bildirimi; `at` yerel saat.
typedef Reminder = ({int id, DateTime at, String title, String body});

/// Hatırlatma grupları; her grup kendi bildirimlerini ayrı eşitler.
abstract final class ReminderGroups {
  /// Görev son tarihleri.
  static const tasks = 'tasks';

  /// Belge süre dolumları.
  static const documents = 'documents';
}

/// Bu telefonda ileri bir zamana kurulan hatırlatma bildirimleri (görev
/// son tarihleri, belge süre dolumları). İnternet gerekmez; bildirimi
/// işletim sistemi gösterir, uygulama kapalı olsa da.
abstract interface class ReminderNotifications {
  /// Bildirim izni verilmiş mi; sormaz.
  Future<bool> hasPermission();

  /// Bildirim iznini gerekiyorsa sorar; verildi mi.
  Future<bool> requestPermission();

  /// Tam zamanlı alarm izni olan bir platform mu (Android). Değilse
  /// bildirimler zaten tam saatinde çalar.
  bool get supportsExactAlarms;

  /// Bildirimler tam saatinde çalabilir mi. Android'de tam zamanlı alarm
  /// izni (`SCHEDULE_EXACT_ALARM`) yoksa birkaç dakika gecikebilir.
  Future<bool> canScheduleExact();

  /// Sistemin "Alarmlar ve hatırlatıcılar" ayarını açar; dönünce izin
  /// verildi mi.
  Future<bool> requestExactAlarms();

  /// [group]'un kurulu bildirimlerini [reminders] ile eşitler: listede
  /// olmayanlar kaldırılır, olanlar kurulur ya da yenilenir; başka grubun
  /// bildirimlerine dokunulmaz. İzin yoksa bildirim görünmez ama kurulur;
  /// izin gelince çalar. [channelName] Android ayarlarında bildirim
  /// kanalının adı.
  Future<void> replaceAll(
    List<Reminder> reminders, {
    required String channelName,
    required String group,
  });
}

/// flutter_local_notifications ile. Eklenti ve saat dilimi ilk kullanımda
/// hazırlanır. Android'de tam zamanlı alarm izni varsa bildirim tam
/// saatinde, yoksa pil tasarrufuna uyarak birkaç dakika gecikmeli çalar.
class DeviceReminderNotifications implements ReminderNotifications {
  new([FlutterLocalNotificationsPlugin? plugin])
    : _plugin = plugin ?? FlutterLocalNotificationsPlugin();

  final FlutterLocalNotificationsPlugin _plugin;
  Future<void>? _ready;

  AndroidFlutterLocalNotificationsPlugin? get _android => _plugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >();

  IOSFlutterLocalNotificationsPlugin? get _ios => _plugin
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >();

  @override
  bool get supportsExactAlarms => Platform.isAndroid;

  @override
  Future<bool> hasPermission() async {
    await (_ready ??= _init());
    if (_android case final android?) {
      return await android.areNotificationsEnabled() ?? false;
    }
    if (_ios case final ios?) {
      return (await ios.checkPermissions())?.isEnabled ?? false;
    }
    return false;
  }

  @override
  Future<bool> requestPermission() async {
    await (_ready ??= _init());
    if (_android case final android?) {
      return await android.requestNotificationsPermission() ?? false;
    }
    if (_ios case final ios?) {
      return await ios.requestPermissions(alert: true, sound: true) ?? false;
    }
    return false;
  }

  @override
  Future<bool> canScheduleExact() async {
    await (_ready ??= _init());
    if (_android case final android?) {
      return await android.canScheduleExactNotifications() ?? false;
    }
    return true;
  }

  @override
  Future<bool> requestExactAlarms() async {
    await (_ready ??= _init());
    if (_android case final android?) {
      return await android.requestExactAlarmsPermission() ?? false;
    }
    return true;
  }

  /// Grup bildirimin `payload`'ında. Gruplardan önce kurulan bildirimlerin
  /// payload'u yok; ilk eşitleyen grup onları kaldırır, görevler yeniden
  /// kurulur.
  @override
  Future<void> replaceAll(
    List<Reminder> reminders, {
    required String channelName,
    required String group,
  }) async {
    await (_ready ??= _init());
    final wanted = {for (final reminder in reminders) reminder.id};
    for (final pending in await _plugin.pendingNotificationRequests()) {
      if ((pending.payload == null || pending.payload == group) &&
          !wanted.contains(pending.id)) {
        await _plugin.cancel(id: pending.id);
      }
    }
    // İzin yokken tam zamanlı kurmak Android'de hata verir.
    final mode = await canScheduleExact()
        ? AndroidScheduleMode.exactAllowWhileIdle
        : AndroidScheduleMode.inexactAllowWhileIdle;
    for (final reminder in reminders) {
      await _plugin.zonedSchedule(
        id: reminder.id,
        title: reminder.title,
        body: reminder.body,
        scheduledDate: tz.TZDateTime.from(reminder.at, tz.local),
        notificationDetails: NotificationDetails(
          android: AndroidNotificationDetails(
            'reminders',
            channelName,
            importance: Importance.high,
            priority: Priority.high,
          ),
          iOS: const DarwinNotificationDetails(),
        ),
        androidScheduleMode: mode,
        payload: group,
      );
    }
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
}

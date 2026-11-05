import 'package:mobil_arici/core/services/reminder_notifications.dart';

/// Cihazsız hatırlatma bildirimi: kurulanları kimliğe göre tutar.
class FakeReminderNotifications implements ReminderNotifications {
  /// Bildirim izni; [requestPermission] sorulduğunda [grantOnRequest]
  /// verilir.
  bool permitted = true;
  bool grantOnRequest = true;
  int permissionRequests = 0;

  @override
  bool supportsExactAlarms = true;

  /// Tam zamanlı alarm izni; [requestExactAlarms] [grantExactOnRequest]
  /// verir. Varsayılan açık: izin diyaloğu yalnız onu deneyen testte çıkar.
  bool exact = true;
  bool grantExactOnRequest = true;
  int exactRequests = 0;

  /// Bütün grupların kurulu bildirimleri.
  Map<int, Reminder> get scheduled => {
    for (final group in groups.values) ...group,
  };

  /// Grup → kurulu bildirimler.
  final groups = <String, Map<int, Reminder>>{};
  String? channelName;
  int replaceCalls = 0;

  @override
  Future<bool> hasPermission() async => permitted;

  @override
  Future<bool> requestPermission() async {
    permissionRequests++;
    if (!permitted) permitted = grantOnRequest;
    return permitted;
  }

  @override
  Future<bool> canScheduleExact() async => exact;

  @override
  Future<bool> requestExactAlarms() async {
    exactRequests++;
    if (!exact) exact = grantExactOnRequest;
    return exact;
  }

  @override
  Future<void> replaceAll(
    List<Reminder> reminders, {
    required String channelName,
    required String group,
  }) async {
    replaceCalls++;
    this.channelName = channelName;
    groups[group] = {for (final r in reminders) r.id: r};
  }

  @override
  Future<void> cancelAll() async => groups.clear();
}

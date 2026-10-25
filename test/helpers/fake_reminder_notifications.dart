import 'package:mobil_arici/core/services/reminder_notifications.dart';

/// Cihazsız hatırlatma bildirimi: kurulanları kimliğe göre tutar.
class FakeReminderNotifications implements ReminderNotifications {
  /// Bildirim izni; false ise hiçbir şey kurulmaz.
  bool permitted = true;

  final scheduled =
      <int, ({DateTime at, String title, String body, String channelName})>{};
  final cancelled = <int>[];

  @override
  Future<bool> schedule({
    required int id,
    required DateTime at,
    required String title,
    required String body,
    required String channelName,
  }) async {
    if (!permitted) return false;
    scheduled[id] = (
      at: at,
      title: title,
      body: body,
      channelName: channelName,
    );
    return true;
  }

  @override
  Future<void> cancel(int id) async {
    cancelled.add(id);
    scheduled.remove(id);
  }
}

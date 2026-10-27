import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:clock/clock.dart';
import 'package:flutter/widgets.dart' show AppLifecycleListener;
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/reminder_notifications.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_labels.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'task_reminders.g.dart';

/// Bu telefondaki bildirim izinleri.
typedef ReminderAccessState = ({
  /// Bildirim izni var.
  bool notifications,

  /// Bildirimler tam saatinde çalabilir (Android'de tam zamanlı alarm
  /// izni; diğer platformlarda hep true).
  bool exact,

  /// Tam zamanlı alarm izni istenebilen platform (Android).
  bool supportsExact,
});

/// Bildirim ve tam zamanlı alarm izinleri. İzin değişince (ör. sistem
/// ayarından dönünce) kurulu hatırlatmalar yeni duruma göre yeniden kurulur.
@Riverpod(keepAlive: true)
class ReminderAccess extends _$ReminderAccess {
  @override
  Future<ReminderAccessState> build() async {
    final notifications = ref.watch(reminderNotificationsProvider);
    return (
      notifications: await notifications.hasPermission(),
      exact: await notifications.canScheduleExact(),
      supportsExact: notifications.supportsExactAlarms,
    );
  }

  /// Bildirim iznini gerekiyorsa sorar; verildi mi.
  Future<bool> requestNotifications() async {
    final granted = await ref
        .read(reminderNotificationsProvider)
        .requestPermission();
    await _changed();
    return granted;
  }

  /// Tam zamanlı alarm ayarını açar; dönünce izin verildi mi.
  Future<bool> requestExact() async {
    final granted = await ref
        .read(reminderNotificationsProvider)
        .requestExactAlarms();
    await _changed();
    return granted;
  }

  /// İzinleri yeniden okur (uygulama öne gelince).
  Future<void> refresh() => _changed();

  Future<void> _changed() async {
    ref.invalidateSelf();
    await future;
    await ref.read(taskRemindersProvider.notifier).resync();
  }
}

/// Görev hatırlatmalarını yerel DB'den eşitler: bu telefonun kullanıcısına
/// atanmış ya da atanmamış açık görevlerin ([reminderPlan]) bildirimleri
/// kurulur, diğerleri kaldırılır. Senkronla gelen, tamamlanan, silinen ya
/// da günü değişen görev de kendiliğinden yansır; internet gerekmez.
/// Uygulama öne gelince izinler ve bildirimler yenilenir. Oturum ya da
/// işletme yoksa bütün bildirimler kalkar. `bootstrap` uygulama boyunca
/// dinler.
@Riverpod(keepAlive: true)
class TaskReminders extends _$TaskReminders {
  List<TaskView> _tasks = const [];
  late String? _userId;
  late AppLocalizations _l10n;
  var _dirty = false;
  Future<void>? _running;

  @override
  void build() {
    final orgId = ref.watch(currentOrgIdProvider);
    _userId = ref.watch(currentUserIdProvider);
    _l10n = lookupAppLocalizations(
      ref.watch(languageProvider).locale ??
          resolveAppLocale(
            PlatformDispatcher.instance.locales,
            AppLocalizations.supportedLocales,
          ),
    );
    _tasks = const [];
    if (orgId == null) {
      // Çıkışta önceki kullanıcının hatırlatmaları kalmasın.
      scheduleMicrotask(_resyncQuietly);
      return;
    }
    final subscription = ref
        .read(taskRepositoryProvider)
        .watchOpen(orgId)
        .listen((tasks) {
          _tasks = tasks;
          _resyncQuietly();
        });
    final lifecycle = AppLifecycleListener(
      onResume: () =>
          unawaited(ref.read(reminderAccessProvider.notifier).refresh()),
    );
    ref.onDispose(() {
      unawaited(subscription.cancel());
      lifecycle.dispose();
    });
  }

  /// Kurulu bildirimleri şimdiki görevlerle eşitler. Eşitleme sürerken
  /// gelen istekler bittikten sonra tek bir tur daha çalıştırır.
  Future<void> resync() {
    _dirty = true;
    return _running ??= _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    while (_dirty) {
      _dirty = false;
      final plan = reminderPlan(_tasks, userId: _userId, now: clock.now());
      await ref
          .read(reminderNotificationsProvider)
          .replaceAll(
            [
              for (final view in plan)
                (
                  id: reminderNotificationId(view.task.id),
                  at: view.task.dueAt.toLocal(),
                  title: taskTitle(_l10n, view),
                  body: taskNotificationBody(_l10n, view),
                ),
            ],
            channelName: _l10n.reminderChannelName,
            group: ReminderGroups.tasks,
          );
    }
  }

  /// Akıştan tetiklenen eşitleme; hata (ör. eklenti hazır değil) bir
  /// sonraki görev değişikliğinde ya da açılışta yeniden denenir.
  void _resyncQuietly() => unawaited(resync().catchError((Object _) {}));
}

import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:clock/clock.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/reminder_notifications.dart';
import 'package:mobil_arici/core/sync/sync_backup_rules.dart';
import 'package:mobil_arici/core/sync/sync_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'sync_reminder.g.dart';

/// Gönderilemeyen kayıt hatırlatması: bekleyen en eski kayıttan
/// [syncOverdueAfter] sonra (gece düşerse 09:00'da) bu telefonda tek bir
/// bildirim kurulur ([syncReminderAt]). Kayıtlar gönderilince ya da
/// bekleyen kalmayınca bildirim kalkar; an geçtiyse kurulmaz, uyarı
/// Bugün'de görünür. İnternet gerekmez. Oturum ya da işletme yoksa bildirim
/// kalkar. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
class SyncReminder extends _$SyncReminder {
  DateTime? _oldestPendingAt;
  int _pending = 0;
  late AppLocalizations _l10n;
  var _dirty = false;
  Future<void>? _running;

  @override
  void build() {
    final orgId = ref.watch(currentOrgIdProvider);
    _l10n = lookupAppLocalizations(
      ref.watch(languageProvider).locale ??
          resolveAppLocale(
            PlatformDispatcher.instance.locales,
            AppLocalizations.supportedLocales,
          ),
    );
    _oldestPendingAt = null;
    _pending = 0;
    ref.listen(reminderAccessProvider, (_, _) => _resyncQuietly());
    if (orgId == null) {
      scheduleMicrotask(_resyncQuietly);
      return;
    }
    final repository = ref.read(syncRepositoryProvider);
    final oldest = repository.watchOldestPendingAt().listen((at) {
      _oldestPendingAt = at;
      _resyncQuietly();
    });
    final count = repository.watchPendingCount().listen((pending) {
      _pending = pending;
      _resyncQuietly();
    });
    ref.onDispose(() {
      unawaited(oldest.cancel());
      unawaited(count.cancel());
    });
  }

  /// Kurulu bildirimi şimdiki bekleyen kayıtlarla eşitler. Eşitleme
  /// sürerken gelen istekler bittikten sonra tek bir tur daha çalıştırır.
  Future<void> resync() {
    _dirty = true;
    return _running ??= _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    while (_dirty) {
      _dirty = false;
      final at = syncReminderAt(
        oldestPendingAt: _oldestPendingAt,
        now: clock.now(),
      );
      await ref
          .read(reminderNotificationsProvider)
          .replaceAll(
            [
              if (at != null && _pending > 0)
                (
                  id: syncReminderId,
                  at: at,
                  title: _l10n.syncReminderTitle,
                  body: _l10n.syncReminderBody(_pending),
                ),
            ],
            channelName: _l10n.reminderChannelName,
            group: ReminderGroups.sync,
          );
    }
  }

  /// Akıştan tetiklenen eşitleme; hata bir sonraki değişiklikte yeniden
  /// denenir.
  void _resyncQuietly() => unawaited(resync().catchError((Object _) {}));
}

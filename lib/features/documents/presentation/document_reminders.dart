import 'dart:async';
import 'dart:ui' show PlatformDispatcher;

import 'package:clock/clock.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/l10n/language_provider.dart';
import 'package:mobil_arici/core/services/media_services_provider.dart';
import 'package:mobil_arici/core/services/reminder_notifications.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/domain/document_rules.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'document_reminders.g.dart';

/// Belge süre dolumu hatırlatmalarını yerel DB'den eşitler: geçerlilik
/// tarihi olan her belgeye son günden 30, 7 ve 1 gün önce saat 09:00'da
/// bildirim ([documentReminderPlan]). Senkronla gelen, düzenlenen ya da
/// silinen belge de kendiliğinden yansır; internet gerekmez. Bildirim
/// izinleri değişince yeniden kurulur. Oturum ya da işletme yoksa belge
/// bildirimleri kalkar. `bootstrap` uygulama boyunca dinler.
@Riverpod(keepAlive: true)
class DocumentReminders extends _$DocumentReminders {
  List<VaultDocument> _documents = const [];
  late AppLocalizations _l10n;
  var _dirty = false;
  Future<void>? _running;

  @override
  void build() {
    final orgId = ref.watch(currentOrgIdProvider);
    final locale =
        ref.watch(languageProvider).locale ??
        resolveAppLocale(
          PlatformDispatcher.instance.locales,
          AppLocalizations.supportedLocales,
        );
    _l10n = lookupAppLocalizations(locale);
    _documents = const [];
    ref.listen(reminderAccessProvider, (_, _) => _resyncQuietly());
    if (orgId == null) {
      // Çıkışta önceki işletmenin hatırlatmaları kalmasın.
      scheduleMicrotask(_resyncQuietly);
      return;
    }
    final subscription = ref
        .read(documentRepositoryProvider)
        .watchByOrg(orgId)
        .listen((documents) {
          _documents = documents;
          _resyncQuietly();
        });
    ref.onDispose(() => unawaited(subscription.cancel()));
  }

  /// Kurulu belge bildirimlerini şimdiki belgelerle eşitler. Eşitleme
  /// sürerken gelen istekler bittikten sonra tek bir tur daha çalıştırır.
  Future<void> resync() {
    _dirty = true;
    return _running ??= _loop().whenComplete(() => _running = null);
  }

  Future<void> _loop() async {
    while (_dirty) {
      _dirty = false;
      // Bildirim metnindeki tarih; widget ağacı dışında yerel veri gerekir.
      await initializeDateFormatting(_l10n.localeName);
      final format = AppFormat(_l10n.localeName);
      final plan = documentReminderPlan(_documents, now: clock.now());
      await ref
          .read(reminderNotificationsProvider)
          .replaceAll(
            [
              for (final reminder in plan)
                (
                  id: documentReminderId(
                    reminder.document.id,
                    reminder.daysLeft,
                  ),
                  at: reminder.at,
                  title: reminder.document.name,
                  body: _l10n.documentReminderBody(
                    reminder.daysLeft,
                    format.date(reminder.document.expiresOn!),
                  ),
                ),
            ],
            channelName: _l10n.reminderChannelName,
            group: ReminderGroups.documents,
          );
    }
  }

  /// Akıştan tetiklenen eşitleme; hata (ör. eklenti hazır değil) bir
  /// sonraki belge değişikliğinde ya da açılışta yeniden denenir.
  void _resyncQuietly() => unawaited(resync().catchError((Object _) {}));
}

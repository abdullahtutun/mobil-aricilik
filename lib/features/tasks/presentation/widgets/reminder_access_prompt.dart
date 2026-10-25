import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/db/local_settings_provider.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/tasks/presentation/task_reminders.dart';

/// Hatırlatma kurulan bir kayıttan sonra izinleri ister: önce bildirim
/// izni (sistem sorar), sonra Android'de tam zamanlı alarm izni yoksa
/// nedenini bir kez anlatır ve onaylanırsa sistem ayarını açar. Bir kez
/// anlatıldıktan sonra yalnız Ayarlar'dan istenir. Bildirim izni verildi
/// mi döner.
Future<bool> requestReminderAccess(BuildContext context, WidgetRef ref) async {
  final access = ref.read(reminderAccessProvider.notifier);
  if (!await access.requestNotifications()) return false;
  final state = await ref.read(reminderAccessProvider.future);
  if (!state.supportsExact || state.exact) return true;

  final settings = ref.read(localSettingsRepositoryProvider);
  if (await settings.exactAlarmPrompted() || !context.mounted) return true;
  await settings.setExactAlarmPrompted();
  if (!context.mounted) return true;
  final l10n = AppLocalizations.of(context);
  final confirmed = await showConfirmDialog(
    context,
    title: l10n.exactAlarmTitle,
    message: l10n.exactAlarmMessage,
    confirmLabel: l10n.exactAlarmConfirm,
  );
  if (confirmed) await access.requestExact();
  return true;
}

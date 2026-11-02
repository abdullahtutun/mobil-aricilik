import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_status_event.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';

enum AddHivesChoice { one, bulk }

/// Kovan ekle: tek kovan ya da toplu oluşturma. Kapatılırsa null.
Future<AddHivesChoice?> showAddHivesSheet(BuildContext context) =>
    showOptionSheet(context, (context) {
      final l10n = AppLocalizations.of(context);
      return OptionSheet(
        title: l10n.hivesAdd,
        options: [
          SheetOption(
            value: AddHivesChoice.one,
            icon: Icons.add_rounded,
            label: l10n.hivesAddOne,
            hint: l10n.hivesAddOneHint,
          ),
          SheetOption(
            value: AddHivesChoice.bulk,
            icon: Icons.library_add_rounded,
            label: l10n.hivesAddBulk,
            hint: l10n.hivesAddBulkHint,
          ),
        ],
      );
    });

/// Kovanın yeni durumu; şimdiki durum listede yok. Kapatılırsa null.
Future<HiveStatus?> showHiveStatusSheet(BuildContext context, Hive hive) =>
    showOptionSheet(context, (context) {
      final l10n = AppLocalizations.of(context);
      final colors = context.colors;
      return OptionSheet(
        title: l10n.hiveStatusSheetTitle(hive.number),
        options: [
          for (final status in HiveStatus.values)
            if (status != hive.status)
              SheetOption(
                value: status,
                icon: status.appStatus.icon,
                iconColor: status.appStatus.colorIn(colors),
                label: status.label(l10n),
              ),
        ],
      );
    });

/// Söndü ya da kayboldu'ya geçen kovanın kayıp nedeni; sezon raporundaki
/// "Kayıplar ve nedenleri" buradan gelir. "Belirtmeden geç" boş nedendir.
/// Kapatılırsa null (durum değişmez).
Future<({HiveLossReason? reason})?> showHiveLossReasonSheet(
  BuildContext context, {
  required String number,
}) => showOptionSheet(context, (context) {
  final l10n = AppLocalizations.of(context);
  return OptionSheet(
    title: l10n.hiveLossReasonTitle(number),
    options: [
      for (final reason in HiveLossReason.values)
        SheetOption(
          value: (reason: reason),
          icon: reason.icon,
          label: reason.label(l10n),
        ),
      SheetOption(
        value: (reason: null),
        icon: Icons.help_outline_rounded,
        label: l10n.hiveLossSkip,
      ),
    ],
  );
});

/// Kovanın taşınacağı arılık; bulunduğu arılık listede yok. Kapatılırsa
/// null.
Future<Apiary?> showHiveMoveSheet(BuildContext context, Hive hive) =>
    showOptionSheet(context, (context) => _MoveSheet(hive));

/// Aktif kovan sayısını düşüren durum değişikliği için onay; vazgeçilirse
/// false.
Future<bool> confirmHiveStatusChange(
  BuildContext context, {
  required String number,
  required HiveStatus status,
}) {
  final l10n = AppLocalizations.of(context);
  return showConfirmDialog(
    context,
    title: l10n.hiveStatusConfirmTitle(status.value, number),
    message: l10n.hiveStatusConfirmMessage,
    confirmLabel: l10n.hiveStatusConfirm,
  );
}

class _MoveSheet extends ConsumerWidget {
  const new(this.hive);

  final Hive hive;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    return OptionSheet(
      title: l10n.hiveMoveTitle(hive.number),
      emptyMessage: l10n.hiveMoveNoOtherApiary,
      options: [
        for (final summary
            in ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[])
          if (summary.apiary.id != hive.apiaryId)
            SheetOption(
              value: summary.apiary,
              icon: Icons.place_rounded,
              label: summary.apiary.name,
              hint: l10n.apiaryHiveCount(summary.activeHiveCount),
            ),
      ],
    );
  }
}

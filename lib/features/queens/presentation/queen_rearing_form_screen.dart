import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/queens/domain/queen_rearing.dart';
import 'package:mobil_arici/features/queens/presentation/queen_providers.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_form_controller.dart';
import 'package:mobil_arici/features/queens/presentation/queen_rearing_providers.dart';
import 'package:mobil_arici/features/queens/presentation/widgets/queen_labels.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/reminder_access_prompt.dart';

/// Seçilebilen aktarma günü bugünden en çok bu kadar yıl önce ya da sonra.
const _pickerYears = 1;

/// Seri ekleme ([batchId] null) ve düzenleme: anne ana, aktarma günü,
/// aktarılan ve kabul edilen sayısı; düzenlemede "Seriyi sil". Yeni seri
/// kaydedilince takvim görevleri kurulur, bildirim izni istenir ve serinin
/// takvimi açılır.
class QueenRearingFormScreen extends ConsumerWidget {
  const new({super.key, this.batchId});

  final String? batchId;

  QueenRearingFormControllerProvider get _provider =>
      queenRearingFormControllerProvider(batchId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      batchId == null ? l10n.rearingFormNewTitle : l10n.rearingFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _RearingFormFields(_provider, form),
              if (batchId case final id?) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.rearingFormDelete,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => _delete(context, ref, id),
                ),
              ],
            ],
          ),
          action: BigButton(
            label: l10n.rearingFormSave,
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.rearingNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.rearingLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    if (batchId == null) {
      // Takvim görevleri bu kullanıcıya atandı; hatırlatmalar için izin.
      await requestReminderAccess(context, ref);
      if (context.mounted) context.go(AppRoutes.rearingBatch(saved.id));
    } else {
      showMessageSnackBar(context, l10n.rearingSaved);
      context.pop();
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.rearingDeleteTitle,
      message: l10n.rearingDeleteMessage,
      confirmLabel: l10n.rearingDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(rearingActionsProvider.notifier).deleteBatch(id);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.rearingDeleted);
    context.go(AppRoutes.rearing);
  }
}

class _RearingFormFields extends ConsumerWidget {
  const new(this.provider, this.form);

  final QueenRearingFormControllerProvider provider;
  final QueenRearingFormState form;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final controller = ref.read(provider.notifier);
    final queens = ref.watch(organizationQueensProvider).value ?? const [];
    final hives = ref.watch(hivesByQueenProvider).value ?? const {};
    final mother = queens
        .where((queen) => queen.id == form.motherQueenId)
        .firstOrNull;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListGroup(
          children: [
            ListRow(
              title: l10n.queenMother,
              value:
                  mother?.reference(l10n, hive: hives[mother.id]) ??
                  l10n.queenMotherUnknown,
              onTap: () async {
                final choice = await showOptionSheet<(String?,)>(
                  context,
                  (context) => OptionSheet(
                    title: l10n.queenMother,
                    options: [
                      SheetOption(
                        value: (null,),
                        icon: Icons.help_outline_rounded,
                        label: l10n.queenMotherUnknown,
                        selected: form.motherQueenId == null,
                      ),
                      // En yeni önce.
                      for (final queen in queens.reversed)
                        SheetOption(
                          value: (queen.id,),
                          icon: Icons.workspace_premium_outlined,
                          label: queen.reference(l10n, hive: hives[queen.id]),
                          selected: queen.id == form.motherQueenId,
                        ),
                    ],
                  ),
                );
                // Kapatılırsa null; "Bilinmiyor" `(null,)` döner.
                if (choice != null) controller.selectMother(choice.$1);
              },
            ),
            ListRow(
              title: l10n.rearingFormGraftedOn,
              value: format.date(form.graftedOn),
              onTap: () async {
                final day = await showDatePicker(
                  context: context,
                  initialDate: form.graftedOn,
                  firstDate: DateTime(form.graftedOn.year - _pickerYears),
                  lastDate: DateTime(
                    form.graftedOn.year + _pickerYears,
                    12,
                    31,
                  ),
                );
                if (day != null) controller.setGraftedOn(day);
              },
            ),
          ],
        ),
        SizedBox(height: spacing.xl),
        BigStepper(
          label: l10n.rearingFormGraftedCount,
          value: form.graftedCount,
          min: 1,
          max: maxGraftedCount,
          onChanged: controller.setGraftedCount,
        ),
        SizedBox(height: spacing.xl),
        BigStepper(
          label: l10n.rearingFormAcceptedCount,
          value: form.acceptedCount,
          max: form.graftedCount,
          onChanged: controller.setAcceptedCount,
        ),
        if (form.acceptedCount != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => controller.setAcceptedCount(null),
              child: Text(l10n.rearingFormAcceptedClear),
            ),
          ),
        SizedBox(height: spacing.lg),
        NoteCard(message: l10n.rearingFormScheduleHint),
      ],
    );
  }
}

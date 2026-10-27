import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';
import 'package:mobil_arici/features/migration/presentation/migration_stop_form_controller.dart';
import 'package:mobil_arici/features/migration/presentation/widgets/migration_labels.dart';

/// Tarih seçicide bugünden önce ve sonra açılan yıl sayısı.
const _pickerYears = 5;

/// Durak ekleme ([stopId] null) ve düzenleme: kaynak, yer, planlanan
/// başlangıç ve bitiş, hedef arılık, kovan sayısı, durum ve rotadaki sıra;
/// düzenlemede "Durağı sil". Kaydedince zaman çizelgesine dönülür.
class MigrationStopFormScreen extends ConsumerWidget {
  const new({required this.migrationId, super.key, this.stopId});

  final String migrationId;
  final String? stopId;

  MigrationStopFormControllerProvider get _provider =>
      migrationStopFormControllerProvider(migrationId, stopId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      stopId == null ? l10n.stopFormNewTitle : l10n.stopFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _StopFormFields(this, form),
              if (stopId case final id?) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.stopFormDelete,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => _delete(context, ref, id),
                ),
              ],
            ],
          ),
          action: BigButton(
            label: l10n.migrationFormSave,
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.migrationNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.migrationsLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    showMessageSnackBar(context, l10n.stopSaved);
    context.pop();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.stopDeleteTitle,
      message: l10n.stopDeleteMessage,
      confirmLabel: l10n.migrationDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(migrationActionsProvider.notifier).deleteStop(id);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.stopDeleted);
    context.pop();
  }
}

class _StopFormFields extends ConsumerStatefulWidget {
  const new(this.screen, this.form);

  final MigrationStopFormScreen screen;
  final MigrationStopFormState form;

  @override
  ConsumerState<_StopFormFields> createState() => _StopFormFieldsState();
}

class _StopFormFieldsState extends ConsumerState<_StopFormFields> {
  late final _name = TextEditingController(text: widget.form.name);
  late final _place = TextEditingController(text: widget.form.place);
  late final _hiveCount = TextEditingController(
    text: widget.form.hiveCount?.toString() ?? '',
  );

  @override
  void dispose() {
    _name.dispose();
    _place.dispose();
    _hiveCount.dispose();
    super.dispose();
  }

  MigrationStopFormController get _controller =>
      ref.read(widget.screen._provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final form = widget.form;
    final apiaries = ref.watch(apiaryListProvider).value ?? const [];
    final apiaryName = [
      for (final summary in apiaries)
        if (summary.apiary.id == form.apiaryId) summary.apiary.name,
    ].firstOrNull;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.stopFormName,
          child: TextField(
            controller: _name,
            autofocus: widget.screen.stopId == null,
            maxLength: maxMigrationNameLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: l10n.stopFormNameHint,
              counterText: '',
            ),
            onChanged: _controller.setName,
          ),
        ),
        SizedBox(height: spacing.lg),
        LabeledField(
          label: l10n.stopFormPlace,
          child: TextField(
            controller: _place,
            maxLength: maxStopPlaceLength,
            textCapitalization: TextCapitalization.words,
            decoration: InputDecoration(
              hintText: l10n.stopFormPlaceHint,
              counterText: '',
            ),
            onChanged: _controller.setPlace,
          ),
        ),
        SizedBox(height: spacing.xl),
        ListGroup(
          children: [
            ListRow(
              title: l10n.stopFormStart,
              value: format.date(form.plannedStartOn),
              onTap: () =>
                  _pickDay(context, form.plannedStartOn, _controller.setStart),
            ),
            ListRow(
              title: l10n.stopFormEnd,
              value: format.date(form.plannedEndOn),
              onTap: () =>
                  _pickDay(context, form.plannedEndOn, _controller.setEnd),
            ),
            ListRow(
              title: l10n.stopFormApiary,
              value: apiaryName ?? l10n.stopFormNone,
              onTap: () => _pickApiary(context, apiaries),
            ),
          ],
        ),
        SizedBox(height: spacing.xl),
        InlineField(
          label: l10n.stopFormHiveCount,
          field: TextField(
            controller: _hiveCount,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter('$maxStopHiveCount'.length),
            ],
            textAlign: TextAlign.center,
            style: context.typography.number,
            onChanged: (text) => _controller.setHiveCount(switch (int.tryParse(
              text,
            )) {
              final count? when count > 0 => count.clamp(1, maxStopHiveCount),
              _ => null,
            }),
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.stopFormStatus,
          child: ChoiceChipGroup<MigrationStopStatus>(
            options: [
              for (final status in MigrationStopStatus.values)
                ChoiceChipOption(
                  value: status,
                  label: stopStatusLabel(l10n, status),
                ),
            ],
            selected: {form.status},
            onChanged: (selected) {
              if (selected.firstOrNull case final status?) {
                _controller.setStatus(status);
              }
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        BigStepper(
          label: l10n.stopFormPosition,
          value: form.position,
          min: 1,
          max: maxStopPosition,
          onChanged: _controller.setPosition,
        ),
      ],
    );
  }

  Future<void> _pickDay(
    BuildContext context,
    DateTime initial,
    ValueChanged<DateTime> onPicked,
  ) async {
    final day = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(initial.year - _pickerYears),
      lastDate: DateTime(initial.year + _pickerYears, 12, 31),
    );
    if (day != null) onPicked(day);
  }

  /// Hedef arılığı seçer.
  Future<void> _pickApiary(
    BuildContext context,
    List<ApiarySummary> apiaries,
  ) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showOptionSheet<String>(
      context,
      (context) => OptionSheet<String>(
        title: l10n.stopFormChooseApiary,
        options: [
          SheetOption(
            value: '',
            icon: Icons.block_rounded,
            label: l10n.stopFormNone,
            selected: widget.form.apiaryId == null,
          ),
          for (final summary in apiaries)
            SheetOption(
              value: summary.apiary.id,
              icon: Icons.place_outlined,
              label: summary.apiary.name,
              selected: widget.form.apiaryId == summary.apiary.id,
            ),
        ],
      ),
    );
    if (picked == null) return;
    final apiaryId = picked.isEmpty ? null : picked;
    _controller.setApiary(apiaryId);
    // Arılık seçilince kovan sayısı arılığın aktif kovanlarıyla dolar;
    // elle değiştirilebilir. Arılık kaldırılınca girilen sayı kalır.
    final summary = apiaries.where((s) => s.apiary.id == apiaryId).firstOrNull;
    if (summary != null && summary.activeHiveCount > 0) {
      _controller.setHiveCount(summary.activeHiveCount);
      _hiveCount.text = '${summary.activeHiveCount}';
    }
  }
}

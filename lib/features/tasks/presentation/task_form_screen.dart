import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/tasks/domain/task_rules.dart';
import 'package:mobil_arici/features/tasks/presentation/task_form_controller.dart';
import 'package:mobil_arici/features/tasks/presentation/task_providers.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/reminder_access_prompt.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/task_labels.dart';

/// Son tarihin seçilebileceği en uzak gün: bugünden bu kadar sonra.
const _maxDueDays = 366;

/// Görev ekleme ([taskId] null) ve düzenleme: başlık, son tarih (Bugün /
/// Yarın / Başka gün ve saat), arılık ve kovan, planlı ilaçlama (ilaç ve
/// kovan başı doz; alışveriş listesine ihtiyaç olarak girer), atanan kişi;
/// düzenlemede
/// Tamamlandı ve Görevi sil. Otomatik görevin başlığı, arılığı ve kovanı
/// kaynaktan gelir, değiştirilemez. Kaydedince hatırlatıcı izinleri
/// istenir ve listeye dönülür.
class TaskFormScreen extends ConsumerWidget {
  const new({super.key, this.taskId});

  final String? taskId;

  TaskFormControllerProvider get _provider =>
      taskFormControllerProvider(taskId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      taskId == null ? l10n.taskFormNewTitle : l10n.taskFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _TaskFormFields(this, form),
              if (taskId case final id?) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.taskFormDelete,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => _delete(context, ref, id),
                ),
              ],
            ],
          ),
          action: BigButton(
            label: l10n.taskFormSave,
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.taskNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.tasksLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    final mine = isMine(saved, ref.read(currentUserIdProvider));
    final reminds =
        saved.completedAt == null &&
        mine &&
        saved.dueAt.isAfter(clock.now().toUtc());
    final permitted = !reminds || await requestReminderAccess(context, ref);
    if (!context.mounted) return;
    showMessageSnackBar(
      context,
      permitted ? l10n.taskSaved : l10n.taskReminderDenied,
    );
    context.pop();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.taskDeleteTitle,
      message: l10n.taskDeleteMessage,
      confirmLabel: l10n.taskDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(taskActionsProvider.notifier).delete(id);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.taskDeleted);
    context.pop();
  }
}

/// Son tarih seçimi.
enum _DueChoice { today, tomorrow, other }

class _TaskFormFields extends ConsumerStatefulWidget {
  const new(this.screen, this.form);

  final TaskFormScreen screen;
  final TaskFormState form;

  @override
  ConsumerState<_TaskFormFields> createState() => _TaskFormFieldsState();
}

class _TaskFormFieldsState extends ConsumerState<_TaskFormFields> {
  late final _title = TextEditingController(text: widget.form.title);

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  TaskFormController get _controller =>
      ref.read(widget.screen._provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final form = widget.form;
    final apiaries = ref.watch(apiaryListProvider).value ?? const [];
    final apiaryId = form.apiaryId;
    final hives = apiaryId == null
        ? null
        : ref.watch(apiaryHivesProvider(apiaryId)).value;
    final apiaryName = [
      for (final summary in apiaries)
        if (summary.apiary.id == apiaryId) summary.apiary.name,
    ].firstOrNull;
    final hiveNumber = [
      for (final hive in hives ?? const <Hive>[])
        if (hive.id == form.hiveId) hive.number,
    ].firstOrNull;
    final catalog =
        ref
            .watch(
              drugCatalogOfProvider(
                Localizations.localeOf(context).languageCode,
              ),
            )
            .value ??
        const <DrugChoice>[];
    final drug = [
      for (final choice in catalog)
        if (form.hasDrug &&
            choice.refDrugId == form.refDrugId &&
            choice.drugId == form.drugId)
          choice,
    ].firstOrNull;
    final treatedHives = form.hiveId != null
        ? 1
        : (hives ?? const <Hive>[]).where(canInspect).length;
    final members = ref.watch(organizationMembersProvider).value ?? const [];
    final userId = ref.watch(currentUserIdProvider);
    final assignees = taskAssignees(l10n, members, userId: userId);

    final today = localDay(clock.now());
    final dueDay = localDay(form.dueAt);
    final dueChoice = switch (dueDay.difference(today).inHours) {
      0 => _DueChoice.today,
      // Yaz saati geçişinde gün 23 ya da 25 saat sürer.
      >= 23 && <= 25 => _DueChoice.tomorrow,
      _ => _DueChoice.other,
    };

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (form.isManual)
          LabeledField(
            label: l10n.taskFormName,
            child: TextField(
              controller: _title,
              autofocus: widget.screen.taskId == null,
              maxLength: maxTaskTitleLength,
              textCapitalization: TextCapitalization.sentences,
              style: context.typography.subtitle.copyWith(
                fontWeight: context.typography.body.fontWeight,
              ),
              decoration: InputDecoration(
                hintText: l10n.taskFormNameHint,
                counterText: '',
              ),
              onChanged: _controller.setTitle,
            ),
          )
        else
          Text(
            autoTaskTitle(
              l10n,
              form.source,
              hiveNumber: hiveNumber,
              step: form.sourceStep,
            ),
            style: context.typography.title,
          ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.taskFormDue,
          child: ChoiceChipGroup<_DueChoice>(
            options: [
              ChoiceChipOption(value: _DueChoice.today, label: l10n.tasksToday),
              ChoiceChipOption(
                value: _DueChoice.tomorrow,
                label: l10n.tasksTomorrow,
              ),
              ChoiceChipOption(
                value: _DueChoice.other,
                label: dueChoice == _DueChoice.other
                    ? format.date(form.dueAt)
                    : l10n.taskFormPickDate,
              ),
            ],
            selected: {dueChoice},
            onChanged: (selected) => _pickDue(
              context,
              selected.firstOrNull ?? _DueChoice.other,
              today,
            ),
          ),
        ),
        SizedBox(height: spacing.md),
        ListGroup(
          children: [
            ListRow(
              title: l10n.taskFormTime,
              value: format.time(form.dueAt),
              onTap: () => _pickTime(context),
            ),
          ],
        ),
        SizedBox(height: spacing.xl),
        ListGroup(
          children: [
            ListRow(
              title: l10n.taskFormApiary,
              value: apiaryName ?? l10n.taskFormNone,
              onTap: form.isManual
                  ? () => _pickApiary(context, [
                      for (final s in apiaries) (s.apiary.id, s.apiary.name),
                    ])
                  : null,
            ),
            ListRow(
              title: l10n.taskFormHive,
              value: hiveNumber == null
                  ? l10n.taskFormNone
                  : l10n.hiveLabel(hiveNumber),
              onTap: form.isManual && hives != null
                  ? () => _pickHive(context, [
                      for (final hive in hives) (hive.id, hive.number),
                    ])
                  : null,
            ),
          ],
        ),
        if (form.isManual) ...[
          SizedBox(height: spacing.xl),
          ListGroup(
            children: [
              ListRow(
                title: l10n.taskFormTreatment,
                value: switch ((form.hasDrug, drug)) {
                  (_, final drug?) => drug.name,
                  (true, null) => l10n.taskFormTreatmentUnknown,
                  (false, _) => l10n.taskFormNone,
                },
                onTap: () => _pickDrug(context),
              ),
            ],
          ),
          if (drug != null) ...[
            SizedBox(height: spacing.lg),
            BigStepper(
              label: l10n.treatmentDose(drug.doseUnit.label(l10n)),
              value: form.dose,
              min: 1,
              max: maxTreatmentDose,
              onChanged: _controller.setDose,
            ),
            SizedBox(height: spacing.xs),
            Text(
              apiaryId == null
                  ? l10n.taskFormTreatmentNeedsApiary
                  : l10n.treatmentDoseTotal(
                      format.number(form.dose * treatedHives),
                      drug.doseUnit.label(l10n),
                    ),
              style: context.typography.bodySmall.copyWith(
                color: apiaryId == null
                    ? context.colors.statusWarning
                    : context.colors.textSecondary,
              ),
            ),
          ],
        ],
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.taskFormAssignee,
          child: ChoiceChipGroup<String?>(
            options: [
              ChoiceChipOption(value: null, label: l10n.taskFormUnassigned),
              for (final assignee in assignees)
                ChoiceChipOption(value: assignee.userId, label: assignee.label),
            ],
            selected: {form.assignedTo},
            onChanged: (selected) =>
                _controller.setAssignee(selected.firstOrNull),
          ),
        ),
        if (widget.screen.taskId != null) ...[
          SizedBox(height: spacing.xl),
          ListGroup(
            children: [
              SwitchListTile(
                value: form.completed,
                onChanged: (completed) =>
                    _controller.setCompleted(completed: completed),
                contentPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
                title: Text(
                  l10n.taskFormCompleted,
                  style: context.typography.body,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Future<void> _pickDue(
    BuildContext context,
    _DueChoice choice,
    DateTime today,
  ) async {
    switch (choice) {
      case _DueChoice.today:
        _controller.setDueDay(today);
      case _DueChoice.tomorrow:
        _controller.setDueDay(DateTime(today.year, today.month, today.day + 1));
      case _DueChoice.other:
        final initial = localDay(widget.form.dueAt);
        final first = initial.isBefore(today) ? initial : today;
        final day = await showDatePicker(
          context: context,
          initialDate: initial,
          firstDate: first,
          lastDate: DateTime(today.year, today.month, today.day + _maxDueDays),
        );
        if (day != null) _controller.setDueDay(day);
    }
  }

  Future<void> _pickTime(BuildContext context) async {
    final due = widget.form.dueAt;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(hour: due.hour, minute: due.minute),
    );
    if (time != null) {
      _controller.setDueTime(hour: time.hour, minute: time.minute);
    }
  }

  Future<void> _pickApiary(
    BuildContext context,
    List<(String, String)> apiaries,
  ) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showOptionSheet<String>(
      context,
      (context) => OptionSheet<String>(
        title: l10n.taskFormChooseApiary,
        options: [
          SheetOption(
            value: '',
            icon: Icons.block_rounded,
            label: l10n.taskFormNone,
            selected: widget.form.apiaryId == null,
          ),
          for (final (id, name) in apiaries)
            SheetOption(
              value: id,
              icon: Icons.place_outlined,
              label: name,
              selected: widget.form.apiaryId == id,
            ),
        ],
      ),
    );
    if (picked != null) _controller.setApiary(picked.isEmpty ? null : picked);
  }

  /// İlaç listesi ve "Yok". İlaç seçilince başlık boşsa "İlaçlama · ilaç"
  /// yazılır.
  Future<void> _pickDrug(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    final form = widget.form;
    // Liste ilk açılışta yükleniyor olabilir; boş sayfa açılmasın.
    final catalog = await ref.read(
      drugCatalogOfProvider(Localizations.localeOf(context).languageCode)
          .future,
    );
    if (!context.mounted) return;
    final picked = await showOptionSheet<int>(
      context,
      (context) => OptionSheet<int>(
        title: l10n.treatmentChooseDrug,
        options: [
          SheetOption(
            value: -1,
            icon: Icons.block_rounded,
            label: l10n.taskFormNone,
            selected: !form.hasDrug,
          ),
          for (final (index, drug) in catalog.indexed)
            SheetOption(
              value: index,
              icon: Icons.medication_outlined,
              label: drug.name,
              hint: drug.activeIngredient.label(l10n),
              selected:
                  form.hasDrug &&
                  drug.refDrugId == form.refDrugId &&
                  drug.drugId == form.drugId,
            ),
        ],
      ),
    );
    if (picked == null) return;
    final drug = picked < 0 ? null : catalog[picked];
    _controller.selectDrug(drug);
    if (drug != null && _title.text.trim().isEmpty) {
      _title.text = l10n.taskTreatmentPlanTitle(drug.name);
      _controller.setTitle(_title.text);
    }
  }

  Future<void> _pickHive(
    BuildContext context,
    List<(String, String)> hives,
  ) async {
    final l10n = AppLocalizations.of(context);
    final picked = await showOptionSheet<String>(
      context,
      (context) => OptionSheet<String>(
        title: l10n.taskFormChooseHive,
        options: [
          SheetOption(
            value: '',
            icon: Icons.block_rounded,
            label: l10n.taskFormNone,
            selected: widget.form.hiveId == null,
          ),
          for (final (id, number) in hives)
            SheetOption(
              value: id,
              icon: Icons.hive_outlined,
              label: l10n.hiveLabel(number),
              selected: widget.form.hiveId == id,
            ),
        ],
      ),
    );
    if (picked != null) _controller.setHive(picked.isEmpty ? null : picked);
  }
}

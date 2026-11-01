import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/health/domain/drug.dart';
import 'package:mobil_arici/features/health/domain/drug_info.dart';
import 'package:mobil_arici/features/health/domain/treatment_rules.dart';
import 'package:mobil_arici/features/health/domain/withdrawal_rules.dart';
import 'package:mobil_arici/features/health/presentation/treatment_form_controller.dart';
import 'package:mobil_arici/features/health/presentation/treatment_providers.dart';
import 'package:mobil_arici/features/health/presentation/widgets/drug_info_sheet.dart';
import 'package:mobil_arici/features/health/presentation/widgets/treatment_labels.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/inspections/domain/inspection_rules.dart';
import 'package:mobil_arici/features/inventory/domain/inventory.dart';
import 'package:mobil_arici/features/inventory/domain/stock_usage_rules.dart';
import 'package:mobil_arici/features/inventory/presentation/inventory_providers.dart';
import 'package:mobil_arici/features/inventory/presentation/widgets/stock_use_field.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/presentation/media_controllers.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_action_row.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/reminder_access_prompt.dart';

/// Başlangıç tarihinin seçilebileceği en eski gün: bugünden bu kadar önce
/// (unutulan kaydın sonradan girilmesi).
const _maxBackdateDays = 60;

/// İlaç uygulaması (docs/design "İlaç kaydı"): kovan ya da arılığın tümü;
/// ilaç kartı (dokununca liste, sonda "Yeni ilaç ekle"); parti no ve
/// başlangıç; kovan başına doz ve toplamı; bekleme süresi; çıkarma ve "bal
/// katı yok" karoları; aynı etken madde uyarısı; reçete / fatura
/// fotoğrafı; düşülecek stok kalemi (varsayılan ilacın son kullanılanı).
/// Kaydedince çıkarma gününün sabahına çıkarma görevi açılır (bildirimi
/// görevle kurulur), toplam doz kalemden düşülür, karta dönülür ve 6 sn
/// geri alınabilir; Geri al stok çıkışını da siler.
class TreatmentFormScreen extends ConsumerWidget {
  const new({required this.apiaryId, required this.hiveId, super.key});

  /// Yoldaki arılık; yeni ilaç rotası buna bağlı.
  final String apiaryId;
  final String hiveId;

  TreatmentFormControllerProvider get _provider =>
      treatmentFormControllerProvider(hiveId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    // İlaç listesi ekran açıkken hazır kalsın; seçim sayfası beklemeden
    // açılır.
    ref
      ..watch(
        drugCatalogOfProvider(Localizations.localeOf(context).languageCode),
      )
      ..watch(drugInfosProvider);

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => _form(context, ref, form),
      AsyncData() => Scaffold(appBar: AppBar(), body: const HiveNotFound()),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }

  Widget _form(BuildContext context, WidgetRef ref, TreatmentFormState form) {
    final l10n = AppLocalizations.of(context);
    // Kalem ekran çizilirken hesaplanır; Kaydet onu yazar.
    final stockItem = _stock(ref, form)?.item;
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.treatmentFormTitle),
      ),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(context.spacing.lg),
          children: [_TreatmentFormFields(this, form)],
        ),
        action: BigButton(
          label: l10n.treatmentSave(_targetCount(ref, form)),
          onPressed: form.canSave
              ? () => _save(context, ref, form, stockItem)
              : null,
        ),
      ),
    );
  }

  /// Kalemden düşülecek miktar: kovan başı doz × kovan, kalemin biriminde
  /// ([treatmentStockUsage]). İlaç seçilmemişse hiçbir kalem uymaz.
  static StockUsage _usage(WidgetRef ref, TreatmentFormState form) {
    final drug = form.drug;
    final total = (form.dose * _targetCount(ref, form)).toDouble();
    return (unit) =>
        drug == null ? null : treatmentStockUsage(drug.doseUnit, total, unit);
  }

  /// Düşülecek kalem; ilaç seçilmemişse yok.
  static InventoryStock? _stock(WidgetRef ref, TreatmentFormState form) {
    final drug = form.drug;
    if (drug == null) return null;
    final drugKey = drug.refDrugId ?? drug.drugId;
    return watchStockUse(
      ref,
      choice: form.stock,
      defaultItemId: ref.watch(lastTreatmentStockItemsProvider).value?[drugKey],
      usage: _usage(ref, form),
    );
  }

  /// Arılıktaki aktif kovan sayısı; liste gelene kadar en az bu kovan.
  static int _activeInApiary(WidgetRef ref, TreatmentFormState form) {
    final hives = ref.watch(apiaryHivesProvider(form.hive.apiaryId)).value;
    if (hives == null) return 1;
    return hives.where(canInspect).length;
  }

  /// Kaydedilecek kovan sayısı.
  static int _targetCount(WidgetRef ref, TreatmentFormState form) =>
      switch (form.scope) {
        TreatmentScope.hive => 1,
        TreatmentScope.apiary => _activeInApiary(ref, form),
      };

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    TreatmentFormState form,
    InventoryItem? stockItem,
  ) async {
    final l10n = AppLocalizations.of(context);
    final actions = ref.read(treatmentActionsProvider.notifier);
    final treatments = await ref
        .read(_provider.notifier)
        .save(stockItem: stockItem);
    // Kovan bu arada silindiyse ekran bunu gösterir.
    if (treatments == null || treatments.isEmpty || !context.mounted) return;
    // Çıkarma görevi açıldıysa hatırlatıcı izinleri istenir.
    final reminder = form.removalOn == null
        ? null
        : await requestReminderAccess(context, ref);
    if (!context.mounted) return;
    showUndoSnackBar(
      context,
      message: form.scope == TreatmentScope.hive
          ? l10n.treatmentSaved(form.hive.number)
          : l10n.treatmentSavedMany(treatments.length),
      details: reminder == false ? Text(l10n.treatmentReminderDenied) : null,
      onUndo: () =>
          actions.undoAdd(treatments, prescription: form.prescription),
    );
    context.pop();
  }

  /// İlaç listesi; "Yeni ilaç ekle" ilaç formunu açar, eklenen ilaç
  /// seçilir.
  Future<void> _pickDrug(
    BuildContext context,
    WidgetRef ref,
    TreatmentFormState form,
  ) async {
    final l10n = AppLocalizations.of(context);
    final languageCode = Localizations.localeOf(context).languageCode;
    final catalog = await ref.read(drugCatalogOfProvider(languageCode).future);
    // Ürün bilgisi beklenmez; yüklenmemişse bilgi butonları görünmez.
    final infos = ref.read(drugInfosProvider).value ?? const {};
    if (!context.mounted) return;
    final picked = await showOptionSheet<Object>(
      context,
      (context) => OptionSheet<Object>(
        title: l10n.treatmentChooseDrug,
        options: [
          for (final drug in catalog)
            SheetOption(
              value: drug,
              icon: Icons.medication_outlined,
              label: drug.name,
              hint: drugChoiceHint(l10n, drug),
              selected: drug == form.drug,
              action: switch (infos[drug.refDrugId]) {
                final info? when drugInfoHasDetails(info) => SheetOptionAction(
                  icon: Icons.info_outline_rounded,
                  label: l10n.drugInfoOpen,
                  onPressed: () => showDrugInfoSheet(context, info),
                ),
                _ => null,
              },
            ),
          SheetOption(
            value: const _NewDrug(),
            icon: Icons.add_rounded,
            label: l10n.treatmentAddDrug,
          ),
        ],
      ),
    );
    if (!context.mounted) return;
    final controller = ref.read(_provider.notifier);
    switch (picked) {
      case final DrugChoice drug:
        controller.selectDrug(drug);
      case _NewDrug():
        final added = await context.push<DrugChoice>(
          AppRoutes.hiveTreatDrugNew(apiaryId, hiveId),
        );
        if (added != null) controller.selectDrug(added);
    }
  }
}

/// Listede "Yeni ilaç ekle" seçeneği.
class _NewDrug {
  const new();
}

class _TreatmentFormFields extends ConsumerStatefulWidget {
  const new(this.screen, this.form);

  final TreatmentFormScreen screen;
  final TreatmentFormState form;

  @override
  ConsumerState<_TreatmentFormFields> createState() =>
      _TreatmentFormFieldsState();
}

class _TreatmentFormFieldsState extends ConsumerState<_TreatmentFormFields> {
  late final _batchNo = TextEditingController(text: widget.form.batchNo);

  @override
  void dispose() {
    _batchNo.dispose();
    super.dispose();
  }

  TreatmentFormController get _controller =>
      ref.read(widget.screen._provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final form = widget.form;
    final drug = form.drug;
    final unit = drug?.doseUnit.label(l10n);
    final count = TreatmentFormScreen._targetCount(ref, form);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SegmentedTabs<TreatmentScope>(
          options: [
            SegmentOption(
              value: TreatmentScope.hive,
              label: l10n.treatmentScopeHive(form.hive.number),
            ),
            SegmentOption(
              value: TreatmentScope.apiary,
              label: l10n.treatmentScopeApiary(
                TreatmentFormScreen._activeInApiary(ref, form),
              ),
            ),
          ],
          selected: form.scope,
          onChanged: _controller.setScope,
        ),
        SizedBox(height: spacing.lg),
        if (drug == null)
          BigButton(
            variant: BigButtonVariant.secondary,
            label: l10n.treatmentChooseDrug,
            icon: Icons.medication_outlined,
            onPressed: () => widget.screen._pickDrug(context, ref, widget.form),
          )
        else
          _DrugCard(
            drug: drug,
            onTap: () => widget.screen._pickDrug(context, ref, widget.form),
          ),
        SizedBox(height: spacing.lg),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: LabeledField(
                label: l10n.treatmentBatchNo,
                child: TextField(
                  controller: _batchNo,
                  textInputAction: TextInputAction.done,
                  onChanged: _controller.setBatchNo,
                ),
              ),
            ),
            SizedBox(width: context.touchTargets.gap),
            Expanded(
              child: LabeledField(
                label: l10n.treatmentStartedOn,
                child: _DateField(
                  text: format.date(form.startedOn),
                  onTap: () => _pickStart(context),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: spacing.lg),
        if (unit != null) ...[
          BigStepper(
            label: l10n.treatmentDose(unit),
            value: form.dose,
            min: 1,
            max: maxTreatmentDose,
            onChanged: _controller.setDose,
          ),
          if (count > 1) ...[
            SizedBox(height: spacing.xs),
            Text(
              l10n.treatmentDoseTotal(format.number(form.dose * count), unit),
              style: context.typography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
          ],
          StockUseField(
            selected: TreatmentFormScreen._stock(ref, form),
            usage: TreatmentFormScreen._usage(ref, form),
            onChanged: _controller.selectStockItem,
          ),
        ],
        SizedBox(height: context.touchTargets.gap),
        BigStepper(
          label: l10n.treatmentWithdrawalDays,
          value: form.withdrawalDays,
          max: maxWithdrawalDays,
          onChanged: _controller.setWithdrawalDays,
        ),
        SizedBox(height: spacing.lg),
        // Uzun yazıda iki karo aynı boyda kalsın.
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: SummaryTile(
                  label: l10n.treatmentRemoval,
                  status: AppStatus.info,
                  value: switch (form.removalOn) {
                    final day? => format.date(day),
                    null => l10n.treatmentRemovalNone,
                  },
                  detail: form.removalOn == null
                      ? l10n.treatmentRemovalSingle
                      : l10n.treatmentRemovalChange,
                  onTap: () => _pickRemoval(context),
                ),
              ),
              SizedBox(width: context.touchTargets.gap),
              Expanded(
                child: SummaryTile(
                  label: l10n.treatmentNoSuper,
                  status: AppStatus.critical,
                  value: l10n.treatmentNoSuperUntil(
                    format.date(form.withdrawalEnd),
                  ),
                  detail: form.removalOn == null
                      ? l10n.treatmentNoSuperAfterStart(form.withdrawalDays)
                      : l10n.treatmentNoSuperAfterRemoval(form.withdrawalDays),
                ),
              ),
            ],
          ),
        ),
        if (form.removalOn != null)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => _controller.setRemovalOn(null),
              child: Text(l10n.treatmentRemovalClear),
            ),
          ),
        if (drug != null) _RotationWarning(form: form, drug: drug),
        SizedBox(height: spacing.lg),
        _Prescription(
          capture: form.prescription,
          onTake: () => _takePrescription(context),
          onRemove: () => _controller.setPrescription(null),
        ),
      ],
    );
  }

  Future<void> _takePrescription(BuildContext context) async {
    try {
      final capture = await ref.read(mediaActionsProvider.notifier).takePhoto();
      if (capture != null) _controller.setPrescription(capture);
    } on MediaCaptureException catch (error) {
      if (context.mounted) {
        showMediaCaptureFailure(context, error.failure, MediaKind.photo);
      }
    }
  }

  Future<void> _pickStart(BuildContext context) async {
    final today = DateTime.now();
    final day = await showDatePicker(
      context: context,
      initialDate: widget.form.startedOn,
      firstDate: DateTime(
        today.year,
        today.month,
        today.day - _maxBackdateDays,
      ),
      lastDate: today,
    );
    if (day != null) _controller.setStartedOn(day);
  }

  Future<void> _pickRemoval(BuildContext context) async {
    final form = widget.form;
    final first = form.firstRemovalDay;
    final initial = form.removalOn ?? first;
    final day = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: DateTime(first.year + 1, first.month, first.day),
    );
    if (day != null) _controller.setRemovalOn(day);
  }
}

/// Seçili ilaç: ikon, ad, etken madde (ve ruhsat); sağda "Değiştir".
class _DrugCard extends StatelessWidget {
  const new({required this.drug, required this.onTap});

  final DrugChoice drug;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;

    return MergeSemantics(
      child: AppCard(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Row(
            children: [
              Icon(
                Icons.medication_outlined,
                size: context.sizes.icon,
                color: colors.statusCritical,
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(drug.name, style: context.typography.subtitle),
                    Text(
                      drugChoiceHint(l10n, drug),
                      style: context.typography.bodySmall.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: spacing.sm),
              Text(
                l10n.treatmentChangeDrug,
                style: context.typography.button.copyWith(
                  color: colors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Metin alanı görünümünde tarih; dokununca takvim açılır.
class _DateField extends StatelessWidget {
  const new({required this.text, required this.onTap});

  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(context.radii.button),
        child: InputDecorator(
          decoration: const InputDecoration(),
          child: Text(text, style: context.typography.body),
        ),
      ),
    );
  }
}

/// Aynı etken madde arılıkta üst üste kullanıldıysa direnç uyarısı
/// (ozellikler.md "İlaç rotasyonu önerisi"); uyarı zemininde, ikon ve
/// kalın başlıkla.
class _RotationWarning extends ConsumerWidget {
  const new({required this.form, required this.drug});

  final TreatmentFormState form;
  final DrugChoice drug;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final treatments =
        ref.watch(apiaryTreatmentsProvider(form.hive.apiaryId)).value ??
        const [];
    final streak = sameIngredientStreak(treatments, drug.activeIngredient);
    if (!needsRotationWarning(streak)) return const SizedBox.shrink();
    final body = context.typography.body;

    return Padding(
      padding: EdgeInsets.only(top: spacing.lg),
      child: MergeSemantics(
        child: AppCard(
          status: AppStatus.warning,
          child: Padding(
            padding: EdgeInsets.all(spacing.lg),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.warning_amber_rounded,
                  size: context.sizes.icon,
                  color: colors.statusWarning,
                ),
                SizedBox(width: spacing.md),
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: l10n.treatmentRotationTitle,
                          style: body.copyWith(
                            color: colors.statusWarning,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const TextSpan(text: ' '),
                        TextSpan(
                          text: l10n.treatmentRotationMessage(
                            streak,
                            drug.activeIngredient.label(l10n),
                          ),
                        ),
                      ],
                    ),
                    style: body.copyWith(color: colors.textPrimary),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Reçete / fatura fotoğrafı: yoksa ekleme butonu; varsa onay ikonu,
/// "eklendi" ve Kaldır.
class _Prescription extends StatelessWidget {
  const new({
    required this.capture,
    required this.onTake,
    required this.onRemove,
  });

  final MediaCapture? capture;
  final VoidCallback onTake;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (capture == null) {
      return BigButton(
        variant: BigButtonVariant.secondary,
        label: l10n.treatmentPrescriptionAdd,
        icon: Icons.receipt_long_outlined,
        onPressed: onTake,
      );
    }
    return Row(
      children: [
        Icon(
          Icons.check_circle_rounded,
          size: context.sizes.icon,
          color: context.colors.statusGood,
        ),
        SizedBox(width: context.spacing.sm),
        Expanded(
          child: Text(
            l10n.treatmentPrescriptionAdded,
            style: context.typography.body,
          ),
        ),
        TextButton(
          onPressed: onRemove,
          child: Text(l10n.treatmentPrescriptionRemove),
        ),
      ],
    );
  }
}

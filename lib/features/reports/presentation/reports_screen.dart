import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/app_language.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/core/services/print_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/core/utils/natural_order.dart';
import 'package:mobil_arici/features/apiaries/domain/apiary_summary.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/organization/presentation/organization_providers.dart';
import 'package:mobil_arici/features/reports/domain/report.dart';
import 'package:mobil_arici/features/reports/domain/report_rules.dart';
import 'package:mobil_arici/features/reports/presentation/pdf/report_pdf.dart';
import 'package:mobil_arici/features/reports/presentation/report_form_controller.dart';
import 'package:mobil_arici/features/reports/presentation/report_providers.dart';

enum _Output { print, share }

/// PDF raporları (docs/design "PDF raporlar"): ilaç kayıt defteri ve kovan
/// geçmişi. Dönem, arılık (geçmişte kovan da) ve PDF'in dili seçilir;
/// başlığa TR profilinde işletme tescil ve AKS no, diğerlerinde serbest
/// kayıt numarası basılır. Numaralar işletmeden dolu gelir, yalnız bu
/// PDF için değiştirilir. PDF cihazda üretilir; "PDF oluştur" yazdırma
/// ekranını (orada PDF olarak kaydet de var), Paylaş paylaşma sayfasını
/// açar.
class ReportsScreen extends ConsumerStatefulWidget {
  const new({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  final _registrationNo = TextEditingController();
  final _aksNo = TextEditingController();
  final _recordNo = TextEditingController();

  /// PDF hazırlanırken butonlar pasif.
  var _busy = false;

  @override
  void initState() {
    super.initState();
    // İşletmenin numaraları ilk geldiğinde alanlar dolar; kullanıcının
    // yazdığı ezilmez.
    ref.listenManual(organizationRegistrationProvider, (_, next) {
      if (next.value case final registration?) {
        _fill(_registrationNo, registration.registrationNo);
        _fill(_aksNo, registration.aksNo);
      }
    }, fireImmediately: true);
  }

  static void _fill(TextEditingController controller, String? value) {
    if (controller.text.isEmpty && value != null) controller.text = value;
  }

  @override
  void dispose() {
    _registrationNo.dispose();
    _aksNo.dispose();
    _recordNo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final form = ref.watch(reportFormControllerProvider);
    final controller = ref.read(reportFormControllerProvider.notifier);
    final aks = ref.watch(regionConfigProvider).features.aks;
    final data = ref.watch(
      reportDataProvider(
        kind: form.kind,
        from: form.from,
        to: form.to,
        apiaryId: form.apiaryId,
        hiveId: form.kind == ReportKind.hiveHistory ? form.hiveId : null,
      ),
    );
    final language = form.language ?? _appLanguage(context);
    final pdfL10n = lookupAppLocalizations(language.locale!);
    final ready = data.value != null && !_busy;
    final sectionGap = SizedBox(height: spacing.xl);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.reportsTitle)),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            RadioCardGroup<ReportKind>(
              options: [
                RadioCardOption(
                  value: ReportKind.treatmentRegister,
                  label: l10n.reportTreatmentRegister,
                  hint: l10n.reportTreatmentRegisterHint,
                ),
                RadioCardOption(
                  value: ReportKind.hiveHistory,
                  label: l10n.reportHiveHistory,
                  hint: l10n.reportHiveHistoryHint,
                ),
              ],
              selected: form.kind,
              onChanged: controller.setKind,
            ),
            sectionGap,
            _Period(form: form, controller: controller),
            sectionGap,
            _Scope(form: form, controller: controller),
            sectionGap,
            LabeledField(
              label: l10n.reportLanguage,
              group: true,
              child: ChoiceChipGroup<AppLanguage>(
                columns: 2,
                options: [
                  ChoiceChipOption(
                    value: AppLanguage.turkish,
                    label: l10n.reportLanguageTurkish,
                  ),
                  ChoiceChipOption(
                    value: AppLanguage.english,
                    label: l10n.reportLanguageEnglish,
                  ),
                ],
                selected: {language},
                onChanged: (selected) {
                  // Her zaman bir dil seçili; seçili chip'e yeniden dokunmak
                  // seçimi kaldırmasın.
                  if (selected.isEmpty) return;
                  controller.setLanguage(selected.single);
                },
              ),
            ),
            sectionGap,
            if (aks) ...[
              LabeledField(
                label: l10n.reportRegistrationNo,
                child: TextField(
                  controller: _registrationNo,
                  textInputAction: TextInputAction.next,
                ),
              ),
              SizedBox(height: spacing.lg),
              LabeledField(
                label: l10n.reportAksNo,
                helper: l10n.reportNumbersHelper,
                child: TextField(
                  controller: _aksNo,
                  textInputAction: TextInputAction.done,
                ),
              ),
            ] else
              LabeledField(
                label: l10n.reportRecordNo,
                helper: l10n.reportNumbersHelper,
                child: TextField(
                  controller: _recordNo,
                  textInputAction: TextInputAction.done,
                ),
              ),
            sectionGap,
            switch (data) {
              AsyncData(:final value) => _Preview(
                data: value,
                title: reportTitle(pdfL10n, form.kind),
                period: l10n.pdfPeriod(
                  AppFormat.of(context).date(form.from),
                  AppFormat.of(context).date(form.to),
                ),
                busy: _busy,
                l10n: pdfL10n,
              ),
              AsyncError() => StatusMessage(
                status: AppStatus.critical,
                message: l10n.reportLoadError,
              ),
              // Yerel DB'den okunuyor; hemen gelir.
              _ => const SizedBox.shrink(),
            },
          ],
        ),
        action: Row(
          spacing: context.touchTargets.gap,
          children: [
            // Oluştur birincil, geniş; büyük yazıda iki etiket de kırılır.
            Expanded(
              child: BigButton(
                variant: BigButtonVariant.secondary,
                label: l10n.reportShare,
                onPressed: ready
                    ? () => _output(_Output.share, form, data.requireValue)
                    : null,
              ),
            ),
            Expanded(
              flex: 2,
              child: BigButton(
                label: l10n.reportCreate,
                onPressed: ready
                    ? () => _output(_Output.print, form, data.requireValue)
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _output(
    _Output output,
    ReportFormState form,
    ReportData data,
  ) async {
    final l10n = AppLocalizations.of(context);
    final language = form.language ?? _appLanguage(context);
    final pdfL10n = lookupAppLocalizations(language.locale!);
    final service = ref.read(printServiceProvider);
    final region = ref.read(regionConfigProvider);
    final organization = ref.read(currentOrganizationProvider).value;
    final apiaryId = form.apiaryId;
    final apiaryName = apiaryId == null ? null : data.apiaryNames[apiaryId];
    final title = reportTitle(pdfL10n, form.kind);
    String? text(TextEditingController controller) =>
        switch (controller.text.trim()) {
          '' => null,
          final value => value,
        };

    setState(() => _busy = true);
    try {
      final bytes = await buildReportPdf(
        data,
        header: (
          organizationName: organization?.name ?? '',
          registrations: region.features.aks
              ? [
                  if (text(_registrationNo) case final number?)
                    pdfL10n.pdfRegistrationNo(number),
                  if (text(_aksNo) case final number?) pdfL10n.pdfAksNo(number),
                ]
              : [
                  if (text(_recordNo) case final number?)
                    pdfL10n.pdfRecordNo(number),
                ],
        ),
        period: (from: form.from, to: form.to),
        apiaryName: apiaryName,
        createdAt: clock.now(),
        l10n: pdfL10n,
        units: region.defaultUnits,
      );
      final name = pdfL10n.pdfDocumentName(
        title,
        AppFormat(pdfL10n.localeName).shortDate(form.from),
        AppFormat(pdfL10n.localeName).shortDate(form.to),
      );
      switch (output) {
        case _Output.print:
          await service.printPdf(bytes, name: name);
        case _Output.share:
          await service.sharePdf(bytes, filename: pdfFileName(name));
      }
    } on Exception {
      if (mounted) showMessageSnackBar(context, l10n.reportError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Uygulamanın o anki dili; PDF dili seçilmediyse bu.
AppLanguage _appLanguage(BuildContext context) =>
    switch (Localizations.localeOf(context).languageCode) {
      'tr' => AppLanguage.turkish,
      _ => AppLanguage.english,
    };

/// Başlangıç ve bitiş günü yan yana.
class _Period extends StatelessWidget {
  const new({required this.form, required this.controller});

  final ReportFormState form;
  final ReportFormController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final today = defaultReportPeriod(clock.now()).to;
    final first = DateTime(today.year - 10);

    Future<DateTime?> pick(DateTime initial) => showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: first,
      lastDate: today,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: context.touchTargets.gap,
      children: [
        Expanded(
          child: LabeledField(
            label: l10n.reportFrom,
            child: DateField(
              text: format.date(form.from),
              onTap: () async {
                if (await pick(form.from) case final day?) {
                  controller.setFrom(day);
                }
              },
            ),
          ),
        ),
        Expanded(
          child: LabeledField(
            label: l10n.reportTo,
            child: DateField(
              text: format.date(form.to),
              onTap: () async {
                if (await pick(form.to) case final day?) controller.setTo(day);
              },
            ),
          ),
        ),
      ],
    );
  }
}

/// Arılık seçimi; kovan geçmişinde altında kovan seçimi. Seçili chip'e
/// yeniden dokunmak "Tümü"ne döner.
class _Scope extends ConsumerWidget {
  const new({required this.form, required this.controller});

  final ReportFormState form;
  final ReportFormController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final apiaries =
        ref.watch(apiaryListProvider).value ?? const <ApiarySummary>[];
    final sorted = [for (final summary in apiaries) summary.apiary]
      ..sort((a, b) => compareNatural(a.name, b.name));
    final hives = form.kind == ReportKind.hiveHistory
        ? reportHives(
            ref.watch(organizationHivesProvider).value ?? const <Hive>[],
            apiaryId: form.apiaryId,
          )
        : const <Hive>[];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.reportApiary,
          group: true,
          child: ChoiceChipGroup<String?>(
            options: [
              ChoiceChipOption(value: null, label: l10n.reportAllApiaries),
              for (final apiary in sorted)
                ChoiceChipOption(value: apiary.id, label: apiary.name),
            ],
            selected: {form.apiaryId},
            onChanged: (selected) => controller.setApiary(selected.firstOrNull),
          ),
        ),
        if (form.kind == ReportKind.hiveHistory && hives.isNotEmpty) ...[
          SizedBox(height: context.spacing.xl),
          LabeledField(
            label: l10n.reportHive,
            group: true,
            child: ChoiceChipGroup<String?>(
              options: [
                ChoiceChipOption(value: null, label: l10n.reportAllHives),
                for (final hive in hives)
                  ChoiceChipOption(value: hive.id, label: hive.number),
              ],
              selected: {form.hiveId},
              onChanged: (selected) => controller.setHive(selected.firstOrNull),
            ),
          ),
        ],
      ],
    );
  }
}

/// İlk sayfanın küçük önizlemesi: A4 oranında beyaz sayfada başlık, kayıt
/// sayısı ve ilk satırlar; metinler PDF'in dilinde ([l10n]). Yalnız
/// özettir, PDF'in kendisi değil.
class _Preview extends StatelessWidget {
  const new({
    required this.data,
    required this.title,
    required this.period,
    required this.busy,
    required this.l10n,
  });

  final ReportData data;
  final String title;

  /// Dönem, uygulamanın dilinde.
  final String period;
  final bool busy;
  final AppLocalizations l10n;

  /// Önizlemede gösterilen satır sayısı.
  static const _rows = 6;

  /// A4'ün eni / boyu (210 / 297 mm); kâğıdın oranı, ekran ölçüsü değil.
  static const double _pageAspect = 210 / 297;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final typography = context.typography;
    final format = AppFormat(l10n.localeName);
    final summary = busy
        ? AppLocalizations.of(context).reportPreparing
        : switch (data) {
            _ when data.isEmpty => l10n.reportEmpty,
            TreatmentRegister(:final entries) => l10n.reportTreatmentCount(
              entries.length,
            ),
            HiveHistoryReport(:final hives, :final itemCount) => [
              l10n.reportHiveCount(hives.length),
              l10n.reportRecordCount(itemCount),
            ].join(l10n.titleSeparator),
          };
    final lines = switch (data) {
      TreatmentRegister(:final entries) => [
        for (final entry in entries.take(_rows))
          [
            format.shortDate(entry.treatment.startedAt.toLocal()),
            entry.treatment.productName,
            l10n.reportHiveCount(entry.hiveCount),
          ].join(l10n.titleSeparator),
      ],
      HiveHistoryReport(:final hives) => [
        for (final history in hives.take(_rows))
          [
            l10n.hiveLabel(history.hive.number),
            l10n.reportRecordCount(history.items.length),
          ].join(l10n.titleSeparator),
      ],
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NoteCard(title: summary, message: period),
        SizedBox(height: spacing.lg),
        ExcludeSemantics(
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colors.surfaceContainer,
              borderRadius: BorderRadius.circular(context.radii.card),
            ),
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Center(
                child: FractionallySizedBox(
                  widthFactor: 0.7,
                  child: AspectRatio(
                    aspectRatio: _pageAspect,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: colors.tile,
                        border: Border.all(
                          color: colors.divider,
                          width: context.strokes.border,
                        ),
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(spacing.md),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: AlignmentDirectional.topStart,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(title, style: typography.label),
                              SizedBox(height: spacing.sm),
                              for (final line in lines)
                                Text(
                                  line,
                                  style: typography.bodySmall.copyWith(
                                    color: colors.textSecondary,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

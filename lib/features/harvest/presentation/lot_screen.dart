import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/core/services/print_service_provider.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/feeding/presentation/widgets/feeding_labels.dart';
import 'package:mobil_arici/features/harvest/data/lot_repository.dart';
import 'package:mobil_arici/features/harvest/domain/harvest_rules.dart';
import 'package:mobil_arici/features/harvest/domain/lot.dart';
import 'package:mobil_arici/features/harvest/domain/lot_rules.dart';
import 'package:mobil_arici/features/harvest/presentation/lot_providers.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_label_sheet.dart';
import 'package:mobil_arici/features/harvest/presentation/widgets/lot_widgets.dart';
import 'package:mobil_arici/features/organization/domain/membership_role.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// Lot: kart (bal türü, numara · yöre, kilogram, etiketler), bekleme süresi
/// ihlali varsa kırmızı kilit kartı, stok (hasat, satılan, stokta; "Satış
/// düş"), analizler ("Analiz ekle"; raporlu analiz belgeyi açar),
/// hasatlar, kovanların son ilaçlamaları ve satışlar. Üstte düzenleme.
/// Viewer yalnız okur.
class LotScreen extends ConsumerWidget {
  const new({required this.lotId, super.key});

  final String lotId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final canWrite = ref.watch(canWriteRecordsProvider);

    return switch (ref.watch(lotSummaryProvider(lotId))) {
      AsyncData(value: final summary?) => Scaffold(
        appBar: AppBar(
          title: Text(summary.lot.number(l10n)),
          actions: [
            if (canWrite)
              IconButton(
                tooltip: l10n.lotEdit,
                icon: const Icon(Icons.edit_outlined),
                onPressed: () => context.go(AppRoutes.lotEdit(lotId)),
              ),
          ],
        ),
        body: _Body(summary, canWrite: canWrite),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.lotNotFound)),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.lotsLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

class _Body extends ConsumerWidget {
  const new(this.summary, {required this.canWrite});

  final LotSummary summary;
  final bool canWrite;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final lot = summary.lot;
    final violations = [
      for (final row
          in ref.watch(lotTreatmentsProvider(lot.id)).value ??
              const <LotTreatmentRow>[])
        if (row.link.withdrawalViolation) row.hiveNumber ?? '?',
    ];

    return ListView(
      padding: EdgeInsets.all(spacing.lg),
      children: [
        LotCard(summary),
        if (violations.isNotEmpty) ...[
          SizedBox(height: spacing.lg),
          CriticalLockCard(
            title: l10n.lotWithdrawalTitle(violations.join(', ')),
            message: l10n.lotWithdrawalMessage,
          ),
        ],
        SizedBox(height: spacing.xl),
        SectionLabel(l10n.lotStock),
        SizedBox(height: spacing.sm),
        ListGroup(
          children: [
            ListRow(
              title: l10n.lotHarvested,
              value: lotWeight(ref, context, summary.kg),
            ),
            ListRow(
              title: l10n.lotSold,
              value: lotWeight(ref, context, summary.soldKg),
            ),
            ListRow(
              title: l10n.lotInStock,
              value: lotWeight(ref, context, lotStock(summary)),
            ),
          ],
        ),
        if (canWrite && lotStock(summary) > 0) ...[
          SizedBox(height: spacing.md),
          BigButton(
            label: l10n.lotSell,
            icon: Icons.remove_shopping_cart_outlined,
            variant: BigButtonVariant.secondary,
            onPressed: () => unawaited(_showSaleSheet(context, ref, summary)),
          ),
        ],
        SizedBox(height: spacing.xl),
        SectionLabel(l10n.lotAnalyses),
        SizedBox(height: spacing.sm),
        _LabResults(lot),
        if (canWrite) ...[
          SizedBox(height: spacing.md),
          BigButton(
            label: l10n.lotAddAnalysis,
            icon: Icons.science_outlined,
            variant: BigButtonVariant.secondary,
            onPressed: () => context.go(AppRoutes.lotLabResult(lot.id)),
          ),
        ],
        // Sayfa adresi yapılandırılmadıysa (özel alan adı yok) gizli.
        if (ref.watch(lotPageBaseUrlProvider) case final baseUrl?) ...[
          SizedBox(height: spacing.xl),
          SectionLabel(l10n.lotPublicPage),
          SizedBox(height: spacing.sm),
          _Publication(lot, baseUrl: baseUrl),
        ],
        SizedBox(height: spacing.xl),
        SectionLabel(l10n.lotHarvests),
        SizedBox(height: spacing.sm),
        _Harvests(lot),
        SizedBox(height: spacing.xl),
        SectionLabel(l10n.lotTreatments),
        SizedBox(height: spacing.sm),
        _Treatments(lot),
        SizedBox(height: spacing.xl),
        SectionLabel(l10n.lotSales),
        SizedBox(height: spacing.sm),
        _Sales(lot),
      ],
    );
  }
}

/// Bölüm boşken soluk açıklama.
class _Empty extends StatelessWidget {
  const new(this.message);

  final String message;

  @override
  Widget build(BuildContext context) => Text(
    message,
    style: context.typography.body.copyWith(
      color: context.colors.textSecondary,
    ),
  );
}

class _LabResults extends ConsumerWidget {
  const new(this.lot);

  final Lot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final results = ref.watch(lotLabResultsProvider(lot.id)).value;
    if (results == null) return const SizedBox.shrink();
    if (results.isEmpty) return _Empty(l10n.lotAnalysesEmpty);
    String number(double value) => format.number(value, maxFractionDigits: 1);

    return ListGroup(
      children: [
        for (final result in results)
          ListRow(
            title: format.date(result.testedOn),
            subtitle: [
              if (result.hmf case final hmf?) l10n.labHmfValue(number(hmf)),
              if (result.diastase case final value?)
                l10n.labDiastaseValue(number(value)),
              if (result.proline case final value?)
                l10n.labProlineValue(number(value)),
              if (result.moisture case final value?)
                l10n.lotMoistureValue(number(value)),
              if (result.residue case final residue?) residue.label(l10n),
            ].join(l10n.titleSeparator),
            trailing: result.documentId == null
                ? null
                : Icon(
                    Icons.description_outlined,
                    semanticLabel: l10n.labReport,
                  ),
            onTap: switch (result.documentId) {
              final id? => () => context.go(AppRoutes.document(id)),
              null => null,
            },
          ),
      ],
    );
  }
}

enum _Output { print, share }

/// "Yayımla" anahtarı; yayımdayken sayfada görünecek alanlar ve kavanoz
/// etiketi (QR) PDF'i. Anahtarları yalnız owner değiştirir, diğerleri
/// durumu görür. Yayımda değilken sayfa 404 olduğu için etiket yok.
class _Publication extends ConsumerStatefulWidget {
  const new(this.lot, {required this.baseUrl});

  final Lot lot;

  /// Lot sayfalarının kökü; QR `<baseUrl>/<lot_id>` taşır.
  final String baseUrl;

  @override
  ConsumerState<_Publication> createState() => _PublicationState();
}

class _PublicationState extends ConsumerState<_Publication> {
  /// PDF hazırlanırken butonlar pasif.
  var _busy = false;

  Future<void> _set({
    bool? published,
    bool? publicProducer,
    bool? publicOrigin,
    bool? publicLab,
    bool? publicReport,
  }) => ref
      .read(lotActionsProvider.notifier)
      .setPublication(
        widget.lot,
        published: published,
        publicProducer: publicProducer,
        publicOrigin: publicOrigin,
        publicLab: publicLab,
        publicReport: publicReport,
      );

  Future<void> _output(_Output output) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(printServiceProvider);
    final lot = widget.lot;
    final number = lot.number(l10n);
    final title = l10n.lotJarLabelsDocumentName(number);
    setState(() => _busy = true);
    try {
      final bytes = await buildLotLabelPdf((
        url: lotPageUrl(widget.baseUrl, lot.id),
        number: number,
        honey: lot.title(l10n),
      ), title: title);
      switch (output) {
        case _Output.print:
          await service.printPdf(bytes, name: title);
        case _Output.share:
          await service.sharePdf(bytes, filename: pdfFileName(title));
      }
    } on Exception {
      if (mounted) showMessageSnackBar(context, l10n.hiveLabelsError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final lot = widget.lot;
    final isOwner = ref.watch(currentRoleProvider) == MembershipRole.owner;

    Widget toggle({
      required String title,
      required bool value,
      required ValueChanged<bool> onChanged,
      String? subtitle,
    }) => SwitchListTile(
      value: value,
      onChanged: isOwner ? onChanged : null,
      contentPadding: EdgeInsets.symmetric(horizontal: spacing.lg),
      title: Text(title, style: context.typography.body),
      subtitle: subtitle == null
          ? null
          : Text(
              subtitle,
              style: context.typography.bodySmall.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListGroup(
          children: [
            toggle(
              title: l10n.lotPublish,
              value: lot.published,
              subtitle: isOwner
                  ? l10n.lotPublishHint
                  : [
                      if (lot.published)
                        l10n.lotPublished
                      else
                        l10n.lotNotPublished,
                      l10n.lotPublishOwnerOnly,
                    ].join(l10n.titleSeparator),
              onChanged: (value) => unawaited(_set(published: value)),
            ),
          ],
        ),
        if (lot.published) ...[
          SizedBox(height: spacing.lg),
          SectionLabel(l10n.lotPublicFields),
          SizedBox(height: spacing.sm),
          ListGroup(
            children: [
              toggle(
                title: l10n.lotPublicProducer,
                value: lot.publicProducer,
                onChanged: (value) => unawaited(_set(publicProducer: value)),
              ),
              toggle(
                title: l10n.lotPublicOrigin,
                value: lot.publicOrigin,
                onChanged: (value) => unawaited(_set(publicOrigin: value)),
              ),
              toggle(
                title: l10n.lotPublicLab,
                value: lot.publicLab,
                onChanged: (value) => unawaited(_set(publicLab: value)),
              ),
              toggle(
                title: l10n.lotPublicReport,
                value: lot.publicReport,
                onChanged: (value) => unawaited(_set(publicReport: value)),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          SectionLabel(l10n.lotJarLabels),
          SizedBox(height: spacing.sm),
          Text(
            l10n.lotJarLabelsHint,
            style: context.typography.bodySmall.copyWith(
              color: context.colors.textSecondary,
            ),
          ),
          SizedBox(height: spacing.md),
          Row(
            children: [
              Expanded(
                child: BigButton(
                  variant: BigButtonVariant.secondary,
                  label: l10n.hiveLabelsShare,
                  onPressed: _busy
                      ? null
                      : () => unawaited(_output(_Output.share)),
                ),
              ),
              SizedBox(width: spacing.md),
              Expanded(
                child: BigButton(
                  icon: Icons.qr_code_2_rounded,
                  label: l10n.hiveLabelsPrint,
                  onPressed: _busy
                      ? null
                      : () => unawaited(_output(_Output.print)),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

class _Harvests extends ConsumerWidget {
  const new(this.lot);

  final Lot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final rows = ref.watch(lotHarvestsProvider(lot.id)).value;
    if (rows == null) return const SizedBox.shrink();
    if (rows.isEmpty) return _Empty(l10n.lotHarvestsEmpty);
    return ListGroup(
      children: [
        for (final row in rows)
          ListRow(
            title: format.date(row.harvest.harvestedAt.toLocal()),
            subtitle: row.apiaryName,
            value: lotWeight(ref, context, row.harvest.netKg),
          ),
      ],
    );
  }
}

class _Treatments extends ConsumerWidget {
  const new(this.lot);

  final Lot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rows = ref.watch(lotTreatmentsProvider(lot.id)).value;
    if (rows == null) return const SizedBox.shrink();
    if (rows.isEmpty) return _Empty(l10n.lotTreatmentsEmpty);
    return ListGroup(children: [for (final row in rows) _TreatmentRow(row)]);
  }
}

/// Kovan · ürün, uygulama ve bekleme bitiş günü; ihlal varsa altında
/// kritik rozet (dar ekranda satırı taşırmasın diye yanda değil).
class _TreatmentRow extends StatelessWidget {
  const new(this.row);

  final LotTreatmentRow row;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;

    return MergeSemantics(
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: context.touchTargets.field),
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: spacing.lg,
            vertical: spacing.md,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.lotTreatmentTitle(row.hiveNumber ?? '?', row.productName),
                style: context.typography.body,
              ),
              Text(
                l10n.lotTreatmentDetail(
                  format.date(row.link.treatedAt.toLocal()),
                  format.date(row.link.withdrawalEndsOn),
                ),
                style: context.typography.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              if (row.link.withdrawalViolation) ...[
                SizedBox(height: spacing.sm),
                StatusBadge(
                  status: AppStatus.critical,
                  label: l10n.lotWithdrawalBadge,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Sales extends ConsumerWidget {
  const new(this.lot);

  final Lot lot;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final sales = ref.watch(lotSalesProvider(lot.id)).value;
    if (sales == null) return const SizedBox.shrink();
    if (sales.isEmpty) return _Empty(l10n.lotSalesEmpty);
    return ListGroup(
      children: [
        for (final sale in sales)
          ListRow(
            title: format.date(sale.soldOn),
            value: l10n.lotSaleValue(lotWeight(ref, context, sale.kg)),
          ),
      ],
    );
  }
}

/// Satış düşme sayfası: miktar (kullanıcının biriminde); stoktan fazlası
/// yazılamaz. Kaydedince 6 sn geri alınabilir.
Future<void> _showSaleSheet(
  BuildContext context,
  WidgetRef ref,
  LotSummary summary,
) async {
  final actions = ref.read(lotActionsProvider.notifier);
  final sale = await showModalBottomSheet<LotSale>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _SaleSheet(lotId: summary.lot.id),
  );
  if (sale == null || !context.mounted) return;
  showUndoSnackBar(
    context,
    message: AppLocalizations.of(context)
        .lotSaleSaved(lotWeight(ref, context, sale.kg)),
    onUndo: () => unawaited(actions.undoSale(sale)),
  );
}

class _SaleSheet extends ConsumerStatefulWidget {
  const new({required this.lotId});

  final String lotId;

  @override
  ConsumerState<_SaleSheet> createState() => _SaleSheetState();
}

class _SaleSheetState extends ConsumerState<_SaleSheet> {
  final _amount = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _amount.dispose();
    super.dispose();
  }

  Future<void> _save(Lot lot, double kg) async {
    setState(() => _busy = true);
    try {
      final sale = await ref
          .read(lotActionsProvider.notifier)
          .addSale(lot, kg, soldOn: clock.now());
      if (mounted) Navigator.of(context).pop(sale);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final summary = ref.watch(lotSummaryProvider(widget.lotId)).value;
    if (summary == null) return const SizedBox.shrink();
    final mass = ref.watch(regionConfigProvider).defaultUnits.mass;
    final stock = lotStock(summary);
    final text = _amount.text.trim();
    final value = parseHarvestWeight(text);
    final kg = value == null ? null : storedHarvestKg(value, mass);
    final valid = kg != null && kg <= stock;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        spacing.lg,
        0,
        spacing.lg,
        spacing.lg + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(summary.lot.number(l10n), style: context.typography.title),
            Text(
              l10n.lotStockValue(lotWeight(ref, context, stock)),
              style: context.typography.body.copyWith(
                color: context.colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.lg),
            LabeledField(
              label: l10n.lotSaleAmount(mass.label(l10n)),
              child: TextField(
                controller: _amount,
                enabled: !_busy,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp('[0-9.,]')),
                ],
                textInputAction: TextInputAction.done,
                style: context.typography.number,
                onChanged: (_) => setState(() {}),
              ),
            ),
            if (text.isNotEmpty && !valid) ...[
              SizedBox(height: spacing.sm),
              StatusMessage(
                status: AppStatus.warning,
                message: kg == null
                    ? l10n.harvestWeightInvalid
                    : l10n.lotSaleTooMuch(lotWeight(ref, context, stock)),
              ),
            ],
            SizedBox(height: spacing.lg),
            BigButton(
              label: l10n.lotSaleSave,
              onPressed: valid && !_busy
                  ? () => unawaited(_save(summary.lot, kg))
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

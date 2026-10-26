import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/pdf_fonts.dart';
import 'package:mobil_arici/core/services/print_service_provider.dart';
import 'package:mobil_arici/features/apiaries/presentation/apiary_providers.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/hive_label_providers.dart';
import 'package:mobil_arici/features/hives/presentation/hive_providers.dart';
import 'package:mobil_arici/features/hives/presentation/labels/hive_label_sheet.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';

enum _Output { print, share }

/// Arılıktaki kovanlardan etiket basılacakları seçtirir; A4 etiket PDF'ini
/// cihazda üretip yazdırma ya da paylaşma ekranını açar. Üstte seçimin
/// özeti ve ilk sayfanın önizlemesi, altta kovan listesi; Paylaş ve Yazdır
/// altta sabit. Aktif kovanlar seçili gelir.
class HiveLabelsScreen extends ConsumerStatefulWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  ConsumerState<HiveLabelsScreen> createState() => _HiveLabelsScreenState();
}

class _HiveLabelsScreenState extends ConsumerState<HiveLabelsScreen> {
  /// PDF hazırlanırken butonlar pasif.
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final apiaryId = widget.apiaryId;
    final apiaryName = ref
        .watch(apiarySummaryProvider(apiaryId))
        .whenData((summary) => summary?.apiary.name);
    final hives = ref.watch(apiaryHivesProvider(apiaryId));
    final choices = ref.watch(hiveLabelSelectionProvider(apiaryId));
    final selected = [
      for (final hive in hives.value ?? const <Hive>[])
        if (isLabelSelected(hive, choices)) hive,
    ];
    final name = apiaryName.value;
    VoidCallback? output(_Output output) =>
        name == null || selected.isEmpty || _busy
        ? null
        : () => _output(output, apiaryName: name, hives: selected);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.hiveLabelsTitle)),
      body: switch ((apiaryName, hives)) {
        (AsyncData(value: null), _) => const ApiaryNotFound(),
        (AsyncData(value: _?), AsyncData(value: final hives)) => _Selection(
          apiaryId: apiaryId,
          hives: hives,
          choices: choices,
          selected: selected,
          busy: _busy,
          onPrint: output(_Output.print),
          onShare: output(_Output.share),
        ),
        (AsyncError(), _) ||
        (_, AsyncError()) => Center(child: Text(l10n.hivesLoadError)),
        // Yerel DB'den okunuyor; hemen gelir.
        _ => const SizedBox.shrink(),
      },
    );
  }

  Future<void> _output(
    _Output output, {
    required String apiaryName,
    required List<Hive> hives,
  }) async {
    final l10n = AppLocalizations.of(context);
    final service = ref.read(printServiceProvider);
    final title = l10n.hiveLabelsDocumentName(apiaryName);
    setState(() => _busy = true);
    try {
      final bytes = await buildHiveLabelPdf([
        for (final hive in hives)
          (hiveId: hive.id, number: hive.number, apiaryName: apiaryName),
      ], title: title);
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
}

/// Özet, önizleme ve kovan listesi; altta sabit Paylaş + Yazdır.
class _Selection extends ConsumerWidget {
  const new({
    required this.apiaryId,
    required this.hives,
    required this.choices,
    required this.selected,
    required this.busy,
    required this.onPrint,
    required this.onShare,
  });

  final String apiaryId;
  final List<Hive> hives;
  final Map<String, bool> choices;
  final List<Hive> selected;
  final bool busy;
  final VoidCallback? onPrint;
  final VoidCallback? onShare;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final selection = hiveLabelSelectionProvider(apiaryId);
    final count = selected.length;

    if (hives.isEmpty) {
      return EmptyState(
        icon: Icons.qr_code_2_rounded,
        title: l10n.hivesEmptyTitle,
        message: l10n.hiveLabelsNoHives,
        centered: true,
      );
    }

    return BottomActionLayout(
      separated: true,
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          NoteCard(
            title: busy
                ? l10n.hiveLabelsPreparing
                : count == 0
                ? l10n.hiveLabelsNoneSelected
                : l10n.hiveLabelsSummary(
                    l10n.hiveLabelsCount(count),
                    l10n.hiveLabelsPages(HiveLabelSheet.pageCount(count)),
                  ),
            message: l10n.hiveLabelsMessage,
          ),
          SizedBox(height: spacing.lg),
          _SheetPreview(numbers: [for (final hive in selected) hive.number]),
          SizedBox(height: spacing.lg),
          Wrap(
            spacing: spacing.sm,
            children: [
              TextButton(
                onPressed: () => ref
                    .read(selection.notifier)
                    .selectAll(hives, selected: true),
                child: Text(l10n.hiveLabelsSelectAll),
              ),
              TextButton(
                onPressed: () => ref
                    .read(selection.notifier)
                    .selectAll(hives, selected: false),
                child: Text(l10n.hiveLabelsSelectNone),
              ),
            ],
          ),
          SizedBox(height: spacing.sm),
          ListGroup(
            children: [
              for (final hive in hives)
                CheckboxListTile(
                  value: isLabelSelected(hive, choices),
                  onChanged: (_) => ref.read(selection.notifier).toggle(hive),
                  controlAffinity: ListTileControlAffinity.leading,
                  contentPadding: EdgeInsets.symmetric(horizontal: spacing.md),
                  title: Text(
                    l10n.hiveLabel(hive.number),
                    style: context.typography.label,
                  ),
                  subtitle: hive.status.isCounted
                      ? null
                      : Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: StatusBadge(
                            status: hive.status.appStatus,
                            label: hive.status.label(l10n),
                          ),
                        ),
                ),
            ],
          ),
        ],
      ),
      action: Row(
        spacing: context.touchTargets.gap,
        children: [
          // Yazdır birincil, geniş; büyük yazıda iki etiket de kırılır.
          Expanded(
            child: BigButton(
              variant: BigButtonVariant.secondary,
              label: l10n.hiveLabelsShare,
              onPressed: onShare,
            ),
          ),
          Expanded(
            flex: 2,
            child: BigButton(label: l10n.hiveLabelsPrint, onPressed: onPrint),
          ),
        ],
      ),
    );
  }
}

/// İlk sayfanın küçük önizlemesi: A4 oranında beyaz sayfada etiket
/// ızgarası; dolu gözlerde QR işareti ve numara, boş gözler soluk. Yalnız
/// süstür; özet ve liste ekran okuyucuya zaten söyler.
class _SheetPreview extends StatelessWidget {
  const new({required this.numbers});

  final List<String> numbers;

  /// A4'ün eni / boyu (210 / 297 mm); kâğıdın oranı, ekran ölçüsü değil.
  static const double _pageAspect = 210 / 297;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final firstPage = numbers.take(HiveLabelSheet.perPage).toList();

    return ExcludeSemantics(
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: BorderRadius.circular(context.radii.card),
        ),
        child: Padding(
          padding: EdgeInsets.all(spacing.lg),
          child: Center(
            child: FractionallySizedBox(
              widthFactor: 0.6,
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
                    padding: EdgeInsets.all(spacing.xs),
                    child: Column(
                      children: [
                        for (var row = 0; row < HiveLabelSheet.rows; row++)
                          Expanded(
                            child: Row(
                              children: [
                                for (
                                  var column = 0;
                                  column < HiveLabelSheet.columns;
                                  column++
                                )
                                  Expanded(
                                    child: _PreviewCell(
                                      number: firstPage.elementAtOrNull(
                                        row * HiveLabelSheet.columns + column,
                                      ),
                                    ),
                                  ),
                              ],
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
    );
  }
}

class _PreviewCell extends StatelessWidget {
  const new({required this.number});

  final String? number;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final number = this.number;
    final ink = number == null ? colors.divider : colors.textPrimary;

    return Padding(
      padding: EdgeInsets.all(context.strokes.border),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: colors.divider,
            width: context.strokes.border,
          ),
        ),
        child: FittedBox(
          child: Padding(
            padding: EdgeInsets.all(context.spacing.xs),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.qr_code_2_rounded, color: ink),
                if (number != null)
                  Text(
                    number,
                    style: context.typography.label.copyWith(color: ink),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

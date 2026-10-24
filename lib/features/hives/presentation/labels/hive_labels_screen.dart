import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
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
/// cihazda üretip yazdırma ya da paylaşma ekranını açar. Aktif kovanlar
/// seçili gelir.
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
      appBar: AppBar(
        title: Text(l10n.hiveLabelsTitle),
        actions: [
          // Alt panel listeye yer bıraksın diye paylaşma üstte.
          if (name != null)
            IconButton(
              tooltip: l10n.hiveLabelsShare,
              icon: const Icon(Icons.share_rounded),
              onPressed: output(_Output.share),
            ),
        ],
      ),
      body: switch ((apiaryName, hives)) {
        (AsyncData(value: null), _) => const ApiaryNotFound(),
        (AsyncData(value: _?), AsyncData(value: final hives)) => _Selection(
          apiaryId: apiaryId,
          hives: hives,
          choices: choices,
          selectedCount: selected.length,
          busy: _busy,
          onPrint: output(_Output.print),
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
          await service.sharePdf(bytes, filename: '${_fileName(title)}.pdf');
      }
    } on Exception {
      if (mounted) showMessageSnackBar(context, l10n.hiveLabelsError);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Dosya adında sorun çıkaran karakterler tireye döner.
String _fileName(String title) =>
    title.replaceAll(RegExp(r'[\\/:*?"<>|]+'), '-').trim();

/// Kovan listesi ve altta sabit özet + Yazdır.
class _Selection extends ConsumerWidget {
  const new({
    required this.apiaryId,
    required this.hives,
    required this.choices,
    required this.selectedCount,
    required this.busy,
    required this.onPrint,
  });

  final String apiaryId;
  final List<Hive> hives;
  final Map<String, bool> choices;
  final int selectedCount;
  final bool busy;
  final VoidCallback? onPrint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final selection = hiveLabelSelectionProvider(apiaryId);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.symmetric(vertical: spacing.lg),
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing.lg),
                child: Text(
                  l10n.hiveLabelsMessage,
                  style: context.typography.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              ),
              if (hives.isEmpty)
                EmptyState(
                  icon: Icons.qr_code_2_rounded,
                  title: l10n.hivesEmptyTitle,
                  message: l10n.hiveLabelsNoHives,
                )
              else ...[
                SizedBox(height: spacing.sm),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                  child: Wrap(
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
                ),
                for (final hive in hives)
                  CheckboxListTile(
                    value: isLabelSelected(hive, choices),
                    onChanged: (_) => ref.read(selection.notifier).toggle(hive),
                    controlAffinity: ListTileControlAffinity.leading,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: spacing.lg,
                    ),
                    title: Text(
                      l10n.hiveLabel(hive.number),
                      style: context.typography.subtitle,
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
            ],
          ),
        ),
        DecoratedBox(
          decoration: BoxDecoration(
            color: context.colors.surface,
            border: Border(
              top: BorderSide(
                color: context.colors.divider,
                width: context.strokes.border,
              ),
            ),
          ),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    busy
                        ? l10n.hiveLabelsPreparing
                        : selectedCount == 0
                        ? l10n.hiveLabelsNoneSelected
                        : l10n.hiveLabelsSummary(
                            l10n.hiveLabelsCount(selectedCount),
                            l10n.hiveLabelsPages(
                              HiveLabelSheet.pageCount(selectedCount),
                            ),
                          ),
                    textAlign: TextAlign.center,
                    style: context.typography.label,
                  ),
                  SizedBox(height: spacing.md),
                  BigButton(
                    label: l10n.hiveLabelsPrint,
                    icon: Icons.print_rounded,
                    onPressed: onPrint,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

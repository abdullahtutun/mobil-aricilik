import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/bulk_hive_form_controller.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_choice_fields.dart';

/// Toplu kovan oluşturma: kaç kovan ve ilk numara (sayaç görünümünde kısa
/// alanlar), tip ve kaynak chip'leri; altında hangi numaraların oluşacağı
/// önizleme kartında. Buton kaç kovan oluşacağını yazar. Kaydedince
/// arılığa dönülür.
class BulkHiveFormScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final title = Text(l10n.hiveBulkTitle);

    return switch (ref.watch(bulkHiveFormControllerProvider(apiaryId))) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(spacing.lg),
            children: [_BulkHiveFormFields(apiaryId: apiaryId)],
          ),
          action: BigButton(
            label: switch (form.numbers) {
              final numbers? => l10n.hiveBulkSaveCount(numbers.length),
              null => l10n.hiveBulkSave,
            },
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: const ApiaryNotFound(),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final created = await ref
        .read(bulkHiveFormControllerProvider(apiaryId).notifier)
        .save();
    if (created == null || !context.mounted) return;
    showMessageSnackBar(
      context,
      AppLocalizations.of(context).hiveBulkCreated(created),
    );
    context.pop();
  }
}

class _BulkHiveFormFields extends ConsumerWidget {
  const new({required this.apiaryId});

  final String apiaryId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final provider = bulkHiveFormControllerProvider(apiaryId);
    final form = ref.watch(provider).value;
    if (form == null) return const SizedBox.shrink();
    final controller = ref.read(provider.notifier);
    final numberStyle = context.typography.number;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InlineField(
          label: l10n.hiveBulkCount,
          field: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.next,
            textAlign: TextAlign.center,
            style: numberStyle,
            decoration: InputDecoration(hintText: l10n.hiveBulkCountHint),
            onChanged: controller.updateCount,
          ),
        ),
        if (form.countTooLarge) ...[
          SizedBox(height: spacing.sm),
          StatusMessage(
            status: AppStatus.warning,
            message: l10n.hiveBulkCountTooMany(maxBulkHiveCount),
          ),
        ],
        SizedBox(height: context.touchTargets.gap),
        InlineField(
          label: l10n.hiveBulkStart,
          field: TextField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            textInputAction: TextInputAction.done,
            textAlign: TextAlign.center,
            style: numberStyle,
            decoration: InputDecoration(hintText: l10n.hiveBulkStartHint),
            onChanged: controller.updateStartNumber,
          ),
        ),
        SizedBox(height: spacing.xl),
        HiveTypeField(selected: form.type, onChanged: controller.selectType),
        SizedBox(height: spacing.xl),
        HiveSourceField(
          selected: form.source,
          onChanged: controller.selectSource,
        ),
        if (form.numbers case final numbers?) ...[
          SizedBox(height: spacing.xl),
          _Preview(numbers),
        ],
      ],
    );
  }
}

/// Oluşacak numaralar: ilk üçü, "…" ve sonuncusu; altında cümlesi. Ekran
/// okuyucu cümleyi okur, değişince kendiliğinden.
class _Preview extends StatelessWidget {
  const new(this.numbers);

  final List<String> numbers;

  /// Bundan uzun listede ortası "…" olur.
  static const _shown = 4;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final shown = numbers.length <= _shown
        ? numbers
        : [...numbers.take(_shown - 1), l10n.listEllipsis, numbers.last];

    return AppCard(
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionLabel(l10n.hiveBulkPreviewTitle),
            SizedBox(height: spacing.sm),
            ExcludeSemantics(
              child: Wrap(
                spacing: spacing.sm,
                runSpacing: spacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  for (final number in shown)
                    if (number == l10n.listEllipsis)
                      Text(number, style: context.typography.label)
                    else
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: context.colors.surfaceContainer,
                          borderRadius: BorderRadius.circular(
                            context.radii.small,
                          ),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: spacing.md,
                            vertical: spacing.xs,
                          ),
                          child: Text(
                            number,
                            style: context.typography.subtitle,
                          ),
                        ),
                      ),
                ],
              ),
            ),
            SizedBox(height: spacing.md),
            Semantics(
              liveRegion: true,
              child: Text(
                l10n.hiveBulkPreview(
                  numbers.length,
                  numbers.first,
                  numbers.last,
                ),
                style: context.typography.bodySmall.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

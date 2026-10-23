import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/domain/hive_rules.dart';
import 'package:mobil_arici/features/hives/presentation/bulk_hive_form_controller.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';

/// Toplu kovan oluşturma: kaç kovan, ilk numara, tip ve kaynak. Butonun
/// üstünde hangi numaraların oluşacağı yazar. Kaydedince arılığa dönülür.
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
        appBar: AppBar(title: title),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(spacing.lg),
                  children: [_BulkHiveFormFields(apiaryId: apiaryId)],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(spacing.lg),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (form.numbers case final numbers?) ...[
                      Semantics(
                        liveRegion: true,
                        child: Text(
                          l10n.hiveBulkPreview(
                            numbers.length,
                            numbers.first,
                            numbers.last,
                          ),
                          style: context.typography.subtitle,
                        ),
                      ),
                      SizedBox(height: spacing.md),
                    ],
                    BigButton(
                      label: l10n.hiveBulkSave,
                      icon: Icons.library_add_rounded,
                      onPressed: form.canSave
                          ? () => _save(context, ref)
                          : null,
                    ),
                  ],
                ),
              ),
            ],
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
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).hiveBulkCreated(created)),
        ),
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

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.next,
          style: context.typography.body,
          decoration: _decoration(
            context,
            label: l10n.hiveBulkCount,
            hint: l10n.hiveBulkCountHint,
            error: form.countTooLarge
                ? l10n.hiveBulkCountTooMany(maxBulkHiveCount)
                : null,
          ),
          onChanged: controller.updateCount,
        ),
        SizedBox(height: spacing.lg),
        TextField(
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          textInputAction: TextInputAction.done,
          style: context.typography.body,
          decoration: _decoration(
            context,
            label: l10n.hiveBulkStart,
            hint: l10n.hiveBulkStartHint,
          ),
          onChanged: controller.updateStartNumber,
        ),
        SizedBox(height: spacing.lg),
        SectionCard(
          title: l10n.hiveFormType,
          child: ChoiceChipGroup<HiveType>(
            options: [
              for (final type in HiveType.values)
                ChoiceChipOption(value: type, label: type.label(l10n)),
            ],
            selected: {form.type},
            // Tip zorunlu; seçili chip'e yeniden dokunmak seçimi kaldırmaz.
            onChanged: (selected) {
              if (selected.isNotEmpty) controller.selectType(selected.single);
            },
          ),
        ),
        SizedBox(height: spacing.lg),
        SectionCard(
          title: l10n.hiveFormSource,
          child: ChoiceChipGroup<HiveSource>(
            options: [
              for (final source in HiveSource.values)
                ChoiceChipOption(value: source, label: source.label(l10n)),
            ],
            selected: {?form.source},
            onChanged: (selected) =>
                controller.selectSource(selected.firstOrNull),
          ),
        ),
      ],
    );
  }

  static InputDecoration _decoration(
    BuildContext context, {
    required String label,
    required String hint,
    String? error,
  }) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      errorText: error,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(context.radii.button),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/apiaries/presentation/widgets/apiary_not_found.dart';
import 'package:mobil_arici/features/hives/domain/hive.dart';
import 'package:mobil_arici/features/hives/presentation/hive_form_controller.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_choice_fields.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_labels.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_not_found.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/hive_sheets.dart';

/// Kovan ekleme ([hiveId] null) ve düzenleme: numara, tip, durum, kaynak.
/// Kaydedince yeni kovanın kartı açılır; düzenlemede karta dönülür. Aktif
/// kovanı söndü, birleşti, satıldı ya da kayboldu yapan kayıt önce onay
/// ister.
class HiveFormScreen extends ConsumerWidget {
  const new({required this.apiaryId, super.key, this.hiveId});

  final String apiaryId;
  final String? hiveId;

  HiveFormControllerProvider get _provider =>
      hiveFormControllerProvider(apiaryId: apiaryId, hiveId: hiveId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      hiveId == null ? l10n.hiveFormNewTitle : l10n.hiveFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(title: title),
        body: BottomActionLayout(
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [_HiveFormFields(_provider, isNew: hiveId == null)],
          ),
          action: BigButton(
            label: l10n.hiveFormSave,
            icon: Icons.check_rounded,
            onPressed: form.canSave ? () => _save(context, ref, form) : null,
          ),
        ),
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(title: title),
        body: hiveId == null ? const ApiaryNotFound() : const HiveNotFound(),
      ),
      AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.hivesLoadError)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    HiveFormState form,
  ) async {
    if (form.needsConfirmation) {
      final confirmed = await confirmHiveStatusChange(
        context,
        number: form.number.trim(),
        status: form.status,
      );
      if (!confirmed || !context.mounted) return;
    }
    final id = await ref.read(_provider.notifier).save();
    if (id == null || !context.mounted) return;
    if (hiveId == null) {
      context.go(AppRoutes.hive(apiaryId, id));
    } else {
      context.pop();
    }
  }
}

class _HiveFormFields extends ConsumerStatefulWidget {
  const new(this.provider, {required this.isNew});

  final HiveFormControllerProvider provider;
  final bool isNew;

  @override
  ConsumerState<_HiveFormFields> createState() => _HiveFormFieldsState();
}

class _HiveFormFieldsState extends ConsumerState<_HiveFormFields> {
  late final _number = TextEditingController(
    text: ref.read(widget.provider).value!.number,
  );

  @override
  void dispose() {
    _number.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final form = ref.watch(widget.provider).value;
    if (form == null) return const SizedBox.shrink();
    final controller = ref.read(widget.provider.notifier);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _number,
          autofocus: widget.isNew,
          textInputAction: TextInputAction.done,
          style: context.typography.body,
          decoration: InputDecoration(
            labelText: l10n.hiveFormNumber,
            hintText: l10n.hiveFormNumberHint,
          ),
          onChanged: controller.updateNumber,
        ),
        SizedBox(height: spacing.lg),
        HiveTypeField(selected: form.type, onChanged: controller.selectType),
        SizedBox(height: spacing.lg),
        SectionCard(
          title: l10n.hiveFormStatus,
          child: ChoiceChipGroup<HiveStatus>(
            options: [
              for (final status in HiveStatus.values)
                ChoiceChipOption(value: status, label: status.label(l10n)),
            ],
            selected: {form.status},
            onChanged: (selected) {
              if (selected.isNotEmpty) {
                controller.selectStatus(selected.single);
              }
            },
          ),
        ),
        SizedBox(height: spacing.lg),
        HiveSourceField(
          selected: form.source,
          onChanged: controller.selectSource,
        ),
      ],
    );
  }
}

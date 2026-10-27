import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/migration/domain/migration.dart';
import 'package:mobil_arici/features/migration/presentation/migration_form_controller.dart';
import 'package:mobil_arici/features/migration/presentation/migration_providers.dart';

/// Göç planı ekleme ([migrationId] null) ve düzenleme: yıl ve ad;
/// düzenlemede "Planı sil". Yeni plan kaydedilince zaman çizelgesi açılır.
class MigrationFormScreen extends ConsumerWidget {
  const new({super.key, this.migrationId});

  final String? migrationId;

  MigrationFormControllerProvider _provider(AppLocalizations l10n) =>
      migrationFormControllerProvider(
        migrationId,
        defaultName: l10n.migrationFormDefaultName,
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final provider = _provider(l10n);
    final title = Text(
      migrationId == null
          ? l10n.migrationFormNewTitle
          : l10n.migrationFormEditTitle,
    );

    return switch (ref.watch(provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _MigrationFormFields(provider, form),
              if (migrationId case final id?) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.migrationFormDelete,
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
    final saved = await ref.read(_provider(l10n).notifier).save();
    if (saved == null || !context.mounted) return;
    // Yeni planın zaman çizelgesi açılır; bildirim "Durak ekle"yi örtmesin.
    if (migrationId == null) {
      context.go(AppRoutes.migration(saved.id));
    } else {
      showMessageSnackBar(context, l10n.migrationSaved);
      context.pop();
    }
  }

  Future<void> _delete(BuildContext context, WidgetRef ref, String id) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.migrationDeleteTitle,
      message: l10n.migrationDeleteMessage,
      confirmLabel: l10n.migrationDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(migrationActionsProvider.notifier).deleteMigration(id);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.migrationDeleted);
    context.go(AppRoutes.migrations);
  }
}

class _MigrationFormFields extends ConsumerStatefulWidget {
  const new(this.provider, this.form);

  final MigrationFormControllerProvider provider;
  final MigrationFormState form;

  @override
  ConsumerState<_MigrationFormFields> createState() =>
      _MigrationFormFieldsState();
}

class _MigrationFormFieldsState extends ConsumerState<_MigrationFormFields> {
  late final _name = TextEditingController(text: widget.form.name);

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  MigrationFormController get _controller => ref.read(widget.provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LabeledField(
          label: l10n.migrationFormName,
          child: TextField(
            controller: _name,
            maxLength: maxMigrationNameLength,
            textCapitalization: TextCapitalization.sentences,
            decoration: const InputDecoration(counterText: ''),
            onChanged: _controller.setName,
          ),
        ),
        SizedBox(height: context.spacing.xl),
        BigStepper(
          label: l10n.migrationFormYear,
          value: widget.form.year,
          min: minMigrationYear,
          max: maxMigrationYear,
          onChanged: _controller.setYear,
        ),
      ],
    );
  }
}

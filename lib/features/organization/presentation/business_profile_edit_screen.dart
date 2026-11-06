import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/region/region_provider.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_action_row.dart';
import 'package:mobil_arici/features/organization/domain/business_profile.dart';
import 'package:mobil_arici/features/organization/domain/organization.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_form_controller.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_providers.dart';
import 'package:mobil_arici/features/organization/presentation/business_profile_screen.dart';
import 'package:mobil_arici/features/organization/presentation/widgets/business_avatar.dart';
import 'package:mobil_arici/features/organization/presentation/widgets/currency_picker.dart';
import 'package:mobil_arici/features/team/presentation/team_providers.dart';

/// İşletme profilini düzenleme (`/more/business/edit`): tam ekran form,
/// üstte İptal ve Kaydet. Alanlar: işletme adı, ad soyad, avatar rengi ya
/// da logo, tür (gezginci / sabit), para birimi. Sayılar, ilk kayıt, rol,
/// e-posta ve ülke burada değişmez. Kaydetmeden çıkılırsa değişiklikleri
/// atmak sorulur; gezginciden sabite geçiş gizlenecek kayıtları sayarak
/// onay ister. Owner ve partner dışındakilere salt okunur açılır. Yazma
/// yerel DB'ye ve outbox'a gider, offline da kaydedilir.
class BusinessProfileEditScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canEdit = ref.watch(canEditOrganizationProvider);
    final hasProfile = ref.watch(
      businessProfileProvider.select((profile) => profile != null),
    );
    if (!hasProfile) {
      final l10n = AppLocalizations.of(context);
      return Scaffold(
        appBar: AppBar(title: Text(l10n.businessEditTitle)),
        body: Center(
          child: EmptyState(
            icon: Icons.storefront_outlined,
            title: l10n.businessMissingTitle,
            message: l10n.businessMissingMessage,
          ),
        ),
      );
    }
    return canEdit ? const _EditForm() : const _ReadOnlyForm();
  }
}

class _EditForm extends ConsumerStatefulWidget {
  const new();

  @override
  ConsumerState<_EditForm> createState() => _EditFormState();
}

class _EditFormState extends ConsumerState<_EditForm> {
  late final BusinessProfileFields _fields = ref
      .read(businessProfileFormControllerProvider)
      .fields;
  late final _name = TextEditingController(text: _fields.name);
  late final _fullName = TextEditingController(text: _fields.fullName);

  /// Kaydedildi; çıkış artık sorulmaz.
  var _done = false;

  @override
  void dispose() {
    _name.dispose();
    _fullName.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(businessProfileFormControllerProvider.notifier);
    final form = ref.read(businessProfileFormControllerProvider);
    if (!form.canSave) return;
    if (form.needsTypeConfirmation) {
      final counts = await controller.migratoryRecordCounts();
      if (!mounted) return;
      final confirmed = await showConfirmDialog(
        context,
        title: l10n.businessTypeConfirmTitle,
        message: l10n.businessTypeConfirmMessage(counts.plans, counts.stops),
        confirmLabel: l10n.businessTypeConfirmAction,
      );
      if (!confirmed || !mounted) return;
    }
    final saved = await controller.save();
    if (!mounted) return;
    if (!saved) {
      showMessageSnackBar(context, l10n.businessSaveError);
      return;
    }
    setState(() => _done = true);
    context.pop();
  }

  Future<void> _leave() async {
    final l10n = AppLocalizations.of(context);
    final dirty = ref.read(businessProfileFormControllerProvider).dirty;
    if (dirty) {
      final discard = await showConfirmDialog(
        context,
        title: l10n.businessDiscardTitle,
        message: l10n.businessDiscardMessage,
        confirmLabel: l10n.businessDiscardAction,
      );
      if (!discard || !mounted) return;
    }
    setState(() => _done = true);
    context.pop();
  }

  Future<void> _pickLogo() async {
    try {
      await ref.read(businessProfileFormControllerProvider.notifier).pickLogo();
    } on MediaCaptureException catch (error) {
      if (mounted) {
        showMediaCaptureFailure(context, error.failure, MediaKind.photo);
      }
    }
  }

  Future<void> _pickCurrency(String current) async {
    final picked = await showCurrencyPicker(
      context,
      selected: current,
      regionDefault: ref.read(regionConfigProvider).currencyCode,
    );
    if (picked != null) {
      ref
          .read(businessProfileFormControllerProvider.notifier)
          .setCurrency(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final form = ref.watch(businessProfileFormControllerProvider);
    final controller = ref.read(businessProfileFormControllerProvider.notifier);
    final fields = form.fields;

    return PopScope(
      canPop: _done || !form.dirty,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) unawaited(_leave());
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: context.touchTargets.button * 2,
          leading: TextButton(
            onPressed: _leave,
            style: TextButton.styleFrom(
              minimumSize: Size.square(context.touchTargets.button),
            ),
            child: Text(l10n.businessCancel),
          ),
          title: Text(l10n.businessEditTitle),
          actions: [
            TextButton(
              onPressed: form.canSave ? _save : null,
              style: TextButton.styleFrom(
                minimumSize: Size.square(context.touchTargets.button),
              ),
              child: Text(l10n.businessSave),
            ),
          ],
        ),
        body: KeyboardDismissArea(
          child: ListView(
            padding: EdgeInsets.all(spacing.lg),
            children: [
              LabeledField(
                label: l10n.businessNameLabel,
                child: TextField(
                  controller: _name,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  onChanged: controller.setName,
                ),
              ),
              SizedBox(height: spacing.xl),
              _AvatarField(fields: fields, onPickLogo: _pickLogo),
              SizedBox(height: spacing.xl),
              LabeledField(
                label: l10n.businessType,
                group: true,
                helper: l10n.businessTypeHelp,
                child: ChoiceChipGroup<OperationType>(
                  columns: 2,
                  options: [
                    ChoiceChipOption(
                      value: OperationType.migratory,
                      label: l10n.businessTypeMigratory,
                    ),
                    ChoiceChipOption(
                      value: OperationType.stationary,
                      label: l10n.businessTypeStationary,
                    ),
                  ],
                  selected: {fields.operationType},
                  onChanged: (types) {
                    if (types.singleOrNull case final type?) {
                      controller.setOperationType(type);
                    }
                  },
                ),
              ),
              SizedBox(height: spacing.xl),
              LabeledField(
                label: l10n.businessCurrency,
                group: true,
                child: ListGroup(
                  children: [
                    ListRow(
                      title: fields.currency,
                      onTap: () => _pickCurrency(fields.currency),
                    ),
                  ],
                ),
              ),
              if (form.currencyChanged) ...[
                SizedBox(height: spacing.sm),
                NoteCard(
                  icon: Icons.info_outline_rounded,
                  message: l10n.businessCurrencyNote,
                ),
              ],
              SizedBox(height: spacing.xl),
              LabeledField(
                label: l10n.businessFullNameLabel,
                helper: l10n.businessFullNameHelp,
                child: TextField(
                  controller: _fullName,
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.done,
                  maxLength: maxFullNameLength,
                  onChanged: controller.setFullName,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Avatar: önizleme, renk seçimi ve logo yükleme/kaldırma. Renk seçmek
/// logoyu kaldırır.
class _AvatarField extends ConsumerWidget {
  const new({required this.fields, required this.onPickLogo});

  final BusinessProfileFields fields;
  final VoidCallback onPickLogo;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final controller = ref.read(businessProfileFormControllerProvider.notifier);
    final logoPath = fields.logoPath;

    return LabeledField(
      label: l10n.businessAvatarLabel,
      group: true,
      helper: l10n.businessAvatarHelp,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.md,
        children: [
          Row(
            children: [
              BusinessAvatar(
                name: fields.name,
                color: fields.avatarColor,
                logoPath: logoPath,
                dimension: context.touchTargets.fieldLarge,
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: logoPath == null
                    ? BigButton(
                        label: l10n.businessLogoUpload,
                        variant: BigButtonVariant.secondary,
                        onPressed: onPickLogo,
                      )
                    : BigButton(
                        label: l10n.businessLogoRemove,
                        variant: BigButtonVariant.secondary,
                        onPressed: controller.removeLogo,
                      ),
              ),
            ],
          ),
          ChoiceChipGroup<OrgAvatarColor>(
            columns: 2,
            options: [
              for (final color in OrgAvatarColor.values)
                ChoiceChipOption(
                  value: color,
                  label: avatarColorLabel(l10n, color),
                ),
            ],
            selected: {
              if (logoPath == null) fields.avatarColor ?? defaultAvatarColor,
            },
            onChanged: (colors) {
              if (colors.singleOrNull case final color?) {
                controller.setAvatarColor(color);
              }
            },
          ),
        ],
      ),
    );
  }
}

String avatarColorLabel(AppLocalizations l10n, OrgAvatarColor color) =>
    switch (color) {
      OrgAvatarColor.pine => l10n.businessAvatarPine,
      OrgAvatarColor.honey => l10n.businessAvatarHoney,
      OrgAvatarColor.sky => l10n.businessAvatarSky,
      OrgAvatarColor.slate => l10n.businessAvatarSlate,
    };

/// İşçi ve danışman: alanlar salt okunur, Kaydet yok. Rotaya elle
/// gidilince çökmez, düzenleme yapılamaz.
class _ReadOnlyForm extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final profile = ref.watch(businessProfileProvider)!;
    final member = ref.watch(ownMemberProfileProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.businessEditTitle)),
      body: ListView(
        padding: EdgeInsets.all(spacing.lg),
        children: [
          NoteCard(
            icon: Icons.lock_outline_rounded,
            message: l10n.businessReadOnly,
          ),
          SizedBox(height: spacing.lg),
          Row(
            children: [
              BusinessAvatar(
                name: profile.name,
                color: profile.avatarColor,
                logoPath: profile.logoPath,
                dimension: context.touchTargets.fieldLarge,
              ),
              SizedBox(width: spacing.lg),
              Expanded(
                child: Text(profile.name, style: context.typography.title),
              ),
            ],
          ),
          SizedBox(height: spacing.lg),
          ListGroup(
            children: [
              ListRow(
                title: l10n.businessType,
                value: operationTypeLabel(l10n, profile.operationType),
              ),
              ListRow(title: l10n.businessCurrency, value: profile.currency),
              ListRow(
                title: l10n.businessFullNameLabel,
                value: member?.fullName ?? '–',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

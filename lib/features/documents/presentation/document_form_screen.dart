import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/documents/domain/document.dart';
import 'package:mobil_arici/features/documents/presentation/document_form_controller.dart';
import 'package:mobil_arici/features/documents/presentation/document_providers.dart';
import 'package:mobil_arici/features/documents/presentation/widgets/document_labels.dart';
import 'package:mobil_arici/features/tasks/presentation/widgets/reminder_access_prompt.dart';

/// Geçerlilik tarihinin seçilebileceği en uzak yıl: bugünden bu kadar
/// sonra.
const _maxExpiryYears = 30;

/// Belge ekleme ([documentId] null) ve düzenleme: tür (TR profilinde hazır
/// liste, diğer bölgelerde kullanıcının yazdığı tür ve önceki türler), ad,
/// açıklama, geçerlilik tarihi (ya da süresiz) ve dosya (fotoğraf çek,
/// galeriden, PDF seç); düzenlemede Belgeyi sil. Kaydedince geçerlilik
/// tarihi varsa hatırlatma izinleri istenir.
class DocumentFormScreen extends ConsumerWidget {
  const new({super.key, this.documentId});

  final String? documentId;

  DocumentFormControllerProvider get _provider =>
      documentFormControllerProvider(documentId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final title = Text(
      documentId == null
          ? l10n.documentFormNewTitle
          : l10n.documentFormEditTitle,
    );

    return switch (ref.watch(_provider)) {
      AsyncData(value: final form?) => Scaffold(
        appBar: AppBar(leading: const CloseButton(), title: title),
        body: BottomActionLayout(
          separated: true,
          body: ListView(
            padding: EdgeInsets.all(context.spacing.lg),
            children: [
              _DocumentFormFields(this, form),
              if (documentId != null) ...[
                SizedBox(height: context.spacing.xl),
                BigButton(
                  label: l10n.documentFormDelete,
                  icon: Icons.delete_outline_rounded,
                  variant: BigButtonVariant.secondary,
                  onPressed: () => _delete(context, ref),
                ),
              ],
            ],
          ),
          action: BigButton(
            label: l10n.documentFormSave,
            onPressed: form.canSave ? () => _save(context, ref) : null,
          ),
        ),
      ),
      AsyncData() || AsyncError() => Scaffold(
        appBar: AppBar(title: title),
        body: Center(child: Text(l10n.documentNotFound)),
      ),
      // Yerel DB'den okunuyor; hemen gelir.
      AsyncValue() => Scaffold(appBar: AppBar(title: title)),
    };
  }

  Future<void> _save(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final saved = await ref.read(_provider.notifier).save();
    if (saved == null || !context.mounted) return;
    final permitted =
        saved.expiresOn == null || await requestReminderAccess(context, ref);
    if (!context.mounted) return;
    showMessageSnackBar(
      context,
      permitted ? l10n.documentSaved : l10n.documentReminderDenied,
    );
    context.pop();
  }

  Future<void> _delete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final document = await ref
        .read(documentRepositoryProvider)
        .findById(documentId!);
    if (document == null || !context.mounted) return;
    final confirmed = await showConfirmDialog(
      context,
      title: l10n.documentDeleteTitle,
      message: l10n.documentDeleteMessage,
      confirmLabel: l10n.documentDeleteConfirm,
    );
    if (!confirmed || !context.mounted) return;
    await ref.read(documentActionsProvider.notifier).delete(document);
    if (!context.mounted) return;
    showMessageSnackBar(context, l10n.documentDeleted);
    context.go(AppRoutes.documents);
  }
}

class _DocumentFormFields extends ConsumerStatefulWidget {
  const new(this.screen, this.form);

  final DocumentFormScreen screen;
  final DocumentFormState form;

  @override
  ConsumerState<_DocumentFormFields> createState() =>
      _DocumentFormFieldsState();
}

class _DocumentFormFieldsState extends ConsumerState<_DocumentFormFields> {
  late final _customType = TextEditingController(
    text: widget.form.customTypeName,
  );
  late final _name = TextEditingController(text: widget.form.name);
  late final _description = TextEditingController(
    text: widget.form.description,
  );

  @override
  void didUpdateWidget(_DocumentFormFields oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Ad türden doldurulunca alana da yazılsın.
    if (_name.text != widget.form.name) _name.text = widget.form.name;
    if (_customType.text != widget.form.customTypeName) {
      _customType.text = widget.form.customTypeName;
    }
  }

  @override
  void dispose() {
    _customType.dispose();
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  DocumentFormController get _controller =>
      ref.read(widget.screen._provider.notifier);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final format = AppFormat.of(context);
    final spacing = context.spacing;
    final form = widget.form;
    final inputStyle = context.typography.subtitle.copyWith(
      fontWeight: context.typography.body.fontWeight,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (form.type == DocumentType.custom)
          _customTypeField(l10n, inputStyle)
        else
          LabeledField(
            label: l10n.documentFormType,
            child: ChoiceChipGroup<DocumentType>(
              options: [
                for (final type in trDocumentTypes)
                  ChoiceChipOption(
                    value: type,
                    label: presetDocumentTypeLabel(l10n, type),
                  ),
              ],
              selected: {?form.type},
              onChanged: (selected) {
                // Seçili türe yeniden dokunmak seçimi kaldırmaz.
                if (selected.firstOrNull case final type?) {
                  _controller.setType(
                    type,
                    label: presetDocumentTypeLabel(l10n, type),
                  );
                }
              },
            ),
          ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.documentFormName,
          child: TextField(
            controller: _name,
            maxLength: maxDocumentNameLength,
            textCapitalization: TextCapitalization.sentences,
            style: inputStyle,
            decoration: InputDecoration(
              hintText: l10n.documentFormNameHint,
              counterText: '',
            ),
            onChanged: _controller.setName,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.documentFormDescription,
          child: TextField(
            controller: _description,
            maxLength: maxDocumentDescriptionLength,
            minLines: 1,
            maxLines: 3,
            textCapitalization: TextCapitalization.sentences,
            style: inputStyle,
            decoration: InputDecoration(
              hintText: l10n.documentFormDescriptionHint,
              counterText: '',
            ),
            onChanged: _controller.setDescription,
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.documentFormExpiry,
          helper: form.expiresOn == null ? null : l10n.documentFormExpiryHelper,
          child: ChoiceChipGroup<bool>(
            options: [
              ChoiceChipOption(value: false, label: l10n.documentFormNoExpiry),
              ChoiceChipOption(
                value: true,
                label: switch (form.expiresOn) {
                  final day? => format.date(day),
                  null => l10n.documentFormPickDate,
                },
              ),
            ],
            selected: {form.expiresOn != null},
            onChanged: (selected) {
              if (selected.firstOrNull == false) {
                _controller.setExpiresOn(null);
              } else {
                // Seçili tarihe yeniden dokunmak da tarihi değiştirir.
                unawaited(_pickExpiry(context));
              }
            },
          ),
        ),
        SizedBox(height: spacing.xl),
        LabeledField(
          label: l10n.documentFormFile,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            spacing: spacing.md,
            children: [
              if (form.fileKind case final kind?)
                StatusMessage(
                  status: AppStatus.good,
                  message: [
                    documentFileKindLabel(l10n, kind),
                    documentFileSize(l10n, format, form.fileByteSize ?? 0),
                  ].join(' · '),
                )
              else
                Text(
                  l10n.documentFormNoFile,
                  style: context.typography.body.copyWith(
                    color: context.colors.textSecondary,
                  ),
                ),
              Wrap(
                spacing: spacing.md,
                runSpacing: spacing.md,
                children: [
                  BigButton(
                    label: l10n.documentFormTakePhoto,
                    icon: Icons.photo_camera_outlined,
                    variant: BigButtonVariant.secondary,
                    expanded: false,
                    onPressed: () =>
                        unawaited(_pick(context, _controller.takePhoto)),
                  ),
                  BigButton(
                    label: l10n.documentFormPickImage,
                    icon: Icons.photo_library_outlined,
                    variant: BigButtonVariant.secondary,
                    expanded: false,
                    onPressed: () =>
                        unawaited(_pick(context, _controller.pickImage)),
                  ),
                  BigButton(
                    label: l10n.documentFormPickPdf,
                    icon: Icons.picture_as_pdf_outlined,
                    variant: BigButtonVariant.secondary,
                    expanded: false,
                    onPressed: () =>
                        unawaited(_pick(context, _controller.pickPdf)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// Kullanıcı tanımlı tür: yazılan ad ve daha önce yazılmış türler.
  Widget _customTypeField(AppLocalizations l10n, TextStyle inputStyle) {
    final spacing = context.spacing;
    final suggestions =
        ref.watch(customDocumentTypeNamesProvider).value ?? const <String>[];
    return LabeledField(
      label: l10n.documentFormType,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: spacing.md,
        children: [
          TextField(
            controller: _customType,
            maxLength: maxDocumentTypeLength,
            textCapitalization: TextCapitalization.sentences,
            style: inputStyle,
            decoration: InputDecoration(
              hintText: l10n.documentFormCustomTypeHint,
              counterText: '',
            ),
            onChanged: _controller.setCustomTypeName,
          ),
          if (suggestions.isNotEmpty)
            ChoiceChipGroup<String>(
              suggested: true,
              options: [
                for (final name in suggestions)
                  ChoiceChipOption(value: name, label: name),
              ],
              selected: {
                for (final name in suggestions)
                  if (name == widget.form.customTypeName.trim()) name,
              },
              onChanged: (selected) {
                if (selected.firstOrNull case final name?) {
                  _controller.setCustomTypeName(name);
                }
              },
            ),
        ],
      ),
    );
  }

  Future<void> _pickExpiry(BuildContext context) async {
    final now = clock.now();
    final today = DateTime(now.year, now.month, now.day);
    final initial = widget.form.expiresOn ?? today;
    final first = initial.isBefore(today) ? initial : today;
    final day = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(first.year - 1, first.month, first.day),
      lastDate: DateTime(today.year + _maxExpiryYears, today.month, today.day),
    );
    if (day != null) _controller.setExpiresOn(day);
  }

  Future<void> _pick(BuildContext context, Future<void> Function() pick) async {
    final l10n = AppLocalizations.of(context);
    final String? problem;
    try {
      await pick();
      return;
    } on MediaCaptureException catch (error) {
      problem = switch (error.failure) {
        MediaCaptureFailure.permissionDenied =>
          l10n.documentFilePermissionDenied,
        MediaCaptureFailure.failed => l10n.documentFileFailed,
      };
    } on DocumentFileTooLargeException {
      problem = l10n.documentFileTooLarge;
    } on Exception {
      // Dosya kopyalanamadı (yer yok, okunamadı).
      problem = l10n.documentFileFailed;
    }
    if (context.mounted) showMessageSnackBar(context, problem);
  }
}

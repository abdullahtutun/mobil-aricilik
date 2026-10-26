import 'dart:io';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/features/feedback/domain/feedback.dart';
import 'package:mobil_arici/features/feedback/domain/feedback_rules.dart';
import 'package:mobil_arici/features/feedback/presentation/feedback_form_controller.dart';

/// "Görüş bildir" (docs/design "Görüş bildir"): konu, mesaj, isteğe bağlı
/// ekran görüntüsü (galeriden) ve cihaz bilgisi. Görüş yerel kuyruğa
/// yazılır; internet yoksa bağlanınca gider. Tasarımdaki "Sesle anlat"
/// yok (kullanıcı kararı).
class FeedbackScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final colors = context.colors;
    final form = ref.watch(feedbackFormControllerProvider);
    final controller = ref.read(feedbackFormControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.feedbackTitle),
      ),
      body: BottomActionLayout(
        separated: true,
        body: ListView(
          padding: EdgeInsets.all(spacing.lg),
          children: [
            Text(
              l10n.feedbackIntro,
              style: context.typography.body.copyWith(
                color: colors.textSecondary,
              ),
            ),
            SizedBox(height: spacing.xl),
            LabeledField(
              label: l10n.feedbackKindLabel,
              group: true,
              child: ChoiceChipGroup<FeedbackKind>(
                options: [
                  for (final kind in FeedbackKind.values)
                    ChoiceChipOption(
                      value: kind,
                      label: _kindLabel(l10n, kind),
                    ),
                ],
                selected: {form.kind},
                onChanged: (selected) {
                  // Her zaman bir konu seçili; seçili chip'e yeniden dokunmak
                  // seçimi kaldırmasın.
                  if (selected.isEmpty) return;
                  controller.setKind(selected.single);
                },
              ),
            ),
            SizedBox(height: spacing.xl),
            LabeledField(
              label: l10n.feedbackMessageLabel,
              child: TextField(
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                minLines: 5,
                maxLines: null,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(feedbackMessageMaxLength),
                ],
                style: context.typography.body,
                decoration: InputDecoration(hintText: l10n.feedbackMessageHint),
                onChanged: controller.setMessage,
              ),
            ),
            SizedBox(height: spacing.lg),
            const _Screenshot(),
            SizedBox(height: spacing.md),
            CheckboxListTile(
              value: form.includeDeviceInfo,
              onChanged: (include) =>
                  controller.setIncludeDeviceInfo(include: include ?? false),
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.feedbackIncludeDeviceInfo,
                style: context.typography.body,
              ),
            ),
            SizedBox(height: spacing.md),
            Text(
              l10n.feedbackOfflineHint,
              style: context.typography.bodySmall.copyWith(
                color: colors.textSecondary,
              ),
            ),
          ],
        ),
        action: BigButton(
          label: l10n.feedbackSend,
          onPressed: form.canSend ? () => _send(context, ref) : null,
        ),
      ),
    );
  }

  Future<void> _send(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toLanguageTag();
    final queued = await ref
        .read(feedbackFormControllerProvider.notifier)
        .send(locale: locale);
    if (!queued || !context.mounted) return;
    showMessageSnackBar(context, l10n.feedbackQueued);
    context.pop();
  }

  static String _kindLabel(AppLocalizations l10n, FeedbackKind kind) =>
      switch (kind) {
        FeedbackKind.bug => l10n.feedbackKindBug,
        FeedbackKind.suggestion => l10n.feedbackKindSuggestion,
        FeedbackKind.missingFeature => l10n.feedbackKindMissingFeature,
        FeedbackKind.thanks => l10n.feedbackKindThanks,
      };
}

/// Ekran görüntüsü yokken galeriyi açan buton; varken küçük resim ve
/// "Kaldır".
class _Screenshot extends ConsumerWidget {
  const new();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final spacing = context.spacing;
    final path = ref.watch(
      feedbackFormControllerProvider.select((form) => form.screenshotPath),
    );
    final controller = ref.read(feedbackFormControllerProvider.notifier);

    Future<void> pick() async {
      try {
        await controller.pickScreenshot();
      } on MediaCaptureException catch (error) {
        if (!context.mounted) return;
        showMessageSnackBar(
          context,
          error.failure == MediaCaptureFailure.permissionDenied
              ? l10n.feedbackScreenshotDenied
              : l10n.mediaCaptureFailed,
        );
      }
    }

    if (path == null) {
      return BigButton(
        variant: BigButtonVariant.secondary,
        icon: Icons.image_outlined,
        label: l10n.feedbackAddScreenshot,
        onPressed: pick,
      );
    }

    final size = math.max(
      context.sizes.mediaThumbnail,
      context.touchTargets.fieldLarge,
    );
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(context.radii.button),
          child: Image.file(
            File(path),
            width: size,
            height: size,
            fit: BoxFit.cover,
            cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
            semanticLabel: l10n.feedbackScreenshotAttached,
          ),
        ),
        SizedBox(width: spacing.md),
        Expanded(
          child: Text(
            l10n.feedbackScreenshotAttached,
            style: context.typography.body,
          ),
        ),
        SizedBox(width: spacing.sm),
        BigButton(
          variant: BigButtonVariant.secondary,
          expanded: false,
          label: l10n.feedbackRemoveScreenshot,
          onPressed: controller.removeScreenshot,
        ),
      ],
    );
  }
}

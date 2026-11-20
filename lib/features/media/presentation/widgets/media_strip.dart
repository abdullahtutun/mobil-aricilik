import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:mobil_arici/features/media/presentation/media_controllers.dart';

/// Zaman tünelinde bir olayın fotoğrafları (küçük resim) ve sesli notları
/// (Dinle butonu), çekilme sırasıyla.
class MediaStrip extends StatelessWidget {
  const new(this.media, {super.key});

  final List<MediaItem> media;

  @override
  Widget build(BuildContext context) {
    final gap = context.touchTargets.gap;
    return Wrap(
      spacing: gap,
      runSpacing: gap,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        for (final item in media)
          switch (item.kind) {
            MediaKind.photo => MediaThumbnail(item, key: ValueKey(item.id)),
            MediaKind.audio => VoiceNoteButton(item, key: ValueKey(item.id)),
          },
      ],
    );
  }
}

/// Fotoğrafın kare küçük resmi; dokununca tam ekran açılır. Fotoğraf başka
/// telefonda çekildiyse telefon ikonu görünür, dokununca nedeni söylenir
/// (dosyalar sunucuya yüklenmez).
class MediaThumbnail extends ConsumerWidget {
  const new(this.media, {super.key});

  final MediaItem media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final size = math.max(
      context.sizes.mediaThumbnail,
      context.touchTargets.fieldLarge,
    );
    final radius = BorderRadius.circular(context.radii.button);
    final file = ref.watch(mediaFileProvider(media));

    final (Widget child, String label, VoidCallback? onTap) = switch (file) {
      AsyncData(value: final file?) => (
        Image.file(
          file,
          fit: BoxFit.cover,
          cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
        ),
        l10n.mediaOpenPhoto,
        () => unawaited(context.push(AppRoutes.mediaPhoto(media.id))),
      ),
      // Yerel dosya; hemen gelir.
      AsyncLoading() => (const SizedBox.shrink(), l10n.mediaOpenPhoto, null),
      _ => (
        Icon(
          Icons.phone_android_outlined,
          size: context.sizes.icon,
          color: colors.textSecondary,
        ),
        l10n.mediaPhotoElsewhere,
        () => showMessageSnackBar(context, l10n.mediaElsewhere),
      ),
    };

    // Kendi düğümü olsun; yoksa tünelin başlığıyla birleşip "Geçmiş"
    // başlığı buton gibi okunur.
    return Semantics(
      container: true,
      button: true,
      label: label,
      excludeSemantics: true,
      child: SizedBox.square(
        dimension: size,
        child: Material(
          color: colors.surfaceContainer,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(
              color: colors.divider,
              width: context.strokes.border,
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

/// Sesli notu çalar ya da durdurur ("Dinle · 0:12" / "Durdur"). Not bu
/// telefonda yoksa (başka telefonda kaydedildi) nedeni söylenir.
class VoiceNoteButton extends ConsumerWidget {
  const new(this.media, {super.key});

  final MediaItem media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final playing = ref.watch(voicePlaybackProvider) == media.id;
    final file = ref.watch(mediaFileProvider(media));
    final duration = formatVoiceDuration(
      Duration(milliseconds: media.durationMs ?? 0),
    );

    return BigButton(
      variant: BigButtonVariant.secondary,
      expanded: false,
      icon: playing ? Icons.stop_rounded : Icons.play_arrow_rounded,
      label: playing ? l10n.mediaStopPlaying : l10n.mediaPlay(duration),
      onPressed: file.isLoading
          ? null
          : () => unawaited(_toggle(context, ref, playing: playing)),
    );
  }

  Future<void> _toggle(
    BuildContext context,
    WidgetRef ref, {
    required bool playing,
  }) async {
    final playback = ref.read(voicePlaybackProvider.notifier);
    if (playing) {
      await playback.stop();
      return;
    }
    final file = await ref.read(mediaFileProvider(media).future);
    if (file == null) {
      if (context.mounted) {
        showMessageSnackBar(
          context,
          AppLocalizations.of(context).mediaElsewhere,
        );
      }
      return;
    }
    await playback.play(media, file);
  }
}

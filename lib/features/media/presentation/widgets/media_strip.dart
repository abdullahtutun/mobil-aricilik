import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/sync/media_sync_service.dart';
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
/// telefonda çekildiyse ve henüz inmediyse indirme ikonu görünür, dokununca
/// iner.
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
    final file = ref.watch(mediaFileControllerProvider(media));

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
      AsyncLoading() => (
        Center(
          child: SizedBox.square(
            dimension: context.sizes.icon,
            child: const CircularProgressIndicator(),
          ),
        ),
        l10n.mediaDownloadPhoto,
        null,
      ),
      _ => (
        Icon(
          Icons.cloud_download_outlined,
          size: context.sizes.icon,
          color: colors.textSecondary,
        ),
        l10n.mediaDownloadPhoto,
        () => unawaited(downloadMedia(context, ref, media)),
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
/// telefonda yoksa önce iner.
class VoiceNoteButton extends ConsumerWidget {
  const new(this.media, {super.key});

  final MediaItem media;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final playing = ref.watch(voicePlaybackProvider) == media.id;
    final file = ref.watch(mediaFileControllerProvider(media));
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
    final provider = mediaFileControllerProvider(media);
    var file = await ref.read(provider.future);
    if (file == null) {
      if (!context.mounted || !await downloadMedia(context, ref, media)) {
        return;
      }
      file = ref.read(provider).value;
    }
    if (file != null) await playback.play(media, file);
  }
}

/// [media]'yı indirir; olmazsa nedenini bildirimle söyler. İndiyse true.
Future<bool> downloadMedia(
  BuildContext context,
  WidgetRef ref,
  MediaItem media,
) async {
  final l10n = AppLocalizations.of(context);
  final failure = await ref
      .read(mediaFileControllerProvider(media).notifier)
      .download();
  if (failure == null) return true;
  if (context.mounted) {
    showMessageSnackBar(context, switch (failure) {
      MediaDownloadFailure.notUploaded => l10n.mediaNotUploaded,
      MediaDownloadFailure.offline => l10n.mediaDownloadOffline,
      MediaDownloadFailure.failed => l10n.mediaDownloadFailed,
    });
  }
  return false;
}

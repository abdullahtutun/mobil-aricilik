import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/utils/app_format.dart';
import 'package:mobil_arici/features/media/presentation/media_controllers.dart';
import 'package:mobil_arici/features/media/presentation/media_providers.dart';
import 'package:mobil_arici/features/media/presentation/widgets/media_strip.dart';

/// Fotoğrafın tam ekranı; iki parmakla yakınlaşır. Üst çubukta çekildiği
/// zaman. Dosya bu telefonda yoksa küçük resmin indirme düğmesi çıkar.
class MediaViewerScreen extends ConsumerWidget {
  const new({required this.mediaId, super.key});

  final String mediaId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final media = ref.watch(mediaItemProvider(mediaId));

    return switch (media) {
      AsyncData(value: final media?) => Scaffold(
        appBar: AppBar(
          title: Text(
            AppFormat.of(context).dateTime(media.capturedAt.toLocal()),
          ),
        ),
        body: switch (ref.watch(mediaFileControllerProvider(media))) {
          AsyncData(value: final file?) => InteractiveViewer(
            maxScale: 5,
            child: Center(
              child: Image.file(file, semanticLabel: l10n.timelinePhoto),
            ),
          ),
          _ => Center(child: MediaThumbnail(media)),
        },
      ),
      AsyncData() => Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.mediaNotFound)),
      ),
      AsyncValue() => Scaffold(appBar: AppBar()),
    };
  }
}

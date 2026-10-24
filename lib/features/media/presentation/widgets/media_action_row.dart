import 'dart:async';

import 'package:clock/clock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/camera_service.dart';
import 'package:mobil_arici/features/media/domain/media_item.dart';
import 'package:mobil_arici/features/media/domain/media_rules.dart';
import 'package:mobil_arici/features/media/presentation/media_controllers.dart';

/// Ekranın altındaki eylem satırı: foto ve mikrofon butonları, yanında
/// genişleyen birincil [action] (Muayene başlat, Kaydet). Kayıt sürerken
/// üstünde süreyle "Kaydediliyor" şeridi çıkar.
///
/// [target] kaydın sahibi ekran (kovan kartı, muayene); ekran kapanınca
/// süren kayıt atılır. Çekilen foto ya da biten kayıt [onCaptured]'a
/// gelir. [voiceFirst] mikrofonu fotoğrafın önüne alır (muayene tasarımı).
class MediaActionRow extends StatelessWidget {
  const new({
    required this.target,
    required this.onCaptured,
    required this.action,
    super.key,
    this.voiceFirst = false,
  });

  final String target;
  final Future<void> Function(MediaCapture capture) onCaptured;
  final Widget action;
  final bool voiceFirst;

  @override
  Widget build(BuildContext context) {
    final gap = SizedBox(width: context.touchTargets.gap);
    final photo = _PhotoButton(onCaptured: onCaptured);
    final voice = _VoiceButton(target: target, onCaptured: onCaptured);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _RecordingBanner(target),
        Row(
          children: [
            if (voiceFirst) ...[voice, gap, photo] else ...[photo, gap, voice],
            gap,
            Expanded(child: action),
          ],
        ),
      ],
    );
  }
}

/// Kamerayı açar; kamera açıkken yeniden dokunulamaz.
class _PhotoButton extends ConsumerStatefulWidget {
  const new({required this.onCaptured});

  final Future<void> Function(MediaCapture capture) onCaptured;

  @override
  ConsumerState<_PhotoButton> createState() => _PhotoButtonState();
}

class _PhotoButtonState extends ConsumerState<_PhotoButton> {
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    return BigIconButton(
      icon: Icons.photo_camera_outlined,
      label: AppLocalizations.of(context).mediaTakePhoto,
      onPressed: _busy ? null : _take,
    );
  }

  Future<void> _take() async {
    setState(() => _busy = true);
    try {
      final capture = await ref.read(mediaActionsProvider.notifier).takePhoto();
      if (capture != null && mounted) await widget.onCaptured(capture);
    } on MediaCaptureException catch (error) {
      if (mounted) _showFailure(context, error.failure, MediaKind.photo);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

/// Mikrofon: dokununca kayıt başlar, buton "Kaydı bitir"e döner.
class _VoiceButton extends ConsumerStatefulWidget {
  const new({required this.target, required this.onCaptured});

  final String target;
  final Future<void> Function(MediaCapture capture) onCaptured;

  @override
  ConsumerState<_VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends ConsumerState<_VoiceButton> {
  var _busy = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final recording =
        ref.watch(voiceRecordingControllerProvider(widget.target)) != null;

    return BigIconButton(
      icon: recording ? Icons.stop_rounded : Icons.mic_none_rounded,
      label: recording ? l10n.mediaStopRecording : l10n.mediaRecordVoice,
      active: recording,
      onPressed: _busy ? null : (recording ? _stop : _start),
    );
  }

  VoiceRecordingController get _controller =>
      ref.read(voiceRecordingControllerProvider(widget.target).notifier);

  Future<void> _start() => _run(() async {
    try {
      await _controller.start();
    } on MediaCaptureException catch (error) {
      if (mounted) _showFailure(context, error.failure, MediaKind.audio);
    }
  });

  Future<void> _stop() => _run(() async {
    final capture = await _controller.stop();
    if (!mounted) return;
    if (capture == null) {
      _showFailure(context, MediaCaptureFailure.failed, MediaKind.audio);
      return;
    }
    await widget.onCaptured(capture);
  });

  Future<void> _run(Future<void> Function() action) async {
    setState(() => _busy = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }
}

void _showFailure(
  BuildContext context,
  MediaCaptureFailure failure,
  MediaKind kind,
) {
  final l10n = AppLocalizations.of(context);
  showMessageSnackBar(context, switch ((failure, kind)) {
    (MediaCaptureFailure.permissionDenied, MediaKind.photo) =>
      l10n.mediaCameraDenied,
    (MediaCaptureFailure.permissionDenied, MediaKind.audio) =>
      l10n.mediaMicrophoneDenied,
    (MediaCaptureFailure.failed, _) => l10n.mediaCaptureFailed,
  });
}

/// Kayıt sürerken kırmızı nokta ve geçen süre. Ekran okuyucu için kaydın
/// sürdüğünü mikrofon butonunun adı ("Kaydı bitir") söyler; her saniye
/// değişen süre duyurulmaz.
class _RecordingBanner extends ConsumerStatefulWidget {
  const new(this.target);

  final String target;

  @override
  ConsumerState<_RecordingBanner> createState() => _RecordingBannerState();
}

class _RecordingBannerState extends ConsumerState<_RecordingBanner> {
  Timer? _ticker;

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final recording = ref.watch(
      voiceRecordingControllerProvider(widget.target),
    );
    if (recording == null) {
      _ticker?.cancel();
      _ticker = null;
      return const SizedBox.shrink();
    }
    _ticker ??= Timer.periodic(
      const Duration(seconds: 1),
      (_) => setState(() {}),
    );
    final colors = context.colors;
    final elapsed = clock.now().difference(recording.startedAt);

    return Padding(
      padding: EdgeInsets.only(bottom: context.spacing.md),
      child: ExcludeSemantics(
        child: Row(
          children: [
            Icon(
              Icons.fiber_manual_record_rounded,
              size: context.sizes.iconSmall,
              color: colors.statusCritical,
            ),
            SizedBox(width: context.spacing.sm),
            Expanded(
              child: Text(
                AppLocalizations.of(context)
                    .mediaRecording(formatVoiceDuration(elapsed)),
                style: context.typography.label.copyWith(
                  color: colors.statusCritical,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

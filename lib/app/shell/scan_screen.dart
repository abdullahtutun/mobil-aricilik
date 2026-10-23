import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mobil_arici/app/routes.dart';
import 'package:mobil_arici/app/shell/scan_controller.dart';
import 'package:mobil_arici/core/design_system/design_system.dart';
import 'package:mobil_arici/core/l10n/generated/app_localizations.dart';
import 'package:mobil_arici/core/services/code_scanner_provider.dart';
import 'package:mobil_arici/core/utils/haptics.dart';
import 'package:mobil_arici/features/hives/presentation/widgets/unknown_label_view.dart';

/// Ortadaki Okut butonunun açtığı ekran: kovan etiketi okutulunca
/// titreşir ve kovan kartı açılır (geri tuşu arılığa döner). Tanınmayan
/// kodda kamera kapanır, ekran nedenini söyler ve etiketi bir kovana
/// atamayı sunar. NFC kendi adımında gelecek.
class ScanScreen extends ConsumerWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final controller = ref.read(scanControllerProvider.notifier);
    ref.listen(scanControllerProvider, (_, state) {
      if (state case ScanFound(:final hive)) {
        unawaited(AppHaptics.scanSuccess());
        context.go(AppRoutes.hive(hive.apiaryId, hive.id));
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text(l10n.scanTitle)),
      body: switch (ref.watch(scanControllerProvider)) {
        ScanUnknown(:final code) => UnknownLabelView(
          code: code,
          onScanAgain: controller.scanAgain,
        ),
        // Kart açılırken de kamera görünür kalır; ekran zaten kapanıyor.
        ScanWaiting() || ScanFound() => _Viewfinder(
          camera: ref.watch(codeScannerProvider)(controller.handle),
        ),
      },
    );
  }
}

/// Kamera, ortada kodun getirileceği çerçeve ve altta ne yapılacağı.
class _Viewfinder extends StatelessWidget {
  const new({required this.camera});

  final Widget camera;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;

    return Stack(
      fit: StackFit.expand,
      children: [
        camera,
        IgnorePointer(
          child: Center(
            child: SizedBox.square(
              dimension: context.sizes.scanWindow,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(context.radii.card),
                  border: Border.all(
                    color: colors.primary,
                    width: context.strokes.focus,
                  ),
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          start: spacing.lg,
          end: spacing.lg,
          bottom: spacing.xl,
          child: SafeArea(
            top: false,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colors.surface,
                borderRadius: BorderRadius.circular(context.radii.card),
              ),
              child: Padding(
                padding: EdgeInsets.all(spacing.md),
                child: Text(
                  AppLocalizations.of(context).scanHint,
                  textAlign: TextAlign.center,
                  style: context.typography.body,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

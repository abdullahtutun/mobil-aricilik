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

/// Ortadaki Okut butonunun açtığı ekran: koyu zeminde kamera ve bal sarısı
/// köşeli çerçeve. Kovan etiketi okutulunca
/// titreşir, kovan kartı ve üstünde hızlı muayene açılır (aktif olmayan
/// kovanda yalnız kart; geri tuşu arılığa döner). Tanınmayan
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
        context.go(AppRoutes.scannedHive(hive));
      }
    });

    final state = ref.watch(scanControllerProvider);
    final colors = context.colors;

    return switch (state) {
      ScanUnknown(:final code) => Scaffold(
        appBar: AppBar(title: Text(l10n.scanTitle)),
        body: UnknownLabelView(code: code, onScanAgain: controller.scanAgain),
      ),
      // Kart açılırken de kamera görünür kalır; ekran zaten kapanıyor.
      ScanWaiting() || ScanFound() => Scaffold(
        backgroundColor: colors.inverseSurface,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: colors.inverseSurface,
          surfaceTintColor: colors.inverseSurface,
          foregroundColor: colors.onInverseSurface,
          // Başlık ekran okuyucuda kalsın; görünürde çerçevenin altındaki
          // cümle anlatıyor.
          title: Text(
            l10n.scanTitle,
            style: context.typography.title.copyWith(
              color: colors.onInverseSurface,
            ),
          ),
          leading: Padding(
            padding: EdgeInsets.all(context.spacing.xs),
            child: IconButton.filled(
              tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
              // Derin linkle gelindiyse altında ekran yok; Bugün'e döner.
              onPressed: () => context.canPop()
                  ? context.pop()
                  : context.go(AppRoutes.today),
              style: IconButton.styleFrom(
                backgroundColor: colors.textPrimary,
                foregroundColor: colors.onInverseSurface,
              ),
              icon: const Icon(Icons.close_rounded),
            ),
          ),
        ),
        body: _Viewfinder(
          camera: ref.watch(codeScannerProvider)(controller.handle),
        ),
      ),
    };
  }
}

/// Kamera, ortada bal sarısı köşelerle kodun getirileceği çerçeve; altında
/// ne yapılacağı ve internet gerekmediği.
class _Viewfinder extends StatelessWidget {
  const new({required this.camera});

  final Widget camera;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = context.colors;
    final spacing = context.spacing;
    final window = context.sizes.scanWindow;

    return Stack(
      fit: StackFit.expand,
      children: [
        camera,
        SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(spacing.lg),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IgnorePointer(
                    child: CustomPaint(
                      size: Size.square(window),
                      painter: _CornersPainter(
                        color: colors.honey,
                        strokeWidth: context.strokes.focus * 2,
                        length: window / 5,
                        radius: context.radii.card,
                      ),
                    ),
                  ),
                  SizedBox(height: spacing.xl),
                  Text(
                    l10n.scanHint,
                    textAlign: TextAlign.center,
                    style: context.typography.subtitle.copyWith(
                      color: colors.onInverseSurface,
                    ),
                  ),
                  SizedBox(height: spacing.xs),
                  Text(
                    l10n.scanOfflineHint,
                    textAlign: TextAlign.center,
                    style: context.typography.body.copyWith(
                      color: colors.honey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Çerçevenin dört köşesi: yuvarlatılmış L'ler; kenarların ortası boş.
class _CornersPainter extends CustomPainter {
  const new({
    required this.color,
    required this.strokeWidth,
    required this.length,
    required this.radius,
  });

  final Color color;
  final double strokeWidth;

  /// Her kolun köşeden uzunluğu.
  final double length;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final inset = strokeWidth / 2;
    final left = inset;
    final top = inset;
    final right = size.width - inset;
    final bottom = size.height - inset;
    final arc = Radius.circular(radius);

    canvas
      ..drawPath(
        Path()
          ..moveTo(left, top + length)
          ..lineTo(left, top + radius)
          ..arcToPoint(Offset(left + radius, top), radius: arc)
          ..lineTo(left + length, top),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(right - length, top)
          ..lineTo(right - radius, top)
          ..arcToPoint(Offset(right, top + radius), radius: arc)
          ..lineTo(right, top + length),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(right, bottom - length)
          ..lineTo(right, bottom - radius)
          ..arcToPoint(Offset(right - radius, bottom), radius: arc)
          ..lineTo(right - length, bottom),
        paint,
      )
      ..drawPath(
        Path()
          ..moveTo(left + length, bottom)
          ..lineTo(left + radius, bottom)
          ..arcToPoint(Offset(left, bottom - radius), radius: arc)
          ..lineTo(left, bottom - length),
        paint,
      );
  }

  @override
  bool shouldRepaint(_CornersPainter oldDelegate) =>
      color != oldDelegate.color ||
      strokeWidth != oldDelegate.strokeWidth ||
      length != oldDelegate.length ||
      radius != oldDelegate.radius;
}

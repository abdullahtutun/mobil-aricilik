import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Uygulamanın logosu: yuvarlak petek ve arı rozeti
/// (`assets/branding/app_logo.png`, kaynağı `docs/mobil_arici_logo.png`).
/// Yalnız süstür; ekran okuyucu atlar.
class AppLogo extends StatelessWidget {
  const new({super.key});

  static const asset = 'assets/branding/app_logo.png';

  @override
  Widget build(BuildContext context) {
    final size = context.touchTargets.fieldLarge;

    return ExcludeSemantics(
      child: Image.asset(
        asset,
        width: size,
        height: size,
        // Ekrandaki boyuta göre çöz; 512 piksellik kaynak bellekte büyük
        // kalmasın.
        cacheWidth: (size * MediaQuery.devicePixelRatioOf(context)).round(),
      ),
    );
  }
}

/// Sivri tepeli altıgen: [center] çevresinde [radius] yarıçaplı.
Path hexagonPath(Offset center, double radius) {
  final path = Path();
  for (var i = 0; i < 6; i++) {
    final angle = -math.pi / 2 + i * math.pi / 3;
    final point = center + Offset(math.cos(angle), math.sin(angle)) * radius;
    if (i == 0) {
      path.moveTo(point.dx, point.dy);
    } else {
      path.lineTo(point.dx, point.dy);
    }
  }
  return path..close();
}

/// Giriş ekranlarının sağ üstündeki petek deseni: çizgi renginde gözler,
/// birinin içi bal sarısı. Yalnız süstür; dokunmayı ve ekran okuyucuyu
/// engellemez. Güneş modunda (kart zemini ekran zeminiyle aynı) çizilmez;
/// kalın siyah çizgiyle dikkat dağıtır.
class HoneycombBackdrop extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    if (colors.surfaceContainer == colors.surface) {
      return const SizedBox.shrink();
    }
    return IgnorePointer(
      child: ExcludeSemantics(
        child: CustomPaint(
          size: Size.square(context.sizes.honeycomb),
          painter: _HoneycombPainter(
            line: colors.divider,
            fill: colors.honey.withValues(alpha: 0.6),
            strokeWidth: context.strokes.focus,
          ),
        ),
      ),
    );
  }
}

class _HoneycombPainter extends CustomPainter {
  const new({
    required this.line,
    required this.fill,
    required this.strokeWidth,
  });

  final Color line;
  final Color fill;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    // Sivri tepeli gözler yan yana √3·r aralıkla, alt sıra yarım kaydırılır.
    final radius = size.width / 4;
    final step = math.sqrt(3) * radius;
    final cells = [
      Offset(size.width - step * 1.5, radius),
      Offset(size.width - step / 2, radius * 0.5),
      Offset(size.width - step, radius * 2),
      Offset(size.width, radius * 2),
      Offset(size.width - step / 2, radius * 3.5),
    ];
    final stroke = Paint()
      ..color = line
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    for (final (i, center) in cells.indexed) {
      final path = hexagonPath(center, radius);
      if (i == 2) canvas.drawPath(path, Paint()..color = fill);
      canvas.drawPath(path, stroke);
    }
  }

  @override
  bool shouldRepaint(_HoneycombPainter oldDelegate) =>
      line != oldDelegate.line ||
      fill != oldDelegate.fill ||
      strokeWidth != oldDelegate.strokeWidth;
}

import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobil_arici/features/weather/domain/weather_icons.dart';

/// Tasarımdaki çizgi hava simgesi (docs/design "Arılık havası · 7 gün"):
/// güneş, güneş + bulut, bulut, yağmur bulutu, rüzgar, kar tanesi. Material
/// ikon setinde güneşli bulut ve yağmur bulutu olmadığı için çizilir;
/// 24'lük ızgarada, [size] kadar.
class WeatherGlyph extends StatelessWidget {
  const new(
    this.icon, {
    required this.size,
    required this.color,
    super.key,
    this.semanticLabel,
  });

  final WeatherIcon icon;
  final double size;
  final Color color;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final glyph = SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: _GlyphPainter(icon, color)),
    );
    return semanticLabel == null
        ? ExcludeSemantics(child: glyph)
        : Semantics(label: semanticLabel, image: true, child: glyph);
  }
}

class _GlyphPainter extends CustomPainter {
  new(this.icon, this.color);

  final WeatherIcon icon;
  final Color color;

  /// Izgara birimi; simge 24 × 24.
  static const _grid = 24.0;

  @override
  void paint(Canvas canvas, Size size) {
    canvas
      ..save()
      ..scale(size.width / _grid);
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.8
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    switch (icon) {
      case WeatherIcon.sunny:
        _sun(canvas, stroke, const Offset(12, 12), 4, 6.5, 9);
      case WeatherIcon.partlyCloudy:
        final cloud = _cloud(const Offset(4.5, 4), 0.82);
        // Bulutun arkasında kalan güneş silinir; zemin rengi bilinmez.
        canvas.saveLayer(Offset.zero & const Size.square(_grid), Paint());
        _sun(canvas, stroke, const Offset(8.5, 8.5), 3, 4.8, 6.6);
        canvas
          ..drawPath(cloud, Paint()..blendMode = BlendMode.clear)
          ..drawPath(cloud, stroke)
          ..restore();
      case WeatherIcon.cloudy:
        canvas.drawPath(_cloud(const Offset(0, 0.5), 1), stroke);
      case WeatherIcon.rainy:
        canvas.drawPath(_cloud(const Offset(0, -3.5), 1), stroke);
        for (final x in [8.5, 12.5, 16.5]) {
          canvas.drawLine(Offset(x, 18), Offset(x - 1.2, 21.5), stroke);
        }
      case WeatherIcon.windy:
        canvas
          ..drawPath(
            Path()
              ..moveTo(3, 8.5)
              ..lineTo(13.5, 8.5)
              ..arcToPoint(
                const Offset(11, 4.5),
                radius: const Radius.circular(2.2),
                largeArc: true,
                clockwise: false,
              ),
            stroke,
          )
          ..drawPath(
            Path()
              ..moveTo(3, 12.5)
              ..lineTo(18, 12.5)
              ..arcToPoint(
                const Offset(15.5, 18),
                radius: const Radius.circular(2.8),
                largeArc: true,
              ),
            stroke,
          )
          ..drawLine(const Offset(3, 16.5), const Offset(10, 16.5), stroke);
      case WeatherIcon.other:
        const center = Offset(12, 12);
        for (var i = 0; i < 3; i++) {
          final angle = math.pi / 2 + i * math.pi / 3;
          final direction = Offset(math.cos(angle), math.sin(angle));
          canvas.drawLine(
            center - direction * 9,
            center + direction * 9,
            stroke,
          );
          for (final end in [-1, 1]) {
            final tip = center + direction * 6.5 * end.toDouble();
            final back = direction * 2.2 * end.toDouble();
            final side = Offset(-direction.dy, direction.dx) * 2.2;
            canvas
              ..drawLine(tip, tip + back + side, stroke)
              ..drawLine(tip, tip + back - side, stroke);
          }
        }
    }
    canvas.restore();
  }

  /// Merkezde [radius]'lık daire ve [inner]–[outer] arası sekiz ışın.
  static void _sun(
    Canvas canvas,
    Paint stroke,
    Offset center,
    double radius,
    double inner,
    double outer,
  ) {
    canvas.drawCircle(center, radius, stroke);
    for (var i = 0; i < 8; i++) {
      final angle = i * math.pi / 4;
      final direction = Offset(math.cos(angle), math.sin(angle));
      canvas.drawLine(
        center + direction * inner,
        center + direction * outer,
        stroke,
      );
    }
  }

  /// Düz tabanlı bulut (üç tümsek); [offset] kadar kaydırılmış, [scale]
  /// kadar büyütülmüş.
  static Path _cloud(Offset offset, double scale) {
    final shape = [
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(8, 14.5), radius: 4)),
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(12.5, 10.5), radius: 5)),
      Path()
        ..addOval(Rect.fromCircle(center: const Offset(17, 15), radius: 3.5)),
      Path()..addRect(const Rect.fromLTRB(8, 13, 17, 18.5)),
    ].reduce((a, b) => Path.combine(PathOperation.union, a, b));
    final matrix = Matrix4.identity()
      ..translateByDouble(offset.dx, offset.dy, 0, 1)
      ..scaleByDouble(scale, scale, 1, 1);
    return shape.transform(matrix.storage);
  }

  @override
  bool shouldRepaint(_GlyphPainter old) =>
      old.icon != icon || old.color != color;
}

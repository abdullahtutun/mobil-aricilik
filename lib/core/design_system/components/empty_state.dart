import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:mobil_arici/core/design_system/components/big_button.dart';
import 'package:mobil_arici/core/design_system/theme_context.dart';

/// Boş liste: ne işe yaradığını tek cümlede anlatır ve ilk eylemi sunar.
/// Üstte koyu bal çizgili petek gözü, altta içeriği kadar geniş buton.
class EmptyState extends StatelessWidget {
  const new({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.actionLabel,
    this.onAction,
    this.centered = false,
  }) : assert(
         (actionLabel == null) == (onAction == null),
         'eylem etiketi ve geri çağrısı birlikte verilmeli',
       );

  final IconData icon;
  final String title;

  /// Tek cümle: bu liste ne işe yarar.
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  /// Ekranın tek içeriği: ortalanır; küçük ekranda ya da büyük yazı
  /// boyutunda sığmazsa kayar.
  final bool centered;

  @override
  Widget build(BuildContext context) {
    final content = _content(context);
    if (!centered) return content;
    return Center(child: SingleChildScrollView(child: content));
  }

  Widget _content(BuildContext context) {
    final colors = context.colors;
    final spacing = context.spacing;
    final sizes = context.sizes;
    final actionLabel = this.actionLabel;

    return Padding(
      padding: EdgeInsets.all(spacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CustomPaint(
            painter: _HexagonPainter(
              stroke: colors.primary,
              strokeWidth: context.strokes.focus,
            ),
            child: SizedBox.square(
              dimension: sizes.illustration,
              child: Icon(icon, size: sizes.icon, color: colors.primary),
            ),
          ),
          SizedBox(height: spacing.lg),
          Semantics(
            header: true,
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: context.typography.title,
            ),
          ),
          SizedBox(height: spacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: context.typography.body.copyWith(
              color: colors.textSecondary,
            ),
          ),
          if (actionLabel != null) ...[
            SizedBox(height: spacing.xl),
            BigButton(label: actionLabel, onPressed: onAction, expanded: false),
          ],
        ],
      ),
    );
  }
}

/// Sivri tepeli petek gözü; boş durum motifinin tek yeri.
class _HexagonPainter extends CustomPainter {
  const new({required this.stroke, required this.strokeWidth});

  final Color stroke;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2 - strokeWidth / 2;
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
    path.close();

    canvas.drawPath(
      path,
      Paint()
        ..color = stroke
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(_HexagonPainter oldDelegate) {
    return stroke != oldDelegate.stroke ||
        strokeWidth != oldDelegate.strokeWidth;
  }
}

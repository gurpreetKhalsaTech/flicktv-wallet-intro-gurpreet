import 'package:flutter/material.dart';


class DottedBackgroundPainter extends CustomPainter {
  const DottedBackgroundPainter({
    this.dotColor = const Color(0xFFE8C34A), // soft gold
    this.spacing = 18.0,
    this.dotRadius = 1.4,
    this.fadeHeightFraction = 0.45, // dots have vanished by ~45% down
    this.maxOpacity = 0.30,
  });

  final Color dotColor;
  final double spacing;
  final double dotRadius;
  final double fadeHeightFraction;
  final double maxOpacity;

  @override
  void paint(Canvas canvas, Size size) {
    final fadeHeight = size.height * fadeHeightFraction;
    if (fadeHeight <= 0 || spacing <= 0) return;

    final paint = Paint()..isAntiAlias = true;

    var row = 0;
    for (double y = 0; y <= fadeHeight; y += spacing, row++) {
      // Vertical fall-off, eased (squared) so the fade is soft, not a hard line.
      final t = (1.0 - y / fadeHeight).clamp(0.0, 1.0);
      final alpha = maxOpacity * t * t;
      if (alpha <= 0.001) continue;

      paint.color = dotColor.withValues(alpha: alpha);

      // Offset alternate rows by half a step → halftone / brick layout.
      final xOffset = row.isEven ? 0.0 : spacing / 2;
      for (double x = xOffset; x <= size.width; x += spacing) {
        canvas.drawCircle(Offset(x, y), dotRadius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant DottedBackgroundPainter oldDelegate) =>
      oldDelegate.dotColor != dotColor ||
          oldDelegate.spacing != spacing ||
          oldDelegate.dotRadius != dotRadius ||
          oldDelegate.fadeHeightFraction != fadeHeightFraction ||
          oldDelegate.maxOpacity != maxOpacity;
}


class DottedBackground extends StatelessWidget {
  const DottedBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return const RepaintBoundary(
      child: CustomPaint(
        painter: DottedBackgroundPainter(),
        size: Size.infinite,
      ),
    );
  }
}
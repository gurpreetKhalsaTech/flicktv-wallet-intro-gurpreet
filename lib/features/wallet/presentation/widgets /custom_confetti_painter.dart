import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../../core /constants/app_colors.dart';


/// A single piece of confetti with its own physics state.
///
/// Physics is advanced by [update] using a real delta-time, so motion looks
/// identical on 60 / 90 / 120 Hz displays. The painter never mutates this —
/// stepping happens once per frame from the owning widget's ticker.
class ConfettiParticle {
  late double x;
  late double y;
  late double vx; // velocity X
  late double vy; // velocity Y
  late double rotation;
  late double rotationSpeed;
  late double opacity;
  late final Color color;
  late final Size size;
  late final double _fadeStartY;

  // One shared RNG instead of allocating a Random per particle.
  static final math.Random _random = math.Random();

  ConfettiParticle(Size screenSize) {
    final fromLeft = _random.nextBool();
    final w = screenSize.width;
    final h = screenSize.height;

    // Spawn just OFF the side edges, in a vertical band around the
    // middle, so the two streams have room to climb and cross.
    if (fromLeft) {
      x = -10 + _random.nextDouble() * 30;
    } else {
      x = w + 10 - _random.nextDouble() * 30;
    }
    y = h * (0.45 + _random.nextDouble() * 0.20); // 0.45h..0.65h
    _fadeStartY = h * 0.85;

    // Each particle aims at a different X along the top edge — some still
    // head all the way to the OPPOSITE corner (preserving the X cross),
    // others peak much earlier so they fall through the centre and the
    // intermediate columns. Net effect: the rain blankets the full
    // screen width on the way down, not just the side gutters.
    final targetX = fromLeft
        ? w * (0.25 + _random.nextDouble() * 0.95) // 0.25w .. 1.20w
        : w * (0.75 - _random.nextDouble() * 0.95); // -0.20w .. 0.75w
    final targetY = -h * 0.08 + _random.nextDouble() * h * 0.04;

    final dx = targetX - x;
    final dy = targetY - y;
    final mag = math.sqrt(dx * dx + dy * dy);

    final speed = 22 + _random.nextDouble() * 7; // 22..29
    vx = (dx / mag) * speed;
    vy = (dy / mag) * speed;

    rotation = _random.nextDouble() * 2 * math.pi;
    rotationSpeed = _random.nextDouble() * 0.4 - 0.2;

    color = AppColors
        .confettiColors[_random.nextInt(AppColors.confettiColors.length)];

    // Smaller pieces — tiny squares mixed with thin, long ribbons.
    if (_random.nextBool()) {
      final s = 3.0 + _random.nextDouble() * 3.0; // 3..6
      size = Size(s, s * (0.7 + _random.nextDouble() * 0.4));
    } else {
      size = Size(
        1.5 + _random.nextDouble() * 1.5, // 1.5..3 width (thin)
        6.0 + _random.nextDouble() * 8.0, // 6..14 height (long)
      );
    }
    opacity = 1.0;
  }

  /// Advances physics by [dt] seconds. Normalised to "60 fps steps"; the clamp
  /// absorbs frame hitches without teleporting.
  void update(double dt) {
    final step = (dt * 60.0).clamp(0.0, 3.0).toDouble();

    x += vx * step;
    y += vy * step;

    // Gentle gravity — particles arc all the way up to the top edge,
    // then drift down slowly like rain instead of slamming back.
    vy += 0.22 * step;

    // Heavier drag on horizontal than vertical, so the initial sideways
    // throw settles into a near-vertical fall — looks like rain.
    vx *= math.pow(0.96, step).toDouble();

    // Asymmetric vertical drag: light on the way UP (so the climb still
    // reaches the top edge), much heavier on the way DOWN (so the rain
    // floats down slowly instead of accelerating to a slam).
    final verticalDrag = vy > 0 ? 0.94 : 0.985;
    vy *= math.pow(verticalDrag, step).toDouble();

    rotation += rotationSpeed * step;

    // Soft per-piece fade as it rains past the lower portion of the screen.
    if (y > _fadeStartY) {
      opacity = (opacity - 0.025 * step).clamp(0.0, 1.0);
    }
  }
}

/// Draws the particles. Pure: it only paints, never simulates. Repaint + the
/// global tail-fade are driven by [progress] (the confetti controller, 0 → 1).
class CustomConfettiPainter extends CustomPainter {
  final List<ConfettiParticle> particles;
  final Animation<double> progress;

  CustomConfettiPainter({
    required this.particles,
    required this.progress,
  }) : super(repaint: progress);

  @override
  void paint(Canvas canvas, Size size) {
    // Tail fade: full opacity until 70% of the confetti's life, then ramps to 0
    // so EVERY piece is guaranteed gone by the end — no frozen leftovers.
    final tail = 1.0 - ((progress.value - 0.7) / 0.3).clamp(0.0, 1.0);
    if (tail <= 0) return;

    final paint = Paint()..style = PaintingStyle.fill;

    for (final particle in particles) {
      final alpha = particle.opacity * tail;
      if (alpha <= 0) continue;

      canvas.save();
      canvas.translate(particle.x, particle.y);
      canvas.rotate(particle.rotation);

      paint.color = particle.color.withValues(alpha: alpha);

      canvas.drawRect(
        Rect.fromCenter(
          center: Offset.zero,
          width: particle.size.width,
          height: particle.size.height,
        ),
        paint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant CustomConfettiPainter oldDelegate) => false;
}
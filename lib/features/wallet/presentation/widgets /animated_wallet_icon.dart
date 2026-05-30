import 'package:flutter/material.dart';

import '../../../../core /constants/app_colors.dart';


class AnimatedWalletIcon extends StatelessWidget {
  final Animation<double> scaleAnimation;

  const AnimatedWalletIcon({
    super.key,
    required this.scaleAnimation,
  });

  // begin/end are constant, so the tween is shared across builds.
  static final Animatable<double> _rotationTween =
  Tween<double>(begin: -0.05, end: 0.02);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: scaleAnimation,
      child: RotationTransition(
        turns: _rotationTween.animate(scaleAnimation),
        child: Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: AppColors.brandGreen,
            borderRadius: BorderRadius.circular(24.0),
            boxShadow: [
              BoxShadow(
                color: AppColors.brandGreen.withValues(alpha: 0.4),
                blurRadius: 30,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: const Center(
            child: Text(
              '₹',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w900,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
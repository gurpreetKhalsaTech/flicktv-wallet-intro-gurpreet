import 'package:flutter/material.dart';

import '../../../../core /constants/app_strings.dart';
import '../../../../core /constants/app_text_styles.dart';

mixin AnimatedHeaderMixin on StatelessWidget {
  // Shared tween — begin/end are constant so one instance covers all builds.
  static final Animatable<double> moneyScaleTween =
      Tween<double>(begin: 0.85, end: 1.0);

  /// Brand title line — fades in via [fade].
  Widget buildBlinkitLine(Animation<double> fade) {
    return FadeTransition(
      opacity: fade,
      child: Text(
        AppStrings.brandTitle,
        style: AppTextStyles.brandHeader,
      ),
    );
  }

  /// MONEY title line — fades and scales in via [fade].
  Widget buildMoneyLine(Animation<double> fade) {
    return FadeTransition(
      opacity: fade,
      child: ScaleTransition(
        scale: moneyScaleTween.animate(fade),
        child: Text(
          AppStrings.moneyTitle,
          style: AppTextStyles.moneyHeader,
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'animated_header_mixin.dart';

class AnimatedHeader extends StatelessWidget with AnimatedHeaderMixin {
  final Animation<double> blinkitFade;
  final Animation<double> moneyFade;

  const AnimatedHeader({
    super.key,
    required this.blinkitFade,
    required this.moneyFade,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        buildBlinkitLine(blinkitFade),
        const SizedBox(height: 4.0),
        buildMoneyLine(moneyFade),
      ],
    );
  }
}
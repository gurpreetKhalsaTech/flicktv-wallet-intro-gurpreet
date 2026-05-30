import 'package:flutter/material.dart';

import '../../../../core /constants/app_colors.dart';
import '../../../../core /constants/app_text_styles.dart';

import '../../data/models/benefit_model.dart';

class BenefitCardItem extends StatelessWidget {
  final BenefitModel benefit;

  const BenefitCardItem({
    super.key,
    required this.benefit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
      decoration: BoxDecoration(
        color: AppColors.cardSurface,
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon
          Container(
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: AppColors.background, // darker inset behind the icon
              borderRadius: BorderRadius.circular(12.0),
            ),
            child: Icon(
              benefit.icon,
              color: AppColors.textPrimary,
              size: 45,
            ),
          ),
          const SizedBox(width: 16.0),

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  benefit.title,
                  style: AppTextStyles.cardTitle,
                ),
                const SizedBox(height: 3.0),
                Text(
                  benefit.subtitle,
                  style: AppTextStyles.cardSubtitle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
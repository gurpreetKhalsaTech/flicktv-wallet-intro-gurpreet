import 'package:flutter/material.dart';

import '../../../../core /constants/app_colors.dart';
import '../../../../core /constants/app_strings.dart';
import '../../../../core /constants/app_text_styles.dart';


class BottomActionPanel extends StatelessWidget {
  const BottomActionPanel({
    super.key,
    this.onAddMoney,
    this.onClaimGiftCard,
  });

  final VoidCallback? onAddMoney;
  final VoidCallback? onClaimGiftCard;

  // TODO: promote to AppColors (e.g. AppColors.giftCardAccent).
  static const Color _giftCardAccent = Colors.orange;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Primary "Add money" button — stays green even before a handler is
        // wired, so it matches the design instead of showing the disabled grey.
        SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: onAddMoney,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.buttonGreen,
              foregroundColor: AppColors.textPrimary,
              disabledBackgroundColor: AppColors.buttonGreen,
              disabledForegroundColor: AppColors.textPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
              ),
            ),
            child: const Text(
              AppStrings.addMoneyButton,
              style: AppTextStyles.buttonText,
            ),
          ),
        ),
        const SizedBox(height: 24.0),

        // "Claim gift card" tile — now on its own card-surface background.
        Material(
          color: AppColors.cardSurface,
          borderRadius: BorderRadius.circular(16.0),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onClaimGiftCard,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12.0,
                vertical: 12.0,
              ),
              child: Row(
                children: [
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: _giftCardAccent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: const SizedBox(
                      width: 44,
                      height: 36,
                      child: Icon(
                        Icons.card_giftcard,
                        color: _giftCardAccent,
                        size: 20,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppStrings.claimGiftCard,
                          style:
                          AppTextStyles.cardTitle.copyWith(fontSize: 14),
                        ),
                        const SizedBox(height: 2.0),
                        Text(
                          AppStrings.claimGiftCardSubtitle,
                          style: AppTextStyles.cardSubtitle
                              .copyWith(fontSize: 11),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    color: AppColors.textSecondary,
                    size: 20,
                  ),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(height: 40.0),

        // Faded footer — alpha baked into the color (no Opacity layer).
        Text(
          AppStrings.footerText,
          textAlign: TextAlign.center,
          style: AppTextStyles.cardTitle.copyWith(
            color: (AppTextStyles.cardTitle.color ?? AppColors.textPrimary)
                .withValues(alpha: 0.3),
            fontSize: 22,
            height: 1.2,
          ),
        ),
        const SizedBox(height: 24.0),
      ],
    );
  }
}
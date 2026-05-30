import 'package:flutter/material.dart';

import '../../../../core /constants/app_colors.dart';

import '../widgets /DottedBackgroundPainter.dart';
import '../widgets /animated_header.dart';
import '../widgets /animated_wallet_icon.dart';
import '../widgets /benefit_card_item.dart';
import '../widgets /bottom_action_panel.dart';
import '../widgets /custom_confetti_painter.dart';

import 'wallet_intro_mixin.dart';

class WalletIntroScreen extends StatefulWidget {
  const WalletIntroScreen({super.key});

  @override
  State<WalletIntroScreen> createState() => _WalletIntroScreenState();
}

class _WalletIntroScreenState extends State<WalletIntroScreen>
    with TickerProviderStateMixin, WalletIntroMixin {
  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.paddingOf(context).top;
    final walletDrop = computeWalletDrop(topPadding);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          _buildBackground(),
          const Positioned.fill(child: DottedBackground()),
          if (particles.isNotEmpty) _buildConfettiLayer(),
          _buildMainContent(walletDrop),
          _buildBackButton(topPadding),
          _buildSettingsButton(topPadding),
        ],
      ),
    );
  }

  // --- Background -----------------------------------------------------------

  Widget _buildBackground() {
    return const Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF242212),
              AppColors.background,
              AppColors.background,
            ],
            stops: [0.0, 0.4, 1.0],
          ),
        ),
      ),
    );
  }

  // --- Confetti -------------------------------------------------------------

  Widget _buildConfettiLayer() {
    return Positioned.fill(
      child: RepaintBoundary(
        child: CustomPaint(
          painter: CustomConfettiPainter(
            particles: particles,
            progress: confettiController,
          ),
        ),
      ),
    );
  }

  // --- Main scrollable content ----------------------------------------------

  Widget _buildMainContent(double walletDrop) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          children: [
            const SizedBox(height: 60.0),
            _buildAnimatedHeroGroup(walletDrop),
            const SizedBox(height: 30.0),
            staggered(cardEntrances[0], BenefitCardItem(benefit: benefits[0])),
            staggered(cardEntrances[1], BenefitCardItem(benefit: benefits[1])),
            staggered(cardEntrances[2], BenefitCardItem(benefit: benefits[2])),
            const SizedBox(height: 16.0),
            staggered(panelEntrance, const BottomActionPanel()),
          ],
        ),
      ),
    );
  }

  // --- Wallet icon + header group (shared vertical translate) ---------------

  Widget _buildAnimatedHeroGroup(double walletDrop) {
    return AnimatedBuilder(
      animation: heroRise,
      builder: (context, child) {
        final groupY =
            (walletDrop - walletSlightRiseDistance * walletSlightRise.value) *
                (1 - groupRise.value);
        return Transform.translate(offset: Offset(0, groupY), child: child);
      },
      child: Column(
        children: [
          Center(child: _buildWalletIcon()),
          const SizedBox(height: 20.0),
          AnimatedHeader(blinkitFade: blinkitFade, moneyFade: moneyFade),
        ],
      ),
    );
  }

  // --- Wallet icon (individual entry-drop translate + scale) ----------------

  Widget _buildWalletIcon() {
    return AnimatedBuilder(
      animation: walletEntry,
      builder: (context, child) => Transform.translate(
        offset: Offset(0, -walletEntryDistance * (1 - walletEntry.value)),
        child: child,
      ),
      child: AnimatedWalletIcon(scaleAnimation: walletScale),
    );
  }

  // --- App-bar chrome -------------------------------------------------------

  Widget _buildBackButton(double topPadding) {
    return Positioned(
      top: 16 + topPadding,
      left: 24,
      child: CircleAvatar(
        backgroundColor: chromeButtonBg,
        child: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
            size: 16,
          ),
          onPressed: () => Navigator.maybePop(context),
        ),
      ),
    );
  }

  Widget _buildSettingsButton(double topPadding) {
    return Positioned(
      top: 16 + topPadding,
      right: 24,
      child: CircleAvatar(
        backgroundColor: chromeButtonBg,
        child: IconButton(
          icon: const Icon(
            Icons.settings_outlined,
            color: Colors.white,
            size: 18,
          ),
          onPressed: () {},
        ),
      ),
    );
  }
}
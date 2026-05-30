import 'package:flutter/material.dart';

import '../../../../core /constants/app_strings.dart';

import '../../data/models/benefit_model.dart';
import '../widgets /custom_confetti_painter.dart';


typedef WalletEntrance = ({Animation<double> fade, Animation<Offset> slide});

mixin WalletIntroMixin<T extends StatefulWidget>
on State<T>, TickerProviderStateMixin<T> {
  // --- Private tunables (only used inside this mixin) -----------------------
  static const Duration _sequenceDuration = Duration(milliseconds: 6500);
  static const Duration _confettiDuration = Duration(milliseconds: 6500);
  static const int _confettiCount = 90;
  static const double _confettiTriggerProgress = 0.22;
  static const double _walletCentreFraction = 0.50;

  // --- Public constants (referenced by the build method) --------------------
  // Non-static so the screen can reference them without qualification.
  final double walletEntryDistance = 120.0;
  final double walletSlightRiseDistance = 100.0;
  final Color chromeButtonBg = const Color(0x14FFFFFF);

  // --- Animation controllers ------------------------------------------------
  late final AnimationController mainController;
  late final AnimationController confettiController;

  // --- Animations -----------------------------------------------------------
  late final Animation<double> walletScale;
  late final Animation<double> walletEntry;
  late final Animation<double> walletSlightRise;
  late final Animation<double> groupRise;
  late final Animation<double> blinkitFade;
  late final Animation<double> moneyFade;
  late final List<WalletEntrance> cardEntrances;
  late final WalletEntrance panelEntrance;

  // Merged listenable for the hero group's two rise animations — built once
  // here instead of allocated inside build().
  late final Listenable heroRise;

  // --- Confetti state -------------------------------------------------------
  final List<ConfettiParticle> particles = [];
  bool _hasFiredConfetti = false;
  Duration _lastElapsed = Duration.zero;

  // --- Layout state ---------------------------------------------------------
  Size screenSize = Size.zero;

  // --- Static data ----------------------------------------------------------
  final List<BenefitModel> benefits = const [
    BenefitModel(
      title: AppStrings.benefit1Title,
      subtitle: AppStrings.benefit1Subtitle,
      icon: Icons.touch_app,
    ),
    BenefitModel(
      title: AppStrings.benefit2Title,
      subtitle: AppStrings.benefit2Subtitle,
      icon: Icons.phonelink_lock,
    ),
    BenefitModel(
      title: AppStrings.benefit3Title,
      subtitle: AppStrings.benefit3Subtitle,
      icon: Icons.currency_rupee,
    ),
  ];

  // --------------------------------------------------------------------------

  @override
  void initState() {
    super.initState();
    _setupControllers();
    _setupAnimations();
    _setupListeners();
    // Defer start so the drop-in plays after the screen is fully painted,
    // not during the route transition.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) mainController.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    screenSize = MediaQuery.sizeOf(context);
  }

  @override
  void dispose() {
    mainController
      ..removeListener(_onMainTick)
      ..dispose();
    confettiController
      ..removeListener(_onConfettiTick)
      ..removeStatusListener(_onConfettiStatus)
      ..dispose();
    super.dispose();
  }

  // --- Setup helpers --------------------------------------------------------

  void _setupControllers() {
    mainController = AnimationController(
      vsync: this,
      duration: _sequenceDuration,
    );
    confettiController = AnimationController(
      vsync: this,
      duration: _confettiDuration,
    );
  }

  void _setupAnimations() {
    walletEntry = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.22, curve: Curves.easeOutCubic),
    );
    walletScale = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.0, 0.22, curve: Curves.elasticOut),
    );
    walletSlightRise = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.34, 0.46, curve: Curves.easeOutCubic),
    );
    blinkitFade = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.50, 0.60, curve: Curves.easeOut),
    );
    moneyFade = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.62, 0.72, curve: Curves.easeOut),
    );
    groupRise = CurvedAnimation(
      parent: mainController,
      curve: const Interval(0.76, 0.88, curve: Curves.easeInOutCubic),
    );

    // Built once now that both rise animations exist.
    heroRise = Listenable.merge([walletSlightRise, groupRise]);

    cardEntrances = [
      _buildEntrance(0.88, 0.92),
      _buildEntrance(0.91, 0.95),
      _buildEntrance(0.94, 0.97),
    ];
    panelEntrance = _buildEntrance(0.96, 1.0);
  }

  void _setupListeners() {
    confettiController
      ..addListener(_onConfettiTick)
      ..addStatusListener(_onConfettiStatus);
    mainController.addListener(_onMainTick);
  }

  WalletEntrance _buildEntrance(double start, double end) {
    final fade = CurvedAnimation(
      parent: mainController,
      curve: Interval(start, end, curve: Curves.easeOut),
    );
    final slide = Tween<Offset>(
      begin: const Offset(0.0, 0.18),
      end: Offset.zero,
    ).animate(fade);
    return (fade: fade, slide: slide);
  }

  // --- Event handlers -------------------------------------------------------

  void _onMainTick() {
    if (_hasFiredConfetti) return;
    if (mainController.value < _confettiTriggerProgress) return;
    _hasFiredConfetti = true;
    mainController.removeListener(_onMainTick);
    _lastElapsed = Duration.zero;
    setState(() {
      particles.addAll(
        List.generate(_confettiCount, (_) => ConfettiParticle(screenSize)),
      );
    });
    confettiController.forward();
  }

  void _onConfettiTick() {
    final elapsed = confettiController.lastElapsedDuration ?? Duration.zero;
    final dt = (elapsed - _lastElapsed).inMicroseconds / 1e6;
    _lastElapsed = elapsed;
    for (final p in particles) {
      p.update(dt);
    }
  }

  void _onConfettiStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && particles.isNotEmpty) {
      setState(particles.clear);
    }
  }

  // --- Build helpers --------------------------------------------------------

  /// Wraps [child] in a fade + slide-up entrance driven by [e].
  Widget staggered(WalletEntrance e, Widget child) {
    return FadeTransition(
      opacity: e.fade,
      child: SlideTransition(position: e.slide, child: child),
    );
  }

  /// Pixel offset that shifts the wallet from its natural top slot down to
  /// the screen centre. Depends on [topPadding] from SafeArea.
  double computeWalletDrop(double topPadding) =>
      ((screenSize.height * _walletCentreFraction) - (topPadding + 110.0))
          .clamp(0.0, 400.0)
          .toDouble();
}
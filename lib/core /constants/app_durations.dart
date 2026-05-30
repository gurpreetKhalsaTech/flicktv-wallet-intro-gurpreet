class AppDurations {
  AppDurations._();

  // Core Animation Durations
  static const Duration fast = Duration(milliseconds: 300);
  static const Duration medium = Duration(milliseconds: 600);
  static const Duration slow = Duration(milliseconds: 1000);

  // Specific Sequence Timings
  static const Duration walletEntrance = Duration(milliseconds: 800);
  static const Duration confettiBurst = Duration(milliseconds: 1500);
  static const Duration headerFadeIn = Duration(milliseconds: 500);
  static const Duration cardSlideIn = Duration(milliseconds: 600);
}
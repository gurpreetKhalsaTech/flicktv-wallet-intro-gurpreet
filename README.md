# Blinkit Money — Wallet Intro Screen

**FlickTV Flutter Assignment** · Gurpreet Singh

A pixel-faithful Flutter implementation of the Blinkit Money wallet onboarding screen, built as part of the FlickTV engineering assignment. The screen features a custom physics-based confetti system, multi-phase staggered animation sequences, and a fully custom-painted halftone background — all without any third-party packages.

---

## Screen Recording & APK

| Screen Recording | Release APK |
|---|---|
| [▶ Watch demo](https://drive.google.com/file/d/1_mODuXSrinT3c58Js4mBRh0u1q8ea0qz/view?usp=sharing) | [⬇ Download APK](https://drive.google.com/file/d/1F5eYTI99Mnq6lc1wcR9I-d46aRE8q7bn/view?usp=sharing) |

---

## Features

- **Wallet entrance** — drops in from above, scales with an elastic bounce, and rises to its header position
- **Two-sided confetti cannon** — particles fire outward from both sides, arc upward to the top of the screen, then rain back down and fade — all driven by real-time physics
- **Staggered content reveal** — "blinkit" → "MONEY" → card 1 → card 2 → card 3 → bottom panel each animate in on their own interval
- **Gold halftone background** — dot grid generated at runtime by a `CustomPainter`, no image asset required
- **Zero third-party packages** — every animation, physics simulation, and custom paint is written from scratch

---

## Architecture

The project follows **Clean Architecture** with a feature-first folder structure.

```
lib/
├── core/
│   └── constants/          # AppColors, AppStrings, AppTextStyles
├── features/
│   └── wallet/
│       ├── data/
│       │   └── models/     # BenefitModel
│       └── presentation/
│           ├── screens/    # WalletIntroScreen, WalletIntroMixin
│           └── widgets/    # AnimatedHeader, AnimatedWalletIcon,
│                           # BenefitCardItem, BottomActionPanel,
│                           # CustomConfettiPainter, DottedBackground
└── main.dart
```

### Why a Mixin instead of BLoC?

`WalletIntroMixin` extracts all animation controller setup, lifecycle hooks, and physics-stepping callbacks from the screen. This is deliberate — the intro screen is **pure presentation**: it has no domain state, no network calls, and no business logic to manage. Introducing a BLoC here would be over-engineering and would add indirection with zero testability benefit. In a real feature (e.g., the wallet balance, transaction history, or add-money flow), BLoC + Clean Architecture repositories + use cases would be the correct approach.

---

## Animation & Performance

### Animation timeline (6.5 s controller)

| Interval | Element |
|---|---|
| `0.00 – 0.22` | Wallet drops in and scales (elasticOut) |
| `0.22` | Confetti fires (separate controller starts) |
| `0.34 – 0.46` | Wallet rises slightly |
| `0.50 – 0.60` | "blinkit" fades in |
| `0.62 – 0.72` | "MONEY" fades + scales in |
| `0.76 – 0.88` | Full hero group rises to top |
| `0.88 – 0.97` | Benefit cards cascade in one-by-one |
| `0.96 – 1.00` | Bottom panel (Add Money + Claim Gift Card + footer) |

### Confetti physics

- Particles are emitted from both sides with a strong horizontal velocity and an upward arc, producing the "cross-fire then rain" pattern.
- Physics (gravity, exponential drag, per-piece rotation and fade) advance using **real elapsed time (dt)**, so the animation looks identical on 60 Hz, 90 Hz, and 120 Hz displays — a common bug in fixed-step simulations.
- A separate `AnimationController` owns the confetti lifetime. When it completes, `particles.clear()` removes the layer entirely. This guarantees no particles are ever frozen on screen.
- A global tail-fade (opacity → 0 over the controller's last 30%) ensures every piece disappears cleanly even if it never crossed the position-based fade threshold.

### Performance decisions

| Technique | Reason |
|---|---|
| `CustomPainter(repaint: controller)` | Repaints the confetti layer without rebuilding any widgets each frame |
| `RepaintBoundary` on confetti + dotted bg | Isolates their continuous repaints from the static layout layer |
| `shouldRepaint` returns `false` on confetti | Re-rasterisation driven solely by the `repaint` listenable |
| `Listenable.merge` hoisted to a field | Avoids allocating a new merged listenable on every `build()` call |
| `static final` tweens in widgets | Tween instances shared across all builds rather than re-allocated |
| `FadeTransition` / `SlideTransition` | Drive the compositor directly — no layout/paint passes from `Opacity` + `Transform` |
| `MediaQuery.sizeOf` / `paddingOf` | Granular subscriptions; only rebuilds when the specific value changes |
| Alpha baked into text color | Footer uses `color.withValues(alpha: 0.3)` instead of an `Opacity` widget |
| `const` widgets throughout | Zero-cost rebuild for all static subtrees |

---

## No Third-Party Packages

The brief requires zero third-party dependencies. All functionality is implemented using the Flutter SDK alone:

- **Confetti** — custom `CustomPainter` with Euler-integration physics (Lottie/Rive exception offered by the brief was not needed)
- **Animations** — `AnimationController`, `CurvedAnimation`, `Interval`, `FadeTransition`, `SlideTransition`, `ScaleTransition`
- **Custom painting** — `CustomPainter` for confetti and the halftone dot background

`pubspec.yaml` has no dependencies beyond `flutter` and `cupertino_icons`.

---

## Getting Started

**Requirements**: Flutter 3.27+ (Dart 3.x), Android SDK 21+

```bash
# Clone
git clone https://github.com/YOUR_USERNAME/flicktv-wallet-intro-gurpreet.git
cd flicktv-wallet-intro-gurpreet

# Install dependencies (there are none beyond the SDK, but this verifies pubspec)
flutter pub get

# Run in debug
flutter run

# Run in profile mode (recommended for performance verification)
flutter run --profile

# Build release APK
flutter build apk --release
```

The release APK is at `build/app/outputs/flutter-apk/app-release.apk`.

---

## Package Info

| Field | Value |
|---|---|
| Package name | `com.flicktv.gurpreet.gurpreet_flicktv_assignment` |
| App name | `Gurpreet Singh` |
| Min SDK | 21 |
| Target SDK | 34 |

---

## Credits

| Asset | Source | License |
|---|---|---|
| Wallet icon | [Source name + URL] | [License, e.g. Free with attribution] |
| Card illustrations | [Source name + URL] | [License] |
| Gift card thumbnail | [Source name + URL] | [License] |
| Font (if used) | [Google Fonts — font name] | OFL |

> Fill in this table with the actual sources once you've downloaded and added the assets.
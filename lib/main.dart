import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'core /constants/app_colors.dart';
import 'core /constants/app_strings.dart';

import 'features/wallet/presentation/screens/wallet_intro_screen.dart';

void main() {
  // Ensure Flutter bindings are initialized before setting system UI overlays
  WidgetsFlutterBinding.ensureInitialized();

  // Force portrait orientation as this UI is explicitly designed for vertical flow
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Set the system status bar to match the dark theme transparently
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(const FlickTvAssignmentApp());
}

class FlickTvAssignmentApp extends StatelessWidget {
  const FlickTvAssignmentApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false, // Always remove the debug banner for recordings!
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: AppColors.background,
        primaryColor: AppColors.brandGreen,
        fontFamily: 'Roboto', // Replace with the specific font if they provided one, otherwise Roboto works well
        useMaterial3: true,
      ),
      home: const WalletIntroScreen(),
    );
  }
}
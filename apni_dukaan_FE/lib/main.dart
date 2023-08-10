import "package:flutter/material.dart";

import "Screens/splash_screen.dart";
import "package:apni_dukaan/Constants/constants.dart";

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme:
            ColorScheme.fromSeed(seedColor: AppConstants.secondBGColor),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
              AppConstants.gradientFirstColor,
              AppConstants.gradientSecondColor,
            ], begin: Alignment.topLeft, end: Alignment.bottomRight),
          ),
          child: const SplashScreen(),
        ),
      ),
    );
  }
}

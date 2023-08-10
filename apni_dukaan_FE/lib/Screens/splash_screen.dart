import "dart:async";
import "package:flutter/material.dart";

import "package:apni_dukaan/Screens/dashboard_screen.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:apni_dukaan/Screens/login_screen.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    handleNavigation();
  }

  void handleNavigation() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? navigateToHome = prefs.getString("token");
    String? role = prefs.getString("role");

    Timer(
      const Duration(seconds: 2),
      () {
        if (navigateToHome != null) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => DashboardScreen(role: role)),
          );
        } else {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginScreen(),
              ));
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        "assets/images/main_logo.png",
        width: 300,
      ),
    );
  }
}

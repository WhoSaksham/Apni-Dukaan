// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:apni_dukaan/Constants/constants.dart';
import 'package:apni_dukaan/Screens/login_screen.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:apni_dukaan/Screens/admin_dashboard_screen.dart';
import 'package:apni_dukaan/Screens/shopowner_dashboard_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen(
      {this.userData = const {
        "name": "Guest",
        "email": "guest@apnidukaan.com",
        "role": "GUEST"
      },
      this.role,
      super.key});

  final Map<String, dynamic> userData;
  final String? role;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late List<String> data = [];

  void getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uData = prefs.getStringList("userData");
    final uRole = prefs.getString("role");
    setState(() {
      data = [...uData!, uRole!];
    });
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: AppConstants.gradientFirstColor,
        centerTitle: true,
        title: Row(
          children: [
            Image.asset(
              "assets/images/main_favicon.png",
              width: 30,
            ),
            const SizedBox(width: 5),
            const Text("Apni Dukaan"),
          ],
        ),
      ),
      drawer: Drawer(
        backgroundColor: AppConstants.gradientSecondColor,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                child: Icon(Icons.account_circle),
              ),
              const SizedBox(height: 10),
              if (data.isNotEmpty) ...[
                Text(data[0],
                    style: const TextStyle(fontSize: 20, color: Colors.white)),
                const SizedBox(height: 10),
                Text(data[1],
                    style: const TextStyle(fontSize: 15, color: Colors.white)),
                const SizedBox(height: 10),
                Text(
                  data[2],
                  style: const TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
              ],
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final prefs = await SharedPreferences.getInstance();
                  prefs.remove("token");
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const LoginScreen(),
                    ),
                  );

                  Fluttertoast.showToast(
                    msg: 'Logout successfully!!',
                    toastLength: Toast.LENGTH_LONG,
                    gravity: ToastGravity.BOTTOM,
                    fontSize: 20,
                  );
                },
                child: const Text("Logout"),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: widget.role == null
            ? const LoginScreen()
            : widget.role == "ADMIN"
                ? const AdminDashboardScreen()
                : const ShopownerDashboardScreen(),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously
import "package:apni_dukaan/Screens/reset_password_screen.dart";
import "package:flutter/material.dart";

import "package:apni_dukaan/Screens/dashboard_screen.dart";
import "package:apni_dukaan/Screens/signup_screen.dart";
import "package:apni_dukaan/Services/auth_services.dart";
import 'package:fluttertoast/fluttertoast.dart';
import "package:shared_preferences/shared_preferences.dart";
import "../Constants/constants.dart";

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  Map<String, dynamic> userData = {};
  bool isChecked = false;
  bool _showPassword = false;

  Color getColor(Set<MaterialState> states) {
    const Set<MaterialState> interactiveStates = <MaterialState>{
      MaterialState.pressed,
      MaterialState.hovered,
      MaterialState.focused,
    };
    if (states.any(interactiveStates.contains)) {
      return Colors.blue;
    }
    return AppConstants.secondBGColor;
  }

  void handleLogin() async {
    final data = await AuthServices().loginShopowner(
        {"email": _emailController.text, "password": _passwordController.text},
        isChecked);

    if (data["success"]) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      prefs.setStringList("userData", [
        '${data["response"]["firstName"]} ${data["response"]["lastName"]}',
        userData["email"] = data["response"]["email"]
      ]);

      userData["role"] = data["response"]["role"];

      // Redirect
      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (context) =>
              DashboardScreen(userData: userData, role: userData["role"]),
        ),
      );

      // Success Toast
      Fluttertoast.showToast(
          msg: 'Welcome back, ${data["response"]["firstName"]}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20);
    } else {
      // Error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset(height: 300, "assets/images/login_img.jpg"),
                const SizedBox(height: 10),
                const Text(
                  "Welcome Back",
                  style: TextStyle(
                      color: AppConstants.secondBGColor,
                      fontStyle: FontStyle.italic,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Email",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      labelText: "Email",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.email,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _passwordController,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        hintText: "Enter Password",
                        hintStyle: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontWeight: FontWeight.w500,
                            fontSize: 18),
                        labelText: "Password",
                        labelStyle:
                            const TextStyle(fontWeight: FontWeight.w500),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: AppConstants.secondBGColor,
                        ),
                        suffixIcon: IconButton(
                            icon: Icon(_showPassword
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _showPassword = !_showPassword;
                              });
                            })),
                  ),
                ),
                Row(
                  children: [
                    Checkbox(
                      checkColor: Colors.white,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      value: isChecked,
                      onChanged: (bool? value) {
                        setState(() {
                          isChecked = value!;
                        });
                      },
                    ),
                    const Text(
                      "Login as ADMIN",
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Align(
                    alignment: Alignment.topRight,
                    child: TextButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute<void>(
                            builder: (context) => const ResetPasswordScreen(),
                          ));
                        },
                        icon: const Icon(Icons.security),
                        label: const Text("Forgot Password?"))),
                const SizedBox(height: 10),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: handleLogin,
                  child: const Text(
                    "Login",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                TextButton(
                    onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        )),
                    child: const Text(
                      "New to Apni Dukaan? Signup Now!",
                      style: TextStyle(
                          fontSize: 18, color: AppConstants.secondBGColor),
                    ))
              ]),
        ),
      ),
    );
  }
}

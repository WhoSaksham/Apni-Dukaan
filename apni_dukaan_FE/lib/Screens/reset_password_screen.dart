import 'package:apni_dukaan/Screens/login_screen.dart';
import 'package:apni_dukaan/Services/auth_services.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../Constants/constants.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map _forgotResp = {};
  bool _nextScreen = false;
  bool _isVerified = false;

  void handleForgotPassword() async {
    final forgotResp = await AuthServices()
        .forgotPassword(resetEmail: {"email": _emailController.text});

    if (forgotResp["success"]) {
      // Success Toast
      Fluttertoast.showToast(
          msg: forgotResp["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20);

      setState(() {
        _nextScreen = true;
        _forgotResp = forgotResp;
      });
    } else {
      // Error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(forgotResp["message"]),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void handleCodeVerify() {
    if (_forgotResp["code"] == _codeController.text) {
      setState(() {
        _isVerified = true;
      });

      // Success Toast
      Fluttertoast.showToast(
          msg: "Code Verified",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20);
    }
  }

  void handleResetPassword() async {
    final resetData = {
      "email": _forgotResp["user"]["email"],
      "password": _passwordController.text
    };

    final resetResp = await AuthServices().resetPassword(resetData: resetData);

    if (resetResp["success"]) {
      // Success Toast
      Fluttertoast.showToast(
          msg: resetResp["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20);

      Navigator.of(context).pushReplacement<void, void>(
        MaterialPageRoute<void>(
          builder: (context) => const LoginScreen(),
        ),
      );
    } else {
      // Error SnackBar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resetResp["message"]),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 100),
              Image.asset(
                "assets/images/main_logo.png",
                width: 200,
              ),
              const SizedBox(height: 20),
              if (!_nextScreen)
                Column(
                  children: [
                    const Text("Enter your Account Email",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
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
                    ElevatedButton.icon(
                        onPressed: () {
                          handleForgotPassword();
                        },
                        icon: const Icon(Icons.forward),
                        label: const Text("Next"))
                  ],
                ),
              if (_nextScreen && !_isVerified)
                Column(
                  children: [
                    const Text("Verify Secert Code",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _codeController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter Secret Code",
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                          labelText: "Secret Code",
                          labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          prefixIcon: Icon(
                            Icons.code,
                            color: AppConstants.secondBGColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                        onPressed: () {
                          handleCodeVerify();
                        },
                        icon: const Icon(Icons.verified),
                        label: const Text("Verify")),
                  ],
                ),
              if (_nextScreen && _isVerified)
                Column(
                  children: [
                    const Text("Reset your Password",
                        style: TextStyle(
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: _passwordController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: "Enter new Password",
                          hintStyle: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              fontSize: 18),
                          labelText: "Password",
                          labelStyle: TextStyle(fontWeight: FontWeight.w500),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: AppConstants.secondBGColor,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                        onPressed: () {
                          handleResetPassword();
                        },
                        icon: const Icon(Icons.done),
                        label: const Text("Change Password")),
                  ],
                )
            ],
          )),
        ),
      ),
    );
  }
}

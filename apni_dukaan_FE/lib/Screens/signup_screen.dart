// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:apni_dukaan/Screens/login_screen.dart';
import 'package:apni_dukaan/Services/auth_services.dart';
import 'package:apni_dukaan/Constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dashboard_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();

  Map<String, dynamic> userData = {};

  void handleSignup() async {
    final data = await AuthServices().signupShopowner({
      "firstName": _firstNameController.text,
      "lastName": _lastNameController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "company": _companyController.text
    });

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
          msg: 'Welcome to Apni Dukaan, ${data["response"]["firstName"]}',
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20);
    } else {
      // Error Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(data["message"]),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  bool _showPassword = false;

  @override
  void initState() {
    super.initState();
    _showPassword = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Image.asset(
                    height: 300, width: 250, "assets/images/signup_img.jpg"),
                const Text(
                  "Become a Member",
                  style: TextStyle(
                      color: AppConstants.secondBGColor,
                      fontStyle: FontStyle.italic,
                      fontSize: 35,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          controller: _firstNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "First Name",
                              hintText: "John"),
                        ),
                      ),
                      SizedBox(
                        width: 180,
                        child: TextFormField(
                          controller: _lastNameController,
                          decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              labelText: "Last Name",
                              hintText: "Doe"),
                        ),
                      ),
                    ]),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                  width: 400,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _emailController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Email",
                        labelStyle: TextStyle(),
                        hintText: "email@example.com",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        prefixIcon: Icon(
                          Icons.email,
                          color: AppConstants.secondBGColor,
                        )),
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                  width: 400,
                  child: TextFormField(
                    controller: _passwordController,
                    keyboardType: TextInputType.text,
                    obscureText: !_showPassword,
                    decoration: InputDecoration(
                        border: const OutlineInputBorder(),
                        labelText: "Password",
                        hintText: "password",
                        hintStyle: const TextStyle(fontStyle: FontStyle.italic),
                        prefixIcon: const Icon(Icons.lock,
                            color: AppConstants.secondBGColor),
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
                Container(
                  margin: const EdgeInsets.fromLTRB(15, 20, 15, 0),
                  width: 400,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _companyController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: "Company/Firm",
                        labelStyle: TextStyle(),
                        hintText: "Example: Apni Dukaan",
                        hintStyle: TextStyle(fontStyle: FontStyle.italic),
                        prefixIcon: Icon(
                          Icons.account_box,
                          color: AppConstants.secondBGColor,
                        )),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                    onPressed: () {
                      handleSignup();
                    },
                    child: const Text("Signup")),
                const SizedBox(height: 20),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()));
                    },
                    child: const Text(
                      "Already a Member? Login Now!",
                      style: TextStyle(
                          fontSize: 18, color: AppConstants.secondBGColor),
                    )),
              ]),
        ),
      ),
    );
  }
}

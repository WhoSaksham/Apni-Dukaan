// ignore_for_file: avoid_print
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class AuthServices {
  final String baseUrl = "https://api-apni-dukaan.onrender.com";

  // Signup API for SHOPOWNER
  signupShopowner(signupData) async {
    try {
      final res = await http.post(Uri.parse('$baseUrl/shopowner/signup'),
          body: signupData);
      final data = jsonDecode(res.body.toString());

      if (res.statusCode == 200 && data["response"]["role"] == "SHOPOWNER") {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", res.headers["authorization"]!.split(" ")[1]);
        prefs.setString("role", data["response"]["role"]);
      }

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Login API for ADMIN/SHOPOWNER
  loginShopowner(loginData, isAdmin) async {
    try {
      final res = await http.post(
          Uri.parse("$baseUrl/${isAdmin ? 'admin' : 'shopowner'}/login"),
          body: loginData);
      final data = jsonDecode(res.body.toString());

      if (res.statusCode == 200 &&
          (data["response"]["role"] == "ADMIN" ||
              data["response"]["role"] == "SHOPOWNER")) {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString("token", res.headers["authorization"]!.split(" ")[1]);
        prefs.setString("role", data["response"]["role"]);
      }

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Forgot Password API for SHOPOWNER
  forgotPassword({required resetEmail}) async {
    try {
      final res = await http.post(
        Uri.parse("$baseUrl/shopowner/forgot"),
        body: resetEmail,
        // headers: {"Content-Type": "application/json"}
      );
      final data = jsonDecode(res.body.toString());

      if (data["success"]) {
        final newData = {...data, "code": res.headers["code"]};
        return newData;
      }

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Reset Password API for SHOPOWNER
  resetPassword({required resetData}) async {
    try {
      final res = await http.put(
        Uri.parse("$baseUrl/shopowner/reset"),
        body: resetData,
        // headers: {"Content-Type": "application/json"}
      );
      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }
}

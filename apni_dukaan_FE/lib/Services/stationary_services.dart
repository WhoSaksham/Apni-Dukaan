// ignore_for_file: avoid_print
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class StationaryServices {
  final String baseUrl = "https://api-apni-dukaan.onrender.com";

  // Add Stationary API for ADMIN
  addStationary(addData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.post(Uri.parse('$baseUrl/admin/stationary'),
          body: addData,
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // View All Stationaries API for ADMIN
  getAllStationaries() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.get(Uri.parse('$baseUrl/admin/stationary'),
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body);

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Edit Stationary API for ADMIN
  editStationary(String id, Map<String, dynamic> editData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.put(Uri.parse("$baseUrl/admin/stationary/$id"),
          body: jsonEncode(editData),
          headers: <String, String>{
            "Authorization": "Bearer ${prefs.getString("token")!}",
            "Content-Type": "application/json"
          });
      final data = jsonDecode(res.body);

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Delete Stationary API for ADMIN
  deleteStationary(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.delete(Uri.parse("$baseUrl/admin/stationary/$id"),
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body);

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }
}

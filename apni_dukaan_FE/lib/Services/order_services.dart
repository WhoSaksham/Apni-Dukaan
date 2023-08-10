// ignore_for_file: avoid_print
import "dart:convert";
import "package:http/http.dart" as http;
import "package:shared_preferences/shared_preferences.dart";

class OrderServices {
  final String baseUrl = "https://api-apni-dukaan.onrender.com/orders";

  // Add Order History API for ShopOwner/Admin
  addOrder(addData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.post(Uri.parse(baseUrl),
          body: jsonEncode(addData),
          headers: <String, String>{
            "Authorization": "Bearer ${prefs.getString("token")}",
            "Content-Type": "application/json"
          });

      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // View All Order History API for ShopOwner/Admin
  getOrder() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.get(Uri.parse(baseUrl),
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // View All Order History by Shopowner email API for ShopOwner/Admin
  getOrderByShopowner({required ownerInfo}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final info = "${(ownerInfo[0]).split(" ")[0]} ${ownerInfo[1]}";

    try {
      final res = await http.get(Uri.parse("$baseUrl/$info"),
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Edit Order History API for ShopOwner/Admin
  editOrder(String id, Map editData) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.put(Uri.parse("$baseUrl/$id"),
          body: editData,
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }

  // Delete Order History API for ShopOwner/Admin
  deleteOrder(String id) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      final res = await http.delete(Uri.parse("$baseUrl/$id"),
          headers: {"Authorization": "Bearer ${prefs.getString("token")!}"});
      final data = jsonDecode(res.body.toString());

      return data;
    } catch (e) {
      print("Error => $e");
    }
  }
}

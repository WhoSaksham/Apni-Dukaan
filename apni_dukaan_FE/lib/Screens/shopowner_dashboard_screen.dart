import 'dart:async';
import 'package:flutter/material.dart';

import 'package:apni_dukaan/Screens/buy_stationary_screen.dart';
import 'package:apni_dukaan/Screens/shopowner_order_screen.dart';
import 'package:apni_dukaan/Services/stationary_services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Constants/constants.dart';

class ShopownerDashboardScreen extends StatefulWidget {
  const ShopownerDashboardScreen({super.key});

  @override
  State<ShopownerDashboardScreen> createState() =>
      _ShopownerDashboardScreenState();
}

class _ShopownerDashboardScreenState extends State<ShopownerDashboardScreen> {
  List<Map<String, dynamic>>? data;
  Map<String, List<Map<String, dynamic>>> category = {};

  Future<void> getStationaries() async {
    try {
      final res = await StationaryServices().getAllStationaries();
      if (res is Map<String, dynamic> && res.containsKey("response")) {
        setState(() {
          data = List<Map<String, dynamic>>.from(res["response"]);
          getCategory();
        });
      } else {
        // Handle the case when the response is not in the expected format
        setState(() {
          data = null; // Set data to null to indicate an error in the response
        });

        // Snackbar
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Something went wrong"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      // Handle any other exceptions that may occur during the API call
      setState(() {
        data = null; // Set data to null to indicate an error in the API call
      });

      // Snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Something went wrong"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
        ),
      );
    }
  }

  void getCategory() {
    // Create a temporary map to store sorted categories
    final Map<String, List<Map<String, dynamic>>> sortedCategory = {};

    // Populate the temporary map with data
    for (var item in data!) {
      final categoryKey = item["category"];
      final companyValue = {
        "id": item["_id"],
        "company": item["company"],
        "name": item["name"],
        "quantity": item["quantity"],
        "price": item["price"],
      };

      if (sortedCategory.containsKey(categoryKey)) {
        sortedCategory[categoryKey]!.add(companyValue);
      } else {
        sortedCategory[categoryKey] = [companyValue];
      }
    }

    // Sort the keys in ascending order
    final sortedKeys = sortedCategory.keys.toList()
      ..sort((a, b) => a.compareTo(b));

    // Create a new map with sorted data
    final Map<String, List<Map<String, dynamic>>> sortedCategoryMap = {};
    for (var key in sortedKeys) {
      sortedCategoryMap[key] = sortedCategory[key]!;
    }

    // Update the original category map with sorted data
    setState(() {
      category = sortedCategoryMap;
    });
  }

  String userName = "";

  void getUserName() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final uData = prefs.getStringList("userData");
    setState(() {
      userName = uData![0];
    });
  }

  @override
  initState() {
    super.initState();
    getStationaries();
    getUserName();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (userName.isNotEmpty) ...[
                RichText(
                  text: TextSpan(
                    text: 'Hi, ',
                    style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    children: <TextSpan>[
                      TextSpan(
                        text: userName.split(" ")[0],
                        style: const TextStyle(
                            color: AppConstants.secondBGColor,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "What would you like to Order Today?",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
              const SizedBox(
                height: 10,
              ),
              const Text(
                "Available Stationaries",
                style: TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 15),
              if (data != null && data!.isNotEmpty)
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: category.keys.length,
                  gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                    maxCrossAxisExtent: 200,
                  ),
                  itemBuilder: (context, index) {
                    final categoryKey = category.keys.toList()[index];
                    final companies = category[categoryKey];

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BuyStationaryScreen(
                                categoryKey, companies, getStationaries),
                          ),
                        );
                      },
                      child: Container(
                        margin: const EdgeInsets.all(8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppConstants.secondBGColor,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              offset: Offset(5, 5),
                              color: AppConstants.firstBGColor,
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              categoryKey,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 10),
                            Text(
                              '${companies!.length} ${companies.length == 1 ? "Company" : "Comapnies"}',
                              style: const TextStyle(
                                fontSize: 14,
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 50),
              if (data == null || data!.isEmpty)
                const Center(
                  child: Text(
                    "No stationary available",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              TextButton.icon(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const ShopownerOrderScreen()));
                  },
                  icon: const Icon(Icons.history),
                  label: const Text("Your Orders",
                      style: TextStyle(fontSize: 20))),
              if (data != null && data!.isNotEmpty)
                const Text(
                  "More Stationaries to be added soon...",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    fontStyle: FontStyle.italic,
                    backgroundColor: AppConstants.gradientSecondColor,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

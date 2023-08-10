import 'package:flutter/material.dart';

import 'package:apni_dukaan/Constants/constants.dart';
import 'package:apni_dukaan/Services/order_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ShopownerOrderScreen extends StatefulWidget {
  const ShopownerOrderScreen({super.key});

  @override
  State<ShopownerOrderScreen> createState() => _ShopownerOrderScreenState();
}

class _ShopownerOrderScreenState extends State<ShopownerOrderScreen> {
  Map<String, dynamic>? data;
  List<String>? userData;
  bool ordersAvailable = false;

  getOwnerInfo() async {
    final prefs = await SharedPreferences.getInstance();
    final uData = prefs.getStringList("userData");
    setState(() {
      userData = uData;
    });

    getOrders();
  }

  getOrders() async {
    final res = await OrderServices().getOrderByShopowner(ownerInfo: userData);
    setState(() {
      data = res;
      ordersAvailable = data != null && data!["response"].isNotEmpty;
    });
  }

  @override
  initState() {
    super.initState();
    getOwnerInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  "assets/images/main_logo.png",
                  width: 100,
                ),
                const SizedBox(height: 10),
                const Text(
                  "Your Orders",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: OrderServices().getOrder(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.firstBGColor,
                        ),
                      );
                    } else if (!ordersAvailable) {
                      return const Center(
                        child: Text(
                          "No Orders found",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    } else {
                      return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount:
                              (data?["response"] as List<dynamic>?)?.length ??
                                  0,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 450,
                            childAspectRatio: 1.7,
                          ),
                          itemBuilder: (context, index) {
                            return Container(
                              height: 300,
                              // margin: const EdgeInsets.only(right: 20),
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
                              padding: const EdgeInsets.all(12),
                              decoration: const BoxDecoration(
                                  color: AppConstants.secondBGColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                        blurRadius: 2,
                                        spreadRadius: 2,
                                        offset: Offset(5, 5),
                                        color: AppConstants.firstBGColor)
                                  ]),
                              child: Column(
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.category,
                                              color: Colors.white),
                                          SizedBox(width: 5),
                                          Text(
                                            "Category",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data?["response"][index]["category"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.crop_original_outlined,
                                              color: Colors.white),
                                          SizedBox(width: 5),
                                          Text(
                                            "Company",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data?["response"][index]["company"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                              Icons
                                                  .supervised_user_circle_sharp,
                                              color: Colors.white),
                                          SizedBox(width: 5),
                                          Text(
                                            "Name",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        data?["response"][index]["name"],
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.production_quantity_limits,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Quantity",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        (data?["response"][index]["quantity"])
                                            .toString(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.price_change_rounded,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Order Total",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹ ${(data?["response"][index]["orderTotal"]).toString()}",
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          });
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

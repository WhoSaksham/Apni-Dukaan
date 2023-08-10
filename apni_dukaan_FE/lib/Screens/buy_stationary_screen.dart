import 'package:flutter/material.dart';

import 'package:apni_dukaan/Services/order_services.dart';
import 'package:apni_dukaan/Services/stationary_services.dart';
import '../Constants/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BuyStationaryScreen extends StatefulWidget {
  const BuyStationaryScreen(this.category, this.companies, this.getStationaries,
      {super.key});

  final List<Map<String, dynamic>> companies;
  final String category;
  final Function getStationaries;

  @override
  State<BuyStationaryScreen> createState() => _BuyStationaryScreenState();
}

class _BuyStationaryScreenState extends State<BuyStationaryScreen> {
  late TextEditingController _quantityController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController();
  }

  placeOrder({required data, required quantity}) async {
    final Map<String, dynamic> orderData = {
      "category": widget.category,
      "company": data["company"],
      "name": data["name"],
      "originalPrice": data["price"],
      "quantity": quantity,
      "orderTotal": quantity * data["price"]
    };

    final res = await OrderServices().addOrder(orderData);

    if (res["success"]) {
      // Success Toast
      Fluttertoast.showToast(
          msg: res["message"],
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          fontSize: 20);

      Navigator.pop(context);

      // Update Stationary available quantity
      final resp = await StationaryServices().editStationary(
          data["id"], {"quantity": data["quantity"] - quantity});

      if (resp["success"]) {
        Navigator.pop(context);

        // Update Stationaries /REFRESH
        widget.getStationaries();

        // Success Toast
        Fluttertoast.showToast(
            msg: resp["message"],
            toastLength: Toast.LENGTH_LONG,
            gravity: ToastGravity.BOTTOM,
            fontSize: 20);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res["message"]),
            backgroundColor: Colors.redAccent,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res["message"]),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  confirmOrder(Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shadowColor: AppConstants.secondBGColor,
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          title: const Text("Order Summary", textAlign: TextAlign.center),
          actions: [
            Text(
              "Category: ${widget.category}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Company: ${orderData["company"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Name: ${orderData["name"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Price: ₹ ${orderData["price"]}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              "Quantity: ${_quantityController.text}",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text("--------------------"),
            Text(
              "Total: ₹ ${int.parse(_quantityController.text) * orderData["price"]} only",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                    onPressed: () {
                      placeOrder(
                          data: orderData,
                          quantity: int.parse(_quantityController.text));
                    },
                    icon: const Icon(Icons.shopping_bag_outlined),
                    label: const Text("Buy")),
                ElevatedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      handleBuy(context, orderData);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Back")),
              ],
            )
          ],
        );
      },
    );
  }

  handleBuy(context, Map<String, dynamic> orderData) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shadowColor: AppConstants.secondBGColor,
          shape:
              BeveledRectangleBorder(borderRadius: BorderRadius.circular(30)),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/main_logo.png",
                  width: 100,
                ),
                const Text(
                  "Place Order",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: widget.category,
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Category",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      labelText: "Category",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.category,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: orderData["company"],
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Company",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      labelText: "Company",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.crop_original_outlined,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    initialValue: orderData["name"],
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Name with Code",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      labelText: "Name",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.supervised_user_circle_sharp,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: orderData["price"].toString(),
                    enabled: false,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Price per Piece",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      labelText: "Price",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.price_change_rounded,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Quantity you want to Buy",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                      labelText: "Quantity",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.supervised_user_circle_sharp,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton.icon(
                        onPressed: () {
                          if (_quantityController.text.isNotEmpty) {
                            if (int.parse(_quantityController.text) <= 0) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("Quantity should be at least 1"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            } else {
                              // Pop
                              Navigator.pop(context);

                              confirmOrder(orderData);
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Enter Quantity"),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                        icon: const Icon(Icons.done),
                        label: const Text("Next")),
                    ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context, true);
                          _quantityController.text = '';
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Cancelled"),
                              backgroundColor: Colors.grey,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
                        icon: const Icon(Icons.cancel),
                        label: const Text("Cancel")),
                  ],
                ),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Buy Stationary"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Text("Available ${widget.category}",
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.w500)),
            const SizedBox(height: 20),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.companies.length,
              itemBuilder: (context, index) {
                final companyData = widget.companies[index];
                final company = companyData["company"];
                final name = companyData["name"];
                final quantity = companyData["quantity"];
                final price = companyData["price"];

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                  child: ListTile(
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            company,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppConstants.secondBGColor),
                          ),
                          Text(
                            name,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: AppConstants.firstBGColor),
                          ),
                        ],
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Available Quantity: $quantity"),
                          Text("Price: ₹ $price / Piece"),
                        ],
                      ),
                      trailing: ElevatedButton.icon(
                          onPressed: () {
                            handleBuy(context, companyData);
                          },
                          icon: const Icon(Icons.shopping_cart_outlined),
                          label: const Text("Buy"))),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

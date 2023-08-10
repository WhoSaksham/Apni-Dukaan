// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';

import 'package:apni_dukaan/Services/stationary_services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../Constants/constants.dart';

class AddStationary extends StatefulWidget {
  const AddStationary({Key? key}) : super(key: key);

  @override
  State<AddStationary> createState() => _AddStationaryState();
}

class _AddStationaryState extends State<AddStationary> {
  final TextEditingController _categoryController = TextEditingController();
  final TextEditingController _companyController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  void showToast(String text) {
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      fontSize: 20,
    );
  }

  Future<void> handleAdd() async {
    final data = await StationaryServices().addStationary({
      "category": _categoryController.text,
      "company": _companyController.text,
      "quantity": _quantityController.text,
      "name": _nameController.text,
      "price": _priceController.text,
    });

    if (data["success"]) {
      // Pop and show success toast
      Navigator.pop(context);
      showToast(data["message"]);
    } else {
      // Show error SnackBar
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
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  "assets/images/main_logo.png",
                  width: 200,
                ),
                const SizedBox(height: 30),
                const Text(
                  "Add New Stationary",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    controller: _categoryController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Category",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
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
                    controller: _companyController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Company",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
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
                    controller: _nameController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Name with Code",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
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
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Quantity",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      labelText: "Quantity",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.production_quantity_limits,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Price per Piece",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 18),
                      labelText: "Price",
                      labelStyle: TextStyle(fontWeight: FontWeight.w500),
                      prefixIcon: Icon(
                        Icons.price_change_rounded,
                        color: AppConstants.secondBGColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: handleAdd,
                      icon: const Icon(Icons.add),
                      label: const Text("Add"),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Cancelled"),
                            backgroundColor: Colors.grey,
                            duration: Duration(seconds: 3),
                          ),
                        );
                      },
                      icon: const Icon(Icons.delete),
                      label: const Text("Cancel"),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

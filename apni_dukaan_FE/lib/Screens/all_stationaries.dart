import 'package:flutter/material.dart';
import 'package:apni_dukaan/Constants/constants.dart';
import 'package:apni_dukaan/Services/stationary_services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AllStationaries extends StatefulWidget {
  const AllStationaries({Key? key}) : super(key: key);

  @override
  State<AllStationaries> createState() => _AllStationariesState();
}

class _AllStationariesState extends State<AllStationaries> {
  late Future<Map<String, dynamic>> stationariesData = Future.value({});
  late TextEditingController _categoryController;
  late TextEditingController _companyController;
  late TextEditingController _nameController;
  late TextEditingController _quantityController;
  late TextEditingController _priceController;

  getStationaries() async {
    final data = await StationaryServices().getAllStationaries();
    setState(() {
      stationariesData = Future.value(data);
    });
  }

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
    _companyController = TextEditingController();
    _nameController = TextEditingController();
    _quantityController = TextEditingController();
    _priceController = TextEditingController();
    getStationaries();
  }

  @override
  void dispose() {
    _categoryController.dispose();
    _companyController.dispose();
    _nameController.dispose();
    _quantityController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void editStationary(String id) async {
    Map<String, dynamic> editData = {};

    editData['category'] = _categoryController.text;
    editData['company'] = _companyController.text;
    editData['name'] = _nameController.text;
    editData['quantity'] = _quantityController.text;
    editData['price'] = _priceController.text;

    final res = await StationaryServices().editStationary(id, editData);

    if (res['success']) {
      Navigator.pop(context, true);

      Fluttertoast.showToast(
        msg: res['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 20,
      );

      setState(() {
        getStationaries();
      });

      _categoryController.text = '';
      _companyController.text = '';
      _quantityController.text = '';
      _nameController.text = '';
      _priceController.text = '';
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void handleEdit(Map<String, dynamic> selectedStationary) {
    _categoryController.text = selectedStationary["category"];
    _companyController.text = selectedStationary["company"];
    _nameController.text = selectedStationary["name"];
    _quantityController.text = selectedStationary["quantity"].toString();
    _priceController.text = selectedStationary["price"].toString();

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 10),
                Image.asset(
                  "assets/images/main_logo.png",
                  width: 100,
                ),
                const Text(
                  "Edit the Stationary",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
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
                    controller: _companyController,
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
                    controller: _nameController,
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
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Enter Stationary Quantity",
                      hintStyle: TextStyle(
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
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
                const SizedBox(height: 10),
                const Text(
                  "*Note : Fill all the fields provided above",
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        editStationary(selectedStationary["_id"]);
                      },
                      icon: const Icon(Icons.done),
                      label: const Text("Edit"),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.pop(context, true);
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text("Cancel"),
                    ),
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

  void deleteStationary(String id) async {
    final res = await StationaryServices().deleteStationary(id);

    if (res['success']) {
      Navigator.pop(context, true);

      Fluttertoast.showToast(
        msg: res['message'],
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        fontSize: 20,
      );

      setState(() {
        getStationaries();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(res['message']),
          backgroundColor: Colors.redAccent,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  void handleDelete(String id) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text("Delete this Stationary?"),
          actions: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    deleteStationary(id);
                  },
                  icon: const Icon(Icons.done),
                  label: const Text("Okay"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  icon: const Icon(Icons.cancel),
                  label: const Text("Cancel"),
                ),
              ],
            ),
          ],
        );
      },
    );
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
                  "All Available Stationaries",
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                FutureBuilder(
                  future: stationariesData,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.firstBGColor,
                        ),
                      );
                    } else if (snapshot.hasData &&
                        snapshot.data!['response'] != null) {
                      if (snapshot.data!['response'].isEmpty) {
                        return const Center(
                          child:
                              Text("No Stationaries found, try Adding some!"),
                        );
                      } else {
                        return GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: snapshot.data!['response'].length,
                          gridDelegate:
                              const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 450,
                            childAspectRatio: 1.45,
                          ),
                          itemBuilder: (context, index) {
                            final item = snapshot.data!['response'][index];
                            return Container(
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 12),
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
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.category,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "Category",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        item["category"],
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
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
                                        item["company"],
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
                                        item["name"],
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
                                        (item["quantity"]).toString(),
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
                                            "Price",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      Text(
                                        "₹ ${(item["price"]).toString()} / Piece",
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
                                      TextButton.icon(
                                        onPressed: () {
                                          handleEdit(item);
                                        },
                                        icon: const Icon(
                                          Icons.edit,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Edit",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      TextButton.icon(
                                        onPressed: () {
                                          handleDelete(item["_id"]);
                                        },
                                        icon: const Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Delete",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppConstants.secondBGColor,
                        ),
                      );
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

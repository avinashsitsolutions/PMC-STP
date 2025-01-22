import 'dart:math';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:multiselect/multiselect.dart';
import 'package:tankerpmc/builder/builderservices.dart';
import 'package:tankerpmc/widgets/appbar.dart';
import 'package:tankerpmc/widgets/constants.dart';
import 'package:tankerpmc/widgets/drawerwidget.dart';
import 'package:get/get.dart';

import '../getx/controller.dart';
import 'dashboard_builder.dart';

class UpdateBCP extends StatefulWidget {
  const UpdateBCP({
    super.key,
    required this.bcpno,
    required this.mobileno,
    required this.id,
    required this.projectName,
    required this.managername,
    required this.address,
    required this.lat,
    required this.long,
    required this.projecttype,
    required this.tankertype,
    required this.selectedBuilders,
  });
  final String bcpno;
  final String mobileno;
  final String id;
  final String projectName;
  final String managername;
  final String address;
  final String lat;
  final String long;
  final String projecttype;
  final String tankertype;
  final List<dynamic> selectedBuilders;

  @override
  State<UpdateBCP> createState() => _UpdateBCPState();
}

class _UpdateBCPState extends State<UpdateBCP> {
  TextEditingController bcpController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController projecttypeController = TextEditingController();
  late GoogleMapController mapController;
  String stpAddress = '';
  bool _isLoading = true;
  final latController = TextEditingController();
  final longController = TextEditingController();
  String projecttype11 = "";
  TextEditingController projectnameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController managernameController = TextEditingController();
  // late LocationData currentLocation;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  bool loadingButton = false;
  MapType _currentMapType = MapType.normal;
  String mb = '0';

  final formKey = GlobalKey<FormState>();

  checkLocationIsEnabledOrNot() async {
    bool serviceEnabled;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      Geolocator.openLocationSettings();
      return false;
    } else {
      return true;
    }
  }

  Random random = Random();
  Future getbuilder() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.get(
      Uri.parse('${Config.baseUrl}/water_type'),
    );
    var data = json.decode(response.body);
    if (data['error'] == false) {
      setState(() {
        fruits = data['data'];
        _isLoading = false;
      });
    } else {
      setState(() {
        _isLoading = false;
      });
    }
  }

  List<dynamic> fruits = [];
  List<dynamic> selectedFruits = [];
  final _formKey = GlobalKey<FormState>();

  String? getStpNameById(int id) {
    var stp = fruits.firstWhere((item) => item['id'] == id, orElse: () => null);
    return stp != null ? stp['water_type'] : null;
  }

  int? getStpIdByName(String name) {
    var stp = fruits.firstWhere((item) => item['water_type'] == name,
        orElse: () => null);
    return stp != null ? stp['id'] : null;
  }

  var dropdownValue1 = 'PMC Project';
  var dropdownValue2 = "Private";
  List<dynamic> selectedBuilders = [];

  @override
  void initState() {
    super.initState();
    projectnameController.text = widget.projectName;
    bcpController.text = widget.bcpno;
    mobileController.text = widget.mobileno;
    addressController.text = widget.address;
    latController.text = widget.lat;
    longController.text = widget.long;
    managernameController.text = widget.managername;
    projecttypeController.text = widget.projecttype;
    selectedBuilders = widget.selectedBuilders;
    dropdownValue1 =
        widget.projecttype; // Initialize the dropdown with the project type
    getbuilder();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.blue[50],
                ),
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Center(
                          child: Text(
                            "Update Project   ",
                            style: TextStyle(
                                fontSize: 21,
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Select Project Type :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        widget.projecttype == "PMC Project" ||
                                widget.projecttype == "Non-PMC Project"
                            ? TextFormField(
                                controller: projecttypeController,
                                enabled: false,
                                decoration: const InputDecoration(
                                  fillColor: Colors.white,
                                  filled: true,
                                  contentPadding: EdgeInsets.only(bottom: 4.0),
                                  hintStyle: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 17,
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 17.0,
                                ),
                              )
                            : Container(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.blue,
                                      width: 1.0,
                                    ),
                                  ),
                                ),
                                child: DropdownButtonFormField<String>(
                                  value: dropdownValue1,
                                  menuMaxHeight: 200,
                                  decoration: const InputDecoration(
                                    suffixIconColor: Colors.blue,
                                    fillColor: Colors.white,
                                    border: InputBorder.none,
                                    filled: true,
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide.none,
                                    ),
                                  ),
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 17.0,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  validator: (value) {
                                    if (value == null || value.isEmpty) {
                                      return 'Please select an option';
                                    }
                                    return null;
                                  },
                                  icon: const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.green,
                                  ),
                                  onChanged: (newValue) {
                                    setState(() {
                                      dropdownValue1 = newValue!;
                                    });
                                  },
                                  items: <String>[
                                    'PMC Project',
                                    'Non-PMC Project',
                                  ].map<DropdownMenuItem<String>>(
                                      (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(value),
                                    );
                                  }).toList(),
                                ),
                              ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Project Name:",
                          style: TextStyle(
                            fontSize: 17,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: projectnameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(bottom: 4.0),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Project Commecement  No :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          onChanged: (text) {
                            bcpController.value = bcpController.value.copyWith(
                              text: text.toUpperCase(),
                              selection:
                                  TextSelection.collapsed(offset: text.length),
                            );
                          },
                          enabled: false,
                          controller: bcpController,
                          textCapitalization: TextCapitalization.characters,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            contentPadding: EdgeInsets.only(bottom: 4.0),
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 11) {
                              return 'Please enter valid Commecement Number';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Password:",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: passwordController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Password',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Password';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Project Manager Name :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          controller: managernameController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter Name',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter Name';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        const Text(
                          "Project Manager Mobile No :",
                          style: TextStyle(
                              fontSize: 17,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        TextFormField(
                          maxLength: 10,
                          keyboardType: TextInputType.number,
                          controller: mobileController,
                          decoration: const InputDecoration(
                            fillColor: Colors.white,
                            filled: true,
                            hintText: 'Enter mobile No',
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 12.0, horizontal: 16.0),
                            isDense: true,
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 17,
                            ),
                          ),
                          validator: (value) {
                            if (value == null ||
                                value.isEmpty ||
                                value.length < 10) {
                              return 'Please enter Mobile No';
                            }
                            return null;
                          },
                          style: const TextStyle(
                            fontSize: 17.0,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        GetBuilder<LocationController>(
                            init: LocationController(),
                            builder: (controller) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    "Project Address :",
                                    style: TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  TextFormField(
                                    controller: addressController,
                                    onChanged: (value) =>
                                        controller.address.value = value,
                                    decoration: const InputDecoration(
                                      hintText: 'Enter Address',
                                      fillColor: Colors.white,
                                      filled: true,
                                      contentPadding:
                                          EdgeInsets.only(bottom: 4.0),
                                      hintStyle: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 17,
                                      ),
                                      enabledBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                      focusedBorder: UnderlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.white),
                                      ),
                                    ),
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Lattitude:",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: latController,
                                            onChanged: (value) => controller
                                                .latitude.value = value,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Lattitude',
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 4.0),
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        const Text(
                                          "Longitude:",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                          child: TextFormField(
                                            controller: longController,
                                            onChanged: (value) => controller
                                                .longitude.value = value,
                                            decoration: const InputDecoration(
                                              hintText: 'Enter Longitude',
                                              fillColor: Colors.white,
                                              filled: true,
                                              contentPadding:
                                                  EdgeInsets.only(bottom: 4.0),
                                              hintStyle: TextStyle(
                                                color: Colors.grey,
                                                fontSize: 18,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                    color: Colors.white),
                                              ),
                                            ),
                                            style: const TextStyle(
                                              fontSize: 18.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color(0xff3e50b5)),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                              shape: MaterialStateProperty.all<OutlinedBorder>(
                                const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.horizontal(
                                    left: Radius.circular(20.0),
                                    right: Radius.circular(20.0),
                                  ),
                                ),
                              ),
                              minimumSize: MaterialStateProperty.all<Size>(
                                  const Size(150, 35)),
                            ),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                projecttype11 = widget.projectName == ""
                                    ? dropdownValue1
                                    : projecttypeController.text;
                                Builderservices.updateBCP(
                                        widget.id,
                                        projectnameController.text,
                                        passwordController.text,
                                        mobileController.text,
                                        projecttype11,
                                        bcpController.text,
                                        addressController.text,
                                        latController.text,
                                        longController.text,
                                        managernameController.text,
                                        selectedBuilders)
                                    .then((data) async {
                                  if (data['error'] == false) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                            'Project Updated Successfulyy'),
                                        backgroundColor: Colors.blue,
                                      ),
                                    );

                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardBuilder()));
                                  } else if (data['error'] == true) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(data['message']),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    addressController.clear();
                                    passwordController.clear();
                                    latController.clear();
                                    longController.clear();
                                    managernameController.clear();
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardBuilder()));
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Something Went Wrong'),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const DashboardBuilder()));
                                    addressController.clear();
                                    latController.clear();
                                    longController.clear();
                                    passwordController.clear();
                                    managernameController.clear();
                                  }
                                });
                              }
                            },
                            child: const Text(
                              'Update Project',
                              style: TextStyle(fontSize: 17),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      // bottomNavigationBar: Container(
      //   decoration: const BoxDecoration(
      //     image: DecorationImage(
      //       image: AssetImage(
      //           'assets/bottomimage.png'), // Replace with your image path
      //     ),
      //   ),
      //   height: 70, // Adjust the height of the image
      // ),
    );
  }
}

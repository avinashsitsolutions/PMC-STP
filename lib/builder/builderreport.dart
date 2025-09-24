import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:tankerpmc/builder/builderservices.dart';
import 'package:tankerpmc/widgets/appbar.dart';
import 'package:tankerpmc/widgets/drawerWidget.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ReportBuilder extends StatefulWidget {
  const ReportBuilder({super.key});

  @override
  State<ReportBuilder> createState() => _ReportBuilderState();
}

class _ReportBuilderState extends State<ReportBuilder> {
  List<dynamic> _dataList = [];
  bool isLoading = false;
  int _selectedOptionId = 0;
  List<Map<String, dynamic>> bcpList = [];
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedOption = '';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();

  void fetchBCPList() {
    Builderservices.bcplist().then((data1) {
      setState(() {
        isLoading = true;
        List<dynamic> data = data1['data'];
        bcpList = data.map((item) => item as Map<String, dynamic>).toList();
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    fetchBCPList();

    DateTime now = DateTime.now();
    _dateController2.text = "${now.day}-${now.month}-${now.year}";
  }

  @override
  Widget build(BuildContext context) {
    final labelRowWidth = math.min(Get.width * 0.95, 320).toDouble();
    final leftColumnWidth = math.min(Get.width * 0.45, 210).toDouble();

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: Padding(
        padding: EdgeInsets.all(Get.width * 0.025),
        child: Container(
          width: Get.width,
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            children: [
              SizedBox(height: Get.height * 0.02),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  "Reports",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: Get.height * 0.02),

              // ✅ Make top part scrollable
              SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(
                      width: labelRowWidth,
                      child: Row(
                        children: const [
                          Expanded(
                            child: Text(
                              "From Date:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: Text(
                              "To Date:",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: Get.height * 0.015),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _dateController1,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: 'Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter date'
                                      : null,
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 1, 1),
                                      maxTime: DateTime(2025, 12, 31),
                                      onConfirm: (date) {
                                        _dateController1.text =
                                            '${date.day}-${date.month}-${date.year}';
                                      },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en,
                                    );
                                  },
                                ),
                              ),
                              SizedBox(width: Get.width * 0.08),
                              Expanded(
                                child: TextFormField(
                                  readOnly: true,
                                  controller: _dateController2,
                                  decoration: const InputDecoration(
                                    fillColor: Colors.white,
                                    filled: true,
                                    labelText: 'Date',
                                    suffixIcon: Icon(Icons.calendar_today),
                                  ),
                                  validator: (value) => value!.isEmpty
                                      ? 'Please enter date'
                                      : null,
                                  onTap: () {
                                    DatePicker.showDatePicker(
                                      context,
                                      showTitleActions: true,
                                      minTime: DateTime(2020, 1, 1),
                                      maxTime: DateTime(2025, 12, 31),
                                      onConfirm: (date) {
                                        _dateController2.text =
                                            '${date.day}-${date.month}-${date.year}';
                                      },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: Get.height * 0.04),
                          TypeAheadField(
                            textFieldConfiguration: TextFieldConfiguration(
                              decoration: const InputDecoration(
                                hintText: "Select BCP No First",
                                prefixIcon: Icon(Icons.search,
                                    color: Color.fromRGBO(0, 0, 0, 1)),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              controller: _typeAheadController,
                              style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            suggestionsCallback: (pattern) {
                              return bcpList
                                  .where((item) =>
                                      item['ni_bcp_no'] != null &&
                                      item['ni_bcp_no']
                                          .toString()
                                          .toLowerCase()
                                          .contains(pattern.toLowerCase()))
                                  .map((item) => item['ni_bcp_no'].toString())
                                  .toList();
                            },
                            itemBuilder: (context, suggestion) {
                              return ListTile(title: Text(suggestion));
                            },
                            onSuggestionSelected: (suggestion) {
                              setState(() {
                                _selectedOption = suggestion;
                                _typeAheadController.text = suggestion;
                                _selectedOptionId = bcpList.firstWhere((item) =>
                                    item['ni_bcp_no'].toString() ==
                                    suggestion)['id'];
                              });
                            },
                            noItemsFoundBuilder: (context) =>
                                const ListTile(title: Text('No item found')),
                          ),
                          SizedBox(height: Get.height * 0.05),
                          ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_selectedOption.isNotEmpty) {
                                  Builderservices.builderrrport(
                                          _selectedOptionId.toString(),
                                          _dateController1.text,
                                          _dateController2.text)
                                      .then((data) {
                                    setState(() => _dataList = data['data']);
                                    isLoading = false;
                                  });
                                } else {
                                  Builderservices.builderrrportall(
                                          _dateController1.text,
                                          _dateController2.text)
                                      .then((data) {
                                    setState(() => _dataList = data['data']);
                                    isLoading = false;
                                  });
                                }
                              }
                            },
                            child: const Text('Submit'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ✅ Bottom always inside Expanded
              Expanded(
                child: isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : _dataList.isEmpty
                        ? const Center(
                            child: Text(
                              "No Reports Available ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _dataList.length,
                            itemBuilder: (context, index) {
                              final data = _dataList[index];
                              String dateString = data['updated_at'];
                              final status = data['status'];
                              DateTime date = DateTime.parse(dateString);
                              String formattedDate =
                                  DateFormat('dd-MM-yyyy').format(date);
                              return Column(
                                children: [
                                  SizedBox(height: Get.height * 0.02),
                                  buildDataRow(leftColumnWidth, "Serial No:",
                                      (index + 1).toString()),
                                  buildDataRow(leftColumnWidth, "Project Name:",
                                      data['ni_project_name']),
                                  buildDataRow(leftColumnWidth,
                                      "Order Completed On:", formattedDate),
                                  buildDataRow(
                                      leftColumnWidth,
                                      "Water Quantity:",
                                      "${data['ni_water_capacity']} Liter"),
                                  buildDataRow(leftColumnWidth, "Tanker No:",
                                      data['ni_tanker_no'].toString()),
                                  buildDataRow(leftColumnWidth, "Site Address:",
                                      data['address'].toString()),
                                  buildDataRow(leftColumnWidth, "STP Name:",
                                      data['ni_nearest_stp'].toString()),
                                  buildDataRow(leftColumnWidth, "Distance:",
                                      "${data['ni_distance']} Km"),
                                  buildDataRow(leftColumnWidth, "Amount:",
                                      "₹ ${data['ni_estimated_amount']}"),
                                  if (status.toString() == "false")
                                    buildDataRow(
                                        leftColumnWidth, "Status:", "Pending"),
                                  if (status.toString() == "null")
                                    buildDataRow(leftColumnWidth, "Status:",
                                        "Cancelled"),
                                  if (status.toString() == "true")
                                    buildDataRow(
                                        leftColumnWidth, "Status:", "Complete"),
                                  const Divider(
                                      thickness: 1, color: Colors.grey),
                                ],
                              );
                            },
                          ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildDataRow(double leftWidth, String label, String? value) {
  return Row(
    children: [
      SizedBox(
        width: leftWidth,
        child: Padding(
          padding: EdgeInsets.only(left: Get.width * 0.07, top: 10, bottom: 10),
          child: Text(
            label,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      Expanded(
        child: Text(
          value ?? '',
          style: const TextStyle(fontSize: 17),
        ),
      )
    ],
  );
}

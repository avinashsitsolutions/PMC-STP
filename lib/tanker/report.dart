import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import 'package:tankerpmc/tanker/tankerservices.dart';
import 'package:tankerpmc/widgets/appbar.dart';
import 'package:tankerpmc/widgets/drawerWidget.dart';

class ReportTanker extends StatefulWidget {
  const ReportTanker({super.key});

  @override
  State<ReportTanker> createState() => _ReportTankerState();
}

class _ReportTankerState extends State<ReportTanker> {
  List<dynamic> _dataList = [];
  String _selectedOption = '';
  List<Map<String, dynamic>> _tankerDataList = [];
  List<dynamic> _tankerNumbers = [];
  String check = "True";
  String selectedTankerId = "";
  TextEditingController _typeAheadController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();
  var status;

  @override
  void initState() {
    super.initState();
    Tankerservices.viewtankerlist().then((data) {
      if (data['error'] == false) {
        setState(() {
          _tankerDataList = List<Map<String, dynamic>>.from(data['data']);
          _tankerNumbers =
              _tankerDataList.map((item) => item['ni_tanker_no']).toList();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    DateTime now = DateTime.now();
    String formattedDate = "${now.day}-${now.month}-${now.year}";
    _dateController2.text = formattedDate;

    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            width: screenWidth,
            child: Column(
              children: [
                const SizedBox(height: 20),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reports",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),
                const SizedBox(
                  width: 320,
                  child: Row(
                    children: [
                      Expanded(
                          child: Text(
                        "From Date:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                      SizedBox(width: 20),
                      Expanded(
                          child: Text(
                        "To Date:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Form(
                  key: _formKey,
                  child: Row(
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
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter date' : null,
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
                      const SizedBox(width: 30),
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
                          validator: (value) =>
                              value!.isEmpty ? 'Please enter date' : null,
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
                ),
                const SizedBox(height: 30),
                TypeAheadField(
                  textFieldConfiguration: TextFieldConfiguration(
                    decoration: const InputDecoration(
                      hintText: 'Select Tanker No First',
                      prefixIcon: Icon(Icons.search, color: Colors.black),
                    ),
                    controller: _typeAheadController,
                  ),
                  suggestionsCallback: (pattern) {
                    return _tankerNumbers
                        .where((item) => item
                            .toString()
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(title: Text(suggestion));
                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      _selectedOption = suggestion;
                      _typeAheadController.text = suggestion;
                      final selectedTanker = _tankerDataList.firstWhere(
                        (item) => item['ni_tanker_no'] == suggestion,
                      );
                      selectedTankerId = selectedTanker['id'].toString();
                    });
                  },
                  noItemsFoundBuilder: (context) =>
                      const ListTile(title: Text('No item found')),
                ),
                const SizedBox(height: 50),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_selectedOption.isNotEmpty) {
                        Tankerservices.reportankerDriver(
                          _selectedOption,
                          _dateController1.text,
                          _dateController2.text,
                        ).then((data) {
                          if (data['error'] == false) {
                            setState(() => _dataList = data['data']);
                          }
                        });
                      } else {
                        Tankerservices.reportankerDriverall(
                          _dateController1.text,
                          _dateController2.text,
                        ).then((data) {
                          if (data['error'] == false) {
                            setState(() => _dataList = data['data']);
                          }
                        });
                      }
                    }
                  },
                  child: const Text('Submit'),
                ),
                const SizedBox(height: 10),
                _dataList.isEmpty
                    ? const Center(
                        child: Column(
                          children: [
                            SizedBox(height: 30),
                            Text(
                              "No Reports Available ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 30),
                          ],
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _dataList.length,
                        itemBuilder: (context, index) {
                          final data = _dataList[index];
                          String dateString = data['updated_at'];
                          DateTime date = DateTime.parse(dateString);
                          String formattedDate =
                              DateFormat('dd-MM-yyyy').format(date);
                          status = data['status'];

                          return SizedBox(
                            height: screenHeight * 0.55, // ✅ responsive height
                            child: Column(
                              children: [
                                _buildRow("Serial No:", (index + 1).toString(),
                                    screenWidth),
                                _buildRow("Reciept No:",
                                    "STP/2023/${data['id']}", screenWidth),
                                _buildRow("Order Completed on:", formattedDate,
                                    screenWidth),
                                _buildRow(
                                    "Water Quantity:",
                                    "${data['ni_water_capacity']} Liters",
                                    screenWidth),
                                _buildRow("Tanker No:", data['ni_tanker_no'],
                                    screenWidth),
                                _buildRow("Site Address:",
                                    data['address'].toString(), screenWidth),
                                _buildRow("STP Name:", data['ni_nearest_stp'],
                                    screenWidth),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: screenWidth *
                                          0.55, // ✅ responsive width
                                      child: const Padding(
                                        padding: EdgeInsets.only(
                                            left: 30,
                                            top: 10,
                                            bottom: 10,
                                            right: 10),
                                        child: Text(
                                          "Status:",
                                          style: TextStyle(
                                              fontSize: 17,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Text(
                                        status.toString() == "false"
                                            ? "Pending"
                                            : status.toString() == "null"
                                                ? "Cancelled"
                                                : "Completed",
                                        style: TextStyle(
                                          fontSize: 17,
                                          color: status.toString() == "null"
                                              ? Colors.red
                                              : Colors.black,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                const Divider(
                                  height: 2,
                                  color: Colors.black,
                                  indent: 140,
                                  endIndent: 140,
                                ),
                              ],
                            ),
                          );
                        },
                      )
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 🔹 Reusable row
  Widget _buildRow(String label, String value, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.55, // ✅ responsive width
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
            child: Text(label,
                style:
                    const TextStyle(fontSize: 17, fontWeight: FontWeight.bold)),
          ),
        ),
        Expanded(
          child: Text(value, style: const TextStyle(fontSize: 17)),
        ),
      ],
    );
  }
}

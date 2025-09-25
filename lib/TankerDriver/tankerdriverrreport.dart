import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:intl/intl.dart';
import 'package:tankerpmc/tanker/tankerservices.dart';
import 'package:tankerpmc/widgets/appbar.dart';
import 'package:tankerpmc/widgets/drawerWidget.dart';

class ReportTankerDriver extends StatefulWidget {
  const ReportTankerDriver({super.key});

  @override
  State<ReportTankerDriver> createState() => _ReportTankerDriverState();
}

class _ReportTankerDriverState extends State<ReportTankerDriver> {
  List<dynamic> _dataList = [];
  String check = "True";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();

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
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Tankerservices.reportanker(
                              _dateController1.text, _dateController2.text)
                          .then((data) {
                        if (data['error'] == true) {
                          check = "false";
                        } else if (data['error'] == false) {
                          setState(() {
                            _dataList = data['data'];
                          });
                        }
                      });
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
                                _buildRow(
                                  "Status:",
                                  data['status'] == false
                                      ? "Pending..."
                                      : "Completed",
                                  screenWidth,
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

  /// 🔹 Reusable row widget (avoids repeating code)
  Widget _buildRow(String label, String value, double screenWidth) {
    return Row(
      children: [
        SizedBox(
          width: screenWidth * 0.55, // ✅ responsive width
          child: Padding(
            padding:
                const EdgeInsets.only(left: 30, top: 10, bottom: 10, right: 10),
            child: Text(
              label,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(fontSize: 17),
          ),
        ),
      ],
    );
  }
}

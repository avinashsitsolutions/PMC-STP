import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tankerpmc/pmc_newuser/services.dart';
import 'package:tankerpmc/widgets/appbar.dart';
import 'package:tankerpmc/widgets/drawerWidget.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';

class ReportPCMCuser extends StatefulWidget {
  const ReportPCMCuser({super.key});

  @override
  State<ReportPCMCuser> createState() => _ReportPCMCuserState();
}

class _ReportPCMCuserState extends State<ReportPCMCuser> {
  List<dynamic> _dataList = [];
  String check = "True";
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController2 = TextEditingController();
  final TextEditingController _dateController1 = TextEditingController();

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
        child: Padding(
          padding:
              const EdgeInsets.only(top: 20, left: 10, right: 10, bottom: 60),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.blue[50],
              borderRadius: BorderRadius.circular(15),
            ),
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Reports",
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
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
                      SizedBox(
                        width: 20,
                      ),
                      Expanded(
                          child: Text(
                        "To Date:",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter date';
                            }
                            return null;
                          },
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
                      const SizedBox(
                        width: 30,
                      ),
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
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter date';
                            }
                            return null;
                          },
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
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Services.reportPCMCuser(
                              _dateController1.text, _dateController2.text)
                          .then((data) {
                        if (data['error'] == true) {
                          check = "false";
                          setState(() {
                            _dataList = data['data'];
                          });
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
                const SizedBox(
                  height: 10,
                ),
                _dataList.isEmpty
                    // check == "false"
                    ? const Center(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 30,
                            ),
                            Text(
                              "No Reports Available ",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              height: 30,
                            ),
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
                            height: 380,
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "Serial No:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            (index + 1).toString(),
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "Reciept No:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "STP/2023/${data['id'].toString()}",
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "Order Completed on:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            formattedDate,
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "Water Quantity:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${data['ni_water_capacity']} Liters",
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "Tanker No :",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['ni_tanker_no'],
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "Site Address:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['address'].toString(),
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                left: 30,
                                                top: 10,
                                                bottom: 10,
                                                right: 10),
                                            child: Text(
                                              "STP Name:",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['ni_nearest_stp'],
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    const SizedBox(
                                      width: 210,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Padding(
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
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            data['status'] == false
                                                ? "Pending..."
                                                : "Completed",
                                            style:
                                                const TextStyle(fontSize: 17),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
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
}

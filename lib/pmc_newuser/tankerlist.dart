import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:tankerpmc/builder/builderservices.dart';
import 'package:tankerpmc/pmc_newuser/receiptpmcproject.dart';
import 'package:tankerpmc/widgets/appbar.dart';
import 'package:tankerpmc/widgets/drawerwidget.dart';
import 'package:http/http.dart' as http;
// ignore: unused_import
import 'package:url_launcher/url_launcher.dart';

class TankerListPCMC extends StatefulWidget {
  const TankerListPCMC({
    Key? key,
    required this.list,
    required this.projectname,
    required this.capacity,
    required this.stp,
    required this.amt,
    required this.distance,
  }) : super(key: key);

  final List<dynamic> list;
  final String projectname;
  final String capacity;
  final String stp;
  final String amt;
  final String distance;

  @override
  State<TankerListPCMC> createState() => _TankerListPCMCState();
}

class _TankerListPCMCState extends State<TankerListPCMC> {
  bool _isLoading = false;
  bool _isBookingInProgress = false;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  late var url;
  late var url2;

  @override
  void initState() {
    super.initState();
    widget.list.isEmpty ? _isLoading = true : _isLoading = false;
  }

  Future<void> bookTanker(int index) async {
    if (_isBookingInProgress) {
      return; // Booking already in progress, do nothing
    }

    setState(() {
      _isBookingInProgress = true;
    });

    final data = widget.list[index];
    final result = await Builderservices.OrderPCMC(
      widget.projectname,
      widget.capacity,
      widget.stp,
      widget.distance,
      widget.amt,
      data['ni_owner_ful_name'].toString(),
      data['ni_tanker_capacity'].toString(),
      data['ni_contact_no'].toString(),
      data['ni_tanker_no'].toString(),
      data['ni_tanker_mo_no'].toString(),
      data['tanker_id'].toString(),
    );

    if (result['error'] == false) {
      url = result['url'];
      url2 = result['url1'];

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.blue,
          behavior: SnackBarBehavior.floating,
          content: Text("Order Added Successfully !!"),
          duration: Duration(seconds: 2),
        ),
      );
      // ignore: use_build_context_synchronously
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ReceiptPCMCProject()),
      );
      final response = await http.get(Uri.parse(url));
      final response1 = await http.get(Uri.parse(url2));
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.red,
          behavior: SnackBarBehavior.floating,
          content: Text("Something went wrong. Please Try Again"),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isBookingInProgress = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(kToolbarHeight),
        child: Appbarwid(),
      ),
      endDrawer: const DrawerWid(),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
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
                  "Tanker List",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                ),
              ),
              _isLoading
                  ? const Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        Center(
                          child: Text(
                            "No Tanker Available...",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
                      ],
                    )
                  : Expanded(
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: widget.list.length,
                        itemBuilder: (context, index) {
                          final data = widget.list[index];
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 2,
                                ),
                              ),
                              height: 230,
                              width: MediaQuery.of(context).size.width,
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Tanker Owner Name: ${data['ni_owner_ful_name'].toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Tanker Number: ${data['ni_tanker_no'].toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Tanker Capacity: ${data['ni_tanker_capacity'].toString()} Liters",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Text(
                                        "Mobile No: ${data['ni_tanker_mo_no'].toString()}",
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 17),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        ElevatedButton(
                                          onPressed: () {
                                            var mob = data['ni_tanker_mo_no'];
                                            FlutterPhoneDirectCaller.callNumber(
                                                "tel:$mob");
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(Icons.call),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Text("Call "),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        ElevatedButton(
                                          onPressed: () async {
                                            await bookTanker(index);
                                          },
                                          child: const Text("Book Tanker"),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}

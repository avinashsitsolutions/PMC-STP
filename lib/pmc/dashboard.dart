import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tankerpmc/pmc/builderlist.dart';
import 'package:tankerpmc/pmc/dailysupply.dart';
import 'package:tankerpmc/pmc/orderlist.dart';
import 'package:http/http.dart' as http;
import 'package:tankerpmc/pmc/stplist.dart';
import 'package:tankerpmc/pmc/tankerlist.dart';
import 'package:tankerpmc/pmc/todayreceipt.dart';
import 'package:tankerpmc/widgets/constants.dart';
import 'package:url_launcher/url_launcher.dart';
import '../widgets/drawerWidget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  List<dynamic> count = [];

  List<String> imagePaths = [
    'assets/buildings.png',
    'assets/truckfast.png',
    'assets/Water damage1.png',
    'assets/Calendar today.png',
    'assets/Receipt long.png',
    'assets/Opacity.png',
  ];

  List<String> text = [
    'Total No.of Registered Builders',
    'Total No.of Registered Tankers',
    'Total No.of Registered STP',
    'Total Orders',
    'Today Orders',
    'Today\'s Supply(in liters)',
  ];

  @override
  void initState() {
    super.initState();
    finalList();
  }

  getCounts() async {
    var response = await http.get(Uri.parse("${Config.baseUrl}/count_new"));
    final Map<String, dynamic> data = jsonDecode(response.body);
    return data;
  }

  finalList() {
    getCounts().then((data) {
      final List<String> dataList = [];
      data.forEach((key, value) {
        dataList.add(value.toString());
      });
      setState(() {
        count = dataList;
      });
    });
  }

  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () => SystemNavigator.pop(),
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = Get.width;
    final screenHeight = Get.height;

    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0, // ✅ remove shadow
          scrolledUnderElevation: 0, // ✅ remove shadow on scroll
          titleSpacing: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () =>
                    launchUrl(Uri.parse('https://pcmcindia.gov.in/index.php')),
                child: const Image(
                  image: AssetImage('assets/pcmc_logo.png'),
                  height: 50,
                ),
              ),
              const SizedBox(width: 5),
              const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pune Municipal Corporation",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "STP Tanker System",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu, size: 25, color: Colors.black),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: const DrawerWid(),

        // ✅ Fix: Wrap body in SafeArea
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.02),
            child: count.isNotEmpty
                ? GridView.builder(
                    itemCount: count.length,
                    physics: const AlwaysScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisSpacing: screenWidth * 0.04,
                      crossAxisCount: screenWidth > 1200
                          ? 4 // desktops
                          : screenWidth > 800
                              ? 3 // tablets
                              : 2, // phones
                      // ✅ keep ratio safe, avoid overflow
                      childAspectRatio: screenWidth / (screenHeight * 0.6),
                    ),
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                          switch (index) {
                            case 0:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const BuilderList()));
                              break;
                            case 1:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TankerList()));
                              break;
                            case 2:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const StpList()));
                              break;
                            case 3:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const OrderList()));
                              break;
                            case 4:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const TodayReceipt()));
                              break;
                            case 5:
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const DailySupply()));
                              break;
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: screenHeight * 0.03),
                          decoration: BoxDecoration(
                            color: Colors.blue[50],
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircleAvatar(
                                radius: screenWidth * 0.07,
                                child: Image.asset(
                                  imagePaths[index],
                                  fit: BoxFit.cover,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                count[index],
                                style: TextStyle(
                                  fontSize: screenWidth * 0.05,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: screenHeight * 0.015),
                              Text(
                                text[index],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: CircularProgressIndicator()),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tankerpmc/TankerDriver/tankerdriverreceipt.dart';
import 'package:tankerpmc/TankerDriver/tankerdriverrreport.dart';
import 'package:tankerpmc/widgets/drawerwidget.dart';
import 'package:tankerpmc/widgets/internet.dart';
import 'package:url_launcher/url_launcher.dart';

class DashboardTankerDriver extends StatefulWidget {
  const DashboardTankerDriver({super.key});

  @override
  State<DashboardTankerDriver> createState() => _DashboardTankerDriverState();
}

class _DashboardTankerDriverState extends State<DashboardTankerDriver> {
  Future<bool> _onWillPop() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('No'),
            ),
            ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
    return false;
  }

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    InternetConnection();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: 0,
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                // ignore: deprecated_member_use
                onTap: () => launch('https://pcmcindia.gov.in/index.php'),
                child: const Image(
                  image: AssetImage('assets/pcmc_logo.png'),
                  height: 50,
                ),
              ),
              const SizedBox(
                width: 5,
              ),
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
                  icon: const Icon(
                    Icons.menu,
                    size: 25,
                    color: Colors.black,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                );
              },
            ),
          ],
        ),
        endDrawer: const DrawerWid(),
        body: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                const Text(
                  " Tanker Driver Dashboard",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TankerDriverReceipt()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: const Image(
                            image: AssetImage('assets/notification.png'),
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "New Order Receipts",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const ReportTankerDriver()));
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    height: 140,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Transform.scale(
                          scale: 1.2,
                          child: const Image(
                            image: AssetImage('assets/receipttext.png'),
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        const Text(
                          "Reports",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
      ),
    );
  }
}

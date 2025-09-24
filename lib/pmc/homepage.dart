import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // ✅ for SystemUiOverlayStyle
import 'package:tankerpmc/pmc/adddepartment.dart';
import 'package:tankerpmc/pmc/addstp.dart';
import 'package:tankerpmc/pmc/dashboard.dart';
import 'package:tankerpmc/pmc/report_pmc.dart';
import 'package:tankerpmc/pmc/wardofficerreg.dart';
import 'package:tankerpmc/widgets/dimensions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

// ignore: non_constant_identifier_names
List<Map> Services = [];
List<dynamic> count = [];
// ignore: non_constant_identifier_names
String RegisteredBuilders = '';
// ignore: non_constant_identifier_names
String RegisteredSTPs = '';

class _HomePageState extends State<HomePage> {
  int pageIdx = 0;
  int currentIdx = 0;

  List Pages = [
    const Dashboard(),
    const AddStp(),
    const ReportPCMC(),
    const OfficerRegistration(),
    const AddDepartment(),
    // const ProfilePCMC(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // ✅ ensures no pink/black bg
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        currentIndex: pageIdx,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house_fill,
                size: 35, color: Color(0xff3d53b1)),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add_home_outlined,
                size: 35, color: Color(0xff3d53b1)),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.summarize_outlined,
                size: Dimensions.height35, color: Color(0xff3d53b1)),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.app_registration,
                size: 35, color: Color(0xff3d53b1)),
            label: '',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.add, size: 35, color: Color(0xff3d53b1)),
            label: '',
          ),
        ],
        onTap: (idx) {
          setState(() {
            pageIdx = idx;
          });
        },
      ),
      body: Pages[pageIdx],
    );
  }
}

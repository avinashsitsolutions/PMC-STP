import 'dart:async';
import 'dart:io';
//import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tankerpmc/Auth/authservices.dart';
import 'package:tankerpmc/Auth/login.dart';
import 'package:tankerpmc/TankerDriver/tankerdriverDashboard.dart';
import 'package:tankerpmc/builder/dashboard_builder.dart';
import 'package:tankerpmc/garage/dashboard_garage.dart';
import 'package:tankerpmc/pmc/homepage.dart';
import 'package:tankerpmc/pmc_newuser/dashboard.dart';
import 'package:tankerpmc/sitemanager/managerdashboard.dart';
import 'package:tankerpmc/society/dashboard_society.dart';
import 'package:tankerpmc/society/getlatlongsociety.dart';
import 'package:tankerpmc/stp/dashboard_stp.dart';
import 'package:tankerpmc/tanker/dashboard_tanker.dart';
import 'package:tankerpmc/wardofficer/wardofficerdashboard.dart';
import 'package:url_launcher/url_launcher.dart';
import 'internet_connection.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({Key? key}) : super(key: key);

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  String? mb;
  String? version;

  @override
  void initState() {
    super.initState();

    /// ✅ Hide status bar only for splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // checkAndUpdateAppVersion();
    checkIsLogin();
  }

  @override
  void dispose() {
    /// ✅ Restore status bar when leaving splash
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  Future<bool> checkAppUpdateStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool updated = prefs.getBool('appUpdated') ?? false;
    return updated;
  }

  checkIsLogin() {
    Timer(const Duration(seconds: 5), () async {
      SharedPreferences prefss = await SharedPreferences.getInstance();
      var auth = prefss.getString("isAuthenticated");
      var userType = prefss.getString("user_type");
      var latlong = prefss.getString("updatelatlong");
      var tankerowner = prefss.getString("tankerowner");

      if (auth == "true") {
        if (userType == "admin") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const HomePage()));
        } else if (userType == "Stp") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashboardStp()));
        } else if (userType == "Builder") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardBuilder()));
        } else if (userType == "Tanker") {
          if (tankerowner == "true") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardTanker()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardTankerDriver()));
          }
        } else if (userType == "Society") {
          if (latlong == "true") {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const DashboardSociety()));
          } else {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Societylatlong()));
          }
        } else if (userType == "Garage") {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const DashboardGarage()));
        } else if (userType == "Manager") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardManager()));
        } else if (userType == "Wardofficer") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardWardOfficer()));
        } else if (userType == "PCMC") {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const DashboardPCMCUSER()));
        }
      } else {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => const Login()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: []),
              Column(
                children: [
                  Image.asset("assets/TWRRS.png", scale: 1),
                  const SizedBox(height: 20),
                  const Text(
                    "Pune Municipal Corporation",
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "STP Water Tanker System",
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.black),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: []),
            ],
          ),
        ),
      ),
    );
  }
}

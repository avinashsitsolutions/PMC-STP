import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter_android/google_maps_flutter_android.dart';
import 'package:google_maps_flutter_platform_interface/google_maps_flutter_platform_interface.dart';
import 'package:tankerpmc/Auth/splashscreen.dart';

AndroidMapRenderer mapRenderer = AndroidMapRenderer.platformDefault;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Set global system UI style (status bar & nav bar)
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white, // White background for status bar
    statusBarIconBrightness: Brightness.dark, // Dark icons (Android)
    statusBarBrightness: Brightness.light, // Dark icons (iOS)
    systemNavigationBarColor: Colors.white, // White bottom nav bar
    systemNavigationBarIconBrightness: Brightness.dark,
  ));

  // ✅ Google Maps surface (Android only)
  if (Platform.isAndroid) {
    final GoogleMapsFlutterPlatform platformInstance =
        GoogleMapsFlutterPlatform.instance;
    if (platformInstance is GoogleMapsFlutterAndroid) {
      platformInstance.useAndroidViewSurface = true;
    }
  }

  // ✅ Check connectivity
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // You can show a "No Internet" screen here if you want
  } else {
    runApp(const MyApp());
  }
}

class MyApp extends StatelessWidget {
  static const customColor = Color(0xFFE5A7A7);

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'PMC STP Water Tanker System',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        scaffoldBackgroundColor: Colors.white, // ✅ Global Scaffold background
        canvasColor: Colors.white,
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Colors.white, // ✅ solid white everywhere
          elevation: 0,
        ),
        primarySwatch:
            createMaterialColor(const Color.fromARGB(255, 63, 81, 181)),
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Colors.red,
        ),
      ),
      home: const SpalshScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

MaterialColor createMaterialColor(Color color) {
  List strengths = <double>[.05];
  Map<int, Color> swatch = <int, Color>{};
  final int r = color.red, g = color.green, b = color.blue;

  for (int i = 1; i < 10; i++) {
    strengths.add(0.1 * i);
  }

  for (var strength in strengths) {
    final double ds = 0.5 - strength;
    swatch[(strength * 1000).round()] = Color.fromRGBO(
      r + ((ds < 0 ? r : (255 - r)) * ds).round(),
      g + ((ds < 0 ? g : (255 - g)) * ds).round(),
      b + ((ds < 0 ? b : (255 - b)) * ds).round(),
      1,
    );
  }

  return MaterialColor(color.value, swatch);
}

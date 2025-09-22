import 'dart:math';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:tankerpmc/Auth/splashscreen.dart';

class CheckInternetConnectionWidget extends StatelessWidget {
  final AsyncSnapshot<ConnectivityResult> snapshot;
  final Widget widget;

  const CheckInternetConnectionWidget({
    Key? key,
    required this.snapshot,
    required this.widget,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!snapshot.hasData) {
      return const Center(child: CircularProgressIndicator());
    }

    final state = snapshot.data;
    if (state == ConnectivityResult.none) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.wifi_off_rounded, size: 40, color: Colors.red),
            SizedBox(height: 10),
            Text(
              'Internet Not Connected',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
          ],
        ),
      );
    }

    // ✅ Connected → show actual widget
    return widget;
  }
}

// ignore: must_be_immutable
class InternetConnectivityScreen extends StatelessWidget {
  InternetConnectivityScreen({Key? key}) : super(key: key);

  final Random random = Random();

  @override
  Widget build(BuildContext context) {
    final connectivity = Connectivity();

    return Scaffold(
      body: SafeArea(
        child: StreamBuilder<ConnectivityResult>(
          stream: connectivity.onConnectivityChanged, // ✅ fixed
          builder: (_, snapshot) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CheckInternetConnectionWidget(
                snapshot: snapshot,
                widget: const SpalshScreen(), // ✅ fixed typo
              ),
            );
          },
        ),
      ),
    );
  }
}

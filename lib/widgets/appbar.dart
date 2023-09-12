import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Appbarwid extends StatefulWidget {
  const Appbarwid({super.key});

  @override
  State<Appbarwid> createState() => _AppbarwidState();
}

class _AppbarwidState extends State<Appbarwid> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      titleSpacing: 0,
      toolbarHeight: 150,
      centerTitle: true,
      title: Row(
        children: [
          InkWell(
            // ignore: deprecated_member_use
            onTap: () => launch('https://pcmcindia.gov.in/index.php'),
            child: const Image(
              image: AssetImage('assets/pcmc_logo.jpg'),
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
                "Pimpri-Chinchwad Municipal Corporation",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12),
              ),
              SizedBox(height: 5),
              Text(
                "Treated Water Recycle and Reuse System",
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
                color: Colors.white,
              ),
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            );
          },
        ),
      ],
    );
  }

  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

import 'package:fademasterz/Utils/app_assets.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Dashboard/dashboard.dart';
import '../enter_your_no.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Image.asset(
        AppAssets.splash,
        width: MediaQuery.of(context).size.width,
        fit: BoxFit.cover,
      ),
    );
  }

  @override
  void initState() {
    // Future.delayed(const Duration(seconds: 3), () {
    //   // FlutterNativeSplash.remove();
    //
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const EnterYourNo(),
    //     ),
    //   );
    // });
    getLocalData();

    // final listener =
    //     InternetConnection().onStatusChange.listen((InternetStatus status) {
    //   switch (status) {
    //     case InternetStatus.connected:
    //       debugPrint(
    //           '>>>>>>>>>>>>>>${'Data connection is available.'}<<<<<<<<<<<<<<');
    //       // The internet is now connected
    //       break;
    //     case InternetStatus.disconnected:
    //       Utility.showNoGetNetworkDialog(context);
    //       debugPrint(
    //           '>>>>>>>>>>>>>>${'You are disconnected from the internet.'}<<<<<<<<<<<<<<');
    //       // The internet is now disconnected
    //       break;
    //   }
    // });

    super.initState();
  }

  bool? profileSetUp = false;
  Future<void> getLocalData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    profileSetUp = prefs.getBool('profileSetUp');
    setState(() {});
    Future.delayed(const Duration(seconds: 3), () {
      // FlutterNativeSplash.remove();
      if (profileSetUp ?? false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(selectIndex: 0),
          ),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const EnterYourNo(),
          ),
        );
      }
    });
  }
}

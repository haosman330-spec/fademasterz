import 'dart:developer';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:upgrader/upgrader.dart';

import 'Notification/notification_service.dart';
import 'Screen/SplashScreen/splash_screen.dart';
import 'Utils/app_color.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // await FirebaseAppCheck.instance.activate(
  //     androidProvider: AndroidProvider.playIntegrity,
  //     appleProvider: AppleProvider.debug);
  await Upgrader.clearSavedSettings();

  FirebaseMessaging.onBackgroundMessage(_backgroundHandler);
  NotificationService.initialize();
  final accessToken = await getAccessToken();

  log('>>>>Access Token:>>>>>>>>>>$accessToken<<<<<<<<<<<<<<');

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then(
    (value) => runApp(
      const MyApp(),
    ),
  );
}

Future<void> _backgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  await updateFirestoreCount();

  debugPrint('Handling a background title>>>> ${message.notification?.title}');
  debugPrint('Handling a background body>>>> ${message.notification?.body}');
  debugPrint('Background state>>>');
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    _getId();

    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // Transparent status bar
      statusBarBrightness: Brightness.light, // Dark text for status bar
    ));
    return FirebasePhoneAuthProvider(
      child: UpgradeAlert(
        dialogStyle: UpgradeDialogStyle.cupertino,
        child: MaterialApp(
          navigatorKey: navigatorKey,
          title: 'Fade Masterz',
          themeMode: ThemeMode.system,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: AppColor.yellow),
            useMaterial3: false,
          ),
          home: const SplashScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
        ),
      ),
    );
  }

  String? deviceType;
  String? deviceId;
  Future<String?> _getId() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var deviceInfo = DeviceInfoPlugin();

    if (Platform.isIOS) {
      var iosDeviceInfo = await deviceInfo.iosInfo;
      deviceType = 'ios';
      deviceId = iosDeviceInfo.identifierForVendor;
      sharedPreferences.setString('deviceType', deviceType!);
      sharedPreferences.setString('deviceId', deviceId!);

      return iosDeviceInfo.identifierForVendor;

      // unique ID on iOS
    } else if (Platform.isAndroid) {
      var androidDeviceInfo = await deviceInfo.androidInfo;
      deviceType = 'android';
      deviceId = androidDeviceInfo.id;
      sharedPreferences.setString('deviceType', deviceType!);
      sharedPreferences.setString('deviceId', deviceId!);

      return androidDeviceInfo.id; // unique ID on Android
    }
    return null;
  }
}

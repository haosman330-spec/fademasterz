/*import 'dart:io';
import 'dart:math';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class FirebaseServices {
  static FirebaseMessaging messaging = FirebaseMessaging.instance;
  static const AndroidInitializationSettings androidInitializationSettings =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  static bool title = false;

  static const DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
          defaultPresentSound: true,
          defaultPresentAlert: true,
          defaultPresentBadge: true,
          requestAlertPermission: true,
          requestSoundPermission: true,
          requestBadgePermission: true,
          onDidReceiveLocalNotification: onDidReceiveLocalNotification);

  ///.....FCM Token........................
  static Future<String?> getFcm() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    String? token = await FirebaseMessaging.instance.getToken();
    debugPrint("fcm token.....$token");
    sharedPreferences.setString('fcmToken', token!);
  }

  static void initialNotification() async {
    var initializationSettingsAndroid = androidInitializationSettings;

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // final NotificationAppLaunchDetails? notificationAppLaunchDetails =
    // await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  }

  static void requestNotificationPermission() async {
    ///new add
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: true,
        badge: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true,
        sound: true);
    const AndroidNotificationChannel(
      "high_importance_channel",
      "High Importance Notifications",
      importance: Importance.max,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );
    if (Platform.isAndroid) {
      await messaging.setForegroundNotificationPresentationOptions(
        alert: true, // Required to display a heads up notification
        badge: true,
        sound: true,
      );
    }

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      debugPrint('user denied permission');
    }

    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  static void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization = androidInitializationSettings;
    var initializationSettingsIOS = const DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSetting = InitializationSettings(
        android: androidInitialization, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      debugPrint("payload>>>>>>$payload");

      handleMessage(context, message);
    });
  }

  static Future<void> onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    // Handle the notification when it's received on iOS
  }

  ///handle tap on notification when app is in background or terminated

  static Future<void> setupInteractMessage(BuildContext context) async {
    /// when app is terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();

    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    ///when app is  background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      if (initialMessage != null) {
        handleMessage(context, event);
      }
    });

    ///When App is Open
    FirebaseMessaging.onMessage.listen((message) {
      title = true;
      if (kDebugMode) {
        debugPrint("title<><><>${message.notification!.title}");
        debugPrint("body<><><>${message.notification!.body}");
        debugPrint("data<><><>Notification : ${message.data}");
        debugPrint("notifications title : ${message.notification!.title}");
      }

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotification(message);
      } else if (Platform.isIOS) {
        initLocalNotifications(context, message);
        //showNotification(message);
      }
    });
  }

  @pragma('vm:entry-point')
  static Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    debugPrint(
        "_firebaseMessagingBackgroundHandler Clicked!${message.notification!.android!.clickAction}");
    debugPrint(
        "_firebaseMessagingBackgroundHandler title!${message.notification!.title}");

    debugPrint("onMessage data: ${message.data}");
    // showNotification(message);
  }

  static Future<void> showNotification(RemoteMessage message) async {
    AndroidNotificationChannel androidNotificationChannel =
        AndroidNotificationChannel(Random.secure().nextInt(100000).toString(),
            'High Importance Notification',
            importance: Importance.max);

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      androidNotificationChannel.id.toString(),
      androidNotificationChannel.name.toString(),
      channelDescription: 'your channel description',
      importance: Importance.high,
      priority: Priority.max,
      ticker: 'ticker',
      icon: '@mipmap/ic_launcher',
      playSound: true,
    );

    DarwinNotificationDetails darwinNotificationDetails =
        const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    NotificationDetails notificationDetails = NotificationDetails(
        android: androidNotificationDetails, iOS: darwinNotificationDetails);

    Future.delayed(Duration.zero, () {
      flutterLocalNotificationsPlugin.show(
          0,
          message.notification!.title.toString(),
          message.notification!.body.toString(),
          notificationDetails);
    });
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
      debugPrint("refresh>>Token>>");
    });
  }

  static Future<void> handleMessage(
      BuildContext context, RemoteMessage message) async {
    debugPrint("get......");

    String notificationScreenOpen = "notification_redirect";

    debugPrint("debugPrintNotificationRedirect>>>$notificationScreenOpen");

    String surveyId = message.data['survey_id'];

    try {
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //     MaterialPageRoute(
      //   builder: (context) =>
      //     //   NewsDetail(
      //     // news_id: int.parse(news_id),
      //     const NotificationPage(),
      //
      // )
      //
      // );
      // navigatorKey.currentState?.pushAndRemoveUntil(
      //   MaterialPageRoute(
      //       builder: (context) => const NotificationPage(
      //       )),
      //       (route) => false,
      // );
    } catch (e) {
      debugPrint("Navigation error: $e");
    }
  }
}*/

import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fademasterz/Screen/Dashboard/dashboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../Screen/Booking/cancelled_booking_details.dart';
import '../Screen/Booking/complete_booking_details.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
String? tokenFcmChat;

class NotificationService {
  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static void notificationTapBackground(message) {
    //_handleMessage(message);
  }
  static void initialize() async {
    var messaging = FirebaseMessaging.instance;
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        defaultPresentSound: true,
        defaultPresentAlert: true,
        defaultPresentBadge: true,
        requestAlertPermission: true,
        requestSoundPermission: true,
        requestBadgePermission: true,
      ),
    );

    await messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            "high_importance_channel",
            "High Importance Notifications",
            importance: Importance.max,
            playSound: true,
            enableVibration: true,
            showBadge: true,
          ),
        );

    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    try {
      await FirebaseMessaging.instance.setAutoInitEnabled(true);
      String? fcmToken;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      fcmToken = await FirebaseMessaging.instance.getToken();

      if (fcmToken?.isNotEmpty ?? false) {
        //    prefs.setString("fcm_token", fcmToken.toString());
        //     debugPrint('fcm token is>>${fcmToken.toString()}');
      }
      // ignore: empty_catches
    } catch (e) {}

    FirebaseMessaging.instance.getInitialMessage().then(
      (message) async {
        /// This function is for app kill state

        debugPrint(
            'kill state >>> FirebaseMessaging.instance.getInitialMessage');
        if (message != null) {
          // var notificationData = NotificationDataModel.fromJson(message.data);
          // _handleMessage(notificationData);
          debugPrint('New Notification');
        }
      },
    );

    // FirebaseMessaging.onBackgroundMessage((message) async {
    //   var notificationData = NotificationDataModel.fromJson(message.data);
    //   _handleMessage(notificationData);
    // });

    FirebaseMessaging.onMessage.listen(
      (message) async {
        /// This function is for foreground state
        debugPrint('foreground >>> FirebaseMessaging.onMessage.listen');
        debugPrint('data foreground is>>> ${message.data['booking_id']}');
        debugPrint('data foreground is>>> ${message.data.toString()}');
        debugPrint('>>>>>>>>>>>>>>${message.data['type']}<<<<<<<<<<<<<<');
        if (message.notification != null) {
          debugPrint(
              'Message notification is>>> ${message.notification.toString()}');
          display(message);
          debugPrint('>>>>>>>>>>>>>>${message.data['type']}<<<<<<<<<<<<<<');
          //await updateFirestoreCount();
          _flutterLocalNotificationsPlugin.initialize(initializationSettings,
              onDidReceiveBackgroundNotificationResponse:
                  notificationTapBackground,
              onDidReceiveNotificationResponse: (msg) {
            debugPrint('>>>>>>>>>>>>>>${message.data['type']}<<<<<<<<<<<<<<');
            // var notificationData = NotificationDataModel.fromJson(message.data);
            // if (message.data['type'] == 'cancelled') {
            //   navigatorKey.currentState?.pushAndRemoveUntil(
            //     MaterialPageRoute(
            //         builder: (context) => CancelledBookingDetail(
            //             cancelBookingId:  message.data['booking_id'],
            //             )),
            //     (route) => false,
            //   );
            // }
            _handleMessage(message.data);
          });
        }
      },
    );

    FirebaseMessaging.onMessageOpenedApp.listen(
      (message) async {
        /// This function is for background state

        debugPrint(
            'background >>>> FirebaseMessaging.onMessageOpenedApp.listen');
        debugPrint('data background is ${message.data.toString()}');
        //   var notificationData = NotificationDataModel.fromJson(message.data);
        if (message.notification != null) {
          debugPrint(
              'message title on background is ${message.notification!.title}');
          debugPrint(
              'message body on background is ${message.notification!.body}');
          //  _handleMessage(notificationData);
          debugPrint("message.data22 ${message.data['booking_id']}");
        }
      },
    );
  }

  static void display(RemoteMessage message) async {
    try {
      debugPrint('In Notification method');
      Random random = Random();
      int id = random.nextInt(1000);
      const NotificationDetails notificationDetails = NotificationDetails(
        iOS: DarwinNotificationDetails(
          presentSound: true,
        ),
        android: AndroidNotificationDetails(
          "high_importance_channel",
          "High Importance Notifications",
          importance: Importance.max,
          priority: Priority.high,
          playSound: true,
        ),
      );
      debugPrint('my id is ${id.toString()}');
      await _flutterLocalNotificationsPlugin.show(
        id,
        message.notification?.title ?? 'N/A',
        message.notification?.body ?? 'N/A',
        notificationDetails,
        payload: message.data['_id'],
      );
    } on Exception catch (e) {
      debugPrint('Error>>>$e');
    }
  }
}

List<String> scopes = ['https://www.googleapis.com/auth/cloud-platform'];

Future<Map<String, dynamic>> _getServiceAccountKey() async {
  final String response = await rootBundle.loadString(
      'assets/fade-masterz-firebase-adminsdk-7y61s-c3e9bf1a49.json');
  return json.decode(response);
}

// Function to get the access token
Future<String> getAccessToken() async {
  try {
    final Map<String, dynamic> key = await _getServiceAccountKey();

    final accountCredentials = ServiceAccountCredentials(
      key['client_email'],
      ClientId(key['client_id']),
      key['private_key'],
    );

    final authClient =
        await clientViaServiceAccount(accountCredentials, scopes);

    // Obtain the access token
    final accessToken = (authClient.credentials).accessToken;

    debugPrint('>>>>>>>>>>>>>>${accessToken.data}<<<<<<<<<<<<<<');
    tokenFcmChat = accessToken.data;
    // Close the auth client to prevent memory leaks
    authClient.close();

    return accessToken.data;
  } catch (e) {
    throw Exception('Error obtaining access token: $e');
  }
}

Future<void> updateFirestoreCount() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String userId = prefs.getString('receiverId') ?? '';
  await FirebaseFirestore.instance.collection('notifications').doc(userId).set(
    {'count': FieldValue.increment(1)},
    SetOptions(merge: true),
  );
  debugPrint('Increment success>>>>');
}

/// Notification Payload Response
// {
// "sound": "default",
// "body": "Please reset the step count for today by clicking this notification or by opening app!",
// "type": "steps",
// "title": "A reminder for steps reset!",
// "click_action": "FLUTTER_NOTIFICATION_CLICK"
// }

void _handleMessage(data) async {
  debugPrint('data is>>> ${data.toString()}');
  // debugPrint('clickAction>>> is ${data.clickAction.toString()}');
  // debugPrint('body>>> is ${data.body.toString()}');
  // steps

  if (data['type'] == null) {
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => const DashBoardScreen(
          selectIndex: 0,
        ),
      ),
    );
  } else if (data['type'] == 'cancelled') {
    int bookingId = int.parse(data['booking_id']);
    debugPrint('>>>>>>>>>>>>>>$bookingId<<<<<<<<<bookingId<<<<<');
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => CancelledBookingDetail(
          cancelBookingId: bookingId,
        ),
      ),
    );
  } else if (data['type'] == 'completed') {
    int bookingId = int.parse(data['booking_id']);
    navigatorKey.currentState?.push(
      MaterialPageRoute(
        builder: (context) => CompleteBookingDetail(
          bookingId: bookingId,
        ),
      ),
    );
  }
  // else {
  //   navigatorKey.currentState?.push(MaterialPageRoute(
  //       builder: (context) => DashboardScreen(selectedIndex: 0)));
  // }
  //ISSUE BELOW
  /// If using pushReplacement, myOrderScreen is visible perfect.
  /// ISSUE If using push, myOrderScreen is visible for some seconds and then navigating to Dashboard(0) for some reason
}

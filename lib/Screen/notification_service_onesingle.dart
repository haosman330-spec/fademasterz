/*
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';

class OneSignalServices {
  String oneSignalAppId = "1a2e3645-f5bf-4f4e-83e0-ea723fcc9420";
  String? _emailAddress;
  String? _smsNumber;
  String? _externalUserId;
  String? _language;
  String? _liveActivityId;
  bool _enableConsentButton = false;
  String debugLabelString = "";

  // CHANGE THIS parameter to true if you want to test GDPR privacy consent
  final bool _requireConsent = false;

  Future<void> initPlatformState() async {
    OneSignal.initialize(oneSignalAppId);
    await OneSignal.Notifications.requestPermission(true);

    // Generate PlayerId..............
    var playerID = OneSignal.User.pushSubscription.id;
    debugPrint("player.....$playerID");
    //  LocalStorageServices.savingData(LocalStorageServices.fcmToken, playerID);

    OneSignal.User.addObserver((state) {
      var userState = state.jsonRepresentation();
      print('OneSignal user changed: $userState');
    });

    OneSignal.User.pushSubscription.addObserver((state) {
      debugPrint("ttt${OneSignal.User.pushSubscription.optedIn}");
      debugPrint("ttt${OneSignal.User.pushSubscription.id}");
      debugPrint("ttt${OneSignal.User.pushSubscription.token}");
      debugPrint("hhjkmk${state.current.jsonRepresentation()}");
    });

    // await OneSignal.Notifications.requestPermission(true);
    OneSignal.LiveActivities.setupDefault();

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission $state");
    });
//    OneSignal.Notifications.clearAll();

    OneSignal.Notifications.addClickListener((event) {
      debugLabelString =
          "Clicked notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      debugPrint(
          'NOTIFICATION CLICK LISTENER CALLED WITH EVENT: $debugLabelString');
      //     _handleNotificationOpened(event);
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      debugPrint(
          'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();

      debugLabelString =
          "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
    });

    OneSignal.InAppMessages.addClickListener((event) {
      debugLabelString =
          "In App Message Clicked: \n${event.result.jsonRepresentation().replaceAll("\\n", "\n")}";
      //   _handleNotificationOpened(event);
    });
    OneSignal.InAppMessages.addWillDisplayListener((event) {
      print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
    });

    _enableConsentButton = _requireConsent;
  }
  //
  // void _handleNotificationOpened(var result) {
  //   print('[notification_service - _handleNotificationOpened()....$result');
  //   print(
  //       "Opened notification: ${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}");
  //
  //   var res = result.notification.jsonRepresentation().replaceAll("\\n", "\n");
  //   debugPrint("model.aps!.alert!.title.toString()..${res}");
  //   NotificationModel model = NotificationModel.fromJson(res);
  //   debugPrint(
  //       "model.aps!.alert!.title.toString()..${model.aps!.alert!.title.toString()}");
  //   // Since the only thing we can get current are new Alerts -- go to the Alert screen
  //   //   navigatorKey.currentState!.pushNamed('/home');
  //   if (model.aps!.alert!.title.toString() == "Test Notification") {
  //     navigatorKey.currentState?.push(MaterialPageRoute(
  //         builder: (context) =>
  //             DetailView(adId: "1", checkIn: "checkIn", checkOut: "")));
  //   }
  // }
}
*/

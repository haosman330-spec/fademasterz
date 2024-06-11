import 'package:flutter/material.dart';

import 'app_color.dart';

class Utility {
  static progressLoadingDialog(BuildContext context, bool status) {
    if (status) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return const Center(
            child: CircularProgressIndicator(
              color: AppColor.yellow,
            ),
          );
        },
      );
      // return pr.show();
    } else {
      Navigator.pop(context);
      // return pr.hide();
    }
  }

  static showNoNetworkDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: AlertDialog(
              title: const Text('No Network Connection'),
              content: const Text(
                  'Please check your internet and Wi-Fi connection.'),
              actions: <Widget>[
                TextButton(
                  child: const Text('OK'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ));
      },
    );
  }

  static showNoGetNetworkDialog(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
            onWillPop: () async => false,
            child: const AlertDialog(
              title: Text('No Network Connection'),
              content: Text(
                'No Internet Please check your internet connection',
              ),
              // actions: <Widget>[
              //   TextButton(
              //     child: const Text('OK'),
              //     onPressed: () {
              //       Navigator.of(context).pop();
              //     },
              //   ),
              // ],
            ));
      },
    );
  }
}

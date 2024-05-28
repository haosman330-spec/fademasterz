import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';

import 'app_color.dart';

class Helper {
  void showToast(String msg,
      {Toast? toastLength,
      ToastGravity? gravity,
      int? timeInSecForIosWeb,
      Color? backgroundColor,
      String? textColor,
      double? fontSize}) {
    Fluttertoast.showToast(
      backgroundColor: AppColor.yellow,
      msg: msg,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
      fontSize: fontSize ?? 16.0,
      textColor: AppColor.black,
    );
  }
}

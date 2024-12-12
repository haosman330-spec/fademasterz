import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Screen/enter_your_no.dart';
import 'app_color.dart';
import 'app_fonts.dart';
import 'app_string.dart';

class Helper {

  void showToast(String msg,
      {Toast? toastLength,
      ToastGravity? gravity,
      int? timeInSecForIosWeb,
      Color? backgroundColor,
      String? textColor,
        Color? textColor1,
      double? fontSize}) {
    Fluttertoast.showToast(
      backgroundColor:backgroundColor?? AppColor.yellow,
      msg: msg,
      toastLength: toastLength ?? Toast.LENGTH_SHORT,
      gravity: gravity ?? ToastGravity.BOTTOM,
      timeInSecForIosWeb: timeInSecForIosWeb ?? 1,
      fontSize: fontSize ?? 16.0,
      textColor: textColor1 ?? AppColor.black,
    );
  }

  void isValidate() {}
}

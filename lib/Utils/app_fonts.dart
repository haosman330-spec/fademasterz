import 'package:fademasterz/Utils/app_color.dart';
import 'package:flutter/material.dart';

class AppFonts {
  static const regular = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 24,
    color: AppColor.white,
  );

  static const normalText = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 12,
    color: AppColor.white,
  );
  static const appText = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 18,
    color: AppColor.white,
  );
  static const textFieldFont = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 15,
    color: AppColor.white,
  );
  static TextStyle text = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColor.lightWhite,
  );
  static const TextStyle yellowFont = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColor.yellow,
  );
  static TextStyle redFont = const TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w500,
    fontSize: 16,
    color: AppColor.redColor,
  );
  static TextStyle text1 = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 14,
    color: AppColor.white.withOpacity(.51),
  );
  static TextStyle textFieldHint = const TextStyle(
      fontFamily: 'Poppins',
      fontWeight: FontWeight.w500,
      fontSize: 15,
      color: AppColor.gray);
  static const TextStyle blackFont = TextStyle(
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 16,
    color: AppColor.black,
  );
  static TextStyle selectBottomNavigationFont = const TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: AppColor.yellow,
  );
  static TextStyle unselectBottomNavigationFont = const TextStyle(
    fontFamily: 'Quicksand',
    fontWeight: FontWeight.w700,
    fontSize: 12,
    color: Color(0xffA0A0A0),
  );
}

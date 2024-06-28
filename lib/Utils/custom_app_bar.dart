import 'package:flutter/material.dart';

class MyAppBar {
  static myAppbar({
    final Widget? title,
    bool? centerTile = true,
    double? elevation,
    Color? color,
    Widget? leading,
    double? bottomOpacity,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title ?? const Text('App Bar'),
      shadowColor: const Color(
        0xffFFFFFF,
      ),
      centerTitle: centerTile,
      leading: leading,
      elevation: elevation ?? 0,
      backgroundColor: color ?? Colors.transparent,
    );
  }
}

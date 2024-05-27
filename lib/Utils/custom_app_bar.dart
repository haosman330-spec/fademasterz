import 'package:flutter/material.dart';

class MyAppBar {
  static myAppbar({
    final Widget? title,
    bool? centerTile = true,
    int? elevation,
    Color? color,
    Widget? leading,
  }) {
    return AppBar(
      automaticallyImplyLeading: false,
      title: title ?? const Text('App Bar'),
      centerTitle: centerTile,
      leading: leading,
      elevation: 0,
      backgroundColor: color ?? Colors.transparent,
    );
  }
}

import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String? title;
  final bool? readonly;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType? textInputType;
  final TextInputAction? textInputAction;
  final GestureTapCallback? onTap;
  final TextStyle? hintTextStyle;
  final TextStyle? style;
  final double? radius;
  final BorderSide? borderSide;
  final String hintText;
  final bool? obscureText;
  final bool? validator;
  final bool? isFilled;
  final bool? enabled;
  final Color? fillColor;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? maxLength;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  const CustomTextField({
    super.key,
    this.title,
    required this.controller,
    required this.hintText,
    this.textInputType,
    this.textInputAction,
    this.focusNode,
    this.onTap,
    this.hintTextStyle,
    this.radius,
    this.obscureText,
    this.fillColor,
    this.prefixIcon,
    this.suffixIcon,
    this.maxLength,
    this.maxLines,
    this.isFilled = true,
    this.borderSide,
    this.style,
    this.enabled,
    this.inputFormatters,
    this.validator,
    this.readonly,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please fill field';
        }
        return null;
      },
      readOnly: readonly ?? false,
      maxLines: maxLines ?? 1,
      maxLength: maxLength,
      controller: controller,
      focusNode: focusNode,
      obscureText: obscureText ?? false,
      keyboardType: textInputType,
      style: style ?? AppFonts.textFieldFont,
      textInputAction: textInputAction,
      cursorColor: AppColor.yellow,
      onTapOutside: (event) {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        filled: isFilled,
        fillColor: fillColor ?? AppColor.black,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        counterText: '',
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(radius ?? 16),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(
            radius ?? 16,
          ),
          borderSide: borderSide ?? BorderSide.none,
        ),
        hintText: hintText,
        hintStyle: hintTextStyle ?? AppFonts.textFieldHint,
      ),
      onTap: onTap,
    );
  }
}

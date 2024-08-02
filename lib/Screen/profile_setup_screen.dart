import 'dart:convert';

import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_assets.dart';
import '../Utils/app_fonts.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/custom_tex_field.dart';
import '../Utils/utility.dart';
import 'Dashboard/dashboard.dart';

class ProfileSetup extends StatefulWidget {
  final String phoneNo;
  const ProfileSetup({super.key, required this.phoneNo});

  @override
  State<ProfileSetup> createState() => _ProfileSetupState();
}

class _ProfileSetupState extends State<ProfileSetup> {
  TextEditingController phoneCn = TextEditingController();
  TextEditingController nameCn = TextEditingController();
  TextEditingController gmailCn = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    phoneCn.text = widget.phoneNo.toString();
    setState(() {});
    super.initState();

    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 37),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: SvgPicture.asset(
                AppIcon.backIcon,
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            const Text(
              AppStrings.profileSetup,
              style: AppFonts.regular,
            ),
            Text(
              AppStrings.profileInformation,
              style: AppFonts.text,
            ),
            const SizedBox(
              height: 30,
            ),
            CustomTextField(
              controller: nameCn,
              hintText: AppStrings.name,
              textInputType: TextInputType.text,
              textInputAction: TextInputAction.next,
              prefixIcon: Align(
                heightFactor: 2,
                widthFactor: 2,
                child: SvgPicture.asset(
                  AppIcon.parsonIcon,
                  height: 17,
                  width: 17,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: gmailCn,
              hintText: AppStrings.email,
              textInputType: TextInputType.emailAddress,
              textInputAction: TextInputAction.next,
              prefixIcon: Align(
                heightFactor: 2,
                widthFactor: 2,
                child: SvgPicture.asset(
                  AppIcon.gmailIcon,
                  height: 17,
                  width: 17,
                ),
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            CustomTextField(
              controller: phoneCn,
              readonly: true,
              hintText: AppStrings.mobileNo,
              textInputType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 11,
              hintTextStyle: AppFonts.textFieldFont,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(
                    r'^\d+?\d*',
                  ),
                ),
              ],
              prefixIcon: Align(
                heightFactor: 2,
                widthFactor: 2,
                child: SvgPicture.asset(
                  AppIcon.phoneIcon,
                  height: 17,
                  width: 17,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MyAppButton(
        title: AppStrings.next,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        onPress: () {
          if (isValidate()) {
            profileSetupApi(context);
          }
        },
      ),
    );
  }

  bool isValidate() {
    String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = RegExp(pattern);
    if (nameCn.text.isEmpty) {
      Helper().showToast('Please Enter Name');
      return false;
    } else if (gmailCn.text.isEmpty) {
      Helper().showToast('Please Enter Email');
      return false;
    } else if (!regex.hasMatch(gmailCn.text.trim())) {
      Helper().showToast('Invalid Email');
      return false;
    } else {
      return true;
    }
  }

  Future<void> profileSetupApi(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }
    var request = {};
    request["name"] = nameCn.text.trim();
    request["email"] = gmailCn.text.trim();

    var response = await http.post(
        Uri.parse(
          ApiService.profileSetup,
        ),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });

    if (context.mounted) {
      Utility.progressLoadingDialog(context, false);
    }

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );
    Helper().showToast(
      jsonResponse['message'],
    );
    if (jsonResponse['status'] == true) {
      sharedPreferences.setBool("profileSetUp", true);

      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const DashBoardScreen(
              selectIndex: 0,
            ),
          ),
          (Route<dynamic> route) => false,
        );
      }
    }
  }
}

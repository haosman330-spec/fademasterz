import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fademasterz/Modal/profile_modal.dart';
import 'package:fademasterz/Screen/edit_profile_screen.dart';
import 'package:fademasterz/Screen/help_screen.dart';
import 'package:fademasterz/Screen/privacy_policy_screen.dart';
import 'package:fademasterz/Screen/terms_condition_screen.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_fonts.dart';
import '../Utils/helper.dart';
import '../Utils/utility.dart';
import 'Booking/cancelled_booking_screen.dart';
import 'enter_your_no.dart';

class ProfileScreen extends StatefulWidget {
  final Function(int) onTap;
  const ProfileScreen({super.key, required this.onTap});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  ProfileModal profileModal = ProfileModal();
  ProfileUserData profileUserData = ProfileUserData();
  String? name;
  String? image;

  Future<void> userProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    image = sharedPreferences.getString('image');
    name = sharedPreferences.getString('name');

    setState(() {});
  }

  void updateProfile() {
    userProfile();
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    userProfile();

    setState(() {});
    super.initState();
  }

  Future<void> userLogoutApi(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }

    var request = {};
    var response = await http.post(
        Uri.parse(
          ApiService.logout,
        ),
        body: jsonEncode(request),
        headers: {
          "content-type": "application/json",
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });
    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );

    if (context.mounted) {
      Utility.progressLoadingDialog(
        context,
        false,
      );
    }
    Helper().showToast(jsonResponse['message']);
    if (jsonResponse['status'] == true) {
      await sharedPreferences.setBool("profileSetUp", false);
      await sharedPreferences.setString("access_Token", '');
      setState(() {});
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const EnterYourNo(),
            ),
            (route) => false);
      }
    } else if (jsonResponse['message'] == 'Unauthenticated.') {
      await sharedPreferences.setBool("profileSetUp", false);
      await sharedPreferences.setString("access_Token", '');
      setState(() {});
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const EnterYourNo(),
            ),
            (Route<dynamic> route) => false);
      }
    }
  }

  Future<void> deleteAccountApi(BuildContext context) async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }

    var request = {};
    var response = await http.post(
        Uri.parse(
          ApiService.deleteAccount,
        ),
        body: jsonEncode(request),
        headers: {
          "content-type": "application/json",
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")} '
        });
    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );

    if (context.mounted) {
      Utility.progressLoadingDialog(
        context,
        false,
      );
    }
    Helper().showToast(jsonResponse['message']);
    if (jsonResponse['status'] == true) {
      await sharedPreferences.setBool("profileSetUp", false);
      await sharedPreferences.setString("access_Token", '');
      setState(() {});
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const EnterYourNo(),
            ),
            (route) => false);
      }
    } else if (jsonResponse['message'] == 'Unauthenticated.') {
      await sharedPreferences.setBool("profileSetUp", false);
      await sharedPreferences.setString("access_Token", '');
      setState(() {});
      if (context.mounted) {
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(
              builder: (context) => const EnterYourNo(),
            ),
            (Route<dynamic> route) => false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.profile,
          style: AppFonts.appText,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      7,
                    ),
                    color: AppColor.black),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                        70,
                      ),
                      child: Visibility(
                        visible: (image?.isNotEmpty ?? false),

                        child: CachedNetworkImage(
                          imageUrl: ApiService.imageUrl + (image ?? ''),
                          height: 72,
                          width: 72,
                          fit: BoxFit.fill,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                value: downloadProgress.progress,
                              ),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        // child: Image.network(
                        //   ApiService.imageUrl + (image ?? ''),
                        //   height: 72,
                        //   width: 72,
                        //   fit: BoxFit.fill,
                      ),
                    ),

                    // _imageFile == null
                    //     ? Image.asset(
                    //         AppAssets.dummyImage,
                    //         height: 72,
                    //         width: 72,
                    //         fit: BoxFit.fill,
                    //       )
                    //     : Image.file(
                    //         _imageFile ?? File('path'),
                    //         height: 72,
                    //         width: 72,
                    //         fit: BoxFit.fill,
                    //       ),
                    //  ),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      (name ?? ''),
                      style: AppFonts.appText.copyWith(
                        fontSize: 17,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditProfileScreen(
                        updateProfile: updateProfile,
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      color: AppColor.black),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.parsonIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColor.white,
                          BlendMode.srcIn,
                        ),
                        //   color: AppColor.white,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.editProfile,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  widget.onTap(1);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.bookingIcon,
                        colorFilter: const ColorFilter.mode(
                          AppColor.white,
                          BlendMode.srcIn,
                        ),
                        //    color: AppColor.white,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.myBookings,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CancelledBookingScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.cancelledIcon,
                        //   color: AppColor.white,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.cancelledBookings,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PrivacyPolicyScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.privacyPolicyIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.privacyPolicy,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const TermsConditionScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.termConditionIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.termConditions,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  // Navigator.push(
                  //   context,
                  //   PageRouteBuilder(
                  //     transitionsBuilder:
                  //         (context, animation, secondaryAnimation, child) {
                  //       return ScaleTransition(
                  //         alignment: Alignment.center,
                  //         scale: Tween<double>(begin: 0.7, end: 1).animate(
                  //           CurvedAnimation(
                  //             parent: animation,
                  //             curve: Curves.bounceIn,
                  //           ),
                  //         ),
                  //         child: child,
                  //       );
                  //     },
                  //     transitionDuration: Duration(seconds: 2),
                  //     pageBuilder: (BuildContext context,
                  //         Animation<double> animation,
                  //         Animation<double> secondaryAnimation) {
                  //       return HelpScreen();
                  //     },
                  //   ),
                  // );
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HelpScreen(),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                        5,
                      ),
                      color: AppColor.black),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        //'assets/icon/cameraIcon.svg',
                        AppIcon.helpIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.help,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  showLogoutDialog();
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.logoutIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.logout,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () async {
                  showDeleteDialog(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 22,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      5,
                    ),
                    color: AppColor.black,
                  ),
                  child: Row(
                    children: [
                      SvgPicture.asset(
                        AppIcon.deleteIcon,
                        height: 20,
                        width: 20,
                      ),
                      const SizedBox(
                        width: 13,
                      ),
                      Expanded(
                        child: Text(
                          AppStrings.deleteAccount,
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SvgPicture.asset(
                        AppIcon.forwardIcon,
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future showLogoutDialog() async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              17,
            ),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 38,
              vertical: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcon.logout),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                      textAlign: TextAlign.center,
                      AppStrings.accountLogout,
                      style: AppFonts.appText.copyWith(
                        fontSize: 20,
                        color: const Color(0xff181725),
                      )),
                ),
                const SizedBox(
                  height: 52,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final List<ConnectivityResult> connectivityResult =
                              await (Connectivity().checkConnectivity());

                          if (connectivityResult
                              .contains(ConnectivityResult.mobile)) {
                            userLogoutApi(context);
                          } else if (connectivityResult
                              .contains(ConnectivityResult.wifi)) {
                            userLogoutApi(context);
                          } else {
                            if (context.mounted) {
                              Utility.showNoNetworkDialog(context);
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              17,
                            ),
                          ),
                          backgroundColor: AppColor.yellow,
                        ),
                        child: const Text(
                          AppStrings.yes,
                          style: AppFonts.blackFont,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();
                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              17,
                            ),
                          ),
                          backgroundColor: const Color(
                            0xffA4A4A4,
                          ),
                        ),
                        child: const Text(
                          AppStrings.no,
                          style: AppFonts.blackFont,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future showDeleteDialog(BuildContext context) async {
    return await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              17,
            ),
          ),
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 18,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 38,
              vertical: 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  AppIcon.logout,
                ),
                const SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Text(
                    textAlign: TextAlign.center,
                    AppStrings.accountDelete,
                    style: AppFonts.appText.copyWith(
                      fontSize: 20,
                      color: const Color(
                        0xff181725,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 52,
                ),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final List<ConnectivityResult> connectivityResult =
                              await (Connectivity().checkConnectivity());

                          if (connectivityResult
                              .contains(ConnectivityResult.mobile)) {
                            deleteAccountApi(context);
                          } else if (connectivityResult
                              .contains(ConnectivityResult.wifi)) {
                            deleteAccountApi(context);
                          } else {
                            Utility.showNoNetworkDialog(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              17,
                            ),
                          ),
                          backgroundColor: AppColor.yellow,
                        ),
                        child: const Text(
                          AppStrings.yes,
                          style: AppFonts.blackFont,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          Navigator.of(context).pop();

                          setState(() {});
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              17,
                            ),
                          ),
                          backgroundColor: const Color(
                            0xffA4A4A4,
                          ),
                        ),
                        child: const Text(
                          AppStrings.no,
                          style: AppFonts.blackFont,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Modal/profile_modal.dart';
import '../Utils/app_assets.dart';
import '../Utils/custom_app_bar.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/custom_tex_field.dart';
import '../Utils/helper.dart';
import '../Utils/utility.dart';

class EditProfileScreen extends StatefulWidget {
  final Function updateProfile;
  const EditProfileScreen({super.key, required this.updateProfile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController phoneCn = TextEditingController();
  TextEditingController nameCn = TextEditingController();
  TextEditingController emailCn = TextEditingController();
  final picker = ImagePicker();
  File? _imageFile;
  String? name;
  String? image;
  String? phone;
  String? email;
  ProfileUserData? profileUserData;
  ProfileModal? profileModal;
  Future<void> userProfile() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    image = sharedPreferences.getString('image');
    nameCn.text = (sharedPreferences.getString('name') ?? '');
    emailCn.text = (sharedPreferences.getString('email') ?? '');
    phoneCn.text = (sharedPreferences.getString('phone') ?? '');
    setState(() {});
  }

  @override
  void initState() {
    profileDetail(context);
    //userProfile();
    super.initState();
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
      }
    });
  }

  Future showOptions() async {
    showCupertinoModalPopup(
      barrierDismissible: false,
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: const Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
          CupertinoActionSheetAction(
            child: const Text('Cancel'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.editProfile,
          style: AppFonts.appText,
        ),
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcon.backIcon,
            height: 12,
            width: 15,
            //     color: Theme.of(context).appBarTheme.foregroundColor,
          ),
          onPressed: () {
            onCallback();

            setState(() {});
          },
        ),
      ),
      body: WillPopScope(
        onWillPop: () async => onCallback(),
        child: Visibility(
          visible: (profileModal?.data?.name?.isNotEmpty ?? false),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 20,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(70),
                        child: _imageFile == null
                            ? CachedNetworkImage(
                                imageUrl: ApiService.imageUrl + (image ?? ''),
                                height: 103,
                                width: 103,
                                fit: BoxFit.fill,
                                progressIndicatorBuilder:
                                    (context, url, downloadProgress) =>
                                        CircularProgressIndicator(
                                            value: downloadProgress.progress),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              )
                            : Image.file(
                                _imageFile ?? File('path'),
                                height: 103,
                                width: 103,
                                fit: BoxFit.fill,
                              ),
                      ),
                      Positioned(
                        bottom: 5,
                        right: 2,
                        child: InkWell(
                          onTap: () {
                            showOptions();
                          },
                          child: SvgPicture.asset(
                            AppIcon.cameraIcon,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                CustomTextField(
                  controller: nameCn,
                  hintText: AppStrings.name,
                  textInputType: TextInputType.text,
                  textInputAction: TextInputAction.next,
                  hintTextStyle: AppFonts.textFieldFont,
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
                  controller: emailCn,
                  hintText: AppStrings.email,
                  textInputType: TextInputType.emailAddress,
                  textInputAction: TextInputAction.next,
                  hintTextStyle: AppFonts.textFieldFont,
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
                  // inputFormatters: [
                  //   FilteringTextInputFormatter.allow(
                  //     RegExp(
                  //       r'^\d+?\d*',
                  //     ),
                  //   ),
                  // ],
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Not Update Mobile No'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                    // Helper().showToast('Not Update in Mobile No');
                  },
                  maxLength: 11,
                  hintTextStyle: AppFonts.textFieldFont,
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
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Visibility(
        visible: profileModal?.data?.name?.isNotEmpty ?? false,
        child: MyAppButton(
          title: AppStrings.update,
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          onPress: () async {
            final List<ConnectivityResult> connectivityResult =
                await (Connectivity().checkConnectivity());

            if (connectivityResult.contains(ConnectivityResult.mobile)) {
              if (context.mounted) userUpdateProfile(context);
            } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
              if (context.mounted) {
                userUpdateProfile(context);
              }
            } else {
              if (context.mounted) {
                Utility.showNoNetworkDialog(context);
              }
            }
          },
        ),
      ),
    );
  }

  onCallback() {
    Navigator.of(context).pop();
    widget.updateProfile();
    setState(() {});

    return false;
  }

  Future<void> userUpdateProfile(BuildContext context) async {
    FocusManager.instance.primaryFocus?.unfocus();
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    if (context.mounted) {
      Utility.progressLoadingDialog(
        context,
        true,
      );
    }
    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferences.getString("access_Token")}'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        ApiService.updateProfile,
      ),
    );

    Map<String, String> body = {
      'name': nameCn.text,
    };

    if (emailCn.text.isNotEmpty) {
      body['email'] = emailCn.text.trim();
    }

    request.fields.addAll(body);
    if (_imageFile != null) {
      request.files.add(
        await http.MultipartFile.fromPath('image', _imageFile?.path ?? ''),
      );
    }
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    _imageFile = null;
    setState(
      () {},
    );

    var result = await response.stream.bytesToString();

    var finalResult = jsonDecode(result);

    Helper().showToast(
      finalResult["message"],
    );

    if (context.mounted) {
      Utility.progressLoadingDialog(
        context,
        false,
      );
    }
    log('>>>>>>Api>>>>>>>>${ApiService.updateProfile}<<<<<<<<<<<<<<');
    log('>>>>>>request>>>>>>>>$request<<<<<<<<<<<<<<');
    log('>>>>>>>jsonResponse>>>>>>>${finalResult.toString()}<<<<<<<<<<<<<<');
    if (finalResult["status"] == true) {
      if (context.mounted) {
        profileDetail(context);
      }
      setState(() {});
    }
  }

  Future<void> profileDetail(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }
    var request = {};

    var response = await http.post(
        Uri.parse(
          ApiService.profile,
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
    // Helper().showToast(
    //   jsonResponse['message'],
    // );
    log('>>>>>>Api>>>>>>>>${ApiService.profile}<<<<<<<<<<<<<<');
    log('>>>>>>request>>>>>>>>$request<<<<<<<<<<<<<<');
    log('>>>>>>>jsonResponse>>>>>>>${jsonResponse.toString()}<<<<<<<<<<<<<<');
    if (jsonResponse['status'] == true) {
      profileModal = ProfileModal.fromJson(jsonResponse);

      image = profileModal?.data?.image;
      emailCn.text = (profileModal?.data?.email ?? '');
      nameCn.text = (profileModal?.data?.name ?? '');
      phoneCn.text =
          ('+${profileModal?.data?.countryCode}${profileModal?.data?.phone}');

      sharedPreferences.setString('image', profileModal?.data?.image ?? '');
      sharedPreferences.setString('name', profileModal?.data?.name ?? '');
      sharedPreferences.setString('email', profileModal?.data?.email ?? '');

      // sharedPreferences.setString(
      //     'User_Id', profileModal?.data?.id.toString() ?? '');
      sharedPreferences
          .setInt(
              'senderId', int.parse(profileModal?.data!.id?.toString() ?? ''))
          .toString();

      setState(() {});
    }
  }
}

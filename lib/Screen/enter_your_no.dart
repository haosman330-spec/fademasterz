import 'dart:convert';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fademasterz/Screen/verify_screen.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

import '../ApiService/api_service.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/helper.dart';
import '../Utils/utility.dart';

class EnterYourNo extends StatefulWidget {
  const EnterYourNo({super.key});

  @override
  State<EnterYourNo> createState() => _EnterYourNoState();
}

class _EnterYourNoState extends State<EnterYourNo> {
  TextEditingController phoneCn = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  CountryCode? _selectedCountry = CountryCode(
      name: 'United Kingdom',
      flagUri: 'flags/gb.png',
      code: 'GB',
      dialCode: '+44');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 62),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Image.asset(
                AppAssets.fadeMasterz,
                width: 160,
                height: 62,
              ),
            ),
            const SizedBox(
              height: 51,
            ),
            const Text(
              AppStrings.enterYourNumber,
              style: AppFonts.regular,
            ),
            Text(
              AppStrings.enterYourNumberLogin,
              style: AppFonts.text1,
            ),
            const SizedBox(
              height: 41,
            ),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: phoneCn,
                style: AppFonts.appText.copyWith(fontSize: 16),
                maxLength: 11,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                    RegExp(
                      r'^\d+?\d*',
                    ),
                  ),
                ],
                decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(16)),
                      borderSide: BorderSide.none,
                    ),
                    border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(Radius.circular(16))),
                    prefixIcon: CountryCodePicker(
                      onChanged: (data) {
                        _selectedCountry = data;
                        setState(() {});
                        // debugPrint(
                        //     '>>>>>>>>>>>>>>${data.name}<<name<<<<<<<<<<<<');
                        // debugPrint(
                        //     '>>>>>>>>>>>>>>${data.code}<<code<<<<<<<<<<<<');
                        debugPrint(
                            '>>>>>>>>>>>>>>${data.dialCode}<<dial code<<<<<<<<<<<<');
                        // debugPrint(
                        //     '>>>>>>>>>>>>>>${data.flagUri}<<flag<<<<<<<<<<<<');
                      },
                      initialSelection: 'GB',
                      favorite: const ['GB'],
                      countryFilter: const [
                        'GB',
                        'IN',
                      ],
                      // countryFilter: ['In', 'FR'],
                      textStyle: const TextStyle(
                        color: Color(
                          0xffFFFFFF,
                        ),
                      ),
                      flagDecoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            5,
                          ),
                        ),
                      ),
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false,
                    ),
                    filled: true,
                    fillColor: AppColor.black,
                    counterText: '',
                    hintText: AppStrings.phoneNumber,
                    hintStyle: AppFonts.textFieldHint),
              ),
            ),
            // Form(
            //   key: _formKey,
            //   child: CustomTextField(
            //     controller: phoneCn,
            //     hintText: AppStrings.phoneNumber,
            //     maxLength: 11,
            //     textInputType: TextInputType.number,
            //     textInputAction: TextInputAction.done,
            //     inputFormatters: [
            //       FilteringTextInputFormatter.allow(
            //         RegExp(
            //           r'^\d+?\d*',
            //         ),
            //       ),
            //     ],
            //     prefixIcon: Row(
            //       children: [
            //         const CountryCodePicker(
            //           onChanged: print,
            //           // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
            //           initialSelection: 'IT', textStyle: AppFonts.appText,
            //           favorite: ['+91', 'In'],
            //           // optional. Shows only country name and flag
            //           showCountryOnly: false,
            //           // optional. Shows only country name and flag when popup is closed.
            //           showOnlyCountryWhenClosed: false,
            //           // optional. aligns the flag and the Text left
            //           alignLeft: false,
            //         ),
            //         Align(
            //           heightFactor: 2,
            //           widthFactor: 2,
            //           child: SvgPicture.asset(
            //             AppIcon.phoneIcon,
            //             height: 17,
            //             width: 17,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MyAppButton(
        title: AppStrings.next,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        onPress: () async {
          if (isValidate()) {
            signUpOtpAuth();

            // verifyPhoneNumber(phoneCn.text);
            // final List<ConnectivityResult> connectivityResult =
            //     await (Connectivity().checkConnectivity());
            //
            // if (connectivityResult.contains(ConnectivityResult.mobile)) {
            //   enterNumberApi(context);
            // } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
            //   enterNumberApi(context);
            // } else {
            //   Utility.showNoNetworkDialog(context);
            // }
          }
        },
      ),
    );
  }

  bool isValidate() {
    if (phoneCn.text.isEmpty || phoneCn.text.length < 10) {
      Helper().showToast('Please Enter Mobile No.');
      return false;
    }
    return true;
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Future<void> enterNumberApi(BuildContext context) async {
    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }
    var request = {};
    request["country_code"] = "91";
    request['mobile_number'] = phoneCn.text.trim();

    var response = await http.post(
      Uri.parse(
        ApiService.enterNumber,
      ),
      body: jsonEncode(request),
      headers: {
        'Accept': 'application/json',
        'Content-Type': 'application/json',
      },
    );
    if (context.mounted) {
      Utility.progressLoadingDialog(context, false);
    }

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );
    Helper().showToast(
      jsonResponse['message'],
    );
    debugPrint(
        '>>>>>>> jsonResponse[message]>>>>>>>${jsonResponse['message']}<<<<<<<<<<<<<<');
    if (jsonResponse['status'] == true) {
      // if (context.mounted) {
      //   await Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => VerifyScreen(
      //         phoneNo: phoneCn.text.trim(),
      //       ),
      //     ),
      //   );
      // }
    }
  }

  Future<void> signUpOtpAuth() {
    Utility.progressLoadingDialog(context, true);
    FirebaseAuth auth = FirebaseAuth.instance;
    debugPrint(
        '>>>>>>>>>>>>>>${_selectedCountry?.dialCode}${phoneCn.text}<<<<<<<<<<<<<<');
    return auth.verifyPhoneNumber(
        phoneNumber: '${_selectedCountry?.dialCode}${phoneCn.text}',
        verificationCompleted: (e) {
          Utility.progressLoadingDialog(context, false);
          Helper().showToast(e.toString());
          debugPrint(
              '>>>>>>>>>>>>>>${'message ${e.verificationId}, phone ${e.smsCode} and error is $e'}<<<<<<<<<<<<<<');
          // await Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => VerifyScreen(
          //         phoneNo: phoneCn.text.toString(),
          //         verificationId: e.verificationId,
          //         selectedCountry: _selectedCountry),
          //   ),
          // );
        },
        verificationFailed: (e) {
          debugPrint(
              '>>>>>>>>>>>>>>${'message ${e.message}, phone ${e.phoneNumber} and error is $e'}<<<<<<<<<<<<<<');

          Helper().showToast('Otp failed $e');
          debugPrint('>>>>>>>Otp failed>>>>>>>$e<<<<<<<<<<<<<<');
          Utility.progressLoadingDialog(context, false);
        },
        codeSent: (String verificationId, int? token) async {
          debugPrint(
              '>>>>>>>>verificationId>>>>>>${verificationId}<<<<<<<<<<<<<<');
          Utility.progressLoadingDialog(context, false);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyScreen(
                  phoneNo: phoneCn.text.toString(),
                  verificationId: verificationId,
                  selectedCountry: _selectedCountry),
            ),
          );
        },
        timeout: const Duration(seconds: 60),
        codeAutoRetrievalTimeout: (String verificationId) {
          Utility.progressLoadingDialog(context, false);
          setState(() {});
        });
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    debugPrint(
        '>>>>>>>>>>>>>>${_selectedCountry?.dialCode}$phoneNumber}<<<<<<<<<<<<<<');
    FirebasePhoneAuthHandler(
      phoneNumber: "${_selectedCountry?.dialCode}$phoneNumber",
      // If true, the user is signed out before the onLoginSuccess callback is fired when the OTP is verified successfully.
      signOutOnSuccessfulVerification: false,

      linkWithExistingUser: false,
      builder: (context, controller) {
        return const SizedBox.shrink();
      },
      autoRetrievalTimeOutDuration: const Duration(seconds: 60),
      otpExpirationDuration: const Duration(seconds: 60),
      onLoginSuccess: (userCredential, autoVerified) {
        debugPrint("autoVerified: $autoVerified");
        debugPrint("Login success UID: ${userCredential.user?.uid}");
      },
      onLoginFailed: (authException, stackTrace) {
        debugPrint("An error occurred: ${authException.message}");
      },
      onError: (error, stackTrace) {},
    );
  }
}

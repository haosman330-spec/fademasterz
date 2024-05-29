import 'dart:async';
import 'dart:convert';

import 'package:country_code_picker/src/country_code.dart';
import 'package:fademasterz/Modal/verify_otp_modal.dart';
import 'package:fademasterz/Screen/profile_setup_screen.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_color.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/utility.dart';
import 'Dashboard/dashboard.dart';

class VerifyScreen extends StatefulWidget {
  final String? phoneNo;
  final String? verificationId;
  final CountryCode? selectedCountry;
  const VerifyScreen(
      {super.key, this.phoneNo, this.verificationId, this.selectedCountry});

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> {
  final formKey = GlobalKey<FormState>();
  TextEditingController otpTextFieldCn = TextEditingController();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  bool? profileSetUp = false;
  VerifyOtpModal verifyOtpModal = VerifyOtpModal();
  Timer? optTimer;
  int mobileOtpSecondsRemaining = 60;

  snackBar(String? message) {
    return ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message!),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void mobileStartTimer() {
    mobileOtpSecondsRemaining = 60;
    optTimer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        if (mobileOtpSecondsRemaining != 0) {
          mobileOtpSecondsRemaining--;
          if (mounted) {
            setState(() {});
          }
        } else {
          if (mounted) {
            setState(() {
              //  mobileEnableResend = true;
            });
          }
          optTimer?.cancel();
        }
      },
    );
  }

  @override
  void initState() {
    mobileStartTimer();
    super.initState();
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
              height: 50,
            ),
            const Text(
              AppStrings.verifyCode,
              style: AppFonts.regular,
            ),
            RichText(
              text: TextSpan(
                text: AppStrings.codeVerification,
                style: AppFonts.text1.copyWith(color: AppColor.lightWhite),
                children: <InlineSpan>[
                  TextSpan(
                    text: AppStrings.yourNumber,
                    style: AppFonts.text1.copyWith(color: AppColor.lightWhite),
                  ),
                  TextSpan(
                    text:
                        ' ${widget.selectedCountry?.dialCode}${widget.phoneNo}',
                    style: AppFonts.text1.copyWith(
                        color: AppColor.yellow, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            PinCodeTextField(
              appContext: context,
              textStyle: AppFonts.textFieldFont,
              length: 6,
              obscureText: true,
              //obscuringCharacter: '*',
              obscuringWidget: const Text(
                '*',
                style: AppFonts.textFieldFont,
              ),

              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              // validator: (v) {
              //   if (v!.length < 3) {
              //     return ;
              //   } else {
              //     return null;
              //   }
              // },
              pinTheme: PinTheme(
                inactiveFillColor: AppColor.black,
                inactiveColor: AppColor.yellow.withOpacity(.21),
                selectedColor: AppColor.yellow,
                selectedFillColor: AppColor.black,
                activeColor: AppColor.black,
                shape: PinCodeFieldShape.box,
                borderRadius: BorderRadius.circular(8),
                fieldHeight: 60,
                fieldWidth: 40,
                activeFillColor: AppColor.black,
              ),
              cursorColor: AppColor.yellow,
              animationDuration: const Duration(milliseconds: 300),
              enableActiveFill: true,
              errorAnimationController: errorController,
              controller: otpTextFieldCn,
              keyboardType: TextInputType.number,

              onCompleted: (v) {
                debugPrint("Completed");
              },
              // onTap: () {
              //   print("Pressed");
              // },
              onChanged: (value) {
                debugPrint(value);
                setState(() {
                  currentText = value;
                });
              },
              beforeTextPaste: (text) {
                debugPrint("Allowing to paste $text");

                return true;
              },
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(AppIcon.clockIcon),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  mobileOtpSecondsRemaining.toString(),
                  style: AppFonts.text1.copyWith(
                    fontSize: 18,
                    color: AppColor.yellow,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  AppStrings.dontRecive,
                  style: AppFonts.text1.copyWith(
                    color: AppColor.white,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    if (mobileOtpSecondsRemaining == 0) {
                      //  resendOtp(context);
                      resendOtpFirebaseAuth();
                    }
                  },
                  child: Text(
                    AppStrings.resend,
                    style: AppFonts.text1.copyWith(
                      color: mobileOtpSecondsRemaining == 0
                          ? AppColor.yellow
                          : AppColor.gray,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 30,
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: MyAppButton(
        title: AppStrings.verify,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        onPress: () async {
          if (isValidate()) {
            otpVerifyFirebase();
            // FirebaseAuth auth = FirebaseAuth.instance;
            // int error;
            // String otp = otpTextFieldCn.text;
            // if (otp.isEmpty) {
            //   error = 0;
            //   Helper().showToast('Please enter  otp');
            //   setState(() {});
            // } else if (otp.length < 6) {
            //   error = 1;
            //   Helper().showToast('Please enter conform otp');
            //   setState(() {});
            // } else {
            //   // verifyMobileNumber();
            //   setState(() {
            //     Utility.progressLoadingDialog(context, true);
            //   });
            //   final credential = PhoneAuthProvider.credential(
            //       verificationId: widget.verificationId.toString(),
            //       smsCode: otpTextFieldCn.text);
            //   debugPrint('>>>>>credential>>>>>>>>>${credential}<<<<<<<<<<<<<<');
            //   try {
            //     await auth.signInWithCredential(credential);
            //
            //     verifyOtp(context);
            //
            //     setState(() {});
            //   } catch (e) {
            //     setState(() {
            //       Utility.progressLoadingDialog(context, false);
            //     });
            //   }
            //
            //   setState(() {});
            // }
            // // final List<ConnectivityResult> connectivityResult =
            // //     await (Connectivity().checkConnectivity());
            // //
            // // if (connectivityResult.contains(ConnectivityResult.mobile)) {
            // //   verifyOtp(context);
            // // } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
            // //   verifyOtp(context);
            // // } else {
            // //   Utility.showNoNetworkDialog(context);
            // // }
          }
        },
      ),
    );
  }

  bool isValidate() {
    if (otpTextFieldCn.text.isEmpty) {
      Helper().showToast('Please Enter Otp');
      return false;
    } else {
      return true;
    }
  }

  Future<void> otpVerifyFirebase() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    int error;
    String otp = otpTextFieldCn.text;
    if (otp.isEmpty) {
      error = 0;
      Helper().showToast('Please enter  otp');
      setState(() {});
    } else if (otp.length < 6) {
      error = 1;
      Helper().showToast('Please enter conform otp');
      setState(() {});
    } else {
      // verifyMobileNumber();
      setState(() {
        Utility.progressLoadingDialog(context, true);
      });
      final credential = PhoneAuthProvider.credential(
          verificationId: widget.verificationId.toString(),
          smsCode: otpTextFieldCn.text);

      try {
        await auth.signInWithCredential(credential);
        //   Helper().showToast('Please enter confirm otp');
        verifyOtp(context);

        setState(() {});
      } catch (e) {
        setState(() {
          debugPrint('>>>>>>>>>>>>>>${e.toString()}<<<<<<<<<<<<<<');
          Helper().showToast('Please enter valid otp');
          Utility.progressLoadingDialog(context, false);
        });
      }

      setState(() {});
    }
    // final List<ConnectivityResult> connectivityResult =
    //     await (Connectivity().checkConnectivity());
    //
    // if (connectivityResult.contains(ConnectivityResult.mobile)) {
    //   verifyOtp(context);
    // } else if (connectivityResult.contains(ConnectivityResult.wifi)) {
    //   verifyOtp(context);
    // } else {
    //   Utility.showNoNetworkDialog(context);
    // }
  }

  Future<void> verifyOtp(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }
    var request = {};
    request["country_code"] = widget.selectedCountry?.dialCode;
    request['mobile_number'] = widget.phoneNo.toString();
    request["otp"] = otpTextFieldCn.text.trim();
    request["fcm_token"] = sharedPreferences.getString('fcmToken');
    request["device_id"] = sharedPreferences.getString('deviceId');
    request["device"] = sharedPreferences.getString('deviceType');

    var response = await http.post(
      Uri.parse(
        ApiService.verifyOtp,
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

    if (jsonResponse['status'] == true) {
      verifyOtpModal = VerifyOtpModal.fromJson(jsonResponse);

      sharedPreferences.setString(
          "access_Token", verifyOtpModal.data!.userDetail!.token.toString());
      var senderId = verifyOtpModal.data!.userDetail!.id;
      var email = verifyOtpModal.data!.userDetail!.email;

      debugPrint('>>>>>senderId>>>>>>>>>$senderId<<<<<<<<<<<<<<');
      sharedPreferences.setInt("senderId", senderId!);
      sharedPreferences.setString("email", email!);

      if (context.mounted) {
        if (verifyOtpModal.data?.isSetup == 'yes') {
          // sharedPreferences.setBool("profileSetUp", true);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  ProfileSetup(phoneNo: widget.phoneNo.toString()),
            ),
          );
        } else {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => const DashBoardScreen(selectIndex: 0),
            ),
            (route) => false,
          );
        }
      }
    }
  }

  Future<void> resendOtpFirebaseAuth() {
    Utility.progressLoadingDialog(context, true);
    FirebaseAuth auth = FirebaseAuth.instance;
    return auth.verifyPhoneNumber(
        phoneNumber: '${widget.selectedCountry?.dialCode}${widget.phoneNo}',
        verificationCompleted: (e) {
          setState(() {
            Utility.progressLoadingDialog(context, false);
          });
        },
        verificationFailed: (e) {
          setState(() {
            debugPrint(
                '>>>>>>>>>>>>>>${'message ${e.message}, phone ${e.phoneNumber} and error is $e'}<<<<<<<<<<<<<<');

            Helper().showToast('Otp failed $e');
            debugPrint('>>>>>>>Otp failed>>>>>>>$e<<<<<<<<<<<<<<');
            Utility.progressLoadingDialog(context, false);
          });
        },
        timeout: const Duration(seconds: 60),
        codeSent: (String verificationId, int? token) async {
          setState(() {
            Utility.progressLoadingDialog(context, false);
          });

          Helper().showToast(
              "Otp successfully sent to ${widget.selectedCountry?.dialCode}${widget.phoneNo}");
          mobileStartTimer();
          otpVerifyFirebase();
          setState(() {});
        },
        codeAutoRetrievalTimeout: (e) {
          setState(() {});
        });
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

/*  Future<void> resendOtp(BuildContext context) async {
    Utility.progressLoadingDialog(context, true);
    var request = {};
    request["country_code"] = "91";
    request['mobile_number'] = widget.phoneNo;

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
    // Helper().showToast(
    //   jsonResponse['message'],
    // );

    if (jsonResponse['status']) {
      mobileStartTimer();
    }
  }*/
}

import 'package:country_code_picker/country_code_picker.dart';
import 'package:fademasterz/Screen/Dashboard/dashboard.dart';
import 'package:fademasterz/Screen/verify_screen.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../Utils/custom_app_button.dart';
import '../Utils/helper.dart';

class EnterYourNo extends StatefulWidget {
  const EnterYourNo({super.key});

  @override
  State<EnterYourNo> createState() => _EnterYourNoState();
}

class _EnterYourNoState extends State<EnterYourNo> {
  TextEditingController phoneCn = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _verificationId;
  bool isLoading = false;
  CountryCode? _selectedCountry = CountryCode(
      name: 'United Kingdom',
      flagUri: 'flags/gb.png',
      code: 'GB',
      dialCode: '+44');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 62,
        ),
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
                style: AppFonts.appText.copyWith(
                  fontSize: 16,
                ),
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
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                decoration: InputDecoration(
                  enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        16,
                      ),
                    ),
                    borderSide: BorderSide.none,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(
                        16,
                      ),
                    ),
                  ),
                  prefixIcon: CountryCodePicker(
                    hideSearch: true,
                    dialogSize: const Size.fromHeight(200),
                    barrierColor: Colors.transparent,
                    onChanged: (data) {
                      _selectedCountry = data;
                      setState(() {});
                    },
                    initialSelection: 'GB',
                    favorite: const ['GB'],
                    countryFilter: const [
                      'GB',
                      'IN',
                    ],
                    padding: EdgeInsets.zero,
                    // countryFilter: ['In', 'FR']--,
                    textStyle: const TextStyle(
                      fontSize: 15,
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
                  hintStyle: AppFonts.textFieldHint,
                ),
              ),
            ),
            const SizedBox(
              height: 41,
            ),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const DashBoardScreen(selectIndex: 0),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColor.yellow,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      10,
                    ),
                  ),
                ),
                child: Text(
                  AppStrings.skip,
                  style: const TextStyle(
                    color: AppColor.black,
                    fontSize: 15,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: isLoading
          ? const CircularProgressIndicator(
              color: AppColor.yellow,
            )
          : MyAppButton(
              title: AppStrings.next,
              padding: const EdgeInsets.symmetric(
                horizontal: 15,
                vertical: 15,
              ),
              onPress: () async {
                if (isValidate()) {
                  // _signInWithMobileNumber();
                  signUpOtpAuth();
                }
              },
            ),
    );
  }

  bool isValidate() {
    if (phoneCn.text.isEmpty) {
      Helper().showToast(AppStrings.pleaseEnterMobileNo);
      return false;
    } else if (phoneCn.text.length < 10) {
      Helper().showToast(AppStrings.pleaseEnterMobileNo10Digit);
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

  /* Future<void> signUpOtpAuth() async {
    Utility.progressLoadingDialog(context, true);
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '${_selectedCountry?.dialCode}${phoneCn.text}',
        verificationCompleted: (PhoneAuthCredential credential) async {
          Utility.progressLoadingDialog(context, false);
          try {
            UserCredential userCredential =
            await auth.signInWithCredential(credential);
            Helper().showToast('Verification Successful');
            debugPrint('User signed in: ${userCredential.user}');
          } catch (error) {
            Helper().showToast('Error during auto sign-in: $error');
            log('Error during auto sign-in: $error');
          }
        },
        verificationFailed: (FirebaseAuthException e) {
          Utility.progressLoadingDialog(context, false);
          String errorMessage = e.message ?? 'OTP verification failed';
          Helper().showToast('Otp failed: $errorMessage');
          log('OTP failed: ${e.code}, $errorMessage');
        },
        codeSent: (String verificationId, int? resendToken) async {
          _verificationId = verificationId;
          debugPrint('>>>>>>Code sent: VerificationId: $_verificationId');
          Utility.progressLoadingDialog(context, false);

          // Navigate to VerifyScreen
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => VerifyScreen(
                phoneNo: phoneCn.text,
                verificationId: _verificationId,
                selectedCountry: _selectedCountry,
              ),
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          // Save verificationId when timeout occurs
          _verificationId = verificationId;
          debugPrint('Code auto retrieval timeout. VerificationId: $_verificationId');
        },
        timeout: const Duration(seconds: 60),
        // Adjust the timeout as needed
      );
    } catch (error) {
      if(mounted) {
        Utility.progressLoadingDialog(context, false);
      }
      Helper().showToast('Error: $error');
      debugPrint('Error in phone authentication: $error');
    }
  }*/

  Future<void> signUpOtpAuth() async {
    setState(() {
      isLoading = true; // ✅ Show loader when function starts
    });
    FirebaseAuth auth = FirebaseAuth.instance;

    try {
      await auth.verifyPhoneNumber(
        phoneNumber: '${_selectedCountry?.dialCode}${phoneCn.text}',
        verificationCompleted: (PhoneAuthCredential credential) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          debugPrint(
              '>>>>>>>verificationCompleted>>>>>>>${credential.verificationId}<<<<<<<<<<<<<<');
          // For iOS, auto-retrieve success
          Helper().showToast('Verification completed successfully');
        },
        verificationFailed: (FirebaseAuthException e) {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          String errorMessage = e.message ?? 'Unknown error';
          String errorCode = e.code;
          debugPrint(
              '>>>>>>>Otp failed - Code: $errorCode, Message: $errorMessage<<<<<<<<<<<<<<');

          // Handle specific iOS errors
          if (errorCode == 'too-many-requests') {
            Helper().showToast(
                'Too many attempts. Please try again later.');
          } else if (errorCode == 'missing-app-credential') {
            Helper().showToast(
                'App configuration error. Please contact support.');
          } else if (errorCode == 'missing-client-identifier') {
            Helper().showToast(
                'Firebase configuration error. Please try again.');
          } else if (errorCode == 'invalid-phone-number') {
            Helper().showToast('Invalid phone number format');
          } else {
            Helper().showToast('OTP verification failed: $errorMessage');
          }
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          debugPrint('Code auto retrieval timeout. VerificationId: $verificationId');
          _verificationId = verificationId;
          if (mounted) {
            setState(() {});
          }
        },
        codeSent: (String verificationId, int? resendToken) async {
          if (mounted) {
            setState(() {
              isLoading = false;
            });
          }
          _verificationId = verificationId;
          debugPrint(
              '>>>>>>>>_verificationId>>>>>>$_verificationId<<<<<<<<<<<<<<');

          if (mounted) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => VerifyScreen(
                  phoneNo: phoneCn.text.toString(),
                  verificationId: _verificationId,
                  selectedCountry: _selectedCountry,
                ),
              ),
            );
          }
        },
        timeout: const Duration(seconds: 60),
      );
    } catch (error) {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
      debugPrint('Error in phone authentication: $error');
      Helper().showToast('Error: $error');
    }
  }
}

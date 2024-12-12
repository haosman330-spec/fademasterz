import 'package:fademasterz/Screen/enter_your_no.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app_color.dart';
class CustomLoginDialog extends StatefulWidget {
  const CustomLoginDialog({super.key});

  @override
  State<CustomLoginDialog> createState() => _CustomLoginDialogState();
}

class _CustomLoginDialogState extends State<CustomLoginDialog> {
   SharedPreferences? sharedPreferences;
  @override
  Widget build(BuildContext context) {
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
            const Icon(Icons.login,size: 70,color: AppColor.yellow,),
            // SvgPicture.asset(AppIcon.logout),
            const SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
              ),
              child: Text(
                  textAlign: TextAlign.center,
                  'Login Required',
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
                      sharedPreferences=await SharedPreferences.getInstance();
                      sharedPreferences?.setBool("profileSetUp", false);
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const EnterYourNo(),), (route) => false,);
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
                      AppStrings.login,
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
  }
}

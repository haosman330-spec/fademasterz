import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Utils/app_assets.dart';
import '../Utils/app_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  final Shader textGradient = const LinearGradient(
    //  begin: Alignment.topRight,
    colors: [Colors.green, Colors.yellow],
  ).createShader(
    const Rect.fromLTWH(
      0.0,
      0.0,
      250.0,
      60.0,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.notification,
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
            Navigator.of(context).pop();
            // onCallback();
            setState(() {});
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Text(
                AppStrings.clearAll,
                style: AppFonts.yellowFont,
              ),
            ),
            // Text(
            //   'Text Gradient',
            //   style: TextStyle(
            //     fontSize: 20,
            //     foreground: Paint()
            //       ..shader = ui.Gradient.linear(
            //         const Offset(0, 73),
            //         const Offset(80, 0),
            //         [
            //           Colors.yellow,
            //           Colors.red,
            //         ],
            //       ),
            //   ),
            // ),
            // const SizedBox(
            //   height: 30,
            // ),
            //
            // Text(
            //   'Hello Word',
            //   style: TextStyle(
            //     fontSize: 20,
            //     foreground: Paint()
            //       ..shader = ui.Gradient.linear(
            //         const Offset(0, 60),
            //         const Offset(150, 0),
            //         [
            //           Colors.yellow,
            //           Colors.green,
            //         ],
            //       ),
            //   ),
            // ),
            // Text(
            //   'Greetings, planet!',
            //   style: TextStyle(
            //       fontSize: 40,
            //       foreground: Paint()
            //         ..shader = ui.Gradient.linear(
            //           const Offset(0, 20),
            //           const Offset(150, 20),
            //           <Color>[
            //             Colors.red,
            //             Colors.yellow,
            //           ],
            //         )),
            // )
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 7,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Divider(
                        color: AppColor.white.withOpacity(
                          .5,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            'Lorem ipsum',
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '1 hr',
                            style: AppFonts.regular.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet consecrate. Magna nun et nil Lauris riviera enum.'
                        ' Turps fuse argue diam gestates ridiculous incident wget frames vestibule. Ege hac justo null Lauris nun.',
                        style: AppFonts.normalText.copyWith(
                          fontSize: 11,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

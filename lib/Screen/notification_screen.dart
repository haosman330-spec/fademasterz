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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Align(
              alignment: Alignment.topRight,
              child: Text(
                AppStrings.clearAll,
                style: AppFonts.yellowFont,
              ),
            ),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: 10,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Divider(
                        color: AppColor.white.withOpacity(.5),
                      ),
                      Row(
                        children: [
                          Text(
                            'Lorem ipsum',
                            style: AppFonts.regular.copyWith(fontSize: 16),
                          ),
                          const Spacer(),
                          Text(
                            '1 hr',
                            style: AppFonts.regular.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                      Text(
                        'Lorem ipsum dolor sit amet consectetur. Magna nunc et nisl mauris viverra enim.'
                        ' Turpis fusce augue diam egestas ridiculus tincidunt eget fames vestibulum. Eget hac justo nulla mauris nunc.',
                        style: AppFonts.normalText.copyWith(fontSize: 11),
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

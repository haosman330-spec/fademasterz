import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Screen/chat_list.dart';
import '../Screen/tab1_home_screen.dart';
import '../Screen/tab2_my_booking_screen.dart';
import '../Screen/tab4_profile_screen.dart';
import '../Utils/app_assets.dart';
import '../Utils/app_string.dart';

class DashBoardScreen extends StatefulWidget {
  final int selectIndex;

  const DashBoardScreen({
    super.key,
    required this.selectIndex,
  });

  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  int selectIndex = 0;
  List<Widget> pages = [];

  @override
  void initState() {
    // TODO: implement initState

    pages = [
      const HomeScreen(),
      const MyBookingScreen(),
      // const ChatScreen(),
      const ChatListScreen(),
      ProfileScreen(
        onTap: (value) {
          onBottomTap(value);
        },
      ),
    ];
    selectIndex = widget.selectIndex;
    setState(() {});
    super.initState();
  }

  void onBottomTap(int value) {
    setState(() {
      selectIndex = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: pages[selectIndex],
      bottomNavigationBar: BottomAppBar(
        padding: const EdgeInsets.symmetric(vertical: 8),
        color: AppColor.black,
        height: 70,
        child: Row(
          // mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: InkWell(
                highlightColor: Colors.transparent,
                onTap: () {
                  setState(
                    () {
                      selectIndex = 0;
                    },
                  );
                },
                child: Visibility(
                  visible: selectIndex == 0,
                  replacement: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcon.homeIcon1,
                          width: 21,
                          height: 22,
                          color: AppColor.lightGray,
                        ),
                        const SizedBox(height: 8),
                        Text(AppStrings.home,
                            style: AppFonts.unselectBottomNavigationFont),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        //'assets/icon/homeIcon.svg',
                        AppIcon.homeIcon,
                        width: 21,
                        height: 22,
                        color: AppColor.yellow,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        AppStrings.home,
                        style: AppFonts.selectBottomNavigationFont,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(
                    () {
                      selectIndex = 1;
                    },
                  );
                },
                child: Visibility(
                  visible: selectIndex == 1,
                  replacement: Container(
                    alignment: Alignment.center,
                    child: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcon.bookingIcon,
                          width: 21,
                          height: 22,
                          color: AppColor.lightGray,
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Text(
                          AppStrings.bookings,
                          style: AppFonts.unselectBottomNavigationFont,
                        ),
                      ],
                    ),
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcon.bookingIcon1,
                        width: 21,
                        height: 21,
                        //  color: AppColor.yellow,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        AppStrings.bookings,
                        style: AppFonts.selectBottomNavigationFont,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(
                    () {
                      selectIndex = 2;
                    },
                  );
                },
                child: Visibility(
                  visible: selectIndex == 2,
                  replacement: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcon.chatIcon,
                        width: 21,
                        height: 22,
                        color: AppColor.lightGray,
                      ),
                      const SizedBox(height: 8),
                      Text(AppStrings.chat,
                          style: AppFonts.unselectBottomNavigationFont),
                    ],
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcon.chatIcon1,
                        width: 21,
                        height: 22,
                      ),
                      const SizedBox(height: 8),
                      Text(AppStrings.chat,
                          style: AppFonts.selectBottomNavigationFont)
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: InkWell(
                onTap: () {
                  setState(
                    () {
                      selectIndex = 3;
                    },
                  );
                },
                child: Visibility(
                  visible: selectIndex == 3,
                  replacement: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcon.parsonIcon,
                        width: 21,
                        height: 22,
                        color: AppColor.lightGray,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(AppStrings.profile,
                          style: AppFonts.unselectBottomNavigationFont)
                    ],
                  ),
                  child: Column(
                    children: [
                      SvgPicture.asset(
                        AppIcon.profileIcon1,
                        width: 21,
                        height: 22,
                        color: AppColor.yellow,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(AppStrings.profile,
                          style: AppFonts.selectBottomNavigationFont)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

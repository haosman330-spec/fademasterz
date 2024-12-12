import 'dart:async';

import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../Utils/app_assets.dart';
import '../../Utils/app_string.dart';
import '../../Utils/custom_login_Dialog.dart';
import '../ChatScreen/chat_service.dart';
import '../tab1_home_screen.dart';
import '../tab2_my_booking_screen.dart';
import '../tab3_chat_list.dart';
import '../tab4_profile_screen.dart';

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
  InternetStatus? _connectionStatus;
  late StreamSubscription<InternetStatus> listener;
  int? userId;
  SharedPreferences? sharedPreferences;

  localData() async {
    sharedPreferences = await SharedPreferences.getInstance();

    userId = sharedPreferences?.getInt("senderId") ?? 0;
  }

  @override
  void initState() {
    localData();
    ChatService.getSelfInfo();
    // TODO: implement initState

    listener =
        InternetConnection().onStatusChange.listen((InternetStatus status) {
      debugPrint('>>>>InternetStatus status>>>>>>>>>>$status<<<<<<<<<<<<<<');

      if (status == InternetStatus.disconnected) {
        debugPrint('>>>>InSide<<<<<<<<<<<<<<');
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (ctx) {
            return PopScope(
              canPop: false,
              child: AlertDialog(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                content: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.network_check,
                      color: AppColor.yellow,
                      size: 150,
                    ),
                    Text(
                      'No Internet Please check your internet connection',
                      style: AppFonts.blackFont,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        );
        //   Utility.showNoGetNetworkDialog(context);
      } else if (status == InternetStatus.connected) {
        if (_connectionStatus == InternetStatus.disconnected) {
          Navigator.pop(context);
        }
      }
      switch (status) {
        case InternetStatus.connected:
          _connectionStatus = status;
          debugPrint('>>>>>>>>>>>>>>$status<<<<<<<<<<<<<<');
          // The internet is now connected
          break;
        case InternetStatus.disconnected:
          _connectionStatus = status;
          debugPrint('>>>>>>>>>>>>>>$status<<<<<<<<<<<<<<');

          // The internet is now disconnected
          break;
      }
    });
    pages = [
      const HomeScreen(),
      const MyBookingScreen(),
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
      selectIndex = value;
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    listener.cancel();
  }

  onTabTap(int value){
    debugPrint('<<<<value<<<<<<<${value}>>>>>>>>>>>>>');
    debugPrint('<<<<userId<<<<<<<${userId}>>>>>>>>>>>>>');
    debugPrint('<<<<senderId<<<<<<<${sharedPreferences?.getInt('senderId')}>>>>>>>>>>>>>');

    if(userId == 0 && (value == 1 || value == 2)){
      if (userId == 0) {
        showDialog(context: context, builder: (_) => const CustomLoginDialog());
      }
    }else{
      selectIndex = value;
    }

    /*
    if (value == 1 || value == 2) {
      if (userId == 0) {
        showDialog(context: context, builder: (_) => const CustomLoginDialog());
      } else {
        selectIndex = value;
      }
    } else {
      selectIndex = value;
    }

     */
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (selectIndex != 0) {
          setState(() {
            selectIndex = 0;
          });
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: AppColor.bg,
        body: pages[selectIndex],
        bottomNavigationBar: BottomAppBar(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
          ),
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
                    onTabTap(0);
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
                            colorFilter: const ColorFilter.mode(
                              AppColor.lightGray,
                              BlendMode.srcIn,
                            ),
                            // color: AppColor.lightGray,
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            AppStrings.home,
                            style: AppFonts.unselectBottomNavigationFont,
                          ),
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
                          colorFilter: const ColorFilter.mode(
                            AppColor.yellow,
                            BlendMode.srcIn,
                          ),
                          // color: AppColor.yellow,
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
                    onTabTap(1);
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
                    onTabTap(2);
                  },
                  child: Visibility(
                    visible: selectIndex == 2,
                    replacement: Column(
                      children: [
                        SvgPicture.asset(
                          AppIcon.chatIcon,
                          width: 21,
                          height: 22,
                          colorFilter: const ColorFilter.mode(
                            AppColor.lightGray,
                            BlendMode.srcIn,
                          ),
                          // color: AppColor.lightGray,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          AppStrings.chat,
                          style: AppFonts.unselectBottomNavigationFont,
                        ),
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
                        Text(
                          AppStrings.chat,
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
                    onTabTap(3);
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
                        Text(
                          AppStrings.profile,
                          style: AppFonts.unselectBottomNavigationFont,
                        )
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
                        Text(
                          AppStrings.profile,
                          style: AppFonts.selectBottomNavigationFont,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

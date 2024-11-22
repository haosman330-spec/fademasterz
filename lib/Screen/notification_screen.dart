import 'dart:convert';

import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Notification/notification_model.dart';
import '../Utils/app_assets.dart';
import '../Utils/app_fonts.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  NotificationResponseModal? notificationResponseModal;
  ScrollController scrollController = ScrollController();
  int currentPage = 1;
  int totalPage = 1;
  bool showLoader = false;
  bool isLoading = false;
  void setLoader(bool value) {
    showLoader = value;
    setState(() {});
  }

  List<ListElement> listNotification = [];
  @override
  void initState() {
    super.initState();
    pagination();
    notificationList(context: context, currentPage: 1);
  }

  pagination() {
    scrollController.addListener(() {
      debugPrint('Pagination started>>>');
      if (!isLoading &&
          (scrollController.position.maxScrollExtent ==
              scrollController.position.pixels) &&
          (currentPage < totalPage)) {
        isLoading = true;
        currentPage++;
        notificationList(context: context, currentPage: currentPage);

        setState(() {});
      }
    });
  }

  Future<void> notificationList({
    required BuildContext context,
    required int currentPage,
  }) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (currentPage <= 1) {
      setLoader(true);
    }
    var request = {};
    request['page'] = currentPage;
    var response = await http.post(
        Uri.parse(
          ApiService.notificationList,
        ),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });

    if (currentPage <= 1) {
      setLoader(false);
    }

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );

    if (jsonResponse['status'] == true) {
      notificationResponseModal =
          NotificationResponseModal.fromJson(jsonResponse);
      totalPage = notificationResponseModal?.data?.totalPage ?? 1;

      if (currentPage == 1) {
        listNotification.clear();
        listNotification.addAll(notificationResponseModal?.data?.list ?? []);
      } else {
        listNotification.addAll(notificationResponseModal?.data?.list ?? []);
      }
      setState(() {});
    }
  }

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
            // const Align(
            //   alignment: Alignment.topRight,
            //   child: Text(
            //     AppStrings.clearAll,
            //     style: AppFonts.yellowFont,
            //   ),
            // ),
            Expanded(
              child: Visibility(
                visible: !showLoader,
                replacement: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.yellow,
                  ),
                ),
                child: Visibility(
                  visible: notificationResponseModal?.data?.list?.isNotEmpty ??
                      false,
                  replacement: const Center(
                    child: Text(
                      'No Found Notification',
                      style: AppFonts.normalText,
                    ),
                  ),
                  child: ListView.builder(
                    controller: scrollController,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shrinkWrap: true,
                    itemCount: listNotification.length,
                    physics: AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      var notification = listNotification[index];

                      return InkWell(
                        // onTap: () {
                        //   // notificationResponseModal?.data?.list?.clear();
                        //   debugPrint(
                        //       '>>>>>>>>>>>>>>${notification.type}<<<<<<<<<<<<<<');
                        //   notification.type == 'cancelled'
                        //       ? Navigator.push(
                        //           context,
                        //           MaterialPageRoute(
                        //             builder: (context) =>
                        //                 CancelledBookingDetail(
                        //               cancelBookingId: notification.bookingId,
                        //             ),
                        //           ),
                        //         )
                        //       : '';
                        //  },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Divider(
                              color: AppColor.white.withOpacity(
                                .5,
                              ),
                              height: 25,
                            ),
                            Row(
                              children: [
                                Text(
                                  notification.title ?? '',
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 16,
                                  ),
                                ),
                                const Spacer(),
                                Text(
                                  DateFormat('dd-MM-yyyy' //hh:mm a',
                                          )
                                      .format(notification.createdAt ??
                                          DateTime.now()),
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              ('${notification.description}' ?? ''),
                              style: AppFonts.yellowFont.copyWith(
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
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

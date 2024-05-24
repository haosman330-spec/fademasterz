import 'dart:convert';

import 'package:fademasterz/Modal/my_booking_modal.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Booking/complete_booking_details.dart';
import '../Utils/app_assets.dart';

class MyBookingScreen extends StatefulWidget {
  const MyBookingScreen({
    super.key,
  });

  @override
  State<MyBookingScreen> createState() => _MyBookingScreenState();
}

class _MyBookingScreenState extends State<MyBookingScreen> {
  bool isVisible = true;
  int? bookingId;
  bool showLoader = false;

  void setLoader(bool value) {
    showLoader = value;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getBookingListApi(context);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.myBooking,
          style: AppFonts.appText,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      getBookingListApi(context);
                      isVisible = true;
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4,
                          ),
                          border: isVisible == true
                              ? null
                              : Border.all(
                                  color: AppColor.gray.withOpacity(
                                    .61,
                                  ),
                                ),
                          color: isVisible == true
                              ? AppColor.yellow
                              : AppColor.black),
                      child: Text(
                        AppStrings.upcoming,
                        style: isVisible == true
                            ? AppFonts.regular.copyWith(
                                fontSize: 15,
                                color: Color(0xff272727),
                              )
                            : AppFonts.regular.copyWith(fontSize: 15),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      isVisible = false;
                      getBookingListApi(context);

                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 38,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            4,
                          ),
                          border: isVisible == false
                              ? null
                              : Border.all(
                                  color: AppColor.gray.withOpacity(
                                    .61,
                                  ),
                                ),
                          color: isVisible == false
                              ? AppColor.yellow
                              : AppColor.black),
                      child: Text(
                        AppStrings.completed,
                        style: isVisible == false
                            ? AppFonts.regular.copyWith(
                                fontSize: 15,
                                color: const Color(0xff272727),
                              )
                            : AppFonts.regular.copyWith(
                                fontSize: 15,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: Visibility(
                visible: !showLoader,
                replacement: const Center(
                  child: CircularProgressIndicator(
                    color: AppColor.yellow,
                  ),
                ),
                child: Visibility(
                  visible: isVisible == true,
                  replacement: Visibility(
                    visible: (myBookingResponse?.data?.completed?.isNotEmpty ??
                        false),
                    replacement: const Center(
                      child: Text(
                        'No Completed Booking',
                        style: AppFonts.normalText,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount:
                          (myBookingResponse?.data?.completed?.length ?? 0),
                      itemBuilder: (BuildContext context, int index) {
                        var myCompleteBooking =
                            myBookingResponse?.data?.completed?[index];

                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColor.black,
                            borderRadius: BorderRadius.circular(
                              11,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      '#${myCompleteBooking?.bookingId ?? ''}',
                                      style: AppFonts.yellowFont.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppIcon.timerIcon),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text((myCompleteBooking?.startTime ?? ''),
                                        style: AppFonts.yellowFont),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    SvgPicture.asset(AppIcon.calenderIcon),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy').format(
                                        (myCompleteBooking?.date ??
                                            DateTime.now()),
                                      ),
                                      style: AppFonts.yellowFont,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: AppColor.gray.withOpacity(.49),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 77,
                                      width: 76,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          11,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        ApiService.imageUrl +
                                            (myCompleteBooking?.shopImage ??
                                                ''),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            (myCompleteBooking?.shopName ?? ''),
                                            style: AppFonts.regular
                                                .copyWith(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppIcon.locationIcon,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  (myCompleteBooking
                                                          ?.shopAddress ??
                                                      ''),
                                                  style: AppFonts.regular
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '£  ${myCompleteBooking?.total ?? ''}',
                                            style: AppFonts.yellowFont,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () async {
                                  final SharedPreferences shared =
                                      await SharedPreferences.getInstance();
                                  bookingId = myBookingResponse
                                      ?.data?.completed?[index].id;
                                  shared.setInt('cbookingId', bookingId!);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompleteBookingDetail(
                                              bookingId: bookingId),
                                    ),
                                  ).then((value) {
                                    getBookingListApi(context);
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 28,
                                    alignment: Alignment.bottomCenter,
                                    decoration: const BoxDecoration(
                                      color: AppColor.yellow,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      AppStrings.viewDetails,
                                      style: AppFonts.blackFont.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.black1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                    ),
                  ),
                  child: Visibility(
                    visible: (myBookingResponse?.data?.upcoming?.isNotEmpty ??
                        false),
                    replacement: const Center(
                      child: Text(
                        'No UpComing Booking',
                        style: AppFonts.normalText,
                      ),
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount:
                          (myBookingResponse?.data?.upcoming?.length ?? 0),
                      itemBuilder: (BuildContext context, int index) {
                        var myUpcomingBooking =
                            myBookingResponse?.data?.upcoming?[index];

                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: AppColor.black,
                            borderRadius: BorderRadius.circular(
                              11,
                            ),
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                child: Row(
                                  children: [
                                    Text(
                                      '#${myUpcomingBooking?.bookingId ?? ''}',
                                      style: AppFonts.yellowFont.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    const Spacer(),
                                    SvgPicture.asset(AppIcon.timerIcon),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text((myUpcomingBooking?.startTime ?? ''),
                                        style: AppFonts.yellowFont),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    SvgPicture.asset(AppIcon.calenderIcon),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      DateFormat('dd MMM yyyy').format(
                                        (myUpcomingBooking?.date ??
                                            DateTime.now()),
                                      ),
                                      style: AppFonts.yellowFont,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Divider(
                                  color: AppColor.gray.withOpacity(.49),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                child: Row(
                                  children: [
                                    Container(
                                      height: 77,
                                      width: 76,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          11,
                                        ),
                                      ),
                                      clipBehavior: Clip.antiAlias,
                                      child: Image.network(
                                        ApiService.imageUrl +
                                            (myUpcomingBooking?.shopImage ??
                                                ''),
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            (myUpcomingBooking?.shopName ?? ''),
                                            style: AppFonts.regular
                                                .copyWith(fontSize: 16),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppIcon.locationIcon,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  (myUpcomingBooking
                                                          ?.shopAddress ??
                                                      ''),
                                                  style: AppFonts.regular
                                                      .copyWith(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            '£  ${myUpcomingBooking?.total ?? ''}',
                                            style: AppFonts.yellowFont,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 8,
                              ),
                              InkWell(
                                onTap: () async {
                                  SharedPreferences sharedPreferences =
                                      await SharedPreferences.getInstance();
                                  bookingId = myBookingResponse
                                      ?.data?.upcoming?[index].id;
                                  sharedPreferences.setInt(
                                      'ubookingId', bookingId!);
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CompleteBookingDetail(
                                              bookingId: bookingId),
                                    ),
                                  ).then((value) {
                                    getBookingListApi(context);
                                  });
                                },
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Container(
                                    height: 28,
                                    alignment: Alignment.bottomCenter,
                                    decoration: const BoxDecoration(
                                      color: AppColor.yellow,
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(10),
                                        bottomRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Text(
                                      AppStrings.viewDetails,
                                      style: AppFonts.blackFont.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: AppColor.black1),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) =>
                          const SizedBox(
                        height: 10,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  MyBookingResponse? myBookingResponse;

  Future<void> getBookingListApi(BuildContext context) async {
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // if (context.mounted) {
    //   Utility.progressLoadingDialog(context, true);
    // }

    var request = {};
    var response = await http.post(
        Uri.parse(
          ApiService.myBooking,
        ),
        body: jsonEncode(request),
        headers: {
          "content-type": "application/json",
          'Accept': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });
    setLoader(false);

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );

    // if (context.mounted) {
    //   Utility.progressLoadingDialog(
    //     context,
    //     false,
    //   );
    // }
    // Helper().showToast(jsonResponse['message']);
    if (jsonResponse['status'] == true) {
      myBookingResponse = MyBookingResponse.fromJson(jsonResponse);
      setState(() {});
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}

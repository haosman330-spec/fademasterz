import 'dart:convert';

import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiService/api_service.dart';
import '../../Modal/booking_detail_modal.dart';
import '../../Utils/app_assets.dart';
import '../../Utils/app_string.dart';

class CancelledBookingDetail extends StatefulWidget {
  final int? cancelBookingId;
  const CancelledBookingDetail({
    super.key,
    this.cancelBookingId,
  });

  @override
  State<CancelledBookingDetail> createState() => _CancelledBookingDetailState();
}

class _CancelledBookingDetailState extends State<CancelledBookingDetail> {
  BookingDetailResponse? bookingDetailResponse;
  bool showLoader = false;

  willPopScop() {
    Navigator.of(context).pop();
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const DashBoardScreen(
    //         selectIndex: 1,
    //       ),
    //     ),
    //     (route) => false);
  }

  void setLoader(bool value) {
    showLoader = value;
    setState(() {});
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      bookingDetailApi(
        context,
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        leading: IconButton(
          icon: SvgPicture.asset(
            AppIcon.backIcon,
            height: 12,
            width: 15,
          ),
          onPressed: () {
            willPopScop();
          },
        ),
        title: const Text(
          AppStrings.cancelledBookings,
          style: AppFonts.appText,
        ),
      ),
      body: Visibility(
        visible: !showLoader,
        replacement: const Center(
          child: CircularProgressIndicator(
            color: AppColor.yellow,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
              vertical: 8,
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        height: 76,
                        width: 77,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            11,
                          ),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Visibility(
                          visible: (bookingDetailResponse
                                  ?.data?.shopImage?.isNotEmpty ??
                              false),
                          child: Image.network(
                            ApiService.imageUrl +
                                (bookingDetailResponse?.data?.shopImage ?? ''),
                            // (bookingDetailResponse.data?.shopImage ?? ''),
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              bookingDetailResponse?.data?.shopName ?? ' ',
                              style: AppFonts.regular.copyWith(fontSize: 16),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  AppIcon.timerIcon,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  (bookingDetailResponse?.data?.startTime ??
                                      ''),
                                  style: AppFonts.regular.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                                SvgPicture.asset(
                                  AppIcon.calenderIcon,
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  DateFormat('dd MMM yyyy').format(
                                    bookingDetailResponse?.data?.date ??
                                        DateTime.now(),
                                  ),
                                  style: AppFonts.regular.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '£ ${(bookingDetailResponse?.data?.total ?? '')}',
                              style: AppFonts.yellowFont.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        AppStrings.salonAddress,
                        style: AppFonts.yellowFont,
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        (bookingDetailResponse?.data?.shopAddress ?? ''),
                        style: AppFonts.regular.copyWith(
                            fontSize: 16, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.bookingDate,
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            AppStrings.bookingTime,
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            AppStrings.specialist,
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              DateFormat('dd MMM yyyy').format(
                                bookingDetailResponse?.data?.date ??
                                    DateTime.now(),
                              ),
                              style: AppFonts.regular.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Text(
                              '${bookingDetailResponse?.data?.startTime ?? ' '}',
                              style: AppFonts.regular.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(
                              height: 9,
                            ),
                            Text(
                              (bookingDetailResponse?.data?.specialistName ??
                                  ''),
                              style: AppFonts.regular.copyWith(
                                  fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount:
                        bookingDetailResponse?.data?.services?.length ?? 0,
                    itemBuilder: (context, index) {
                      // var service =
                      //     bookingDetailResponse?.data?.services?[index];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (index == 0)
                            const Text(
                              AppStrings.services,
                              style: AppFonts.yellowFont,
                            ),
                          Row(
                            children: [
                              Text(
                                (bookingDetailResponse
                                        ?.data?.services?[index].name ??
                                    ' '),
                                style: AppFonts.regular.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              Text(
                                '£ ${(bookingDetailResponse?.data?.services?[index].price ?? ' ')}',
                                style: AppFonts.regular.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColor.black,
                    borderRadius: BorderRadius.circular(
                      11,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                AppStrings.subTotal,
                                style: AppFonts.regular.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                AppStrings.tax,
                                style: AppFonts.regular.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                            ],
                          ),
                          const Spacer(),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '£ ${bookingDetailResponse?.data?.subTotal ?? ''}',
                                style: AppFonts.regular.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                '£ ${bookingDetailResponse?.data?.tax ?? ''}',
                                style: AppFonts.regular.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Divider(
                        color: Color(0xff434343),
                        height: 1,
                      ),
                      Row(
                        children: [
                          Text(
                            AppStrings.total,
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const Spacer(),
                          Text(
                            '£ ${bookingDetailResponse?.data?.total ?? ''}',
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> bookingDetailApi(BuildContext context) async {
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // if (context.mounted) {
    //   Utility.progressLoadingDialog(context, true);
    // }
    var request = {};
    request["booking_id"] = widget.cancelBookingId;
    var response = await http.post(
        Uri.parse(
          ApiService.bookingDetail,
        ),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });

    setLoader(false);
    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );
    if (jsonResponse['status']) {
      bookingDetailResponse = BookingDetailResponse.fromJson(jsonResponse);
      if (mounted) setState(() {});
    }
  }
}

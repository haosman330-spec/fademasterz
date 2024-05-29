import 'dart:convert';

import 'package:fademasterz/Modal/cancelled_booking_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiService/api_service.dart';
import '../../Utils/app_assets.dart';
import '../../Utils/app_color.dart';
import '../../Utils/app_fonts.dart';
import '../../Utils/app_string.dart';
import '../../Utils/custom_app_bar.dart';
import 'cancelled_booking_details.dart';

class CancelledBookingScreen extends StatefulWidget {
  const CancelledBookingScreen({super.key});

  @override
  State<CancelledBookingScreen> createState() => _CancelledBookingScreenState();
}

class _CancelledBookingScreenState extends State<CancelledBookingScreen> {
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

  bool showLoader = false;

  void setLoader(bool value) {
    showLoader = value;
    setState(() {});
  }

  int? cancelBookingId;
  @override
  void initState() {
    cancelBookingApi(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: Visibility(
              visible:
                  (cancelledBookingResponse?.data?.cancelBooking?.isNotEmpty ??
                      false),
              replacement: const Center(
                child: Text(
                  'No Cancelled Booking',
                  style: AppFonts.normalText,
                ),
              ),
              child: ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount:
                    (cancelledBookingResponse?.data?.cancelBooking?.length ??
                        0),
                itemBuilder: (BuildContext context, int index) {
                  var cancelledBooking =
                      cancelledBookingResponse?.data?.cancelBooking?[index];

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
                                '#${cancelledBooking?.bookingId ?? ''}',
                                style: AppFonts.yellowFont.copyWith(
                                    fontSize: 16, fontWeight: FontWeight.w500),
                              ),
                              const Spacer(),
                              SvgPicture.asset(AppIcon.timerIcon),
                              const SizedBox(
                                width: 5,
                              ),
                              Text((cancelledBooking?.startTime ?? ''),
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
                                  (cancelledBooking?.date ?? DateTime.now()),
                                ),
                                style: AppFonts.yellowFont,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
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
                                      (cancelledBooking?.shopImage ?? ''),
                                  // (cancelledBookingResponse?.data
                                  //         ?.cancelBooking?[index].shopImage
                                  //         .toString() ??
                                  //     ''),
                                  fit: BoxFit.fill,
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
                                      (cancelledBookingResponse?.data
                                              ?.cancelBooking?[index].shopName
                                              .toString() ??
                                          ''),
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
                                            overflow: TextOverflow.ellipsis,
                                            (cancelledBookingResponse
                                                    ?.data
                                                    ?.cancelBooking?[index]
                                                    .shopAddress
                                                    .toString() ??
                                                ''),
                                            style: AppFonts.regular.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                        )
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      '£  ${cancelledBooking?.total ?? ''}',
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
                            cancelBookingId = cancelledBookingResponse
                                ?.data?.cancelBooking?[index].id;

                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CancelledBookingDetail(
                                    cancelBookingId: cancelBookingId),
                              ),
                            );
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
    );
  }

  CancelledBookingResponse? cancelledBookingResponse;
  Future<void> cancelBookingApi(BuildContext context) async {
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // if (context.mounted) {
    //   Utility.progressLoadingDialog(context, true);
    // }

    var request = {};
    var response = await http.post(
        Uri.parse(
          ApiService.cancelBookingList,
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

    // Helper().showToast(jsonResponse['message']);
    if (jsonResponse['status']) {
      cancelledBookingResponse =
          CancelledBookingResponse.fromJson(jsonResponse);

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

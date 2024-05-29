import 'dart:async';
import 'dart:convert';

import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:fademasterz/Utils/custom_tex_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../ApiService/api_service.dart';
import '../../Modal/booking_detail_modal.dart';
import '../../Utils/app_assets.dart';
import '../../Utils/app_string.dart';
import '../../Utils/custom_app_button.dart';
import '../../Utils/helper.dart';
import '../Dashboard/dashboard.dart';
import '../chat_screen_inbox.dart';
import '../choose_availability_barber.dart';

class CompleteBookingDetail extends StatefulWidget {
  final int? bookingId;

  const CompleteBookingDetail({super.key, this.bookingId});

  @override
  State<CompleteBookingDetail> createState() => _CompleteBookingDetailState();
}

class _CompleteBookingDetailState extends State<CompleteBookingDetail> {
  TextEditingController reviewCn = TextEditingController();
  String? rating1 = '';
  bool showLoader = false;
  var bookingId;
  String? time;
  String? note;
  String? image;
  String? date;
  String? specialistId;
  BookingDetailResponse? bookingDetailResponse;
  void setLoader(bool value) {
    showLoader = value;
    setState(() {});
  }

  @override
  void initState() {
    debugPrint('>>>>>>>>>>>>>>${widget.bookingId}<<<<<<<<<<<<<<');
    SchedulerBinding.instance.addPostFrameCallback((_) {
      bookingDetailApi(
        context,
      );
    });
    super.initState();
  }

  willPopScop() {
    bookingDetailResponse?.data?.bookingStatus == "Completed"
        ? Navigator.pop(context)
        : '';
    (bookingDetailResponse?.data?.bookingStatus == "Pending" ||
            bookingDetailResponse?.data?.bookingStatus == "Cancelled")
        ? Navigator.pop(context)
        : '';
    // Navigator.pushAndRemoveUntil(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) => const DashBoardScreen(
    //         selectIndex: 1,
    //       ),
    //     ),
    //     (route) => false);
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
          AppStrings.bookingSummary,
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
                              (bookingDetailResponse?.data?.shopName ?? ''),
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
                      Column(
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
                            (bookingDetailResponse?.data?.startTime ?? ''),
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            (bookingDetailResponse?.data?.specialistName ?? ''),
                            style: AppFonts.regular.copyWith(
                                fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ],
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
                const SizedBox(
                  height: 10,
                ),
                (bookingDetailResponse?.data?.rating != null)
                    ? Container(
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 10),
                        decoration: BoxDecoration(
                          color: AppColor.black,
                          borderRadius: BorderRadius.circular(
                            11,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  'Rating/Review ',
                                  style: AppFonts.yellowFont.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const Spacer(),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: AppColor.yellow,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        AppIcon.ratingIcon,
                                      ),
                                      const SizedBox(
                                        width: 6,
                                      ),
                                      Text(
                                        ' ${bookingDetailResponse?.data?.rating?.rating ?? ''}',
                                        style: AppFonts.yellowFont,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  bookingDetailResponse
                                          ?.data?.rating?.comment ??
                                      '',
                                  style: AppFonts.regular.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500),
                                ),
                                const SizedBox(
                                  height: 9,
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Visibility(
        visible: (bookingDetailResponse?.data?.bookingStatus == "Pending" ||
            bookingDetailResponse?.data?.bookingStatus == "Cancelled"),
        replacement: Visibility(
          visible: (bookingDetailResponse?.data?.bookingStatus == "Completed"),
          child: (bookingDetailResponse?.data?.rating == null)
              ? MyAppButton(
                  title: AppStrings.rateNow,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  onPress: () {
                    showDialog(
                      barrierDismissible: false,
                      context: context,
                      builder: (context) {
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
                                horizontal: 15, vertical: 16),
                            child: SingleChildScrollView(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: SizedBox(
                                      height: 21,
                                      width: 21,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.pop(context);
                                        },
                                        child: SvgPicture.asset(
                                            AppIcon.cancelIcon),
                                      ),
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      AppStrings.rating,
                                      style: AppFonts.blackFont.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 9,
                                  ),
                                  SvgPicture.asset(
                                    AppIcon.ratingDialogIcon,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 10),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'You have done using Barber/Salon Service ',
                                      style: AppFonts.blackFont.copyWith(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16),
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      'Please leave your review so others people can know your opinion.',
                                      style: AppFonts.text.copyWith(
                                        color: const Color(0xff5F5F5F)
                                            .withOpacity(.90),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 17,
                                  ),
                                  RatingBar.builder(
                                    initialRating: 0,
                                    minRating: 1,
                                    direction: Axis.horizontal,
                                    allowHalfRating: true,
                                    itemCount: 5,
                                    itemPadding: const EdgeInsets.symmetric(
                                        horizontal: 4.0),
                                    itemBuilder: (context, _) => const Icon(
                                        Icons.star,
                                        color: AppColor.yellow),
                                    onRatingUpdate: (rating) {
                                      rating1 = rating.toString();
                                      setState(() {});
                                      //  print(rating);
                                    },
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        top: 15,
                                        bottom: 15),
                                    child: CustomTextField(
                                      controller: reviewCn,
                                      textInputAction: TextInputAction.done,
                                      radius: 6,
                                      hintText: AppStrings.reviews,
                                      maxLines: 4,
                                      style: AppFonts.blackFont.copyWith(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w500),
                                      borderSide: BorderSide.none,
                                      isFilled: true,
                                      fillColor: const Color(0xffEDEDED),
                                    ),
                                  ),
                                  MyAppButton(
                                    onPress: () async {
                                      await rateNowApi(context).then((value) {
                                        bookingDetailApi(context);
                                      });
                                    },
                                    height: 48,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15),
                                    title: AppStrings.submit,
                                    style: AppFonts.blackFont
                                        .copyWith(fontWeight: FontWeight.w500),
                                    radius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                )
              : const SizedBox.shrink(),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: MyAppButton(
                      onPress: () async {
                        SharedPreferences shared =
                            await SharedPreferences.getInstance();
                        shared.setString(
                            'receiverId',
                            (bookingDetailResponse?.data!.shopId.toString() ??
                                ''));

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatScreenInBox(
                              receiverId: bookingDetailResponse?.data?.shopId
                                  .toString(),
                              receiverImage:
                                  bookingDetailResponse?.data?.shopImage,
                              receiverName:
                                  bookingDetailResponse?.data?.shopName,
                            ),
                          ),
                        );
                      },
                      title: AppStrings.chatNow,
                      style: AppFonts.blackFont.copyWith(
                          color: AppColor.bg, fontWeight: FontWeight.w500),
                      height: 50,
                      radius: 6,
                    ),
                  ),
                  const SizedBox(
                    width: 21,
                  ),
                  Expanded(
                    child: MyAppButton(
                      onPress: () {
                        var currentTime =
                            DateTime.now().subtract(const Duration(hours: 2));
                        var scheduleTime = DateTime.parse('$date $time');
                        debugPrint('>>>>>>>>>>>>>>$currentTime '
                            '+'
                            ' $scheduleTime}<<<<<<<<<<<<<<');
                        // if (bookingDetailResponse?.data?.bookingStatus ==
                        //     "Cancelled") {
                        //   Helper().showToast('Booking already Cancelled');
                        // }
                        //  else {
                        if (currentTime.isBefore(scheduleTime)) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChooseAvailabilityBarber(
                                data: bookingDetailResponse?.data,
                              ),
                            ),
                          );
                        } else {
                          showBottomSheet();
                        }
                        //   }
                        //Navigator.of(context).pop();
                      },
                      radius: 6,
                      height: 50,
                      title: AppStrings.reschedule,
                      style: AppFonts.blackFont.copyWith(
                          color: AppColor.bg, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // if ((bookingDetailResponse?.data?.bookingStatus ==
                  //     "Cancelled")) {
                  //   Helper().showToast('Booking already Cancelled');
                  // }

                  //  else {
                  showModalBottomSheet(
                    isDismissible: false,
                    backgroundColor: Colors.transparent,
                    context: context,
                    builder: (ctx) {
                      return Container(
                        height: 230,
                        decoration: const BoxDecoration(
                          color: AppColor.bg,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(
                              20,
                            ),
                            topRight: Radius.circular(
                              20,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          child: Column(
                            children: [
                              Align(
                                alignment: Alignment.topRight,
                                child: SizedBox(
                                  height: 21,
                                  width: 21,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.pop(ctx);
                                    },
                                    child: const Icon(
                                      Icons.cancel,
                                      color: AppColor.yellow,
                                    ),
                                  ),
                                ),
                              ),
                              const Text(
                                AppStrings.cancelBooking,
                                style: AppFonts.appText,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 35),
                                child: Text(
                                  textAlign: TextAlign.center,
                                  AppStrings.conformCancel,
                                  style: AppFonts.normalText
                                      .copyWith(fontSize: 14),
                                ),
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              const Divider(
                                color: AppColor.dividerColor,
                              ),
                              const SizedBox(
                                height: 14,
                              ),
                              Row(
                                children: [
                                  Expanded(
                                    child: MyAppButton(
                                      onPress: () {
                                        Navigator.pop(ctx);
                                      },
                                      border:
                                          Border.all(color: AppColor.yellow),
                                      title: AppStrings.no,
                                      style: AppFonts.yellowFont.copyWith(
                                          fontWeight: FontWeight.w500),
                                      height: 50,
                                      color: Colors.transparent,
                                      radius: 6,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 21,
                                  ),
                                  Expanded(
                                    child: MyAppButton(
                                      onPress: () {
                                        Navigator.pop(ctx);
                                        /* var currentTime = DateTime.now()
                                            .subtract(const Duration(hours: 2));
                                        var scheduleTime =
                                            DateTime.parse('$date $time');*/
                                        // .isBefore(scheduleTime)) {
                                        cancelBookingApi(context);
                                        /*     }
                                        else {
                                          showBottomSheet();
                                        }
                                        Navigator.popUntil(
                                            context, (route) => false);*/
                                      },
                                      radius: 6,
                                      height: 50,
                                      title: AppStrings.yesCancelBooking,
                                      style: AppFonts.blackFont.copyWith(
                                          color: AppColor.bg,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                  //   }
                },
                child: Text(
                  AppStrings.cancelBooking,
                  style: AppFonts.yellowFont
                      .copyWith(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ],
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

    request["booking_id"] = widget.bookingId;

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
    // Helper().showToast(
    //   jsonResponse['message'],
    // );
    if (jsonResponse['status']) {
      bookingDetailResponse = BookingDetailResponse.fromJson(jsonResponse);
      // var shopId = bookingDetailResponse?.data?.shopId;
      bookingId = bookingDetailResponse?.data?.bookingId;
      time = bookingDetailResponse?.data?.startTime;
      date = bookingDetailResponse?.data?.date?.toString().split(" ").first;

      image = bookingDetailResponse?.data?.desiredLook;
      note = bookingDetailResponse?.data?.note;
      specialistId = bookingDetailResponse?.data?.specialistId.toString();

      setState(() {});
    }
  }

  Future<void> rateNowApi(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // if (context.mounted) {
    //   Utility.progressLoadingDialog(context, true);
    // }
    var request = {};

    request["booking_id"] = widget.bookingId;
    request["rating"] = rating1.toString();
    request["comment"] = reviewCn.text.toString();

    var response = await http.post(
        Uri.parse(
          ApiService.rateNow,
        ),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });

    // if (context.mounted) {
    //   Utility.progressLoadingDialog(context, false);
    // }

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );
    Helper().showToast(
      jsonResponse['message'],
    );
    if (jsonResponse['status'] == true) {
      Navigator.of(context).pop();
      reviewCn.clear();
      setState(() {});
    }
  }

  Future<void> cancelBookingApi(BuildContext context) async {
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var request = {};

    request["booking_id"] = widget.bookingId;

    var response = await http.post(
        Uri.parse(
          ApiService.cancelBooking,
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
    //  Helper().showToast(jsonResponse['message']);
    if (jsonResponse['status']) {
      if (context.mounted) {
        bookingDetailApi(context);
      }
    }
    _showBottomSheet(
      context: context,
      description: jsonResponse["message"],
      isSuccess: jsonResponse['status'],
    );
  }

  Future showBottomSheet() async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      isDismissible: false,
      context: context,
      builder: (context) {
        return PopScope(
          canPop: false,
          child: Container(
            height: 220,
            decoration: const BoxDecoration(
              color: AppColor.bg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(
                  20,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox.shrink(),
                      Text(
                        textAlign: TextAlign.center,
                        AppStrings.alert,
                        style: AppFonts.redFont,
                      ),
                      SizedBox(
                        height: 21,
                        width: 21,
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: AppColor.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  const Text(
                    AppStrings.rescheduleBooking,
                    style: AppFonts.appText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      textAlign: TextAlign.center,
                      'You can only Reschedule before 2 hrs of booking time',
                      style: AppFonts.normalText.copyWith(fontSize: 14),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Divider(
                    color: AppColor.dividerColor,
                  ),
                  MyAppButton(
                    onPress: () {
                      Navigator.of(context).pop();
                    },
                    title: AppStrings.gotIt,
                    style: AppFonts.blackFont.copyWith(
                      color: AppColor.bg,
                      fontWeight: FontWeight.w500,
                    ),
                    radius: 7,
                    height: 50,
                    width: 128,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future _showBottomSheet({
    required BuildContext context,
    required String description,
    required bool isSuccess,
  }) async {
    return await showModalBottomSheet(
      backgroundColor: Colors.transparent,
      context: context,
      builder: (ctx) {
        // debugPrint('>>>isSuccess>>>>>>>>>>>${isSuccess}<<<<<<<<<<<<<<');
        // debugPrint('>>>>>>>description>>>>>>>${description}<<<<<<<<<<<<<<');
        return PopScope(
          canPop: false,
          child: Container(
            height: 230,
            decoration: const BoxDecoration(
              color: AppColor.bg,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  20,
                ),
                topRight: Radius.circular(
                  20,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 21,
                        width: 21,
                      ),
                      Visibility(
                        visible: !isSuccess,
                        child: Text(
                          AppStrings.alert,
                          style: AppFonts.redFont,
                        ),
                      ),
                      SizedBox(
                        height: 21,
                        width: 21,
                        child: InkWell(
                          onTap: () {
                            isSuccess
                                ? Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const DashBoardScreen(selectIndex: 1),
                                    ),
                                    (route) => false)
                                : Navigator.pop(ctx);
                          },
                          child: const Icon(
                            Icons.cancel,
                            color: AppColor.yellow,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                  Text(
                    isSuccess
                        ? AppStrings.cancelledSuccessfully
                        : AppStrings.cancelBooking,
                    style: AppFonts.appText,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 35),
                    child: Text(
                      textAlign: TextAlign.center,
                      description,
                      style: AppFonts.normalText.copyWith(fontSize: 15),
                    ),
                  ),
                  const SizedBox(
                    height: 14,
                  ),
                  const Divider(
                    color: AppColor.dividerColor,
                  ),
                  MyAppButton(
                    onPress: () {
                      isSuccess
                          ? Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const DashBoardScreen(selectIndex: 1),
                              ),
                              (route) => false)
                          : Navigator.of(ctx).pop();
                    },
                    title: AppStrings.gotIt,
                    style: AppFonts.blackFont.copyWith(
                        color: AppColor.bg, fontWeight: FontWeight.w500),
                    radius: 7,
                    height: 50,
                    width: 128,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

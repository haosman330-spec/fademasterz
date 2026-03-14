import 'dart:convert';
import 'dart:developer';

import 'package:fademasterz/Screen/web_view_page.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:fademasterz/Utils/helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Model/book_now_model.dart';
import '../Model/booking_summary_argument_model.dart';
import '../Model/booking_summary_model.dart';
import '../Utils/app_assets.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/utility.dart';
import 'Dashboard/dashboard.dart';

class BookingSummaryScreen extends StatefulWidget {
  final BookingSummaryArgument data;

  const BookingSummaryScreen({
    super.key,
    required this.data,
  });

  @override
  State<BookingSummaryScreen> createState() => BookingSummaryScreenState();
}

class BookingSummaryScreenState extends State<BookingSummaryScreen> {
  BookNowResponse? bookNowResponse;
  BookingSummaryResponse? bookingSummaryResponse;
  bool showLoader = false;
  bool isCashPayment = false;

  void setLoader(bool value) {
    showLoader = value;
    setState(() {});
  }



  @override
  void initState() {
    bookingSummaryApi(context);
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
            Navigator.pop(context);
            // onCallback();
          },
        ),
        title: const Text(
          AppStrings.bookingSummary,
          style: AppFonts.appText,
        ),
      ),
      body: Visibility(
        visible: !showLoader,
        replacement: Center(
          child: Container(
            alignment: Alignment.center,
            child: const CircularProgressIndicator(
              color: AppColor.yellow,
            ),
          ),
        ),
        child: Visibility(
          visible: bookingSummaryResponse != null,
          replacement: Center(
            child: Text(
             'Service not found.',
              style: AppFonts.regular.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          child: SingleChildScrollView(  padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 20,
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
                        height: 77,
                        width: 76,
                        clipBehavior: Clip.antiAlias,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.all(
                            Radius.circular(
                              11,
                            ),
                          ),
                        ),
                        child: Visibility(
                          visible: (bookingSummaryResponse
                                  ?.data?.image?.isNotEmpty ??
                              false),
                          child: Image.network(
                            ApiService.imageUrl +
                                (bookingSummaryResponse?.data?.image ?? ''),
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
                              (bookingSummaryResponse?.data?.name ?? ' '),
                              style: AppFonts.regular.copyWith(
                                fontSize: 16,
                              ),
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
                                  (bookingSummaryResponse
                                          ?.data?.bookingTime ??
                                      'N/A'),
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
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
                                Expanded(
                                  child: Text(
                                    // bookingSummaryResponse?.data?.bookingDate
                                    //         .toString() ??
                                    //     'N/A',
                                    DateFormat('dd MMM yyyy').format(
                                        bookingSummaryResponse
                                                ?.data?.bookingDate ??
                                            DateTime.now()),
                                    //  DateTime.now().toString(),
                                    style: AppFonts.regular.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              '£${bookingSummaryResponse?.data?.subTotal ?? ' '}',
                              style: AppFonts.yellowFont.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
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
                        (bookingSummaryResponse?.data?.address ?? ' '),
                        style: AppFonts.regular.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 10),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            AppStrings.bookingTime,
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            AppStrings.specialist,
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            // (bookingSummaryResponse?.data?.bookingDate
                            //         .toString() ??
                            //     'N/A'),

                            DateFormat('dd MMM yyyy').format(
                              bookingSummaryResponse?.data?.bookingDate ??
                                  DateTime.now(),
                            ),
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            (bookingSummaryResponse?.data?.bookingTime ??
                                ' '),
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 9,
                          ),
                          Text(
                            (bookingSummaryResponse?.data?.specialist?.name ??
                                'N/A'),
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: bookingSummaryResponse?.data?.services?.length,
                    itemBuilder: (context, index) {
                      var service =
                          bookingSummaryResponse?.data?.services?[index];
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
                                (service?.name ?? ' '),
                                style: AppFonts.regular.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '£ ${(service?.price ?? ' ')}',
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
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                AppStrings.tax,
                                style: AppFonts.regular.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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
                                ' £${bookingSummaryResponse?.data?.subTotal ?? ' '}',
                                style: AppFonts.regular.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 9,
                              ),
                              Text(
                                ' £${(bookingSummaryResponse?.data?.tax ?? ' ')}',
                                style: AppFonts.regular.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                ),
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
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '£ ${(bookingSummaryResponse?.data?.total ?? ' ')}',
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        AppStrings.paymentMethod,
                        style: AppFonts.yellowFont,
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isCashPayment = false;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    isCashPayment
                                        ? Icons.radio_button_off
                                        : Icons.radio_button_checked,
                                    color: AppColor.yellow,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.payWithCard,
                                      style: AppFonts.regular.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  isCashPayment = true;
                                });
                              },
                              child: Row(
                                children: [
                                  Icon(
                                    isCashPayment
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: AppColor.yellow,
                                    size: 20,
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      AppStrings.payWithCash,
                                      style: AppFonts.regular.copyWith(
                                        fontSize: 14,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
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
      bottomNavigationBar: MyAppButton(
        title: AppStrings.proceedTOPay,
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        onPress: () {
          // (widget.data.bookingStatus != "Pending")

          bookNowApi(context);
          //  : rescheduleBookingApi(context);
        },
      ),
    );
  }

  Future<void> bookingSummaryApi(BuildContext context) async {
    // Utility.progressLoadingDialog(context, true);
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // try {
    var request = {};
    debugPrint('<<<<<<<< widget.data.price.toString()<<<${ widget.data.price.toString()}>>>>>>>>>>>>>');
    request["shop_id"] =
        widget.data.shopId ?? sharedPreferences.getInt('shop_id');
    request["specialist_id"] = widget.data.specialistId;
    request["time"] = widget.data.time.toString();
    request["price"] = widget.data.price.toString();
    request["service_ids"] = widget.data.serviceId.toString();
    request["date"] = widget.data.date.toString();

    var response = await http.post(
        Uri.parse(
          ApiService.bookingSummary,
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
    setLoader(false);

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );
    log('>>>>>>Api>>>>>>>>${ApiService.bookingSummary}<<<<<<<<<<<<<<');
    log('>>>>>>request>>>>>>>>${request.toString()}<<<<<<<<<<<<<<');
    log('>>>>>>jsonResponse>>>>>>>>${jsonResponse.toString()}<<<<<<<<<<<<<<');
    if (jsonResponse['status'] == true) {
      bookingSummaryResponse = BookingSummaryResponse.fromJson(jsonResponse);

      setState(() {});
    }
    else {

      Helper().showToast(jsonResponse['message']);
      Navigator.of(context).pop(true);

    }
    // } catch (e) {
    //   if (context.mounted) {
    //     Utility.progressLoadingDialog(context, false);
    //   }
    //   Helper().showToast(e.toString());
    // }
  }

  Future<void> bookNowApi(BuildContext context) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }

    var headers = {
      'Accept': 'application/json',
      'Authorization': 'Bearer ${sharedPreferences.getString("access_Token")}'
    };
    var request = http.MultipartRequest(
      'POST',
      Uri.parse(
        ApiService.bookNow,
      ),
    );

    request.fields.addAll({
      'shop_id':
          widget.data.shopId ?? sharedPreferences.getInt('shop_id').toString(),
      'date': widget.data.date.toString(),
      'time': widget.data.time.toString(),
      'sub_total': (bookingSummaryResponse?.data?.subTotal.toString() ?? ''),
      'tax': (bookingSummaryResponse?.data?.tax.toString() ?? ''),
      'total': (bookingSummaryResponse?.data?.total.toString() ?? ''),
      'specialist_id': widget.data.specialistId.toString(),
      'service_ids': widget.data.serviceId.toString(),
      'note': widget.data.noteText.toString(),
      'payment_method': isCashPayment ? 'cash' : 'card',
    });
    if (widget.data.image?.isNotEmpty ?? false) {
      request.files.add(
        await http.MultipartFile.fromPath(
            'desired_look', (widget.data.image.toString())),
      );
    }
    request.headers.addAll(headers);

    http.StreamedResponse response = await request.send();

    var result = await response.stream.bytesToString();

    var jsonResponse = jsonDecode(result);

    if (context.mounted) {
      Utility.progressLoadingDialog(
        context,
        false,
      );
    }
    log('>>>>>>Api>>>>>>>>${ApiService.bookNow}<<<<<<<<<<<<<<');
    log('>>>>>>request>>>>>>>>${request.fields}<<<<<<<<<<<<<<');
    log('>>>>>>jsonResponse>>>>>>>>${jsonResponse.toString()}<<<<<<<<<<<<<<');
    if (jsonResponse["status"]==true) {
      bookNowResponse = BookNowResponse.fromJson(jsonResponse);
      final String? url = bookNowResponse?.data?.url?.toString();

      if (isCashPayment || (url == null || url.isEmpty)) {
        await _showBookingSuccessDialog(context);
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WebViewPage(url: url.toString()),
          ),
        ).then((value) async {
          if (value != null && value) {
            await _showBookingSuccessDialog(context);
          }
        });
      }
      setState(() {});
    } else{
      Helper().showToast(jsonResponse['message']);
     // Navigator.of(context).pop(true);
    }
  }

  Future<void> _showBookingSuccessDialog(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (ctx) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Dialog(
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
                  SvgPicture.asset(
                    AppIcon.paymentIcon,
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppStrings.paymentSuccessful,
                      style: AppFonts.blackFont.copyWith(
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                    child: Text(
                      textAlign: TextAlign.center,
                      AppStrings.successfulDone,
                      style: AppFonts.blackFont.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 16,
                  ),
                  MyAppButton(
                    onPress: () async {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashBoardScreen(
                            selectIndex: 1,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    height: 48,
                    title: AppStrings.viewBookingSummary,
                    style: AppFonts.blackFont.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    radius: 39,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  MyAppButton(
                    onPress: () {
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DashBoardScreen(
                            selectIndex: 0,
                          ),
                        ),
                        (route) => false,
                      );
                    },
                    height: 48,
                    title: AppStrings.backToHome,
                    style: AppFonts.blackFont.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                    radius: 39,
                    color: const Color(0xffFFFBF0),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

}

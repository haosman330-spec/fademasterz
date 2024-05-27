import 'dart:async';
import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fademasterz/Modal/home_page_modal.dart';
import 'package:fademasterz/Screen/notification_screen.dart';
import 'package:fademasterz/Screen/shop_detail.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Modal/booking_summary_argument_modal.dart';
import '../Utils/bottam_sheet.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/utility.dart';

class HomeScreen extends StatefulWidget {
  // final String? startYr;
  // final String? availability;
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchCn = TextEditingController();
  bool isDataLoading = false;
  String? startYr;
  String? endYr;
  String? availability;
  List<String>? serviceId;
  void setLoader(bool value) {
    isDataLoading = value;
    setState(() {});
  }

  FilterData? filterData;

  Future<void> _showDialog(BuildContext context) async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always ||
        permission == LocationPermission.whileInUse) {
      homeDetailApi(context: context);

      // return;
    } else {
      await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (ctx) {
          return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                17,
              ),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 18,
            ),
            child: WillPopScope(
              onWillPop: () async => false,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SvgPicture.asset(AppIcon.locationDialogIcon),
                    const SizedBox(
                      height: 12,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 20),
                      child: Text(
                        textAlign: TextAlign.center,
                        AppStrings.enableLocation,
                        style: AppFonts.blackFont.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        textAlign: TextAlign.center,
                        AppStrings.locationNearest,
                        style: AppFonts.blackFont.copyWith(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    MyAppButton(
                      onPress: () async {
                        // await Geolocator.openLocationSettings();
                        //   await getLocation();
                        await getLetLongPosition();

                        Navigator.of(ctx).pop();
                      },
                      height: 48,
                      title: AppStrings.enableLocation,
                      style: AppFonts.blackFont
                          .copyWith(fontWeight: FontWeight.w500),
                      radius: 39,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    /*        MyAppButton(
                      onPress: () {
                        Navigator.of(ctx).pop();
                      },
                      height: 48,
                      title: AppStrings.cancel,
                      style: AppFonts.blackFont
                          .copyWith(fontWeight: FontWeight.w500),
                      radius: 39,
                      color: const Color(0xffFFFBF0),
                    ),*/
                  ],
                ),
              ),
            ),
          );
        },
      );
      homeDetailApi(context: context);
    }
  }

  double? latitude;
  double? longitude;
  late LocationPermission permission;

  // Future<void> getLocation() async {
  //   try {
  //     Position position = await Geolocator.getCurrentPosition(
  //         desiredAccuracy: LocationAccuracy.high);
  //     latitude = position.latitude;
  //     longitude = position.longitude;
  //
  //     debugPrint('>>>>>>>>>>>>>>${latitude}<<<<<<<<<<<<<<');
  //     debugPrint('>>>>>>>>>>>>>>${longitude}<<<<<<<<<<<<<<');
  //     setState(() {});
  //   } catch (e) {
  //     Helper().showToast(e.toString());
  //   }
  // }

  Future<void> getLetLongPosition() async {
    bool serviceEnabled;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      Geolocator.openAppSettings();
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    longitude = position.longitude;
    latitude = position.latitude;
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      await _showDialog(context);
    });
    // final listener =
    //     InternetConnection().onStatusChange.listen((InternetStatus status) {
    //   switch (status) {
    //     case InternetStatus.connected:
    //       debugPrint(
    //           '>>>>>>>>>>>>>>${'Data connection is available.'}<<<<<<<<<<<<<<');
    //       // The internet is now connected
    //       break;
    //     case InternetStatus.disconnected:
    //       debugPrint(
    //           '>>>>>>>>>>>>>>${'You are disconnected from the internet.'}<<<<<<<<<<<<<<');
    //       // The internet is now disconnected
    //       break;
    //   }
    // });

    // var listener = InternetConnectionChecker().onStatusChange.listen((status) {
    //   switch (status) {
    //     case InternetConnectionStatus.connected:
    //       // homeDetail(context: context);
    //       debugPrint(
    //           '>>>>>>>>>>>>>>${'Data connection is available.'}<<<<<<<<<<<<<<');
    //
    //       break;
    //     case InternetConnectionStatus.disconnected:
    //       Utility.showNoGetNetworkDialog(context);
    //       debugPrint(
    //           '>>>>>>>>>>>>>>${'You are disconnected from the internet.'}<<<<<<<<<<<<<<');
    //       break;
    //   }
    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: Visibility(
                      visible:
                          (homePageModal.data?.userDetail?.image?.isNotEmpty ??
                              false),
                      child: CachedNetworkImage(
                        imageUrl: ApiService.imageUrl +
                            (homePageModal.data?.userDetail?.image ?? ''),
                        height: 36,
                        width: 36,
                        fit: BoxFit.cover,
                        placeholder: (
                          context,
                          url,
                        ) =>
                            const CircularProgressIndicator(
                          color: AppColor.yellow,
                        ),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),

                      // Image.network(
                      //   ApiService.imageUrl +
                      //       (homePageModal.data?.userDetail?.image ?? ''),
                      //   height: 36,
                      //   width: 36,
                      //   fit: BoxFit.cover,
                      // ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Welcome, ${homePageModal.data?.userDetail?.name ?? ''}',
                          style: AppFonts.text
                              .copyWith(fontSize: 16, color: AppColor.yellow),
                        ),
                        const Text(AppStrings.helpToday,
                            style: AppFonts.normalText),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NotificationScreen(),
                        ),
                      );
                    },
                    child: SvgPicture.asset(
                      AppIcon.notificationIcon,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        controller: searchCn,
                        style: AppFonts.textFieldFont,
                        onTapOutside: (event) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        },
                        onChanged: (value) {
                          // if (value.isNotEmpty) {
                          homeDetailApi(context: context, searchValue: value);
                          setState(() {});
                          // }
                        },
                        textAlignVertical: TextAlignVertical.bottom,
                        textInputAction: TextInputAction.done,
                        decoration: InputDecoration(
                          hintText: AppStrings.search,
                          hintStyle: AppFonts.textFieldFont,
                          prefixIcon: Align(
                            heightFactor: 0.5,
                            widthFactor: 0.5,
                            child: SvgPicture.asset(
                              AppIcon.searchIcon,
                              height: 17,
                              width: 17,
                            ),
                          ),
                          filled: true,
                          fillColor: AppColor.black,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  GestureDetector(
                    onTap: () async {
                      showModalBottomSheet(
                        isDismissible: false,
                        backgroundColor: Colors.transparent,
                        context: context,
                        builder: (context) {
                          return AppBottomSheet(
                            filterData: filterData,
                          );
                        },
                      ).then((value) async {
                        if (value != null) {
                          filterData = value;
                          startYr = filterData?.startYear;
                          availability = filterData?.availability;
                          serviceId = filterData?.serviceId;

                          startYr = value?.startYear;
                          endYr = value?.endYear;
                          availability = value?.availability;
                          serviceId = value?.serviceId;
                          debugPrint(
                              '>>>>>>>>>>>>>>${serviceId}<<<<<<<<<<<<<<');
                          await homeDetailApi(context: context);
                        }
                      });
                      // return const AppBottomSheet();
                    },

                    //_modalBottomSheetMenu();

                    child: Container(
                      // height: 46,
                      // width: 48,
                      padding: const EdgeInsets.all(12),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(6),
                        color: AppColor.black,
                      ),
                      child: SvgPicture.asset(AppIcon.filterIcon),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 15,
              ),
              Text(
                '${(searchCn.text.trim().isNotEmpty) ? (searchHomePageModal?.data?.totalShops ?? '') : (homePageModal.data?.totalShops ?? '')} Shops available',
                style: AppFonts.text.copyWith(
                  fontSize: 16,
                  color: AppColor.yellow,
                ),
              ),
              Visibility(
                visible: (searchCn.text.trim().isNotEmpty),
                replacement: Visibility(
                  visible: (homePageModal.data?.shops?.isNotEmpty ?? false),
                  replacement: Center(
                    child: Visibility(
                      visible: !isDataLoading,
                      child: const Text(
                        'No Shop Available',
                        style: AppFonts.normalText,
                      ),
                    ),
                  ),
                  child: Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: (homePageModal.data?.shops?.length ?? 0),
                      padding: const EdgeInsets.only(top: 15, bottom: 15),
                      itemBuilder: (context, index) {
                        var item = homePageModal.data?.shops?[index];

                        return InkWell(
                          onTap: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setInt(
                              'shop_id',
                              item!.id!.toInt(),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopDetail(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColor.black,
                              borderRadius: BorderRadius.circular(
                                15,
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
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: Visibility(
                                    visible: (item?.image?.isNotEmpty ?? false),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiService.imageUrl +
                                          (item?.image ?? ''),
                                      fit: BoxFit.fill,
                                      placeholder: (
                                        context,
                                        url,
                                      ) =>
                                          const CircularProgressIndicator(
                                        color: AppColor.yellow,
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),

                                    // Image.network(
                                    //   ApiService.imageUrl + (item?.image ?? ''),
                                    //   fit: BoxFit.fill,
                                    // ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (item?.name ?? ''),
                                        style: AppFonts.regular
                                            .copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcon.ratingIcon,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            (item?.avgRating) == '0'
                                                ? 'No Rating Yet'
                                                : (item?.avgRating ?? ''),
                                            style: AppFonts.regular.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppIcon.locationIcon,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${item?.distance ?? ' '} km',
                                                style: AppFonts.regular
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
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
                                              (item?.address ?? ''),
                                              style: AppFonts.regular.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
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
                child: Visibility(
                  visible:
                      (searchHomePageModal?.data?.shops?.isNotEmpty ?? false),
                  replacement: Center(
                    child: Visibility(
                      visible: !isDataLoading,
                      child: const Text(
                        'No Shop Available',
                        style: AppFonts.normalText,
                      ),
                    ),
                  ),
                  child: Expanded(
                    child: ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount:
                          (searchHomePageModal?.data?.shops?.length ?? 1),
                      padding: const EdgeInsets.only(top: 15),
                      itemBuilder: (context, index) {
                        var item = searchHomePageModal?.data?.shops?[index];

                        return InkWell(
                          onTap: () async {
                            SharedPreferences sharedPreferences =
                                await SharedPreferences.getInstance();
                            sharedPreferences.setInt(
                              'shop_id',
                              item!.id!.toInt(),
                            );

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const ShopDetail(),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: AppColor.black,
                              borderRadius: BorderRadius.circular(
                                15,
                              ),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  height: 75,
                                  width: 76,
                                  clipBehavior: Clip.antiAlias,
                                  decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(
                                        10,
                                      ),
                                    ),
                                  ),
                                  child: Visibility(
                                    visible: (item?.image?.isNotEmpty ?? false),
                                    child: Image.network(
                                      ApiService.imageUrl + (item?.image ?? ''),
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        (item?.name ?? ''),
                                        style: AppFonts.regular
                                            .copyWith(fontSize: 16),
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      Row(
                                        children: [
                                          SvgPicture.asset(
                                            AppIcon.ratingIcon,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            (item?.avgRating) == '0'
                                                ? 'No Rating Yet'
                                                : (item?.avgRating ?? ''),
                                            style: AppFonts.regular.copyWith(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          const SizedBox(
                                            width: 20,
                                          ),
                                          Row(
                                            children: [
                                              SvgPicture.asset(
                                                AppIcon.locationIcon,
                                              ),
                                              const SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                '${item?.distance ?? ' '} km',
                                                style: AppFonts.regular
                                                    .copyWith(
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.w500),
                                              ),
                                            ],
                                          )
                                        ],
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
                                              (item?.address ?? ''),
                                              style: AppFonts.regular.copyWith(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
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
            ],
          ),
        ),
      ),
    );
  }

  HomePageModal homePageModal = HomePageModal();
  HomePageModal? searchHomePageModal;

  Future<void> homeDetailApi({
    required BuildContext context,
    String? searchValue,
  }) async {
    // try {
    if (searchValue?.isEmpty ?? true) {
      Utility.progressLoadingDialog(context, true);
    }
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (latitude == null || longitude == null) {
      await getLetLongPosition();
    }

    var request = {};

    request["latitude"] = latitude.toString();
    request['longitude'] = longitude.toString();
    request["search"] = searchValue ?? '';
    request["availibility"] =
        (availability?.isNotEmpty ?? false) ? availability : 'All';
    request["category_ids"] = serviceId?.join(',') ?? '';
    request["experience_level"] =
        ((startYr?.isNotEmpty ?? false) && (endYr?.isNotEmpty ?? false))
            ? "${startYr}" "-" "${endYr}"
            : ' ';
    // (startYr?.isNotEmpty ?? false) ?
    var response = await http.post(
        Uri.parse(
          ApiService.home,
        ),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });

    if (context.mounted) {
      if (searchValue?.isEmpty ?? true) {
        Utility.progressLoadingDialog(context, false);
      }
    }
    setLoader(false);

    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );

    sharedPreferences.setBool("profileSetUp", true);
    if (jsonResponse['status'] == true) {
      if (searchValue?.isNotEmpty ?? false) {
        searchHomePageModal = HomePageModal.fromJson(jsonResponse);
        setState(() {});
      } else {
        homePageModal = HomePageModal.fromJson(jsonResponse);

        setState(() {});
      }

      sharedPreferences.setString(
          'image', homePageModal.data?.userDetail?.image ?? '');
      sharedPreferences.setString(
          'name', homePageModal.data?.userDetail?.name ?? '');

      sharedPreferences.setBool("profileSetUp", true);
      setState(() {});
    }
    // }
    // catch (e) {
    //   Helper().showToast(e.toString());
    // }
  }

  @override
  void setState(VoidCallback fn) {
    super.setState(fn);
  }
}

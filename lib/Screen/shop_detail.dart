import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:fademasterz/Modal/shop_detail_modal.dart';
import 'package:fademasterz/Screen/reviews_screen.dart';
import 'package:fademasterz/Screen/select_your_service_screen.dart';
import 'package:fademasterz/Screen/services_screen.dart';
import 'package:fademasterz/Screen/specialist_screen.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:maps_launcher/maps_launcher.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_fonts.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_button.dart';
import '../Utils/utility.dart';
import 'gallery_screen.dart';

class ShopDetail extends StatefulWidget {
  const ShopDetail({super.key});

  @override
  State<ShopDetail> createState() => _ShopDetailState();
}

class _ShopDetailState extends State<ShopDetail> {
  int selectIndex = 0;
  int selectIndex1 = 0;
  bool isListVisible = false;
  bool isDataLoad = false;
  List<Widget> categories = [];
  void setLoader(bool value) {
    isDataLoad = value;
    setState(() {});
  }

  @override
  void initState() {
    shopDetail(context).then(
      (value) => categories = [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ReadMoreText(
            (shopDetailModal.data?.about ?? ''),
            trimMode: TrimMode.Line,
            trimLines: 3,
            trimLength: 200,
            style: AppFonts.normalText.copyWith(fontSize: 14),
            trimCollapsedText: 'Read more....',
            isExpandable: true,
            moreStyle: AppFonts.yellowFont,
            lessStyle: AppFonts.yellowFont,
            trimExpandedText: ' show less',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              if (shopDetailModal.data?.services?.isNotEmpty ?? false)
                Row(
                  children: [
                    Text(
                      AppStrings.services,
                      style: AppFonts.regular.copyWith(fontSize: 16),
                    ),
                    const Spacer(),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ServicesScreen(
                              service: (shopDetailModal.data?.services),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        AppStrings.seeAll,
                        style: AppFonts.yellowFont,
                      ),
                    )
                  ],
                ),
              const Divider(
                color: AppColor.dividerColor,
                height: 25,
              ),
              Visibility(
                visible: (shopDetailModal.data?.services?.isNotEmpty ?? false),
                replacement: Center(
                  child: Text(
                    'No Services Found',
                    style: AppFonts.appText.copyWith(fontSize: 14),
                  ),
                ),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: (shopDetailModal.data?.services?.length ?? 4) < 4
                      ? (shopDetailModal.data?.services?.length ?? 4)
                      : 4,
                  itemBuilder: (context, index) {
                    var services = shopDetailModal.data?.services?[index];
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColor.black,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(AppIcon.rightIcon),
                          const SizedBox(
                            width: 12,
                          ),
                          Text(
                            (services?.name ?? ''),
                            style: AppFonts.appText.copyWith(fontSize: 14),
                          )
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (context, index) => const SizedBox(
                    height: 10,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              if (shopDetailModal.data?.gallery?.isNotEmpty ?? false)
                Row(
                  children: [
                    Text(
                      AppStrings.gallery,
                      style: AppFonts.regular.copyWith(fontSize: 16),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GalleryScreen(
                              gallery: (shopDetailModal.data?.gallery),
                            ),
                          ),
                        );
                      },
                      child: const Text(
                        AppStrings.seeAll,
                        style: AppFonts.yellowFont,
                      ),
                    )
                  ],
                ),
              const Divider(
                color: AppColor.dividerColor,
                height: 25,
              ),
              Visibility(
                visible: (shopDetailModal.data?.gallery?.isNotEmpty ?? false),
                replacement: Center(
                  child: Text(
                    'No Gallery Image',
                    style: AppFonts.appText.copyWith(fontSize: 14),
                  ),
                ),
                child: GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.zero,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  shrinkWrap: true,
                  itemCount: (shopDetailModal.data?.gallery?.length ?? 9) < 9
                      ? (shopDetailModal.data?.gallery?.length ?? 9)
                      : 9,
                  itemBuilder: (BuildContext context, int index) {
                    var gallery = shopDetailModal.data?.gallery?[index];
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            barrierDismissible: false,
                            context: context,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Stack(children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: Image.network(
                                      ApiService.imageUrl +
                                          (gallery?.image ?? ''),
                                      //     images[index],

                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
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
                                  )
                                ]),
                              );
                            },
                          );
                        },
                        child: CachedNetworkImage(
                          imageUrl:
                              ApiService.imageUrl + (gallery?.image ?? ''),
                          width: 103,
                          height: 88,
                          fit: BoxFit.fill,
                          progressIndicatorBuilder:
                              (context, url, downloadProgress) => Center(
                            child: SizedBox(
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                  value: downloadProgress.progress),
                            ),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                        ),
                        // Image.network(
                        //   ApiService.imageUrl + (gallery?.image ?? ''),
                        //   //     images[index],
                        //   width: 103,
                        //   height: 88,
                        //   fit: BoxFit.fill,
                        // ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: Visibility(
            visible: (shopDetailModal.data?.review?.isNotEmpty ?? false),
            replacement: Center(
              child: Text(
                'No Review Found',
                style: AppFonts.appText.copyWith(fontSize: 14),
              ),
            ),
            child: ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              itemCount: (shopDetailModal.data?.review!.length ?? 0) > 3
                  ? 3
                  : (shopDetailModal.data?.review!.length ?? 0),
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                var review = shopDetailModal.data?.review?[index];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (index == 0)
                      Row(
                        children: [
                          SvgPicture.asset(
                            AppIcon.ratingIcon,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            (shopDetailModal.data?.review?[index].rating ?? ''),

                            //AppStrings.gallery,
                            style: AppFonts.regular.copyWith(fontSize: 16),
                          ),
                          const Spacer(),
                          InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ReviewsScreen(
                                    review: (shopDetailModal.data!.review),
                                  ),
                                ),
                              );
                            },
                            child: const Text(
                              AppStrings.seeAll,
                              style: AppFonts.yellowFont,
                            ),
                          )
                        ],
                      ),
                    const Divider(
                      color: AppColor.dividerColor,
                      height: 25,
                    ),
                    Row(
                      children: [
                        Text(
                          (review?.userName ?? ''),
                          style: AppFonts.regular.copyWith(fontSize: 15),
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
                                (review?.rating ?? ''),
                                style: AppFonts.yellowFont,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      (review?.comment ?? ''),
                      style: AppFonts.normalText.copyWith(fontSize: 14),
                    ),
                    Text(
                      DateFormat('dd-MMM-yyyy').format(
                        DateTime.parse(review?.createdAt.toString() ?? ''),
                      ),
                      style: AppFonts.normalText.copyWith(
                          fontSize: 13, color: const Color(0xff989898)),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
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
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            //height: 250,
            child: Stack(
              children: [
                Visibility(
                  visible: (shopDetailModal.data?.image?.isNotEmpty ?? false),
                  child: Image.network(
                    ApiService.imageUrl + (shopDetailModal.data?.image ?? ''),
                    fit: BoxFit.fill,
                    height: 250,
                    width: MediaQuery.of(context).size.width,
                  ),
                ),
                Positioned(
                  left: 15,
                  top: MediaQuery.of(context).viewPadding.top,
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: AppColor.yellow,
                        shape: BoxShape.circle,
                      ),
                      child: SvgPicture.asset(
                        AppIcon.backIcon,
                        color: AppColor.black,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Visibility(
                visible: (shopDetailModal.data?.name?.isNotEmpty ?? false),
                replacement: Center(
                    child: Visibility(
                  visible: !isDataLoad,
                  child: const Text(
                    'No Data Load',
                    style: AppFonts.normalText,
                  ),
                )),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 10,
                      ),
                      child: Text(
                        shopDetailModal.data?.name ?? '',
                        style: AppFonts.regular.copyWith(
                          fontSize: 20,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcon.locationIcon,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Text(
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              shopDetailModal.data?.address ?? '',
                              style: AppFonts.regular.copyWith(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 5),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            AppIcon.ratingIcon,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Text(
                            (shopDetailModal.data?.avgRating) == '0'
                                ? 'No Rating Yet'
                                : (shopDetailModal.data?.avgRating ?? ''),
                            style: AppFonts.regular.copyWith(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 15, right: 15, top: 15),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              launchUrl(
                                Uri.parse(
                                    shopDetailModal.data?.instagramLink ?? ''),
                              );
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(AppIcon.instagramIcon),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  AppStrings.instagram,
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Column(
                            children: [
                              SvgPicture.asset(
                                AppIcon.openNowIcon,
                              ),
                              const SizedBox(
                                height: 6,
                              ),
                              Text(
                                _shopStatus,
                                style: AppFonts.regular.copyWith(
                                  fontSize: 15,
                                ),
                              )
                            ],
                          ),
                          InkWell(
                            onTap: () {
                              MapsLauncher.launchCoordinates(
                                double.parse(
                                  shopDetailModal.data!.lat.toString(),
                                ),
                                double.parse(
                                  shopDetailModal.data!.lng.toString(),
                                ),
                              );
                            },
                            child: Column(
                              children: [
                                SvgPicture.asset(
                                  AppIcon.directionIcon,
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  AppStrings.direction,
                                  style: AppFonts.regular.copyWith(
                                    fontSize: 15,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 15,
                      ),
                      child: Divider(
                        height: 2,
                        color: AppColor.dividerColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                        top: 21,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            AppStrings.ourSpecialists,
                            style: AppFonts.regular.copyWith(
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SpecialistScreen(
                                    specialist:
                                        (shopDetailModal.data!.ourSpecialist),
                                  ),
                                ),
                              );
                              setState(() {});
                            },
                            child: Text(
                              (shopDetailModal
                                          .data?.ourSpecialist?.isNotEmpty ??
                                      false)
                                  ? AppStrings.seeAll
                                  : '',
                              style: AppFonts.yellowFont.copyWith(
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Visibility(
                      visible:
                          (shopDetailModal.data?.ourSpecialist?.isNotEmpty ??
                              false),
                      replacement: Center(
                        child: Text(
                          'No Specialist Found',
                          style: AppFonts.appText.copyWith(
                            fontSize: 14,
                          ),
                        ),
                      ),
                      child: SizedBox(
                        height: 95,
                        child: ListView.separated(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: (shopDetailModal
                                          .data?.ourSpecialist!.length ??
                                      0) >
                                  5
                              ? 5
                              : (shopDetailModal.data?.ourSpecialist!.length ??
                                  0),
                          addSemanticIndexes: true,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 5),
                          itemBuilder: (BuildContext context, int index) {
                            var specialist =
                                shopDetailModal.data?.ourSpecialist?[index];
                            return GestureDetector(
                              onTap: () {
                                selectIndex = index;
                                setState(
                                  () {},
                                );
                              },
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(35),
                                    child: CachedNetworkImage(
                                      imageUrl: ApiService.imageUrl +
                                          (specialist?.image ?? ''),
                                      height: 60,
                                      width: 60,
                                      fit: BoxFit.fill,
                                      progressIndicatorBuilder:
                                          (context, url, downloadProgress) =>
                                              Center(
                                        child: SizedBox(
                                          height: 30,
                                          width: 30,
                                          child: CircularProgressIndicator(
                                            value: downloadProgress.progress,
                                          ),
                                        ),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          const Icon(
                                        Icons.error,
                                      ),
                                    ),

                                    //   Image.network(
                                    //     ApiService.imageUrl +
                                    //         (specialist?.image ?? ''),
                                    //     height: 60,
                                    //     width: 60,
                                    //     fit: BoxFit.fill,
                                    //   ),
                                  ),
                                  Text(
                                    (specialist?.name ?? ''),
                                    style: AppFonts.normalText.copyWith(
                                      fontSize: 14,
                                    ),
                                  )
                                ],
                              ),
                            );
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const SizedBox(
                              width: 20,
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      height: 33,
                      child: ListView.separated(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: shopServicesList.length,
                        addSemanticIndexes: true,
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              selectIndex1 = index;
                              setState(
                                () {},
                              );
                            },
                            child: Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: selectIndex1 == index
                                    ? AppColor.yellow
                                    : Colors.transparent,
                                border: Border.all(color: AppColor.yellow),
                                borderRadius: BorderRadius.circular(19),
                              ),
                              //  margin: const EdgeInsets.all(5),
                              child: Text(shopServicesList[index],
                                  style: selectIndex1 == index
                                      ? AppFonts.text.copyWith(
                                          color: AppColor.black1, fontSize: 14)
                                      : AppFonts.yellowFont),
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const SizedBox(
                            width: 15,
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    if (categories.isNotEmpty) categories[selectIndex1],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: MyAppButton(
        title: AppStrings.bookNow,
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const SelectYourServices(),
            ),
          );
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => const WebViewXPage(),
          //   ),
          // );
        },
      ),
    );
  }

  String _shopStatus = 'Loading...';
  String _updateShopStatus(String openTime, String closeTime) {
    // Get the current time

    DateTime ct = DateTime.now();
    // Format opening and closing times as DateTime objects
    DateTime openDateTime = DateFormat.Hm().parse(openTime);

    DateTime closeDateTime = DateFormat.Hm().parse(closeTime);
    // debugPrint('>>>>>>>>>>>>>>${openDateTime}<<<<<<<<<<<<<<');
    // debugPrint('>>>>>>>>>>>>>>${closeDateTime}<<<<<<<<<<<<<<');
    DateTime currentTime = DateTime(openDateTime.year, openDateTime.month,
        openDateTime.day, ct.hour, ct.minute, ct.second);

    // Compare the current time with the opening and closing times
    if (currentTime.isAfter(openDateTime) &&
        currentTime.isBefore(closeDateTime)) {
      _shopStatus = 'Open Now';
      setState(() {});
    } else {
      setState(() {
        _shopStatus = 'Closed Now ';
      });
    }

    return _shopStatus;
  }

  String? openTime;
  String? closeTime;
  ShopDetailModal shopDetailModal = ShopDetailModal();
  Future<void> shopDetail(BuildContext context) async {
    setLoader(true);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }
    var request = {};

    request["shop_id"] = sharedPreferences.getInt('shop_id');

    var response = await http.post(
        Uri.parse(
          ApiService.shopDetail,
        ),
        body: jsonEncode(request),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer ${sharedPreferences.getString("access_Token")}'
        });

    setLoader(false);
    if (context.mounted) {
      Utility.progressLoadingDialog(context, false);
    }
    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );
    // Helper().showToast(
    //   jsonResponse['message'],
    // );

    if (jsonResponse['status'] == true) {
      shopDetailModal = ShopDetailModal.fromJson(jsonResponse);
      openTime = shopDetailModal.data?.shopStartTime;
      closeTime = shopDetailModal.data?.shopEndTime;
      // var id = shopDetailModal.data?.id;
      debugPrint(
          '>>>>>jsonResponse>>>>>>>>>${jsonResponse['data'].toString()}<<<<<<<<<<<<<<');
      _updateShopStatus(openTime!, closeTime!);
      setState(() {});
    }
  }
}

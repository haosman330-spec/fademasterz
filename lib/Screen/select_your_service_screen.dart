import 'dart:convert';
import 'dart:developer';

import 'package:fademasterz/Model/shop_service_model.dart';
import 'package:fademasterz/Model/shop_work_service_model.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_fonts.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_assets.dart';
import '../Utils/helper.dart';
import '../Utils/utility.dart';
import 'choose_availability_barber.dart';

class SelectYourServices extends StatefulWidget {
  const SelectYourServices({super.key});

  @override
  State<SelectYourServices> createState() => _SelectYourServicesState();
}

class _SelectYourServicesState extends State<SelectYourServices> {
  int selectIndex = 0;
  int? shopWorkServiceId;
  bool isDataLoading = false;
  List<Service1?>? selectedServiceList = [];
  ShopWorkServiceResponse shopWorkServiceModal = ShopWorkServiceResponse();
  ShopServiceResponse shopServiceModal = ShopServiceResponse();

  void setLoader(bool value) {
    isDataLoading = value;
    setState(() {});
  }

  @override
  void initState() {
    shopWorkService(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.selectService,
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

            setState(() {});
          },
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 33,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 15),
              itemCount: (shopWorkServiceModal.data?.workServices?.length ?? 0),
              itemBuilder: (BuildContext context, int index) {
                var shopService =
                    shopWorkServiceModal.data?.workServices?[index];

                return GestureDetector(
                  onTap: () async {
                    shopWorkServiceId = (shopService?.id?.toInt() ?? 0);

                    selectIndex = index;
                    _shopService(context);
                    setState(
                      () {},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectIndex == index
                          ? AppColor.yellow
                          : Colors.transparent,
                      border: Border.all(color: AppColor.yellow),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    //  margin: const EdgeInsets.all(5),
                    child: Text((shopService?.name ?? ''),
                        style: selectIndex == index
                            ? AppFonts.text
                                .copyWith(color: AppColor.black1, fontSize: 14)
                            : AppFonts.yellowFont),
                  ),
                );
              },
              separatorBuilder: (BuildContext context, int index) {
                return const SizedBox(
                  width: 8,
                );
              },
            ),
          ),
          Expanded(
            child: Visibility(
              visible: (shopServiceModal.data?.services?.isNotEmpty ?? false),
              replacement: Center(
                child: Visibility(
                  visible: !isDataLoading,
                  child: Text(
                    'No Service Available',
                    style: AppFonts.appText.copyWith(
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
              child: ListView.separated(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                itemCount: (shopServiceModal.data?.services?.length ?? 0),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  var shopService = shopServiceModal.data?.services?[index];

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: AppColor.black),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              (shopService?.name ?? ''),
                              style: AppFonts.appText.copyWith(fontSize: 14),
                            ),
                            Text(
                              (shopService?.duration ?? ''),
                              style: AppFonts.normalText,
                            ),
                            const SizedBox(
                              height: 4,
                            ),
                            Text(
                              '£ ${shopService?.price //.toStringAsFixed(0),
                              }',
                              style: AppFonts.appText.copyWith(
                                  fontWeight: FontWeight.w600, fontSize: 14),
                            ),
                          ],
                        ),
                        InkWell(
                          onTap: () {


                            onItemAddRemove(shopService);

                            setState(() {});

                          },
                          child: !(shopService?.selected ?? false)
                              ? SvgPicture.asset(
                                  AppIcon.addIcon,
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.fill,
                                )
                              : SvgPicture.asset(
                                  AppIcon.removeIcon,
                                  height: 25,
                                  width: 25,
                                  fit: BoxFit.fill,
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
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 16),
        child: ElevatedButton(
          onPressed: () {
            if (selectedServiceList?.isNotEmpty ?? false) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChooseAvailabilityBarber(
                      selectedServiceList: selectedServiceList,
                      price: selectedServiceList?.fold<double>(0.0, (previousValue, element) =>
                      previousValue + double.parse(element?.price ?? '0')).toStringAsFixed(2)),
                ),
              ).then((value) {
                if (value == true) {
                  selectIndex = 0;
                  selectedServiceList?.clear();
                  shopWorkServiceId = shopWorkServiceModal
                          .data?.workServices?[selectIndex].id ??
                      0;
                  shopWorkService(context);
                  setState(() {});
                }
              });
              ;
            } else {
              Helper().showToast(AppStrings.pleaseSelectYourService);
            }
          },
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 16),
            backgroundColor: AppColor.yellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Row(
            children: [
              Text(
                '£ ${selectedServiceList?.fold<double>(0.0, (previousValue, element) =>
                previousValue + double.parse(element?.price ?? '0')).toStringAsFixed(2)}',
                style: AppFonts.blackFont,
              ),
              const Spacer(),
              const Text(
                AppStrings.continueString,
                style: AppFonts.blackFont,
              ),
              const SizedBox(
                width: 7,
              ),
              SvgPicture.asset(AppIcon.forward1Icon)
            ],
          ),
        ),
      ),
    );
  }

  void onItemAddRemove(Service1? data) {
    bool isAlreadySelected = false;
    selectedServiceList?.forEach((element) {
      if (element?.id == data?.id) {
        isAlreadySelected = true;
      }
    });
    if (isAlreadySelected) {
      Helper().showToast('Unselect',backgroundColor: AppColor.black,textColor1: AppColor.white );
      selectedServiceList?.removeWhere((element) => element?.id == data?.id);
    } else {
      Helper().showToast('Selected',backgroundColor: AppColor.black,textColor1: AppColor.white );
      selectedServiceList?.add(data);
    }
    shopServiceModal.data?.services?.forEach((element) {
      if (element.id == data?.id) {
        element.selected = !(element.selected ?? false);
      }
    });
    setState(() {});
  }

  Future<void> shopWorkService(BuildContext context) async {
    setLoader(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }

    var request = {};
    request["shop_id"] = sharedPreferences.getInt('shop_id');
    request['user_id'] =sharedPreferences.getInt("senderId")??0;

    var response = await http.post(
        Uri.parse(
          ApiService.shopWorkServices,
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
    log('>>>>>Api>>>>>>>>>${ApiService.shopWorkServices}<<<<<<<<<<<<<<');
    log('>>>>>request>>>>>>>>>${request}<<<<<<<<<<<<<<');
    log('>>>>>response>>>>>>>>${jsonResponse.toString()}<<<<<<<<<<<<<<');
    if (jsonResponse['status'] == true) {
      shopWorkServiceModal = ShopWorkServiceResponse.fromJson(jsonResponse);
      setState(() {});
      if (shopWorkServiceModal.data?.workServices?.isNotEmpty ?? false) {
        shopWorkServiceId =
            shopWorkServiceModal.data?.workServices?[selectIndex].id ?? 0;
        _shopService(context);
      }
    }
  }

  Future<void> _shopService(BuildContext context) async {
    setLoader(true);

    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    if (context.mounted) {
      Utility.progressLoadingDialog(context, true);
    }

    var request = {};

    request["shop_id"] = sharedPreferences.getInt('shop_id');
    request["work_service_id"] = shopWorkServiceId;

    var response = await http.post(
        Uri.parse(
          ApiService.shopServices,
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

    log('>>>>>Api>>>>>>>>>${ApiService.shopServices}<<<<<<<<<<<<<<');
    log('>>>>>request>>>>>>>>>${request}<<<<<<<<<<<<<<');
    log('>>>>>response>>>>>>>>${jsonResponse.toString()}<<<<<<<<<<<<<<');
    // Helper().showToast(
    //   jsonResponse['message'],
    // );
    if (jsonResponse['status'] == true) {
      shopServiceModal = ShopServiceResponse.fromJson(jsonResponse);

      shopServiceModal.data?.services?.forEach(
        (shopItemElement) {
          selectedServiceList?.forEach(
            (selectedItemElement) {
              if (shopItemElement.id == selectedItemElement?.id) {
                shopItemElement.selected = true;
              }
            },
          );
        },
      );

      setState(() {});
    }
  }
}

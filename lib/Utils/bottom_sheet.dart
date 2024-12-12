import 'dart:convert';

import 'package:fademasterz/Model/get_category_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:http/http.dart' as http;

import '../ApiService/api_service.dart';
import '../Model/booking_summary_argument_model.dart';
import '../Screen/Dashboard/dashboard.dart';
import 'app_color.dart';
import 'app_fonts.dart';
import 'app_list.dart';
import 'app_string.dart';

class AppBottomSheet extends StatefulWidget {
  final FilterData? filterData;

  const AppBottomSheet({
    super.key,
    this.filterData,
  });

  @override
  State<AppBottomSheet> createState() => _AppBottomSheetState();
}

class _AppBottomSheetState extends State<AppBottomSheet> {
  int? selectAvailabilityIndex = 0;
  double? startYr;
  double? endYr;
  bool dataLoad = true;
  List<CategoryDataModel> categoryService = [];

  void onTap(int index) {
    if (index == 0) {
      for (var element in categoryService) {
        element.isSelected = true;
      }
    } else {
      if (categoryService.first.isSelected ?? false) {
        for (var element in categoryService) {
          element.isSelected = false;
        }
      }
      categoryService[index].isSelected =
          !(categoryService[index].isSelected ?? false);

      int count = 0;
      for (var element in categoryService) {
        if (element.isSelected ?? false) {
          count++;
        }
      }
      if (count == 0) {
        categoryService[index].isSelected =
            !(categoryService[index].isSelected ?? false);
      } else if (count == (categoryService.length - 1)) {
        for (var element in categoryService) {
          element.isSelected = true;
        }
      }
    }

    setState(() {});
  }

  void initData() {
    debugPrint('>>>>>>>>filterData>>>>>>${widget.filterData}<<<<<<<<<<<<<<');

    startYr = double.parse(widget.filterData?.startYear ?? '0.0');
    endYr = double.parse(widget.filterData?.endYear ?? '20.0');

    if (widget.filterData?.availability?.isNotEmpty ?? false) {
      selectAvailabilityIndex =
          available.indexOf(widget.filterData?.availability ?? '');
    }

    List<String>? selectedServiceIds = widget.filterData?.serviceId;
    if (selectedServiceIds?.isNotEmpty ?? false) {
      for (var id in selectedServiceIds ?? []) {
        for (var element in categoryService) {
          if (element.id.toString() == id) {
            categoryService.first.isSelected = false;
            element.isSelected = true;
          }
        }
      }
    } else {
      for (var element in categoryService) {
        element.isSelected = true;
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      getCategory(context).then(
        (value) => initData(),
      );
    });

    super.initState();
  }

  GetCategory? getCategoryResponse;
  List<String>? serviceId;

  Future<void> getCategory(BuildContext context) async {
    dataLoad = true;
    var response = await http.post(
        Uri.parse(
          ApiService.getCategories,
        ),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        });

    dataLoad = false;
    Map<String, dynamic> jsonResponse = jsonDecode(
      response.body,
    );

    if (jsonResponse['status'] == true) {
      getCategoryResponse = GetCategory.fromJson(jsonResponse);

      categoryService.add(CategoryDataModel(
        id: 0,
        name: "All",
      ));
      categoryService.addAll(getCategoryResponse?.data ?? []);

      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 430,
      decoration: const BoxDecoration(
        color: AppColor.bg,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Padding(
            padding: const EdgeInsets.only(right: 5, top: 10),
            child: InkWell(onTap: () {
              Navigator.pop(context);
            },
              child: Align(
                alignment: Alignment.topRight,
                child:   IconButton(onPressed: (){  Navigator.pop(context);}, icon: Icon(
                  Icons.cancel,
                  size: 30,
                  color: AppColor.yellow,
                ),),
             /*   SizedBox(
                  height: 21,
                  width: 21,
                  child: const Icon(
                    Icons.cancel,
                    size: 30,
                    color: AppColor.yellow,
                  ),
                ),*/
              ),
            ),
          ),
          Center(
            child: Text(
              AppStrings.filter,
              style: AppFonts.regular.copyWith(
                fontSize: 18,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Divider(
              height: 1,
              color: AppColor.white.withOpacity(.10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10),
            child: Text(
              AppStrings.category,
              style: AppFonts.regular.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 33,
            child: Visibility(
              visible: dataLoad,
              replacement: ListView.separated(
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemCount: categoryService.length,
                padding: const EdgeInsets.only(left: 15, right: 15),
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () => onTap(index),

                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: (categoryService[index].isSelected ?? true)
                            ? AppColor.yellow
                            : Colors.transparent,
                        border: Border.all(color: AppColor.yellow),
                        borderRadius: BorderRadius.circular(19),
                      ),
                      //  margin: const EdgeInsets.all(5),
                      child: Text(
                        categoryService[index].name ?? '',
                        style: (categoryService[index].isSelected ?? true)
                            ? AppFonts.text
                                .copyWith(color: AppColor.black1, fontSize: 14)
                            : AppFonts.yellowFont,
                      ),
                    ),
                  );
                },
                separatorBuilder: (BuildContext context, int index) {
                  return const SizedBox(
                    width: 8,
                  );
                },
              ),
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColor.yellow,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Text(
              AppStrings.availability,
              style: AppFonts.regular.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 33,
            child: ListView.separated(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: available.length,
              addSemanticIndexes: true,
              padding: const EdgeInsets.only(left: 15),
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    selectAvailabilityIndex = index;
                    setState(
                      () {},
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selectAvailabilityIndex == index
                          ? AppColor.yellow
                          : Colors.transparent,
                      border: Border.all(color: AppColor.yellow),
                      borderRadius: BorderRadius.circular(19),
                    ),
                    //  margin: const EdgeInsets.all(5),
                    child: Text(available[index],
                        style: selectAvailabilityIndex == index
                            ? AppFonts.text.copyWith(
                                color: AppColor.black1,
                              )
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
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Text(
              AppStrings.experienceLevel,
              style: AppFonts.regular.copyWith(
                fontSize: 16,
              ),
            ),
          ),
          SliderTheme(
            data: const SliderThemeData(
              thumbColor: AppColor.yellow,
            ),
            child: RangeSlider(
              activeColor: AppColor.yellow,
              inactiveColor: AppColor.black,
              values: RangeValues(startYr ?? 0, endYr ?? 20),
              labels: RangeLabels(
                  startYr?.toString() ?? '0', endYr?.toString() ?? '15'),
              onChanged: (value) {
                setState(() {
                  startYr = value.start;
                  endYr = value.end;
                });
              },
              min: 0.0,
              max: 20.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${startYr?.toStringAsFixed(0) ?? 0} yr',
                  style: AppFonts.yellowFont.copyWith(fontSize: 13),
                ),
                Text(
                  '${endYr?.toStringAsFixed(0) ?? 20} yr',
                  style: AppFonts.yellowFont.copyWith(fontSize: 13),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Divider(
              height: 1,
              color: AppColor.white.withOpacity(.10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15, top: 10, right: 15),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigator.pop(context)
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const DashBoardScreen(selectIndex: 0),
                          ),
                          (route) => false);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: AppColor.yellow),
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: Text(AppStrings.reset,
                        style: AppFonts.yellowFont.copyWith(fontSize: 16)),
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      List<String>? serviceId;
                      if (!(categoryService.first.isSelected ?? false)) {
                        serviceId = [];
                        for (var element in categoryService) {
                          if (element.isSelected ?? false) {
                            serviceId.add(element.id.toString());
                          }
                        }
                      }
                      var data = FilterData(
                        availability: available[selectAvailabilityIndex ?? 0],
                        startYear: startYr?.toStringAsFixed(0),
                        endYear: endYr?.toStringAsFixed(0),
                        serviceId: serviceId,
                      );

                      Navigator.pop(context, data);
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: AppColor.yellow,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          20,
                        ),
                      ),
                    ),
                    child: Text(
                      AppStrings.applyFilter,
                      style: AppFonts.text
                          .copyWith(color: AppColor.black1, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if(mounted) {
      super.setState(fn);
    }
  }
}

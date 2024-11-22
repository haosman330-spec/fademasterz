import 'package:fademasterz/Model/shop_detail_model.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../ApiService/api_service.dart';
import '../Utils/app_assets.dart';
import '../Utils/app_fonts.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_bar.dart';

class GalleryScreen extends StatefulWidget {
  final List<Gallery>? gallery;
  const GalleryScreen({super.key, required this.gallery});

  @override
  State<GalleryScreen> createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.gallery,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: [
              Visibility(
                visible: (widget.gallery?.isNotEmpty ?? false),
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
                  itemCount: widget.gallery?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16)),
                      child: GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              return Dialog(
                                backgroundColor: Colors.transparent,
                                child: Stack(children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width,
                                    height: 200,
                                    child: Image.network(
                                      ApiService.imageUrl +
                                          (widget.gallery?[index].image ?? ''),
                                      //     images[index],

                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
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
                        child: Image.network(
                          ApiService.imageUrl +
                              (widget.gallery?[index].image ?? ''),
                          //     images[index],
                          width: 103,
                          height: 104,
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

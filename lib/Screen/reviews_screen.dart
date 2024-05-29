import 'package:fademasterz/Modal/shop_detail_modal.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

import '../Utils/app_fonts.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_bar.dart';

class ReviewsScreen extends StatefulWidget {
  final List<Review>? review;
  const ReviewsScreen({super.key, this.review});

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.reviews,
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
            // onCallback();
            setState(() {});
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.review?.length,
              itemBuilder: (BuildContext context, int index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          (widget.review?[index].userName ?? ''),
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
                                (widget.review?[index].rating ?? ''),
                                style: AppFonts.yellowFont,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Text(
                      (widget.review?[index].comment ?? ''),
                      style: AppFonts.normalText.copyWith(fontSize: 14),
                    ),
                    Text(
                      DateFormat('dd-MMM-yyyy')
                          .format(DateTime.parse(
                            (widget.review?[index].createdAt.toString() ?? ''),
                          ))
                          .toString(),
                      style: AppFonts.normalText.copyWith(
                          fontSize: 13, color: const Color(0xff989898)),
                    ),
                    const Divider(
                      color: AppColor.dividerColor,
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }
}

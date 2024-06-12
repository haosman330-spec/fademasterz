import 'package:fademasterz/Modal/shop_detail_modal.dart';
import 'package:fademasterz/Utils/app_assets.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:fademasterz/Utils/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../Utils/app_fonts.dart';

class ServicesScreen extends StatefulWidget {
  final List<Service>? service;
  const ServicesScreen({super.key, this.service});

  @override
  State<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends State<ServicesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        title: const Text(
          AppStrings.services,
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
          child: Column(
            children: [
              Visibility(
                visible: (widget.service?.isNotEmpty ?? false),
                replacement: Center(
                  child: Text(
                    AppStrings.noServices,
                    style: AppFonts.appText.copyWith(fontSize: 14),
                  ),
                ),
                child: ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: widget.service!.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {},
                      child: Container(
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
                              (widget.service?[index].name ?? ''),
                              style: AppFonts.appText.copyWith(fontSize: 14),
                            )
                          ],
                        ),
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
      ),
    );
  }
}

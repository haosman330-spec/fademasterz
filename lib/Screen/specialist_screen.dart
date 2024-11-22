import 'package:fademasterz/ApiService/api_service.dart';
import 'package:fademasterz/Utils/app_color.dart';
import 'package:fademasterz/Utils/app_string.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../Model/shop_detail_model.dart';
import '../Utils/app_assets.dart';
import '../Utils/app_fonts.dart';

class SpecialistScreen extends StatefulWidget {
  final List<OurSpecialist>? specialist;
  const SpecialistScreen({
    super.key,
    this.specialist,
  });

  @override
  State<SpecialistScreen> createState() => _SpecialistScreenState();
}

class _SpecialistScreenState extends State<SpecialistScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          AppStrings.specialists,
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Visibility(
          visible: (widget.specialist?.isNotEmpty ?? false),
          replacement: Center(
            child: Text(
              AppStrings.noSpecialistFound,
              style: AppFonts.appText.copyWith(fontSize: 14),
            ),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            itemCount: widget.specialist?.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              mainAxisSpacing: 10,
              crossAxisSpacing: 15,
              childAspectRatio: 0.5,
            ),
            itemBuilder: (context, index) {
              var specialist = widget.specialist?[index];

              return InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(35),
                      child: Image.network(
                        ApiService.imageUrl + (specialist?.image ?? ''),
                        height: 65,
                        width: 65,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      textAlign: TextAlign.center,
                      (specialist?.name ?? ''),
                      style: AppFonts.normalText.copyWith(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

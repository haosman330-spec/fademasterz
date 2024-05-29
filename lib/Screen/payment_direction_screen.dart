import 'package:fademasterz/Utils/app_color.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_svg/svg.dart';

import '../Utils/app_assets.dart';
import '../Utils/app_fonts.dart';
import '../Utils/app_string.dart';
import '../Utils/custom_app_bar.dart';
import '../Utils/custom_app_button.dart';
import 'Booking/cancelled_booking_details.dart';
import 'Dashboard/dashboard.dart';

class PaymentDirection extends StatefulWidget {
  final String? url;
  const PaymentDirection({super.key, this.url});

  @override
  State<PaymentDirection> createState() => PaymentDirectionState();
}

class PaymentDirectionState extends State<PaymentDirection> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.bg,
      appBar: MyAppBar.myAppbar(
        centerTile: true,
        title: Text(
          AppStrings.paymentDirection,
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
            Navigator.pop(context);
            setState(() {});
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            CreditCardWidget(
              cardNumber: '4444 4744 4477 4777',
              expiryDate: '01/30',
              cardHolderName: 'Adam Nils',
              cvvCode: '411',
              cardBgColor: AppColor.black,
              obscureCardNumber: false,
              obscureCardCvv: false, cardType: CardType.rupay,
              bankName: 'BoI',
              animationDuration: const Duration(seconds: 2),
              isHolderNameVisible: true, chipColor: AppColor.yellow,
              showBackView: true, //true when you want to show cvv(back) view
              onCreditCardWidgetChange: (CreditCardBrand
                  brand) {}, // Callback for anytime credit card brand is changed
            ),
            CreditCardForm(
              formKey: formKey, // Required
              cardHolderName: 'Adam Nils', // Required
              cardNumber: '4444 4744 4477 4777', // Required
              expiryDate: '01/2030', // Required
              cvvCode: '411',
              // Required
              // cardNumberKey: cardNumberKey,
              // cvvCodeKey: cvvCodeKey,
              // expiryDateKey: expiryDateKey,
              // cardHolderKey: cardHolderKey,
              onCreditCardModelChange: (CreditCardModel data) {}, // Required
              obscureCvv: false,
              obscureNumber: false,
              isHolderNameVisible: true,
              isCardNumberVisible: true,
              isExpiryDateVisible: true,
              enableCvv: true,
              cvvValidationMessage: 'Please input a valid CVV',
              dateValidationMessage: 'Please input a valid date',
              numberValidationMessage: 'Please input a valid number',
              cardHolderValidator: (String? cardHolderName) {
                return null;
              },
              cardNumberValidator: (String? cardNumber) {
                return null;
              },
              expiryDateValidator: (String? expiryDate) {
                return null;
              },
              cvvValidator: (String? cvv) {
                return null;
              },

              onFormComplete: () {
                // callback to execute at the end of filling card data
              },

              inputConfiguration: InputConfiguration(
                cardHolderDecoration: InputDecoration(
                  prefixIcon: Align(
                      widthFactor: 2,
                      heightFactor: 2,
                      child: SvgPicture.asset(AppIcon.parsonIcon)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  hintText: 'Card Holder Name',
                  hintStyle: AppFonts.textFieldHint,
                  filled: true,
                  fillColor: AppColor.black,
                ),
                cardNumberDecoration: InputDecoration(
                  prefixIcon: Align(
                      widthFactor: 2,
                      heightFactor: 2,
                      child: SvgPicture.asset(AppIcon.cardIcon)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  hintText: 'Card Number',
                  hintStyle: AppFonts.textFieldHint,
                  filled: true,
                  fillColor: AppColor.black,
                ),
                expiryDateDecoration: InputDecoration(
                  prefixIcon: Align(
                      widthFactor: 2,
                      heightFactor: 2,
                      child: SvgPicture.asset(
                        AppIcon.calenderIcon,
                        height: 20,
                        width: 20,
                        color: AppColor.gray,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  hintText: 'Month / Year',
                  hintStyle: AppFonts.textFieldHint,
                  filled: true,
                  fillColor: AppColor.black,
                ),
                cvvCodeDecoration: InputDecoration(
                  prefixIcon: Align(
                      widthFactor: 1,
                      heightFactor: 1,
                      child: SvgPicture.asset(
                        AppIcon.lockIcon,
                      )),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(
                      8,
                    ),
                  ),
                  hintText: 'Cvv',
                  hintStyle: AppFonts.textFieldHint,
                  filled: true,
                  fillColor: AppColor.black,
                ),
                cardNumberTextStyle: AppFonts.textFieldFont,
                cardHolderTextStyle: AppFonts.textFieldFont,
                expiryDateTextStyle: AppFonts.textFieldFont,
                cvvCodeTextStyle: AppFonts.textFieldFont,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: MyAppButton(
        title: AppStrings.payNow,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        onPress: () {
          showDialog(
            //   barrierDismissible: false,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 38, vertical: 16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcon.paymentIcon),
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 20),
                        child: Text(
                          textAlign: TextAlign.center,
                          AppStrings.paymentSuccessful,
                          style: AppFonts.blackFont.copyWith(
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          textAlign: TextAlign.center,
                          AppStrings.successfulDone,
                          style: AppFonts.blackFont.copyWith(
                              fontSize: 14, fontWeight: FontWeight.w500),
                        ),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      MyAppButton(
                        onPress: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const CancelledBookingDetail(),
                            ),
                          );
                        },
                        height: 48,
                        title: AppStrings.viewBookingSummary,
                        style: AppFonts.blackFont
                            .copyWith(fontWeight: FontWeight.w500),
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
                        style: AppFonts.blackFont
                            .copyWith(fontWeight: FontWeight.w500),
                        radius: 39,
                        color: const Color(0xffFFFBF0),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

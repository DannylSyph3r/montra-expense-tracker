import 'package:expense_tracker_app/features/onboarding/views/confirmation_view.dart';
import 'package:expense_tracker_app/features/onboarding/widgets/option_seletion_tile.dart';
import 'package:expense_tracker_app/shared/app_graphics.dart';
import 'package:expense_tracker_app/shared/app_texts.dart';
import 'package:expense_tracker_app/theme/palette.dart';
import 'package:expense_tracker_app/utils/app_constants.dart';
import 'package:expense_tracker_app/utils/app_extensions.dart';
import 'package:expense_tracker_app/utils/nav.dart';
import 'package:expense_tracker_app/utils/widgets/button.dart';
import 'package:expense_tracker_app/utils/widgets/custom_modal_bottomsheet.dart';
import 'package:expense_tracker_app/utils/widgets/row_railer.dart';
import 'package:expense_tracker_app/utils/widgets/serrated_painter.dart';
import 'package:expense_tracker_app/utils/widgets/text_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

class NewAccountView extends StatefulWidget {
  const NewAccountView({super.key});

  @override
  State<NewAccountView> createState() => _NewAccountViewState();
}

class _NewAccountViewState extends State<NewAccountView> {
  final TextEditingController _clusterNameController = TextEditingController();
  final TextEditingController _clusterStartingAmountController =
      TextEditingController();
  final TextEditingController _clusterTypeController = TextEditingController();

  final ValueNotifier<String> _balanceNotifier =
      ValueNotifier<String>("0.00");

  final List<Map<String, dynamic>> accountTypes = [
    {
      'icon': PhosphorIconsFill.bank,
      'label': 'Bank',
    },
    {
      'icon': PhosphorIconsFill.cardholder,
      'label': 'Card',
    },
    {
      'icon': PhosphorIconsFill.wallet,
      'label': 'Fintech Wallet',
    },
  ];

  @override
  void initState() {
    super.initState();
    _clusterStartingAmountController.addListener(_updateBalance);
  }

  @override
  void dispose() {
    _clusterNameController.dispose();
    _clusterStartingAmountController.dispose();
    _clusterTypeController.dispose();
    _balanceNotifier.dispose();
    super.dispose();
  }

  void _updateBalance() {
    final amountText = _clusterStartingAmountController.text;
    double amount = double.tryParse(amountText.replaceAll(',', '')) ?? 0.0;
    String formattedAmount =
        NumberFormat.currency(locale: 'en_US', symbol: '', decimalDigits: 2)
            .format(amount);
    _balanceNotifier.value = formattedAmount;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (Widget child, Animation<double> animation) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Palette.montraPurple,
        body: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  Positioned(
                    top: -5,
                    left: -5,
                    child: AppGraphics.eclipses.png.myImage(
                      height: 200.h,
                    ),
                  ),
                  Column(
                    children: [
                      50.sbH,
                      RowRailer(
                        rowPadding: 20.padH,
                        leading: const Icon(PhosphorIconsBold.arrowLeft,
                                color: Palette.whiteColor)
                            .tap(onTap: () {
                          goBack(context);
                        }),
                        middle: "Add New Account"
                            .txt16(color: Palette.whiteColor, fontW: F.w5),
                      ),
                      40.sbH,
                      Padding(
                        padding: 50.padH,
                        child: ValueListenableBuilder<String>(
                          valueListenable: _balanceNotifier,
                          builder: (context, balance, _) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  PhosphorIconsBold.currencyNgn,
                                  color: Palette.whiteColor,
                                  size: 30.sp,
                                ),
                                3.sbW,
                                Flexible(
                                  child: balance.txt(
                                    size: 30.sp,
                                    fontW: F.w8,
                                    color: Palette.whiteColor,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                      30.sbH
                    ],
                  ),
                  Column(
                    children: [
                      200.sbH,
                      CustomPaint(
                        size: Size(double.infinity, 60.h),
                        painter: SerratedPainter(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            border: Border.all(
                                color: Palette.whiteColor, width: 1)),
                        constraints: BoxConstraints(
                          minHeight: height(context) - 250.h,
                          minWidth: double.infinity,
                        ),
                        child: Padding(
                          padding: 20.padH,
                          child: Column(
                            children: [
                              20.sbH,

                              // Account Name Input
                              TextInputWidget(
                                maxLength: 50,
                                hintText: AppTexts.clusterNameFieldHint,
                                hintTextSize: 14.sp,
                                inputtedTextSize: 14.sp,
                                prefix: Padding(
                                  padding: 12.5.padA,
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    height: 26.h,
                                    width: 26.h,
                                    child: Center(
                                        child: Padding(
                                            padding: 4.0.padH,
                                            child: Icon(
                                              PhosphorIconsFill.tag,
                                              color: Palette.greyColor,
                                              size: 20.h,
                                            ))),
                                  ),
                                ),
                                controller: _clusterNameController,
                              ),
                              10.sbH,

                              // Starting Balance Input
                              TextInputWidget(
                                hintText: AppTexts.clusterStartingBalance,
                                controller: _clusterStartingAmountController,
                                keyboardType: TextInputType.number,
                                onChanged: (p0) {
                                  _updateBalance();
                                },
                                maxLength: 50,
                                hintTextSize: 14.sp,
                                inputtedTextSize: 14.sp,
                                prefix: Padding(
                                  padding: 12.5.padA,
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    height: 26.h,
                                    width: 26.h,
                                    child: Center(
                                        child: Padding(
                                            padding: 4.0.padH,
                                            child: Icon(
                                              PhosphorIconsBold.currencyNgn,
                                              color: Palette.greyColor,
                                              size: 20.h,
                                            ))),
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 12.5.w),
                                  child: const Icon(PhosphorIconsFill.xCircle,
                                          color: Palette.greyColor)
                                      .tap(onTap: () {
                                    _clusterStartingAmountController.clear();
                                    _updateBalance();
                                  }),
                                ),
                              ),
                              10.sbH,

                              // Account Type Selection
                              TextInputWidget(
                                onTap: () {
                                  showCustomModal(context,
                                      modalHeight: 230.h,
                                      child: ListView.builder(
                                        padding: 15.padH,
                                        shrinkWrap: true,
                                        itemCount: accountTypes.length,
                                        itemBuilder: (context, index) {
                                          return OptionSelectionListTile(
                                            leadingIcon: accountTypes[index]
                                                ['icon'] as IconData,
                                            interactiveTrailing: false,
                                            titleFontSize: 15.sp,
                                            titleLabel: accountTypes[index]
                                                ['label'] as String,
                                            onTileTap: () {
                                              _clusterTypeController.text =
                                                  accountTypes[index]['label']
                                                      as String;
                                              goBack(context);
                                            },
                                          );
                                        },
                                      ));
                                },
                                isTextFieldEnabled: false,
                                hintTextSize: 14.sp,
                                inputtedTextSize: 14.sp,
                                hintText: AppTexts.clusterAccountType,
                                controller: _clusterTypeController,
                                prefix: Padding(
                                  padding: 12.5.padA,
                                  child: Container(
                                    decoration: const BoxDecoration(),
                                    height: 26.h,
                                    width: 26.h,
                                    child: Center(
                                        child: Padding(
                                            padding: 4.0.padH,
                                            child: Icon(
                                              PhosphorIconsBold.list,
                                              color: Palette.greyColor,
                                              size: 20.h,
                                            ))),
                                  ),
                                ),
                                suffixIcon: Padding(
                                  padding: 15.padH,
                                  child: Icon(PhosphorIconsRegular.caretDown,
                                      size: 20.h, color: Palette.textFieldGrey),
                                ),
                              ),
                              30.sbH,

                              // Account Information Card
                              Container(
                                width: double.infinity,
                                padding: 15.0.padA,
                                decoration: BoxDecoration(
                                  color: Palette.montraPurple.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.r),
                                  border: Border.all(
                                      color: Palette.montraPurple
                                          .withOpacity(0.3)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          PhosphorIconsBold.info,
                                          color: Palette.montraPurple,
                                          size: 16.h,
                                        ),
                                        8.sbW,
                                        "Account Details".txt12(
                                          color: Palette.montraPurple,
                                          fontW: F.w6,
                                        ),
                                      ],
                                    ),
                                    8.sbH,
                                    "This account can be for your bank, credit card or your fintech wallet."
                                        .txt(
                                            size: 11.sp,
                                            color: Palette.greyColor),
                                    "You can create multiple accounts to track different financial sources."
                                        .txt(
                                            size: 11.sp,
                                            color: Palette.greyColor),
                                  ],
                                ),
                              ),
                              20.sbH,

                              // Create Account Button
                              ListenableBuilder(
                                listenable: Listenable.merge([
                                  _clusterNameController,
                                  _clusterStartingAmountController,
                                  _clusterTypeController,
                                ]),
                                builder: (context, child) {
                                  final isEnabled = _clusterNameController
                                          .text.isNotEmpty &&
                                      _clusterStartingAmountController
                                          .text.isNotEmpty &&
                                      _clusterTypeController.text.isNotEmpty;

                                  return AppButton(
                                    isEnabled: isEnabled,
                                    color: Palette.montraPurple,
                                    text: "Continue",
                                    onTap: () {
                                      goTo(
                                          context: context,
                                          view: const ClusterConfirmationView());
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                      Transform.scale(
                        scaleY: -1,
                        child: CustomPaint(
                          size: Size(double.infinity, 60.h),
                          painter: SerratedPainter(),
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
    );
  }
}
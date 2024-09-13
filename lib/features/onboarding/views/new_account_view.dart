import 'package:expense_tracker_app/features/home/widgets/curved_painter.dart';
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
          physics: const NeverScrollableScrollPhysics(),
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
                      80.sbH,
                      Padding(
                        padding: 50.padH,
                        child: ValueListenableBuilder<String>(
                          valueListenable: _balanceNotifier,
                          builder: (context, balance, _) {
                            return Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  PhosphorIconsBold.currencyNgn,
                                  color: Palette.whiteColor,
                                  size: 28.sp,
                                ),
                                3.sbW,
                                Expanded(
                                  child: balance
                                      .txt(
                                          size: 28.sp,
                                          fontW: F.w8,
                                          color: Palette.whiteColor,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis)
                                      .alignCenterLeft(),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      260.sbH,
                      CustomPaint(
                        size: Size(double.infinity, 50.h),
                        painter: CurvedPainter(),
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            border: Border.all(
                                color: Palette.whiteColor, width: 1)),
                        constraints: BoxConstraints(
                            minHeight: height(context) - 250.h,
                            minWidth: double.infinity),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 210,
                    left: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: 25.padH,
                        child: Container(
                          padding: 15.0.padA,
                          decoration: BoxDecoration(
                            color: Palette.whiteColor,
                            borderRadius: BorderRadius.circular(25.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                spreadRadius: 10,
                                blurRadius: 20,
                                offset: const Offset(5, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              30.sbH,
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
                                              color: Palette.montraPurple,
                                              size: 20.h,
                                            ))),
                                  ),
                                ),
                                controller: _clusterNameController,
                              ),
                              5.sbH,
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
                                              color: Palette.montraPurple,
                                              size: 20.h,
                                            ))),
                                  ),
                                ),
                              ),
                              5.sbH,
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
                                suffixIcon: Padding(
                                  padding: 15.padH,
                                  child: Icon(PhosphorIconsRegular.caretDown,
                                      size: 20.h, color: Palette.textFieldGrey),
                                ),
                              ),
                              30.sbH,
                              AppButton(
                                  isEnabled: _clusterNameController
                                          .text.isNotEmpty &&
                                      _clusterStartingAmountController
                                          .text.isNotEmpty &&
                                      _clusterTypeController.text.isNotEmpty,
                                  text: "Continue",
                                  onTap: () {
                                    goTo(
                                        context: context,
                                        view: const ClusterConfirmationView());
                                  })
                            ],
                          ),
                        ),
                      ),
                    ),
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
